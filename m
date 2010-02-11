From: akpm@linux-foundation.org
Subject: + viafb-make-some-variables-a-bit-less-global.patch added to -mm tree
Date: Thu, 11 Feb 2010 15:05:57 -0800
Message-ID: <201002112305.o1BN5veV001549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690Ab0BKXGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 18:06:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: make some variables a bit less global
has been added to the -mm tree.  Its filename is
     viafb-make-some-variables-a-bit-less-global.patch

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
Subject: viafb: make some variables a bit less global
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Move some variables closer to their usage.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/global.c   |    4 ----
 drivers/video/via/global.h   |    2 --
 drivers/video/via/hw.h       |    2 --
 drivers/video/via/viafbdev.c |    9 +++++++--
 drivers/video/via/viafbdev.h |    2 --
 5 files changed, 7 insertions(+), 12 deletions(-)

diff -puN drivers/video/via/global.c~viafb-make-some-variables-a-bit-less-global drivers/video/via/global.c
--- a/drivers/video/via/global.c~viafb-make-some-variables-a-bit-less-global
+++ a/drivers/video/via/global.c
@@ -29,8 +29,6 @@ int viafb_refresh = 60;
 int viafb_refresh1 = 60;
 int viafb_lcd_dsp_method = LCD_EXPANDSION;
 int viafb_lcd_mode = LCD_OPENLDI;
-int viafb_bpp = 32;
-int viafb_bpp1 = 32;
 int viafb_CRT_ON = 1;
 int viafb_DVI_ON;
 int viafb_LCD_ON ;
@@ -41,8 +39,6 @@ int viafb_hotplug_Xres = 640;
 int viafb_hotplug_Yres = 480;
 int viafb_hotplug_bpp = 32;
 int viafb_hotplug_refresh = 60;
-unsigned int viafb_second_offset;
-int viafb_second_size;
 int viafb_primary_dev = None_Device;
 unsigned int viafb_second_xres = 640;
 unsigned int viafb_second_yres = 480;
diff -puN drivers/video/via/global.h~viafb-make-some-variables-a-bit-less-global drivers/video/via/global.h
--- a/drivers/video/via/global.h~viafb-make-some-variables-a-bit-less-global
+++ a/drivers/video/via/global.h
@@ -67,8 +67,6 @@ extern int viafb_refresh;
 extern int viafb_refresh1;
 extern int viafb_lcd_dsp_method;
 extern int viafb_lcd_mode;
-extern int viafb_bpp;
-extern int viafb_bpp1;
 
 extern int viafb_CRT_ON;
 extern int viafb_hotplug_Xres;
diff -puN drivers/video/via/hw.h~viafb-make-some-variables-a-bit-less-global drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-make-some-variables-a-bit-less-global
+++ a/drivers/video/via/hw.h
@@ -863,8 +863,6 @@ struct pci_device_id_info {
 };
 
 extern unsigned int viafb_second_virtual_xres;
-extern unsigned int viafb_second_offset;
-extern int viafb_second_size;
 extern int viafb_SAMM_ON;
 extern int viafb_dual_fb;
 extern int viafb_LCD2_ON;
diff -puN drivers/video/via/viafbdev.c~viafb-make-some-variables-a-bit-less-global drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-make-some-variables-a-bit-less-global
+++ a/drivers/video/via/viafbdev.c
@@ -26,13 +26,17 @@
 
 #include "global.h"
 
-static struct fb_var_screeninfo default_var;
 static char *viafb_name = "Via";
 static u32 pseudo_pal[17];
 
 /* video mode */
 static char *viafb_mode;
 static char *viafb_mode1;
+static int viafb_bpp = 32;
+static int viafb_bpp1 = 32;
+
+static unsigned int viafb_second_offset;
+static int viafb_second_size;
 
 static int viafb_accel = 1;
 
@@ -1849,10 +1853,11 @@ static int __devinit via_pci_probe(struc
 {
 	u32 default_xres, default_yres;
 	struct VideoModeTable *vmode_entry;
+	struct fb_var_screeninfo default_var;
 	u32 viafb_par_length;
 
 	DEBUG_MSG(KERN_INFO "VIAFB PCI Probe!!\n");
-
+	memset(&default_var, 0, sizeof(default_var));
 	viafb_par_length = ALIGN(sizeof(struct viafb_par), BITS_PER_LONG/8);
 
 	/* Allocate fb_info and ***_par here, also including some other needed
diff -puN drivers/video/via/viafbdev.h~viafb-make-some-variables-a-bit-less-global drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-make-some-variables-a-bit-less-global
+++ a/drivers/video/via/viafbdev.h
@@ -83,8 +83,6 @@ struct viafb_par {
 
 extern unsigned int viafb_second_virtual_yres;
 extern unsigned int viafb_second_virtual_xres;
-extern unsigned int viafb_second_offset;
-extern int viafb_second_size;
 extern int viafb_SAMM_ON;
 extern int viafb_dual_fb;
 extern int viafb_LCD2_ON;
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

