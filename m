From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-various-improvements.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:36 -0700
Message-ID: <200904011842.n31IgaYb009749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758258AbZDATTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:19:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: various improvements
has been removed from the -mm tree.  Its filename was
     cirrusfb-various-improvements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: various improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Various improvements to the code:
- kill a structure with only one
  field: multiplexing and use the
  field directly
- move the cirrusfb_ops structure
  down the file to kill forward
  declarations
- move cirrusfb_init() to kill
  forward declaration
- kill register loads done already
  in the init_vgachip()
- kill assigments done by higher
  layer in the cirrusfb_pan_display()
- do not overwrite line pitch bit in
  the CL_CRT1D register
- kill btype variables if they were
  used only once or twice
- add cpu_relax() in the busy waiting
  loop

The fix to the CL_CRT1D register handling makess the 1024x768 32bpp mode
work.  Previously, only lower resolution modes have worked with 32bpp.

Signed-off-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  202 ++++++++++---------------------------
 1 file changed, 58 insertions(+), 144 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-various-improvements drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-various-improvements
+++ a/drivers/video/cirrusfb.c
@@ -313,10 +313,6 @@ static const struct {
 };
 #endif /* CONFIG_ZORRO */
 
-struct cirrusfb_regs {
-	int multiplexing;
-};
-
 #ifdef CIRRUSFB_DEBUG
 enum cirrusfb_dbg_reg_class {
 	CRT,
@@ -331,7 +327,7 @@ struct cirrusfb_info {
 	enum cirrus_board btype;
 	unsigned char SFR;	/* Shadow of special function register */
 
-	struct cirrusfb_regs currentmode;
+	int multiplexing;
 	int blank_mode;
 	u32 pseudo_palette[16];
 
@@ -345,43 +341,8 @@ static char *mode_option __devinitdata =
 /**** BEGIN PROTOTYPES ******************************************************/
 
 /*--- Interface used by the world ------------------------------------------*/
-static int cirrusfb_init(void);
-#ifndef MODULE
-static int cirrusfb_setup(char *options);
-#endif
-
-static int cirrusfb_open(struct fb_info *info, int user);
-static int cirrusfb_release(struct fb_info *info, int user);
-static int cirrusfb_setcolreg(unsigned regno, unsigned red, unsigned green,
-			      unsigned blue, unsigned transp,
-			      struct fb_info *info);
-static int cirrusfb_check_var(struct fb_var_screeninfo *var,
-			      struct fb_info *info);
-static int cirrusfb_set_par(struct fb_info *info);
 static int cirrusfb_pan_display(struct fb_var_screeninfo *var,
 				struct fb_info *info);
-static int cirrusfb_blank(int blank_mode, struct fb_info *info);
-static void cirrusfb_fillrect(struct fb_info *info,
-			      const struct fb_fillrect *region);
-static void cirrusfb_copyarea(struct fb_info *info,
-			      const struct fb_copyarea *area);
-static void cirrusfb_imageblit(struct fb_info *info,
-			       const struct fb_image *image);
-
-/* function table of the above functions */
-static struct fb_ops cirrusfb_ops = {
-	.owner		= THIS_MODULE,
-	.fb_open	= cirrusfb_open,
-	.fb_release	= cirrusfb_release,
-	.fb_setcolreg	= cirrusfb_setcolreg,
-	.fb_check_var	= cirrusfb_check_var,
-	.fb_set_par	= cirrusfb_set_par,
-	.fb_pan_display = cirrusfb_pan_display,
-	.fb_blank	= cirrusfb_blank,
-	.fb_fillrect	= cirrusfb_fillrect,
-	.fb_copyarea	= cirrusfb_copyarea,
-	.fb_imageblit	= cirrusfb_imageblit,
-};
 
 /*--- Internal routines ----------------------------------------------------*/
 static void init_vgachip(struct fb_info *info);
@@ -587,7 +548,6 @@ static int cirrusfb_check_var(struct fb_
 }
 
 static int cirrusfb_decode_var(const struct fb_var_screeninfo *var,
-				struct cirrusfb_regs *regs,
 				struct fb_info *info)
 {
 	long freq;
@@ -628,7 +588,7 @@ static int cirrusfb_decode_var(const str
 	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
 
 	maxclock = cirrusfb_board_info[cinfo->btype].maxclock[maxclockidx];
-	regs->multiplexing = 0;
+	cinfo->multiplexing = 0;
 
 	/* If the frequency is greater than we can support, we might be able
 	 * to use multiplexing for the video mode */
@@ -636,7 +596,7 @@ static int cirrusfb_decode_var(const str
 		switch (cinfo->btype) {
 		case BT_ALPINE:
 		case BT_GD5480:
-			regs->multiplexing = 1;
+			cinfo->multiplexing = 1;
 			break;
 
 		default:
@@ -691,7 +651,6 @@ static int cirrusfb_set_par_foo(struct f
 {
 	struct cirrusfb_info *cinfo = info->par;
 	struct fb_var_screeninfo *var = &info->var;
-	struct cirrusfb_regs regs;
 	u8 __iomem *regbase = cinfo->regbase;
 	unsigned char tmp;
 	int err;
@@ -709,7 +668,7 @@ static int cirrusfb_set_par_foo(struct f
 
 	init_vgachip(info);
 
-	err = cirrusfb_decode_var(var, &regs, info);
+	err = cirrusfb_decode_var(var, info);
 	if (err) {
 		/* should never happen */
 		dev_dbg(info->device, "mode change aborted.  invalid var.\n");
@@ -753,7 +712,7 @@ static int cirrusfb_set_par_foo(struct f
 		vsyncend /= 2;
 		vdispend /= 2;
 	}
-	if (regs.multiplexing) {
+	if (cinfo->multiplexing) {
 		htotal /= 2;
 		hsyncstart /= 2;
 		hsyncend /= 2;
@@ -964,7 +923,7 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_ALPINE:
 		case BT_GD5480:
 			vga_wseq(regbase, CL_SEQR7,
-				 regs.multiplexing ?
+				 cinfo->multiplexing ?
 					bi->sr07_1bpp_mux : bi->sr07_1bpp);
 			break;
 
@@ -1018,7 +977,7 @@ static int cirrusfb_set_par_foo(struct f
 
 		/* pixel mask: pass-through for first plane */
 		WGen(cinfo, VGA_PEL_MSK, 0x01);
-		if (regs.multiplexing)
+		if (cinfo->multiplexing)
 			/* hidden dac reg: 1280x1024 */
 			WHDR(cinfo, 0x4a);
 		else
@@ -1047,7 +1006,7 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_ALPINE:
 		case BT_GD5480:
 			vga_wseq(regbase, CL_SEQR7,
-				  regs.multiplexing ?
+				  cinfo->multiplexing ?
 					bi->sr07_8bpp_mux : bi->sr07_8bpp);
 			break;
 
@@ -1101,18 +1060,12 @@ static int cirrusfb_set_par_foo(struct f
 
 		/* mode register: 256 color mode */
 		vga_wgfx(regbase, VGA_GFX_MODE, 64);
-		/* pixel mask: pass-through all planes */
-		WGen(cinfo, VGA_PEL_MSK, 0xff);
-		if (regs.multiplexing)
+		if (cinfo->multiplexing)
 			/* hidden dac reg: 1280x1024 */
 			WHDR(cinfo, 0x4a);
 		else
 			/* hidden dac: nothing */
 			WHDR(cinfo, 0);
-		/* memory mode: chain4, ext. memory */
-		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
-		/* plane mask: enable writing to all 4 planes */
-		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
 	}
 
 	/******************************************************
@@ -1177,18 +1130,12 @@ static int cirrusfb_set_par_foo(struct f
 
 		/* mode register: 256 color mode */
 		vga_wgfx(regbase, VGA_GFX_MODE, 64);
-		/* pixel mask: pass-through all planes */
-		WGen(cinfo, VGA_PEL_MSK, 0xff);
 #ifdef CONFIG_PCI
 		WHDR(cinfo, 0xc1);	/* Copy Xbh */
 #elif defined(CONFIG_ZORRO)
 		/* FIXME: CONFIG_PCI and CONFIG_ZORRO may be defined both */
 		WHDR(cinfo, 0xa0);	/* hidden dac reg: nothing special */
 #endif
-		/* memory mode: chain4, ext. memory */
-		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
-		/* plane mask: enable writing to all 4 planes */
-		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
 	}
 
 	/******************************************************
@@ -1253,14 +1200,8 @@ static int cirrusfb_set_par_foo(struct f
 
 		/* mode register: 256 color mode */
 		vga_wgfx(regbase, VGA_GFX_MODE, 64);
-		/* pixel mask: pass-through all planes */
-		WGen(cinfo, VGA_PEL_MSK, 0xff);
 		/* hidden dac reg: 8-8-8 mode (24 or 32) */
 		WHDR(cinfo, 0xc5);
-		/* memory mode: chain4, ext. memory */
-		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
-		/* plane mask: enable writing to all 4 planes */
-		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
 	}
 
 	/******************************************************
@@ -1309,48 +1250,13 @@ static int cirrusfb_set_par_foo(struct f
 	}
 
 
-	/* text cursor location high */
-	vga_wcrt(regbase, VGA_CRTC_CURSOR_HI, 0);
-	/* text cursor location low */
-	vga_wcrt(regbase, VGA_CRTC_CURSOR_LO, 0);
-	/* underline row scanline = at very bottom */
-	vga_wcrt(regbase, VGA_CRTC_UNDERLINE, 0);
-
-	/* controller mode */
-	vga_wattr(regbase, VGA_ATC_MODE, 1);
-	/* overscan (border) color */
-	vga_wattr(regbase, VGA_ATC_OVERSCAN, 0);
-	/* color plane enable */
-	vga_wattr(regbase, VGA_ATC_PLANE_ENABLE, 15);
 	/* pixel panning */
 	vga_wattr(regbase, CL_AR33, 0);
-	/* color select */
-	vga_wattr(regbase, VGA_ATC_COLOR_PAGE, 0);
 
 	/* [ EGS: SetOffset(); ] */
 	/* From SetOffset(): Turn on VideoEnable bit in Attribute controller */
 	AttrOn(cinfo);
 
-	/* set/reset register */
-	vga_wgfx(regbase, VGA_GFX_SR_VALUE, 0);
-	/* set/reset enable */
-	vga_wgfx(regbase, VGA_GFX_SR_ENABLE, 0);
-	/* color compare */
-	vga_wgfx(regbase, VGA_GFX_COMPARE_VALUE, 0);
-	/* data rotate */
-	vga_wgfx(regbase, VGA_GFX_DATA_ROTATE, 0);
-	/* read map select */
-	vga_wgfx(regbase, VGA_GFX_PLANE_READ, 0);
-	/* miscellaneous register */
-	vga_wgfx(regbase, VGA_GFX_MISC, 1);
-	/* color don't care */
-	vga_wgfx(regbase, VGA_GFX_COMPARE_MASK, 15);
-	/* bit mask */
-	vga_wgfx(regbase, VGA_GFX_BIT_MASK, 255);
-
-	/* graphics cursor attributes: nothing special */
-	vga_wseq(regbase, CL_SEQR12, 0x0);
-
 	if (cinfo->btype == BT_LAGUNA) {
 		/* no tiles */
 		fb_writew(control | 0x1000, cinfo->laguna_mmio + 0x402);
@@ -1369,8 +1275,6 @@ static int cirrusfb_set_par_foo(struct f
 	vga_wseq(regbase, VGA_SEQ_CLOCK_MODE, tmp);
 	dev_dbg(info->device, "CL_SEQR1: %d\n", tmp);
 
-	cinfo->currentmode = regs;
-
 	/* pan to requested offset */
 	cirrusfb_pan_display(var, info);
 
@@ -1443,9 +1347,6 @@ static int cirrusfb_pan_display(struct f
 	if (var->vmode & FB_VMODE_YWRAP)
 		return -EINVAL;
 
-	info->var.xoffset = var->xoffset;
-	info->var.yoffset = var->yoffset;
-
 	xoffset = var->xoffset * info->var.bits_per_pixel / 8;
 	yoffset = var->yoffset;
 
@@ -1480,8 +1381,11 @@ static int cirrusfb_pan_display(struct f
 	vga_wcrt(cinfo->regbase, CL_CRT1B, tmp);
 
 	/* construct bit 19 of screen start address */
-	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19)
-		vga_wcrt(cinfo->regbase, CL_CRT1D, (base >> 12) & 0x80);
+	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19) {
+		tmp = vga_rcrt(cinfo->regbase, CL_CRT1D) & ~0x80;
+		tmp |= (base >> 12) & 0x80;
+		vga_wcrt(cinfo->regbase, CL_CRT1D, tmp);
+	}
 
 	/* write pixel panning value to AR33; this does not quite work in 8bpp
 	 *
@@ -1670,8 +1574,8 @@ static void init_vgachip(struct fb_info 
 	vga_wseq(cinfo->regbase, VGA_SEQ_PLANE_WRITE, 0xff);
 	/* character map select: doesn't even matter in gx mode */
 	vga_wseq(cinfo->regbase, VGA_SEQ_CHARACTER_MAP, 0x00);
-	/* memory mode: chain-4, no odd/even, ext. memory */
-	vga_wseq(cinfo->regbase, VGA_SEQ_MEMORY_MODE, 0x0e);
+	/* memory mode: chain4, ext. memory */
+	vga_wseq(cinfo->regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
 
 	/* controller-internal base address of video memory */
 	if (bi->init_sr07)
@@ -1784,7 +1688,6 @@ static void init_vgachip(struct fb_info 
 	vga_wattr(cinfo->regbase, VGA_ATC_OVERSCAN, 0x00);
 	/* Color Plane enable: Enable all 4 planes */
 	vga_wattr(cinfo->regbase, VGA_ATC_PLANE_ENABLE, 0x0f);
-/* ###  vga_wattr(cinfo->regbase, CL_AR33, 0x00); * Pixel Panning: - */
 	/* Color Select: - */
 	vga_wattr(cinfo->regbase, VGA_ATC_COLOR_PAGE, 0x00);
 
@@ -2063,6 +1966,21 @@ static void cirrusfb_zorro_unmap(struct 
 }
 #endif /* CONFIG_ZORRO */
 
+/* function table of the above functions */
+static struct fb_ops cirrusfb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_open	= cirrusfb_open,
+	.fb_release	= cirrusfb_release,
+	.fb_setcolreg	= cirrusfb_setcolreg,
+	.fb_check_var	= cirrusfb_check_var,
+	.fb_set_par	= cirrusfb_set_par,
+	.fb_pan_display = cirrusfb_pan_display,
+	.fb_blank	= cirrusfb_blank,
+	.fb_fillrect	= cirrusfb_fillrect,
+	.fb_copyarea	= cirrusfb_copyarea,
+	.fb_imageblit	= cirrusfb_imageblit,
+};
+
 static int __devinit cirrusfb_set_fbinfo(struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
@@ -2111,12 +2029,9 @@ static int __devinit cirrusfb_register(s
 {
 	struct cirrusfb_info *cinfo = info->par;
 	int err;
-	enum cirrus_board btype;
-
-	btype = cinfo->btype;
 
 	/* sanity checks */
-	assert(btype != BT_NONE);
+	assert(cinfo->btype != BT_NONE);
 
 	/* set all the vital stuff */
 	cirrusfb_set_fbinfo(info);
@@ -2132,7 +2047,7 @@ static int __devinit cirrusfb_register(s
 
 	info->var.activate = FB_ACTIVATE_NOW;
 
-	err = cirrusfb_decode_var(&info->var, &cinfo->currentmode, info);
+	err = cirrusfb_decode_var(&info->var, info);
 	if (err < 0) {
 		/* should never happen */
 		dev_dbg(info->device,
@@ -2174,7 +2089,6 @@ static int __devinit cirrusfb_pci_regist
 {
 	struct cirrusfb_info *cinfo;
 	struct fb_info *info;
-	enum cirrus_board btype;
 	unsigned long board_addr, board_size;
 	int ret;
 
@@ -2192,11 +2106,11 @@ static int __devinit cirrusfb_pci_regist
 	}
 
 	cinfo = info->par;
-	cinfo->btype = btype = (enum cirrus_board) ent->driver_data;
+	cinfo->btype = (enum cirrus_board) ent->driver_data;
 
 	dev_dbg(info->device,
 		" Found PCI device, base address 0 is 0x%Lx, btype set to %d\n",
-		(unsigned long long)pdev->resource[0].start, btype);
+		(unsigned long long)pdev->resource[0].start,  cinfo->btype);
 	dev_dbg(info->device, " base address 1 is 0x%Lx\n",
 		(unsigned long long)pdev->resource[1].start);
 
@@ -2219,7 +2133,7 @@ static int __devinit cirrusfb_pci_regist
 	dev_dbg(info->device, "Board address: 0x%lx, register address: 0x%lx\n",
 		board_addr, info->fix.mmio_start);
 
-	board_size = (btype == BT_GD5480) ?
+	board_size = (cinfo->btype == BT_GD5480) ?
 		32 * MB_ : cirrusfb_get_memsize(info, cinfo->regbase);
 
 	ret = pci_request_regions(pdev, "cirrusfb");
@@ -2425,27 +2339,6 @@ static struct zorro_driver cirrusfb_zorr
 };
 #endif /* CONFIG_ZORRO */
 
-static int __init cirrusfb_init(void)
-{
-	int error = 0;
-
-#ifndef MODULE
-	char *option = NULL;
-
-	if (fb_get_options("cirrusfb", &option))
-		return -ENODEV;
-	cirrusfb_setup(option);
-#endif
-
-#ifdef CONFIG_ZORRO
-	error |= zorro_register_driver(&cirrusfb_zorro_driver);
-#endif
-#ifdef CONFIG_PCI
-	error |= pci_register_driver(&cirrusfb_pci_driver);
-#endif
-	return error;
-}
-
 #ifndef MODULE
 static int __init cirrusfb_setup(char *options)
 {
@@ -2477,6 +2370,27 @@ MODULE_AUTHOR("Copyright 1999,2000 Jeff 
 MODULE_DESCRIPTION("Accelerated FBDev driver for Cirrus Logic chips");
 MODULE_LICENSE("GPL");
 
+static int __init cirrusfb_init(void)
+{
+	int error = 0;
+
+#ifndef MODULE
+	char *option = NULL;
+
+	if (fb_get_options("cirrusfb", &option))
+		return -ENODEV;
+	cirrusfb_setup(option);
+#endif
+
+#ifdef CONFIG_ZORRO
+	error |= zorro_register_driver(&cirrusfb_zorro_driver);
+#endif
+#ifdef CONFIG_PCI
+	error |= pci_register_driver(&cirrusfb_pci_driver);
+#endif
+	return error;
+}
+
 static void __exit cirrusfb_exit(void)
 {
 #ifdef CONFIG_PCI
@@ -2683,7 +2597,7 @@ static void cirrusfb_WaitBLT(u8 __iomem 
 {
 	/* now busy-wait until we're done */
 	while (vga_rgfx(regbase, CL_GR31) & 0x08)
-		/* do nothing */ ;
+		cpu_relax();
 }
 
 /*******************************************************************
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

