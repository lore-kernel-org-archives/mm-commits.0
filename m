From: akpm@osdl.org
Subject: + git-acpi-correct-id-for-fixed-buttons.patch added to -mm tree
Date: Wed, 31 Jan 2007 16:00:20 -0800
Message-ID: <200702010000.l1100KUW030625@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59866 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933367AbXBAABk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 19:01:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexey.y.starikovskiy@linux.intel.com, lenb@kernel.org


The patch titled
     git-acpi: correct id for fixed buttons
has been added to the -mm tree.  Its filename is
     git-acpi-correct-id-for-fixed-buttons.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-acpi: correct id for fixed buttons
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>

ACPI_BUTTON_HID_POWERF was changed, but this change was not propogated to
button.c, thus breaking detection of fixed power and sleep buttons.

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/button.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/button.c~git-acpi-correct-id-for-fixed-buttons drivers/acpi/button.c
--- a/drivers/acpi/button.c~git-acpi-correct-id-for-fixed-buttons
+++ a/drivers/acpi/button.c
@@ -75,7 +75,7 @@ static int acpi_button_state_open_fs(str
 static struct acpi_driver acpi_button_driver = {
 	.name = ACPI_BUTTON_DRIVER_NAME,
 	.class = ACPI_BUTTON_CLASS,
-	.ids = "ACPI_FPB,ACPI_FSB,PNP0C0D,PNP0C0C,PNP0C0E",
+	.ids = "button_power,button_sleep,PNP0C0D,PNP0C0C,PNP0C0E",
 	.ops = {
 		.add = acpi_button_add,
 		.remove = acpi_button_remove,
_

Patches currently in -mm which might be from alexey.y.starikovskiy@linux.intel.com are

git-acpi.patch
git-acpi-correct-id-for-fixed-buttons.patch
swsusp-change-code-order-in-diskc-fix.patch
