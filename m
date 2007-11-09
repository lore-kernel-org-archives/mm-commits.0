From: akpm@linux-foundation.org
Subject: + acpi4asus-add-support-for-f3sa.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:03:36 -0800
Message-ID: <200711090403.lA943bu8028460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758721AbXKIEEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:04:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kronos.it@gmail.com, corentincj@iksaif.net, lenb@kernel.org, sziwan@users.sourceforge.net


The patch titled
     acpi4asus: add support for F3Sa
has been added to the -mm tree.  Its filename is
     acpi4asus-add-support-for-f3sa.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi4asus: add support for F3Sa
From: Luca Tettamanti <kronos.it@gmail.com>

Add support for ASUS F3Sa notebook. Features:
- LCD on/off
- Brightness
- Wifi kill
- Bluetooth kill

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/asus_acpi.c |   55 ++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff -puN drivers/acpi/asus_acpi.c~acpi4asus-add-support-for-f3sa drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~acpi4asus-add-support-for-f3sa
+++ a/drivers/acpi/asus_acpi.c
@@ -142,6 +142,7 @@ struct asus_hotk {
 		xxN,		//M2400N, M3700N, M5200N, M6800N, S1300N, S5200N
 		A4S,            //Z81sp
 		//(Centrino)
+		F3Sa,
 		END_MODEL
 	} model;		//Models currently supported
 	u16 event_count[128];	//count for each event TODO make this better
@@ -405,7 +406,20 @@ static struct model_data model_conf[END_
 		.brightness_get    = "GPLV",
 		.mt_bt_switch      = "BLED",
 		.mt_wled           = "WLED"
-	}
+	},
+
+	{
+		.name		= "F3Sa",
+		.mt_bt_switch	= "BLED",
+		.mt_wled	= "WLED",
+		.mt_mled	= "MLED",
+		.brightness_get	= "GPLV",
+		.brightness_set	= "SPLV",
+		.mt_lcd_switch	= "\\_SB.PCI0.SBRG.EC0._Q10",
+		.lcd_status	= "\\_SB.PCI0.SBRG.EC0.RPIN",
+		.display_get	= "\\ADVG",
+		.display_set	= "SDSP",
+	},
 
 };
 
@@ -710,15 +724,8 @@ static int get_lcd_state(void)
 {
 	int lcd = 0;
 
-	if (hotk->model != L3H) {
-		/* We don't have to check anything if we are here */
-		if (!read_acpi_int(NULL, hotk->methods->lcd_status, &lcd))
-			printk(KERN_WARNING
-			       "Asus ACPI: Error reading LCD status\n");
-
-		if (hotk->model == L2D)
-			lcd = ~lcd;
-	} else {		/* L3H and the like have to be handled differently */
+	if (hotk->model == L3H) {
+		/* L3H and the like have to be handled differently */
 		acpi_status status = 0;
 		struct acpi_object_list input;
 		union acpi_object mt_params[2];
@@ -745,6 +752,32 @@ static int get_lcd_state(void)
 		if (out_obj.type == ACPI_TYPE_INTEGER)
 			/* That's what the AML code does */
 			lcd = out_obj.integer.value >> 8;
+	} else if (hotk->model == F3Sa) {
+		unsigned long tmp;
+		union acpi_object param;
+		struct acpi_object_list input;
+		acpi_status status;
+
+		/* Read pin 11 */
+		param.type = ACPI_TYPE_INTEGER;
+		param.integer.value = 0x11;
+		input.count = 1;
+		input.pointer = &param;
+
+		status = acpi_evaluate_integer(NULL, hotk->methods->lcd_status,
+						&input, &tmp);
+		if (status != AE_OK)
+			return -1;
+
+		lcd = tmp;
+	} else {
+		/* We don't have to check anything if we are here */
+		if (!read_acpi_int(NULL, hotk->methods->lcd_status, &lcd))
+			printk(KERN_WARNING
+			       "Asus ACPI: Error reading LCD status\n");
+
+		if (hotk->model == L2D)
+			lcd = ~lcd;
 	}
 
 	return (lcd & 1);
@@ -1134,6 +1167,8 @@ static int asus_model_match(char *model)
 		return W5A;
 	else if (strncmp(model, "A4S", 3) == 0)
 		return A4S;
+	else if (strncmp(model, "F3Sa", 4) == 0)
+		return F3Sa;
 	else
 		return END_MODEL;
 }
_

Patches currently in -mm which might be from kronos.it@gmail.com are

acpi4asus-add-support-for-f3sa.patch
git-kvm.patch
