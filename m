From: akpm@linux-foundation.org
Subject: + pm2fb-source-code-improvements.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:36 -0700
Message-ID: <200707261900.l6QJ0asO015645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764507AbXGZTMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: source code improvements
has been added to the -mm tree.  Its filename is
     pm2fb-source-code-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: source code improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch concentrates on source compacting, simplification and more
conformance to kernel coding standards.
The major changes:
- RD32() and WR() functions are merged into pm2_RD() and pm2_WR()
- conditional (with switch()) RDAC functions are separated in two
unconditional ones
- the conditional pm2fb_block_op() function is merged into pm2fb_fillrect()
and pm2fb_copyarea()
- WAIT_FIFO() values are corrected

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |  350 +++++++++++++++++-----------------------
 1 file changed, 155 insertions(+), 195 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-source-code-improvements drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-source-code-improvements
+++ a/drivers/video/pm2fb.c
@@ -11,7 +11,7 @@
  * and additional input from James Simmon's port of Hannu Mallat's tdfx
  * driver.
  *
- * I have a Creative Graphics Blaster Exxtreme card - pm2fb on x86.  I
+ * I have a Creative Graphics Blaster Exxtreme card - pm2fb on x86. I
  * have no access to other pm2fb implementations. Sparc (and thus
  * hopefully other big-endian) devices now work, thanks to a lot of
  * testing work by Ron Murray. I have no access to CVision hardware,
@@ -146,56 +146,35 @@ static struct fb_var_screeninfo pm2fb_va
  * Utility functions
  */
 
-static inline u32 RD32(unsigned char __iomem *base, s32 off)
-{
-	return fb_readl(base + off);
-}
-
-static inline void WR32(unsigned char __iomem *base, s32 off, u32 v)
-{
-	fb_writel(v, base + off);
-}
-
 static inline u32 pm2_RD(struct pm2fb_par* p, s32 off)
 {
-	return RD32(p->v_regs, off);
+	return fb_readl(p->v_regs + off);
 }
 
 static inline void pm2_WR(struct pm2fb_par* p, s32 off, u32 v)
 {
-	WR32(p->v_regs, off, v);
+	fb_writel(v, p->v_regs + off);
 }
 
 static inline u32 pm2_RDAC_RD(struct pm2fb_par* p, s32 idx)
 {
-	int index = PM2R_RD_INDEXED_DATA;
-	switch (p->type) {
-	case PM2_TYPE_PERMEDIA2:
-		pm2_WR(p, PM2R_RD_PALETTE_WRITE_ADDRESS, idx);
-		break;
-	case PM2_TYPE_PERMEDIA2V:
-		pm2_WR(p, PM2VR_RD_INDEX_LOW, idx & 0xff);
-		index = PM2VR_RD_INDEXED_DATA;
-		break;
-	}
+	pm2_WR(p, PM2R_RD_PALETTE_WRITE_ADDRESS, idx);
 	mb();
-	return pm2_RD(p, index);
+	return pm2_RD(p, PM2R_RD_INDEXED_DATA);
+}
+
+static inline u32 pm2v_RDAC_RD(struct pm2fb_par* p, s32 idx)
+{
+	pm2_WR(p, PM2VR_RD_INDEX_LOW, idx & 0xff);
+	mb();
+	return pm2_RD(p,  PM2VR_RD_INDEXED_DATA);
 }
 
 static inline void pm2_RDAC_WR(struct pm2fb_par* p, s32 idx, u32 v)
 {
-	int index = PM2R_RD_INDEXED_DATA;
-	switch (p->type) {
-	case PM2_TYPE_PERMEDIA2:
-		pm2_WR(p, PM2R_RD_PALETTE_WRITE_ADDRESS, idx);
-		break;
-	case PM2_TYPE_PERMEDIA2V:
-		pm2_WR(p, PM2VR_RD_INDEX_LOW, idx & 0xff);
-		index = PM2VR_RD_INDEXED_DATA;
-		break;
-	}
+	pm2_WR(p, PM2R_RD_PALETTE_WRITE_ADDRESS, idx);
 	wmb();
-	pm2_WR(p, index, v);
+	pm2_WR(p, PM2R_RD_INDEXED_DATA, v);
 	wmb();
 }
 
