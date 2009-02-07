From: akpm@linux-foundation.org
Subject: - acpica-fix-table-entry-truncation-calculation.patch removed from -mm tree
Date: Fri, 06 Feb 2009 22:09:07 -0800
Message-ID: <200902070609.n17697Xl023748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490AbZBGGJW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 7 Feb 2009 01:09:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: myron.stowe@hp.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpica: fix table entry truncation calculation
has been removed from the -mm tree.  Its filename was
     acpica-fix-table-entry-truncation-calculation.patch

This patch was dropped because

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpica: fix table entry truncation calculation
From: Myron Stowe <myron.stowe@hp.com>

During early boot, ACPI RSDT/XSDT table entries are gathered into the
'initial_tables[]' array.  This array is currently statically defined (see
./drivers/acpi/tables.c).  When there are more table entries than can be
held in the 'initial_tables[]' array, the message "Truncating N table
entries!" is output.  As currently implemented, this message will always
erroneously calculate N as 0.

This patch fixes the calculation that determines how many table entries
will be missing (truncated).

This modification may be used under either the GPL or the BSD-style
license used for Intel ACPI CA code.

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpica/tbutils.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/acpi/acpica/tbutils.c~acpica-fix-table-entry-truncation-calculation drivers/acpi/acpica/tbutils.c
--- a/drivers/acpi/acpica/tbutils.c~acpica-fix-table-entry-truncation-calculation
+++ a/drivers/acpi/acpica/tbutils.c
@@ -538,10 +538,9 @@ acpi_tb_parse_root_table(acpi_physical_a
 			if (ACPI_FAILURE(status)) {
 				ACPI_WARNING((AE_INFO,
 					      "Truncating %u table entries!",
-					      (unsigned)
-					      (acpi_gbl_root_table_list.size -
-					       acpi_gbl_root_table_list.
-					       count)));
+					      (unsigned) (table_count -
+					       (acpi_gbl_root_table_list.
+					       count - 2))));
 				break;
 			}
 		}
_

Patches currently in -mm which might be from myron.stowe@hp.com are

acpica-fix-table-entry-truncation-calculation.patch

