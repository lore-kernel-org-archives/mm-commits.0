From: akpm@linux-foundation.org
Subject: + pm3fb-improvements-and-cleanups.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:30 -0700
Message-ID: <200707261900.l6QJ0UTc015631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936316AbXGZTBM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:01:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm3fb: improvements and cleanups
has been added to the -mm tree.  Its filename is
     pm3fb-improvements-and-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm3fb: improvements and cleanups
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch contains improvements:
- it adds ROP_XOR in pm3fb_fillrect()
- it conforms closer to coding style
- it removes redundant parentheses and setting bits with 0 value
- it checks if hardware acceleration is disabled in pm3fb_imageblit
- it adds module description

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |   68 ++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-improvements-and-cleanups drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-improvements-and-cleanups
+++ a/drivers/video/pm3fb.c
@@ -135,7 +135,7 @@ static void pm3fb_clear_colormap(struct 
 
 }
 
-/* Calculating various clock parameter */
+/* Calculating various clock parameters */
 static void pm3fb_calculate_clock(unsigned long reqclock,
 				unsigned char *prescale,
 				unsigned char *feedback,
@@ -166,7 +166,7 @@ static void pm3fb_calculate_clock(unsign
 
 static inline int pm3fb_depth(const struct fb_var_screeninfo *var)
 {
-	if ( var->bits_per_pixel == 16 )
+	if (var->bits_per_pixel == 16)
 		return var->red.length + var->green.length
 			+ var->blue.length;
 
@@ -351,7 +351,7 @@ static void pm3fb_init_engine(struct fb_
 
 	PM3_WRITE_REG(par, PM3dXDom, 0x0);
 	PM3_WRITE_REG(par, PM3dXSub, 0x0);
-	PM3_WRITE_REG(par, PM3dY, (1 << 16));
+	PM3_WRITE_REG(par, PM3dY, 1 << 16);
 	PM3_WRITE_REG(par, PM3StartXDom, 0x0);
 	PM3_WRITE_REG(par, PM3StartXSub, 0x0);
 	PM3_WRITE_REG(par, PM3StartY, 0x0);
@@ -372,16 +372,21 @@ static void pm3fb_fillrect (struct fb_in
 	struct pm3_par *par = info->par;
 	struct fb_fillrect modded;
 	int vxres, vyres;
+	int rop;
 	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
 		((u32*)info->pseudo_palette)[region->color] : region->color;
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
-	if ((info->flags & FBINFO_HWACCEL_DISABLED) ||
-		region->rop != ROP_COPY ) {
+	if (info->flags & FBINFO_HWACCEL_DISABLED) {
 		cfb_fillrect(info, region);
 		return;
 	}
+	if (region->rop == ROP_COPY )
+		rop = PM3Config2D_ForegroundROP(0x3); /* GXcopy */
+	else
+		rop = PM3Config2D_ForegroundROP(0x6) | /* GXxor */
+			PM3Config2D_FBDestReadEnable;
 
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
@@ -407,22 +412,22 @@ static void pm3fb_fillrect (struct fb_in
 	PM3_WRITE_REG(par, PM3Config2D,
 			PM3Config2D_UseConstantSource |
 			PM3Config2D_ForegroundROPEnable |
-			(PM3Config2D_ForegroundROP(0x3)) |
+			rop |
 			PM3Config2D_FBWriteEnable);
 
 	PM3_WRITE_REG(par, PM3ForegroundColor, color);
 
 	PM3_WRITE_REG(par, PM3RectanglePosition,
-			(PM3RectanglePosition_XOffset(modded.dx)) |
-			(PM3RectanglePosition_YOffset(modded.dy)));
+			PM3RectanglePosition_XOffset(modded.dx) |
+			PM3RectanglePosition_YOffset(modded.dy));
 
 	PM3_WRITE_REG(par, PM3Render2D,
 		      PM3Render2D_XPositive |
 		      PM3Render2D_YPositive |
 		      PM3Render2D_Operation_Normal |
 		      PM3Render2D_SpanOperation |
-		      (PM3Render2D_Width(modded.width)) |
-		      (PM3Render2D_Height(modded.height)));
+		      PM3Render2D_Width(modded.width) |
+		      PM3Render2D_Height(modded.height));
 }
 
 static void pm3fb_copyarea(struct fb_info *info,
@@ -470,7 +475,7 @@ static void pm3fb_copyarea(struct fb_inf
 			PM3Config2D_UserScissorEnable |
 			PM3Config2D_ForegroundROPEnable |
 			PM3Config2D_Blocking |
-			(PM3Config2D_ForegroundROP(0x3)) | /* Ox3 is GXcopy */
+			PM3Config2D_ForegroundROP(0x3) | /* Ox3 is GXcopy */
 			PM3Config2D_FBWriteEnable);
 
 	PM3_WRITE_REG(par, PM3ScissorMinXY,
@@ -484,8 +489,8 @@ static void pm3fb_copyarea(struct fb_inf
 			PM3FBSourceReadBufferOffset_YOffset(o_y));
 
 	PM3_WRITE_REG(par, PM3RectanglePosition,
-			(PM3RectanglePosition_XOffset(modded.dx - x_align)) |
-			(PM3RectanglePosition_YOffset(modded.dy)));
+			PM3RectanglePosition_XOffset(modded.dx - x_align) |
+			PM3RectanglePosition_YOffset(modded.dy));
 
 	PM3_WRITE_REG(par, PM3Render2D,
 			((modded.sx > modded.dx) ? PM3Render2D_XPositive : 0) |
@@ -493,8 +498,8 @@ static void pm3fb_copyarea(struct fb_inf
 			PM3Render2D_Operation_Normal |
 			PM3Render2D_SpanOperation |
 			PM3Render2D_FBSourceReadEnable |
-			(PM3Render2D_Width(modded.width + x_align)) |
-			(PM3Render2D_Height(modded.height)));
+			PM3Render2D_Width(modded.width + x_align) |
+			PM3Render2D_Height(modded.height));
 }
 
 static void pm3fb_imageblit(struct fb_info *info, const struct fb_image *image)
@@ -504,6 +509,12 @@ static void pm3fb_imageblit(struct fb_in
 	u32 fgx, bgx;
 	const u32 *src = (const u32*)image->data;
 
+	if (info->state != FBINFO_STATE_RUNNING)
+		return;
+	if (info->flags & FBINFO_HWACCEL_DISABLED) {
+		cfb_imageblit(info, image);
+		return;
+	}
 	switch (info->fix.visual) {
 		case FB_VISUAL_PSEUDOCOLOR:
 			fgx = image->fg_color;
@@ -537,7 +548,7 @@ static void pm3fb_imageblit(struct fb_in
 			PM3Config2D_UserScissorEnable |
 			PM3Config2D_UseConstantSource |
 			PM3Config2D_ForegroundROPEnable |
-			(PM3Config2D_ForegroundROP(0x3)) |
+			PM3Config2D_ForegroundROP(0x3) |
 			PM3Config2D_OpaqueSpan |
 			PM3Config2D_FBWriteEnable);
 	PM3_WRITE_REG(par, PM3ScissorMinXY,
@@ -546,15 +557,15 @@ static void pm3fb_imageblit(struct fb_in
 			(((image->dy + image->height) & 0x0fff) << 16) |
 			((image->dx + image->width) & 0x0fff));
 	PM3_WRITE_REG(par, PM3RectanglePosition,
-			(PM3RectanglePosition_XOffset(image->dx)) |
-			(PM3RectanglePosition_YOffset(image->dy)));
+			PM3RectanglePosition_XOffset(image->dx) |
+			PM3RectanglePosition_YOffset(image->dy));
 	PM3_WRITE_REG(par, PM3Render2D,
 			PM3Render2D_XPositive |
 			PM3Render2D_YPositive |
 			PM3Render2D_Operation_SyncOnBitMask |
 			PM3Render2D_SpanOperation |
-			(PM3Render2D_Width(image->width)) |
-			(PM3Render2D_Height(image->height)));
+			PM3Render2D_Width(image->width) |
+			PM3Render2D_Height(image->height));
 
 
 	while (height--) {
@@ -783,7 +794,7 @@ static int pm3fb_check_var(struct fb_var
 	unsigned bpp = var->red.length + var->green.length
 			+ var->blue.length + var->transp.length;
 
-	if ( bpp != var->bits_per_pixel ) {
+	if (bpp != var->bits_per_pixel) {
 		/* set predefined mode for bits_per_pixel settings */
 
 		switch(var->bits_per_pixel) {
@@ -838,7 +849,7 @@ static int pm3fb_check_var(struct fb_var
 	}
 
 	var->xres = (var->xres + 31) & ~31; /* could sometimes be 8 */
-	lpitch = var->xres * ((var->bits_per_pixel + 7)>>3);
+	lpitch = var->xres * ((var->bits_per_pixel + 7) >> 3);
 
 	if (var->xres < 200 || var->xres > 2048) {
 		DPRINTK("width not supported: %u\n", var->xres);
@@ -890,15 +901,12 @@ static int pm3fb_set_par(struct fb_info 
 
 	if ((info->var.vmode & FB_VMODE_MASK) == FB_VMODE_DOUBLE)
 		par->video |= PM3VideoControl_LINE_DOUBLE_ON;
-	else
-		par->video |= PM3VideoControl_LINE_DOUBLE_OFF;
 
 	if ((info->var.activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW)
 		par->video |= PM3VideoControl_ENABLE;
-	else {
-		par->video &= ~PM3VideoControl_ENABLE;
+	else
 		DPRINTK("PM3Video disabled\n");
-	}
+
 	switch (bpp) {
 	case 8:
 		par->video |= PM3VideoControl_PIXELSIZE_8BIT;
@@ -916,8 +924,7 @@ static int pm3fb_set_par(struct fb_info 
 
 	info->fix.visual =
 		(bpp == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
-	info->fix.line_length = ((info->var.xres_virtual + 7)  & ~7)
-					* bpp / 8;
+	info->fix.line_length = ((info->var.xres_virtual + 7)  >> 3) * bpp;
 
 /*	pm3fb_clear_memory(info, 0);*/
 	pm3fb_clear_colormap(par, 0, 0, 0);
@@ -1035,7 +1042,7 @@ static int pm3fb_blank(int blank_mode, s
 		video |= PM3VideoControl_ENABLE;
 		break;
 	case FB_BLANK_NORMAL:
-		video &= ~(PM3VideoControl_ENABLE);
+		video &= ~PM3VideoControl_ENABLE;
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
 		video &= ~(PM3VideoControl_HSYNC_MASK |
@@ -1367,4 +1374,5 @@ static void __exit pm3fb_exit(void)
 module_init(pm3fb_init);
 module_exit(pm3fb_exit);
 
+MODULE_DESCRIPTION("Permedia3 framebuffer device driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
