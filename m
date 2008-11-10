From: akpm@linux-foundation.org
Subject: - acpi-use-macro-to-replace-hard-number.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:54 -0800
Message-ID: <200811102033.mAAKXsxP024744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbYKJUg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:36:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: use macro to replace hard number
has been removed from the -mm tree.  Its filename was
     acpi-use-macro-to-replace-hard-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: use macro to replace hard number
From: Yinghai Lu <yinghai@kernel.org>

Impact: cleanup

Use MACRO for rev 3 fadt id instead of 3 directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/tables/tbfadt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/tables/tbfadt.c~acpi-use-macro-to-replace-hard-number drivers/acpi/tables/tbfadt.c
--- a/drivers/acpi/tables/tbfadt.c~acpi-use-macro-to-replace-hard-number
+++ a/drivers/acpi/tables/tbfadt.c
@@ -304,7 +304,7 @@ static void acpi_tb_convert_fadt(void)
 	 * The ACPI 1.0 reserved fields that will be zeroed are the bytes located at
 	 * offset 45, 55, 95, and the word located at offset 109, 110.
 	 */
-	if (acpi_gbl_FADT.header.revision < 3) {
+	if (acpi_gbl_FADT.header.revision < FADT2_REVISION_ID) {
 		acpi_gbl_FADT.preferred_profile = 0;
 		acpi_gbl_FADT.pstate_control = 0;
 		acpi_gbl_FADT.cst_control = 0;
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
mm-print-out-memmap-number-only-it-is-not-zero.patch

