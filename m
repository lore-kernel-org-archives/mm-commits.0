From: akpm@linux-foundation.org
Subject: + cyber2000fb-checkpatch-fixes.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:47:00 -0700
Message-ID: <200709160547.l8G5l0Dk002369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbXIPFrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     cyber2000fb: checkpatch fixes
has been added to the -mm tree.  Its filename is
     cyber2000fb-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cyber2000fb: checkpatch fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes errors and warnings pointed out by the checkpatch.pl
script.

Antonino Daplas replaced BIT with ENCODE_BIT.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cyber2000fb.c |  208 +++++++++++++++++-----------------
 1 file changed, 105 insertions(+), 103 deletions(-)

diff -puN drivers/video/cyber2000fb.c~cyber2000fb-checkpatch-fixes drivers/video/cyber2000fb.c
--- a/drivers/video/cyber2000fb.c~cyber2000fb-checkpatch-fixes
+++ a/drivers/video/cyber2000fb.c
@@ -62,7 +62,7 @@ struct cfb_info {
 	struct display_switch	*dispsw;
 	struct display		*display;
 	struct pci_dev		*dev;
-	unsigned char 		__iomem *region;
+	unsigned char		__iomem *region;
 	unsigned char		__iomem *regs;
 	u_int			id;
 	int			func_use_count;
@@ -97,11 +97,11 @@ MODULE_PARM_DESC(default_font, "Default 
 /*
  * Our access methods.
  */
-#define cyber2000fb_writel(val,reg,cfb)	writel(val, (cfb)->regs + (reg))
-#define cyber2000fb_writew(val,reg,cfb)	writew(val, (cfb)->regs + (reg))
-#define cyber2000fb_writeb(val,reg,cfb)	writeb(val, (cfb)->regs + (reg))
+#define cyber2000fb_writel(val, reg, cfb)	writel(val, (cfb)->regs + (reg))
+#define cyber2000fb_writew(val, reg, cfb)	writew(val, (cfb)->regs + (reg))
+#define cyber2000fb_writeb(val, reg, cfb)	writeb(val, (cfb)->regs + (reg))
 
-#define cyber2000fb_readb(reg,cfb)	readb((cfb)->regs + (reg))
+#define cyber2000fb_readb(reg, cfb)		readb((cfb)->regs + (reg))
 
 static inline void
 cyber2000_crtcw(unsigned int reg, unsigned int val, struct cfb_info *cfb)
@@ -221,12 +221,8 @@ cyber2000fb_copyarea(struct fb_info *inf
 static void
 cyber2000fb_imageblit(struct fb_info *info, const struct fb_image *image)
 {
-//	struct cfb_info *cfb = (struct cfb_info *)info;
-
-//	if (!(cfb->fb.var.accel_flags & FB_ACCELF_TEXT)) {
-		cfb_imageblit(info, image);
-		return;
-//	}
+	cfb_imageblit(info, image);
+	return;
 }
 
 static int cyber2000fb_sync(struct fb_info *info)
@@ -277,12 +273,12 @@ cyber2000fb_setcolreg(u_int regno, u_int
 
 	/*
 	 * Pseudocolour:
-	 *         8     8
+	 *	   8     8
 	 * pixel --/--+--/-->  red lut  --> red dac
-	 *            |  8
-	 *            +--/--> green lut --> green dac
-	 *            |  8
-	 *            +--/-->  blue lut --> blue dac
+	 *	      |  8
+	 *	      +--/--> green lut --> green dac
+	 *	      |  8
+	 *	      +--/-->  blue lut --> blue dac
 	 */
 	case FB_VISUAL_PSEUDOCOLOR:
 		if (regno >= NR_PALETTE)
@@ -292,9 +288,9 @@ cyber2000fb_setcolreg(u_int regno, u_int
 		green >>= 8;
 		blue >>= 8;
 
-		cfb->palette[regno].red   = red;
+		cfb->palette[regno].red = red;
 		cfb->palette[regno].green = green;
-		cfb->palette[regno].blue  = blue;
+		cfb->palette[regno].blue = blue;
 
 		cyber2000fb_writeb(regno, 0x3c8, cfb);
 		cyber2000fb_writeb(red, 0x3c9, cfb);
@@ -304,12 +300,12 @@ cyber2000fb_setcolreg(u_int regno, u_int
 
 	/*
 	 * Direct colour:
-	 *          n     rl
-	 *  pixel --/--+--/-->  red lut  --> red dac
-	 *             |  gl
-	 *             +--/--> green lut --> green dac
-	 *             |  bl
-	 *             +--/-->  blue lut --> blue dac
+	 *	   n     rl
+	 * pixel --/--+--/-->  red lut  --> red dac
+	 *	      |  gl
+	 *	      +--/--> green lut --> green dac
+	 *	      |  bl
+	 *	      +--/-->  blue lut --> blue dac
 	 * n = bpp, rl = red length, gl = green length, bl = blue length
 	 */
 	case FB_VISUAL_DIRECTCOLOR:
@@ -325,9 +321,11 @@ cyber2000fb_setcolreg(u_int regno, u_int
 			 * to the high 6 bits of the LUT.
 			 */
 			cyber2000fb_writeb(regno << 2, 0x3c8, cfb);
-			cyber2000fb_writeb(cfb->palette[regno >> 1].red, 0x3c9, cfb);
+			cyber2000fb_writeb(cfb->palette[regno >> 1].red,
+					   0x3c9, cfb);
 			cyber2000fb_writeb(green, 0x3c9, cfb);
-			cyber2000fb_writeb(cfb->palette[regno >> 1].blue, 0x3c9, cfb);
+			cyber2000fb_writeb(cfb->palette[regno >> 1].blue,
+					   0x3c9, cfb);
 
 			green = cfb->palette[regno << 3].green;
 
@@ -335,9 +333,9 @@ cyber2000fb_setcolreg(u_int regno, u_int
 		}
 
 		if (var->green.length >= 5 && regno < 32) {
-			cfb->palette[regno << 3].red   = red;
+			cfb->palette[regno << 3].red = red;
 			cfb->palette[regno << 3].green = green;
-			cfb->palette[regno << 3].blue  = blue;
+			cfb->palette[regno << 3].blue = blue;
 
 			/*
 			 * The 5 bits of each colour component are
@@ -351,9 +349,9 @@ cyber2000fb_setcolreg(u_int regno, u_int
 		}
 
 		if (var->green.length == 4 && regno < 16) {
-			cfb->palette[regno << 4].red   = red;
+			cfb->palette[regno << 4].red = red;
 			cfb->palette[regno << 4].green = green;
-			cfb->palette[regno << 4].blue  = blue;
+			cfb->palette[regno << 4].blue = blue;
 
 			/*
 			 * The 5 bits of each colour component are
@@ -377,12 +375,12 @@ cyber2000fb_setcolreg(u_int regno, u_int
 
 	/*
 	 * True colour:
-	 *          n     rl
-	 *  pixel --/--+--/--> red dac
-	 *             |  gl
-	 *             +--/--> green dac
-	 *             |  bl
-	 *             +--/--> blue dac
+	 *	   n     rl
+	 * pixel --/--+--/--> red dac
+	 *	      |  gl
+	 *	      +--/--> green dac
+	 *	      |  bl
+	 *	      +--/--> blue dac
 	 * n = bpp, rl = red length, gl = green length, bl = blue length
 	 */
 	case FB_VISUAL_TRUECOLOR:
@@ -494,9 +492,9 @@ static void cyber2000fb_set_timing(struc
 
 	/* PLL registers */
 	cyber2000_grphw(EXT_DCLK_MULT, hw->clock_mult, cfb);
-	cyber2000_grphw(EXT_DCLK_DIV,  hw->clock_div, cfb);
+	cyber2000_grphw(EXT_DCLK_DIV, hw->clock_div, cfb);
 	cyber2000_grphw(EXT_MCLK_MULT, cfb->mclk_mult, cfb);
-	cyber2000_grphw(EXT_MCLK_DIV,  cfb->mclk_div, cfb);
+	cyber2000_grphw(EXT_MCLK_DIV, cfb->mclk_div, cfb);
 	cyber2000_grphw(0x90, 0x01, cfb);
 	cyber2000_grphw(0xb9, 0x80, cfb);
 	cyber2000_grphw(0xb9, 0x00, cfb);
@@ -515,8 +513,8 @@ static void cyber2000fb_set_timing(struc
 	/*
 	 * Set up accelerator registers
 	 */
-	cyber2000fb_writew(hw->width,     CO_REG_SRC_WIDTH,  cfb);
-	cyber2000fb_writew(hw->width,     CO_REG_DEST_WIDTH, cfb);
+	cyber2000fb_writew(hw->width, CO_REG_SRC_WIDTH, cfb);
+	cyber2000fb_writew(hw->width, CO_REG_DEST_WIDTH, cfb);
 	cyber2000fb_writeb(hw->co_pixfmt, CO_REG_PIXFMT, cfb);
 }
 
@@ -549,15 +547,15 @@ cyber2000fb_decode_crtc(struct par_info 
 {
 	u_int Htotal, Hblankend, Hsyncend;
 	u_int Vtotal, Vdispend, Vblankstart, Vblankend, Vsyncstart, Vsyncend;
-#define ENCODE_BIT(v,b1,m,b2) (((v >> b1) & m) << b2)
+#define ENCODE_BIT(v, b1, m, b2) ((((v) >> (b1)) & (m)) << (b2))
 
 	hw->crtc[13] = hw->pitch;
 	hw->crtc[17] = 0xe3;
 	hw->crtc[14] = 0;
 	hw->crtc[8]  = 0;
 
-	Htotal      = var->xres + var->right_margin +
-		      var->hsync_len + var->left_margin;
+	Htotal     = var->xres + var->right_margin +
+		     var->hsync_len + var->left_margin;
 
 	if (Htotal > 2080)
 		return -EINVAL;
@@ -567,7 +565,7 @@ cyber2000fb_decode_crtc(struct par_info 
 	hw->crtc[2] = var->xres >> 3;
 	hw->crtc[4] = (var->xres + var->right_margin) >> 3;
 
-	Hblankend   = (Htotal - 4*8) >> 3;
+	Hblankend   = (Htotal - 4 * 8) >> 3;
 
 	hw->crtc[3] = ENCODE_BIT(Hblankend,  0, 0x1f,  0) |
 		      ENCODE_BIT(1,          0, 0x01,  7);
@@ -593,13 +591,13 @@ cyber2000fb_decode_crtc(struct par_info 
 	hw->crtc[7]  = ENCODE_BIT(Vtotal,     8, 0x01,  0) |
 			ENCODE_BIT(Vdispend,   8, 0x01,  1) |
 			ENCODE_BIT(Vsyncstart, 8, 0x01,  2) |
-			ENCODE_BIT(Vblankstart,8, 0x01,  3) |
+			ENCODE_BIT(Vblankstart, 8, 0x01,  3) |
 			ENCODE_BIT(1,          0, 0x01,  4) |
-	        	ENCODE_BIT(Vtotal,     9, 0x01,  5) |
+			ENCODE_BIT(Vtotal,     9, 0x01,  5) |
 			ENCODE_BIT(Vdispend,   9, 0x01,  6) |
 			ENCODE_BIT(Vsyncstart, 9, 0x01,  7);
 	hw->crtc[9]  = ENCODE_BIT(0,          0, 0x1f,  0) |
-		        ENCODE_BIT(Vblankstart,9, 0x01,  5) |
+			ENCODE_BIT(Vblankstart, 9, 0x01,  5) |
 			ENCODE_BIT(1,          0, 0x01,  6);
 	hw->crtc[10] = Vsyncstart;
 	hw->crtc[11] = ENCODE_BIT(Vsyncend,   0, 0x0f,  0) |
@@ -615,10 +613,10 @@ cyber2000fb_decode_crtc(struct par_info 
 	 * 4=LINECOMP:10 5-IVIDEO 6=FIXCNT
 	 */
 	hw->crtc_ofl =
-		ENCODE_BIT(Vtotal,     10, 0x01,  0) |
-		ENCODE_BIT(Vdispend,   10, 0x01,  1) |
-		ENCODE_BIT(Vsyncstart, 10, 0x01,  2) |
-		ENCODE_BIT(Vblankstart,10, 0x01,  3) |
+		ENCODE_BIT(Vtotal, 10, 0x01, 0) |
+		ENCODE_BIT(Vdispend, 10, 0x01, 1) |
+		ENCODE_BIT(Vsyncstart, 10, 0x01, 2) |
+		ENCODE_BIT(Vblankstart, 10, 0x01, 3) |
 		EXT_CRT_VRTOFL_LINECOMP10;
 
 	/* woody: set the interlaced bit... */
@@ -750,11 +748,11 @@ cyber2000fb_check_var(struct fb_var_scre
 	var->red.msb_right	= 0;
 	var->green.msb_right	= 0;
 	var->blue.msb_right	= 0;
+	var->transp.offset	= 0;
+	var->transp.length	= 0;
 
 	switch (var->bits_per_pixel) {
 	case 8:	/* PSEUDOCOLOUR, 256 */
-		var->transp.offset	= 0;
-		var->transp.length	= 0;
 		var->red.offset		= 0;
 		var->red.length		= 8;
 		var->green.offset	= 0;
@@ -766,8 +764,6 @@ cyber2000fb_check_var(struct fb_var_scre
 	case 16:/* DIRECTCOLOUR, 64k or 32k */
 		switch (var->green.length) {
 		case 6: /* RGB565, 64k */
-			var->transp.offset	= 0;
-			var->transp.length	= 0;
 			var->red.offset		= 11;
 			var->red.length		= 5;
 			var->green.offset	= 5;
@@ -778,8 +774,6 @@ cyber2000fb_check_var(struct fb_var_scre
 
 		default:
 		case 5: /* RGB555, 32k */
-			var->transp.offset	= 0;
-			var->transp.length	= 0;
 			var->red.offset		= 10;
 			var->red.length		= 5;
 			var->green.offset	= 5;
@@ -802,8 +796,6 @@ cyber2000fb_check_var(struct fb_var_scre
 		break;
 
 	case 24:/* TRUECOLOUR, 16m */
-		var->transp.offset	= 0;
-		var->transp.length	= 0;
 		var->red.offset		= 16;
 		var->red.length		= 8;
 		var->green.offset	= 8;
@@ -830,7 +822,7 @@ cyber2000fb_check_var(struct fb_var_scre
 	mem = var->xres_virtual * var->yres_virtual * (var->bits_per_pixel / 8);
 	if (mem > cfb->fb.fix.smem_len)
 		var->yres_virtual = cfb->fb.fix.smem_len * 8 /
-			(var->bits_per_pixel * var->xres_virtual);
+				    (var->bits_per_pixel * var->xres_virtual);
 
 	if (var->yres > var->yres_virtual)
 		var->yres = var->yres_virtual;
@@ -921,7 +913,7 @@ static int cyber2000fb_set_par(struct fb
 		hw.fetch <<= 1;
 	hw.fetch += 1;
 
-	cfb->fb.fix.line_length	= var->xres_virtual * var->bits_per_pixel / 8;
+	cfb->fb.fix.line_length = var->xres_virtual * var->bits_per_pixel / 8;
 
 	/*
 	 * Same here - if the size of the video mode exceeds the
@@ -952,7 +944,6 @@ static int cyber2000fb_set_par(struct fb
 	return 0;
 }
 
-
 /*
  *    Pan or Wrap the Display
  */
@@ -1002,15 +993,15 @@ static int cyber2000fb_blank(int blank, 
 	switch (blank) {
 	case FB_BLANK_POWERDOWN:	/* powerdown - both sync lines down */
 		sync = EXT_SYNC_CTL_VS_0 | EXT_SYNC_CTL_HS_0;
-		break;	
+		break;
 	case FB_BLANK_HSYNC_SUSPEND:	/* hsync off */
 		sync = EXT_SYNC_CTL_VS_NORMAL | EXT_SYNC_CTL_HS_0;
-		break;	
+		break;
 	case FB_BLANK_VSYNC_SUSPEND:	/* vsync off */
 		sync = EXT_SYNC_CTL_VS_0 | EXT_SYNC_CTL_HS_NORMAL;
 		break;
-	case FB_BLANK_NORMAL:	        /* soft blank */
-	default: /* unblank */
+	case FB_BLANK_NORMAL:		/* soft blank */
+	default:			/* unblank */
 		break;
 	}
 
@@ -1018,7 +1009,8 @@ static int cyber2000fb_blank(int blank, 
 
 	if (blank <= 1) {
 		/* turn on ramdacs */
-		cfb->ramdac_powerdown &= ~(RAMDAC_DACPWRDN | RAMDAC_BYPASS | RAMDAC_RAMPWRDN);
+		cfb->ramdac_powerdown &= ~(RAMDAC_DACPWRDN | RAMDAC_BYPASS |
+					   RAMDAC_RAMPWRDN);
 		cyber2000fb_write_ramdac_ctrl(cfb);
 	}
 
@@ -1043,7 +1035,8 @@ static int cyber2000fb_blank(int blank, 
 
 	if (blank >= 2) {
 		/* turn off ramdacs */
-		cfb->ramdac_powerdown |= RAMDAC_DACPWRDN | RAMDAC_BYPASS | RAMDAC_RAMPWRDN;
+		cfb->ramdac_powerdown |= RAMDAC_DACPWRDN | RAMDAC_BYPASS |
+					 RAMDAC_RAMPWRDN;
 		cyber2000fb_write_ramdac_ctrl(cfb);
 	}
 
@@ -1068,7 +1061,7 @@ static struct fb_ops cyber2000fb_ops = {
  * of this driver.  It is here solely at the moment to support the other
  * CyberPro modules external to this driver.
  */
-static struct cfb_info		*int_cfb_info;
+static struct cfb_info *int_cfb_info;
 
 /*
  * Enable access to the extended registers
@@ -1085,6 +1078,7 @@ void cyber2000fb_enable_extregs(struct c
 		cyber2000_grphw(EXT_FUNC_CTL, old, cfb);
 	}
 }
+EXPORT_SYMBOL(cyber2000fb_enable_extregs);
 
 /*
  * Disable access to the extended registers
@@ -1104,11 +1098,13 @@ void cyber2000fb_disable_extregs(struct 
 	else
 		cfb->func_use_count -= 1;
 }
+EXPORT_SYMBOL(cyber2000fb_disable_extregs);
 
 void cyber2000fb_get_fb_var(struct cfb_info *cfb, struct fb_var_screeninfo *var)
 {
 	memcpy(var, &cfb->fb.var, sizeof(struct fb_var_screeninfo));
 }
+EXPORT_SYMBOL(cyber2000fb_get_fb_var);
 
 /*
  * Attach a capture/tv driver to the core CyberX0X0 driver.
@@ -1122,13 +1118,15 @@ int cyber2000fb_attach(struct cyberpro_i
 		info->fb_size	      = int_cfb_info->fb.fix.smem_len;
 		info->enable_extregs  = cyber2000fb_enable_extregs;
 		info->disable_extregs = cyber2000fb_disable_extregs;
-		info->info            = int_cfb_info;
+		info->info	      = int_cfb_info;
 
-		strlcpy(info->dev_name, int_cfb_info->fb.fix.id, sizeof(info->dev_name));
+		strlcpy(info->dev_name, int_cfb_info->fb.fix.id,
+			sizeof(info->dev_name));
 	}
 
 	return int_cfb_info != NULL;
 }
+EXPORT_SYMBOL(cyber2000fb_attach);
 
 /*
  * Detach a capture/tv driver from the core CyberX0X0 driver.
@@ -1136,12 +1134,7 @@ int cyber2000fb_attach(struct cyberpro_i
 void cyber2000fb_detach(int idx)
 {
 }
-
-EXPORT_SYMBOL(cyber2000fb_attach);
 EXPORT_SYMBOL(cyber2000fb_detach);
-EXPORT_SYMBOL(cyber2000fb_enable_extregs);
-EXPORT_SYMBOL(cyber2000fb_disable_extregs);
-EXPORT_SYMBOL(cyber2000fb_get_fb_var);
 
 /*
  * These parameters give
@@ -1205,7 +1198,7 @@ static void cyberpro_init_hw(struct cfb_
 	int i;
 
 	for (i = 0; i < sizeof(igs_regs); i += 2)
-		cyber2000_grphw(igs_regs[i], igs_regs[i+1], cfb);
+		cyber2000_grphw(igs_regs[i], igs_regs[i + 1], cfb);
 
 	if (cfb->id == ID_CYBERPRO_5000) {
 		unsigned char val;
@@ -1215,8 +1208,8 @@ static void cyberpro_init_hw(struct cfb_
 	}
 }
 
-static struct cfb_info * __devinit
-cyberpro_alloc_fb_info(unsigned int id, char *name)
+static struct cfb_info __devinit *cyberpro_alloc_fb_info(unsigned int id,
+							 char *name)
 {
 	struct cfb_info *cfb;
 
@@ -1228,9 +1221,9 @@ cyberpro_alloc_fb_info(unsigned int id, 
 	cfb->id			= id;
 
 	if (id == ID_CYBERPRO_5000)
-		cfb->ref_ps	= 40690; // 24.576 MHz
+		cfb->ref_ps	= 40690; /* 24.576 MHz */
 	else
-		cfb->ref_ps	= 69842; // 14.31818 MHz (69841?)
+		cfb->ref_ps	= 69842; /* 14.31818 MHz (69841?) */
 
 	cfb->divisors[0]	= 1;
 	cfb->divisors[1]	= 2;
@@ -1282,8 +1275,7 @@ cyberpro_alloc_fb_info(unsigned int id, 
 	return cfb;
 }
 
-static void
-cyberpro_free_fb_info(struct cfb_info *cfb)
+static void cyberpro_free_fb_info(struct cfb_info *cfb)
 {
 	if (cfb) {
 		/*
@@ -1300,8 +1292,7 @@ cyberpro_free_fb_info(struct cfb_info *c
  *  video=cyber2000:font:fontname
  */
 #ifndef MODULE
-static int
-cyber2000fb_setup(char *options)
+static int cyber2000fb_setup(char *options)
 {
 	char *opt;
 
@@ -1315,7 +1306,8 @@ cyber2000fb_setup(char *options)
 		if (strncmp(opt, "font:", 5) == 0) {
 			static char default_font_storage[40];
 
-			strlcpy(default_font_storage, opt + 5, sizeof(default_font_storage));
+			strlcpy(default_font_storage, opt + 5,
+				sizeof(default_font_storage));
 			default_font = default_font_storage;
 			continue;
 		}
@@ -1354,10 +1346,18 @@ static int __devinit cyberpro_common_pro
 	 * Determine the size of the memory.
 	 */
 	switch (cfb->mem_ctl2 & MEM_CTL2_SIZE_MASK) {
-	case MEM_CTL2_SIZE_4MB:	smem_size = 0x00400000; break;
-	case MEM_CTL2_SIZE_2MB:	smem_size = 0x00200000; break;
-	case MEM_CTL2_SIZE_1MB: smem_size = 0x00100000; break;
-	default:		smem_size = 0x00100000; break;
+	case MEM_CTL2_SIZE_4MB:
+		smem_size = 0x00400000;
+		break;
+	case MEM_CTL2_SIZE_2MB:
+		smem_size = 0x00200000;
+		break;
+	case MEM_CTL2_SIZE_1MB:
+		smem_size = 0x00100000;
+		break;
+	default:
+		smem_size = 0x00100000;
+		break;
 	}
 
 	cfb->fb.fix.smem_len   = smem_size;
@@ -1366,8 +1366,8 @@ static int __devinit cyberpro_common_pro
 
 	err = -EINVAL;
 	if (!fb_find_mode(&cfb->fb.var, &cfb->fb, NULL, NULL, 0,
-	    		  &cyber2000fb_default_mode, 8)) {
-		printk("%s: no valid mode found\n", cfb->fb.fix.id);
+			  &cyber2000fb_default_mode, 8)) {
+		printk(KERN_ERR "%s: no valid mode found\n", cfb->fb.fix.id);
 		goto failed;
 	}
 
@@ -1377,7 +1377,7 @@ static int __devinit cyberpro_common_pro
 	if (cfb->fb.var.yres_virtual < cfb->fb.var.yres)
 		cfb->fb.var.yres_virtual = cfb->fb.var.yres;
 
-//	fb_set_var(&cfb->fb.var, -1, &cfb->fb);
+/*	fb_set_var(&cfb->fb.var, -1, &cfb->fb); */
 
 	/*
 	 * Calculate the hsync and vsync frequencies.  Note that
@@ -1425,20 +1425,20 @@ static void cyberpro_common_resume(struc
 
 #include <asm/arch/hardware.h>
 
-static int __devinit
-cyberpro_vl_probe(void)
+static int __devinit cyberpro_vl_probe(void)
 {
 	struct cfb_info *cfb;
 	int err = -ENOMEM;
 
-	if (!request_mem_region(FB_START,FB_SIZE,"CyberPro2010")) return err;
+	if (!request_mem_region(FB_START, FB_SIZE, "CyberPro2010"))
+		return err;
 
 	cfb = cyberpro_alloc_fb_info(ID_CYBERPRO_2010, "CyberPro2010");
 	if (!cfb)
 		goto failed_release;
 
 	cfb->dev = NULL;
-	cfb->region = ioremap(FB_START,FB_SIZE);
+	cfb->region = ioremap(FB_START, FB_SIZE);
 	if (!cfb->region)
 		goto failed_ioremap;
 
@@ -1475,7 +1475,7 @@ failed:
 failed_ioremap:
 	cyberpro_free_fb_info(cfb);
 failed_release:
-	release_mem_region(FB_START,FB_SIZE);
+	release_mem_region(FB_START, FB_SIZE);
 
 	return err;
 }
@@ -1538,7 +1538,8 @@ static int cyberpro_pci_enable_mmio(stru
 	 * Allow the CyberPro to accept PCI burst accesses
 	 */
 	if (cfb->id == ID_CYBERPRO_2010) {
-		printk(KERN_INFO "%s: NOT enabling PCI bursts\n", cfb->fb.fix.id);
+		printk(KERN_INFO "%s: NOT enabling PCI bursts\n",
+		       cfb->fb.fix.id);
 	} else {
 		val = cyber2000_grphr(EXT_BUS_CTL, cfb);
 		if (!(val & EXT_BUS_CTL_PCIBURST_WRITE)) {
@@ -1688,9 +1689,10 @@ static int cyberpro_pci_resume(struct pc
 }
 
 static struct pci_device_id cyberpro_pci_table[] = {
-//	Not yet
-//	{ PCI_VENDOR_ID_INTERG, PCI_DEVICE_ID_INTERG_1682,
-//		PCI_ANY_ID, PCI_ANY_ID, 0, 0, ID_IGA_1682 },
+/*	Not yet
+ *	{ PCI_VENDOR_ID_INTERG, PCI_DEVICE_ID_INTERG_1682,
+ *		PCI_ANY_ID, PCI_ANY_ID, 0, 0, ID_IGA_1682 },
+ */
 	{ PCI_VENDOR_ID_INTERG, PCI_DEVICE_ID_INTERG_2000,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, ID_CYBERPRO_2000 },
 	{ PCI_VENDOR_ID_INTERG, PCI_DEVICE_ID_INTERG_2010,
@@ -1700,7 +1702,7 @@ static struct pci_device_id cyberpro_pci
 	{ 0, }
 };
 
-MODULE_DEVICE_TABLE(pci,cyberpro_pci_table);
+MODULE_DEVICE_TABLE(pci, cyberpro_pci_table);
 
 static struct pci_driver cyberpro_driver = {
 	.name		= "CyberPro",
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-alsa.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
s3c2410fb-byte-ordering-fixes.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
tdfxfb-replace-busy-waiting-with-cpu_relax.patch
pm2fb-replace-busy-waiting-with-cpu_relax.patch
pm3fb-replace-busy-waiting-with-cpu_relax.patch
tdfxfb-checkpatch-fixes.patch
cyber2000fb-checkpatch-fixes.patch
