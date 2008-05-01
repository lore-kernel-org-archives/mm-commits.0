From: akpm@linux-foundation.org
Subject: - pxafb-fix-various-coding-style-issues-for-pxafb.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:03 -0700
Message-ID: <200805010925.m419P3qP030163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268AbYEAJZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:25:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: fix various coding style issues for pxafb
has been removed from the -mm tree.  Its filename was
     pxafb-fix-various-coding-style-issues-for-pxafb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: fix various coding style issues for pxafb
From: eric miao <eric.miao@marvell.com>

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |  280 ++++++++++++++++++++--------------------
 1 file changed, 144 insertions(+), 136 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-fix-various-coding-style-issues-for-pxafb drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-fix-various-coding-style-issues-for-pxafb
+++ a/drivers/video/pxafb.c
@@ -57,13 +57,18 @@
 #include "pxafb.h"
 
 /* Bits which should not be set in machine configuration structures */
-#define LCCR0_INVALID_CONFIG_MASK (LCCR0_OUM|LCCR0_BM|LCCR0_QDM|LCCR0_DIS|LCCR0_EFM|LCCR0_IUM|LCCR0_SFM|LCCR0_LDM|LCCR0_ENB)
-#define LCCR3_INVALID_CONFIG_MASK (LCCR3_HSP|LCCR3_VSP|LCCR3_PCD|LCCR3_BPP)
+#define LCCR0_INVALID_CONFIG_MASK	(LCCR0_OUM | LCCR0_BM | LCCR0_QDM |\
+					 LCCR0_DIS | LCCR0_EFM | LCCR0_IUM |\
+					 LCCR0_SFM | LCCR0_LDM | LCCR0_ENB)
+
+#define LCCR3_INVALID_CONFIG_MASK	(LCCR3_HSP | LCCR3_VSP |\
+					 LCCR3_PCD | LCCR3_BPP)
 
 static void (*pxafb_backlight_power)(int);
 static void (*pxafb_lcd_power)(int, struct fb_var_screeninfo *);
 
-static int pxafb_activate_var(struct fb_var_screeninfo *var, struct pxafb_info *);
+static int pxafb_activate_var(struct fb_var_screeninfo *var,
+				struct pxafb_info *);
 static void set_ctrlr_state(struct pxafb_info *fbi, u_int state);
 
 #ifdef CONFIG_FB_PXA_PARAMETERS
