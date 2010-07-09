From: akpm@linux-foundation.org
Subject: + s3c-fb-initial-move-to-unifying-the-header-files.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:08:52 -0700
Message-ID: <201007092308.o69N8qKB030952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611Ab0GIXJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, inki.dae@samsung.com, m.szyprowski@samsung.com, p.osciak@samsung.com


The patch titled
     s3c-fb: initial move to unifying the header files
has been added to the -mm tree.  Its filename is
     s3c-fb-initial-move-to-unifying-the-header-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c-fb: initial move to unifying the header files
From: Ben Dooks <ben-linux@fluff.org>

Remove the various header files that configure this driver and use the
platform device name to select the correct configuration at probe time.

Currently this does not remove the header files, only updates the driver
and the relevant platform files.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: KyungMin Park <kyungmin.park.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c64xx/include/mach/regs-fb.h    |   20 -
 arch/arm/mach-s5pc100/include/mach/regs-fb.h    |   34 --
 arch/arm/plat-samsung/include/plat/regs-fb-v4.h |   36 --
 drivers/video/s3c-fb.c                          |  208 ++++++++++++--
 4 files changed, 180 insertions(+), 118 deletions(-)

diff -puN arch/arm/mach-s3c64xx/include/mach/regs-fb.h~s3c-fb-initial-move-to-unifying-the-header-files arch/arm/mach-s3c64xx/include/mach/regs-fb.h
--- a/arch/arm/mach-s3c64xx/include/mach/regs-fb.h~s3c-fb-initial-move-to-unifying-the-header-files
+++ a/arch/arm/mach-s3c64xx/include/mach/regs-fb.h
@@ -18,24 +18,4 @@
 
 #include <plat/regs-fb-v4.h>
 
-/* Palette registers */
-#define WIN2_PAL(_entry)			(0x300 + ((_entry) * 2))
-#define WIN3_PAL(_entry)			(0x320 + ((_entry) * 2))
-#define WIN4_PAL(_entry)			(0x340 + ((_entry) * 2))
-#define WIN0_PAL(_entry)			(0x400 + ((_entry) * 4))
-#define WIN1_PAL(_entry)			(0x800 + ((_entry) * 4))
-
-static inline unsigned int s3c_fb_pal_reg(unsigned int window, int reg)
-{
-	switch (window) {
-	case 0: return WIN0_PAL(reg);
-	case 1: return WIN1_PAL(reg);
-	case 2: return WIN2_PAL(reg);
-	case 3: return WIN3_PAL(reg);
-	case 4: return WIN4_PAL(reg);
-	}
-
-	BUG();
-}
-
 #endif /* __ASM_ARCH_MACH_REGS_FB_H */
diff -puN arch/arm/mach-s5pc100/include/mach/regs-fb.h~s3c-fb-initial-move-to-unifying-the-header-files arch/arm/mach-s5pc100/include/mach/regs-fb.h
--- a/arch/arm/mach-s5pc100/include/mach/regs-fb.h~s3c-fb-initial-move-to-unifying-the-header-files
+++ a/arch/arm/mach-s5pc100/include/mach/regs-fb.h
@@ -100,40 +100,6 @@
 #define BLENDCON					(0x260)
 #define BLENDCON_8BIT_ALPHA				(1 << 0)
 
