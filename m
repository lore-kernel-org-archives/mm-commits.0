From: akpm@linux-foundation.org
Subject: + tdfxfb-code-improvements.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:42:14 -0700
Message-ID: <200708012242.l71MgEe7021171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbXHAWmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     tdfxfb: code improvements
has been added to the -mm tree.  Its filename is
     tdfxfb-code-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tdfxfb: code improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch improves source code mainly by killing redundant variable loads,
reducing number of variables, simplifying conditional branches, etc.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |  161 +++++++++++----------------------------
 include/video/tdfx.h   |    3 
 2 files changed, 47 insertions(+), 117 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-code-improvements drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-code-improvements
+++ a/drivers/video/tdfxfb.c
@@ -63,12 +63,9 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/nvram.h>
 #include <asm/io.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
@@ -159,26 +156,15 @@ static char *mode_option __devinitdata =
  *                      Hardware-specific funcions
  * ------------------------------------------------------------------------- */
 
-#ifdef VGA_REG_IO
-static inline u8 vga_inb(struct tdfx_par *par, u32 reg)
-{
-	return inb(reg);
-}
-
-static inline void vga_outb(struct tdfx_par *par, u32 reg, u8 val)
-{
-	outb(val, reg);
-}
-#else
 static inline u8 vga_inb(struct tdfx_par *par, u32 reg)
 {
 	return inb(par->iobase + reg - 0x300);
 }
+
 static inline void vga_outb(struct tdfx_par *par, u32 reg, u8 val)
 {
 	outb(val, par->iobase + reg - 0x300);
 }
