From: akpm@linux-foundation.org
Subject: - tgafb-accelerated-code.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:42 -0700
Message-ID: <200705090259.l492xgkN010439@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032754AbXEIC74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsimmons@infradead.org, adaplas@pol.net, macro@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     tgafb accelerated code
has been removed from the -mm tree.  Its filename was
     tgafb-accelerated-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tgafb accelerated code
From: James Simmons <jsimmons@infradead.org>

Add accelerated panning and accelerated color and mono image drawing. 
Please apply.

Signed-off-by: James Simmons <jsimmons@infradead.org>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>  (tested, too!)
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |  157 ++++++++++++++++++++++++++++------------
 1 file changed, 113 insertions(+), 44 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-accelerated-code drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-accelerated-code
+++ a/drivers/video/tgafb.c
@@ -59,6 +59,7 @@ static void tgafb_init_fix(struct fb_inf
 static void tgafb_imageblit(struct fb_info *, const struct fb_image *);
 static void tgafb_fillrect(struct fb_info *, const struct fb_fillrect *);
 static void tgafb_copyarea(struct fb_info *, const struct fb_copyarea *);
+static int tgafb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info);
 
 static int __devinit tgafb_register(struct device *dev);
 static void __devexit tgafb_unregister(struct device *dev);
@@ -81,6 +82,7 @@ static struct fb_ops tgafb_ops = {
 	.fb_set_par		= tgafb_set_par,
 	.fb_setcolreg		= tgafb_setcolreg,
 	.fb_blank		= tgafb_blank,
+	.fb_pan_display		= tgafb_pan_display,
 	.fb_fillrect		= tgafb_fillrect,
 	.fb_copyarea		= tgafb_copyarea,
 	.fb_imageblit		= tgafb_imageblit,
@@ -319,21 +321,7 @@ tgafb_set_par(struct fb_info *info)
 		BT485_WRITE(par, 0x00, BT485_ADDR_PAL_WRITE);
 		TGA_WRITE_REG(par, BT485_DATA_PAL, TGA_RAMDAC_SETUP_REG);
 
-#ifdef CONFIG_HW_CONSOLE
-		for (i = 0; i < 16; i++) {
-			int j = color_table[i];
-
-			TGA_WRITE_REG(par, default_red[j]|(BT485_DATA_PAL<<8),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, default_grn[j]|(BT485_DATA_PAL<<8),
-				      TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, default_blu[j]|(BT485_DATA_PAL<<8),
-				      TGA_RAMDAC_REG);
-		}
-		for (i = 0; i < 240 * 3; i += 4) {
-#else
 		for (i = 0; i < 256 * 3; i += 4) {
-#endif
 			TGA_WRITE_REG(par, 0x55 | (BT485_DATA_PAL << 8),
 				      TGA_RAMDAC_REG);
 			TGA_WRITE_REG(par, 0x00 | (BT485_DATA_PAL << 8),
@@ -358,18 +346,7 @@ tgafb_set_par(struct fb_info *info)
 		BT459_LOAD_ADDR(par, 0x0000);
 		TGA_WRITE_REG(par, BT459_PALETTE << 2, TGA_RAMDAC_SETUP_REG);
 
-#ifdef CONFIG_HW_CONSOLE
-		for (i = 0; i < 16; i++) {
-			int j = color_table[i];
-
-			TGA_WRITE_REG(par, default_red[j], TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, default_grn[j], TGA_RAMDAC_REG);
-			TGA_WRITE_REG(par, default_blu[j], TGA_RAMDAC_REG);
-		}
-		for (i = 0; i < 240 * 3; i += 4) {
-#else
 		for (i = 0; i < 256 * 3; i += 4) {
-#endif
 			TGA_WRITE_REG(par, 0x55, TGA_RAMDAC_REG);
 			TGA_WRITE_REG(par, 0x00, TGA_RAMDAC_REG);
 			TGA_WRITE_REG(par, 0x00, TGA_RAMDAC_REG);
@@ -646,16 +623,8 @@ tgafb_blank(int blank, struct fb_info *i
  *  Acceleration.
  */
 
-/**
- *      tgafb_imageblit - REQUIRED function. Can use generic routines if
- *                        non acclerated hardware and packed pixel based.
- *                        Copies a image from system memory to the screen. 
- *
- *      @info: frame buffer structure that represents a single frame buffer
- *      @image: structure defining the image.
- */
 static void
-tgafb_imageblit(struct fb_info *info, const struct fb_image *image)
+tgafb_mono_imageblit(struct fb_info *info, const struct fb_image *image)
 {
 	struct tga_par *par = (struct tga_par *) info->par;
 	u32 fgcolor, bgcolor, dx, dy, width, height, vxres, vyres, pixelmask;
@@ -665,6 +634,17 @@ tgafb_imageblit(struct fb_info *info, co
 	void __iomem *regs_base;
 	void __iomem *fb_base;
 
+	is8bpp = info->var.bits_per_pixel == 8;
+
+	/* For copies that aren't pixel expansion, there's little we
+	   can do better than the generic code.  */
+	/* ??? There is a DMA write mode; I wonder if that could be
+	   made to pull the data from the image buffer...  */
+	if (image->depth > 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
+
 	dx = image->dx;
 	dy = image->dy;
 	width = image->width;
@@ -682,18 +662,8 @@ tgafb_imageblit(struct fb_info *info, co
 	if (dy + height > vyres)
 		height = vyres - dy;
 
-	/* For copies that aren't pixel expansion, there's little we
-	   can do better than the generic code.  */
-	/* ??? There is a DMA write mode; I wonder if that could be
-	   made to pull the data from the image buffer...  */
-	if (image->depth > 1) {
-		cfb_imageblit(info, image);
-		return;
-	}
-
 	regs_base = par->tga_regs_base;
 	fb_base = par->tga_fb_base;
-	is8bpp = info->var.bits_per_pixel == 8;
 
 	/* Expand the color values to fill 32-bits.  */
 	/* ??? Would be nice to notice colour changes elsewhere, so
@@ -871,6 +841,85 @@ tgafb_imageblit(struct fb_info *info, co
 		     regs_base + TGA_MODE_REG);
 }
 
+static void
+tgafb_clut_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	struct tga_par *par = (struct tga_par *) info->par;
+	u32 color, dx, dy, width, height, vxres, vyres;
+	u32 *palette = ((u32 *)info->pseudo_palette);
+	unsigned long pos, line_length, i, j;
+	const unsigned char *data;
+	void *regs_base, *fb_base;
+
+	dx = image->dx;
+	dy = image->dy;
+	width = image->width;
+	height = image->height;
+	vxres = info->var.xres_virtual;
+	vyres = info->var.yres_virtual;
+	line_length = info->fix.line_length;
+
+	/* Crop the image to the screen.  */
+	if (dx > vxres || dy > vyres)
+		return;
+	if (dx + width > vxres)
+		width = vxres - dx;
+	if (dy + height > vyres)
+		height = vyres - dy;
+
+	regs_base = par->tga_regs_base;
+	fb_base = par->tga_fb_base;
+
+	pos = dy * line_length + (dx * 4);
+	data = image->data;
+
+	/* Now copy the image, color_expanding via the palette. */
+	for (i = 0; i < height; i++) {
+		for (j = 0; j < width; j++) {
+			color = palette[*data++];
+			__raw_writel(color, fb_base + pos + j*4);
+		}
+		pos += line_length;
+	}
+}
+
+/**
+ *      tgafb_imageblit - REQUIRED function. Can use generic routines if
+ *                        non acclerated hardware and packed pixel based.
+ *                        Copies a image from system memory to the screen.
+ *
+ *      @info: frame buffer structure that represents a single frame buffer
+ *      @image: structure defining the image.
+ */
+static void
+tgafb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	unsigned int is8bpp = info->var.bits_per_pixel == 8;
+
+	/* If a mono image, regardless of FB depth, go do it. */
+	if (image->depth == 1) {
+		tgafb_mono_imageblit(info, image);
+		return;
+	}
+
+	/* For copies that aren't pixel expansion, there's little we
+	   can do better than the generic code.  */
+	/* ??? There is a DMA write mode; I wonder if that could be
+	   made to pull the data from the image buffer...  */
+	if (image->depth == info->var.bits_per_pixel) {
+		cfb_imageblit(info, image);
+		return;
+	}
+
+	/* If 24-plane FB and the image is 8-plane with CLUT, we can do it. */
+	if (!is8bpp && image->depth == 8) {
+		tgafb_clut_imageblit(info, image);
+		return;
+	}
+
+	/* Silently return... */
+}
+
 /**
  *      tgafb_fillrect - REQUIRED function. Can use generic routines if 
  *                       non acclerated hardware and packed pixel based.
@@ -1480,6 +1529,26 @@ tgafb_init_fix(struct fb_info *info)
 	info->fix.ywrapstep = 0;
 
 	info->fix.accel = FB_ACCEL_DEC_TGA;
+
+	/*
+	 * These are needed by fb_set_logo_truepalette(), so we
+	 * set them here for 24-plane cards.
+	 */
+	if (tga_type != TGA_TYPE_8PLANE) {
+		info->var.red.length = 8;
+		info->var.green.length = 8;
+		info->var.blue.length = 8;
+		info->var.red.offset = 16;
+		info->var.green.offset = 8;
+		info->var.blue.offset = 0;
+	}
+}
+
+static int tgafb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	/* We just use this to catch switches out of graphics mode. */
+	tgafb_set_par(info); /* A bit of overkill for BASE_ADDR reset. */
+	return 0;
 }
 
 static int __devinit
_

Patches currently in -mm which might be from jsimmons@infradead.org are

origin.patch