@@ -79,10 +84,12 @@ static inline void pxafb_schedule_work(s
 	/*
 	 * We need to handle two requests being made at the same time.
 	 * There are two important cases:
-	 *  1. When we are changing VT (C_REENABLE) while unblanking (C_ENABLE)
-	 *     We must perform the unblanking, which will do our REENABLE for us.
-	 *  2. When we are blanking, but immediately unblank before we have
-	 *     blanked.  We do the "REENABLE" thing here as well, just to be sure.
+	 *  1. When we are changing VT (C_REENABLE) while unblanking
+	 *     (C_ENABLE) We must perform the unblanking, which will
+	 *     do our REENABLE for us.
+	 *  2. When we are blanking, but immediately unblank before
+	 *     we have blanked.  We do the "REENABLE" thing here as
+	 *     well, just to be sure.
 	 */
 	if (fbi->task_state == C_ENABLE && state == C_REENABLE)
 		state = (u_int) -1;
@@ -129,13 +136,13 @@ pxafb_setpalettereg(u_int regno, u_int r
 		val  = ((red   << 8) & 0x00f80000);
 		val |= ((green >> 0) & 0x0000fc00);
 		val |= ((blue  >> 8) & 0x000000f8);
-		((u32*)(fbi->palette_cpu))[regno] = val;
+		((u32 *)(fbi->palette_cpu))[regno] = val;
 		break;
 	case LCCR4_PAL_FOR_2:
 		val  = ((red   << 8) & 0x00fc0000);
 		val |= ((green >> 0) & 0x0000fc00);
 		val |= ((blue  >> 8) & 0x000000fc);
-		((u32*)(fbi->palette_cpu))[regno] = val;
+		((u32 *)(fbi->palette_cpu))[regno] = val;
 		break;
 	}
 
@@ -203,15 +210,15 @@ pxafb_setcolreg(u_int regno, u_int red, 
  */
 static int pxafb_bpp_to_lccr3(struct fb_var_screeninfo *var)
 {
-        int ret = 0;
-        switch (var->bits_per_pixel) {
-        case 1:  ret = LCCR3_1BPP; break;
-        case 2:  ret = LCCR3_2BPP; break;
-        case 4:  ret = LCCR3_4BPP; break;
-        case 8:  ret = LCCR3_8BPP; break;
-        case 16: ret = LCCR3_16BPP; break;
-        }
-        return ret;
+	int ret = 0;
+	switch (var->bits_per_pixel) {
+	case 1:  ret = LCCR3_1BPP; break;
+	case 2:  ret = LCCR3_2BPP; break;
+	case 4:  ret = LCCR3_4BPP; break;
+	case 8:  ret = LCCR3_8BPP; break;
+	case 16: ret = LCCR3_16BPP; break;
+	}
+	return ret;
 }
 
 #ifdef CONFIG_CPU_FREQ
@@ -223,31 +230,32 @@ static int pxafb_bpp_to_lccr3(struct fb_
  */
 static unsigned int pxafb_display_dma_period(struct fb_var_screeninfo *var)
 {
-       /*
-        * Period = pixclock * bits_per_byte * bytes_per_transfer
-        *              / memory_bits_per_pixel;
-        */
-       return var->pixclock * 8 * 16 / var->bits_per_pixel;
+	/*
+	 * Period = pixclock * bits_per_byte * bytes_per_transfer
+	 *              / memory_bits_per_pixel;
+	 */
+	return var->pixclock * 8 * 16 / var->bits_per_pixel;
 }
-
-extern unsigned int get_clk_frequency_khz(int info);
 #endif
 
 /*
  * Select the smallest mode that allows the desired resolution to be
  * displayed. If desired parameters can be rounded up.
  */
-static struct pxafb_mode_info *pxafb_getmode(struct pxafb_mach_info *mach, struct fb_var_screeninfo *var)
+static struct pxafb_mode_info *pxafb_getmode(struct pxafb_mach_info *mach,
+					     struct fb_var_screeninfo *var)
 {
 	struct pxafb_mode_info *mode = NULL;
 	struct pxafb_mode_info *modelist = mach->modes;
 	unsigned int best_x = 0xffffffff, best_y = 0xffffffff;
 	unsigned int i;
 
-	for (i = 0 ; i < mach->num_modes ; i++) {
-		if (modelist[i].xres >= var->xres && modelist[i].yres >= var->yres &&
-				modelist[i].xres < best_x && modelist[i].yres < best_y &&
-				modelist[i].bpp >= var->bits_per_pixel ) {
+	for (i = 0; i < mach->num_modes; i++) {
+		if (modelist[i].xres >= var->xres &&
+		    modelist[i].yres >= var->yres &&
+		    modelist[i].xres < best_x &&
+		    modelist[i].yres < best_y &&
+		    modelist[i].bpp >= var->bits_per_pixel) {
 			best_x = modelist[i].xres;
 			best_y = modelist[i].yres;
 			mode = &modelist[i];
@@ -257,7 +265,8 @@ static struct pxafb_mode_info *pxafb_get
 	return mode;
 }
 
-static void pxafb_setmode(struct fb_var_screeninfo *var, struct pxafb_mode_info *mode)
+static void pxafb_setmode(struct fb_var_screeninfo *var,
+			  struct pxafb_mode_info *mode)
 {
 	var->xres		= mode->xres;
 	var->yres		= mode->yres;
@@ -315,19 +324,20 @@ static int pxafb_check_var(struct fb_var
 	var->yres_virtual =
 		max(var->yres_virtual, var->yres);
 
-        /*
+	/*
 	 * Setup the RGB parameters for this display.
 	 *
 	 * The pixel packing format is described on page 7-11 of the
 	 * PXA2XX Developer's Manual.
-         */
+	 */
 	if (var->bits_per_pixel == 16) {
 		var->red.offset   = 11; var->red.length   = 5;
 		var->green.offset = 5;  var->green.length = 6;
 		var->blue.offset  = 0;  var->blue.length  = 5;
 		var->transp.offset = var->transp.length = 0;
 	} else {
-		var->red.offset = var->green.offset = var->blue.offset = var->transp.offset = 0;
+		var->red.offset = var->green.offset = 0;
+		var->blue.offset = var->transp.offset = 0;
 		var->red.length   = 8;
 		var->green.length = 8;
 		var->blue.length  = 8;
@@ -346,7 +356,7 @@ static int pxafb_check_var(struct fb_var
 static inline void pxafb_set_truecolor(u_int is_true_color)
 {
 	pr_debug("pxafb: true_color = %d\n", is_true_color);
-	// do your machine-specific setup if needed
+	/* do your machine-specific setup if needed */
 }
 
 /*
@@ -379,7 +389,8 @@ static int pxafb_set_par(struct fb_info 
 	if (var->bits_per_pixel == 16)
 		fbi->palette_size = 0;
 	else
-		fbi->palette_size = var->bits_per_pixel == 1 ? 4 : 1 << var->bits_per_pixel;
+		fbi->palette_size = var->bits_per_pixel == 1 ?
+					4 : 1 << var->bits_per_pixel;
 
 	if ((fbi->lccr4 & LCCR4_PAL_FOR_MASK) == LCCR4_PAL_FOR_0)
 		palette_mem_size = fbi->palette_size * sizeof(u16);
@@ -460,11 +471,11 @@ static int pxafb_blank(int blank, struct
 				pxafb_setpalettereg(i, 0, 0, 0, 0, info);
 
 		pxafb_schedule_work(fbi, C_DISABLE);
-		//TODO if (pxafb_blank_helper) pxafb_blank_helper(blank);
+		/* TODO if (pxafb_blank_helper) pxafb_blank_helper(blank); */
 		break;
 
 	case FB_BLANK_UNBLANK:
-		//TODO if (pxafb_blank_helper) pxafb_blank_helper(blank);
+		/* TODO if (pxafb_blank_helper) pxafb_blank_helper(blank); */
 		if (fbi->fb.fix.visual == FB_VISUAL_PSEUDOCOLOR ||
 		    fbi->fb.fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR)
 			fb_set_cmap(&fbi->fb.cmap, info);
@@ -529,7 +540,8 @@ static struct fb_ops pxafb_ops = {
  *
  * Factoring the 10^4 and 10^-12 out gives 10^-8 == 1 / 100000000 as used below.
  */
-static inline unsigned int get_pcd(struct pxafb_info *fbi, unsigned int pixclock)
+static inline unsigned int get_pcd(struct pxafb_info *fbi,
+				   unsigned int pixclock)
 {
 	unsigned long long pcd;
 
@@ -555,7 +567,7 @@ static inline void set_hsync_time(struct
 	unsigned long htime;
 
 	if ((pcd == 0) || (fbi->fb.var.hsync_len == 0)) {
-		fbi->hsync_time=0;
+		fbi->hsync_time = 0;
 		return;
 	}
 
@@ -578,10 +590,11 @@ EXPORT_SYMBOL(pxafb_get_hsync_time);
 
 /*
  * pxafb_activate_var():
- *	Configures LCD Controller based on entries in var parameter.  Settings are
- *	only written to the controller if changes were made.
+ *	Configures LCD Controller based on entries in var parameter.
+ *	Settings are only written to the controller if changes were made.
  */
-static int pxafb_activate_var(struct fb_var_screeninfo *var, struct pxafb_info *fbi)
+static int pxafb_activate_var(struct fb_var_screeninfo *var,
+			      struct pxafb_info *fbi)
 {
 	struct pxafb_lcd_reg new_regs;
 	u_long flags;
@@ -598,10 +611,10 @@ static int pxafb_activate_var(struct fb_
 	pr_debug("var: pixclock=%d pcd=%d\n", var->pixclock, pcd);
 
 #if DEBUG_VAR
-	if (var->xres < 16        || var->xres > 1024)
+	if (var->xres < 16 || var->xres > 1024)
 		printk(KERN_ERR "%s: invalid xres %d\n",
 			fbi->fb.fix.id, var->xres);
-	switch(var->bits_per_pixel) {
+	switch (var->bits_per_pixel) {
 	case 1:
 	case 2:
 	case 4:
@@ -613,19 +626,19 @@ static int pxafb_activate_var(struct fb_
 		       fbi->fb.fix.id, var->bits_per_pixel);
 		break;
 	}
-	if (var->hsync_len < 1    || var->hsync_len > 64)
+	if (var->hsync_len < 1 || var->hsync_len > 64)
 		printk(KERN_ERR "%s: invalid hsync_len %d\n",
 			fbi->fb.fix.id, var->hsync_len);
-	if (var->left_margin < 1  || var->left_margin > 255)
+	if (var->left_margin < 1 || var->left_margin > 255)
 		printk(KERN_ERR "%s: invalid left_margin %d\n",
 			fbi->fb.fix.id, var->left_margin);
 	if (var->right_margin < 1 || var->right_margin > 255)
 		printk(KERN_ERR "%s: invalid right_margin %d\n",
 			fbi->fb.fix.id, var->right_margin);
-	if (var->yres < 1         || var->yres > 1024)
+	if (var->yres < 1 || var->yres > 1024)
 		printk(KERN_ERR "%s: invalid yres %d\n",
 			fbi->fb.fix.id, var->yres);
-	if (var->vsync_len < 1    || var->vsync_len > 64)
+	if (var->vsync_len < 1 || var->vsync_len > 64)
 		printk(KERN_ERR "%s: invalid vsync_len %d\n",
 			fbi->fb.fix.id, var->vsync_len);
 	if (var->upper_margin < 0 || var->upper_margin > 255)
@@ -638,7 +651,7 @@ static int pxafb_activate_var(struct fb_
 
 	new_regs.lccr0 = fbi->lccr0 |
 		(LCCR0_LDM | LCCR0_SFM | LCCR0_IUM | LCCR0_EFM |
-                 LCCR0_QDM | LCCR0_BM  | LCCR0_OUM);
+		 LCCR0_QDM | LCCR0_BM  | LCCR0_OUM);
 
 	new_regs.lccr1 =
 		LCCR1_DisWdth(var->xres) +
@@ -662,8 +675,10 @@ static int pxafb_activate_var(struct fb_
 
 	new_regs.lccr3 = fbi->lccr3 |
 		pxafb_bpp_to_lccr3(var) |
-		(var->sync & FB_SYNC_HOR_HIGH_ACT ? LCCR3_HorSnchH : LCCR3_HorSnchL) |
-		(var->sync & FB_SYNC_VERT_HIGH_ACT ? LCCR3_VrtSnchH : LCCR3_VrtSnchL);
+		(var->sync & FB_SYNC_HOR_HIGH_ACT ?
+		 LCCR3_HorSnchH : LCCR3_HorSnchL) |
+		(var->sync & FB_SYNC_VERT_HIGH_ACT ?
+		 LCCR3_VrtSnchH : LCCR3_VrtSnchL);
 
 	if (pcd)
 		new_regs.lccr3 |= LCCR3_PixClkDiv(pcd);
@@ -677,9 +692,12 @@ static int pxafb_activate_var(struct fb_
 	local_irq_save(flags);
 
 	/* setup dma descriptors */
-	fbi->dmadesc_fblow_cpu = (struct pxafb_dma_descriptor *)((unsigned int)fbi->palette_cpu - 3*16);
-	fbi->dmadesc_fbhigh_cpu = (struct pxafb_dma_descriptor *)((unsigned int)fbi->palette_cpu - 2*16);
-	fbi->dmadesc_palette_cpu = (struct pxafb_dma_descriptor *)((unsigned int)fbi->palette_cpu - 1*16);
+	fbi->dmadesc_fblow_cpu = (struct pxafb_dma_descriptor *)
+				((unsigned int)fbi->palette_cpu - 3*16);
+	fbi->dmadesc_fbhigh_cpu = (struct pxafb_dma_descriptor *)
+				((unsigned int)fbi->palette_cpu - 2*16);
+	fbi->dmadesc_palette_cpu = (struct pxafb_dma_descriptor *)
+				((unsigned int)fbi->palette_cpu - 1*16);
 
 	fbi->dmadesc_fblow_dma = fbi->palette_dma - 3*16;
 	fbi->dmadesc_fbhigh_dma = fbi->palette_dma - 2*16;
@@ -716,32 +734,12 @@ static int pxafb_activate_var(struct fb_
 		/* init it to something, even though we won't be using it */
 		fbi->dmadesc_palette_cpu->fdadr = fbi->dmadesc_palette_dma;
 	} else {
+		/* flips back and forth between pal and fbhigh */
 		fbi->dmadesc_palette_cpu->fdadr = fbi->dmadesc_fbhigh_dma;
 		fbi->dmadesc_fbhigh_cpu->fdadr = fbi->dmadesc_palette_dma;
-		fbi->fdadr0 = fbi->dmadesc_palette_dma; /* flips back and forth between pal and fbhigh */
+		fbi->fdadr0 = fbi->dmadesc_palette_dma;
 	}
 
-#if 0
-	pr_debug("fbi->dmadesc_fblow_cpu = 0x%p\n", fbi->dmadesc_fblow_cpu);
-	pr_debug("fbi->dmadesc_fbhigh_cpu = 0x%p\n", fbi->dmadesc_fbhigh_cpu);
-	pr_debug("fbi->dmadesc_palette_cpu = 0x%p\n", fbi->dmadesc_palette_cpu);
-	pr_debug("fbi->dmadesc_fblow_dma = 0x%x\n", fbi->dmadesc_fblow_dma);
-	pr_debug("fbi->dmadesc_fbhigh_dma = 0x%x\n", fbi->dmadesc_fbhigh_dma);
-	pr_debug("fbi->dmadesc_palette_dma = 0x%x\n", fbi->dmadesc_palette_dma);
-
-	pr_debug("fbi->dmadesc_fblow_cpu->fdadr = 0x%x\n", fbi->dmadesc_fblow_cpu->fdadr);
-	pr_debug("fbi->dmadesc_fbhigh_cpu->fdadr = 0x%x\n", fbi->dmadesc_fbhigh_cpu->fdadr);
-	pr_debug("fbi->dmadesc_palette_cpu->fdadr = 0x%x\n", fbi->dmadesc_palette_cpu->fdadr);
-
-	pr_debug("fbi->dmadesc_fblow_cpu->fsadr = 0x%x\n", fbi->dmadesc_fblow_cpu->fsadr);
-	pr_debug("fbi->dmadesc_fbhigh_cpu->fsadr = 0x%x\n", fbi->dmadesc_fbhigh_cpu->fsadr);
-	pr_debug("fbi->dmadesc_palette_cpu->fsadr = 0x%x\n", fbi->dmadesc_palette_cpu->fsadr);
-
-	pr_debug("fbi->dmadesc_fblow_cpu->ldcmd = 0x%x\n", fbi->dmadesc_fblow_cpu->ldcmd);
-	pr_debug("fbi->dmadesc_fbhigh_cpu->ldcmd = 0x%x\n", fbi->dmadesc_fbhigh_cpu->ldcmd);
-	pr_debug("fbi->dmadesc_palette_cpu->ldcmd = 0x%x\n", fbi->dmadesc_palette_cpu->ldcmd);
-#endif
-
 	fbi->reg_lccr0 = new_regs.lccr0;
 	fbi->reg_lccr1 = new_regs.lccr1;
 	fbi->reg_lccr2 = new_regs.lccr2;
@@ -773,8 +771,8 @@ static inline void __pxafb_backlight_pow
 {
 	pr_debug("pxafb: backlight o%s\n", on ? "n" : "ff");
 
- 	if (pxafb_backlight_power)
- 		pxafb_backlight_power(on);
+	if (pxafb_backlight_power)
+		pxafb_backlight_power(on);
 }
 
 static inline void __pxafb_lcd_power(struct pxafb_info *fbi, int on)
@@ -788,11 +786,11 @@ static inline void __pxafb_lcd_power(str
 static void pxafb_setup_gpio(struct pxafb_info *fbi)
 {
 	int gpio, ldd_bits;
-        unsigned int lccr0 = fbi->lccr0;
+	unsigned int lccr0 = fbi->lccr0;
 
 	/*
 	 * setup is based on type of panel supported
-        */
+	 */
 
 	/* 4 bit interface */
 	if ((lccr0 & LCCR0_CMS) == LCCR0_Mono &&
@@ -801,21 +799,25 @@ static void pxafb_setup_gpio(struct pxaf
 		ldd_bits = 4;
 
 	/* 8 bit interface */
-        else if (((lccr0 & LCCR0_CMS) == LCCR0_Mono &&
-		  ((lccr0 & LCCR0_SDS) == LCCR0_Dual || (lccr0 & LCCR0_DPD) == LCCR0_8PixMono)) ||
-                 ((lccr0 & LCCR0_CMS) == LCCR0_Color &&
-		  (lccr0 & LCCR0_PAS) == LCCR0_Pas && (lccr0 & LCCR0_SDS) == LCCR0_Sngl))
+	else if (((lccr0 & LCCR0_CMS) == LCCR0_Mono &&
+		  ((lccr0 & LCCR0_SDS) == LCCR0_Dual ||
+		   (lccr0 & LCCR0_DPD) == LCCR0_8PixMono)) ||
+		 ((lccr0 & LCCR0_CMS) == LCCR0_Color &&
+		  (lccr0 & LCCR0_PAS) == LCCR0_Pas &&
+		  (lccr0 & LCCR0_SDS) == LCCR0_Sngl))
 		ldd_bits = 8;
 
 	/* 16 bit interface */
 	else if ((lccr0 & LCCR0_CMS) == LCCR0_Color &&
-		 ((lccr0 & LCCR0_SDS) == LCCR0_Dual || (lccr0 & LCCR0_PAS) == LCCR0_Act))
+		 ((lccr0 & LCCR0_SDS) == LCCR0_Dual ||
+		  (lccr0 & LCCR0_PAS) == LCCR0_Act))
 		ldd_bits = 16;
 
 	else {
-	        printk(KERN_ERR "pxafb_setup_gpio: unable to determine bits per pixel\n");
+		printk(KERN_ERR "pxafb_setup_gpio: unable to determine "
+			       "bits per pixel\n");
 		return;
-        }
+	}
 
 	for (gpio = 58; ldd_bits; gpio++, ldd_bits--)
 		pxa_gpio_mode(gpio | GPIO_ALT_FN_2_OUT);
@@ -921,7 +923,7 @@ static void set_ctrlr_state(struct pxafb
 		 */
 		if (old_state != C_DISABLE && old_state != C_DISABLE_PM) {
 			fbi->state = state;
-			//TODO __pxafb_lcd_power(fbi, 0);
+			/* TODO __pxafb_lcd_power(fbi, 0); */
 			pxafb_disable_controller(fbi);
 		}
 		break;
@@ -948,7 +950,7 @@ static void set_ctrlr_state(struct pxafb
 		if (old_state == C_DISABLE_CLKCHANGE) {
 			fbi->state = C_ENABLE;
 			pxafb_enable_controller(fbi);
-			//TODO __pxafb_lcd_power(fbi, 1);
+			/* TODO __pxafb_lcd_power(fbi, 1); */
 		}
 		break;
 
@@ -1019,7 +1021,7 @@ static int
 pxafb_freq_transition(struct notifier_block *nb, unsigned long val, void *data)
 {
 	struct pxafb_info *fbi = TO_INF(nb, freq_transition);
-	//TODO struct cpufreq_freqs *f = data;
+	/* TODO struct cpufreq_freqs *f = data; */
 	u_int pcd;
 
 	switch (val) {
@@ -1030,7 +1032,8 @@ pxafb_freq_transition(struct notifier_bl
 	case CPUFREQ_POSTCHANGE:
 		pcd = get_pcd(fbi, fbi->fb.var.pixclock);
 		set_hsync_time(fbi, pcd);
-		fbi->reg_lccr3 = (fbi->reg_lccr3 & ~0xff) | LCCR3_PixClkDiv(pcd);
+		fbi->reg_lccr3 = (fbi->reg_lccr3 & ~0xff) |
+				  LCCR3_PixClkDiv(pcd);
 		set_ctrlr_state(fbi, C_ENABLE_CLKCHANGE);
 		break;
 	}
@@ -1050,18 +1053,8 @@ pxafb_freq_policy(struct notifier_block 
 		pr_debug("min dma period: %d ps, "
 			"new clock %d kHz\n", pxafb_display_dma_period(var),
 			policy->max);
-		// TODO: fill in min/max values
+		/* TODO: fill in min/max values */
 		break;
-#if 0
-	case CPUFREQ_NOTIFY:
-		printk(KERN_ERR "%s: got CPUFREQ_NOTIFY\n", __FUNCTION__);
-		do {} while(0);
-		/* todo: panic if min/max values aren't fulfilled
-		 * [can't really happen unless there's a bug in the
-		 * CPU policy verification process *
-		 */
-		break;
-#endif
 	}
 	return 0;
 }
@@ -1131,9 +1124,11 @@ static int __init pxafb_map_video_memory
 		else
 			palette_mem_size = fbi->palette_size * sizeof(u32);
 
-		pr_debug("pxafb: palette_mem_size = 0x%08lx\n", palette_mem_size);
+		pr_debug("pxafb: palette_mem_size = 0x%08lx\n",
+				palette_mem_size);
 
-		fbi->palette_cpu = (u16 *)(fbi->map_cpu + PAGE_SIZE - palette_mem_size);
+		fbi->palette_cpu = (u16 *)(fbi->map_cpu + PAGE_SIZE
+						- palette_mem_size);
 		fbi->palette_dma = fbi->map_dma + PAGE_SIZE - palette_mem_size;
 	}
 
@@ -1188,14 +1183,14 @@ static struct pxafb_info * __init pxafb_
 
 	pxafb_setmode(&fbi->fb.var, mode);
 
-	fbi->cmap_inverse		= inf->cmap_inverse;
-	fbi->cmap_static		= inf->cmap_static;
+	fbi->cmap_inverse	= inf->cmap_inverse;
+	fbi->cmap_static	= inf->cmap_static;
 
-	fbi->lccr0			= inf->lccr0;
-	fbi->lccr3			= inf->lccr3;
-	fbi->lccr4			= inf->lccr4;
-	fbi->state			= C_STARTUP;
-	fbi->task_state			= (u_char)-1;
+	fbi->lccr0		= inf->lccr0;
+	fbi->lccr3		= inf->lccr3;
+	fbi->lccr4		= inf->lccr4;
+	fbi->state		= C_STARTUP;
+	fbi->task_state		= (u_char)-1;
 
 	for (i = 0; i < inf->num_modes; i++) {
 		smemlen = mode[i].xres * mode[i].yres * mode[i].bpp / 8;
@@ -1211,7 +1206,7 @@ static struct pxafb_info * __init pxafb_
 }
 
 #ifdef CONFIG_FB_PXA_PARAMETERS
-static int parse_opt_mode(struct device *dev, const char *this_opt)
+static int __init parse_opt_mode(struct device *dev, const char *this_opt)
 {
 	struct pxafb_mach_info *inf = dev->platform_data;
 
@@ -1270,7 +1265,7 @@ done:
 	return 0;
 }
 
-static int parse_opt(struct device *dev, char *this_opt)
+static int __init parse_opt(struct device *dev, char *this_opt)
 {
 	struct pxafb_mach_info *inf = dev->platform_data;
 	struct pxafb_mode_info *mode = &inf->modes[0];
@@ -1409,31 +1404,40 @@ static int __init pxafb_probe(struct pla
 #endif
 
 #ifdef DEBUG_VAR
-        /* Check for various illegal bit-combinations. Currently only
+	/* Check for various illegal bit-combinations. Currently only
 	 * a warning is given. */
 
-        if (inf->lccr0 & LCCR0_INVALID_CONFIG_MASK)
-                dev_warn(&dev->dev, "machine LCCR0 setting contains illegal bits: %08x\n",
-                        inf->lccr0 & LCCR0_INVALID_CONFIG_MASK);
-        if (inf->lccr3 & LCCR3_INVALID_CONFIG_MASK)
-                dev_warn(&dev->dev, "machine LCCR3 setting contains illegal bits: %08x\n",
-                        inf->lccr3 & LCCR3_INVALID_CONFIG_MASK);
-        if (inf->lccr0 & LCCR0_DPD &&
+	if (inf->lccr0 & LCCR0_INVALID_CONFIG_MASK)
+		dev_warn(&dev->dev, "machine LCCR0 setting contains "
+				"illegal bits: %08x\n",
+			inf->lccr0 & LCCR0_INVALID_CONFIG_MASK);
+	if (inf->lccr3 & LCCR3_INVALID_CONFIG_MASK)
+		dev_warn(&dev->dev, "machine LCCR3 setting contains "
+				"illegal bits: %08x\n",
+			inf->lccr3 & LCCR3_INVALID_CONFIG_MASK);
+	if (inf->lccr0 & LCCR0_DPD &&
 	    ((inf->lccr0 & LCCR0_PAS) != LCCR0_Pas ||
 	     (inf->lccr0 & LCCR0_SDS) != LCCR0_Sngl ||
 	     (inf->lccr0 & LCCR0_CMS) != LCCR0_Mono))
-                dev_warn(&dev->dev, "Double Pixel Data (DPD) mode is only valid in passive mono"
-			 " single panel mode\n");
-        if ((inf->lccr0 & LCCR0_PAS) == LCCR0_Act &&
+		dev_warn(&dev->dev, "Double Pixel Data (DPD) mode is "
+				"only valid in passive mono"
+				" single panel mode\n");
+	if ((inf->lccr0 & LCCR0_PAS) == LCCR0_Act &&
 	    (inf->lccr0 & LCCR0_SDS) == LCCR0_Dual)
-                dev_warn(&dev->dev, "Dual panel only valid in passive mode\n");
-        if ((inf->lccr0 & LCCR0_PAS) == LCCR0_Pas &&
-             (inf->modes->upper_margin || inf->modes->lower_margin))
-                dev_warn(&dev->dev, "Upper and lower margins must be 0 in passive mode\n");
+		dev_warn(&dev->dev, "Dual panel only valid in passive mode\n");
+	if ((inf->lccr0 & LCCR0_PAS) == LCCR0_Pas &&
+	     (inf->modes->upper_margin || inf->modes->lower_margin))
+		dev_warn(&dev->dev, "Upper and lower margins must be 0 in "
+				"passive mode\n");
 #endif
 
-	dev_dbg(&dev->dev, "got a %dx%dx%d LCD\n",inf->modes->xres, inf->modes->yres, inf->modes->bpp);
-	if (inf->modes->xres == 0 || inf->modes->yres == 0 || inf->modes->bpp == 0) {
+	dev_dbg(&dev->dev, "got a %dx%dx%d LCD\n",
+			inf->modes->xres,
+			inf->modes->yres,
+			inf->modes->bpp);
+	if (inf->modes->xres == 0 ||
+	    inf->modes->yres == 0 ||
+	    inf->modes->bpp == 0) {
 		dev_err(&dev->dev, "Invalid resolution or bit depth\n");
 		ret = -EINVAL;
 		goto failed;
@@ -1442,8 +1446,9 @@ static int __init pxafb_probe(struct pla
 	pxafb_lcd_power = inf->pxafb_lcd_power;
 	fbi = pxafb_init_fbinfo(&dev->dev);
 	if (!fbi) {
+		/* only reason for pxafb_init_fbinfo to fail is kmalloc */
 		dev_err(&dev->dev, "Failed to initialize framebuffer device\n");
-		ret = -ENOMEM; // only reason for pxafb_init_fbinfo to fail is kmalloc
+		ret = -ENOMEM;
 		goto failed;
 	}
 
@@ -1473,19 +1478,22 @@ static int __init pxafb_probe(struct pla
 
 	ret = register_framebuffer(&fbi->fb);
 	if (ret < 0) {
-		dev_err(&dev->dev, "Failed to register framebuffer device: %d\n", ret);
+		dev_err(&dev->dev,
+			"Failed to register framebuffer device: %d\n", ret);
 		goto failed;
 	}
 
 #ifdef CONFIG_PM
-	// TODO
+	/* TODO */
 #endif
 
 #ifdef CONFIG_CPU_FREQ
 	fbi->freq_transition.notifier_call = pxafb_freq_transition;
 	fbi->freq_policy.notifier_call = pxafb_freq_policy;
-	cpufreq_register_notifier(&fbi->freq_transition, CPUFREQ_TRANSITION_NOTIFIER);
-	cpufreq_register_notifier(&fbi->freq_policy, CPUFREQ_POLICY_NOTIFIER);
+	cpufreq_register_notifier(&fbi->freq_transition,
+				CPUFREQ_TRANSITION_NOTIFIER);
+	cpufreq_register_notifier(&fbi->freq_policy,
+				CPUFREQ_POLICY_NOTIFIER);
 #endif
 
 	/*
_

Patches currently in -mm which might be from eric.miao@marvell.com are

origin.patch
git-arm.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

