From: akpm@linux-foundation.org
Subject: + tdfxfb-coding-style-improvement.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:50 -0700
Message-ID: <200707261900.l6QJ0oNn015677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932789AbXGZTMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:12:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     tdfxfb: coding style improvement
has been added to the -mm tree.  Its filename is
     tdfxfb-coding-style-improvement.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tdfxfb: coding style improvement
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch contains coding style improvements to the tdfxfb driver (white
spaces, indentations, long lines).

It also moves fb_ops structure to the end of file, so forward declarations of
ops functions are redundant.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |  737 +++++++++++++++++++--------------------
 include/video/tdfx.h   |  260 ++++++-------
 2 files changed, 506 insertions(+), 491 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-coding-style-improvement drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-coding-style-improvement
+++ a/drivers/video/tdfxfb.c
@@ -10,7 +10,7 @@
  * Created      : Thu Sep 23 18:17:43 1999, hmallat
  * Last modified: Tue Nov  2 21:19:47 1999, hmallat
  *
- * Lots of the information here comes from the Daryll Strauss' Banshee 
+ * Lots of the information here comes from the Daryll Strauss' Banshee
  * patches to the XF86 server, and the rest comes from the 3dfx
  * Banshee specification. I'm very much indebted to Daryll for his
  * work on the X server.
@@ -23,7 +23,7 @@
  * behave very differently from the Voodoo3/4/5. For anyone wanting to
  * use frame buffer on the Voodoo1/2, see the sstfb driver (which is
  * located at http://www.sourceforge.net/projects/sstfb).
- * 
+ *
  * While I _am_ grateful to 3Dfx for releasing the specs for Banshee,
  * I do wish the next version is a bit more complete. Without the XF86
  * patches I couldn't have gotten even this far... for instance, the
@@ -33,7 +33,7 @@
  *
  * The structure of this driver comes pretty much from the Permedia
  * driver by Ilario Nardinocchi, which in turn is based on skeletonfb.
- * 
+ *
  * TODO:
  * - support for 16/32 bpp needs fixing (funky bootup penguin)
  * - multihead support (basically need to support an array of fb_infos)
@@ -76,12 +76,12 @@
 
 #include <video/tdfx.h>
 
-#undef TDFXFB_DEBUG 
+#undef TDFXFB_DEBUG
 #ifdef TDFXFB_DEBUG
 #define DPRINTK(a,b...) printk(KERN_DEBUG "fb: %s: " a, __FUNCTION__ , ## b)
 #else
 #define DPRINTK(a,b...)
-#endif 
+#endif
 
 #define BANSHEE_MAX_PIXCLOCK 270000
 #define VOODOO3_MAX_PIXCLOCK 300000
@@ -90,9 +90,9 @@
 static struct fb_fix_screeninfo tdfx_fix __devinitdata = {
 	.id =		"3Dfx",
 	.type =		FB_TYPE_PACKED_PIXELS,
-	.visual =	FB_VISUAL_PSEUDOCOLOR, 
+	.visual =	FB_VISUAL_PSEUDOCOLOR,
 	.ypanstep =	1,
-	.ywrapstep =	1, 
+	.ywrapstep =	1,
 	.accel =	FB_ACCEL_3DFX_BANSHEE
 };
 
@@ -102,7 +102,7 @@ static struct fb_var_screeninfo tdfx_var
 	.yres =		480,
 	.xres_virtual =	640,
 	.yres_virtual =	1024,
-	.bits_per_pixel =8,
+	.bits_per_pixel = 8,
 	.red =		{0, 8, 0},
 	.blue =		{0, 8, 0},
 	.green =	{0, 8, 0},
@@ -142,103 +142,79 @@ static struct pci_device_id tdfxfb_id_ta
 
 static struct pci_driver tdfxfb_driver = {
 	.name		= "tdfxfb",
-	.id_table 	= tdfxfb_id_table,
-	.probe 		= tdfxfb_probe,
-	.remove 	= __devexit_p(tdfxfb_remove),
+	.id_table	= tdfxfb_id_table,
+	.probe		= tdfxfb_probe,
+	.remove		= __devexit_p(tdfxfb_remove),
 };
 
 MODULE_DEVICE_TABLE(pci, tdfxfb_id_table);
 
 /*
- *  Frame buffer device API
- */
-static int tdfxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *fb); 
-static int tdfxfb_set_par(struct fb_info *info); 
-static int tdfxfb_setcolreg(u_int regno, u_int red, u_int green, u_int blue, 
-			    u_int transp, struct fb_info *info); 
-static int tdfxfb_blank(int blank, struct fb_info *info); 
-static int tdfxfb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info);
-static int banshee_wait_idle(struct fb_info *info);
-#ifdef CONFIG_FB_3DFX_ACCEL
-static void tdfxfb_fillrect(struct fb_info *info, const struct fb_fillrect *rect);
-static void tdfxfb_copyarea(struct fb_info *info, const struct fb_copyarea *area);  
-static void tdfxfb_imageblit(struct fb_info *info, const struct fb_image *image); 
-#endif /* CONFIG_FB_3DFX_ACCEL */
-
-static struct fb_ops tdfxfb_ops = {
-	.owner		= THIS_MODULE,
-	.fb_check_var	= tdfxfb_check_var,
-	.fb_set_par	= tdfxfb_set_par,
-	.fb_setcolreg	= tdfxfb_setcolreg,
-	.fb_blank	= tdfxfb_blank,
-	.fb_pan_display	= tdfxfb_pan_display,
-	.fb_sync	= banshee_wait_idle,
-#ifdef CONFIG_FB_3DFX_ACCEL
-	.fb_fillrect	= tdfxfb_fillrect,
-	.fb_copyarea	= tdfxfb_copyarea,
-	.fb_imageblit	= tdfxfb_imageblit,
-#else
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
-#endif
-};
-
-/*
- * do_xxx: Hardware-specific functions
- */
-static u32 do_calc_pll(int freq, int *freq_out);
-static void  do_write_regs(struct fb_info *info, struct banshee_reg *reg);
-static unsigned long do_lfb_size(struct tdfx_par *par, unsigned short);
-
-/*
- * Driver data 
+ * Driver data
  */
 static int  nopan   = 0;
 static int  nowrap  = 1;      // not implemented (yet)
 static char *mode_option __devinitdata = NULL;
 
-/* ------------------------------------------------------------------------- 
+/* -------------------------------------------------------------------------
  *                      Hardware-specific funcions
  * ------------------------------------------------------------------------- */
 
-#ifdef VGA_REG_IO 
-static inline  u8 vga_inb(struct tdfx_par *par, u32 reg) { return inb(reg); }
+#ifdef VGA_REG_IO
+static inline u8 vga_inb(struct tdfx_par *par, u32 reg)
+{
+	return inb(reg);
+}
 
-static inline void vga_outb(struct tdfx_par *par, u32 reg,  u8 val) { outb(val, reg); }
+static inline void vga_outb(struct tdfx_par *par, u32 reg, u8 val)
+{
+	outb(val, reg);
+}
 #else