@@ -212,7 +191,7 @@ static inline void pm2v_RDAC_WR(struct p
 #else
 static inline void WAIT_FIFO(struct pm2fb_par* p, u32 a)
 {
-	while( pm2_RD(p, PM2R_IN_FIFO_SPACE) < a );
+	while(pm2_RD(p, PM2R_IN_FIFO_SPACE) < a);
 	mb();
 }
 #endif
@@ -249,7 +228,7 @@ static u32 partprod(u32 xres)
 
 	for (i = 0; pp_table[i].width && pp_table[i].width != xres; i++)
 		;
-	if ( pp_table[i].width == 0 )
+	if (pp_table[i].width == 0)
 		DPRINTK("invalid width %u\n", xres);
 	return pp_table[i].pp;
 }
@@ -257,20 +236,17 @@ static u32 partprod(u32 xres)
 static u32 to3264(u32 timing, int bpp, int is64)
 {
 	switch (bpp) {
+	case 24:
+		timing *= 3;
 	case 8:
-		timing >>= 2 + is64;
-		break;
+		timing >>= 1;
 	case 16:
-		timing >>= 1 + is64;
-		break;
-	case 24:
-		timing = (timing * 3) >> (2 + is64);
-		break;
+		timing >>= 1;
 	case 32:
-		if (is64)
-			timing >>= 1;
 		break;
 	}
+	if (is64)
+		timing >>= 1;
 	return timing;
 }
 
