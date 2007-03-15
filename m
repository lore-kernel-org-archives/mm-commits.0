From: akpm@linux-foundation.org
Subject: + fbdev-correct-image-offsets-when-rotating-logo.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:55:54 -0800
Message-ID: <200703151855.l2FItufj023530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36172 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbXCOS4e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     fbdev: correct image offsets when rotating logo
has been added to the -mm tree.  Its filename is
     fbdev-correct-image-offsets-when-rotating-logo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: correct image offsets when rotating logo
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Correct the image offsets when rotating the logo.  Before image->dx and
image->dy were always zero, so nobody ever noticed.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-By: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-correct-image-offsets-when-rotating-logo drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-correct-image-offsets-when-rotating-logo
+++ a/drivers/video/fbmem.c
@@ -354,22 +354,26 @@ static void fb_rotate_logo(struct fb_inf
 	if (rotate == FB_ROTATE_UD) {
 		fb_rotate_logo_ud(image->data, dst, image->width,
 				  image->height);
-		image->dx = info->var.xres - image->width;
-		image->dy = info->var.yres - image->height;
+		image->dx = info->var.xres - image->width - image->dx;
+		image->dy = info->var.yres - image->height - image->dy;
 	} else if (rotate == FB_ROTATE_CW) {
 		fb_rotate_logo_cw(image->data, dst, image->width,
 				  image->height);
 		tmp = image->width;
 		image->width = image->height;
 		image->height = tmp;
-		image->dx = info->var.xres - image->width;
+		tmp = image->dy;
+		image->dy = image->dx;
+		image->dx = info->var.xres - image->width - tmp;
 	} else if (rotate == FB_ROTATE_CCW) {
 		fb_rotate_logo_ccw(image->data, dst, image->width,
 				   image->height);
 		tmp = image->width;
 		image->width = image->height;
 		image->height = tmp;
-		image->dy = info->var.yres - image->height;
+		tmp = image->dx;
+		image->dx = image->dy;
+		image->dy = info->var.yres - image->height - tmp;
 	}
 
 	image->data = dst;
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
