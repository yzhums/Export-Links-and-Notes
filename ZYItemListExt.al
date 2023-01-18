pageextension 50101 ZYItemListExt extends "Item List"
{
    actions
    {
        addfirst(processing)
        {
            action(ExportLinksToExcel)
            {
                Caption = 'Export Links to Excel';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;
                trigger OnAction()
                begin
                    ExportLinksToExcel(Rec);
                end;
            }
            action(ExportNotesToExcel)
            {
                Caption = 'Export Notes to Excel';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;
                trigger OnAction()
                begin
                    ExportNotesToExcel(Rec);
                end;
            }
        }
    }
    local procedure ExportLinksToExcel(var Item: Record Item)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        LinksLbl: Label 'Links';
        ExcelFileName: Label 'Links_%1_%2';
        RecordLink: Record "Record Link";
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Item.FieldCaption("No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RecordLink.FieldCaption(URL1), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RecordLink.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RecordLink.FieldCaption(Created), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RecordLink.FieldCaption("User ID"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        if Item.FindSet() then
            repeat
                RecordLink.Reset();
                RecordLink.SetRange("Record ID", Item.RecordId);
                RecordLink.SetRange(Type, RecordLink.Type::Link);
                if RecordLink.FindSet() then
                    repeat
                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Item.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(RecordLink.URL1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(RecordLink.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(RecordLink.Created, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(RecordLink."User ID", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    until RecordLink.Next() = 0;
            until Item.Next() = 0;
        TempExcelBuffer.CreateNewBook(LinksLbl);
        TempExcelBuffer.WriteSheet(LinksLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;

    local procedure ExportNotesToExcel(var Item: Record Item)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NotesLbl: Label 'Notes';
        ExcelFileName: Label 'Notes_%1_%2';
        RecordLink: Record "Record Link";
        RecordLinkMgt: Codeunit "Record Link Management";
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Item.FieldCaption("No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RecordLink.FieldCaption(Note), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RecordLink.FieldCaption(Created), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(RecordLink.FieldCaption("User ID"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        if Item.FindSet() then
            repeat
                RecordLink.Reset();
                RecordLink.SetRange("Record ID", Item.RecordId);
                RecordLink.SetRange(Type, RecordLink.Type::Note);
                if RecordLink.FindSet() then
                    repeat
                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Item.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        RecordLink.CalcFields(Note);
                        TempExcelBuffer.AddColumn(RecordLinkMgt.ReadNote(RecordLink), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(RecordLink.Created, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(RecordLink."User ID", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    until RecordLink.Next() = 0;
            until Item.Next() = 0;
        TempExcelBuffer.CreateNewBook(NotesLbl);
        TempExcelBuffer.WriteSheet(NotesLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;
}
