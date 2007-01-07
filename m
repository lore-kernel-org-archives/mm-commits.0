From: akpm@osdl.org
Subject: - fix-the-toshiba_acpi-write_lcd-return-value.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:39 -0800
Message-ID: <200701070800.l0780dgC013209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbXAGIBH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:01:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thotter@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix the toshiba_acpi write_lcd return value
has been removed from the -mm tree.  Its filename was
     fix-the-toshiba_acpi-write_lcd-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 6 insertions(+), 3 deletions(-)

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

git-acpi.patch
