From: akpm@osdl.org
Subject: + fix-the-toshiba_acpi-write_lcd-return-value.patch added to -mm tree
Date: Thu, 04 Jan 2007 15:03:59 -0800
Message-ID: <200701042304.l04N3xmf001923@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:34363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030259AbXADXEl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:04:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thotter@gmail.com, lenb@kernel.org


The patch titled
     fix the toshiba_acpi write_lcd return value
has been added to the -mm tree.  Its filename is
     fix-the-toshiba_acpi-write_lcd-return-value.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix the toshiba_acpi write_lcd return value
From: Matthijs van Otterdijk <thotter@gmail.com>

write_lcd() in toshiba_acpi returns 0 on success since the big ACPI patch
merged in 2.6.20-rc2.  It should return count.

Signed-off-by: Matthijs van Otterdijk <thotter@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/toshiba_acpi.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/toshiba_acpi.c~fix-the-toshiba_acpi-write_lcd-return-value drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~fix-the-toshiba_acpi-write_lcd-return-value
+++ a/drivers/acpi/toshiba_acpi.c
@@ -321,13 +321,16 @@ static int set_lcd_status(struct backlig
 static unsigned long write_lcd(const char *buffer, unsigned long count)
 {
 	int value;
-	int ret = count;
+	int ret;
 
 	if (sscanf(buffer, " brightness : %i", &value) == 1 &&
-	    value >= 0 && value < HCI_LCD_BRIGHTNESS_LEVELS)
+	    value >= 0 && value < HCI_LCD_BRIGHTNESS_LEVELS) {
 		ret = set_lcd(value);
-	else
+		if (ret == 0)
+			ret = count;
+	} else {
 		ret = -EINVAL;
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from thotter@gmail.com are

fix-the-toshiba_acpi-write_lcd-return-value.patch
