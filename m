From: akpm@linux-foundation.org
Subject: + fbdev-fb_do_show_logo-updates.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:55:51 -0800
Message-ID: <200703151855.l2FItr0O023527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36165 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbXCOS41 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, geoffrey.levand@am.sony.com, jsimmons@infradead.org


The patch titled
     fbdev: fb_do_show_logo() updates
has been added to the -mm tree.  Its filename is
     fbdev-fb_do_show_logo-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: fb_do_show_logo() updates
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

fb_do_show_logo() updates:
  - Use width and height of the passed image instead of the global variable
    fb_logo
  - Explicitly pass the number of logos to draw

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-By: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-fb_do_show_logo-updates drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-fb_do_show_logo-updates
+++ a/drivers/video/fbmem.c
@@ -376,37 +376,33 @@ static void fb_rotate_logo(struct fb_inf
 }
 
 static void fb_do_show_logo(struct fb_info *info, struct fb_image *image,
-			    int rotate)
+			    int rotate, unsigned int num)
 {
-	int x;
+	unsigned int x;
 
 	if (rotate == FB_ROTATE_UR) {
-		for (x = 0; x < num_online_cpus() &&
-			     x * (fb_logo.logo->width + 8) <=
-			     info->var.xres - fb_logo.logo->width; x++) {
+		for (x = 0;
+		     x < num && image->dx + image->width <= info->var.xres;
+		     x++) {
 			info->fbops->fb_imageblit(info, image);
-			image->dx += fb_logo.logo->width + 8;
+			image->dx += image->width + 8;
 		}
 	} else if (rotate == FB_ROTATE_UD) {
-		for (x = 0; x < num_online_cpus() &&
-			     x * (fb_logo.logo->width + 8) <=
-			     info->var.xres - fb_logo.logo->width; x++) {
+		for (x = 0; x < num && image->dx >= 0; x++) {
 			info->fbops->fb_imageblit(info, image);
-			image->dx -= fb_logo.logo->width + 8;
+			image->dx -= image->width + 8;
 		}
 	} else if (rotate == FB_ROTATE_CW) {
-		for (x = 0; x < num_online_cpus() &&
-			     x * (fb_logo.logo->width + 8) <=
-			     info->var.yres - fb_logo.logo->width; x++) {
+		for (x = 0;
+		     x < num && image->dy + image->height <= info->var.yres;
+		     x++) {
 			info->fbops->fb_imageblit(info, image);
-			image->dy += fb_logo.logo->width + 8;
+			image->dy += image->height + 8;
 		}
 	} else if (rotate == FB_ROTATE_CCW) {
-		for (x = 0; x < num_online_cpus() &&
-			     x * (fb_logo.logo->width + 8) <=
-			     info->var.yres - fb_logo.logo->width; x++) {
+		for (x = 0; x < num && image->dy >= 0; x++) {
 			info->fbops->fb_imageblit(info, image);
-			image->dy -= fb_logo.logo->width + 8;
+			image->dy -= image->height + 8;
 		}
 	}
 }
@@ -532,7 +528,7 @@ int fb_show_logo(struct fb_info *info, i
 			fb_rotate_logo(info, logo_rotate, &image, rotate);
 	}
 
-	fb_do_show_logo(info, &image, rotate);
+	fb_do_show_logo(info, &image, rotate, num_online_cpus());
 
 	kfree(palette);
 	if (saved_pseudo_palette != NULL)
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

bool-fbdevs-must-depend-on-fb-=-y.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
