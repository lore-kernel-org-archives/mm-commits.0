From: akpm@linux-foundation.org
Subject: + fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:38:03 -0700
Message-ID: <200704091938.l39Jc3pp021577@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57169 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbXDITiT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, khali@linux-fr.org


The patch titled
     fbdev: don't show logo if driver or fbcon are modular
has been added to the -mm tree.  Its filename is
     fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: don't show logo if driver or fbcon are modular
From: "Antonino A. Daplas" <adaplas@gmail.com>

It was always intended for the logo to be drawn only if both fbcon and the
driver that is mapped to it are both compiled statically.  Currently, if fbcon
is loaded prior to the driver, the logo is not shown.  Reverse the order, and
the code may attempt to draw the logo which is __initdata.  By accident, this
bug is rarely seen because this method of loading the modules is not common
and secondly, a code in fb_prepare_logo() that checks the height of the logo
(now a random value) rarely succeeds.

Fix by drawing the logo only if both fbcon and the driver are statically
compiled.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc:  Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   15 +++++++++++++++
 drivers/video/fbmem.c         |    6 ++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbdev-dont-show-logo-if-driver-or-fbcon-are-modular drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbdev-dont-show-logo-if-driver-or-fbcon-are-modular
+++ a/drivers/video/console/fbcon.c
@@ -107,7 +107,9 @@ static struct display fb_display[MAX_NR_
 
 static signed char con2fb_map[MAX_NR_CONSOLES];
 static signed char con2fb_map_boot[MAX_NR_CONSOLES];
+#ifndef MODULE
 static int logo_height;
+#endif
 static int logo_lines;
 /* logo_shown is an index to vc_cons when >= 0; otherwise follows FBCON_LOGO
    enums.  */
@@ -576,6 +578,13 @@ static int fbcon_takeover(int show_logo)
 	return err;
 }
 
+#ifdef MODULE
+static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
+			       int cols, int rows, int new_cols, int new_rows)
+{
+	logo_shown = FBCON_LOGO_DONTSHOW;
+}
+#else
 static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 			       int cols, int rows, int new_cols, int new_rows)
 {
@@ -584,6 +593,11 @@ static void fbcon_prepare_logo(struct vc
 	int cnt, erase = vc->vc_video_erase_char, step;
 	unsigned short *save = NULL, *r, *q;
 
+	if (info->flags & FBINFO_MODULE) {
+		logo_shown = FBCON_LOGO_DONTSHOW;
+		return;
+	}
+
 	/*
 	 * remove underline attribute from erase character
 	 * if black and white framebuffer.
@@ -655,6 +669,7 @@ static void fbcon_prepare_logo(struct vc
 		vc->vc_top = logo_lines;
 	}
 }
+#endif /* MODULE */
 
 #ifdef CONFIG_FB_TILEBLITTING
 static void set_blitting_type(struct vc_data *vc, struct fb_info *info)
diff -puN drivers/video/fbmem.c~fbdev-dont-show-logo-if-driver-or-fbcon-are-modular drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-dont-show-logo-if-driver-or-fbcon-are-modular
+++ a/drivers/video/fbmem.c
@@ -418,7 +418,8 @@ int fb_prepare_logo(struct fb_info *info
 
 	memset(&fb_logo, 0, sizeof(struct logo_data));
 
-	if (info->flags & FBINFO_MISC_TILEBLITTING)
+	if (info->flags & FBINFO_MISC_TILEBLITTING ||
+	    info->flags & FBINFO_MODULE)
 		return 0;
 
 	if (info->fix.visual == FB_VISUAL_DIRECTCOLOR) {
@@ -483,7 +484,8 @@ int fb_show_logo(struct fb_info *info, i
 	struct fb_image image;
 
 	/* Return if the frame buffer is not mapped or suspended */
-	if (fb_logo.logo == NULL || info->state != FBINFO_STATE_RUNNING)
+	if (fb_logo.logo == NULL || info->state != FBINFO_STATE_RUNNING ||
+	    info->flags & FBINFO_MODULE)
 		return 0;
 
 	image.depth = 8;
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
nvidiafb-fix-reversed-ddc-port.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-nvidiafb-enable-hardware-monitoring.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
nvidiafb-ensure-that-crtc-registers-are-accessible.patch
nvidiafb-access-crt-registers-safely.patch
