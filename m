From: akpm@linux-foundation.org
Subject: - s3fb-add-sparse-annotations.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:04 -0700
Message-ID: <200705090301.l49314ch010645@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032929AbXEIDBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3fb: add sparse annotations
has been removed from the -mm tree.  Its filename was
     s3fb-add-sparse-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3fb: add sparse annotations
From: "Antonino A. Daplas" <adaplas@gmail.com>

Add sparse annotations and use fb_read/fb_write and family to access the
framebuffer.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/s3fb.c~s3fb-add-sparse-annotations drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-add-sparse-annotations
+++ a/drivers/video/s3fb.c
@@ -164,7 +164,7 @@ MODULE_PARM_DESC(fasttext, "Enable S3 fa
 static void s3fb_settile_fast(struct fb_info *info, struct fb_tilemap *map)
 {
 	const u8 *font = map->data;
-	u8* fb = (u8 *) info->screen_base;
+	u8 __iomem *fb = (u8 __iomem *) info->screen_base;
 	int i, c;
 
 	if ((map->width != 8) || (map->height != 16) ||
@@ -177,7 +177,7 @@ static void s3fb_settile_fast(struct fb_
 	fb += 2;
 	for (i = 0; i < map->height; i++) {
 		for (c = 0; c < map->length; c++) {
-			fb[c * 4] = font[c * map->height + i];
+			fb_writeb(font[c * map->height + i], fb + c * 4);
 		}
 		fb += 1024;
 	}
@@ -656,7 +656,7 @@ static int s3fb_set_par(struct fb_info *
 	value = ((value * hmul) / 8) - 5;
 	vga_wcrt(NULL, 0x3C, (value + 1) / 2);
 
-	memset((u8*)info->screen_base, 0x00, screen_size);
+	memset_io(info->screen_base, 0x00, screen_size);
 	/* Device and screen back on */
 	svga_wcrt_mask(0x17, 0x80, 0x80);
 	svga_wseq_mask(0x01, 0x00, 0x20);
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