-static inline  u8 vga_inb(struct tdfx_par *par, u32 reg) { 
-	return inb(par->iobase + reg - 0x300); 
+static inline u8 vga_inb(struct tdfx_par *par, u32 reg)
+{
+	return inb(par->iobase + reg - 0x300);
 }
-static inline void vga_outb(struct tdfx_par *par, u32 reg,  u8 val) { 
-	outb(val, par->iobase + reg - 0x300); 
+static inline void vga_outb(struct tdfx_par *par, u32 reg, u8 val)
+{
+	outb(val, par->iobase + reg - 0x300);
 }
 #endif
 
-static inline void gra_outb(struct tdfx_par *par, u32 idx, u8 val) {
-	vga_outb(par, GRA_I, idx); vga_outb(par, GRA_D, val);
+static inline void gra_outb(struct tdfx_par *par, u32 idx, u8 val)
+{
+	vga_outb(par, GRA_I, idx);
+	vga_outb(par, GRA_D, val);
 }
 
-static inline void seq_outb(struct tdfx_par *par, u32 idx, u8 val) {
-	vga_outb(par, SEQ_I, idx); vga_outb(par, SEQ_D, val);
+static inline void seq_outb(struct tdfx_par *par, u32 idx, u8 val)
+{
+	vga_outb(par, SEQ_I, idx);
+	vga_outb(par, SEQ_D, val);
 }
 
-static inline u8 seq_inb(struct tdfx_par *par, u32 idx) {
-	vga_outb(par, SEQ_I, idx); return vga_inb(par, SEQ_D);
+static inline u8 seq_inb(struct tdfx_par *par, u32 idx)
+{
+	vga_outb(par, SEQ_I, idx);
+	return vga_inb(par, SEQ_D);
 }
 
-static inline void crt_outb(struct tdfx_par *par, u32 idx, u8 val) {
-	vga_outb(par, CRT_I, idx); vga_outb(par, CRT_D, val);
+static inline void crt_outb(struct tdfx_par *par, u32 idx, u8 val)
+{
+	vga_outb(par, CRT_I, idx);
+	vga_outb(par, CRT_D, val);
 }
 
-static inline u8 crt_inb(struct tdfx_par *par, u32 idx) {
-	vga_outb(par, CRT_I, idx); return vga_inb(par, CRT_D);
+static inline u8 crt_inb(struct tdfx_par *par, u32 idx)
+{
+	vga_outb(par, CRT_I, idx);
+	return vga_inb(par, CRT_D);
 }
 
-static inline void att_outb(struct tdfx_par *par, u32 idx, u8 val) 
+static inline void att_outb(struct tdfx_par *par, u32 idx, u8 val)
 {
 	unsigned char tmp;
-	
+
 	tmp = vga_inb(par, IS1_R);
 	vga_outb(par, ATT_IW, idx);
 	vga_outb(par, ATT_IW, val);
@@ -270,7 +246,7 @@ static inline void vga_enable_palette(st
 	vga_outb(par, ATT_IW, 0x20);
 }
 
-static inline u32 tdfx_inl(struct tdfx_par *par, unsigned int reg) 
+static inline u32 tdfx_inl(struct tdfx_par *par, unsigned int reg)
 {
 	return readl(par->regbase_virt + reg);
 }
@@ -284,7 +260,7 @@ static inline void banshee_make_room(str
 {
 	/* Note: The Voodoo3's onboard FIFO has 32 slots. This loop
 	 * won't quit if you ask for more. */
-	while((tdfx_inl(par, STATUS) & 0x1f) < size-1);
+ 	while ((tdfx_inl(par, STATUS) & 0x1f) < size - 1) ;
 }
  
 static int banshee_wait_idle(struct fb_info *info)
@@ -295,15 +271,16 @@ static int banshee_wait_idle(struct fb_i
 	banshee_make_room(par, 1);
 	tdfx_outl(par, COMMAND_3D, COMMAND_3D_NOP);
 
-	while(1) {
+ 	while (1) {
 		i = (tdfx_inl(par, STATUS) & STATUS_BUSY) ? 0 : i + 1;
-		if(i == 3) break;
+ 		if (i == 3)
+ 			break;
 	}
 	return 0;
 }
 
 /*
- * Set the color of a palette entry in 8bpp mode 
+ * Set the color of a palette entry in 8bpp mode
  */
 static inline void do_setpalentry(struct tdfx_par *par, unsigned regno, u32 c)
 {  
@@ -312,11 +289,11 @@ static inline void do_setpalentry(struct
 	tdfx_outl(par, DACDATA, c);
 }
 
-static u32 do_calc_pll(int freq, int* freq_out) 
+static u32 do_calc_pll(int freq, int *freq_out)
 {
 	int m, n, k, best_m, best_n, best_k, best_error;
 	int fref = 14318;
-  
+
 	best_error = freq;
 	best_n = best_m = best_k = 0;
 
@@ -336,17 +313,17 @@ static u32 do_calc_pll(int freq, int* fr
 				 * estimated n
 				 */
 				int f = fref * (n + 2) / (m + 2) / (1 << k);
-				int error = abs (f - freq);
+				int error = abs(f - freq);
 
 				/*
-				 *  If this is the closest we've come to the
+				 * If this is the closest we've come to the
 				 * target frequency then remember n, m and k
 				 */
-				if (error  < best_error) {
+				if (error < best_error) {
 					best_error = error;
-					best_n     = n;
-					best_m     = m;
-					best_k     = k;
+					best_n = n;
+					best_m = m;
+					best_k = k;
 				}
 			}
 		}
@@ -355,12 +332,12 @@ static u32 do_calc_pll(int freq, int* fr
 	n = best_n;
 	m = best_m;
 	k = best_k;
-	*freq_out = fref*(n + 2)/(m + 2)/(1 << k);
+	*freq_out = fref * (n + 2) / (m + 2) / (1 << k);
 
 	return (n << 8) | (m << 2) | k;
 }
 
-static void do_write_regs(struct fb_info *info, struct banshee_reg* reg) 
+static void do_write_regs(struct fb_info *info, struct banshee_reg *reg)
 {
 	struct tdfx_par *par = info->par;
 	int i;
@@ -372,13 +349,13 @@ static void do_write_regs(struct fb_info
 	crt_outb(par, 0x11, crt_inb(par, 0x11) & 0x7f); /* CRT unprotect */
 
 	banshee_make_room(par, 3);
-	tdfx_outl(par, VGAINIT1,	reg->vgainit1 &  0x001FFFFF);
-	tdfx_outl(par, VIDPROCCFG,	reg->vidcfg   & ~0x00000001);
+	tdfx_outl(par, VGAINIT1, reg->vgainit1 & 0x001FFFFF);
+	tdfx_outl(par, VIDPROCCFG, reg->vidcfg & ~0x00000001);
 #if 0
 	tdfx_outl(par, PLLCTRL1, reg->mempll);
 	tdfx_outl(par, PLLCTRL2, reg->gfxpll);
 #endif
-	tdfx_outl(par, PLLCTRL0,	reg->vidpll);
+	tdfx_outl(par, PLLCTRL0, reg->vidpll);
 
 	vga_outb(par, MISC_W, reg->misc[0x00] | 0x01);
 
@@ -401,31 +378,31 @@ static void do_write_regs(struct fb_info
 	vga_enable_video(par);
 
 	banshee_make_room(par, 11);
-	tdfx_outl(par, 	VGAINIT0,      reg->vgainit0);
-	tdfx_outl(par,	DACMODE,       reg->dacmode);
-	tdfx_outl(par,	VIDDESKSTRIDE, reg->stride);
-	tdfx_outl(par,	HWCURPATADDR,  0);
-   
-	tdfx_outl(par,	VIDSCREENSIZE,reg->screensize);
-	tdfx_outl(par,	VIDDESKSTART,	reg->startaddr);
-	tdfx_outl(par,	VIDPROCCFG,	reg->vidcfg);
-	tdfx_outl(par,	VGAINIT1,	reg->vgainit1);  
-	tdfx_outl(par,	MISCINIT0,	reg->miscinit0);	
-
-	banshee_make_room(par,	8);
-	tdfx_outl(par,	SRCBASE,         reg->srcbase);
-	tdfx_outl(par,	DSTBASE,         reg->dstbase);
-	tdfx_outl(par,	COMMANDEXTRA_2D, 0);
-	tdfx_outl(par,	CLIP0MIN,        0);
-	tdfx_outl(par,	CLIP0MAX,        0x0fff0fff);
-	tdfx_outl(par,	CLIP1MIN,        0);
-	tdfx_outl(par,	CLIP1MAX,        0x0fff0fff);
-	tdfx_outl(par,	SRCXY,	   0);
+	tdfx_outl(par, VGAINIT0, reg->vgainit0);
+	tdfx_outl(par, DACMODE, reg->dacmode);
+	tdfx_outl(par, VIDDESKSTRIDE, reg->stride);
+	tdfx_outl(par, HWCURPATADDR, 0);
+
+	tdfx_outl(par, VIDSCREENSIZE, reg->screensize);
+	tdfx_outl(par, VIDDESKSTART, reg->startaddr);
+	tdfx_outl(par, VIDPROCCFG, reg->vidcfg);
+	tdfx_outl(par, VGAINIT1, reg->vgainit1);
+	tdfx_outl(par, MISCINIT0, reg->miscinit0);
+
+	banshee_make_room(par, 8);
+	tdfx_outl(par, SRCBASE, reg->srcbase);
+	tdfx_outl(par, DSTBASE, reg->dstbase);
+	tdfx_outl(par, COMMANDEXTRA_2D, 0);
+	tdfx_outl(par, CLIP0MIN, 0);
+	tdfx_outl(par, CLIP0MAX, 0x0fff0fff);
+	tdfx_outl(par, CLIP1MIN, 0);
+	tdfx_outl(par, CLIP1MAX, 0x0fff0fff);
+	tdfx_outl(par, SRCXY, 0);
 
 	banshee_wait_idle(info);
 }
 
-static unsigned long do_lfb_size(struct tdfx_par *par, unsigned short dev_id) 
+static unsigned long do_lfb_size(struct tdfx_par *par, unsigned short dev_id)
 {
 	u32 draminit0;
 	u32 draminit1;
@@ -436,16 +413,17 @@ static unsigned long do_lfb_size(struct 
 	u32 lfbsize;
 	int has_sgram;
 
-	draminit0 = tdfx_inl(par, DRAMINIT0);  
+	draminit0 = tdfx_inl(par, DRAMINIT0);
 	draminit1 = tdfx_inl(par, DRAMINIT1);
 
 	num_chips = (draminit0 & DRAMINIT0_SGRAM_NUM) ? 8 : 4;
- 
+
 	if (dev_id < PCI_DEVICE_ID_3DFX_VOODOO5) {
 		/* Banshee/Voodoo3 */
 		has_sgram = draminit1 & DRAMINIT1_MEM_SDRAM;
-		chip_size = has_sgram ? ((draminit0 & DRAMINIT0_SGRAM_TYPE) ? 2 : 1)
-				      : 2;
+		chip_size = 2;
+		if (has_sgram)
+			chip_size = (draminit0 & DRAMINIT0_SGRAM_TYPE) ? 2 : 1;
 	} else {
 		/* Voodoo4/5 */
 		has_sgram = 0;
@@ -458,14 +436,14 @@ static unsigned long do_lfb_size(struct 
 	miscinit1 |= has_sgram ? 0 : MISCINIT1_2DBLOCK_DIS;
 	miscinit1 |= MISCINIT1_CLUT_INV;
 
-	banshee_make_room(par, 1); 
+	banshee_make_room(par, 1);
 	tdfx_outl(par, MISCINIT1, miscinit1);
 	return lfbsize;
 }
 
 /* ------------------------------------------------------------------------- */
 
-static int tdfxfb_check_var(struct fb_var_screeninfo *var,struct fb_info *info) 
+static int tdfxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct tdfx_par *par = info->par;
 	u32 lpitch;
@@ -490,67 +468,66 @@ static int tdfxfb_check_var(struct fb_va
 	/* Banshee doesn't support interlace, but Voodoo4/5 and probably Voodoo3 do. */
 	/* no direct information about device id now? use max_pixclock for this... */
 	if (((var->vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED) &&
-			(par->max_pixclock < VOODOO3_MAX_PIXCLOCK)) {
+	    (par->max_pixclock < VOODOO3_MAX_PIXCLOCK)) {
 		DPRINTK("interlace not supported\n");
 		return -EINVAL;
 	}
 
 	var->xres = (var->xres + 15) & ~15; /* could sometimes be 8 */
-	lpitch = var->xres * ((var->bits_per_pixel + 7)>>3);
-  
+	lpitch = var->xres * ((var->bits_per_pixel + 7) >> 3);
+
 	if (var->xres < 320 || var->xres > 2048) {
 		DPRINTK("width not supported: %u\n", var->xres);
 		return -EINVAL;
 	}
-  
+
 	if (var->yres < 200 || var->yres > 2048) {
 		DPRINTK("height not supported: %u\n", var->yres);
 		return -EINVAL;
 	}
-  
+
 	if (lpitch * var->yres_virtual > info->fix.smem_len) {
-		var->yres_virtual = info->fix.smem_len/lpitch;
+		var->yres_virtual = info->fix.smem_len / lpitch;
 		if (var->yres_virtual < var->yres) {
 			DPRINTK("no memory for screen (%ux%ux%u)\n",
-			var->xres, var->yres_virtual, var->bits_per_pixel);
+				var->xres, var->yres_virtual,
+				var->bits_per_pixel);
 			return -EINVAL;
 		}
 	}
-  
+
 	if (PICOS2KHZ(var->pixclock) > par->max_pixclock) {
-		DPRINTK("pixclock too high (%ldKHz)\n",PICOS2KHZ(var->pixclock));
+		DPRINTK("pixclock too high (%ldKHz)\n",
+			PICOS2KHZ(var->pixclock));
 		return -EINVAL;
 	}
 
-	switch(var->bits_per_pixel) {
-		case 8:
-			var->red.length = var->green.length = var->blue.length = 8;
-			break;
-		case 16:
-			var->red.offset   = 11;
-			var->red.length   = 5;
-			var->green.offset = 5;
-			var->green.length = 6;
-			var->blue.offset  = 0;
-			var->blue.length  = 5;
-			break;
-		case 24:
-			var->red.offset=16;
-			var->green.offset=8;
-			var->blue.offset=0;
-			var->red.length = var->green.length = var->blue.length = 8;
-		case 32:
-			var->red.offset   = 16;
-			var->green.offset = 8;
-			var->blue.offset  = 0;
-			var->red.length = var->green.length = var->blue.length = 8;
-			break;
+	switch (var->bits_per_pixel) {
+	case 8:
+		var->red.length = var->green.length = var->blue.length = 8;
+		break;
+	case 16:
+		var->red.offset   = 11;
+		var->red.length   = 5;
+		var->green.offset = 5;
+		var->green.length = 6;
+		var->blue.offset  = 0;
+		var->blue.length  = 5;
+		break;
+	case 32:
+	case 24:
+		var->red.offset=16;
+		var->green.offset=8;
+		var->blue.offset=0;
+		var->red.length = var->green.length = var->blue.length = 8;
+		break;
 	}
 	var->height = var->width = -1;
-  
+
 	var->accel_flags = FB_ACCELF_TEXT;
-	
-	DPRINTK("Checking graphics mode at %dx%d depth %d\n",  var->xres, var->yres, var->bits_per_pixel);
+
+	DPRINTK("Checking graphics mode at %dx%d depth %d\n",
+		var->xres, var->yres, var->bits_per_pixel);
 	return 0;
 }
 
@@ -563,26 +540,29 @@ static int tdfxfb_set_par(struct fb_info
 	struct banshee_reg reg;
 	int fout, freq;
 	u32 wd, cpp;
-  
-	par->baseline  = 0;
- 
+
+	par->baseline = 0;
+
 	memset(&reg, 0, sizeof(reg));
-	cpp = (info->var.bits_per_pixel + 7)/8;
- 
-	reg.vidcfg = VIDCFG_VIDPROC_ENABLE | VIDCFG_DESK_ENABLE | VIDCFG_CURS_X11 | ((cpp - 1) << VIDCFG_PIXFMT_SHIFT) | (cpp != 1 ? VIDCFG_CLUT_BYPASS : 0);
+	cpp = (info->var.bits_per_pixel + 7) / 8;
+
+	reg.vidcfg = VIDCFG_VIDPROC_ENABLE | VIDCFG_DESK_ENABLE |
+		     VIDCFG_CURS_X11 |
+		     ((cpp - 1) << VIDCFG_PIXFMT_SHIFT) |
+		     (cpp != 1 ? VIDCFG_CLUT_BYPASS : 0);
 
 	/* PLL settings */
 	freq = PICOS2KHZ(info->var.pixclock);
 
 	reg.dacmode = 0;
-	reg.vidcfg  &= ~VIDCFG_2X;
+	reg.vidcfg &= ~VIDCFG_2X;
 
 	hdispend = info->var.xres;
 	hsyncsta = hdispend + info->var.right_margin;
 	hsyncend = hsyncsta + info->var.hsync_len;
-	htotal   = hsyncend + info->var.left_margin;	
+	htotal   = hsyncend + info->var.left_margin;
 
-	if (freq > par->max_pixclock/2) {
+	if (freq > par->max_pixclock / 2) {
 		freq = freq > par->max_pixclock ? par->max_pixclock : freq;
 		reg.dacmode |= DACMODE_2X;
 		reg.vidcfg  |= VIDCFG_2X;
@@ -591,7 +571,7 @@ static int tdfxfb_set_par(struct fb_info
 		hsyncend >>= 1;
 		htotal   >>= 1;
 	}
-  
+
 	hd  = wd = (hdispend >> 3) - 1;
 	hs  = (hsyncsta >> 3) - 1;
 	he  = (hsyncend >> 3) - 1;
@@ -610,13 +590,13 @@ static int tdfxfb_set_par(struct fb_info
 		ve  = vs + info->var.vsync_len;
 		vbe = vt = ve + info->var.upper_margin - 1;
 	}
-  
+
 	/* this is all pretty standard VGA register stuffing */
-	reg.misc[0x00] = 0x0f | 
+	reg.misc[0x00] = 0x0f |
 			(info->var.xres < 400 ? 0xa0 :
 			 info->var.xres < 480 ? 0x60 :
 			 info->var.xres < 768 ? 0xe0 : 0x20);
-     
+
 	reg.gra[0x00] = 0x00;
 	reg.gra[0x01] = 0x00;
 	reg.gra[0x02] = 0x00;
@@ -660,17 +640,17 @@ static int tdfxfb_set_par(struct fb_info
 	reg.crt[0x02] = hbs;
 	reg.crt[0x03] = 0x80 | (hbe & 0x1f);
 	reg.crt[0x04] = hs;
-	reg.crt[0x05] = ((hbe & 0x20) << 2) | (he & 0x1f); 
+	reg.crt[0x05] = ((hbe & 0x20) << 2) | (he & 0x1f);
 	reg.crt[0x06] = vt;
 	reg.crt[0x07] = ((vs & 0x200) >> 2) |
 			((vd & 0x200) >> 3) |
 			((vt & 0x200) >> 4) | 0x10 |
 			((vbs & 0x100) >> 5) |
-			((vs  & 0x100) >> 6) |
-			((vd  & 0x100) >> 7) |
-			((vt  & 0x100) >> 8);
+			((vs & 0x100) >> 6) |
+			((vd & 0x100) >> 7) |
+			((vt & 0x100) >> 8);
 	reg.crt[0x08] = 0x00;
-	reg.crt[0x09] = 0x40 | ((vbs & 0x200) >> 4); 
+	reg.crt[0x09] = 0x40 | ((vbs & 0x200) >> 4);
 	reg.crt[0x0a] = 0x00;
 	reg.crt[0x0b] = 0x00;
 	reg.crt[0x0c] = 0x00;
@@ -678,28 +658,28 @@ static int tdfxfb_set_par(struct fb_info
 	reg.crt[0x0e] = 0x00;
 	reg.crt[0x0f] = 0x00;
 	reg.crt[0x10] = vs;
-	reg.crt[0x11] = (ve & 0x0f) | 0x20; 
+	reg.crt[0x11] = (ve & 0x0f) | 0x20;
 	reg.crt[0x12] = vd;
 	reg.crt[0x13] = wd;
 	reg.crt[0x14] = 0x00;
 	reg.crt[0x15] = vbs;
-	reg.crt[0x16] = vbe + 1; 
+	reg.crt[0x16] = vbe + 1;
 	reg.crt[0x17] = 0xc3;
 	reg.crt[0x18] = 0xff;
- 
+
 	/* Banshee's nonvga stuff */
-	reg.ext[0x00] = (((ht  & 0x100) >> 8) | 
-			((hd  & 0x100) >> 6) |
+	reg.ext[0x00] = (((ht & 0x100) >> 8) |
+			((hd & 0x100) >> 6) |
 			((hbs & 0x100) >> 4) |
-			((hbe &  0x40) >> 1) |
-			((hs  & 0x100) >> 2) |
-			((he  &  0x20) << 2)); 
-	reg.ext[0x01] = (((vt  & 0x400) >> 10) |
-			((vd  & 0x400) >>  8) | 
-			((vbs & 0x400) >>  6) |
-			((vbe & 0x400) >>  4));
+			((hbe & 0x40) >> 1) |
+			((hs & 0x100) >> 2) |
+			((he & 0x20) << 2));
+	reg.ext[0x01] = (((vt & 0x400) >> 10) |
+			((vd & 0x400) >> 8) |
+			((vbs & 0x400) >> 6) |
+			((vbe & 0x400) >> 4));
 
-	reg.vgainit0 = 	VGAINIT0_8BIT_DAC     |
+	reg.vgainit0 =	VGAINIT0_8BIT_DAC     |
 			VGAINIT0_EXT_ENABLE   |
 			VGAINIT0_WAKEUP_3C3   |
 			VGAINIT0_ALT_READBACK |
@@ -707,10 +687,10 @@ static int tdfxfb_set_par(struct fb_info
 	reg.vgainit1 = tdfx_inl(par, VGAINIT1) & 0x1fffff;
 
 	reg.cursloc   = 0;
-   
-	reg.cursc0    = 0; 
+
+	reg.cursc0    = 0;
 	reg.cursc1    = 0xffffff;
-   
+
 	reg.stride    = info->var.xres * cpp;
 	reg.startaddr = par->baseline * reg.stride;
 	reg.srcbase   = reg.startaddr;
@@ -721,7 +701,7 @@ static int tdfxfb_set_par(struct fb_info
 
 	reg.dacmode &= ~DACMODE_2X;
 	reg.vidcfg  &= ~VIDCFG_2X;
-	if (freq > par->max_pixclock/2) {
+	if (freq > par->max_pixclock / 2) {
 		freq = freq > par->max_pixclock ? par->max_pixclock : freq;
 		reg.dacmode |= DACMODE_2X;
 		reg.vidcfg  |= VIDCFG_2X;
@@ -746,43 +726,47 @@ static int tdfxfb_set_par(struct fb_info
 
 #if defined(__BIG_ENDIAN)
 	switch (info->var.bits_per_pixel) {
-		case 8:
-		case 24:
-			reg.miscinit0 &= ~(1 << 30);
-			reg.miscinit0 &= ~(1 << 31);
-			break;
-		case 16:
-			reg.miscinit0 |= (1 << 30);
-			reg.miscinit0 |= (1 << 31);
-			break;
-		case 32:
-			reg.miscinit0 |= (1 << 30);
-			reg.miscinit0 &= ~(1 << 31);
-			break;
+	case 8:
+	case 24:
+		reg.miscinit0 &= ~(1 << 30);
+		reg.miscinit0 &= ~(1 << 31);
+		break;
+	case 16:
+		reg.miscinit0 |= (1 << 30);
+		reg.miscinit0 |= (1 << 31);
+		break;
+	case 32:
+		reg.miscinit0 |= (1 << 30);
+		reg.miscinit0 &= ~(1 << 31);
+		break;
 	}
-#endif 
+#endif
 	do_write_regs(info, &reg);
 
 	/* Now change fb_fix_screeninfo according to changes in par */
-	info->fix.line_length = info->var.xres * ((info->var.bits_per_pixel + 7)>>3);
-	info->fix.visual = (info->var.bits_per_pixel == 8) 
+	info->fix.line_length =
+		info->var.xres * ((info->var.bits_per_pixel + 7) >> 3);
+	info->fix.visual = (info->var.bits_per_pixel == 8)
 				? FB_VISUAL_PSEUDOCOLOR
 				: FB_VISUAL_TRUECOLOR;
-	DPRINTK("Graphics mode is now set at %dx%d depth %d\n", info->var.xres, info->var.yres, info->var.bits_per_pixel);
-	return 0;	
+	DPRINTK("Graphics mode is now set at %dx%d depth %d\n",
+		info->var.xres, info->var.yres, info->var.bits_per_pixel);
+	return 0;
 }
 
 /* A handy macro shamelessly pinched from matroxfb */
-#define CNVT_TOHW(val,width) ((((val)<<(width))+0x7FFF-(val))>>16)
+#define CNVT_TOHW(val, width) ((((val)<<(width))+0x7FFF-(val))>>16)
 
-static int tdfxfb_setcolreg(unsigned regno, unsigned red, unsigned green,  
-			    unsigned blue,unsigned transp,struct fb_info *info) 
+static int tdfxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			    unsigned blue, unsigned transp,
+			    struct fb_info *info)
 {
 	struct tdfx_par *par = info->par;
 	u32 rgbcol;
-   
-	if (regno >= info->cmap.len || regno > 255) return 1;
-   
+
+	if (regno >= info->cmap.len || regno > 255)
+		return 1;
+
 	switch (info->fix.visual) {
 	case FB_VISUAL_PSEUDOCOLOR:
 		rgbcol =(((u32)red   & 0xff00) << 8) |
@@ -793,13 +777,13 @@ static int tdfxfb_setcolreg(unsigned reg
 	/* Truecolor has no hardware color palettes. */
 	case FB_VISUAL_TRUECOLOR:
 		if (regno < 16) {
-			rgbcol = (CNVT_TOHW( red, info->var.red.length) <<
+			rgbcol = (CNVT_TOHW(red, info->var.red.length) <<
 				  info->var.red.offset) |
-				(CNVT_TOHW( green, info->var.green.length) <<
+				(CNVT_TOHW(green, info->var.green.length) <<
 				 info->var.green.offset) |
-				(CNVT_TOHW( blue, info->var.blue.length) <<
+				(CNVT_TOHW(blue, info->var.blue.length) <<
 				 info->var.blue.offset) |
-				(CNVT_TOHW( transp, info->var.transp.length) <<
+				(CNVT_TOHW(transp, info->var.transp.length) <<
 				 info->var.transp.offset);
 			par->palette[regno] = rgbcol;
 		}
@@ -815,54 +799,54 @@ static int tdfxfb_setcolreg(unsigned reg
 
 /* 0 unblank, 1 blank, 2 no vsync, 3 no hsync, 4 off */
 static int tdfxfb_blank(int blank, struct fb_info *info)
-{ 
+{
 	struct tdfx_par *par = info->par;
 	u32 dacmode, state = 0, vgablank = 0;
 
 	dacmode = tdfx_inl(par, DACMODE);
 
 	switch (blank) {
-		case FB_BLANK_UNBLANK: /* Screen: On; HSync: On, VSync: On */
-			state    = 0;
-			vgablank = 0;
-			break;
-		case FB_BLANK_NORMAL: /* Screen: Off; HSync: On, VSync: On */
-			state    = 0;
-			vgablank = 1;
-			break;
-		case FB_BLANK_VSYNC_SUSPEND: /* Screen: Off; HSync: On, VSync: Off */
-			state    = BIT(3);
-			vgablank = 1;
-			break;
-		case FB_BLANK_HSYNC_SUSPEND: /* Screen: Off; HSync: Off, VSync: On */
-			state    = BIT(1);
-			vgablank = 1;
-			break;
-		case FB_BLANK_POWERDOWN: /* Screen: Off; HSync: Off, VSync: Off */
-			state    = BIT(1) | BIT(3);
-			vgablank = 1;
-			break;
+	case FB_BLANK_UNBLANK: /* Screen: On; HSync: On, VSync: On */
+		state    = 0;
+		vgablank = 0;
+		break;
+	case FB_BLANK_NORMAL: /* Screen: Off; HSync: On, VSync: On */
+		state    = 0;
+		vgablank = 1;
+		break;
+	case FB_BLANK_VSYNC_SUSPEND: /* Screen: Off; HSync: On, VSync: Off */
+		state    = BIT(3);
+		vgablank = 1;
+		break;
+	case FB_BLANK_HSYNC_SUSPEND: /* Screen: Off; HSync: Off, VSync: On */
+		state    = BIT(1);
+		vgablank = 1;
+		break;
+	case FB_BLANK_POWERDOWN: /* Screen: Off; HSync: Off, VSync: Off */
+		state    = BIT(1) | BIT(3);
+		vgablank = 1;
+		break;
 	}
 
 	dacmode &= ~(BIT(1) | BIT(3));
 	dacmode |= state;
-	banshee_make_room(par, 1); 
+	banshee_make_room(par, 1);
 	tdfx_outl(par, DACMODE, dacmode);
-	if (vgablank) 
+	if (vgablank)
 		vga_disable_video(par);
 	else
 		vga_enable_video(par);
 	return 0;
 }
 
-/*   
+/*
  * Set the starting position of the visible screen to var->yoffset
- */   
+ */
 static int tdfxfb_pan_display(struct fb_var_screeninfo *var,
-			      struct fb_info *info) 
+			      struct fb_info *info)
 {
 	struct tdfx_par *par = info->par;
-	u32 addr;  	
+	u32 addr;
 
 	if (nopan || var->xoffset || (var->yoffset > var->yres_virtual))
 		return -EINVAL;
@@ -872,84 +856,86 @@ static int tdfxfb_pan_display(struct fb_
 	addr = var->yoffset * info->fix.line_length;
 	banshee_make_room(par, 1);
 	tdfx_outl(par, VIDDESKSTART, addr);
-   
+
 	info->var.xoffset = var->xoffset;
-	info->var.yoffset = var->yoffset; 
+	info->var.yoffset = var->yoffset;
 	return 0;
 }
 
 #ifdef CONFIG_FB_3DFX_ACCEL
 /*
- * FillRect 2D command (solidfill or invert (via ROP_XOR))   
+ * FillRect 2D command (solidfill or invert (via ROP_XOR))
  */
-static void tdfxfb_fillrect(struct fb_info *info, const struct fb_fillrect *rect) 
+static void tdfxfb_fillrect(struct fb_info *info,
+			    const struct fb_fillrect *rect)
 {
 	struct tdfx_par *par = info->par;
 	u32 bpp = info->var.bits_per_pixel;
 	u32 stride = info->fix.line_length;
-	u32 fmt= stride | ((bpp+((bpp==8) ? 0 : 8)) << 13); 
+	u32 fmt= stride | ((bpp + ((bpp == 8) ? 0 : 8)) << 13);
 	int tdfx_rop;
-   	
-	if (rect->rop == ROP_COPY) 
+
+	if (rect->rop == ROP_COPY)
 		tdfx_rop = TDFX_ROP_COPY;
-	else 			 
+	else
 		tdfx_rop = TDFX_ROP_XOR;
 
 	banshee_make_room(par, 5);
-	tdfx_outl(par,	DSTFORMAT, fmt);
+	tdfx_outl(par, DSTFORMAT, fmt);
 	if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR) {
-		tdfx_outl(par,	COLORFORE, rect->color);
+		tdfx_outl(par, COLORFORE, rect->color);
 	} else { /* FB_VISUAL_TRUECOLOR */
 		tdfx_outl(par, COLORFORE, par->palette[rect->color]);
 	}
-	tdfx_outl(par,	COMMAND_2D, COMMAND_2D_FILLRECT | (tdfx_rop << 24));
-	tdfx_outl(par,	DSTSIZE,    rect->width | (rect->height << 16));
-	tdfx_outl(par,	LAUNCH_2D,  rect->dx | (rect->dy << 16));
+	tdfx_outl(par, COMMAND_2D, COMMAND_2D_FILLRECT | (tdfx_rop << 24));
+	tdfx_outl(par, DSTSIZE, rect->width | (rect->height << 16));
+	tdfx_outl(par, LAUNCH_2D, rect->dx | (rect->dy << 16));
 }
 
 /*
- * Screen-to-Screen BitBlt 2D command (for the bmove fb op.) 
+ * Screen-to-Screen BitBlt 2D command (for the bmove fb op.)
  */
-static void tdfxfb_copyarea(struct fb_info *info, const struct fb_copyarea *area)  
+static void tdfxfb_copyarea(struct fb_info *info,
+			    const struct fb_copyarea *area)
 {
 	struct tdfx_par *par = info->par;
-   	u32 sx = area->sx, sy = area->sy, dx = area->dx, dy = area->dy;
+	u32 sx = area->sx, sy = area->sy, dx = area->dx, dy = area->dy;
 	u32 bpp = info->var.bits_per_pixel;
 	u32 stride = info->fix.line_length;
 	u32 blitcmd = COMMAND_2D_S2S_BITBLT | (TDFX_ROP_COPY << 24);
-	u32 fmt = stride | ((bpp+((bpp==8) ? 0 : 8)) << 13); 
-	
+	u32 fmt = stride | ((bpp + ((bpp == 8) ? 0 : 8)) << 13);
+
 	if (area->sx <= area->dx) {
-		//-X 
+		//-X
 		blitcmd |= BIT(14);
 		sx += area->width - 1;
 		dx += area->width - 1;
 	}
 	if (area->sy <= area->dy) {
-		//-Y  
+		//-Y
 		blitcmd |= BIT(15);
 		sy += area->height - 1;
 		dy += area->height - 1;
 	}
-   
+
 	banshee_make_room(par, 6);
 
-	tdfx_outl(par,	SRCFORMAT, fmt);
-	tdfx_outl(par,	DSTFORMAT, fmt);
-	tdfx_outl(par,	COMMAND_2D, blitcmd); 
-	tdfx_outl(par,	DSTSIZE,   area->width | (area->height << 16));
-	tdfx_outl(par,	DSTXY,     dx | (dy << 16));
-	tdfx_outl(par,	LAUNCH_2D, sx | (sy << 16)); 
+	tdfx_outl(par, SRCFORMAT, fmt);
+	tdfx_outl(par, DSTFORMAT, fmt);
+	tdfx_outl(par, COMMAND_2D, blitcmd);
+	tdfx_outl(par, DSTSIZE, area->width | (area->height << 16));
+	tdfx_outl(par, DSTXY, dx | (dy << 16));
+	tdfx_outl(par, LAUNCH_2D, sx | (sy << 16));
 }
 
-static void tdfxfb_imageblit(struct fb_info *info, const struct fb_image *image) 
+static void tdfxfb_imageblit(struct fb_info *info, const struct fb_image *image)
 {
 	struct tdfx_par *par = info->par;
-	int size = image->height * ((image->width * image->depth + 7)>>3);
+	int size = image->height * ((image->width * image->depth + 7) >> 3);
 	int fifo_free;
 	int i, stride = info->fix.line_length;
 	u32 bpp = info->var.bits_per_pixel;
-	u32 dstfmt = stride | ((bpp+((bpp==8) ? 0 : 8)) << 13); 
+	u32 dstfmt = stride | ((bpp + ((bpp == 8) ? 0 : 8)) << 13);
 	u8 *chardata = (u8 *) image->data;
 	u32 srcfmt;
 
@@ -961,53 +947,61 @@ static void tdfxfb_imageblit(struct fb_i
 	} else {
 		banshee_make_room(par, 8);
 		switch (info->fix.visual) {
-			case FB_VISUAL_PSEUDOCOLOR:
-		tdfx_outl(par, COLORFORE, image->fg_color);
-		tdfx_outl(par, COLORBACK, image->bg_color);
-				break;
-			case FB_VISUAL_TRUECOLOR:
-			default:
-				tdfx_outl(par, COLORFORE,
-					  par->palette[image->fg_color]);
-				tdfx_outl(par, COLORBACK,
-					  par->palette[image->bg_color]);
+		case FB_VISUAL_PSEUDOCOLOR:
+			tdfx_outl(par, COLORFORE, image->fg_color);
+			tdfx_outl(par, COLORBACK, image->bg_color);
+			break;
+		case FB_VISUAL_TRUECOLOR:
+		default:
+			tdfx_outl(par, COLORFORE,
+				  par->palette[image->fg_color]);
+			tdfx_outl(par, COLORBACK,
+				  par->palette[image->bg_color]);
 		}
 #ifdef __BIG_ENDIAN
 		srcfmt = 0x400000 | BIT(20);
 #else
 		srcfmt = 0x400000;
 #endif
-	}	
+	}
 
-	tdfx_outl(par,	SRCXY,     0);
-	tdfx_outl(par,	DSTXY,     image->dx | (image->dy << 16));
-	tdfx_outl(par,	COMMAND_2D, COMMAND_2D_H2S_BITBLT | (TDFX_ROP_COPY << 24));
-	tdfx_outl(par,	SRCFORMAT, srcfmt);
-	tdfx_outl(par,	DSTFORMAT, dstfmt);
-	tdfx_outl(par,	DSTSIZE,   image->width | (image->height << 16));
+	tdfx_outl(par, SRCXY, 0);
+	tdfx_outl(par, DSTXY, image->dx | (image->dy << 16));
+	tdfx_outl(par, COMMAND_2D, COMMAND_2D_H2S_BITBLT | (TDFX_ROP_COPY << 24));
+	tdfx_outl(par, SRCFORMAT, srcfmt);
+	tdfx_outl(par, DSTFORMAT, dstfmt);
+	tdfx_outl(par, DSTSIZE, image->width | (image->height << 16));
 
 	/* A count of how many free FIFO entries we've requested.
 	 * When this goes negative, we need to request more. */
 	fifo_free = 0;
 
-	/* Send four bytes at a time of data */	
-	for (i = (size >> 2) ; i > 0; i--) { 
-		if(--fifo_free < 0) {
-			fifo_free=31;
-			banshee_make_room(par,fifo_free);
+	/* Send four bytes at a time of data */
+	for (i = (size >> 2); i > 0; i--) {
+		if (--fifo_free < 0) {
+			fifo_free = 31;
+			banshee_make_room(par, fifo_free);
 		}
-		tdfx_outl(par,	LAUNCH_2D,*(u32*)chardata);
-		chardata += 4; 
-	}	
-
-	/* Send the leftovers now */	
-	banshee_make_room(par,3);
-	i = size%4;	
+		tdfx_outl(par, LAUNCH_2D, *(u32*)chardata);
+		chardata += 4;
+	}
+
+	/* Send the leftovers now */
+	banshee_make_room(par, 3);
+	i = size % 4;
 	switch (i) {
-		case 0: break;
-		case 1:  tdfx_outl(par,	LAUNCH_2D,*chardata); break;
-		case 2:  tdfx_outl(par,	LAUNCH_2D,*(u16*)chardata); break;
-		case 3:  tdfx_outl(par,	LAUNCH_2D,*(u16*)chardata | ((chardata[3]) << 24)); break;
+	case 0:
+		break;
+	case 1:
+		tdfx_outl(par, LAUNCH_2D, *chardata);
+		break;
+	case 2:
+		tdfx_outl(par, LAUNCH_2D, *(u16*)chardata);
+		break;
+	case 3:
+		tdfx_outl(par, LAUNCH_2D,
+			*(u16*)chardata | ((chardata[3]) << 24));
+		break;
 	}
 }
 #endif /* CONFIG_FB_3DFX_ACCEL */
@@ -1019,19 +1013,20 @@ static int tdfxfb_cursor(struct fb_info 
 	unsigned long flags;
 
 	/*
-	 * If the cursor is not be changed this means either we want the 
+	 * If the cursor is not be changed this means either we want the
 	 * current cursor state (if enable is set) or we want to query what
-	 * we can do with the cursor (if enable is not set) 
- 	 */
-	if (!cursor->set) return 0;
+	 * we can do with the cursor (if enable is not set)
+	 */
+	if (!cursor->set)
+		return 0;
 
 	/* Too large of a cursor :-( */
 	if (cursor->image.width > 64 || cursor->image.height > 64)
 		return -ENXIO;
 
-	/* 
+	/*
 	 * If we are going to be changing things we should disable
-	 * the cursor first 
+	 * the cursor first
 	 */
 	if (info->cursor.enable) {
 		spin_lock_irqsave(&par->DAClock, flags);
@@ -1052,11 +1047,11 @@ static int tdfxfb_cursor(struct fb_info 
 
 		cmap.len = 2; /* Voodoo 3+ only support 2 color cursors */
 		fg_color = ((cmap.red[cmap.start] << 16) |
-			    (cmap.green[cmap.start] << 8)  |
+			    (cmap.green[cmap.start] << 8) |
 			    (cmap.blue[cmap.start]));
-		bg_color = ((cmap.red[cmap.start+1] << 16) |
-			    (cmap.green[cmap.start+1] << 8) |
-			    (cmap.blue[cmap.start+1]));
+		bg_color = ((cmap.red[cmap.start + 1] << 16) |
+			    (cmap.green[cmap.start + 1] << 8) |
+			    (cmap.blue[cmap.start + 1]));
 		fb_copy_cmap(&cmap, &info->cursor.image.cmap);
 		spin_lock_irqsave(&par->DAClock, flags);
 		banshee_make_room(par, 2);
@@ -1089,7 +1084,7 @@ static int tdfxfb_cursor(struct fb_info 
 
 	if (cursor->set && FB_CUR_SETSHAPE) {
 		/*
-	 	 * Voodoo 3 and above cards use 2 monochrome cursor patterns.
+		 * Voodoo 3 and above cards use 2 monochrome cursor patterns.
 		 *    The reason is so the card can fetch 8 words at a time
 		 * and are stored on chip for use for the next 8 scanlines.
 		 * This reduces the number of times for access to draw the
@@ -1106,9 +1101,9 @@ static int tdfxfb_cursor(struct fb_info 
 		 * (128 bits) which is the maximum cursor width times two for
 		 * the two monochrome patterns.
 		 */
-		u8 *cursorbase = (u8 *) info->cursor.image.data;
+		u8 *cursorbase = (u8 *)info->cursor.image.data;
 		char *bitmap = (char *)cursor->image.data;
-		char *mask = (char *) cursor->mask;
+		char *mask = (char *)cursor->mask;
 		int i, j, k, h = 0;
 
 		for (i = 0; i < 64; i++) {
@@ -1116,16 +1111,16 @@ static int tdfxfb_cursor(struct fb_info 
 				j = (cursor->image.width + 7) >> 3;
 				k = 8 - j;
 
-				for (;j > 0; j--) {
-				/* Pattern 0. Copy the cursor bitmap to it */
+				for (; j > 0; j--) {
+					/* Pattern 0. Copy the cursor bitmap to it */
 					fb_writeb(*bitmap, cursorbase + h);
 					bitmap++;
-				/* Pattern 1. Copy the cursor mask to it */
+					/* Pattern 1. Copy the cursor mask to it */
 					fb_writeb(*mask, cursorbase + h + 8);
 					mask++;
 					h++;
 				}
-				for (;k > 0; k--) {
+				for (; k > 0; k--) {
 					fb_writeb(0, cursorbase + h);
 					fb_writeb(~0, cursorbase + h + 8);
 					h++;
@@ -1142,7 +1137,7 @@ static int tdfxfb_cursor(struct fb_info 
 	/* Turn the cursor on */
 	cursor->enable = 1;
 	info->cursor = *cursor;
-	mod_timer(&par->hwcursor.timer, jiffies+HZ/2);
+	mod_timer(&par->hwcursor.timer, jiffies + HZ / 2);
 	spin_lock_irqsave(&par->DAClock, flags);
 	banshee_make_room(par, 1);
 	tdfx_outl(par, VIDPROCCFG, par->hwcursor.enable);
@@ -1151,6 +1146,25 @@ static int tdfxfb_cursor(struct fb_info 
 }
 #endif
 
+static struct fb_ops tdfxfb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_check_var	= tdfxfb_check_var,
+	.fb_set_par	= tdfxfb_set_par,
+	.fb_setcolreg	= tdfxfb_setcolreg,
+	.fb_blank	= tdfxfb_blank,
+	.fb_pan_display	= tdfxfb_pan_display,
+	.fb_sync	= banshee_wait_idle,
+#ifdef CONFIG_FB_3DFX_ACCEL
+	.fb_fillrect	= tdfxfb_fillrect,
+	.fb_copyarea	= tdfxfb_copyarea,
+	.fb_imageblit	= tdfxfb_imageblit,
+#else
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+#endif
+};
+
 /**
  *      tdfxfb_probe - Device Initializiation
  *
@@ -1161,7 +1175,7 @@ static int tdfxfb_cursor(struct fb_info 
  *
  */
 static int __devinit tdfxfb_probe(struct pci_dev *pdev,
-                                  const struct pci_device_id *id)
+				  const struct pci_device_id *id)
 {
 	struct tdfx_par *default_par;
 	struct fb_info *info;
@@ -1176,56 +1190,57 @@ static int __devinit tdfxfb_probe(struct
 
 	if (!info)
 		return -ENOMEM;
-		
+
 	default_par = info->par;
- 
+
 	/* Configure the default fb_fix_screeninfo first */
 	switch (pdev->device) {
-		case PCI_DEVICE_ID_3DFX_BANSHEE:	
-			strcat(tdfx_fix.id, " Banshee");
-			default_par->max_pixclock = BANSHEE_MAX_PIXCLOCK;
-			break;
-		case PCI_DEVICE_ID_3DFX_VOODOO3:
-			strcat(tdfx_fix.id, " Voodoo3");
-			default_par->max_pixclock = VOODOO3_MAX_PIXCLOCK;
-			break;
-		case PCI_DEVICE_ID_3DFX_VOODOO5:
-			strcat(tdfx_fix.id, " Voodoo5");
-			default_par->max_pixclock = VOODOO5_MAX_PIXCLOCK;
-			break;
+	case PCI_DEVICE_ID_3DFX_BANSHEE:
+		strcat(tdfx_fix.id, " Banshee");
+		default_par->max_pixclock = BANSHEE_MAX_PIXCLOCK;
+		break;
+	case PCI_DEVICE_ID_3DFX_VOODOO3:
+		strcat(tdfx_fix.id, " Voodoo3");
+		default_par->max_pixclock = VOODOO3_MAX_PIXCLOCK;
+		break;
+	case PCI_DEVICE_ID_3DFX_VOODOO5:
+		strcat(tdfx_fix.id, " Voodoo5");
+		default_par->max_pixclock = VOODOO5_MAX_PIXCLOCK;
+		break;
 	}
 
 	tdfx_fix.mmio_start = pci_resource_start(pdev, 0);
 	tdfx_fix.mmio_len = pci_resource_len(pdev, 0);
-	default_par->regbase_virt = ioremap_nocache(tdfx_fix.mmio_start, tdfx_fix.mmio_len);
+	default_par->regbase_virt =
+		ioremap_nocache(tdfx_fix.mmio_start, tdfx_fix.mmio_len);
 	if (!default_par->regbase_virt) {
 		printk("fb: Can't remap %s register area.\n", tdfx_fix.id);
 		goto out_err;
 	}
-    
+
 	if (!request_mem_region(pci_resource_start(pdev, 0),
-	    pci_resource_len(pdev, 0), "tdfx regbase")) {
+				pci_resource_len(pdev, 0), "tdfx regbase")) {
 		printk(KERN_WARNING "tdfxfb: Can't reserve regbase\n");
 		goto out_err;
-	} 
+	}
 
 	tdfx_fix.smem_start = pci_resource_start(pdev, 1);
 	if (!(tdfx_fix.smem_len = do_lfb_size(default_par, pdev->device))) {
 		printk("fb: Can't count %s memory.\n", tdfx_fix.id);
 		release_mem_region(pci_resource_start(pdev, 0),
 				   pci_resource_len(pdev, 0));
-		goto out_err;	
+		goto out_err;
 	}
 
 	if (!request_mem_region(pci_resource_start(pdev, 1),
-	     pci_resource_len(pdev, 1), "tdfx smem")) {
+				pci_resource_len(pdev, 1), "tdfx smem")) {
 		printk(KERN_WARNING "tdfxfb: Can't reserve smem\n");
 		release_mem_region(pci_resource_start(pdev, 0),
 				   pci_resource_len(pdev, 0));
 		goto out_err;
 	}
 
-	info->screen_base = ioremap_nocache(tdfx_fix.smem_start, 
+	info->screen_base = ioremap_nocache(tdfx_fix.smem_start,
 					    tdfx_fix.smem_len);
 	if (!info->screen_base) {
 		printk("fb: Can't remap %s framebuffer.\n", tdfx_fix.id);
@@ -1237,9 +1252,9 @@ static int __devinit tdfxfb_probe(struct
 	}
 
 	default_par->iobase = pci_resource_start(pdev, 2);
-    
+
 	if (!request_region(pci_resource_start(pdev, 2),
-	    pci_resource_len(pdev, 2), "tdfx iobase")) {
+			    pci_resource_len(pdev, 2), "tdfx iobase")) {
 		printk(KERN_WARNING "tdfxfb: Can't reserve iobase\n");
 		release_mem_region(pci_resource_start(pdev, 1),
 				   pci_resource_len(pdev, 1));
@@ -1252,9 +1267,9 @@ static int __devinit tdfxfb_probe(struct
 
 	tdfx_fix.ypanstep	= nopan ? 0 : 1;
 	tdfx_fix.ywrapstep	= nowrap ? 0 : 1;
-   
+
 	info->fbops		= &tdfxfb_ops;
-	info->fix		= tdfx_fix; 	
+	info->fix		= tdfx_fix;
 	info->pseudo_palette	= default_par->palette;
 	info->flags		= FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 #ifdef CONFIG_FB_3DFX_ACCEL
@@ -1264,14 +1279,14 @@ static int __devinit tdfxfb_probe(struct
 
 	if (!mode_option)
 		mode_option = "640x480@60";
-	 
-	err = fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 8); 
+
+	err = fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 8);
 	if (!err || err == 4)
 		info->var = tdfx_var;
 
 	/* maximize virtual vertical length */
 	lpitch = info->var.xres_virtual * ((info->var.bits_per_pixel + 7) >> 3);
-	info->var.yres_virtual = info->fix.smem_len/lpitch;
+	info->var.yres_virtual = info->fix.smem_len / lpitch;
 	if (info->var.yres_virtual < info->var.yres)
 		goto out_err;
 
@@ -1299,7 +1314,7 @@ static int __devinit tdfxfb_probe(struct
 	 * Our driver data
 	 */
 	pci_set_drvdata(pdev, info);
-	return 0; 
+	return 0;
 
 out_err:
 	/*
@@ -1316,7 +1331,7 @@ out_err:
 #ifndef MODULE
 static void tdfxfb_setup(char *options)
 {
-	char* this_opt;
+	char *this_opt;
 
 	if (!options || !*options)
 		return;
@@ -1324,9 +1339,9 @@ static void tdfxfb_setup(char *options)
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
-		if(!strcmp(this_opt, "nopan")) {
+		if (!strcmp(this_opt, "nopan")) {
 			nopan = 1;
-		} else if(!strcmp(this_opt, "nowrap")) {
+		} else if (!strcmp(this_opt, "nowrap")) {
 			nowrap = 1;
 		} else {
 			mode_option = this_opt;
@@ -1374,17 +1389,17 @@ static int __init tdfxfb_init(void)
 
 	tdfxfb_setup(option);
 #endif
-        return pci_register_driver(&tdfxfb_driver);
+	return pci_register_driver(&tdfxfb_driver);
 }
 
 static void __exit tdfxfb_exit(void)
 {
-        pci_unregister_driver(&tdfxfb_driver);
+	pci_unregister_driver(&tdfxfb_driver);
 }
 
 MODULE_AUTHOR("Hannu Mallat <hmallat@cc.hut.fi>");
 MODULE_DESCRIPTION("3Dfx framebuffer device driver");
 MODULE_LICENSE("GPL");
- 
+
 module_init(tdfxfb_init);
 module_exit(tdfxfb_exit);
diff -puN include/video/tdfx.h~tdfxfb-coding-style-improvement include/video/tdfx.h
--- a/include/video/tdfx.h~tdfxfb-coding-style-improvement
+++ a/include/video/tdfx.h
@@ -2,140 +2,140 @@
 #define _TDFX_H
 
 /* membase0 register offsets */
-#define STATUS          0x00
-#define PCIINIT0        0x04
-#define SIPMONITOR      0x08
-#define LFBMEMORYCONFIG 0x0c
-#define MISCINIT0       0x10
-#define MISCINIT1       0x14
-#define DRAMINIT0       0x18
-#define DRAMINIT1       0x1c
-#define AGPINIT         0x20
-#define TMUGBEINIT      0x24
-#define VGAINIT0        0x28
-#define VGAINIT1        0x2c
-#define DRAMCOMMAND     0x30
-#define DRAMDATA        0x34
-/* reserved             0x38 */
-/* reserved             0x3c */
-#define PLLCTRL0        0x40
-#define PLLCTRL1        0x44
-#define PLLCTRL2        0x48
-#define DACMODE         0x4c
-#define DACADDR         0x50
-#define DACDATA         0x54
-#define RGBMAXDELTA     0x58
-#define VIDPROCCFG      0x5c
-#define HWCURPATADDR    0x60
-#define HWCURLOC        0x64
-#define HWCURC0         0x68
-#define HWCURC1         0x6c
-#define VIDINFORMAT     0x70
-#define VIDINSTATUS     0x74
-#define VIDSERPARPORT   0x78
-#define VIDINXDELTA     0x7c
-#define VIDININITERR    0x80
-#define VIDINYDELTA     0x84
-#define VIDPIXBUFTHOLD  0x88
-#define VIDCHRMIN       0x8c
-#define VIDCHRMAX       0x90
-#define VIDCURLIN       0x94
-#define VIDSCREENSIZE   0x98
-#define VIDOVRSTARTCRD  0x9c
-#define VIDOVRENDCRD    0xa0
-#define VIDOVRDUDX      0xa4
-#define VIDOVRDUDXOFF   0xa8
-#define VIDOVRDVDY      0xac
-/*  ... */
-#define VIDOVRDVDYOFF   0xe0
-#define VIDDESKSTART    0xe4
-#define VIDDESKSTRIDE   0xe8
-#define VIDINADDR0      0xec
-#define VIDINADDR1      0xf0
-#define VIDINADDR2      0xf4
-#define VIDINSTRIDE     0xf8
-#define VIDCUROVRSTART  0xfc
-
-#define INTCTRL         (0x00100000 + 0x04)
-#define CLIP0MIN        (0x00100000 + 0x08)
-#define CLIP0MAX        (0x00100000 + 0x0c)
-#define DSTBASE         (0x00100000 + 0x10)
-#define DSTFORMAT       (0x00100000 + 0x14)
-#define SRCBASE         (0x00100000 + 0x34)
-#define COMMANDEXTRA_2D (0x00100000 + 0x38)
-#define CLIP1MIN        (0x00100000 + 0x4c)
-#define CLIP1MAX        (0x00100000 + 0x50)
-#define SRCFORMAT       (0x00100000 + 0x54)
-#define SRCSIZE         (0x00100000 + 0x58)
-#define SRCXY           (0x00100000 + 0x5c)
-#define COLORBACK       (0x00100000 + 0x60)
-#define COLORFORE       (0x00100000 + 0x64)
-#define DSTSIZE         (0x00100000 + 0x68)
-#define DSTXY           (0x00100000 + 0x6c)
-#define COMMAND_2D      (0x00100000 + 0x70)
-#define LAUNCH_2D       (0x00100000 + 0x80)
+#define STATUS		0x00
+#define PCIINIT0	0x04
+#define SIPMONITOR	0x08
+#define LFBMEMORYCONFIG	0x0c
+#define MISCINIT0	0x10
+#define MISCINIT1	0x14
+#define DRAMINIT0	0x18
+#define DRAMINIT1	0x1c
+#define AGPINIT		0x20
+#define TMUGBEINIT	0x24
+#define VGAINIT0	0x28
+#define VGAINIT1	0x2c
+#define DRAMCOMMAND	0x30
+#define DRAMDATA	0x34
+/* reserved	0x38 */
+/* reserved	0x3c */
+#define PLLCTRL0	0x40
+#define PLLCTRL1	0x44
+#define PLLCTRL2	0x48
+#define DACMODE		0x4c
+#define DACADDR		0x50
+#define DACDATA		0x54
+#define RGBMAXDELTA	0x58
+#define VIDPROCCFG	0x5c
+#define HWCURPATADDR	0x60
+#define HWCURLOC	0x64
+#define HWCURC0		0x68
+#define HWCURC1		0x6c
+#define VIDINFORMAT	0x70
+#define VIDINSTATUS	0x74
+#define VIDSERPARPORT	0x78
+#define VIDINXDELTA	0x7c
+#define VIDININITERR	0x80
+#define VIDINYDELTA	0x84
+#define VIDPIXBUFTHOLD	0x88
+#define VIDCHRMIN	0x8c
+#define VIDCHRMAX	0x90
+#define VIDCURLIN	0x94
+#define VIDSCREENSIZE	0x98
+#define VIDOVRSTARTCRD	0x9c
+#define VIDOVRENDCRD	0xa0
+#define VIDOVRDUDX	0xa4
+#define VIDOVRDUDXOFF	0xa8
+#define VIDOVRDVDY	0xac
+/* ... */
+#define VIDOVRDVDYOFF	0xe0
+#define VIDDESKSTART	0xe4
+#define VIDDESKSTRIDE	0xe8
+#define VIDINADDR0	0xec
+#define VIDINADDR1	0xf0
+#define VIDINADDR2	0xf4
+#define VIDINSTRIDE	0xf8
+#define VIDCUROVRSTART	0xfc
+
+#define INTCTRL		(0x00100000 + 0x04)
+#define CLIP0MIN	(0x00100000 + 0x08)
+#define CLIP0MAX	(0x00100000 + 0x0c)
+#define DSTBASE		(0x00100000 + 0x10)
+#define DSTFORMAT	(0x00100000 + 0x14)
+#define SRCBASE		(0x00100000 + 0x34)
+#define COMMANDEXTRA_2D	(0x00100000 + 0x38)
+#define CLIP1MIN	(0x00100000 + 0x4c)
+#define CLIP1MAX	(0x00100000 + 0x50)
+#define SRCFORMAT	(0x00100000 + 0x54)
+#define SRCSIZE		(0x00100000 + 0x58)
+#define SRCXY		(0x00100000 + 0x5c)
+#define COLORBACK	(0x00100000 + 0x60)
+#define COLORFORE	(0x00100000 + 0x64)
+#define DSTSIZE		(0x00100000 + 0x68)
+#define DSTXY		(0x00100000 + 0x6c)
+#define COMMAND_2D	(0x00100000 + 0x70)
+#define LAUNCH_2D	(0x00100000 + 0x80)
 
-#define COMMAND_3D      (0x00200000 + 0x120)
+#define COMMAND_3D	(0x00200000 + 0x120)
 
 /* register bitfields (not all, only as needed) */
 
-#define BIT(x) (1UL << (x))
+#define BIT(x)	(1UL << (x))
 
 /* COMMAND_2D reg. values */
-#define TDFX_ROP_COPY        0xcc     // src
-#define TDFX_ROP_INVERT      0x55     // NOT dst
-#define TDFX_ROP_XOR         0x66     // src XOR dst
-
-#define AUTOINC_DSTX                    BIT(10)
-#define AUTOINC_DSTY                    BIT(11)
-#define COMMAND_2D_FILLRECT             0x05
-#define COMMAND_2D_S2S_BITBLT           0x01      // screen to screen
-#define COMMAND_2D_H2S_BITBLT           0x03       // host to screen
-
-#define COMMAND_3D_NOP                  0x00
-#define STATUS_RETRACE                  BIT(6)
-#define STATUS_BUSY                     BIT(9)
-#define MISCINIT1_CLUT_INV              BIT(0)
-#define MISCINIT1_2DBLOCK_DIS           BIT(15)
-#define DRAMINIT0_SGRAM_NUM             BIT(26)
-#define DRAMINIT0_SGRAM_TYPE            BIT(27)
-#define DRAMINIT0_SGRAM_TYPE_MASK       (BIT(27)|BIT(28)|BIT(29))
+#define TDFX_ROP_COPY		0xcc	/* src */
+#define TDFX_ROP_INVERT		0x55	/* NOT dst */
+#define TDFX_ROP_XOR		0x66	/* src XOR dst */
+
+#define AUTOINC_DSTX			BIT(10)
+#define AUTOINC_DSTY			BIT(11)
+#define COMMAND_2D_FILLRECT		0x05
+#define COMMAND_2D_S2S_BITBLT		0x01	/* screen to screen */
+#define COMMAND_2D_H2S_BITBLT		0x03	/* host to screen */
+
+#define COMMAND_3D_NOP			0x00
+#define STATUS_RETRACE			BIT(6)
+#define STATUS_BUSY			BIT(9)
+#define MISCINIT1_CLUT_INV		BIT(0)
+#define MISCINIT1_2DBLOCK_DIS		BIT(15)
+#define DRAMINIT0_SGRAM_NUM		BIT(26)
+#define DRAMINIT0_SGRAM_TYPE		BIT(27)
+#define DRAMINIT0_SGRAM_TYPE_MASK       (BIT(27) | BIT(28) | BIT(29))
 #define DRAMINIT0_SGRAM_TYPE_SHIFT      27
-#define DRAMINIT1_MEM_SDRAM             BIT(30)
-#define VGAINIT0_VGA_DISABLE            BIT(0)
-#define VGAINIT0_EXT_TIMING             BIT(1)
-#define VGAINIT0_8BIT_DAC               BIT(2)
-#define VGAINIT0_EXT_ENABLE             BIT(6)
-#define VGAINIT0_WAKEUP_3C3             BIT(8)
-#define VGAINIT0_LEGACY_DISABLE         BIT(9)
-#define VGAINIT0_ALT_READBACK           BIT(10)
-#define VGAINIT0_FAST_BLINK             BIT(11)
-#define VGAINIT0_EXTSHIFTOUT            BIT(12)
-#define VGAINIT0_DECODE_3C6             BIT(13)
-#define VGAINIT0_SGRAM_HBLANK_DISABLE   BIT(22)
-#define VGAINIT1_MASK                   0x1fffff
-#define VIDCFG_VIDPROC_ENABLE           BIT(0)
-#define VIDCFG_CURS_X11                 BIT(1)
-#define VIDCFG_INTERLACE                BIT(3)
-#define VIDCFG_HALF_MODE                BIT(4)
-#define VIDCFG_DESK_ENABLE              BIT(7)
-#define VIDCFG_CLUT_BYPASS              BIT(10)
-#define VIDCFG_2X                       BIT(26)
-#define VIDCFG_HWCURSOR_ENABLE          BIT(27)
+#define DRAMINIT1_MEM_SDRAM		BIT(30)
+#define VGAINIT0_VGA_DISABLE		BIT(0)
+#define VGAINIT0_EXT_TIMING		BIT(1)
+#define VGAINIT0_8BIT_DAC		BIT(2)
+#define VGAINIT0_EXT_ENABLE		BIT(6)
+#define VGAINIT0_WAKEUP_3C3		BIT(8)
+#define VGAINIT0_LEGACY_DISABLE		BIT(9)
+#define VGAINIT0_ALT_READBACK		BIT(10)
+#define VGAINIT0_FAST_BLINK		BIT(11)
+#define VGAINIT0_EXTSHIFTOUT		BIT(12)
+#define VGAINIT0_DECODE_3C6		BIT(13)
+#define VGAINIT0_SGRAM_HBLANK_DISABLE	BIT(22)
+#define VGAINIT1_MASK			0x1fffff
+#define VIDCFG_VIDPROC_ENABLE		BIT(0)
+#define VIDCFG_CURS_X11			BIT(1)
+#define VIDCFG_INTERLACE		BIT(3)
+#define VIDCFG_HALF_MODE		BIT(4)
+#define VIDCFG_DESK_ENABLE		BIT(7)
+#define VIDCFG_CLUT_BYPASS		BIT(10)
+#define VIDCFG_2X			BIT(26)
+#define VIDCFG_HWCURSOR_ENABLE		BIT(27)
 #define VIDCFG_PIXFMT_SHIFT             18
-#define DACMODE_2X                      BIT(0)
+#define DACMODE_2X			BIT(0)
 
 /* VGA rubbish, need to change this for multihead support */
-#define MISC_W  0x3c2
-#define MISC_R  0x3cc
-#define SEQ_I   0x3c4
-#define SEQ_D   0x3c5
-#define CRT_I   0x3d4
-#define CRT_D   0x3d5
-#define ATT_IW  0x3c0
-#define IS1_R   0x3da
-#define GRA_I   0x3ce
-#define GRA_D   0x3cf
+#define MISC_W		0x3c2
+#define MISC_R		0x3cc
+#define SEQ_I		0x3c4
+#define SEQ_D		0x3c5
+#define CRT_I		0x3d4
+#define CRT_D		0x3d5
+#define ATT_IW		0x3c0
+#define IS1_R		0x3da
+#define GRA_I		0x3ce
+#define GRA_D		0x3cf
 
 #ifdef __KERNEL__
 
@@ -143,9 +143,9 @@ struct banshee_reg {
 	/* VGA rubbish */
 	unsigned char att[21];
 	unsigned char crt[25];
-	unsigned char gra[ 9];
+	unsigned char gra[9];
 	unsigned char misc[1];
-	unsigned char seq[ 5];
+	unsigned char seq[5];
 
 	/* Banshee extensions */
 	unsigned char ext[2];
@@ -180,15 +180,15 @@ struct tdfx_par {
 	u32 baseline;
 
 	struct {
-		int w,u,d;
-		unsigned long enable,disable;
+		int w, u, d;
+		unsigned long enable, disable;
 		struct timer_list timer;
 	} hwcursor;
 
 	spinlock_t DAClock;
 };
 
-#endif /* __KERNEL__ */
+#endif	/* __KERNEL__ */
 
-#endif /* _TDFX_H */
+#endif	/* _TDFX_H */
 
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
