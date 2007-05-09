From: akpm@linux-foundation.org
Subject: - fbdev-add-sparse-annotations-in-svgalibc.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:00 -0700
Message-ID: <200705090301.l49310dn010636@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032936AbXEIDBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: add sparse annotations in svgalib.c
has been removed from the -mm tree.  Its filename was
     fbdev-add-sparse-annotations-in-svgalibc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: add sparse annotations in svgalib.c
From: "Antonino A. Daplas" <adaplas@gmail.com>

Add sparse annotations and use fb_read/fb_write family to access the
framebuffer.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/svgalib.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN drivers/video/svgalib.c~fbdev-add-sparse-annotations-in-svgalibc drivers/video/svgalib.c
--- a/drivers/video/svgalib.c~fbdev-add-sparse-annotations-in-svgalibc
+++ a/drivers/video/svgalib.c
@@ -194,7 +194,7 @@ void svga_dump_var(struct fb_var_screeni
 void svga_settile(struct fb_info *info, struct fb_tilemap *map)
 {
 	const u8 *font = map->data;
-	u8* fb = (u8 *) info->screen_base;
+	u8 __iomem *fb = (u8 __iomem *)info->screen_base;
 	int i, c;
 
 	if ((map->width != 8) || (map->height != 16) ||
@@ -207,7 +207,8 @@ void svga_settile(struct fb_info *info, 
 	fb += 2;
 	for (c = 0; c < map->length; c++) {
 		for (i = 0; i < map->height; i++) {
-			fb[i * 4] = font[i];
+			fb_writeb(font[i], fb + i * 4);
+//			fb[i * 4] = font[i];
 		}
 		fb += 128;
 		font += map->height;
@@ -221,8 +222,8 @@ void svga_tilecopy(struct fb_info *info,
 	/*  colstride is halved in this function because u16 are used */
 	int colstride = 1 << (info->fix.type_aux & FB_AUX_TEXT_SVGA_MASK);
 	int rowstride = colstride * (info->var.xres_virtual / 8);
-	u16 *fb = (u16 *) info->screen_base;
-	u16 *src, *dst;
+	u16 __iomem *fb = (u16 __iomem *) info->screen_base;
+	u16 __iomem *src, *dst;
 
 	if ((area->sy > area->dy) ||
 	    ((area->sy == area->dy) && (area->sx > area->dx))) {
@@ -239,10 +240,11 @@ void svga_tilecopy(struct fb_info *info,
 	    }
 
 	for (dy = 0; dy < area->height; dy++) {
-		u16* src2 = src;
-		u16* dst2 = dst;
+		u16 __iomem *src2 = src;
+		u16 __iomem *dst2 = dst;
 		for (dx = 0; dx < area->width; dx++) {
-			*dst2 = *src2;
+			fb_writew(fb_readw(src2), dst2);
+//			*dst2 = *src2;
 			src2 += colstride;
 			dst2 += colstride;
 		}
@@ -258,14 +260,14 @@ void svga_tilefill(struct fb_info *info,
 	int colstride = 2 << (info->fix.type_aux & FB_AUX_TEXT_SVGA_MASK);
 	int rowstride = colstride * (info->var.xres_virtual / 8);
 	int attr = (0x0F & rect->bg) << 4 | (0x0F & rect->fg);
-	u8  *fb = (u8 *) info->screen_base;
+	u8 __iomem *fb = (u8 __iomem *)info->screen_base;
 	fb += rect->sx * colstride + rect->sy * rowstride;
 
 	for (dy = 0; dy < rect->height; dy++) {
-		u8* fb2 = fb;
+		u8 __iomem *fb2 = fb;
 		for (dx = 0; dx < rect->width; dx++) {
-			fb2[0] = rect->index;
-			fb2[1] = attr;
+			fb_writeb(rect->index, fb2);
+			fb_writeb(attr, fb2 + 1);
 			fb2 += colstride;
 		}
 		fb += rowstride;
@@ -279,15 +281,15 @@ void svga_tileblit(struct fb_info *info,
 	int colstride = 2 << (info->fix.type_aux & FB_AUX_TEXT_SVGA_MASK);
 	int rowstride = colstride * (info->var.xres_virtual / 8);
 	int attr = (0x0F & blit->bg) << 4 | (0x0F & blit->fg);
-	u8* fb = (u8 *) info->screen_base;
+	u8 __iomem *fb = (u8 __iomem *)info->screen_base;
 	fb += blit->sx * colstride + blit->sy * rowstride;
 
 	i=0;
 	for (dy=0; dy < blit->height; dy ++) {
-		u8* fb2 = fb;
+		u8 __iomem *fb2 = fb;
 		for (dx = 0; dx < blit->width; dx ++) {
-			fb2[0] = blit->indices[i];
-			fb2[1] = attr;
+			fb_writeb(blit->indices[i], fb2);
+			fb_writeb(attr, fb2 + 1);
 			fb2 += colstride;
 			i ++;
 			if (i == blit->length) return;
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
