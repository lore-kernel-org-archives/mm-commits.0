From: akpm@linux-foundation.org
Subject: + pm3fb-various-fixes.patch added to -mm tree
Date: Thu, 17 May 2007 12:00:28 -0700
Message-ID: <200705171900.l4HJ0Sod030588@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbXEQTCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm3fb: various fixes
has been added to the -mm tree.  Its filename is
     pm3fb-various-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm3fb: various fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

- fix 16-bit RGBA 4444 and 5551 modes (use fbset -rgba to set them)
- kill wmb() after each register write by PM3_SLOW_WRITE_REG
- kill inaccurate comments (leftovers from skeletonfb.c)
- kill PCI class restriction, now it is more general and shorter
- white spaces and other minor fixes and source reducing

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |  329 ++++++++++++++++++----------------------
 1 files changed, 150 insertions(+), 179 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-various-fixes drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-various-fixes
+++ a/drivers/video/pm3fb.c
@@ -52,11 +52,6 @@
 static char *mode_option __devinitdata;
 
 /*
- *  If your driver supports multiple boards, you should make the
- *  below data types arrays, or allocate them dynamically (using kmalloc()).
- */
-
-/*
  * This structure defines the hardware state of the graphics card. Normally
  * you place this in a header file in linux/include/video. This file usually
  * also includes register information. That allows other driver subsystems
@@ -67,7 +62,7 @@ struct pm3_par {
 	unsigned char	__iomem *v_regs;/* virtual address of p_regs */
 	u32		video;		/* video flags before blanking */
 	u32		base;		/* screen base (xoffset+yoffset) in 128 bits unit */
-	u32 		palette[16];
+	u32		palette[16];
 };
 
 /*
@@ -104,36 +99,28 @@ static inline void PM3_WAIT(struct pm3_p
 	while (PM3_READ_REG(par, PM3InFIFOSpace) < n);
 }
 
-static inline void PM3_SLOW_WRITE_REG(struct pm3_par *par, s32 off, u32 v)
-{
-	if (par->v_regs) {
-		mb();
-		PM3_WAIT(par, 1);
-		wmb();
-		PM3_WRITE_REG(par, off, v);
-	}
-}
-
-static inline void PM3_SET_INDEX(struct pm3_par *par, unsigned index)
-{
-	PM3_SLOW_WRITE_REG(par, PM3RD_IndexHigh, (index >> 8) & 0xff);
-	PM3_SLOW_WRITE_REG(par, PM3RD_IndexLow, index & 0xff);
-}
-
 static inline void PM3_WRITE_DAC_REG(struct pm3_par *par, unsigned r, u8 v)
 {
-	PM3_SET_INDEX(par, r);
+	PM3_WAIT(par, 3);
+	PM3_WRITE_REG(par, PM3RD_IndexHigh, (r >> 8) & 0xff);
+	PM3_WRITE_REG(par, PM3RD_IndexLow, r & 0xff);
 	wmb();
 	PM3_WRITE_REG(par, PM3RD_IndexedData, v);
+	wmb();
 }
 
 static inline void pm3fb_set_color(struct pm3_par *par, unsigned char regno,
 			unsigned char r, unsigned char g, unsigned char b)
 {
-	PM3_SLOW_WRITE_REG(par, PM3RD_PaletteWriteAddress, regno);
-	PM3_SLOW_WRITE_REG(par, PM3RD_PaletteData, r);
-	PM3_SLOW_WRITE_REG(par, PM3RD_PaletteData, g);
-	PM3_SLOW_WRITE_REG(par, PM3RD_PaletteData, b);
+	PM3_WAIT(par, 4);
+	PM3_WRITE_REG(par, PM3RD_PaletteWriteAddress, regno);
+	wmb();
+	PM3_WRITE_REG(par, PM3RD_PaletteData, r);
+	wmb();
+	PM3_WRITE_REG(par, PM3RD_PaletteData, g);
+	wmb();
+	PM3_WRITE_REG(par, PM3RD_PaletteData, b);
+	wmb();
 }
 
 static void pm3fb_clear_colormap(struct pm3_par *par,
@@ -141,7 +128,7 @@ static void pm3fb_clear_colormap(struct 
 {
 	int i;
 
-	for (i = 0; i < 256 ; i++) /* fill color map with white */
+	for (i = 0; i < 256 ; i++)
 		pm3fb_set_color(par, i, r, g, b);
 
 }