-/* Per-window palette base addresses (start of palette memory).
- * Each window palette area consists of 256 32-bit entries.
- * START is the first address (entry 0th), END is the address of 255th entry.
- */
-#define WIN0_PAL_BASE					(0x2400)
-#define WIN0_PAL_END					(0x27fc)
-#define WIN1_PAL_BASE					(0x2800)
-#define WIN1_PAL_END					(0x2bfc)
-#define WIN2_PAL_BASE					(0x2c00)
-#define WIN2_PAL_END					(0x2ffc)
-#define WIN3_PAL_BASE					(0x3000)
-#define WIN3_PAL_END					(0x33fc)
-#define WIN4_PAL_BASE					(0x3400)
-#define WIN4_PAL_END					(0x37fc)
-
-#define WIN0_PAL(_entry)			(WIN0_PAL_BASE + ((_entry) * 4))
-#define WIN1_PAL(_entry)			(WIN1_PAL_BASE + ((_entry) * 4))
-#define WIN2_PAL(_entry)			(WIN2_PAL_BASE + ((_entry) * 4))
-#define WIN3_PAL(_entry)			(WIN3_PAL_BASE + ((_entry) * 4))
-#define WIN4_PAL(_entry)			(WIN4_PAL_BASE + ((_entry) * 4))
-
-static inline unsigned int s3c_fb_pal_reg(unsigned int window, int reg)
-{
-	switch (window) {
-	case 0: return WIN0_PAL(reg);
-	case 1: return WIN1_PAL(reg);
-	case 2: return WIN2_PAL(reg);
-	case 3: return WIN3_PAL(reg);
-	case 4: return WIN4_PAL(reg);
-	}
-
-	BUG();
-}
-
 
 #endif /* __ASM_ARCH_REGS_FB_H */
 
diff -puN arch/arm/plat-samsung/include/plat/regs-fb-v4.h~s3c-fb-initial-move-to-unifying-the-header-files arch/arm/plat-samsung/include/plat/regs-fb-v4.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb-v4.h~s3c-fb-initial-move-to-unifying-the-header-files
+++ a/arch/arm/plat-samsung/include/plat/regs-fb-v4.h
@@ -148,42 +148,6 @@
  * compiled.
 */
 
