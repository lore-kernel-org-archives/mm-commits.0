From: akpm@linux-foundation.org
Subject: + fbdev-add-sparse-annotations-in-svgalibc.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:32:44 -0700
Message-ID: <200704260032.l3Q0WiDe016930@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423421AbXDZAcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: add sparse annotations in svgalib.c
has been added to the -mm tree.  Its filename is
     fbdev-add-sparse-annotations-in-svgalibc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
skeletonfb-various-corrections.patch
epson1355fbc-fix-error-handling-code.patch
nvidiafb-vga-state-save-and-restore.patch
savagefb-rework-i2c-bit-access.patch
savagefb-vga-state-save-and-restore.patch
fbdev-link-vgastateo-using-kconfig.patch
fbcon-delay-screen-update-when-setting-the-mode-of.patch
nvidiafb-fix-sparse-warning.patch
rivafb-fix-io-access.patch
fbdev-kill-sparse-warning-in-deferred-io.patch
fbdev-add-sparse-annotations-in-svgalibc.patch
arcfb-kill-sparse-warning.patch
s3fb-add-sparse-annotations.patch
hecubafb-kill-sparse-warnings.patch
i810fb-fix-incorrect-frequency-mask.patch
vt-add-documentation-for-new-boot-sysfs-options.patch
skeletonfb-documentation-error-fixes.patch
fbdev-add-drawing-functions-for-framebuffers-in-system.patch
arcfb-use-sys-instead-of-cfb-drawing-functions.patch
hecubafb-use-sys-instead-of-cfb-drawing-functions.patch
vfb-use-sys-instead-of-cfb-drawing-functions.patch
fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch
fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch
arcfb-us-fb_sys_read.patch
hecubafb-us-fb_sys_read.patch
vfb-us-fb_sys_read-and-fb_sys_write.patch
fbdev-consolidate-common-drawing-functions-into-a.patch
fbdev-advertise-limitation-of-drawing-engine.patch
fbcon-font-setting-should-check-limitation-of-driver.patch
vga16fb-restrict-to-blit-rectangles-with-widths-of.patch
s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch
fbdev-add-tile-operation-to-get-the-maximum-length.patch
s3fb-implement-fb_get_tilemax.patch
fbcon-check-if-the-character-count-can-be-handled.patch
fbdev-save-the-activate-field-before-calling-fb_check_var.patch
s3fb-driver-fixes.patch
vmlfb-framebuffer-driver-for-intel-vermilion-range.patch
nvidiafb-rivafb-switch-to-pci_get-refcounting.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
nvidiafb-prevent-triggering-of-softlockup.patch