@@ -175,19 +162,26 @@ static void pm3fb_calculate_clock(unsign
 	}
 }
 
-static inline int pm3fb_shift_bpp(unsigned long depth, int v)
+static inline int pm3fb_depth(const struct fb_var_screeninfo *var)
 {
-	switch (depth) {
+	if ( var->bits_per_pixel == 16 )
+		return var->red.length + var->green.length
+			+ var->blue.length;
+
+	return var->bits_per_pixel;
+}
+
+static inline int pm3fb_shift_bpp(unsigned bpp, int v)
+{
+	switch (bpp) {
 	case 8:
 		return (v >> 4);
-	case 12:
-	case 15:
 	case 16:
 		return (v >> 3);
 	case 32:
 		return (v >> 2);
 	}
-	DPRINTK("Unsupported depth %ld\n", depth);
+	DPRINTK("Unsupported depth %u\n", bpp);
 	return 0;
 }
 
@@ -206,56 +200,50 @@ static void pm3fb_write_mode(struct fb_i
 	const u32 vbend = vsend + info->var.upper_margin;
 	const u32 vtotal = info->var.yres + vbend;
 	const u32 width = (info->var.xres_virtual + 7) & ~7;
+	const unsigned bpp = info->var.bits_per_pixel;
 
-	PM3_SLOW_WRITE_REG(par, PM3MemBypassWriteMask, 0xffffffff);
-	PM3_SLOW_WRITE_REG(par, PM3Aperture0, 0x00000000);
-	PM3_SLOW_WRITE_REG(par, PM3Aperture1, 0x00000000);
-	PM3_SLOW_WRITE_REG(par, PM3FIFODis, 0x00000007);
-
-	PM3_SLOW_WRITE_REG(par, PM3HTotal,
-			   pm3fb_shift_bpp(info->var.bits_per_pixel,
-					  htotal - 1));
-	PM3_SLOW_WRITE_REG(par, PM3HsEnd,
-			   pm3fb_shift_bpp(info->var.bits_per_pixel,
-					  hsend));
-	PM3_SLOW_WRITE_REG(par, PM3HsStart,
-			   pm3fb_shift_bpp(info->var.bits_per_pixel,
-					  hsstart));
-	PM3_SLOW_WRITE_REG(par, PM3HbEnd,
-			   pm3fb_shift_bpp(info->var.bits_per_pixel,
-					  hbend));
-	PM3_SLOW_WRITE_REG(par, PM3HgEnd,
-			   pm3fb_shift_bpp(info->var.bits_per_pixel,
-					  hbend));
-	PM3_SLOW_WRITE_REG(par, PM3ScreenStride,
-			   pm3fb_shift_bpp(info->var.bits_per_pixel,
-					  width));
-	PM3_SLOW_WRITE_REG(par, PM3VTotal, vtotal - 1);
-	PM3_SLOW_WRITE_REG(par, PM3VsEnd, vsend - 1);
-	PM3_SLOW_WRITE_REG(par, PM3VsStart, vsstart - 1);
-	PM3_SLOW_WRITE_REG(par, PM3VbEnd, vbend);
+	PM3_WAIT(par, 20);
+	PM3_WRITE_REG(par, PM3MemBypassWriteMask, 0xffffffff);
+	PM3_WRITE_REG(par, PM3Aperture0, 0x00000000);
+	PM3_WRITE_REG(par, PM3Aperture1, 0x00000000);
+	PM3_WRITE_REG(par, PM3FIFODis, 0x00000007);
+
+	PM3_WRITE_REG(par, PM3HTotal,
+			   pm3fb_shift_bpp(bpp, htotal - 1));
+	PM3_WRITE_REG(par, PM3HsEnd,
+			   pm3fb_shift_bpp(bpp, hsend));
+	PM3_WRITE_REG(par, PM3HsStart,
+			   pm3fb_shift_bpp(bpp, hsstart));
+	PM3_WRITE_REG(par, PM3HbEnd,
+			   pm3fb_shift_bpp(bpp, hbend));
+	PM3_WRITE_REG(par, PM3HgEnd,
+			   pm3fb_shift_bpp(bpp, hbend));
+	PM3_WRITE_REG(par, PM3ScreenStride,
+			   pm3fb_shift_bpp(bpp, width));
+	PM3_WRITE_REG(par, PM3VTotal, vtotal - 1);
+	PM3_WRITE_REG(par, PM3VsEnd, vsend - 1);
+	PM3_WRITE_REG(par, PM3VsStart, vsstart - 1);
+	PM3_WRITE_REG(par, PM3VbEnd, vbend);
 
-	switch (info->var.bits_per_pixel) {
+	switch (bpp) {
 	case 8:
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture1Mode,
+		PM3_WRITE_REG(par, PM3ByAperture1Mode,
 				   PM3ByApertureMode_PIXELSIZE_8BIT);
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture2Mode,
+		PM3_WRITE_REG(par, PM3ByAperture2Mode,
 				   PM3ByApertureMode_PIXELSIZE_8BIT);
 		break;
 
-	case 12:
-	case 15:
 	case 16:
 #ifndef __BIG_ENDIAN
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture1Mode,
+		PM3_WRITE_REG(par, PM3ByAperture1Mode,
 				   PM3ByApertureMode_PIXELSIZE_16BIT);
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture2Mode,
+		PM3_WRITE_REG(par, PM3ByAperture2Mode,
 				   PM3ByApertureMode_PIXELSIZE_16BIT);
 #else
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture1Mode,
+		PM3_WRITE_REG(par, PM3ByAperture1Mode,
 				   PM3ByApertureMode_PIXELSIZE_16BIT |
 				   PM3ByApertureMode_BYTESWAP_BADC);
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture2Mode,
+		PM3_WRITE_REG(par, PM3ByAperture2Mode,
 				   PM3ByApertureMode_PIXELSIZE_16BIT |
 				   PM3ByApertureMode_BYTESWAP_BADC);
 #endif /* ! __BIG_ENDIAN */
@@ -263,23 +251,22 @@ static void pm3fb_write_mode(struct fb_i
 
 	case 32:
 #ifndef __BIG_ENDIAN
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture1Mode,
+		PM3_WRITE_REG(par, PM3ByAperture1Mode,
 				   PM3ByApertureMode_PIXELSIZE_32BIT);
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture2Mode,
+		PM3_WRITE_REG(par, PM3ByAperture2Mode,
 				   PM3ByApertureMode_PIXELSIZE_32BIT);
 #else
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture1Mode,
+		PM3_WRITE_REG(par, PM3ByAperture1Mode,
 				   PM3ByApertureMode_PIXELSIZE_32BIT |
 				   PM3ByApertureMode_BYTESWAP_DCBA);
-		PM3_SLOW_WRITE_REG(par, PM3ByAperture2Mode,
+		PM3_WRITE_REG(par, PM3ByAperture2Mode,
 				   PM3ByApertureMode_PIXELSIZE_32BIT |
 				   PM3ByApertureMode_BYTESWAP_DCBA);
 #endif /* ! __BIG_ENDIAN */
 		break;
 
 	default:
-		DPRINTK("Unsupported depth %d\n",
-			info->var.bits_per_pixel);
+		DPRINTK("Unsupported depth %d\n", bpp);
 		break;
 	}
 
@@ -296,14 +283,15 @@ static void pm3fb_write_mode(struct fb_i
 			   PM3VideoControl_VSYNC_MASK);
 		video |= PM3VideoControl_HSYNC_ACTIVE_HIGH |
 			 PM3VideoControl_VSYNC_ACTIVE_HIGH;
-		PM3_SLOW_WRITE_REG(par, PM3VideoControl, video);
+		PM3_WRITE_REG(par, PM3VideoControl, video);
 	}
-	PM3_SLOW_WRITE_REG(par, PM3VClkCtl,
+	PM3_WRITE_REG(par, PM3VClkCtl,
 			   (PM3_READ_REG(par, PM3VClkCtl) & 0xFFFFFFFC));
-	PM3_SLOW_WRITE_REG(par, PM3ScreenBase, par->base);
-	PM3_SLOW_WRITE_REG(par, PM3ChipConfig,
+	PM3_WRITE_REG(par, PM3ScreenBase, par->base);
+	PM3_WRITE_REG(par, PM3ChipConfig,
 			   (PM3_READ_REG(par, PM3ChipConfig) & 0xFFFFFFFD));
 
+	wmb();
 	{
 		unsigned char uninitialized_var(m);	/* ClkPreScale */
 		unsigned char uninitialized_var(n);	/* ClkFeedBackScale */
@@ -337,7 +325,7 @@ static void pm3fb_write_mode(struct fb_i
 
 	PM3_WRITE_DAC_REG(par, PM3RD_DACControl, 0x00);
 
-	switch (info->var.bits_per_pixel) {
+	switch (pm3fb_depth(&info->var)) {
 	case 8:
 		PM3_WRITE_DAC_REG(par, PM3RD_PixelSize,
 				  PM3RD_PixelSize_8_BIT_PIXELS);
@@ -393,57 +381,44 @@ static void pm3fb_write_mode(struct fb_i
  * hardware independent functions
  */
 int pm3fb_init(void);
-int pm3fb_setup(char*);
 
 static int pm3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	u32 lpitch;
+	unsigned bpp = var->red.length + var->green.length
+			+ var->blue.length + var->transp.length;
 
-	var->transp.offset = 0;
-	var->transp.length = 0;
-	switch(var->bits_per_pixel) {
-	case 8:
-		var->red.length = var->green.length = var->blue.length = 8;
-		var->red.offset = var->green.offset = var->blue.offset = 0;
-		break;
-	case 12:
-		var->red.offset   = 8;
-		var->red.length   = 4;
-		var->green.offset = 4;
-		var->green.length = 4;
-		var->blue.offset  = 0;
-		var->blue.length  = 4;
-		var->transp.offset = 12;
-		var->transp.length = 4;
-	case 15:
-		var->red.offset   = 10;
-		var->red.length   = 5;
-		var->green.offset = 5;
-		var->green.length = 5;
-		var->blue.offset  = 0;
-		var->blue.length  = 5;
-		var->transp.offset = 15;
-		var->transp.length = 1;
-		break;
-	case 16:
-		var->red.offset   = 11;
-		var->red.length   = 5;
-		var->green.offset = 5;
-		var->green.length = 6;
-		var->blue.offset  = 0;
-		var->blue.length  = 5;
-		break;
-	case 32:
-		var->transp.offset = 24;
-		var->transp.length = 8;
-		var->red.offset	  = 16;
-		var->green.offset = 8;
-		var->blue.offset  = 0;
-		var->red.length = var->green.length = var->blue.length = 8;
-		break;
-	default:
-		DPRINTK("depth not supported: %u\n", var->bits_per_pixel);
-		return -EINVAL;
+	if ( bpp != var->bits_per_pixel ) {
+		/* set predefined mode for bits_per_pixel settings */
+
+		switch(var->bits_per_pixel) {
+		case 8:
+			var->red.length = var->green.length = var->blue.length = 8;
+			var->red.offset = var->green.offset = var->blue.offset = 0;
+			var->transp.offset = 0;
+			var->transp.length = 0;
+			break;
+		case 16:
+			var->red.length = var->blue.length = 5;
+			var->green.length = 6;
+			var->transp.length = 0;
+			break;
+		case 32:
+			var->red.length = var->green.length = var->blue.length = 8;
+			var->transp.length = 8;
+			break;
+		default:
+			DPRINTK("depth not supported: %u\n", var->bits_per_pixel);
+			return -EINVAL;
+		}
+	}
+	/* it is assumed BGRA order */
+	if (var->bits_per_pixel > 8 )
+	{
+		var->blue.offset = 0;
+		var->green.offset = var->blue.length;
+		var->red.offset = var->green.offset + var->green.length;
+		var->transp.offset = var->red.offset + var->red.length;
 	}
 	var->height = var->width = -1;
 
@@ -502,10 +477,9 @@ static int pm3fb_set_par(struct fb_info 
 {
 	struct pm3_par *par = info->par;
 	const u32 xres = (info->var.xres + 31) & ~31;
-	const int depth = (info->var.bits_per_pixel + 7) & ~7;
+	const unsigned bpp = info->var.bits_per_pixel;
 
-	par->base = pm3fb_shift_bpp(info->var.bits_per_pixel,
-					(info->var.yoffset * xres)
+	par->base = pm3fb_shift_bpp(bpp,(info->var.yoffset * xres)
 					+ info->var.xoffset);
 	par->video = 0;
 
@@ -530,12 +504,10 @@ static int pm3fb_set_par(struct fb_info 
 		par->video |= PM3VideoControl_DISABLE;
 		DPRINTK("PM3Video disabled\n");
 	}
-	switch (depth) {
+	switch (bpp) {
 	case 8:
 		par->video |= PM3VideoControl_PIXELSIZE_8BIT;
 		break;
-	case 12:
-	case 15:
 	case 16:
 		par->video |= PM3VideoControl_PIXELSIZE_16BIT;
 		break;
@@ -548,9 +520,9 @@ static int pm3fb_set_par(struct fb_info 
 	}
 
 	info->fix.visual =
-		(depth == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
+		(bpp == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
 	info->fix.line_length = ((info->var.xres_virtual + 7)  & ~7)
-					* depth / 8;
+					* bpp / 8;
 
 /*	pm3fb_clear_memory(info, 0);*/
 	pm3fb_clear_colormap(par, 0, 0, 0);
@@ -580,8 +552,8 @@ static int pm3fb_setcolreg(unsigned regn
 	 *   var->{color}.length contains length of bitfield
 	 *   {hardwarespecific} contains width of DAC
 	 *   pseudo_palette[X] is programmed to (X << red.offset) |
-	 *				      (X << green.offset) |
-	 *				      (X << blue.offset)
+	 *					(X << green.offset) |
+	 *					(X << blue.offset)
 	 *   RAMDAC[X] is programmed to (red, green, blue)
 	 *   color depth = SUM(var->{color}.length)
 	 *
@@ -621,7 +593,6 @@ static int pm3fb_setcolreg(unsigned regn
 		case 8:
 			break;
 		case 16:
-		case 24:
 		case 32:
 			((u32*)(info->pseudo_palette))[regno] = v;
 			break;
@@ -643,7 +614,8 @@ static int pm3fb_pan_display(struct fb_v
 	par->base = pm3fb_shift_bpp(var->bits_per_pixel,
 					(var->yoffset * xres)
 					+ var->xoffset);
-	PM3_SLOW_WRITE_REG(par, PM3ScreenBase, par->base);
+	PM3_WAIT(par, 1);
+	PM3_WRITE_REG(par, PM3ScreenBase, par->base);
 	return 0;
 }
 
@@ -665,31 +637,31 @@ static int pm3fb_blank(int blank_mode, s
 
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		video = video | PM3VideoControl_ENABLE;
+		video |= PM3VideoControl_ENABLE;
 		break;
-	case FB_BLANK_NORMAL:	/* FIXME */
-		video = video & ~(PM3VideoControl_ENABLE);
+	case FB_BLANK_NORMAL:
+		video &= ~(PM3VideoControl_ENABLE);
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		video = video & ~(PM3VideoControl_HSYNC_MASK |
-				  PM3VideoControl_BLANK_ACTIVE_LOW);
+		video &= ~(PM3VideoControl_HSYNC_MASK |
+			  PM3VideoControl_BLANK_ACTIVE_LOW);
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		video = video & ~(PM3VideoControl_VSYNC_MASK |
-				  PM3VideoControl_BLANK_ACTIVE_LOW);
+		video &= ~(PM3VideoControl_VSYNC_MASK |
+			  PM3VideoControl_BLANK_ACTIVE_LOW);
 		break;
 	case FB_BLANK_POWERDOWN:
-		video = video & ~(PM3VideoControl_HSYNC_MASK |
-				  PM3VideoControl_VSYNC_MASK |
-				  PM3VideoControl_BLANK_ACTIVE_LOW);
+		video &= ~(PM3VideoControl_HSYNC_MASK |
+			  PM3VideoControl_VSYNC_MASK |
+			  PM3VideoControl_BLANK_ACTIVE_LOW);
 		break;
 	default:
 		DPRINTK("Unsupported blanking %d\n", blank_mode);
 		return 1;
 	}
 
-	PM3_SLOW_WRITE_REG(par,PM3VideoControl, video);
-
+	PM3_WAIT(par, 1);
+	PM3_WRITE_REG(par,PM3VideoControl, video);
 	return 0;
 }
 
@@ -703,9 +675,9 @@ static struct fb_ops pm3fb_ops = {
 	.fb_set_par	= pm3fb_set_par,
 	.fb_setcolreg	= pm3fb_setcolreg,
 	.fb_pan_display	= pm3fb_pan_display,
-	.fb_fillrect	= cfb_fillrect,		/* Needed !!! */
-	.fb_copyarea	= cfb_copyarea,		/* Needed !!! */
-	.fb_imageblit	= cfb_imageblit,	/* Needed !!! */
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
 	.fb_blank	= pm3fb_blank,
 };
 
@@ -722,7 +694,7 @@ static unsigned long pm3fb_size_memory(s
 	unsigned long	memsize = 0, tempBypass, i, temp1, temp2;
 	unsigned char	__iomem *screen_mem;
 
-	pm3fb_fix.smem_len = 64 * 1024 * 1024; /* request full aperture size */
+	pm3fb_fix.smem_len = 64 * 1024l * 1024; /* request full aperture size */
 	/* Linear frame buffer - request region and map it. */
 	if (!request_mem_region(pm3fb_fix.smem_start, pm3fb_fix.smem_len,
 				 "pm3fb smem")) {
@@ -744,7 +716,8 @@ static unsigned long pm3fb_size_memory(s
 
 	DPRINTK("PM3MemBypassWriteMask was: 0x%08lx\n", tempBypass);
 
-	PM3_SLOW_WRITE_REG(par, PM3MemBypassWriteMask, 0xFFFFFFFF);
+	PM3_WAIT(par, 1);
+	PM3_WRITE_REG(par, PM3MemBypassWriteMask, 0xFFFFFFFF);
 
 	/* pm3 split up memory, replicates, and do a lot of nasty stuff IMHO ;-) */
 	for (i = 0; i < 32; i++) {
@@ -765,10 +738,9 @@ static unsigned long pm3fb_size_memory(s
 	if (memsize + 1 == i) {
 		for (i = 0; i < 32; i++) {
 			/* Clear first 32MB ; 0 is 0, no need to byteswap */
-			writel(0x0000000,
-			       (screen_mem + (i * 1048576)));
-			mb();
+			writel(0x0000000, (screen_mem + (i * 1048576)));
 		}
+		wmb();
 
 		for (i = 32; i < 64; i++) {
 			fb_writel(i * 0x00345678,
@@ -787,7 +759,8 @@ static unsigned long pm3fb_size_memory(s
 	}
 	DPRINTK("Second detect pass got %ld MB\n", memsize + 1);
 
-	PM3_SLOW_WRITE_REG(par, PM3MemBypassWriteMask, tempBypass);
+	PM3_WAIT(par, 1);
+	PM3_WRITE_REG(par, PM3MemBypassWriteMask, tempBypass);
 
 	iounmap(screen_mem);
 	release_mem_region(pm3fb_fix.smem_start, pm3fb_fix.smem_len);
@@ -890,7 +863,6 @@ static int __devinit pm3fb_probe(struct 
 		goto err_exit_both;
 	}
 
-	/* This has to been done !!! */
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		retval = -ENOMEM;
 		goto err_exit_both;
@@ -907,7 +879,7 @@ static int __devinit pm3fb_probe(struct 
 	}
 	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
 	   info->fix.id);
-	pci_set_drvdata(dev, info); /* or dev_set_drvdata(device, info) */
+	pci_set_drvdata(dev, info);
 	return 0;
 
  err_exit_all:
@@ -949,8 +921,7 @@ static void __devexit pm3fb_remove(struc
 
 static struct pci_device_id pm3fb_id_table[] = {
 	{ PCI_VENDOR_ID_3DLABS, 0x0a,
-	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
-	  0xff0000, 0 },
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0, }
 };
 
@@ -964,6 +935,22 @@ static struct pci_driver pm3fb_driver = 
 
 MODULE_DEVICE_TABLE(pci, pm3fb_id_table);
 
+#ifndef MODULE
+	/*
+	 *  Setup
+	 */
+
+/*
+ * Only necessary if your driver takes special options,
+ * otherwise we fall back on the generic fb_setup().
+ */
+static int __init pm3fb_setup(char *options)
+{
+	/* Parse user speficied options (`video=pm3fb:') */
+	return 0;
+}
+#endif /* MODULE */
+
 int __init pm3fb_init(void)
 {
 	/*
@@ -985,22 +972,6 @@ static void __exit pm3fb_exit(void)
 	pci_unregister_driver(&pm3fb_driver);
 }
 
-#ifndef MODULE
-	/*
-	 *  Setup
-	 */
-
-/*
- * Only necessary if your driver takes special options,
- * otherwise we fall back on the generic fb_setup().
- */
-int __init pm3fb_setup(char *options)
-{
-	/* Parse user speficied options (`video=pm3fb:') */
-	return 0;
-}
-#endif /* MODULE */
-
 module_init(pm3fb_init);
 module_exit(pm3fb_exit);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

fbdev-cleanup-of-sparc-fb-options.patch
pm2fb-rdac_wr-barriers-clean-up.patch
pm3fb-various-fixes.patch
fbcon-smart-blitter-usage-for-scrolling.patch
