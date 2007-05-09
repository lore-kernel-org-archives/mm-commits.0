From: akpm@linux-foundation.org
Subject: - fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:19 -0700
Message-ID: <200705090300.l4930JaO010546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032685AbXEIDAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: don't show logo if driver or fbcon are modular
has been removed from the -mm tree.  Its filename was
     fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