-/* return true if window _win has OSD register D */
-#define s3c_fb_has_osd_d(_win) ((_win) != 4 && (_win) != 0)
-
-static inline unsigned int s3c_fb_win_pal_size(unsigned int win)
-{
-	if (win < 2)
-		return 256;
-	if (win < 4)
-		return 16;
-	if (win == 4)
-		return 4;
-
-	BUG();	/* shouldn't get here */
-}
-
-static inline int s3c_fb_validate_win_bpp(unsigned int win, unsigned int bpp)
-{
-	/* all windows can do 1/2 bpp */
-
-	if ((bpp == 25 || bpp == 19) && win == 0)
-		return 0;	/* win 0 does not have 19 or 25bpp modes */
-
-	if (bpp == 4 && win == 4)
-		return 0;
-
-	if (bpp == 8 && (win >= 3))
-		return 0;	/* win 3/4 cannot do 8bpp in any mode */
-
-	return 1;
-}
-
-static inline int s3c_fb_pal_is16(unsigned int window)
-{
-	return window > 1;
-}
-
 struct s3c_fb_palette {
 	struct fb_bitfield	r;
 	struct fb_bitfield	g;
diff -puN drivers/video/s3c-fb.c~s3c-fb-initial-move-to-unifying-the-header-files drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-initial-move-to-unifying-the-header-files
+++ a/drivers/video/s3c-fb.c
@@ -1,7 +1,7 @@
 /* linux/drivers/video/s3c-fb.c
  *
  * Copyright 2008 Openmoko Inc.
- * Copyright 2008 Simtec Electronics
+ * Copyright 2008-2010 Simtec Electronics
  *      Ben Dooks <ben@simtec.co.uk>
  *      http://armlinux.simtec.co.uk/
  *
@@ -36,9 +36,9 @@
  * output timings and as the control for the output power-down state.
 */
 
-/* note, some of the functions that get called are derived from including
- * <mach/regs-fb.h> as they are specific to the architecture that the code
- * is being built for.
+/* note, the previous use of <mach/regs-fb.h> to get platform specific data
+ * has been replaced by using the platform device name to pick the correct
+ * configuration data for the system.
 */
 
 #ifdef CONFIG_FB_S3C_DEBUG_REGWRITE
@@ -50,11 +50,52 @@
 
 struct s3c_fb;
 
+#define VALID_BPP(x) (1 << ((x) - 1))
+
+/**
+ * struct s3c_fb_variant - fb variant information
+ * @nr_windows: The number of windows.
+ * @palette: Address of palette memory, or 0 if none.
+ */
+struct s3c_fb_variant {
+	unsigned short	nr_windows;
+	unsigned short	palette[S3C_FB_MAX_WIN];
+};
+
+/**
+ * struct s3c_fb_win_variant
+ * @has_osd_c: Set if has OSD C register.
+ * @has_osd_d: Set if has OSD D register.
+ * @palette_sz: Size of palette in entries.
+ * @palette_16bpp: Set if palette is 16bits wide.
+ * @valid_bpp: 1 bit per BPP setting to show valid bits-per-pixel.
+ *
+ * valid_bpp bit x is set if (x+1)BPP is supported.
+ */
+struct s3c_fb_win_variant {
+	unsigned int	has_osd_c:1;
+	unsigned int	has_osd_d:1;
+	unsigned int	palette_16bpp:1;
+	unsigned short	palette_sz;
+	u32		valid_bpp;
+};
+
+/**
+ * struct s3c_fb_driverdata - per-device type driver data for init time.
+ * @variant: The variant information for this driver.
+ * @win: The window information for each window.
+ */
+struct s3c_fb_driverdata {
+	struct s3c_fb_variant	variant;
+	struct s3c_fb_win_variant *win[S3C_FB_MAX_WIN];
+};
+
 /**
  * struct s3c_fb_win - per window private data for each framebuffer.
  * @windata: The platform data supplied for the window configuration.
  * @parent: The hardware that this window is part of.
  * @fbinfo: Pointer pack to the framebuffer info for this window.
+ * @varint: The variant information for this window.
  * @palette_buffer: Buffer/cache to hold palette entries.
  * @pseudo_palette: For use in TRUECOLOUR modes for entries 0..15/
  * @index: The window number of this window.
@@ -65,6 +106,7 @@ struct s3c_fb_win {
 	struct s3c_fb		*parent;
 	struct fb_info		*fbinfo;
 	struct s3c_fb_palette	 palette;
+	struct s3c_fb_win_variant variant;
 
 	u32			*palette_buffer;
 	u32			 pseudo_palette[16];
@@ -77,6 +119,7 @@ struct s3c_fb_win {
  * @regs_res: The resource we claimed for the IO registers.
  * @bus_clk: The clk (hclk) feeding our interface and possibly pixclk.
  * @regs: The mapped hardware registers.
+ * @variant: Variant information for this hardware.
  * @enabled: A bitmask of enabled hardware windows.
  * @pdata: The platform configuration data passed with the device.
  * @windows: The hardware windows that have been claimed.
@@ -86,6 +129,7 @@ struct s3c_fb {
 	struct resource		*regs_res;
 	struct clk		*bus_clk;
 	void __iomem		*regs;
+	struct s3c_fb_variant	 variant;
 
 	unsigned char		 enabled;
 
@@ -94,15 +138,13 @@ struct s3c_fb {
 };
 
 /**
- * s3c_fb_win_has_palette() - determine if a mode has a palette
- * @win: The window number being queried.
- * @bpp: The number of bits per pixel to test.
- *
- * Work out if the given window supports palletised data at the specified bpp.
+ * s3c_fb_validate_win_bpp - validate the bits-per-pixel for this mode.
+ * @win: The device window.
+ * @bpp: The bit depth.
  */
-static int s3c_fb_win_has_palette(unsigned int win, unsigned int bpp)
+static bool s3c_fb_validate_win_bpp(struct s3c_fb_win *win, unsigned int bpp)
 {
-	return s3c_fb_win_pal_size(win) <= (1 << bpp);
+	return win->variant.valid_bpp & VALID_BPP(bpp);
 }
 
 /**
@@ -125,7 +167,7 @@ static int s3c_fb_check_var(struct fb_va
 	var->xres_virtual = max((unsigned int)windata->virtual_x, var->xres);
 	var->yres_virtual = max((unsigned int)windata->virtual_y, var->yres);
 
-	if (!s3c_fb_validate_win_bpp(win->index, var->bits_per_pixel)) {
+	if (!s3c_fb_validate_win_bpp(win, var->bits_per_pixel)) {
 		dev_dbg(sfb->dev, "win %d: unsupported bpp %d\n",
 			win->index, var->bits_per_pixel);
 		return -EINVAL;
@@ -140,7 +182,7 @@ static int s3c_fb_check_var(struct fb_va
 	case 2:
 	case 4:
 	case 8:
-		if (!s3c_fb_win_has_palette(win->index, var->bits_per_pixel)) {
+		if (sfb->variant.palette[win->index] != 0) {
 			/* non palletised, A:1,R:2,G:3,B:2 mode */
 			var->red.offset		= 4;
 			var->green.offset	= 2;
@@ -282,7 +324,7 @@ static int s3c_fb_set_par(struct fb_info
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
 		break;
 	case 8:
-		if (s3c_fb_win_has_palette(win_no, 8))
+		if (win->variant.palette_sz >= 256)
 			info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
 		else
 			info->fix.visual = FB_VISUAL_TRUECOLOR;
@@ -364,7 +406,7 @@ static int s3c_fb_set_par(struct fb_info
 		VIDISD14C_ALPHA1_G(0xf) |
 		VIDISD14C_ALPHA1_B(0xf);
 
-	if (s3c_fb_has_osd_d(win_no)) {
+	if (win->variant.has_osd_d) {
 		writel(data, regs + VIDOSD_D(win_no));
 		writel(osdc_data, regs + VIDOSD_C(win_no));
 	} else
@@ -471,7 +513,7 @@ static void s3c_fb_update_palette(struct
 	void __iomem *palreg;
 	u32 palcon;
 
-	palreg = sfb->regs + s3c_fb_pal_reg(win->index, reg);
+	palreg = sfb->regs + sfb->variant.palette[win->index];
 
 	dev_dbg(sfb->dev, "%s: win %d, reg %d (%p): %08x\n",
 		__func__, win->index, reg, palreg, value);
@@ -481,10 +523,10 @@ static void s3c_fb_update_palette(struct
 	palcon = readl(sfb->regs + WPALCON);
 	writel(palcon | WPALCON_PAL_UPDATE, sfb->regs + WPALCON);
 
-	if (s3c_fb_pal_is16(win->index))
-		writew(value, palreg);
+	if (win->variant.palette_16bpp)
+		writew(value, palreg + (reg * 2));
 	else
-		writel(value, palreg);
+		writel(value, palreg + (reg * 4));
 
 	writel(palcon, sfb->regs + WPALCON);
 }
@@ -533,7 +575,7 @@ static int s3c_fb_setcolreg(unsigned reg
 		break;
 
 	case FB_VISUAL_PSEUDOCOLOR:
-		if (regno < s3c_fb_win_pal_size(win->index)) {
+		if (regno < win->variant.palette_sz) {
 			val  = chan_to_field(red, &win->palette.r);
 			val |= chan_to_field(green, &win->palette.g);
 			val |= chan_to_field(blue, &win->palette.b);
@@ -736,12 +778,14 @@ static void s3c_fb_release_win(struct s3
 /**
  * s3c_fb_probe_win() - register an hardware window
  * @sfb: The base resources for the hardware
+ * @variant: The variant information for this window.
  * @res: Pointer to where to place the resultant window.
  *
  * Allocate and do the basic initialisation for one of the hardware's graphics
  * windows.
  */
 static int __devinit s3c_fb_probe_win(struct s3c_fb *sfb, unsigned int win_no,
+				      struct s3c_fb_win_variant *variant,
 				      struct s3c_fb_win **res)
 {
 	struct fb_var_screeninfo *var;
@@ -754,7 +798,7 @@ static int __devinit s3c_fb_probe_win(st
 
 	dev_dbg(sfb->dev, "probing window %d\n", win_no);
 
-	palette_size = s3c_fb_win_pal_size(win_no);
+	palette_size = variant->palette_sz * 4;
 
 	fbinfo = framebuffer_alloc(sizeof(struct s3c_fb_win) +
 				   palette_size * sizeof(u32), sfb->dev);
@@ -772,6 +816,7 @@ static int __devinit s3c_fb_probe_win(st
 
 	win = fbinfo->par;
 	var = &fbinfo->var;
+	win->variant = *variant;
 	win->fbinfo = fbinfo;
 	win->parent = sfb;
 	win->windata = windata;
@@ -809,7 +854,7 @@ static int __devinit s3c_fb_probe_win(st
 
 	/* create initial colour map */
 
-	ret = fb_alloc_cmap(&fbinfo->cmap, s3c_fb_win_pal_size(win_no), 1);
+	ret = fb_alloc_cmap(&fbinfo->cmap, win->variant.palette_sz, 1);
 	if (ret == 0)
 		fb_set_cmap(&fbinfo->cmap, fbinfo);
 	else
@@ -852,6 +897,7 @@ static void s3c_fb_clear_win(struct s3c_
 
 static int __devinit s3c_fb_probe(struct platform_device *pdev)
 {
+	struct s3c_fb_driverdata *fbdrv;
 	struct device *dev = &pdev->dev;
 	struct s3c_fb_platdata *pd;
 	struct s3c_fb *sfb;
@@ -859,6 +905,13 @@ static int __devinit s3c_fb_probe(struct
 	int win;
 	int ret = 0;
 
+	fbdrv = (struct s3c_fb_driverdata *)platform_get_device_id(pdev)->driver_data;
+
+	if (fbdrv->variant.nr_windows > S3C_FB_MAX_WIN) {
+		dev_err(dev, "too many windows, cannot attach\n");
+		return -EINVAL;
+	}
+
 	pd = pdev->dev.platform_data;
 	if (!pd) {
 		dev_err(dev, "no platform data specified\n");
@@ -873,6 +926,7 @@ static int __devinit s3c_fb_probe(struct
 
 	sfb->dev = dev;
 	sfb->pdata = pd;
+	sfb->variant = fbdrv->variant;
 
 	sfb->bus_clk = clk_get(dev, "lcd");
 	if (IS_ERR(sfb->bus_clk)) {
@@ -914,22 +968,23 @@ static int __devinit s3c_fb_probe(struct
 
 	/* zero all windows before we do anything */
 
-	for (win = 0; win < S3C_FB_MAX_WIN; win++)
+	for (win = 0; win < fbdrv->variant.nr_windows; win++)
 		s3c_fb_clear_win(sfb, win);
 
 	/* initialise colour key controls */
-	for (win = 0; win < (S3C_FB_MAX_WIN - 1); win++) {
+	for (win = 0; win < (fbdrv->variant.nr_windows - 1); win++) {
 		writel(0xffffff, sfb->regs + WxKEYCONy(win, 0));
 		writel(0xffffff, sfb->regs + WxKEYCONy(win, 1));
 	}
 
 	/* we have the register setup, start allocating framebuffers */
 
-	for (win = 0; win < S3C_FB_MAX_WIN; win++) {
+	for (win = 0; win < fbdrv->variant.nr_windows; win++) {
 		if (!pd->win[win])
 			continue;
 
-		ret = s3c_fb_probe_win(sfb, win, &sfb->windows[win]);
+		ret = s3c_fb_probe_win(sfb, win, fbdrv->win[win],
+				       &sfb->windows[win]);
 		if (ret < 0) {
 			dev_err(dev, "failed to create window %d\n", win);
 			for (; win >= 0; win--)
@@ -1020,10 +1075,10 @@ static int s3c_fb_resume(struct platform
 	writel(pd->vidcon1, sfb->regs + VIDCON1);
 
 	/* zero all windows before we do anything */
-	for (win_no = 0; win_no < S3C_FB_MAX_WIN; win_no++)
+	for (win_no = 0; win_no < sfb->variant.nr_windows; win_no++)
 		s3c_fb_clear_win(sfb, win_no);
 
-	for (win_no = 0; win_no < S3C_FB_MAX_WIN - 1; win_no++) {
+	for (win_no = 0; win_no < sfb->variant.nr_windows - 1; win_no++) {
 		writel(0xffffff, sfb->regs + WxKEYCONy(win_no, 1));
 		writel(0xffffff, sfb->regs + WxKEYCONy(win_no, 1));
 	}
@@ -1045,11 +1100,108 @@ static int s3c_fb_resume(struct platform
 #define s3c_fb_resume  NULL
 #endif
 
+
+#define VALID_BPP124 (VALID_BPP(1) | VALID_BPP(2) | VALID_BPP(4))
+#define VALID_BPP1248 (VALID_BPP124 | VALID_BPP(8))
+
+static struct s3c_fb_win_variant s3c_fb_data_64xx_wins[] __devinitdata = {
+	[0] = {
+		.has_osd_c	= 1,
+		.palette_sz	= 256,
+		.valid_bpp	= VALID_BPP1248 | VALID_BPP(16) | VALID_BPP(24),
+	},
+	[1] = {
+		.has_osd_c	= 1,
+		.has_osd_d	= 1,
+		.palette_sz	= 256,
+		.valid_bpp	= (VALID_BPP1248 | VALID_BPP(16) |
+				   VALID_BPP(18) | VALID_BPP(19) |
+				   VALID_BPP(24) | VALID_BPP(25)),
+	},
+	[2] = {
+		.has_osd_c	= 1,
+		.has_osd_d	= 1,
+		.palette_sz	= 16,
+		.palette_16bpp	= 1,
+		.valid_bpp	= (VALID_BPP1248 | VALID_BPP(16) |
+				   VALID_BPP(18) | VALID_BPP(19) |
+				   VALID_BPP(24) | VALID_BPP(25)),
+	},
+	[3] = {
+		.has_osd_c	= 1,
+		.has_osd_d	= 1,
+		.palette_sz	= 16,
+		.palette_16bpp	= 1,
+		.valid_bpp	= (VALID_BPP124  | VALID_BPP(16) |
+				   VALID_BPP(18) | VALID_BPP(19) |
+				   VALID_BPP(24) | VALID_BPP(25)),
+	},
+	[4] = {
+		.has_osd_c	= 1,
+		.palette_sz	= 4,
+		.palette_16bpp	= 1,
+		.valid_bpp	= (VALID_BPP(1) | VALID_BPP(2) |
+				   VALID_BPP(16) | VALID_BPP(18) |
+				   VALID_BPP(24) | VALID_BPP(25)),
+	},
+};
+
+static struct s3c_fb_driverdata s3c_fb_data_64xx __devinitdata = {
+	.variant = {
+		.nr_windows	= 5,
+
+		.palette = {
+			[0] = 0x400,
+			[1] = 0x800,
+			[2] = 0x300,
+			[3] = 0x320,
+			[4] = 0x340,
+		},
+	},
+	.win[0]	= &s3c_fb_data_64xx_wins[0],
+	.win[1]	= &s3c_fb_data_64xx_wins[1],
+	.win[2]	= &s3c_fb_data_64xx_wins[2],
+	.win[3]	= &s3c_fb_data_64xx_wins[3],
+	.win[4]	= &s3c_fb_data_64xx_wins[4],
+};
+
+static struct s3c_fb_driverdata s3c_fb_data_s5p __devinitdata = {
+	.variant = {
+		.nr_windows	= 5,
+
+		.palette = {
+			[0] = 0x2400,
+			[1] = 0x2800,
+			[2] = 0x2c00,
+			[3] = 0x3000,
+			[4] = 0x3400,
+		},
+	},
+	.win[0]	= &s3c_fb_data_64xx_wins[0],
+	.win[1]	= &s3c_fb_data_64xx_wins[1],
+	.win[2]	= &s3c_fb_data_64xx_wins[2],
+	.win[3]	= &s3c_fb_data_64xx_wins[3],
+	.win[4]	= &s3c_fb_data_64xx_wins[4],
+};
+
+static struct platform_device_id s3c_fb_driver_ids[] = {
+	{
+		.name		= "s3c-fb",
+		.driver_data	= (unsigned long)&s3c_fb_data_64xx,
+	}, {
+		.name		= "s5p-fb",
+		.driver_data	= (unsigned long)&s3c_fb_data_s5p,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, s3c_fb_driver_ids);
+
 static struct platform_driver s3c_fb_driver = {
 	.probe		= s3c_fb_probe,
 	.remove		= __devexit_p(s3c_fb_remove),
 	.suspend	= s3c_fb_suspend,
 	.resume		= s3c_fb_resume,
+	.id_table	= s3c_fb_driver_ids,
 	.driver		= {
 		.name	= "s3c-fb",
 		.owner	= THIS_MODULE,
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-fix-section-mismatch.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch
panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch

