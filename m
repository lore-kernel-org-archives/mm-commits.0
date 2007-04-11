From: akpm@linux-foundation.org
Subject: + acpi-asus_acpi-support-f2je-model.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:21:06 -0700
Message-ID: <200704112021.l3BKLPxD013480@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965309AbXDKUWh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, lenb@kernel.org


The patch titled
     ACPI: asus_acpi, support F2JE model
has been added to the -mm tree.  Its filename is
     acpi-asus_acpi-support-f2je-model.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: asus_acpi, support F2JE model
From: Jiri Slaby <jirislaby@gmail.com>

Also augment the driver to support switching LCD status even if no function
for getting lcd status exists in DSDT.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/asus_acpi.c |   37 +++++++++++++++++++++++++++++++------
 1 files changed, 31 insertions(+), 6 deletions(-)

diff -puN drivers/acpi/asus_acpi.c~acpi-asus_acpi-support-f2je-model drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~acpi-asus_acpi-support-f2je-model
+++ a/drivers/acpi/asus_acpi.c
@@ -123,6 +123,7 @@ struct asus_hotk {
 		A2x,		//A2500H
 		A4G,		//A4700G
 		D1x,		//D1
+		F2x,		//F2JE
 		L2D,		//L2000D
 		L3C,		//L3800C
 		L3D,		//L3400D
@@ -150,6 +151,7 @@ struct asus_hotk {
 
 /* Here we go */
 #define A1x_PREFIX "\\_SB.PCI0.ISA.EC0."
+#define F2x_PREFIX "\\_SB.PCI0.SBRG.EC0."
 #define L3C_PREFIX "\\_SB.PCI0.PX40.ECD0."
 #define M1A_PREFIX "\\_SB.PCI0.PX40.EC0."
 #define P30_PREFIX "\\_SB.PCI0.LPCB.EC0."
@@ -206,6 +208,16 @@ static struct model_data model_conf[END_
 	 .display_get = "\\INFB"},
 
 	{
+	 .name = "F2x",
+	 .mt_wled = "WLED",
+	 .mt_bt_switch = "BLED",
+	 .mt_lcd_switch = F2x_PREFIX "_Q10",
+	 .brightness_set = "SPLV",
+	 .brightness_get = "GPLV",
+	 .display_set = "SDSP",
+	 .display_get = "\\ADVG"},
+
+	{
 	 .name = "L2D",
 	 .mt_mled = "MLED",
 	 .mled_status = "\\SGP6",
@@ -706,6 +718,8 @@ static int get_lcd_state(void)
 {
 	int lcd = 0;
 
+	BUG_ON(!hotk->methods->lcd_status);
+
 	if (hotk->model != L3H) {
 		/* We don't have to check anything if we are here */
 		if (!read_acpi_int(NULL, hotk->methods->lcd_status, &lcd))
@@ -748,11 +762,17 @@ static int get_lcd_state(void)
 
 static int set_lcd_state(int value)
 {
-	int lcd = 0;
 	acpi_status status = 0;
 
-	lcd = value ? 1 : 0;
-	if (lcd != get_lcd_state()) {
+	if (!value && !hotk->methods->lcd_status) {
+		printk(KERN_ERR "Asus ACPI: You must pass nonzero value to "
+				"switch LCD status for this model\n");
+		return -EINVAL;
+	}
+
+	/* pay attention to lazy evaluation, we don't want to reach
+	   get_lcd_state if lcd_status is empty string */
+	if (!hotk->methods->lcd_status || !!value != get_lcd_state()) {
 		/* switch */
 		if (hotk->model != L3H) {
 			status =
@@ -778,7 +798,10 @@ static int
 proc_read_lcd(char *page, char **start, off_t off, int count, int *eof,
 	      void *data)
 {
-	return sprintf(page, "%d\n", get_lcd_state());
+	return hotk->methods->lcd_status ?
+		sprintf(page, "%d\n", get_lcd_state()) :
+		sprintf(page, "n/a (but 1 may be written to switch LCD "
+				"state)\n");
 }
 
 static int
@@ -1007,7 +1030,7 @@ static int asus_hotk_add_fs(struct acpi_
 	 * We need both read node and write method as LCD switch is also accessible
 	 * from keyboard 
 	 */
-	if (hotk->methods->mt_lcd_switch && hotk->methods->lcd_status) {
+	if (hotk->methods->mt_lcd_switch) {
 		asus_proc_add(PROC_LCD, &proc_write_lcd, &proc_read_lcd, mode,
 			      device);
 	}
@@ -1040,7 +1063,7 @@ static int asus_hotk_remove_fs(struct ac
 			remove_proc_entry(PROC_LEDD, acpi_device_dir(device));
 		if (hotk->methods->mt_bt_switch)
 			remove_proc_entry(PROC_BT, acpi_device_dir(device));
-		if (hotk->methods->mt_lcd_switch && hotk->methods->lcd_status)
+		if (hotk->methods->mt_lcd_switch)
 			remove_proc_entry(PROC_LCD, acpi_device_dir(device));
 		if ((hotk->methods->brightness_up
 		     && hotk->methods->brightness_down)
@@ -1091,6 +1114,8 @@ static int asus_model_match(char *model)
 		return L8L;
 	else if (strncmp(model, "L4R", 3) == 0)
 		return L4R;
+	else if (strncmp(model, "F2JE", 4) == 0)
+		return F2x;
 	else if (strncmp(model, "M6N", 3) == 0 || strncmp(model, "W3N", 3) == 0)
 		return M6N;
 	else if (strncmp(model, "M6R", 3) == 0 || strncmp(model, "A3G", 3) == 0)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

acpi-asus_acpi-support-f2je-model.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
shrink_slab-handle-bad-shrinkers.patch