@@ -289,13 +265,13 @@ static void pm2_mnp(u32 clk, unsigned ch
 		for (m = 2; m; m++) {
 			f = PM2_REFERENCE_CLOCK * m / n;
 			if (f >= 150000 && f <= 300000) {
-				for ( p = 0; p < 5; p++, f >>= 1) {
-					curr = ( clk > f ) ? clk - f : f - clk;
-					if ( curr < delta ) {
-						delta=curr;
-						*mm=m;
-						*nn=n;
-						*pp=p;
+				for (p = 0; p < 5; p++, f >>= 1) {
+					curr = (clk > f) ? clk - f : f - clk;
+					if (curr < delta) {
+						delta = curr;
+						*mm = m;
+						*nn = n;
+						*pp = p;
 					}
 				}
 			}
@@ -313,15 +289,15 @@ static void pm2v_mnp(u32 clk, unsigned c
 	s32 delta = 1000;
 
 	*mm = *nn = *pp = 0;
-	for ( m = 1; m < 128; m++) {
+	for (m = 1; m < 128; m++) {
 		for (n = 2 * m + 1; n; n++) {
-			for ( p = 0; p < 2; p++) {
-				f = ( PM2_REFERENCE_CLOCK >> ( p + 1 )) * n / m;
-				if ( clk > f - delta && clk < f + delta ) {
-					delta = ( clk > f ) ? clk - f : f - clk;
-					*mm=m;
-					*nn=n;
-					*pp=p;
+			for (p = 0; p < 2; p++) {
+				f = (PM2_REFERENCE_CLOCK >> (p + 1)) * n / m;
+				if (clk > f - delta && clk < f + delta) {
+					delta = (clk > f) ? clk - f : f - clk;
+					*mm = m;
+					*nn = n;
+					*pp = p;
 				}
 			}
 		}
@@ -329,7 +305,7 @@ static void pm2v_mnp(u32 clk, unsigned c
 }
 
 static void clear_palette(struct pm2fb_par* p) {
-	int i=256;
+	int i = 256;
 
 	WAIT_FIFO(p, 1);
 	pm2_WR(p, PM2R_RD_PALETTE_WRITE_ADDRESS, 0);
@@ -369,7 +345,7 @@ static void reset_config(struct pm2fb_pa
 {
 	WAIT_FIFO(p, 52);
 	pm2_WR(p, PM2R_CHIP_CONFIG, pm2_RD(p, PM2R_CHIP_CONFIG) &
-	       ~(PM2F_VGA_ENABLE|PM2F_VGA_FIXED));
+			~(PM2F_VGA_ENABLE | PM2F_VGA_FIXED));
 	pm2_WR(p, PM2R_BYPASS_WRITE_MASK, ~(0L));
 	pm2_WR(p, PM2R_FRAMEBUFFER_WRITE_MASK, ~(0L));
 	pm2_WR(p, PM2R_FIFO_CONTROL, 0);
@@ -409,16 +385,21 @@ static void reset_config(struct pm2fb_pa
 		pm2_RDAC_WR(p, PM2I_RD_MODE_CONTROL, 0); /* no overlay */
 		pm2_RDAC_WR(p, PM2I_RD_CURSOR_CONTROL, 0);
 		pm2_RDAC_WR(p, PM2I_RD_MISC_CONTROL, PM2F_RD_PALETTE_WIDTH_8);
+		pm2_RDAC_WR(p, PM2I_RD_COLOR_KEY_CONTROL, 0);
+		pm2_RDAC_WR(p, PM2I_RD_OVERLAY_KEY, 0);
+		pm2_RDAC_WR(p, PM2I_RD_RED_KEY, 0);
+		pm2_RDAC_WR(p, PM2I_RD_GREEN_KEY, 0);
+		pm2_RDAC_WR(p, PM2I_RD_BLUE_KEY, 0);
 		break;
 	case PM2_TYPE_PERMEDIA2V:
 		pm2v_RDAC_WR(p, PM2VI_RD_MISC_CONTROL, 1); /* 8bit */
+		pm2v_RDAC_WR(p, PM2I_RD_COLOR_KEY_CONTROL, 0);
+		pm2v_RDAC_WR(p, PM2I_RD_OVERLAY_KEY, 0);
+		pm2v_RDAC_WR(p, PM2I_RD_RED_KEY, 0);
+		pm2v_RDAC_WR(p, PM2I_RD_GREEN_KEY, 0);
+		pm2v_RDAC_WR(p, PM2I_RD_BLUE_KEY, 0);
 		break;
 	}
-	pm2_RDAC_WR(p, PM2I_RD_COLOR_KEY_CONTROL, 0);
-	pm2_RDAC_WR(p, PM2I_RD_OVERLAY_KEY, 0);
-	pm2_RDAC_WR(p, PM2I_RD_RED_KEY, 0);
-	pm2_RDAC_WR(p, PM2I_RD_GREEN_KEY, 0);
-	pm2_RDAC_WR(p, PM2I_RD_BLUE_KEY, 0);
 }
 
 static void set_aperture(struct pm2fb_par* p, u32 depth)
@@ -428,7 +409,7 @@ static void set_aperture(struct pm2fb_pa
 	 * hosts, the on-chip aperture settings are used where
 	 * possible to translate from host to card byte order.
 	 */
-	WAIT_FIFO(p, 4);
+	WAIT_FIFO(p, 2);
 #ifdef __LITTLE_ENDIAN
 	pm2_WR(p, PM2R_APERTURE_ONE, PM2F_APERTURE_STANDARD);
 #else
@@ -476,7 +457,7 @@ static void set_memclock(struct pm2fb_pa
 	switch (par->type) {
 	case PM2_TYPE_PERMEDIA2V:
 		pm2v_mnp(clk/2, &m, &n, &p);
-		WAIT_FIFO(par, 8);
+		WAIT_FIFO(par, 12);
 		pm2_WR(par, PM2VR_RD_INDEX_HIGH, PM2VI_RD_MCLK_CONTROL >> 8);
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_CONTROL, 0);
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_PRESCALE, m);
@@ -484,10 +465,9 @@ static void set_memclock(struct pm2fb_pa
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_POSTSCALE, p);
 		pm2v_RDAC_WR(par, PM2VI_RD_MCLK_CONTROL, 1);
 		rmb();
-		for (i = 256;
-		     i && !(pm2_RDAC_RD(par, PM2VI_RD_MCLK_CONTROL) & 2);
-		     i--)
-			;
+		for (i = 256; i; i--)
+			if (pm2v_RDAC_RD(par, PM2VI_RD_MCLK_CONTROL) & 2)
+				break;
 		pm2_WR(par, PM2VR_RD_INDEX_HIGH, 0);
 		break;
 	case PM2_TYPE_PERMEDIA2:
@@ -499,10 +479,9 @@ static void set_memclock(struct pm2fb_pa
 		pm2_RDAC_WR(par, PM2I_RD_MEMORY_CLOCK_3, 8|p);
 		pm2_RDAC_RD(par, PM2I_RD_MEMORY_CLOCK_STATUS);
 		rmb();
-		for (i = 256;
-		     i && !(pm2_RD(par, PM2R_RD_INDEXED_DATA) & PM2F_PLL_LOCKED);
-		     i--)
-			;
+		for (i = 256; i; i--)
+			if (pm2_RD(par, PM2R_RD_INDEXED_DATA) & PM2F_PLL_LOCKED)
+				break;
 		break;
 	}
 }
@@ -515,17 +494,16 @@ static void set_pixclock(struct pm2fb_pa
 	switch (par->type) {
 	case PM2_TYPE_PERMEDIA2:
 		pm2_mnp(clk, &m, &n, &p);
-		WAIT_FIFO(par, 8);
+		WAIT_FIFO(par, 10);
 		pm2_RDAC_WR(par, PM2I_RD_PIXEL_CLOCK_A3, 0);
 		pm2_RDAC_WR(par, PM2I_RD_PIXEL_CLOCK_A1, m);
 		pm2_RDAC_WR(par, PM2I_RD_PIXEL_CLOCK_A2, n);
 		pm2_RDAC_WR(par, PM2I_RD_PIXEL_CLOCK_A3, 8|p);
 		pm2_RDAC_RD(par, PM2I_RD_PIXEL_CLOCK_STATUS);
 		rmb();
-		for (i = 256;
-		     i && !(pm2_RD(par, PM2R_RD_INDEXED_DATA) & PM2F_PLL_LOCKED);
-		     i--)
-			;
+		for (i = 256; i; i--)
+			if (pm2_RD(par, PM2R_RD_INDEXED_DATA) & PM2F_PLL_LOCKED)
+				break;
 		break;
 	case PM2_TYPE_PERMEDIA2V:
 		pm2v_mnp(clk/2, &m, &n, &p);
@@ -541,9 +519,7 @@ static void set_pixclock(struct pm2fb_pa
 
 static void set_video(struct pm2fb_par* p, u32 video) {
 	u32 tmp;
-	u32 vsync;
-
-	vsync = video;
+	u32 vsync = video;
 
 	DPRINTK("video = 0x%x\n", video);
 
@@ -553,8 +529,8 @@ static void set_video(struct pm2fb_par* 
 	 * driver may well. So always set +hsync/+vsync and then set
 	 * the RAMDAC to invert the sync if necessary.
 	 */
-	vsync &= ~(PM2F_HSYNC_MASK|PM2F_VSYNC_MASK);
-	vsync |= PM2F_HSYNC_ACT_HIGH|PM2F_VSYNC_ACT_HIGH;
+	vsync &= ~(PM2F_HSYNC_MASK | PM2F_VSYNC_MASK);
+	vsync |= PM2F_HSYNC_ACT_HIGH | PM2F_VSYNC_ACT_HIGH;
 
 	WAIT_FIFO(p, 5);
 	pm2_WR(p, PM2R_VIDEO_CONTROL, vsync);
@@ -581,10 +557,6 @@ static void set_video(struct pm2fb_par* 
 }
 
 /*
- *
- */
-
-/**
  *	pm2fb_check_var - Optional function. Validates a var passed in.
  *	@var: frame buffer variable screen structure
  *	@info: frame buffer structure that represents a single frame buffer
@@ -625,7 +597,7 @@ static int pm2fb_check_var(struct fb_var
 	}
 
 	var->xres = (var->xres + 15) & ~15; /* could sometimes be 8 */
-	lpitch = var->xres * ((var->bits_per_pixel + 7)>>3);
+	lpitch = var->xres * ((var->bits_per_pixel + 7) >> 3);
 
 	if (var->xres < 320 || var->xres > 1600) {
 		DPRINTK("width not supported: %u\n", var->xres);
@@ -702,7 +674,9 @@ static int pm2fb_set_par(struct fb_info 
 {
 	struct pm2fb_par *par = info->par;
 	u32 pixclock;
-	u32 width, height, depth;
+	u32 width = (info->var.xres_virtual + 7) & ~7;
+	u32 height = info->var.yres_virtual;
+	u32 depth = (info->var.bits_per_pixel + 7) & ~7;
 	u32 hsstart, hsend, hbend, htotal;
 	u32 vsstart, vsend, vbend, vtotal;
 	u32 stride;
@@ -712,22 +686,18 @@ static int pm2fb_set_par(struct fb_info 
 	u32 txtmap = 0;
 	u32 pixsize = 0;
 	u32 clrformat = 0;
-	u32 xres;
+	u32 xres = (info->var.xres + 31) & ~31;
 	int data64;
 
 	reset_card(par);
 	reset_config(par);
 	clear_palette(par);
-	if ( par->memclock )
+	if (par->memclock)
 		set_memclock(par, par->memclock);
 
-	width = (info->var.xres_virtual + 7) & ~7;
-	height = info->var.yres_virtual;
-	depth = (info->var.bits_per_pixel + 7) & ~7;
 	depth = (depth > 32) ? 32 : depth;
 	data64 = depth > 8 || par->type == PM2_TYPE_PERMEDIA2V;
 
-	xres = (info->var.xres + 31) & ~31;
 	pixclock = PICOS2KHZ(info->var.pixclock);
 	if (pixclock > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%uKHz)\n", pixclock);
@@ -767,13 +737,13 @@ static int pm2fb_set_par(struct fb_info 
 	}
 	else
 		video |= PM2F_VSYNC_ACT_LOW;
-	if ((info->var.vmode & FB_VMODE_MASK)==FB_VMODE_INTERLACED) {
+	if ((info->var.vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED) {
 		DPRINTK("interlaced not supported\n");
 		return -EINVAL;
 	}
-	if ((info->var.vmode & FB_VMODE_MASK)==FB_VMODE_DOUBLE)
+	if ((info->var.vmode & FB_VMODE_MASK) == FB_VMODE_DOUBLE)
 		video |= PM2F_LINE_DOUBLE;
-	if ((info->var.activate & FB_ACTIVATE_MASK)==FB_ACTIVATE_NOW)
+	if ((info->var.activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW)
 		video |= PM2F_VIDEO_ENABLE;
 	par->video = video;
 
@@ -794,8 +764,6 @@ static int pm2fb_set_par(struct fb_info 
 
 	mb();
 	WAIT_FIFO(par, 19);
-	pm2_RDAC_WR(par, PM2I_RD_COLOR_KEY_CONTROL,
-		    ( depth == 8 ) ? 0 : PM2F_COLOR_KEY_TEST_OFF);
 	switch (depth) {
 	case 8:
 		pm2_WR(par, PM2R_FB_READ_PIXEL, 0);
@@ -845,14 +813,18 @@ static int pm2fb_set_par(struct fb_info 
 	pm2_WR(par, PM2R_SCREEN_BASE, base);
 	wmb();
 	set_video(par, video);
-	WAIT_FIFO(par, 4);
+	WAIT_FIFO(par, 6);
 	switch (par->type) {
 	case PM2_TYPE_PERMEDIA2:
 		pm2_RDAC_WR(par, PM2I_RD_COLOR_MODE, clrmode);
+		pm2_RDAC_WR(par, PM2I_RD_COLOR_KEY_CONTROL,
+			        (depth == 8) ? 0 : PM2F_COLOR_KEY_TEST_OFF);
 		break;
 	case PM2_TYPE_PERMEDIA2V:
 		pm2v_RDAC_WR(par, PM2VI_RD_PIXEL_SIZE, pixsize);
 		pm2v_RDAC_WR(par, PM2VI_RD_COLOR_FORMAT, clrformat);
+		pm2v_RDAC_WR(par, PM2I_RD_COLOR_KEY_CONTROL,
+			         (depth == 8) ? 0 : PM2F_COLOR_KEY_TEST_OFF);
 		break;
 	}
 	set_pixclock(par, pixclock);
@@ -983,11 +955,9 @@ static int pm2fb_pan_display(struct fb_v
 {
 	struct pm2fb_par *p = info->par;
 	u32 base;
-	u32 depth;
-	u32 xres;
+	u32 depth = (var->bits_per_pixel + 7) & ~7;
+	u32 xres = (var->xres + 31) & ~31;
 
-	xres = (var->xres + 31) & ~31;
-	depth = (var->bits_per_pixel + 7) & ~7;
 	depth = (depth > 32) ? 32 : depth;
 	base = to3264(var->yoffset * xres + var->xoffset, depth, 1);
 	WAIT_FIFO(p, 1);
@@ -1029,11 +999,11 @@ static int pm2fb_blank(int blank_mode, s
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
 		/* VSync: Off */
-		video &= ~(PM2F_VSYNC_MASK | PM2F_BLANK_LOW );
+		video &= ~(PM2F_VSYNC_MASK | PM2F_BLANK_LOW);
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
 		/* HSync: Off */
-		video &= ~(PM2F_HSYNC_MASK | PM2F_BLANK_LOW );
+		video &= ~(PM2F_HSYNC_MASK | PM2F_BLANK_LOW);
 		break;
 	case FB_BLANK_POWERDOWN:
 		/* HSync: Off, VSync: Off */
@@ -1060,37 +1030,10 @@ static int pm2fb_sync(struct fb_info *in
 	return 0;
 }
 
-/*
- * block operation. copy=0: rectangle fill, copy=1: rectangle copy.
- */
-static void pm2fb_block_op(struct fb_info* info, int copy,
-				s32 xsrc, s32 ysrc,
-				s32 x, s32 y, s32 w, s32 h,
-				u32 color) {
-	struct pm2fb_par *par = info->par;
-
-	if (!w || !h)
-		return;
-	WAIT_FIFO(par, 5);
-	pm2_WR(par, PM2R_CONFIG, PM2F_CONFIG_FB_WRITE_ENABLE |
-		PM2F_CONFIG_FB_READ_SOURCE_ENABLE);
-	if (copy)
-		pm2_WR(par, PM2R_FB_SOURCE_DELTA,
-			((ysrc-y) & 0xfff) << 16 | ((xsrc-x) & 0xfff));
-	else
-		pm2_WR(par, PM2R_FB_BLOCK_COLOR, color);
-	pm2_WR(par, PM2R_RECTANGLE_ORIGIN, (y << 16) | x);
-	pm2_WR(par, PM2R_RECTANGLE_SIZE, (h << 16) | w);
-	wmb();
-	pm2_WR(par, PM2R_RENDER, PM2F_RENDER_RECTANGLE |
-				(x<xsrc ? PM2F_INCREASE_X : 0) |
-				(y<ysrc ? PM2F_INCREASE_Y : 0) |
-				(copy ? 0 : PM2F_RENDER_FASTFILL));
-}
-
 static void pm2fb_fillrect (struct fb_info *info,
 				const struct fb_fillrect *region)
 {
+  	struct pm2fb_par *par = info->par;
 	struct fb_fillrect modded;
 	int vxres, vyres;
 	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
@@ -1109,31 +1052,39 @@ static void pm2fb_fillrect (struct fb_in
 
 	memcpy(&modded, region, sizeof(struct fb_fillrect));
 
-	if(!modded.width || !modded.height ||
-	   modded.dx >= vxres || modded.dy >= vyres)
+	if (!modded.width || !modded.height ||
+	    modded.dx >= vxres || modded.dy >= vyres)
 		return;
 
-	if(modded.dx + modded.width  > vxres)
+	if (modded.dx + modded.width  > vxres)
 		modded.width  = vxres - modded.dx;
-	if(modded.dy + modded.height > vyres)
+	if (modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
-	if(info->var.bits_per_pixel == 8)
+	if (info->var.bits_per_pixel == 8)
 		color |= color << 8;
-	if(info->var.bits_per_pixel <= 16)
+	if (info->var.bits_per_pixel <= 16)
 		color |= color << 16;
 
-	if(info->var.bits_per_pixel != 24)
-		pm2fb_block_op(info, 0, 0, 0,
-				modded.dx, modded.dy,
-				modded.width, modded.height, color);
-	else
+	WAIT_FIFO(par, 3);
+	pm2_WR(par, PM2R_CONFIG, PM2F_CONFIG_FB_WRITE_ENABLE);
+	pm2_WR(par, PM2R_RECTANGLE_ORIGIN, (modded.dy << 16) | modded.dx);
+	pm2_WR(par, PM2R_RECTANGLE_SIZE, (modded.height << 16) | modded.width);
+	if (info->var.bits_per_pixel != 24) {
+		WAIT_FIFO(par, 2);
+		pm2_WR(par, PM2R_FB_BLOCK_COLOR, color);
+		wmb();
+		pm2_WR(par, PM2R_RENDER,
+				PM2F_RENDER_RECTANGLE | PM2F_RENDER_FASTFILL);
+	} else {
 		cfb_fillrect(info, region);
+	}
 }
 
 static void pm2fb_copyarea(struct fb_info *info,
 				const struct fb_copyarea *area)
 {
+	struct pm2fb_par *par = info->par;
 	struct fb_copyarea modded;
 	u32 vxres, vyres;
 
@@ -1149,23 +1100,32 @@ static void pm2fb_copyarea(struct fb_inf
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
 
-	if(!modded.width || !modded.height ||
-	   modded.sx >= vxres || modded.sy >= vyres ||
-	   modded.dx >= vxres || modded.dy >= vyres)
+	if (!modded.width || !modded.height ||
+	    modded.sx >= vxres || modded.sy >= vyres ||
+	    modded.dx >= vxres || modded.dy >= vyres)
 		return;
 
-	if(modded.sx + modded.width > vxres)
+	if (modded.sx + modded.width > vxres)
 		modded.width = vxres - modded.sx;
-	if(modded.dx + modded.width > vxres)
+	if (modded.dx + modded.width > vxres)
 		modded.width = vxres - modded.dx;
-	if(modded.sy + modded.height > vyres)
+	if (modded.sy + modded.height > vyres)
 		modded.height = vyres - modded.sy;
-	if(modded.dy + modded.height > vyres)
+	if (modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
-	pm2fb_block_op(info, 1, modded.sx, modded.sy,
-			modded.dx, modded.dy,
-			modded.width, modded.height, 0);
+	WAIT_FIFO(par, 5);
+	pm2_WR(par, PM2R_CONFIG, PM2F_CONFIG_FB_WRITE_ENABLE |
+		PM2F_CONFIG_FB_READ_SOURCE_ENABLE);
+	pm2_WR(par, PM2R_FB_SOURCE_DELTA,
+			((modded.sy-modded.dy) & 0xfff) << 16 |
+			((modded.sx-modded.dx) & 0xfff));
+	pm2_WR(par, PM2R_RECTANGLE_ORIGIN, (modded.dy << 16) | modded.dx);
+	pm2_WR(par, PM2R_RECTANGLE_SIZE, (modded.height << 16) | modded.width);
+	wmb();
+	pm2_WR(par, PM2R_RENDER, PM2F_RENDER_RECTANGLE |
+				(modded.dx<modded.sx ? PM2F_INCREASE_X : 0) |
+				(modded.dy<modded.sy ? PM2F_INCREASE_Y : 0));
 }
 
 static void pm2fb_imageblit(struct fb_info *info, const struct fb_image *image)
@@ -1183,15 +1143,15 @@ static void pm2fb_imageblit(struct fb_in
 		return;
 	}
 	switch (info->fix.visual) {
-		case FB_VISUAL_PSEUDOCOLOR:
-			fgx = image->fg_color;
-			bgx = image->bg_color;
-			break;
-		case FB_VISUAL_TRUECOLOR:
-		default:
-			fgx = par->palette[image->fg_color];
-			bgx = par->palette[image->bg_color];
-			break;
+	case FB_VISUAL_PSEUDOCOLOR:
+		fgx = image->fg_color;
+		bgx = image->bg_color;
+		break;
+	case FB_VISUAL_TRUECOLOR:
+	default:
+		fgx = par->palette[image->fg_color];
+		bgx = par->palette[image->bg_color];
+		break;
 	}
 	if (info->var.bits_per_pixel == 8) {
 		fgx |= fgx << 8;
@@ -1211,7 +1171,7 @@ static void pm2fb_imageblit(struct fb_in
 			((image->dx + image->width) & 0x0fff));
 	pm2_WR(par, PM2R_SCISSOR_MODE, 1);
 	/* GXcopy & UNIT_ENABLE */
-	pm2_WR(par, PM2R_LOGICAL_OP_MODE, (0x3 << 1) | 1 );
+	pm2_WR(par, PM2R_LOGICAL_OP_MODE, (0x3 << 1) | 1);
 	pm2_WR(par, PM2R_RECTANGLE_ORIGIN,
 			((image->dy & 0xfff) << 16) | (image->dx & 0x0fff));
 	pm2_WR(par, PM2R_RECTANGLE_SIZE,
@@ -1223,10 +1183,10 @@ static void pm2fb_imageblit(struct fb_in
 		pm2_WR(par, PM2R_CONSTANT_COLOR, bgx);
 		pm2_WR(par, PM2R_RENDER,
 			PM2F_RENDER_RECTANGLE |
-			PM2F_INCREASE_X | PM2F_INCREASE_Y );
+			PM2F_INCREASE_X | PM2F_INCREASE_Y);
 		/* BitMapPackEachScanline & invert bits and byte order*/
 		/* force background */
-		pm2_WR(par, PM2R_RASTERIZER_MODE,  (1<<9) | 1 | (3<<7));
+		pm2_WR(par, PM2R_RASTERIZER_MODE,  (1 << 9) | 1 | (3 << 7));
 		pm2_WR(par, PM2R_CONSTANT_COLOR, fgx);
 		pm2_WR(par, PM2R_RENDER,
 			PM2F_RENDER_RECTANGLE |
@@ -1239,9 +1199,9 @@ static void pm2fb_imageblit(struct fb_in
 		pm2_WR(par, PM2R_RENDER,
 			PM2F_RENDER_RECTANGLE |
 			PM2F_RENDER_FASTFILL |
-			PM2F_INCREASE_X | PM2F_INCREASE_Y );
+			PM2F_INCREASE_X | PM2F_INCREASE_Y);
 		/* invert bits and byte order*/
-		pm2_WR(par, PM2R_RASTERIZER_MODE,  1 | (3<<7) );
+		pm2_WR(par, PM2R_RASTERIZER_MODE,  1 | (3 << 7));
 		pm2_WR(par, PM2R_FB_BLOCK_COLOR, fgx);
 		pm2_WR(par, PM2R_RENDER,
 			PM2F_RENDER_RECTANGLE |
@@ -1306,13 +1266,13 @@ static int __devinit pm2fb_probe(struct 
 	int err, err_retval = -ENXIO;
 
 	err = pci_enable_device(pdev);
-	if ( err ) {
+	if (err) {
 		printk(KERN_WARNING "pm2fb: Can't enable pdev: %d\n", err);
 		return err;
 	}
 
 	info = framebuffer_alloc(sizeof(struct pm2fb_par), &pdev->dev);
-	if ( !info )
+	if (!info)
 		return -ENOMEM;
 	default_par = info->par;
 
@@ -1345,14 +1305,14 @@ static int __devinit pm2fb_probe(struct 
 	DPRINTK("Register base at 0x%lx\n", pm2fb_fix.mmio_start);
 
 	/* Registers - request region and map it. */
-	if ( !request_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len,
-				 "pm2fb regbase") ) {
+	if (!request_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len,
+				"pm2fb regbase")) {
 		printk(KERN_WARNING "pm2fb: Can't reserve regbase.\n");
 		goto err_exit_neither;
 	}
 	default_par->v_regs =
 		ioremap_nocache(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len);
-	if ( !default_par->v_regs ) {
+	if (!default_par->v_regs) {
 		printk(KERN_WARNING "pm2fb: Can't remap %s register area.\n",
 		       pm2fb_fix.id);
 		release_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len);
@@ -1367,13 +1327,13 @@ static int __devinit pm2fb_probe(struct 
 		default_par->mem_control, default_par->boot_address,
 		default_par->mem_config);
 
-	if(default_par->mem_control == 0 &&
+	if (default_par->mem_control == 0 &&
 		default_par->boot_address == 0x31 &&
 		default_par->mem_config == 0x259fffff) {
 		default_par->memclock = CVPPC_MEMCLOCK;
-		default_par->mem_control=0;
-		default_par->boot_address=0x20;
-		default_par->mem_config=0xe6002021;
+		default_par->mem_control = 0;
+		default_par->boot_address = 0x20;
+		default_par->mem_config = 0xe6002021;
 		if (pdev->subsystem_vendor == 0x1048 &&
 			pdev->subsystem_device == 0x0a31) {
 			DPRINTK("subsystem_vendor: %04x, subsystem_device: %04x\n",
@@ -1381,7 +1341,7 @@ static int __devinit pm2fb_probe(struct 
 			DPRINTK("We have not been initialized by VGA BIOS "
 				"and are running on an Elsa Winner 2000 Office\n");
 			DPRINTK("Initializing card timings manually...\n");
-			default_par->memclock=70000;
+			default_par->memclock = 70000;
 		}
 		if (pdev->subsystem_vendor == 0x3d3d &&
 			pdev->subsystem_device == 0x0100) {
@@ -1390,36 +1350,36 @@ static int __devinit pm2fb_probe(struct 
 			DPRINTK("We have not been initialized by VGA BIOS "
 				"and are running on an 3dlabs reference board\n");
 			DPRINTK("Initializing card timings manually...\n");
-			default_par->memclock=74894;
+			default_par->memclock = 74894;
 		}
 	}
 
 	/* Now work out how big lfb is going to be. */
 	switch(default_par->mem_config & PM2F_MEM_CONFIG_RAM_MASK) {
 	case PM2F_MEM_BANKS_1:
-		pm2fb_fix.smem_len=0x200000;
+		pm2fb_fix.smem_len = 0x200000;
 		break;
 	case PM2F_MEM_BANKS_2:
-		pm2fb_fix.smem_len=0x400000;
+		pm2fb_fix.smem_len = 0x400000;
 		break;
 	case PM2F_MEM_BANKS_3:
-		pm2fb_fix.smem_len=0x600000;
+		pm2fb_fix.smem_len = 0x600000;
 		break;
 	case PM2F_MEM_BANKS_4:
-		pm2fb_fix.smem_len=0x800000;
+		pm2fb_fix.smem_len = 0x800000;
 		break;
 	}
 	pm2fb_fix.smem_start = pci_resource_start(pdev, 1);
 
 	/* Linear frame buffer - request region and map it. */
-	if ( !request_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len,
-				 "pm2fb smem") ) {
+	if (!request_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len,
+				"pm2fb smem")) {
 		printk(KERN_WARNING "pm2fb: Can't reserve smem.\n");
 		goto err_exit_mmio;
 	}
 	info->screen_base =
 		ioremap_nocache(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
-	if ( !info->screen_base ) {
+	if (!info->screen_base) {
 		printk(KERN_WARNING "pm2fb: Can't ioremap smem area.\n");
 		release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
 		goto err_exit_mmio;
@@ -1571,9 +1531,9 @@ static int __init pm2fb_setup(char *opti
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
-		if(!strcmp(this_opt, "lowhsync")) {
+		if (!strcmp(this_opt, "lowhsync")) {
 			lowhsync = 1;
-		} else if(!strcmp(this_opt, "lowvsync")) {
+		} else if (!strcmp(this_opt, "lowvsync")) {
 			lowvsync = 1;
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
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
