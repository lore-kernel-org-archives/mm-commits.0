From: akpm@linux-foundation.org
Subject: + acpica-80-column-adherence-no-functional-change.patch added to -mm tree
Date: Mon, 02 Feb 2009 15:59:34 -0800
Message-ID: <200902022359.n12NxYEY010073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417AbZBBX7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 18:59:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: myron.stowe@hp.com, lenb@kernel.org


The patch titled
     acpica: 80 column adherence (no functional change)
has been added to the -mm tree.  Its filename is
     acpica-80-column-adherence-no-functional-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpica: 80 column adherence (no functional change)
From: Myron Stowe <myron.stowe@hp.com>

Modify a file derived from ACPI CA and as such formatting may come
directly from the CA code or indirectly from some type of parsing of the
original CA code.  As such, non-functional formatting changes may be
counter productive.  If this is the case then feel free to ignore this
component of the patch series.

This modification may be used under either the GPL or the BSD-style
license used for Intel ACPI CA code.

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpica/tbutils.c |   36 ++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff -puN drivers/acpi/acpica/tbutils.c~acpica-80-column-adherence-no-functional-change drivers/acpi/acpica/tbutils.c
--- a/drivers/acpi/acpica/tbutils.c~acpica-80-column-adherence-no-functional-change
+++ a/drivers/acpi/acpica/tbutils.c
@@ -179,7 +179,10 @@ acpi_tb_print_table_header(acpi_physical
 
 	if (ACPI_COMPARE_NAME(header->signature, ACPI_SIG_FACS)) {
 
-		/* FACS only has signature and length fields of common table header */
+		/*
+		 * FACS only has signature and length fields of common table
+		 * header
+		 */
 
 		ACPI_INFO((AE_INFO, "%4.4s %08lX, %04X",
 			   header->signature, (unsigned long)address,
@@ -379,14 +382,18 @@ acpi_tb_get_root_table_entry(u8 *table_e
 	} else {
 		/*
 		 * 32-bit platform, XSDT: Truncate 64-bit to 32-bit and return
-		 * 64-bit platform, XSDT: Move (unaligned) 64-bit to local, return 64-bit
+		 * 64-bit platform, XSDT: Move (unaligned) 64-bit to local,
+		 * return 64-bit
 		 */
 		ACPI_MOVE_64_TO_64(&address64, table_entry);
 
 #if ACPI_MACHINE_WIDTH == 32
 		if (address64 > ACPI_UINT32_MAX) {
 
-			/* Will truncate 64-bit address to 32 bits, issue warning */
+			/*
+			 * Will truncate 64-bit address to 32 bits, issue
+			 * warning
+			 */
 
 			ACPI_WARNING((AE_INFO,
 				      "64-bit Physical Address in XSDT is too large (%8.8X%8.8X), truncating",
@@ -448,9 +455,9 @@ acpi_tb_parse_root_table(acpi_physical_a
 	if (rsdp->revision > 1 && rsdp->xsdt_physical_address
 			&& !acpi_rsdt_forced) {
 		/*
-		 * Root table is an XSDT (64-bit physical addresses). We must use the
-		 * XSDT if the revision is > 1 and the XSDT pointer is present, as per
-		 * the ACPI specification.
+		 * Root table is an XSDT (64-bit physical addresses). We must
+		 * use the XSDT if the revision is > 1 and the XSDT pointer
+		 * is present, as per * the ACPI specification.
 		 */
 		address = (acpi_physical_address) rsdp->xsdt_physical_address;
 		table_entry_size = sizeof(u64);
@@ -487,7 +494,7 @@ acpi_tb_parse_root_table(acpi_physical_a
 
 	acpi_tb_print_table_header(address, table);
 
-	/* Get the length of the full table, verify length and map entire table */
+	/* Get the length of the full table, verify len, and map entire table */
 
 	length = table->length;
 	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
@@ -518,8 +525,9 @@ acpi_tb_parse_root_table(acpi_physical_a
 		    sizeof(struct acpi_table_header)) / table_entry_size);
 
 	/*
-	 * First two entries in the table array are reserved for the DSDT and FACS,
-	 * which are not actually present in the RSDT/XSDT - they come from the FADT
+	 * First two entries in the table array are reserved for the DSDT and
+	 * FACS, * which are not actually present in the RSDT/XSDT - they come
+	 * from the FADT
 	 */
 	table_entry =
 	    ACPI_CAST_PTR(u8, table) + sizeof(struct acpi_table_header);
@@ -532,7 +540,10 @@ acpi_tb_parse_root_table(acpi_physical_a
 		if (acpi_gbl_root_table_list.count >=
 		    acpi_gbl_root_table_list.size) {
 
-			/* There is no more room in the root table array, attempt resize */
+			/*
+			 * There is no more room in the root table array,
+			 * attempt resize
+			 */
 
 			status = acpi_tb_resize_root_table_list();
 			if (ACPI_FAILURE(status)) {
@@ -545,7 +556,10 @@ acpi_tb_parse_root_table(acpi_physical_a
 			}
 		}
 
-		/* Get the table physical address (32-bit for RSDT, 64-bit for XSDT) */
+		/*
+		 * Get the table physical address (32-bit for RSDT,
+		 * 64-bit for XSDT)
+		 */
 
 		acpi_gbl_root_table_list.tables[acpi_gbl_root_table_list.count].
 		    address =
_

Patches currently in -mm which might be from myron.stowe@hp.com are

acpica-fix-table-entry-truncation-calculation.patch
acpica-80-column-adherence-no-functional-change.patch