-#endif
 
 static inline void gra_outb(struct tdfx_par *par, u32 idx, u8 val)
 {
@@ -279,11 +265,11 @@ static int banshee_wait_idle(struct fb_i
 	banshee_make_room(par, 1);
 	tdfx_outl(par, COMMAND_3D, COMMAND_3D_NOP);
 
- 	while (1) {
-		i = (tdfx_inl(par, STATUS) & STATUS_BUSY) ? 0 : i + 1;
- 		if (i == 3)
- 			break;
-	}
+	do {
+ 		if ((tdfx_inl(par, STATUS) & STATUS_BUSY) == 0)
+		       i++;
+	} while (i < 3);
+
 	return 0;
 }
 
@@ -313,16 +299,17 @@ static u32 do_calc_pll(int freq, int *fr
 			 * Estimate value of n that produces target frequency
 			 * with current m and k
 			 */
-			int n_estimated = (freq * (m + 2) * (1 << k) / fref) - 2;
+			int n_estimated = ((freq * (m + 2) << k) / fref) - 2;
 
 			/* Search neighborhood of estimated n */
-			for (n = max(0, n_estimated - 1);
-					n <= min(255, n_estimated + 1); n++) {
+			for (n = max(0, n_estimated);
+				n <= min(255, n_estimated + 1);
+				n++) {
 				/*
 				 * Calculate PLL freqency with current m, k and
 				 * estimated n
 				 */
-				int f = fref * (n + 2) / (m + 2) / (1 << k);
+				int f = (fref * (n + 2) / (m + 2)) >> k;
 				int error = abs(f - freq);
 
 				/*
@@ -342,7 +329,7 @@ static u32 do_calc_pll(int freq, int *fr
 	n = best_n;
 	m = best_m;
 	k = best_k;
-	*freq_out = fref * (n + 2) / (m + 2) / (1 << k);
+	*freq_out = (fref * (n + 2) / (m + 2)) >> k;
 
 	return (n << 8) | (m << 2) | k;
 }
@@ -387,7 +374,7 @@ static void do_write_regs(struct fb_info
 	vga_enable_palette(par);
 	vga_enable_video(par);
 
-	banshee_make_room(par, 11);
+	banshee_make_room(par, 9);
 	tdfx_outl(par, VGAINIT0, reg->vgainit0);
 	tdfx_outl(par, DACMODE, reg->dacmode);
 	tdfx_outl(par, VIDDESKSTRIDE, reg->stride);
@@ -400,8 +387,8 @@ static void do_write_regs(struct fb_info
 	tdfx_outl(par, MISCINIT0, reg->miscinit0);
 
 	banshee_make_room(par, 8);
-	tdfx_outl(par, SRCBASE, reg->srcbase);
-	tdfx_outl(par, DSTBASE, reg->dstbase);
+	tdfx_outl(par, SRCBASE, reg->startaddr);
+	tdfx_outl(par, DSTBASE, reg->startaddr);
 	tdfx_outl(par, COMMANDEXTRA_2D, 0);
 	tdfx_outl(par, CLIP0MIN, 0);
 	tdfx_outl(par, CLIP0MAX, 0x0fff0fff);
@@ -414,32 +401,24 @@ static void do_write_regs(struct fb_info
 
 static unsigned long do_lfb_size(struct tdfx_par *par, unsigned short dev_id)
 {
-	u32 draminit0;
-	u32 draminit1;
+	u32 draminit0 = tdfx_inl(par, DRAMINIT0);
+	u32 draminit1 = tdfx_inl(par, DRAMINIT1);
 	u32 miscinit1;
-
-	int num_chips;
+	int num_chips = (draminit0 & DRAMINIT0_SGRAM_NUM) ? 8 : 4;
 	int chip_size; /* in MB */
-	u32 lfbsize;
-	int has_sgram;
-
-	draminit0 = tdfx_inl(par, DRAMINIT0);
-	draminit1 = tdfx_inl(par, DRAMINIT1);
-
-	num_chips = (draminit0 & DRAMINIT0_SGRAM_NUM) ? 8 : 4;
+	int has_sgram = draminit1 & DRAMINIT1_MEM_SDRAM;
 
 	if (dev_id < PCI_DEVICE_ID_3DFX_VOODOO5) {
 		/* Banshee/Voodoo3 */
-		has_sgram = draminit1 & DRAMINIT1_MEM_SDRAM;
 		chip_size = 2;
-		if (has_sgram)
-			chip_size = (draminit0 & DRAMINIT0_SGRAM_TYPE) ? 2 : 1;
+		if (has_sgram && (draminit0 & DRAMINIT0_SGRAM_TYPE))
+			chip_size = 1;
 	} else {
 		/* Voodoo4/5 */
 		has_sgram = 0;
-		chip_size = 1 << ((draminit0 & DRAMINIT0_SGRAM_TYPE_MASK) >> DRAMINIT0_SGRAM_TYPE_SHIFT);
+		chip_size = draminit0 & DRAMINIT0_SGRAM_TYPE_MASK;
+		chip_size = 1 << (chip_size >> DRAMINIT0_SGRAM_TYPE_SHIFT);
 	}
-	lfbsize = num_chips * chip_size * 1024 * 1024;
 
 	/* disable block writes for SDRAM */
 	miscinit1 = tdfx_inl(par, MISCINIT1);
@@ -448,7 +427,7 @@ static unsigned long do_lfb_size(struct 
 
 	banshee_make_room(par, 1);
 	tdfx_outl(par, MISCINIT1, miscinit1);
-	return lfbsize;
+	return num_chips * chip_size * 1024l * 1024;
 }
 
 /* ------------------------------------------------------------------------- */
@@ -548,17 +527,18 @@ static int tdfxfb_check_var(struct fb_va
 static int tdfxfb_set_par(struct fb_info *info)
 {
 	struct tdfx_par *par = info->par;
-	u32 hdispend, hsyncsta, hsyncend, htotal;
+	u32 hdispend = info->var.xres;
+	u32 hsyncsta = hdispend + info->var.right_margin;
+	u32 hsyncend = hsyncsta + info->var.hsync_len;
+	u32 htotal   = hsyncend + info->var.left_margin;
 	u32 hd, hs, he, ht, hbs, hbe;
 	u32 vd, vs, ve, vt, vbs, vbe;
 	struct banshee_reg reg;
 	int fout, freq;
-	u32 wd, cpp;
-
-	par->baseline = 0;
+	u32 wd;
+	u32 cpp = (info->var.bits_per_pixel + 7) >> 3;
 
 	memset(&reg, 0, sizeof(reg));
-	cpp = (info->var.bits_per_pixel + 7) / 8;
 
 	reg.vidcfg = VIDCFG_VIDPROC_ENABLE | VIDCFG_DESK_ENABLE |
 		     VIDCFG_CURS_X11 |
@@ -568,14 +548,8 @@ static int tdfxfb_set_par(struct fb_info
 	/* PLL settings */
 	freq = PICOS2KHZ(info->var.pixclock);
 
-	reg.dacmode = 0;
 	reg.vidcfg &= ~VIDCFG_2X;
 
-	hdispend = info->var.xres;
-	hsyncsta = hdispend + info->var.right_margin;
-	hsyncend = hsyncsta + info->var.hsync_len;
-	htotal   = hsyncend + info->var.left_margin;
-
 	if (freq > par->max_pixclock / 2) {
 		freq = freq > par->max_pixclock ? par->max_pixclock : freq;
 		reg.dacmode |= DACMODE_2X;
@@ -598,11 +572,16 @@ static int tdfxfb_set_par(struct fb_info
 		vs  = vd + (info->var.lower_margin << 1);
 		ve  = vs + (info->var.vsync_len << 1);
 		vbe = vt = ve + (info->var.upper_margin << 1) - 1;
+		reg.screensize = info->var.xres | (info->var.yres << 13);
+		reg.vidcfg |= VIDCFG_HALF_MODE;
+		reg.crt[0x09] = 0x80;
 	} else {
 		vbs = vd = info->var.yres - 1;
 		vs  = vd + info->var.lower_margin;
 		ve  = vs + info->var.vsync_len;
 		vbe = vt = ve + info->var.upper_margin - 1;
+		reg.screensize = info->var.xres | (info->var.yres << 12);
+		reg.vidcfg &= ~VIDCFG_HALF_MODE;
 	}
 
 	/* this is all pretty standard VGA register stuffing */
@@ -611,11 +590,6 @@ static int tdfxfb_set_par(struct fb_info
 			 info->var.xres < 480 ? 0x60 :
 			 info->var.xres < 768 ? 0xe0 : 0x20);
 
-	reg.gra[0x00] = 0x00;
-	reg.gra[0x01] = 0x00;
-	reg.gra[0x02] = 0x00;
-	reg.gra[0x03] = 0x00;
-	reg.gra[0x04] = 0x00;
 	reg.gra[0x05] = 0x40;
 	reg.gra[0x06] = 0x05;
 	reg.gra[0x07] = 0x0f;
@@ -638,10 +612,7 @@ static int tdfxfb_set_par(struct fb_info
 	reg.att[0x0e] = 0x0e;
 	reg.att[0x0f] = 0x0f;
 	reg.att[0x10] = 0x41;
-	reg.att[0x11] = 0x00;
 	reg.att[0x12] = 0x0f;
-	reg.att[0x13] = 0x00;
-	reg.att[0x14] = 0x00;
 
 	reg.seq[0x00] = 0x03;
 	reg.seq[0x01] = 0x01; /* fixme: clkdiv2? */
@@ -663,19 +634,11 @@ static int tdfxfb_set_par(struct fb_info
 			((vs & 0x100) >> 6) |
 			((vd & 0x100) >> 7) |
 			((vt & 0x100) >> 8);
-	reg.crt[0x08] = 0x00;
-	reg.crt[0x09] = 0x40 | ((vbs & 0x200) >> 4);
-	reg.crt[0x0a] = 0x00;
-	reg.crt[0x0b] = 0x00;
-	reg.crt[0x0c] = 0x00;
-	reg.crt[0x0d] = 0x00;
-	reg.crt[0x0e] = 0x00;
-	reg.crt[0x0f] = 0x00;
+	reg.crt[0x09] |= 0x40 | ((vbs & 0x200) >> 4);
 	reg.crt[0x10] = vs;
 	reg.crt[0x11] = (ve & 0x0f) | 0x20;
 	reg.crt[0x12] = vd;
 	reg.crt[0x13] = wd;
-	reg.crt[0x14] = 0x00;
 	reg.crt[0x15] = vbs;
 	reg.crt[0x16] = vbe + 1;
 	reg.crt[0x17] = 0xc3;
@@ -706,34 +669,15 @@ static int tdfxfb_set_par(struct fb_info
 	reg.cursc1    = 0xffffff;
 
 	reg.stride    = info->var.xres * cpp;
-	reg.startaddr = par->baseline * reg.stride;
-	reg.srcbase   = reg.startaddr;
-	reg.dstbase   = reg.startaddr;
-
-	/* PLL settings */
-	freq = PICOS2KHZ(info->var.pixclock);
+	reg.startaddr = info->var.yoffset * reg.stride
+			+ info->var.xoffset * cpp;
 
-	reg.dacmode &= ~DACMODE_2X;
-	reg.vidcfg  &= ~VIDCFG_2X;
-	if (freq > par->max_pixclock / 2) {
-		freq = freq > par->max_pixclock ? par->max_pixclock : freq;
-		reg.dacmode |= DACMODE_2X;
-		reg.vidcfg  |= VIDCFG_2X;
-	}
 	reg.vidpll = do_calc_pll(freq, &fout);
 #if 0
 	reg.mempll = do_calc_pll(..., &fout);
 	reg.gfxpll = do_calc_pll(..., &fout);
 #endif
 
-	if ((info->var.vmode & FB_VMODE_MASK) == FB_VMODE_DOUBLE) {
-		reg.screensize = info->var.xres | (info->var.yres << 13);
-		reg.vidcfg |= VIDCFG_HALF_MODE;
-		reg.crt[0x09] |= 0x80;
-	} else {
-		reg.screensize = info->var.xres | (info->var.yres << 12);
-		reg.vidcfg &= ~VIDCFG_HALF_MODE;
-	}
 	if ((info->var.vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED)
 		reg.vidcfg |= VIDCFG_INTERLACE;
 	reg.miscinit0 = tdfx_inl(par, MISCINIT0);
@@ -758,8 +702,7 @@ static int tdfxfb_set_par(struct fb_info
 	do_write_regs(info, &reg);
 
 	/* Now change fb_fix_screeninfo according to changes in par */
-	info->fix.line_length =
-		info->var.xres * ((info->var.bits_per_pixel + 7) >> 3);
+	info->fix.line_length = reg.stride;
 	info->fix.visual = (info->var.bits_per_pixel == 8)
 				? FB_VISUAL_PSEUDOCOLOR
 				: FB_VISUAL_TRUECOLOR;
@@ -821,35 +764,28 @@ static int tdfxfb_setcolreg(unsigned reg
 static int tdfxfb_blank(int blank, struct fb_info *info)
 {
 	struct tdfx_par *par = info->par;
-	u32 dacmode, state = 0, vgablank = 0;
+	int vgablank = 1;
+	u32 dacmode = tdfx_inl(par, DACMODE);
 
-	dacmode = tdfx_inl(par, DACMODE);
+	dacmode &= ~(BIT(1) | BIT(3));
 
 	switch (blank) {
 	case FB_BLANK_UNBLANK: /* Screen: On; HSync: On, VSync: On */
-		state    = 0;
 		vgablank = 0;
 		break;
 	case FB_BLANK_NORMAL: /* Screen: Off; HSync: On, VSync: On */
-		state    = 0;
-		vgablank = 1;
 		break;
 	case FB_BLANK_VSYNC_SUSPEND: /* Screen: Off; HSync: On, VSync: Off */
-		state    = BIT(3);
-		vgablank = 1;
+		dacmode |= BIT(3);
 		break;
 	case FB_BLANK_HSYNC_SUSPEND: /* Screen: Off; HSync: Off, VSync: On */
-		state    = BIT(1);
-		vgablank = 1;
+		dacmode |= BIT(1);
 		break;
 	case FB_BLANK_POWERDOWN: /* Screen: Off; HSync: Off, VSync: Off */
-		state    = BIT(1) | BIT(3);
-		vgablank = 1;
+		dacmode |= BIT(1) | BIT(3);
 		break;
 	}
 
-	dacmode &= ~(BIT(1) | BIT(3));
-	dacmode |= state;
 	banshee_make_room(par, 1);
 	tdfx_outl(par, DACMODE, dacmode);
 	if (vgablank)
@@ -866,14 +802,13 @@ static int tdfxfb_pan_display(struct fb_
 			      struct fb_info *info)
 {
 	struct tdfx_par *par = info->par;
-	u32 addr;
+	u32 addr = var->yoffset * info->fix.line_length;
 
 	if (nopan || var->xoffset || (var->yoffset > var->yres_virtual))
 		return -EINVAL;
 	if ((var->yoffset + var->yres > var->yres_virtual && nowrap))
 		return -EINVAL;
 
-	addr = var->yoffset * info->fix.line_length;
 	banshee_make_room(par, 1);
 	tdfx_outl(par, VIDDESKSTART, addr);
 
@@ -962,7 +897,6 @@ static void tdfxfb_copyarea(struct fb_in
 		dx = 0;
 	}
 
-
 	if (area->sx <= area->dx) {
 		//-X
 		blitcmd |= BIT(14);
@@ -1061,8 +995,7 @@ static void tdfxfb_imageblit(struct fb_i
 
 	/* Send the leftovers now */
 	banshee_make_room(par, 3);
-	i = size % 4;
-	switch (i) {
+	switch (size % 4) {
 	case 0:
 		break;
 	case 1:
diff -puN include/video/tdfx.h~tdfxfb-code-improvements include/video/tdfx.h
--- a/include/video/tdfx.h~tdfxfb-code-improvements
+++ a/include/video/tdfx.h
@@ -167,8 +167,6 @@ struct banshee_reg {
 	unsigned long clip0max;
 	unsigned long clip1min;
 	unsigned long clip1max;
-	unsigned long srcbase;
-	unsigned long dstbase;
 	unsigned long miscinit0;
 };
 
@@ -177,7 +175,6 @@ struct tdfx_par {
 	u32 palette[16];
 	void __iomem *regbase_virt;
 	unsigned long iobase;
-	u32 baseline;
 
 	struct {
 		int w, u, d;
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
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
