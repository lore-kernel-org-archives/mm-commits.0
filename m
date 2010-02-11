From: akpm@linux-foundation.org
Subject: + viafb-introduce-strict-parameter-checking.patch added to -mm tree
Date: Thu, 11 Feb 2010 15:05:49 -0800
Message-ID: <201002112305.o1BN5nFr001540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690Ab0BKXFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 18:05:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: introduce strict parameter checking
has been added to the -mm tree.  Its filename is
     viafb-introduce-strict-parameter-checking.patch

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
Subject: viafb: introduce strict parameter checking
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Refuse to work if wrong parameters are given.  This should improve the
user experience as it will be clear that something is wrong and not
silently ignored.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   67 ++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-introduce-strict-parameter-checking drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-introduce-strict-parameter-checking
+++ a/drivers/video/via/viafbdev.c
@@ -31,13 +31,13 @@ static char *viafb_name = "Via";
 static u32 pseudo_pal[17];
 
 /* video mode */
-static char *viafb_mode = "640x480";
-static char *viafb_mode1 = "640x480";
+static char *viafb_mode;
+static char *viafb_mode1;
 
 static int viafb_accel = 1;
 
 /* Added for specifying active devices.*/
-char *viafb_active_dev = "";
+char *viafb_active_dev;
 
 /*Added for specify lcd output port*/
 char *viafb_lcd_port = "";
@@ -1327,7 +1327,7 @@ static void retrieve_device_setting(stru
 	setting_info->lcd_attributes.lcd_mode = viafb_lcd_mode;
 }
 
-static void parse_active_dev(void)
+static int parse_active_dev(void)
 {
 	viafb_CRT_ON = STATE_OFF;
 	viafb_DVI_ON = STATE_OFF;
@@ -1338,60 +1338,63 @@ static void parse_active_dev(void)
 	   IGA path to devices in SAMM case. */
 	/*    Note: The previous of active_dev is primary device,
 	   and the following is secondary device. */
-	if (!strncmp(viafb_active_dev, "CRT+DVI", 7)) {
+	if (!viafb_active_dev) {
+		viafb_CRT_ON = STATE_ON;
+		viafb_SAMM_ON = STATE_OFF;
+	} else if (!strcmp(viafb_active_dev, "CRT+DVI")) {
 		/* CRT+DVI */
 		viafb_CRT_ON = STATE_ON;
 		viafb_DVI_ON = STATE_ON;
 		viafb_primary_dev = CRT_Device;
-	} else if (!strncmp(viafb_active_dev, "DVI+CRT", 7)) {
+	} else if (!strcmp(viafb_active_dev, "DVI+CRT")) {
 		/* DVI+CRT */
 		viafb_CRT_ON = STATE_ON;
 		viafb_DVI_ON = STATE_ON;
 		viafb_primary_dev = DVI_Device;
-	} else if (!strncmp(viafb_active_dev, "CRT+LCD", 7)) {
+	} else if (!strcmp(viafb_active_dev, "CRT+LCD")) {
 		/* CRT+LCD */
 		viafb_CRT_ON = STATE_ON;
 		viafb_LCD_ON = STATE_ON;
 		viafb_primary_dev = CRT_Device;
-	} else if (!strncmp(viafb_active_dev, "LCD+CRT", 7)) {
+	} else if (!strcmp(viafb_active_dev, "LCD+CRT")) {
 		/* LCD+CRT */
 		viafb_CRT_ON = STATE_ON;
 		viafb_LCD_ON = STATE_ON;
 		viafb_primary_dev = LCD_Device;
-	} else if (!strncmp(viafb_active_dev, "DVI+LCD", 7)) {
+	} else if (!strcmp(viafb_active_dev, "DVI+LCD")) {
 		/* DVI+LCD */
 		viafb_DVI_ON = STATE_ON;
 		viafb_LCD_ON = STATE_ON;
 		viafb_primary_dev = DVI_Device;
-	} else if (!strncmp(viafb_active_dev, "LCD+DVI", 7)) {
+	} else if (!strcmp(viafb_active_dev, "LCD+DVI")) {
 		/* LCD+DVI */
 		viafb_DVI_ON = STATE_ON;
 		viafb_LCD_ON = STATE_ON;
 		viafb_primary_dev = LCD_Device;
-	} else if (!strncmp(viafb_active_dev, "LCD+LCD2", 8)) {
+	} else if (!strcmp(viafb_active_dev, "LCD+LCD2")) {
 		viafb_LCD_ON = STATE_ON;
 		viafb_LCD2_ON = STATE_ON;
 		viafb_primary_dev = LCD_Device;
-	} else if (!strncmp(viafb_active_dev, "LCD2+LCD", 8)) {
+	} else if (!strcmp(viafb_active_dev, "LCD2+LCD")) {
 		viafb_LCD_ON = STATE_ON;
 		viafb_LCD2_ON = STATE_ON;
 		viafb_primary_dev = LCD2_Device;
-	} else if (!strncmp(viafb_active_dev, "CRT", 3)) {
+	} else if (!strcmp(viafb_active_dev, "CRT")) {
 		/* CRT only */
 		viafb_CRT_ON = STATE_ON;
 		viafb_SAMM_ON = STATE_OFF;
-	} else if (!strncmp(viafb_active_dev, "DVI", 3)) {
+	} else if (!strcmp(viafb_active_dev, "DVI")) {
 		/* DVI only */
 		viafb_DVI_ON = STATE_ON;
 		viafb_SAMM_ON = STATE_OFF;
-	} else if (!strncmp(viafb_active_dev, "LCD", 3)) {
+	} else if (!strcmp(viafb_active_dev, "LCD")) {
 		/* LCD only */
 		viafb_LCD_ON = STATE_ON;
 		viafb_SAMM_ON = STATE_OFF;
-	} else {
-		viafb_CRT_ON = STATE_ON;
-		viafb_SAMM_ON = STATE_OFF;
-	}
+	} else
+		return -EINVAL;
+
+	return 0;
 }
 
 static int parse_port(char *opt_str, int *output_interface)
