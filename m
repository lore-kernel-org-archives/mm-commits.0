From: akpm@linux-foundation.org
Subject: - fbdev-correct-image-offsets-when-rotating-logo.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:52 -0700
Message-ID: <200705090259.l492xqc7010465@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032837AbXEIDAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: correct image offsets when rotating logo
has been removed from the -mm tree.  Its filename was
     fbdev-correct-image-offsets-when-rotating-logo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