@@ -1820,24 +1823,25 @@ static void viafb_remove_proc(struct pro
 	remove_proc_entry("viafb", NULL);
 }
 
-static void parse_mode(const char *str, u32 *xres, u32 *yres)
+static int parse_mode(const char *str, u32 *xres, u32 *yres)
 {
 	char *ptr;
 
+	if (!str) {
+		*xres = 640;
+		*yres = 480;
+		return 0;
+	}
+
 	*xres = simple_strtoul(str, &ptr, 10);
 	if (ptr[0] != 'x')
-		goto out_default;
+		return -EINVAL;
 
 	*yres = simple_strtoul(&ptr[1], &ptr, 10);
 	if (ptr[0])
-		goto out_default;
-
-	return;
+		return -EINVAL;
 
-out_default:
-	printk(KERN_WARNING "viafb received invalid mode string: %s\n", str);
-	*xres = 640;
-	*yres = 480;
+	return 0;
 }
 
 static int __devinit via_pci_probe(struct pci_dev *pdev,
@@ -1874,7 +1878,6 @@ static int __devinit via_pci_probe(struc
 
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
-	parse_active_dev();
 	parse_lcd_port();
 	parse_dvi_port();
 
@@ -2192,12 +2195,18 @@ static struct pci_driver viafb_driver = 
 
 static int __init viafb_init(void)
 {
+	u32 dummy;
 #ifndef MODULE
 	char *option = NULL;
 	if (fb_get_options("viafb", &option))
 		return -ENODEV;
 	viafb_setup(option);
 #endif
+	if (parse_mode(viafb_mode, &dummy, &dummy)
+		|| parse_mode(viafb_mode1, &dummy, &dummy)
+		|| parse_active_dev())
+		return -EINVAL;
+
 	printk(KERN_INFO
        "VIA Graphics Intergration Chipset framebuffer %d.%d initializing\n",
 	       VERSION_MAJOR, VERSION_MINOR);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-deprecate-private-ioctls.patch
viafb-remove-dead-code.patch
viafb-split-global-index-up.patch
viafb-split-global-index-up-fix.patch
viafb-remove-the-remaining-via_res_-uses.patch
viafb-some-dvi-cleanup.patch
viafb-yet-another-dead-code-removal.patch
viafb-reorder-initialization-for-dual-framebuffer-mode.patch
viafb-video-address-setting-revisited.patch
viafb-make-viafb_set_par-more-dual-framebuffer-compatible.patch
viafb-introduce-strict-parameter-checking.patch
viafb-split-color-mode-setting-up.patch
viafb-remove-dead-code-due-to-iga1_iga2.patch
viafb-make-some-variables-a-bit-less-global.patch
drivers-video-via-fix-continuation-line-formats.patch

