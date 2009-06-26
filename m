From: akpm@linux-foundation.org
Subject: + atyfb-coding-style-cleanup.patch added to -mm tree
Date: Fri, 26 Jun 2009 15:40:47 -0700
Message-ID: <200906262240.n5QMel7L031961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228AbZFZWlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 18:41:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, hartleys@visionengravers.com, krzysztof.h1@poczta.fm


The patch titled
     atyfb: coding style cleanup
has been added to the -mm tree.  Its filename is
     atyfb-coding-style-cleanup.patch

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
Subject: atyfb: coding style cleanup
From: Ville Syrjala <syrjala@sci.fi>

Fix a bunch of coding style problems in atyfb_base.c.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |  829 +++++++++++++++++--------------
 1 file changed, 458 insertions(+), 371 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-coding-style-cleanup drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-coding-style-cleanup
+++ a/drivers/video/aty/atyfb_base.c
@@ -132,7 +132,7 @@
 #endif
 
 #define PRINTKI(fmt, args...)	printk(KERN_INFO "atyfb: " fmt, ## args)
-#define PRINTKE(fmt, args...)	 printk(KERN_ERR "atyfb: " fmt, ## args)
+#define PRINTKE(fmt, args...)	printk(KERN_ERR "atyfb: " fmt, ## args)
 
 #if defined(CONFIG_PM) || defined(CONFIG_PMAC_BACKLIGHT) || \
 defined (CONFIG_FB_ATY_GENERIC_LCD) || defined(CONFIG_FB_ATY_BACKLIGHT)
@@ -188,24 +188,23 @@ u32 aty_ld_lcd(int index, const struct a
  */
 static void ATIReduceRatio(int *Numerator, int *Denominator)
 {
-    int Multiplier, Divider, Remainder;
+	int Multiplier, Divider, Remainder;
 
-    Multiplier = *Numerator;
-    Divider = *Denominator;
+	Multiplier = *Numerator;
+	Divider = *Denominator;
 
-    while ((Remainder = Multiplier % Divider))
-    {
-        Multiplier = Divider;
-        Divider = Remainder;
-    }
+	while ((Remainder = Multiplier % Divider)) {
+		Multiplier = Divider;
+		Divider = Remainder;
+	}
 
-    *Numerator /= Divider;
-    *Denominator /= Divider;
+	*Numerator /= Divider;
+	*Denominator /= Divider;
 }
 #endif
-    /*
-     *  The Hardware parameters for each card
-     */
+/*
+ * The Hardware parameters for each card
+ */
 
 struct pci_mmap_map {
 	unsigned long voff;
@@ -223,17 +222,19 @@ static struct fb_fix_screeninfo atyfb_fi
 	.ypanstep	= 1,
 };
 
-    /*
-     *  Frame buffer device API
-     */
+/*
+ * Frame buffer device API
+ */
 
 static int atyfb_open(struct fb_info *info, int user);
 static int atyfb_release(struct fb_info *info, int user);
-static int atyfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info);
+static int atyfb_check_var(struct fb_var_screeninfo *var,
+			   struct fb_info *info);
 static int atyfb_set_par(struct fb_info *info);
 static int atyfb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
-	u_int transp, struct fb_info *info);
-static int atyfb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info);
+			   u_int transp, struct fb_info *info);
+static int atyfb_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *info);
 static int atyfb_blank(int blank, struct fb_info *info);
 static int atyfb_ioctl(struct fb_info *info, u_int cmd, u_long arg);
 #ifdef __sparc__
@@ -241,9 +242,9 @@ static int atyfb_mmap(struct fb_info *in
 #endif
 static int atyfb_sync(struct fb_info *info);
 
-    /*
-     *  Internal routines
-     */
+/*
+ * Internal routines
+ */
 
 static int aty_init(struct fb_info *info);
 
@@ -254,8 +255,11 @@ static int store_video_par(char *videopa
 static void aty_get_crtc(const struct atyfb_par *par, struct crtc *crtc);
 
 static void aty_set_crtc(const struct atyfb_par *par, const struct crtc *crtc);
-static int aty_var_to_crtc(const struct fb_info *info, const struct fb_var_screeninfo *var, struct crtc *crtc);
-static int aty_crtc_to_var(const struct crtc *crtc, struct fb_var_screeninfo *var);
+static int aty_var_to_crtc(const struct fb_info *info,
+			   const struct fb_var_screeninfo *var,
+			   struct crtc *crtc);
+static int aty_crtc_to_var(const struct crtc *crtc,
+			   struct fb_var_screeninfo *var);
 static void set_off_pitch(struct atyfb_par *par, const struct fb_info *info);
 #ifdef CONFIG_PPC
 static int read_aty_sense(const struct atyfb_par *par);
@@ -264,9 +268,9 @@ static int read_aty_sense(const struct a
 static DEFINE_MUTEX(reboot_lock);
 static struct fb_info *reboot_info;
 
-    /*
-     *  Interface used by the world
-     */
+/*
+ * Interface used by the world
+ */
 
 static struct fb_var_screeninfo default_var = {
 	/* 640x480, 60 Hz, Non-Interlaced (25.175 MHz dotclock) */
@@ -452,14 +456,14 @@ static int __devinit correct_chipset(str
 	type = chip_id & CFG_CHIP_TYPE;
 	rev = (chip_id & CFG_CHIP_REV) >> 24;
 
-	switch(par->pci_id) {
+	switch (par->pci_id) {
 #ifdef CONFIG_FB_ATY_GX
 	case PCI_CHIP_MACH64GX:
-		if(type != 0x00d7)
+		if (type != 0x00d7)
 			return -ENODEV;
 		break;
 	case PCI_CHIP_MACH64CX:
-		if(type != 0x0057)
+		if (type != 0x0057)
 			return -ENODEV;
 		break;
 #endif
@@ -564,7 +568,8 @@ static char *aty_xl_ram[8] __devinitdata
 };
 #endif /* CONFIG_FB_ATY_CT */
 
-static u32 atyfb_get_pixclock(struct fb_var_screeninfo *var, struct atyfb_par *par)
+static u32 atyfb_get_pixclock(struct fb_var_screeninfo *var,
+			      struct atyfb_par *par)
 {
 	u32 pixclock = var->pixclock;
 #ifdef CONFIG_FB_ATY_GENERIC_LCD
@@ -572,7 +577,7 @@ static u32 atyfb_get_pixclock(struct fb_
 	par->pll.ct.xres = 0;
 	if (par->lcd_table != 0) {
 		lcd_on_off = aty_ld_lcd(LCD_GEN_CNTL, par);
-		if(lcd_on_off & LCD_ON) {
+		if (lcd_on_off & LCD_ON) {
 			par->pll.ct.xres = var->xres;
 			pixclock = par->lcd_pixclock;
 		}
@@ -584,7 +589,7 @@ static u32 atyfb_get_pixclock(struct fb_
 #if defined(CONFIG_PPC)
 
 /*
- *  Apple monitor sense
+ * Apple monitor sense
  */
 
 static int __devinit read_aty_sense(const struct atyfb_par *par)
@@ -625,16 +630,16 @@ static int __devinit read_aty_sense(cons
 /* ------------------------------------------------------------------------- */
 
 /*
- *  CRTC programming
+ * CRTC programming
  */
 
 static void aty_get_crtc(const struct atyfb_par *par, struct crtc *crtc)
 {
 #ifdef CONFIG_FB_ATY_GENERIC_LCD
 	if (par->lcd_table != 0) {
-		if(!M64_HAS(LT_LCD_REGS)) {
-		    crtc->lcd_index = aty_ld_le32(LCD_INDEX, par);
-		    aty_st_le32(LCD_INDEX, crtc->lcd_index, par);
+		if (!M64_HAS(LT_LCD_REGS)) {
+			crtc->lcd_index = aty_ld_le32(LCD_INDEX, par);
+			aty_st_le32(LCD_INDEX, crtc->lcd_index, par);
 		}
 		crtc->lcd_config_panel = aty_ld_lcd(CNFG_PANEL, par);
 		crtc->lcd_gen_cntl = aty_ld_lcd(LCD_GEN_CNTL, par);
@@ -642,7 +647,7 @@ static void aty_get_crtc(const struct at
 
 		/* switch to non shadow registers */
 		aty_st_lcd(LCD_GEN_CNTL, crtc->lcd_gen_cntl &
-                    ~(CRTC_RW_SELECT | SHADOW_EN | SHADOW_RW_EN), par);
+			   ~(CRTC_RW_SELECT | SHADOW_EN | SHADOW_RW_EN), par);
 
 		/* save stretching */
 		crtc->horz_stretching = aty_ld_lcd(HORZ_STRETCHING, par);
@@ -663,7 +668,7 @@ static void aty_get_crtc(const struct at
 	if (par->lcd_table != 0) {
 		/* switch to shadow registers */
 		aty_st_lcd(LCD_GEN_CNTL, (crtc->lcd_gen_cntl & ~CRTC_RW_SELECT) |
-			SHADOW_EN | SHADOW_RW_EN, par);
+			   SHADOW_EN | SHADOW_RW_EN, par);
 
 		crtc->shadow_h_tot_disp = aty_ld_le32(CRTC_H_TOTAL_DISP, par);
 		crtc->shadow_h_sync_strt_wid = aty_ld_le32(CRTC_H_SYNC_STRT_WID, par);
@@ -680,21 +685,20 @@ static void aty_set_crtc(const struct at
 #ifdef CONFIG_FB_ATY_GENERIC_LCD
 	if (par->lcd_table != 0) {
 		/* stop CRTC */
-		aty_st_le32(CRTC_GEN_CNTL, crtc->gen_cntl & ~(CRTC_EXT_DISP_EN | CRTC_EN), par);
+		aty_st_le32(CRTC_GEN_CNTL, crtc->gen_cntl &
+			    ~(CRTC_EXT_DISP_EN | CRTC_EN), par);
 
 		/* update non-shadow registers first */
 		aty_st_lcd(CNFG_PANEL, crtc->lcd_config_panel, par);
 		aty_st_lcd(LCD_GEN_CNTL, crtc->lcd_gen_cntl &
-			~(CRTC_RW_SELECT | SHADOW_EN | SHADOW_RW_EN), par);
+			   ~(CRTC_RW_SELECT | SHADOW_EN | SHADOW_RW_EN), par);
 
 		/* temporarily disable stretching */
-		aty_st_lcd(HORZ_STRETCHING,
-			crtc->horz_stretching &
-			~(HORZ_STRETCH_MODE | HORZ_STRETCH_EN), par);
-		aty_st_lcd(VERT_STRETCHING,
-			crtc->vert_stretching &
-			~(VERT_STRETCH_RATIO1 | VERT_STRETCH_RATIO2 |
-			VERT_STRETCH_USE0 | VERT_STRETCH_EN), par);
+		aty_st_lcd(HORZ_STRETCHING, crtc->horz_stretching &
+			   ~(HORZ_STRETCH_MODE | HORZ_STRETCH_EN), par);
+		aty_st_lcd(VERT_STRETCHING, crtc->vert_stretching &
+			   ~(VERT_STRETCH_RATIO1 | VERT_STRETCH_RATIO2 |
+			     VERT_STRETCH_USE0 | VERT_STRETCH_EN), par);
 	}
 #endif
 	/* turn off CRT */
@@ -702,17 +706,19 @@ static void aty_set_crtc(const struct at
 
 	DPRINTK("setting up CRTC\n");
 	DPRINTK("set primary CRT to %ix%i %c%c composite %c\n",
-	    ((((crtc->h_tot_disp>>16) & 0xff) + 1)<<3), (((crtc->v_tot_disp>>16) & 0x7ff) + 1),
-	    (crtc->h_sync_strt_wid & 0x200000)?'N':'P', (crtc->v_sync_strt_wid & 0x200000)?'N':'P',
-	    (crtc->gen_cntl & CRTC_CSYNC_EN)?'P':'N');
-
-	DPRINTK("CRTC_H_TOTAL_DISP: %x\n",crtc->h_tot_disp);
-	DPRINTK("CRTC_H_SYNC_STRT_WID: %x\n",crtc->h_sync_strt_wid);
-	DPRINTK("CRTC_V_TOTAL_DISP: %x\n",crtc->v_tot_disp);
-	DPRINTK("CRTC_V_SYNC_STRT_WID: %x\n",crtc->v_sync_strt_wid);
+		((((crtc->h_tot_disp >> 16) & 0xff) + 1) << 3),
+		(((crtc->v_tot_disp >> 16) & 0x7ff) + 1),
+		(crtc->h_sync_strt_wid & 0x200000) ? 'N' : 'P',
+		(crtc->v_sync_strt_wid & 0x200000) ? 'N' : 'P',
+		(crtc->gen_cntl & CRTC_CSYNC_EN) ? 'P' : 'N');
+
+	DPRINTK("CRTC_H_TOTAL_DISP: %x\n", crtc->h_tot_disp);
+	DPRINTK("CRTC_H_SYNC_STRT_WID: %x\n", crtc->h_sync_strt_wid);
+	DPRINTK("CRTC_V_TOTAL_DISP: %x\n", crtc->v_tot_disp);
+	DPRINTK("CRTC_V_SYNC_STRT_WID: %x\n", crtc->v_sync_strt_wid);
 	DPRINTK("CRTC_OFF_PITCH: %x\n", crtc->off_pitch);
 	DPRINTK("CRTC_VLINE_CRNT_VLINE: %x\n", crtc->vline_crnt_vline);
-	DPRINTK("CRTC_GEN_CNTL: %x\n",crtc->gen_cntl);
+	DPRINTK("CRTC_GEN_CNTL: %x\n", crtc->gen_cntl);
 
 	aty_st_le32(CRTC_H_TOTAL_DISP, crtc->h_tot_disp, par);
 	aty_st_le32(CRTC_H_SYNC_STRT_WID, crtc->h_sync_strt_wid, par);
@@ -732,16 +738,22 @@ static void aty_set_crtc(const struct at
 	if (par->lcd_table != 0) {
 		/* switch to shadow registers */
 		aty_st_lcd(LCD_GEN_CNTL, (crtc->lcd_gen_cntl & ~CRTC_RW_SELECT) |
-			(SHADOW_EN | SHADOW_RW_EN), par);
+			   SHADOW_EN | SHADOW_RW_EN, par);
 
 		DPRINTK("set shadow CRT to %ix%i %c%c\n",
-		    ((((crtc->shadow_h_tot_disp>>16) & 0xff) + 1)<<3), (((crtc->shadow_v_tot_disp>>16) & 0x7ff) + 1),
-		    (crtc->shadow_h_sync_strt_wid & 0x200000)?'N':'P', (crtc->shadow_v_sync_strt_wid & 0x200000)?'N':'P');
-
-		DPRINTK("SHADOW CRTC_H_TOTAL_DISP: %x\n", crtc->shadow_h_tot_disp);
-		DPRINTK("SHADOW CRTC_H_SYNC_STRT_WID: %x\n", crtc->shadow_h_sync_strt_wid);
-		DPRINTK("SHADOW CRTC_V_TOTAL_DISP: %x\n", crtc->shadow_v_tot_disp);
-		DPRINTK("SHADOW CRTC_V_SYNC_STRT_WID: %x\n", crtc->shadow_v_sync_strt_wid);
+			((((crtc->shadow_h_tot_disp >> 16) & 0xff) + 1) << 3),
+			(((crtc->shadow_v_tot_disp >> 16) & 0x7ff) + 1),
+			(crtc->shadow_h_sync_strt_wid & 0x200000) ? 'N' : 'P',
+			(crtc->shadow_v_sync_strt_wid & 0x200000) ? 'N' : 'P');
+
+		DPRINTK("SHADOW CRTC_H_TOTAL_DISP: %x\n",
+			crtc->shadow_h_tot_disp);
+		DPRINTK("SHADOW CRTC_H_SYNC_STRT_WID: %x\n",
+			crtc->shadow_h_sync_strt_wid);
+		DPRINTK("SHADOW CRTC_V_TOTAL_DISP: %x\n",
+			crtc->shadow_v_tot_disp);
+		DPRINTK("SHADOW CRTC_V_SYNC_STRT_WID: %x\n",
+			crtc->shadow_v_sync_strt_wid);
 
 		aty_st_le32(CRTC_H_TOTAL_DISP, crtc->shadow_h_tot_disp, par);
 		aty_st_le32(CRTC_H_SYNC_STRT_WID, crtc->shadow_h_sync_strt_wid, par);
@@ -752,16 +764,16 @@ static void aty_set_crtc(const struct at
 		DPRINTK("LCD_GEN_CNTL: %x\n", crtc->lcd_gen_cntl);
 		DPRINTK("HORZ_STRETCHING: %x\n", crtc->horz_stretching);
 		DPRINTK("VERT_STRETCHING: %x\n", crtc->vert_stretching);
-		if(!M64_HAS(LT_LCD_REGS))
-		    DPRINTK("EXT_VERT_STRETCH: %x\n", crtc->ext_vert_stretch);
+		if (!M64_HAS(LT_LCD_REGS))
+			DPRINTK("EXT_VERT_STRETCH: %x\n", crtc->ext_vert_stretch);
 
 		aty_st_lcd(LCD_GEN_CNTL, crtc->lcd_gen_cntl, par);
 		aty_st_lcd(HORZ_STRETCHING, crtc->horz_stretching, par);
 		aty_st_lcd(VERT_STRETCHING, crtc->vert_stretching, par);
-		if(!M64_HAS(LT_LCD_REGS)) {
-		    aty_st_lcd(EXT_VERT_STRETCH, crtc->ext_vert_stretch, par);
-		    aty_ld_le32(LCD_INDEX, par);
-		    aty_st_le32(LCD_INDEX, crtc->lcd_index, par);
+		if (!M64_HAS(LT_LCD_REGS)) {
+			aty_st_lcd(EXT_VERT_STRETCH, crtc->ext_vert_stretch, par);
+			aty_ld_le32(LCD_INDEX, par);
+			aty_st_le32(LCD_INDEX, crtc->lcd_index, par);
 		}
 	}
 #endif /* CONFIG_FB_ATY_GENERIC_LCD */
@@ -779,7 +791,8 @@ static u32 calc_line_length(struct atyfb
 }
 
 static int aty_var_to_crtc(const struct fb_info *info,
-	const struct fb_var_screeninfo *var, struct crtc *crtc)
+			   const struct fb_var_screeninfo *var,
+			   struct crtc *crtc)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
 	u32 xres, yres, vxres, vyres, xoffset, yoffset, bpp;
@@ -814,34 +827,32 @@ static int aty_var_to_crtc(const struct 
 	if (bpp <= 8) {
 		bpp = 8;
 		pix_width = CRTC_PIX_WIDTH_8BPP;
-		dp_pix_width =
-		    HOST_8BPP | SRC_8BPP | DST_8BPP |
-		    BYTE_ORDER_LSB_TO_MSB;
+		dp_pix_width = HOST_8BPP | SRC_8BPP | DST_8BPP |
+			BYTE_ORDER_LSB_TO_MSB;
 		dp_chain_mask = DP_CHAIN_8BPP;
 	} else if (bpp <= 15) {
 		bpp = 16;
 		pix_width = CRTC_PIX_WIDTH_15BPP;
 		dp_pix_width = HOST_15BPP | SRC_15BPP | DST_15BPP |
-		    BYTE_ORDER_LSB_TO_MSB;
+			BYTE_ORDER_LSB_TO_MSB;
 		dp_chain_mask = DP_CHAIN_15BPP;
 	} else if (bpp <= 16) {
 		bpp = 16;
 		pix_width = CRTC_PIX_WIDTH_16BPP;
 		dp_pix_width = HOST_16BPP | SRC_16BPP | DST_16BPP |
-		    BYTE_ORDER_LSB_TO_MSB;
+			BYTE_ORDER_LSB_TO_MSB;
 		dp_chain_mask = DP_CHAIN_16BPP;
 	} else if (bpp <= 24 && M64_HAS(INTEGRATED)) {
 		bpp = 24;
 		pix_width = CRTC_PIX_WIDTH_24BPP;
-		dp_pix_width =
-		    HOST_8BPP | SRC_8BPP | DST_8BPP |
-		    BYTE_ORDER_LSB_TO_MSB;
+		dp_pix_width = HOST_8BPP | SRC_8BPP | DST_8BPP |
+			BYTE_ORDER_LSB_TO_MSB;
 		dp_chain_mask = DP_CHAIN_24BPP;
 	} else if (bpp <= 32) {
 		bpp = 32;
 		pix_width = CRTC_PIX_WIDTH_32BPP;
 		dp_pix_width = HOST_32BPP | SRC_32BPP | DST_32BPP |
-		    BYTE_ORDER_LSB_TO_MSB;
+			BYTE_ORDER_LSB_TO_MSB;
 		dp_chain_mask = DP_CHAIN_32BPP;
 	} else
 		FAIL("invalid bpp");
@@ -854,9 +865,9 @@ static int aty_var_to_crtc(const struct 
 	h_sync_pol = sync & FB_SYNC_HOR_HIGH_ACT ? 0 : 1;
 	v_sync_pol = sync & FB_SYNC_VERT_HIGH_ACT ? 0 : 1;
 
-	if((xres > 1600) || (yres > 1200)) {
+	if ((xres > 1600) || (yres > 1200)) {
 		FAIL("MACH64 chips are designed for max 1600x1200\n"
-		"select anoter resolution.");
+		     "select anoter resolution.");
 	}
 	h_sync_strt = h_disp + var->right_margin;
 	h_sync_end = h_sync_strt + var->hsync_len;
@@ -869,11 +880,12 @@ static int aty_var_to_crtc(const struct 
 
 #ifdef CONFIG_FB_ATY_GENERIC_LCD
 	if (par->lcd_table != 0) {
-		if(!M64_HAS(LT_LCD_REGS)) {
-		    u32 lcd_index = aty_ld_le32(LCD_INDEX, par);
-		    crtc->lcd_index = lcd_index &
-			~(LCD_INDEX_MASK | LCD_DISPLAY_DIS | LCD_SRC_SEL | CRTC2_DISPLAY_DIS);
-		    aty_st_le32(LCD_INDEX, lcd_index, par);
+		if (!M64_HAS(LT_LCD_REGS)) {
+			u32 lcd_index = aty_ld_le32(LCD_INDEX, par);
+			crtc->lcd_index = lcd_index &
+				~(LCD_INDEX_MASK | LCD_DISPLAY_DIS |
+				  LCD_SRC_SEL | CRTC2_DISPLAY_DIS);
+			aty_st_le32(LCD_INDEX, lcd_index, par);
 		}
 
 		if (!M64_HAS(MOBIL_BUS))
@@ -888,12 +900,14 @@ static int aty_var_to_crtc(const struct 
 			USE_SHADOWED_ROWCUR | SHADOW_EN | SHADOW_RW_EN);
 		crtc->lcd_gen_cntl |= DONT_SHADOW_VPAR | LOCK_8DOT;
 
-		if((crtc->lcd_gen_cntl & LCD_ON) &&
-			((xres > par->lcd_width) || (yres > par->lcd_height))) {
-			/* We cannot display the mode on the LCD. If the CRT is enabled
-			   we can turn off the LCD.
-			   If the CRT is off, it isn't a good idea to switch it on; we don't
-			   know if one is connected. So it's better to fail then.
+		if ((crtc->lcd_gen_cntl & LCD_ON) &&
+		    ((xres > par->lcd_width) || (yres > par->lcd_height))) {
+			/*
+			 * We cannot display the mode on the LCD. If the CRT is
+			 * enabled we can turn off the LCD.
+			 * If the CRT is off, it isn't a good idea to switch it
+			 * on; we don't know if one is connected. So it's better
+			 * to fail then.
 			 */
 			if (crtc->lcd_gen_cntl & CRT_ON) {
 				if (!(var->activate & FB_ACTIVATE_TEST))
@@ -916,17 +930,18 @@ static int aty_var_to_crtc(const struct 
 
 		vmode &= ~(FB_VMODE_DOUBLE | FB_VMODE_INTERLACED);
 
-		/* This is horror! When we simulate, say 640x480 on an 800x600
-		   LCD monitor, the CRTC should be programmed 800x600 values for
-		   the non visible part, but 640x480 for the visible part.
-		   This code has been tested on a laptop with it's 1400x1050 LCD
-		   monitor and a conventional monitor both switched on.
-		   Tested modes: 1280x1024, 1152x864, 1024x768, 800x600,
-		    works with little glitches also with DOUBLESCAN modes
+		/*
+		 * This is horror! When we simulate, say 640x480 on an 800x600
+		 * LCD monitor, the CRTC should be programmed 800x600 values for
+		 * the non visible part, but 640x480 for the visible part.
+		 * This code has been tested on a laptop with it's 1400x1050 LCD
+		 * monitor and a conventional monitor both switched on.
+		 * Tested modes: 1280x1024, 1152x864, 1024x768, 800x600,
+		 * works with little glitches also with DOUBLESCAN modes
 		 */
 		if (yres < par->lcd_height) {
 			VScan = par->lcd_height / yres;
-			if(VScan > 1) {
+			if (VScan > 1) {
 				VScan = 2;
 				vmode |= FB_VMODE_DOUBLE;
 			}
@@ -952,7 +967,7 @@ static int aty_var_to_crtc(const struct 
 	FAIL_MAX("h_disp too large", h_disp, 0xff);
 	FAIL_MAX("h_sync_strt too large", h_sync_strt, 0x1ff);
 	/*FAIL_MAX("h_sync_wid too large", h_sync_wid, 0x1f);*/
-	if(h_sync_wid > 0x1f)
+	if (h_sync_wid > 0x1f)
 		h_sync_wid = 0x1f;
 	FAIL_MAX("h_total too large", h_total, 0x1ff);
 
@@ -978,7 +993,7 @@ static int aty_var_to_crtc(const struct 
 	FAIL_MAX("v_disp too large", v_disp, 0x7ff);
 	FAIL_MAX("v_sync_stsrt too large", v_sync_strt, 0x7ff);
 	/*FAIL_MAX("v_sync_wid too large", v_sync_wid, 0x1f);*/
-	if(v_sync_wid > 0x1f)
+	if (v_sync_wid > 0x1f)
 		v_sync_wid = 0x1f;
 	FAIL_MAX("v_total too large", v_total, 0x7ff);
 
@@ -995,11 +1010,13 @@ static int aty_var_to_crtc(const struct 
 		((line_length / bpp) << 22);
 	crtc->vline_crnt_vline = 0;
 
-	crtc->h_tot_disp = h_total | (h_disp<<16);
-	crtc->h_sync_strt_wid = (h_sync_strt & 0xff) | (h_sync_dly<<8) |
-		((h_sync_strt & 0x100)<<4) | (h_sync_wid<<16) | (h_sync_pol<<21);
-	crtc->v_tot_disp = v_total | (v_disp<<16);
-	crtc->v_sync_strt_wid = v_sync_strt | (v_sync_wid<<16) | (v_sync_pol<<21);
+	crtc->h_tot_disp = h_total | (h_disp << 16);
+	crtc->h_sync_strt_wid = (h_sync_strt & 0xff) | (h_sync_dly << 8) |
+		((h_sync_strt & 0x100) << 4) | (h_sync_wid << 16) |
+		(h_sync_pol << 21);
+	crtc->v_tot_disp = v_total | (v_disp << 16);
+	crtc->v_sync_strt_wid = v_sync_strt | (v_sync_wid << 16) |
+		(v_sync_pol << 21);
 
 	/* crtc->gen_cntl = aty_ld_le32(CRTC_GEN_CNTL, par) & CRTC_PRESERVED_MASK; */
 	crtc->gen_cntl = CRTC_EXT_DISP_EN | CRTC_EN | pix_width | c_sync;
@@ -1014,13 +1031,15 @@ static int aty_var_to_crtc(const struct 
 #ifdef CONFIG_FB_ATY_GENERIC_LCD
 	if (par->lcd_table != 0) {
 		vdisplay = yres;
-		if(vmode & FB_VMODE_DOUBLE)
+		if (vmode & FB_VMODE_DOUBLE)
 			vdisplay <<= 1;
 		crtc->gen_cntl &= ~(CRTC2_EN | CRTC2_PIX_WIDTH);
 		crtc->lcd_gen_cntl &= ~(HORZ_DIVBY2_EN | DIS_HOR_CRT_DIVBY2 |
-			/*TVCLK_PM_EN | VCLK_DAC_PM_EN |*/
-			USE_SHADOWED_VEND | USE_SHADOWED_ROWCUR | SHADOW_EN | SHADOW_RW_EN);
-		crtc->lcd_gen_cntl |= (DONT_SHADOW_VPAR/* | LOCK_8DOT*/);
+					/*TVCLK_PM_EN | VCLK_DAC_PM_EN |*/
+					USE_SHADOWED_VEND |
+					USE_SHADOWED_ROWCUR |
+					SHADOW_EN | SHADOW_RW_EN);
+		crtc->lcd_gen_cntl |= DONT_SHADOW_VPAR/* | LOCK_8DOT*/;
 
 		/* MOBILITY M1 tested, FIXME: LT */
 		crtc->horz_stretching = aty_ld_lcd(HORZ_STRETCHING, par);
@@ -1028,28 +1047,32 @@ static int aty_var_to_crtc(const struct 
 			crtc->ext_vert_stretch = aty_ld_lcd(EXT_VERT_STRETCH, par) &
 				~(AUTO_VERT_RATIO | VERT_STRETCH_MODE | VERT_STRETCH_RATIO3);
 
-		crtc->horz_stretching &=
-			~(HORZ_STRETCH_RATIO | HORZ_STRETCH_LOOP | AUTO_HORZ_RATIO |
-			HORZ_STRETCH_MODE | HORZ_STRETCH_EN);
+		crtc->horz_stretching &= ~(HORZ_STRETCH_RATIO |
+					   HORZ_STRETCH_LOOP | AUTO_HORZ_RATIO |
+					   HORZ_STRETCH_MODE | HORZ_STRETCH_EN);
 		if (xres < par->lcd_width && crtc->lcd_gen_cntl & LCD_ON) {
 			do {
 				/*
-				* The horizontal blender misbehaves when HDisplay is less than a
-				* a certain threshold (440 for a 1024-wide panel).  It doesn't
-				* stretch such modes enough.  Use pixel replication instead of
-				* blending to stretch modes that can be made to exactly fit the
-				* panel width.  The undocumented "NoLCDBlend" option allows the
-				* pixel-replicated mode to be slightly wider or narrower than the
-				* panel width.  It also causes a mode that is exactly half as wide
-				* as the panel to be pixel-replicated, rather than blended.
-				*/
+				 * The horizontal blender misbehaves when
+				 * HDisplay is less than a certain threshold
+				 * (440 for a 1024-wide panel).  It doesn't
+				 * stretch such modes enough.  Use pixel
+				 * replication instead of blending to stretch
+				 * modes that can be made to exactly fit the
+				 * panel width.  The undocumented "NoLCDBlend"
+				 * option allows the pixel-replicated mode to
+				 * be slightly wider or narrower than the
+				 * panel width.  It also causes a mode that is
+				 * exactly half as wide as the panel to be
+				 * pixel-replicated, rather than blended.
+				 */
 				int HDisplay  = xres & ~7;
 				int nStretch  = par->lcd_width / HDisplay;
 				int Remainder = par->lcd_width % HDisplay;
 
 				if ((!Remainder && ((nStretch > 2))) ||
-					(((HDisplay * 16) / par->lcd_width) < 7)) {
-					static const char StretchLoops[] = {10, 12, 13, 15, 16};
+				    (((HDisplay * 16) / par->lcd_width) < 7)) {
+					static const char StretchLoops[] = { 10, 12, 13, 15, 16 };
 					int horz_stretch_loop = -1, BestRemainder;
 					int Numerator = HDisplay, Denominator = par->lcd_width;
 					int Index = 5;
@@ -1098,12 +1121,12 @@ static int aty_var_to_crtc(const struct 
 				(((vdisplay * (VERT_STRETCH_RATIO0 + 1)) / par->lcd_height) & VERT_STRETCH_RATIO0));
 
 			if (!M64_HAS(LT_LCD_REGS) &&
-			    xres <= (M64_HAS(MOBIL_BUS)?1024:800))
+			    xres <= (M64_HAS(MOBIL_BUS) ? 1024 : 800))
 				crtc->ext_vert_stretch |= VERT_STRETCH_MODE;
 		} else {
 			/*
-			 * Don't use vertical blending if the mode is too wide or not
-			 * vertically stretched.
+			 * Don't use vertical blending if the mode is too wide
+			 * or not vertically stretched.
 			 */
 			crtc->vert_stretching = 0;
 		}
@@ -1125,11 +1148,11 @@ static int aty_var_to_crtc(const struct 
 	return 0;
 }
 
-static int aty_crtc_to_var(const struct crtc *crtc, struct fb_var_screeninfo *var)
+static int aty_crtc_to_var(const struct crtc *crtc,
+			   struct fb_var_screeninfo *var)
 {
 	u32 xres, yres, bpp, left, right, upper, lower, hslen, vslen, sync;
-	u32 h_total, h_disp, h_sync_strt, h_sync_dly, h_sync_wid,
-	    h_sync_pol;
+	u32 h_total, h_disp, h_sync_strt, h_sync_dly, h_sync_wid, h_sync_pol;
 	u32 v_total, v_disp, v_sync_strt, v_sync_wid, v_sync_pol, c_sync;
 	u32 pix_width;
 	u32 double_scan, interlace;
@@ -1161,8 +1184,8 @@ static int aty_crtc_to_var(const struct 
 	lower = v_sync_strt - v_disp;
 	vslen = v_sync_wid;
 	sync = (h_sync_pol ? 0 : FB_SYNC_HOR_HIGH_ACT) |
-	    (v_sync_pol ? 0 : FB_SYNC_VERT_HIGH_ACT) |
-	    (c_sync ? FB_SYNC_COMP_HIGH_ACT : 0);
+		(v_sync_pol ? 0 : FB_SYNC_VERT_HIGH_ACT) |
+		(c_sync ? FB_SYNC_COMP_HIGH_ACT : 0);
 
 	switch (pix_width) {
 #if 0
@@ -1252,20 +1275,21 @@ static int aty_crtc_to_var(const struct 
 	var->vsync_len = vslen;
 	var->sync = sync;
 	var->vmode = FB_VMODE_NONINTERLACED;
-	/* In double scan mode, the vertical parameters are doubled, so we need to
-	   half them to get the right values.
-	   In interlaced mode the values are already correct, so no correction is
-	   necessary.
+	/*
+	 * In double scan mode, the vertical parameters are doubled,
+	 * so we need to halve them to get the right values.
+	 * In interlaced mode the values are already correct,
+	 * so no correction is necessary.
 	 */
 	if (interlace)
 		var->vmode = FB_VMODE_INTERLACED;
 
 	if (double_scan) {
 		var->vmode = FB_VMODE_DOUBLE;
-		var->yres>>=1;
-		var->upper_margin>>=1;
-		var->lower_margin>>=1;
-		var->vsync_len>>=1;
+		var->yres >>= 1;
+		var->upper_margin >>= 1;
+		var->lower_margin >>= 1;
+		var->vsync_len >>= 1;
 	}
 
 	return 0;
@@ -1286,7 +1310,8 @@ static int atyfb_set_par(struct fb_info 
 	if (par->asleep)
 		return 0;
 
-	if ((err = aty_var_to_crtc(info, var, &par->crtc)))
+	err = aty_var_to_crtc(info, var, &par->crtc);
+	if (err)
 		return err;
 
 	pixclock = atyfb_get_pixclock(var, par);
@@ -1295,7 +1320,9 @@ static int atyfb_set_par(struct fb_info 
 		PRINTKE("Invalid pixclock\n");
 		return -EINVAL;
 	} else {
-		if((err = par->pll_ops->var_to_pll(info, pixclock, var->bits_per_pixel, &par->pll)))
+		err = par->pll_ops->var_to_pll(info, pixclock,
+					       var->bits_per_pixel, &par->pll);
+		if (err)
 			return err;
 	}
 
@@ -1313,22 +1340,23 @@ static int atyfb_set_par(struct fb_info 
 		wait_for_idle(par);
 
 	aty_set_crtc(par, &par->crtc);
-	par->dac_ops->set_dac(info, &par->pll, var->bits_per_pixel, par->accel_flags);
+	par->dac_ops->set_dac(info, &par->pll,
+			      var->bits_per_pixel, par->accel_flags);
 	par->pll_ops->set_pll(info, &par->pll);
 
 #ifdef DEBUG
-	if(par->pll_ops && par->pll_ops->pll_to_var)
-		pixclock_in_ps = par->pll_ops->pll_to_var(info, &(par->pll));
+	if (par->pll_ops && par->pll_ops->pll_to_var)
+		pixclock_in_ps = par->pll_ops->pll_to_var(info, &par->pll);
 	else
 		pixclock_in_ps = 0;
 
-	if(0 == pixclock_in_ps) {
+	if (0 == pixclock_in_ps) {
 		PRINTKE("ALERT ops->pll_to_var get 0\n");
 		pixclock_in_ps = pixclock;
 	}
 
 	memset(&debug, 0, sizeof(debug));
-	if(!aty_crtc_to_var(&(par->crtc), &debug)) {
+	if (!aty_crtc_to_var(&par->crtc, &debug)) {
 		u32 hSync, vRefresh;
 		u32 h_disp, h_sync_strt, h_sync_end, h_total;
 		u32 v_disp, v_sync_strt, v_sync_end, v_total;
@@ -1344,16 +1372,20 @@ static int atyfb_set_par(struct fb_info 
 
 		hSync = 1000000000 / (pixclock_in_ps * h_total);
 		vRefresh = (hSync * 1000) / v_total;
-        	if (par->crtc.gen_cntl & CRTC_INTERLACE_EN)
-            	vRefresh *= 2;
-        	if (par->crtc.gen_cntl & CRTC_DBL_SCAN_EN)
-            	vRefresh /= 2;
+		if (par->crtc.gen_cntl & CRTC_INTERLACE_EN)
+			vRefresh *= 2;
+		if (par->crtc.gen_cntl & CRTC_DBL_SCAN_EN)
+			vRefresh /= 2;
 
 		DPRINTK("atyfb_set_par\n");
-		DPRINTK(" Set Visible Mode to %ix%i-%i\n", var->xres, var->yres, var->bits_per_pixel);
-		DPRINTK(" Virtual resolution %ix%i, pixclock_in_ps %i (calculated %i)\n",
-			var->xres_virtual, var->yres_virtual, pixclock, pixclock_in_ps);
-		DPRINTK(" Dot clock:           %i MHz\n", 1000000 / pixclock_in_ps);
+		DPRINTK(" Set Visible Mode to %ix%i-%i\n",
+			var->xres, var->yres, var->bits_per_pixel);
+		DPRINTK(" Virtual resolution %ix%i, "
+			"pixclock_in_ps %i (calculated %i)\n",
+			var->xres_virtual, var->yres_virtual,
+			pixclock, pixclock_in_ps);
+		DPRINTK(" Dot clock:           %i MHz\n",
+			1000000 / pixclock_in_ps);
 		DPRINTK(" Horizontal sync:     %i kHz\n", hSync);
 		DPRINTK(" Vertical refresh:    %i Hz\n", vRefresh);
 		DPRINTK(" x  style: %i.%03i %i %i %i %i   %i %i %i %i\n",
@@ -1448,7 +1480,8 @@ static int atyfb_set_par(struct fb_info 
 	base = 0x2000;
 	printk("debug atyfb: Mach64 non-shadow register values:");
 	for (i = 0; i < 256; i = i+4) {
-		if(i%16 == 0) printk("\ndebug atyfb: 0x%04X: ", base + i);
+		if (i % 16 == 0)
+			printk("\ndebug atyfb: 0x%04X: ", base + i);
 		printk(" %08X", aty_ld_le32(i, par));
 	}
 	printk("\n\n");
@@ -1458,8 +1491,10 @@ static int atyfb_set_par(struct fb_info 
 	base = 0x00;
 	printk("debug atyfb: Mach64 PLL register values:");
 	for (i = 0; i < 64; i++) {
-		if(i%16 == 0) printk("\ndebug atyfb: 0x%02X: ", base + i);
-		if(i%4 == 0)  printk(" ");
+		if (i % 16 == 0)
+			printk("\ndebug atyfb: 0x%02X: ", base + i);
+		if (i % 4 == 0)
+			printk(" ");
 		printk("%02X", aty_ld_pll_ct(i, par));
 	}
 	printk("\n\n");
@@ -1470,19 +1505,21 @@ static int atyfb_set_par(struct fb_info 
 		/* LCD registers */
 		base = 0x00;
 		printk("debug atyfb: LCD register values:");
-		if(M64_HAS(LT_LCD_REGS)) {
-		    for(i = 0; i <= POWER_MANAGEMENT; i++) {
-			if(i == EXT_VERT_STRETCH)
-			    continue;
-			printk("\ndebug atyfb: 0x%04X: ", lt_lcd_regs[i]);
-			printk(" %08X", aty_ld_lcd(i, par));
-		    }
-
+		if (M64_HAS(LT_LCD_REGS)) {
+			for (i = 0; i <= POWER_MANAGEMENT; i++) {
+				if (i == EXT_VERT_STRETCH)
+					continue;
+				printk("\ndebug atyfb: 0x%04X: ",
+				       lt_lcd_regs[i]);
+				printk(" %08X", aty_ld_lcd(i, par));
+			}
 		} else {
-		    for (i = 0; i < 64; i++) {
-			if(i%4 == 0) printk("\ndebug atyfb: 0x%02X: ", base + i);
-			printk(" %08X", aty_ld_lcd(i, par));
-		    }
+			for (i = 0; i < 64; i++) {
+				if (i % 4 == 0)
+					printk("\ndebug atyfb: 0x%02X: ",
+					       base + i);
+				printk(" %08X", aty_ld_lcd(i, par));
+			}
 		}
 		printk("\n\n");
 	}
@@ -1500,9 +1537,10 @@ static int atyfb_check_var(struct fb_var
 	union aty_pll pll;
 	u32 pixclock;
 
-	memcpy(&pll, &(par->pll), sizeof(pll));
+	memcpy(&pll, &par->pll, sizeof(pll));
 
-	if((err = aty_var_to_crtc(info, var, &crtc)))
+	err = aty_var_to_crtc(info, var, &crtc);
+	if (err)
 		return err;
 
 	pixclock = atyfb_get_pixclock(var, par);
@@ -1512,7 +1550,9 @@ static int atyfb_check_var(struct fb_var
 			PRINTKE("Invalid pixclock\n");
 		return -EINVAL;
 	} else {
-		if((err = par->pll_ops->var_to_pll(info, pixclock, var->bits_per_pixel, &pll)))
+		err = par->pll_ops->var_to_pll(info, pixclock,
+					       var->bits_per_pixel, &pll);
+		if (err)
 			return err;
 	}
 
@@ -1539,9 +1579,9 @@ static void set_off_pitch(struct atyfb_p
 }
 
 
-    /*
-     *  Open/Release the frame buffer device
-     */
+/*
+ * Open/Release the frame buffer device
+ */
 
 static int atyfb_open(struct fb_info *info, int user)
 {
@@ -1553,7 +1593,7 @@ static int atyfb_open(struct fb_info *in
 		par->mmaped = 0;
 #endif
 	}
-	return (0);
+	return 0;
 }
 
 static irqreturn_t aty_irq(int irq, void *dev_id)
@@ -1568,7 +1608,8 @@ static irqreturn_t aty_irq(int irq, void
 
 	if (int_cntl & CRTC_VBLANK_INT) {
 		/* clear interrupt */
-		aty_st_le32(CRTC_INT_CNTL, (int_cntl & CRTC_INT_EN_MASK) | CRTC_VBLANK_INT_AK, par);
+		aty_st_le32(CRTC_INT_CNTL, (int_cntl & CRTC_INT_EN_MASK) |
+			    CRTC_VBLANK_INT_AK, par);
 		par->vblank.count++;
 		if (par->vblank.pan_display) {
 			par->vblank.pan_display = 0;
@@ -1603,9 +1644,11 @@ static int aty_enable_irq(struct atyfb_p
 		spin_lock_irq(&par->int_lock);
 		int_cntl = aty_ld_le32(CRTC_INT_CNTL, par) & CRTC_INT_EN_MASK;
 		if (!(int_cntl & CRTC_VBLANK_INT_EN)) {
-			printk("atyfb: someone disabled IRQ [%08x]\n", int_cntl);
+			printk("atyfb: someone disabled IRQ [%08x]\n",
+			       int_cntl);
 			/* re-enable interrupt */
-			aty_st_le32(CRTC_INT_CNTL, int_cntl | CRTC_VBLANK_INT_EN, par );
+			aty_st_le32(CRTC_INT_CNTL, int_cntl |
+				    CRTC_VBLANK_INT_EN, par);
 		}
 		spin_unlock_irq(&par->int_lock);
 	}
@@ -1625,7 +1668,7 @@ static int aty_disable_irq(struct atyfb_
 		spin_lock_irq(&par->int_lock);
 		int_cntl = aty_ld_le32(CRTC_INT_CNTL, par) & CRTC_INT_EN_MASK;
 		/* disable interrupt */
-		aty_st_le32(CRTC_INT_CNTL, int_cntl & ~CRTC_VBLANK_INT_EN, par );
+		aty_st_le32(CRTC_INT_CNTL, int_cntl & ~CRTC_VBLANK_INT_EN, par);
 		spin_unlock_irq(&par->int_lock);
 		free_irq(par->irq, par);
 	}
@@ -1636,50 +1679,62 @@ static int aty_disable_irq(struct atyfb_
 static int atyfb_release(struct fb_info *info, int user)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
-	if (user) {
-		par->open--;
-		mdelay(1);
-		wait_for_idle(par);
-		if (!par->open) {
 #ifdef __sparc__
-			int was_mmaped = par->mmaped;
+	int was_mmaped;
+#endif
 
-			par->mmaped = 0;
+	if (!user)
+		return 0;
 
-			if (was_mmaped) {
-				struct fb_var_screeninfo var;
+	par->open--;
+	mdelay(1);
+	wait_for_idle(par);
 
-				/* Now reset the default display config, we have no
-				 * idea what the program(s) which mmap'd the chip did
-				 * to the configuration, nor whether it restored it
-				 * correctly.
-				 */
-				var = default_var;
-				if (noaccel)
-					var.accel_flags &= ~FB_ACCELF_TEXT;
-				else
-					var.accel_flags |= FB_ACCELF_TEXT;
-				if (var.yres == var.yres_virtual) {
-					u32 videoram = (info->fix.smem_len - (PAGE_SIZE << 2));
-					var.yres_virtual = ((videoram * 8) / var.bits_per_pixel) / var.xres_virtual;
-					if (var.yres_virtual < var.yres)
-						var.yres_virtual = var.yres;
-				}
-			}
-#endif
-			aty_disable_irq(par);
+	if (par->open)
+		return 0;
+
+#ifdef __sparc__
+	was_mmaped = par->mmaped;
+
+	par->mmaped = 0;
+
+	if (was_mmaped) {
+		struct fb_var_screeninfo var;
+
+		/*
+		 * Now reset the default display config, we have
+		 * no idea what the program(s) which mmap'd the
+		 * chip did to the configuration, nor whether it
+		 * restored it correctly.
+		 */
+		var = default_var;
+		if (noaccel)
+			var.accel_flags &= ~FB_ACCELF_TEXT;
+		else
+			var.accel_flags |= FB_ACCELF_TEXT;
+		if (var.yres == var.yres_virtual) {
+			u32 videoram = (info->fix.smem_len - (PAGE_SIZE << 2));
+			var.yres_virtual =
+				((videoram * 8) / var.bits_per_pixel) /
+				var.xres_virtual;
+			if (var.yres_virtual < var.yres)
+				var.yres_virtual = var.yres;
 		}
 	}
-	return (0);
+#endif
+	aty_disable_irq(par);
+
+	return 0;
 }
 
-    /*
-     *  Pan or Wrap the Display
-     *
-     *  This call looks only at xoffset, yoffset and the FB_VMODE_YWRAP flag
-     */
+/*
+ * Pan or Wrap the Display
+ *
+ * This call looks only at xoffset, yoffset and the FB_VMODE_YWRAP flag
+ */
 
-static int atyfb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
+static int atyfb_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *info)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
 	u32 xres, yres, xoffset, yoffset;
@@ -1690,7 +1745,8 @@ static int atyfb_pan_display(struct fb_v
 		yres >>= 1;
 	xoffset = (var->xoffset + 7) & ~7;
 	yoffset = var->yoffset;
-	if (xoffset + xres > par->crtc.vxres || yoffset + yres > par->crtc.vyres)
+	if (xoffset + xres > par->crtc.vxres ||
+	    yoffset + yres > par->crtc.vyres)
 		return -EINVAL;
 	info->var.xoffset = xoffset;
 	info->var.yoffset = yoffset;
@@ -1727,10 +1783,10 @@ static int aty_waitforvblank(struct atyf
 		return ret;
 
 	count = vbl->count;
-	ret = wait_event_interruptible_timeout(vbl->wait, count != vbl->count, HZ/10);
-	if (ret < 0) {
+	ret = wait_event_interruptible_timeout(vbl->wait,
+					       count != vbl->count, HZ/10);
+	if (ret < 0)
 		return ret;
-	}
 	if (ret == 0) {
 		aty_enable_irq(par, 1);
 		return -ETIMEDOUT;
@@ -1784,7 +1840,8 @@ static int atyfb_ioctl(struct fb_info *i
 		fbtyp.fb_depth = info->var.bits_per_pixel;
 		fbtyp.fb_cmsize = info->cmap.len;
 		fbtyp.fb_size = info->fix.smem_len;
-		if (copy_to_user((struct fbtype __user *) arg, &fbtyp, sizeof(fbtyp)))
+		if (copy_to_user((struct fbtype __user *) arg, &fbtyp,
+				 sizeof(fbtyp)))
 			return -EFAULT;
 		break;
 #endif /* __sparc__ */
@@ -1804,7 +1861,7 @@ static int atyfb_ioctl(struct fb_info *i
 	case ATYIO_CLKR:
 		if (M64_HAS(INTEGRATED)) {
 			struct atyclk clk;
-			union aty_pll *pll = &(par->pll);
+			union aty_pll *pll = &par->pll;
 			u32 dsp_config = pll->ct.dsp_config;
 			u32 dsp_on_off = pll->ct.dsp_on_off;
 			clk.ref_clk_per = par->ref_clk_per;
@@ -1829,8 +1886,9 @@ static int atyfb_ioctl(struct fb_info *i
 	case ATYIO_CLKW:
 		if (M64_HAS(INTEGRATED)) {
 			struct atyclk clk;
-			union aty_pll *pll = &(par->pll);
-			if (copy_from_user(&clk, (struct atyclk __user *) arg, sizeof(clk)))
+			union aty_pll *pll = &par->pll;
+			if (copy_from_user(&clk, (struct atyclk __user *) arg,
+					   sizeof(clk)))
 				return -EFAULT;
 			par->ref_clk_per = clk.ref_clk_per;
 			pll->ct.pll_ref_div = clk.pll_ref_div;
@@ -1841,8 +1899,10 @@ static int atyfb_ioctl(struct fb_info *i
 			pll->ct.vclk_fb_div = clk.vclk_fb_div;
 			pll->ct.vclk_post_div_real = clk.vclk_post_div;
 			pll->ct.dsp_config = (clk.dsp_xclks_per_row & 0x3fff) |
-				((clk.dsp_loop_latency & 0xf)<<16)| ((clk.dsp_precision & 7)<<20);
-			pll->ct.dsp_on_off = (clk.dsp_off & 0x7ff) | ((clk.dsp_on & 0x7ff)<<16);
+				((clk.dsp_loop_latency & 0xf) << 16) |
+				((clk.dsp_precision & 7) << 20);
+			pll->ct.dsp_on_off = (clk.dsp_off & 0x7ff) |
+				((clk.dsp_on & 0x7ff) << 16);
 			/*aty_calc_pll_ct(info, &pll->ct);*/
 			aty_set_pll_ct(info, pll);
 		} else
@@ -1913,8 +1973,7 @@ static int atyfb_mmap(struct fb_info *in
 				continue;
 
 			map_size = par->mmap_map[i].size - (offset - start);
-			map_offset =
-			    par->mmap_map[i].poff + (offset - start);
+			map_offset = par->mmap_map[i].poff + (offset - start);
 			break;
 		}
 		if (!map_size) {
@@ -1924,8 +1983,7 @@ static int atyfb_mmap(struct fb_info *in
 		if (page + map_size > size)
 			map_size = size - page;
 
-		pgprot_val(vma->vm_page_prot) &=
-		    ~(par->mmap_map[i].prot_mask);
+		pgprot_val(vma->vm_page_prot) &= ~(par->mmap_map[i].prot_mask);
 		pgprot_val(vma->vm_page_prot) |= par->mmap_map[i].prot_flag;
 
 		if (remap_pfn_range(vma, vma->vm_start + page,
@@ -2029,7 +2087,8 @@ static int atyfb_pci_suspend(struct pci_
 	par->asleep = 1;
 	par->lock_blank = 1;
 
-	/* Because we may change PCI D state ourselves, we need to
+	/*
+	 * Because we may change PCI D state ourselves, we need to
 	 * first save the config space content so the core can
 	 * restore it properly on resume.
 	 */
@@ -2080,7 +2139,8 @@ static int atyfb_pci_resume(struct pci_d
 
 	acquire_console_sem();
 
-	/* PCI state will have been restored by the core, so
+	/*
+	 * PCI state will have been restored by the core, so
 	 * we should be in D0 now with our config space fully
 	 * restored
 	 */
@@ -2192,8 +2252,8 @@ static void aty_bl_init(struct atyfb_par
 
 	info->bl_dev = bd;
 	fb_bl_default_curve(info, 0,
-		0x3F * FB_BACKLIGHT_MAX / MAX_LEVEL,
-		0xFF * FB_BACKLIGHT_MAX / MAX_LEVEL);
+			    0x3F * FB_BACKLIGHT_MAX / MAX_LEVEL,
+			    0xFF * FB_BACKLIGHT_MAX / MAX_LEVEL);
 
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
@@ -2236,16 +2296,16 @@ static void __devinit aty_calc_mem_refre
 		size = ARRAY_SIZE(ragepro_tbl);
 	}
 
-	for (i=0; i < size; i++) {
+	for (i = 0; i < size; i++) {
 		if (xclk < refresh_tbl[i])
-		break;
+			break;
 	}
 	par->mem_refresh_rate = i;
 }
 
-    /*
-     *  Initialisation
-     */
+/*
+ * Initialisation
+ */
 
 static struct fb_info *fb_list = NULL;
 
@@ -2375,8 +2435,10 @@ static int __devinit aty_init(struct fb_
 	}
 #endif
 #ifdef CONFIG_PPC_PMAC
-	/* The Apple iBook1 uses non-standard memory frequencies. We detect it
-	 * and set the frequency manually. */
+	/*
+	 * The Apple iBook1 uses non-standard memory frequencies.
+	 * We detect it and set the frequency manually.
+	 */
 	if (machine_is_compatible("PowerBook2,1")) {
 		par->pll_limits.mclk = 70;
 		par->pll_limits.xclk = 53;
@@ -2421,13 +2483,14 @@ static int __devinit aty_init(struct fb_
 
 	/* save previous video mode */
 	aty_get_crtc(par, &par->saved_crtc);
-	if(par->pll_ops->get_pll)
+	if (par->pll_ops->get_pll)
 		par->pll_ops->get_pll(info, &par->saved_pll);
 
 	par->mem_cntl = aty_ld_le32(MEM_CNTL, par);
 	gtb_memsize = M64_HAS(GTB_DSP);
 	if (gtb_memsize)
-		switch (par->mem_cntl & 0xF) {	/* 0xF used instead of MEM_SIZE_ALIAS */
+		/* 0xF used instead of MEM_SIZE_ALIAS */
+		switch (par->mem_cntl & 0xF) {
 		case MEM_SIZE_512K:
 			info->fix.smem_len = 0x80000;
 			break;
@@ -2496,8 +2559,8 @@ static int __devinit aty_init(struct fb_
 	}
 
 	/*
-	 *  Reg Block 0 (CT-compatible block) is at mmio_start
-	 *  Reg Block 1 (multimedia extensions) is at mmio_start - 0x400
+	 * Reg Block 0 (CT-compatible block) is at mmio_start
+	 * Reg Block 1 (multimedia extensions) is at mmio_start - 0x400
 	 */
 	if (M64_HAS(GX)) {
 		info->fix.mmio_len = 0x400;
@@ -2516,84 +2579,98 @@ static int __devinit aty_init(struct fb_
 	}
 
 	PRINTKI("%d%c %s, %s MHz XTAL, %d MHz PLL, %d Mhz MCLK, %d MHz XCLK\n",
-	       info->fix.smem_len == 0x80000 ? 512 : (info->fix.smem_len >> 20),
-	       info->fix.smem_len == 0x80000 ? 'K' : 'M', ramname, xtal, par->pll_limits.pll_max,
-	       par->pll_limits.mclk, par->pll_limits.xclk);
+		info->fix.smem_len == 0x80000 ? 512 : (info->fix.smem_len>>20),
+		info->fix.smem_len == 0x80000 ? 'K' : 'M', ramname, xtal,
+		par->pll_limits.pll_max, par->pll_limits.mclk,
+		par->pll_limits.xclk);
 
 #if defined(DEBUG) && defined(CONFIG_FB_ATY_CT)
 	if (M64_HAS(INTEGRATED)) {
 		int i;
-		printk("debug atyfb: BUS_CNTL DAC_CNTL MEM_CNTL EXT_MEM_CNTL CRTC_GEN_CNTL "
-		       "DSP_CONFIG DSP_ON_OFF CLOCK_CNTL\n"
-		       "debug atyfb: %08x %08x %08x %08x     %08x      %08x   %08x   %08x\n"
+		printk("debug atyfb: BUS_CNTL DAC_CNTL MEM_CNTL "
+		       "EXT_MEM_CNTL CRTC_GEN_CNTL DSP_CONFIG "
+		       "DSP_ON_OFF CLOCK_CNTL\n"
+		       "debug atyfb: %08x %08x %08x "
+		       "%08x     %08x      %08x   "
+		       "%08x   %08x\n"
 		       "debug atyfb: PLL",
-			aty_ld_le32(BUS_CNTL, par), aty_ld_le32(DAC_CNTL, par),
-			aty_ld_le32(MEM_CNTL, par), aty_ld_le32(EXT_MEM_CNTL, par),
-			aty_ld_le32(CRTC_GEN_CNTL, par), aty_ld_le32(DSP_CONFIG, par),
-			aty_ld_le32(DSP_ON_OFF, par), aty_ld_le32(CLOCK_CNTL, par));
+		       aty_ld_le32(BUS_CNTL, par),
+		       aty_ld_le32(DAC_CNTL, par),
+		       aty_ld_le32(MEM_CNTL, par),
+		       aty_ld_le32(EXT_MEM_CNTL, par),
+		       aty_ld_le32(CRTC_GEN_CNTL, par),
+		       aty_ld_le32(DSP_CONFIG, par),
+		       aty_ld_le32(DSP_ON_OFF, par),
+		       aty_ld_le32(CLOCK_CNTL, par));
 		for (i = 0; i < 40; i++)
 			printk(" %02x", aty_ld_pll_ct(i, par));
 		printk("\n");
 	}
 #endif
-	if(par->pll_ops->init_pll)
+	if (par->pll_ops->init_pll)
 		par->pll_ops->init_pll(info, &par->pll);
 	if (par->pll_ops->resume_pll)
 		par->pll_ops->resume_pll(info, &par->pll);
 
 	/*
-	 *  Last page of 8 MB (4 MB on ISA) aperture is MMIO,
-	 *  unless the auxiliary register aperture is used.
+	 * Last page of 8 MB (4 MB on ISA) aperture is MMIO,
+	 * unless the auxiliary register aperture is used.
 	 */
-
 	if (!par->aux_start &&
-		(info->fix.smem_len == 0x800000 || (par->bus_type == ISA && info->fix.smem_len == 0x400000)))
+	    (info->fix.smem_len == 0x800000 ||
+	     (par->bus_type == ISA && info->fix.smem_len == 0x400000)))
 		info->fix.smem_len -= GUI_RESERVE;
 
 	/*
-	 *  Disable register access through the linear aperture
-	 *  if the auxiliary aperture is used so we can access
-	 *  the full 8 MB of video RAM on 8 MB boards.
+	 * Disable register access through the linear aperture
+	 * if the auxiliary aperture is used so we can access
+	 * the full 8 MB of video RAM on 8 MB boards.
 	 */
 	if (par->aux_start)
-		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
+		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) |
+			    BUS_APER_REG_DIS, par);
 
 #ifdef CONFIG_MTRR
 	par->mtrr_aper = -1;
 	par->mtrr_reg = -1;
 	if (!nomtrr) {
 		/* Cover the whole resource. */
-		 par->mtrr_aper = mtrr_add(par->res_start, par->res_size, MTRR_TYPE_WRCOMB, 1);
-		 if (par->mtrr_aper >= 0 && !par->aux_start) {
+		par->mtrr_aper = mtrr_add(par->res_start, par->res_size,
+					  MTRR_TYPE_WRCOMB, 1);
+		if (par->mtrr_aper >= 0 && !par->aux_start) {
 			/* Make a hole for mmio. */
-			par->mtrr_reg = mtrr_add(par->res_start + 0x800000 - GUI_RESERVE,
-				GUI_RESERVE, MTRR_TYPE_UNCACHABLE, 1);
+			par->mtrr_reg = mtrr_add(par->res_start + 0x800000 -
+						 GUI_RESERVE, GUI_RESERVE,
+						 MTRR_TYPE_UNCACHABLE, 1);
 			if (par->mtrr_reg < 0) {
 				mtrr_del(par->mtrr_aper, 0, 0);
 				par->mtrr_aper = -1;
 			}
-		 }
+		}
 	}
 #endif
 
 	info->fbops = &atyfb_ops;
 	info->pseudo_palette = par->pseudo_palette;
 	info->flags = FBINFO_DEFAULT           |
-	              FBINFO_HWACCEL_IMAGEBLIT |
-	              FBINFO_HWACCEL_FILLRECT  |
-	              FBINFO_HWACCEL_COPYAREA  |
-	              FBINFO_HWACCEL_YPAN;
+		      FBINFO_HWACCEL_IMAGEBLIT |
+		      FBINFO_HWACCEL_FILLRECT  |
+		      FBINFO_HWACCEL_COPYAREA  |
+		      FBINFO_HWACCEL_YPAN;
 
 #ifdef CONFIG_PMAC_BACKLIGHT
 	if (M64_HAS(G3_PB_1_1) && machine_is_compatible("PowerBook1,1")) {
-		/* these bits let the 101 powerbook wake up from sleep -- paulus */
-		aty_st_lcd(POWER_MANAGEMENT, aty_ld_lcd(POWER_MANAGEMENT, par)
-			   | (USE_F32KHZ | TRISTATE_MEM_EN), par);
+		/*
+		 * these bits let the 101 powerbook
+		 * wake up from sleep -- paulus
+		 */
+		aty_st_lcd(POWER_MANAGEMENT, aty_ld_lcd(POWER_MANAGEMENT, par) |
+			   USE_F32KHZ | TRISTATE_MEM_EN, par);
 	} else
 #endif
 	if (M64_HAS(MOBIL_BUS) && backlight) {
 #ifdef CONFIG_FB_ATY_BACKLIGHT
-		aty_bl_init (par);
+		aty_bl_init(par);
 #endif
 	}
 
@@ -2601,8 +2678,8 @@ static int __devinit aty_init(struct fb_
 #ifdef CONFIG_PPC
 	if (machine_is(powermac)) {
 		/*
-		 *  FIXME: The NVRAM stuff should be put in a Mac-specific file, as it
-		 *         applies to all Mac video cards
+		 * FIXME: The NVRAM stuff should be put in a Mac-specific file,
+		 *        as it applies to all Mac video cards
 		 */
 		if (mode) {
 			if (mac_find_mode(&var, info, mode, 8))
@@ -2615,8 +2692,7 @@ static int __devinit aty_init(struct fb_
 					default_vmode = VMODE_1024_768_60;
 				else if (machine_is_compatible("iMac"))
 					default_vmode = VMODE_1024_768_75;
-				else if (machine_is_compatible
-					 ("PowerBook2,1"))
+				else if (machine_is_compatible("PowerBook2,1"))
 					/* iBook with 800x600 LCD */
 					default_vmode = VMODE_800_600_60;
 				else
@@ -2630,7 +2706,7 @@ static int __devinit aty_init(struct fb_
 			if (default_cmode < CMODE_8 || default_cmode > CMODE_32)
 				default_cmode = CMODE_8;
 			if (!mac_vmode_to_var(default_vmode, default_cmode,
-					       &var))
+					      &var))
 				has_var = 1;
 		}
 	}
@@ -2702,12 +2778,12 @@ aty_init_exit:
 
 #ifdef CONFIG_MTRR
 	if (par->mtrr_reg >= 0) {
-	    mtrr_del(par->mtrr_reg, 0, 0);
-	    par->mtrr_reg = -1;
+		mtrr_del(par->mtrr_reg, 0, 0);
+		par->mtrr_reg = -1;
 	}
 	if (par->mtrr_aper >= 0) {
-	    mtrr_del(par->mtrr_aper, 0, 0);
-	    par->mtrr_aper = -1;
+		mtrr_del(par->mtrr_aper, 0, 0);
+		par->mtrr_aper = -1;
 	}
 #endif
 	return ret;
@@ -2735,18 +2811,18 @@ static int __devinit store_video_par(cha
 	phys_size[m64_num] = size;
 	phys_guiregbase[m64_num] = guiregbase;
 	PRINTKI("stored them all: $%08lX $%08lX $%08lX \n", vmembase, size,
-	       guiregbase);
+		guiregbase);
 	return 0;
 
-      mach64_invalid:
+ mach64_invalid:
 	phys_vmembase[m64_num] = 0;
 	return -1;
 }
 #endif /* CONFIG_ATARI */
 
-    /*
-     *  Blank the display.
-     */
+/*
+ * Blank the display.
+ */
 
 static int atyfb_blank(int blank, struct fb_info *info)
 {
@@ -2768,20 +2844,20 @@ static int atyfb_blank(int blank, struct
 	gen_cntl = aty_ld_le32(CRTC_GEN_CNTL, par);
 	gen_cntl &= ~0x400004c;
 	switch (blank) {
-		case FB_BLANK_UNBLANK:
-			break;
-		case FB_BLANK_NORMAL:
-			gen_cntl |= 0x4000040;
-			break;
-		case FB_BLANK_VSYNC_SUSPEND:
-			gen_cntl |= 0x4000048;
-			break;
-		case FB_BLANK_HSYNC_SUSPEND:
-			gen_cntl |= 0x4000044;
-			break;
-		case FB_BLANK_POWERDOWN:
-			gen_cntl |= 0x400004c;
-			break;
+	case FB_BLANK_UNBLANK:
+		break;
+	case FB_BLANK_NORMAL:
+		gen_cntl |= 0x4000040;
+		break;
+	case FB_BLANK_VSYNC_SUSPEND:
+		gen_cntl |= 0x4000048;
+		break;
+	case FB_BLANK_HSYNC_SUSPEND:
+		gen_cntl |= 0x4000044;
+		break;
+	case FB_BLANK_POWERDOWN:
+		gen_cntl |= 0x400004c;
+		break;
 	}
 	aty_st_le32(CRTC_GEN_CNTL, gen_cntl, par);
 
@@ -2806,15 +2882,15 @@ static void aty_st_pal(u_int regno, u_in
 	aty_st_8(DAC_DATA, blue, par);
 }
 
-    /*
-     *  Set a single color register. The values supplied are already
-     *  rounded down to the hardware's capabilities (according to the
-     *  entries in the var structure). Return != 0 for invalid regno.
-     *  !! 4 & 8 =  PSEUDO, > 8 = DIRECTCOLOR
-     */
+/*
+ * Set a single color register. The values supplied are already
+ * rounded down to the hardware's capabilities (according to the
+ * entries in the var structure). Return != 0 for invalid regno.
+ * !! 4 & 8 =  PSEUDO, > 8 = DIRECTCOLOR
+ */
 
 static int atyfb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
-	u_int transp, struct fb_info *info)
+			   u_int transp, struct fb_info *info)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
 	int i, depth;
@@ -2868,16 +2944,15 @@ static int atyfb_setcolreg(u_int regno, 
 		if (depth == 16) {
 			if (regno < 32)
 				aty_st_pal(regno << 3, red,
-					   par->palette[regno<<1].green,
+					   par->palette[regno << 1].green,
 					   blue, par);
-			red = par->palette[regno>>1].red;
-			blue = par->palette[regno>>1].blue;
+			red = par->palette[regno >> 1].red;
+			blue = par->palette[regno >> 1].blue;
 			regno <<= 2;
 		} else if (depth == 15) {
 			regno <<= 3;
-			for(i = 0; i < 8; i++) {
-			    aty_st_pal(regno + i, red, green, blue, par);
-			}
+			for (i = 0; i < 8; i++)
+				aty_st_pal(regno + i, red, green, blue, par);
 		}
 	}
 	aty_st_pal(regno, red, green, blue, par);
@@ -2890,7 +2965,8 @@ static int atyfb_setcolreg(u_int regno, 
 #ifdef __sparc__
 
 static int __devinit atyfb_setup_sparc(struct pci_dev *pdev,
-			struct fb_info *info, unsigned long addr)
+				       struct fb_info *info,
+				       unsigned long addr)
 {
 	struct atyfb_par *par = info->par;
 	struct device_node *dp;
@@ -2978,7 +3054,8 @@ static int __devinit atyfb_setup_sparc(s
 		j++;
 	}
 
-	if((ret = correct_chipset(par)))
+	ret = correct_chipset(par);
+	if (ret)
 		return ret;
 
 	if (IS_XL(pdev->device)) {
@@ -3108,28 +3185,28 @@ static void __devinit aty_init_lcd(struc
 	u32 driv_inf_tab, sig;
 	u16 lcd_ofs;
 
-	/* To support an LCD panel, we should know it's dimensions and
+	/*
+	 * To support an LCD panel, we should know it's dimensions and
 	 *  it's desired pixel clock.
 	 * There are two ways to do it:
 	 *  - Check the startup video mode and calculate the panel
 	 *    size from it. This is unreliable.
 	 *  - Read it from the driver information table in the video BIOS.
-	*/
+	 */
 	/* Address of driver information table is at offset 0x78. */
 	driv_inf_tab = bios_base + *((u16 *)(bios_base+0x78));
 
 	/* Check for the driver information table signature. */
-	sig = (*(u32 *)driv_inf_tab);
+	sig = *(u32 *)driv_inf_tab;
 	if ((sig == 0x54504c24) || /* Rage LT pro */
-		(sig == 0x544d5224) || /* Rage mobility */
-		(sig == 0x54435824) || /* Rage XC */
-		(sig == 0x544c5824)) { /* Rage XL */
+	    (sig == 0x544d5224) || /* Rage mobility */
+	    (sig == 0x54435824) || /* Rage XC */
+	    (sig == 0x544c5824)) { /* Rage XL */
 		PRINTKI("BIOS contains driver information table.\n");
-		lcd_ofs = (*(u16 *)(driv_inf_tab + 10));
+		lcd_ofs = *(u16 *)(driv_inf_tab + 10);
 		par->lcd_table = 0;
-		if (lcd_ofs != 0) {
+		if (lcd_ofs != 0)
 			par->lcd_table = bios_base + lcd_ofs;
-		}
 	}
 
 	if (par->lcd_table != 0) {
@@ -3144,14 +3221,16 @@ static void __devinit aty_init_lcd(struc
 		u16 width, height, panel_type, refresh_rates;
 		u16 *lcdmodeptr;
 		u32 format;
-		u8 lcd_refresh_rates[16] = {50,56,60,67,70,72,75,76,85,90,100,120,140,150,160,200};
-		/* The most important information is the panel size at
+		u8 lcd_refresh_rates[16] = { 50, 56, 60, 67, 70, 72, 75, 76, 85,
+					     90, 100, 120, 140, 150, 160, 200 };
+		/*
+		 * The most important information is the panel size at
 		 * offset 25 and 27, but there's some other nice information
 		 * which we print to the screen.
 		 */
 		id = *(u8 *)par->lcd_table;
-		strncpy(model,(char *)par->lcd_table+1,24);
-		model[23]=0;
+		strncpy(model, (char *)par->lcd_table+1, 24);
+		model[23] = 0;
 
 		width = par->lcd_width = *(u16 *)(par->lcd_table+25);
 		height = par->lcd_height = *(u16 *)(par->lcd_table+27);
@@ -3164,7 +3243,7 @@ static void __devinit aty_init_lcd(struc
 			txtdual = "dual (split) ";
 		else
 			txtdual = "";
-		tech = (panel_type>>2) & 63;
+		tech = (panel_type >> 2) & 63;
 		switch (tech) {
 		case 0:
 			txtmonitor = "passive matrix";
@@ -3224,22 +3303,24 @@ static void __devinit aty_init_lcd(struc
 			}
 		}
 		PRINTKI("%s%s %s monitor detected: %s\n",
-			txtdual ,txtcolour, txtmonitor, model);
+			txtdual, txtcolour, txtmonitor, model);
 		PRINTKI("       id=%d, %dx%d pixels, %s\n",
 			id, width, height, txtformat);
 		refresh_rates_buf[0] = 0;
 		refresh_rates = *(u16 *)(par->lcd_table+62);
 		m = 1;
 		f = 0;
-		for (i=0;i<16;i++) {
+		for (i = 0; i < 16; i++) {
 			if (refresh_rates & m) {
 				if (f == 0) {
-					sprintf(strbuf, "%d", lcd_refresh_rates[i]);
+					sprintf(strbuf, "%d",
+						lcd_refresh_rates[i]);
 					f++;
 				} else {
-					sprintf(strbuf, ",%d", lcd_refresh_rates[i]);
+					sprintf(strbuf, ",%d",
+						lcd_refresh_rates[i]);
 				}
-				strcat(refresh_rates_buf,strbuf);
+				strcat(refresh_rates_buf, strbuf);
 			}
 			m = m << 1;
 		}
@@ -3247,7 +3328,8 @@ static void __devinit aty_init_lcd(struc
 		PRINTKI("       supports refresh rates [%s], default %d Hz\n",
 			refresh_rates_buf, lcd_refresh_rates[default_refresh_rate]);
 		par->lcd_refreshrate = lcd_refresh_rates[default_refresh_rate];
-		/* We now need to determine the crtc parameters for the
+		/*
+		 * We now need to determine the crtc parameters for the
 		 * LCD monitor. This is tricky, because they are not stored
 		 * individually in the BIOS. Instead, the BIOS contains a
 		 * table of display modes that work for this monitor.
@@ -3382,7 +3464,9 @@ static int __devinit init_from_bios(stru
 }
 #endif /* __i386__ */
 
-static int __devinit atyfb_setup_generic(struct pci_dev *pdev, struct fb_info *info, unsigned long addr)
+static int __devinit atyfb_setup_generic(struct pci_dev *pdev,
+					 struct fb_info *info,
+					 unsigned long addr)
 {
 	struct atyfb_par *par = info->par;
 	u16 tmp;
@@ -3429,10 +3513,12 @@ static int __devinit atyfb_setup_generic
 		goto atyfb_setup_generic_fail;
 	}
 
-	if((ret = correct_chipset(par)))
+	ret = correct_chipset(par);
+	if (ret)
 		goto atyfb_setup_generic_fail;
 #ifdef __i386__
-	if((ret = init_from_bios(par)))
+	ret = init_from_bios(par);
+	if (ret)
 		goto atyfb_setup_generic_fail;
 #endif
 	if (!(aty_ld_le32(CRTC_GEN_CNTL, par) & CRTC_EXT_DISP_EN))
@@ -3457,7 +3543,8 @@ atyfb_setup_generic_fail:
 
 #endif /* !__sparc__ */
 
-static int __devinit atyfb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit atyfb_pci_probe(struct pci_dev *pdev,
+				     const struct pci_device_id *ent)
 {
 	unsigned long addr, res_start, res_size;
 	struct fb_info *info;
@@ -3482,10 +3569,10 @@ static int __devinit atyfb_pci_probe(str
 	/* Reserve space */
 	res_start = rp->start;
 	res_size = rp->end - rp->start + 1;
-	if (!request_mem_region (res_start, res_size, "atyfb"))
+	if (!request_mem_region(res_start, res_size, "atyfb"))
 		return -EBUSY;
 
-        /* Allocate framebuffer */
+	/* Allocate framebuffer */
 	info = framebuffer_alloc(sizeof(struct atyfb_par), &pdev->dev);
 	if (!info) {
 		PRINTKE("atyfb_pci_probe() can't alloc fb_info\n");
@@ -3573,7 +3660,8 @@ static int __init atyfb_atari_probe(void
 	for (m64_num = 0; m64_num < mach64_count; m64_num++) {
 		if (!phys_vmembase[m64_num] || !phys_size[m64_num] ||
 		    !phys_guiregbase[m64_num]) {
-		    PRINTKI("phys_*[%d] parameters not set => returning early. \n", m64_num);
+			PRINTKI("phys_*[%d] parameters not set => "
+				"returning early. \n", m64_num);
 			continue;
 		}
 
@@ -3589,8 +3677,8 @@ static int __init atyfb_atari_probe(void
 		par->irq = (unsigned int) -1; /* something invalid */
 
 		/*
-		 *  Map the video memory (physical address given) to somewhere in the
-		 *  kernel address space.
+		 * Map the video memory (physical address given)
+		 * to somewhere in the kernel address space.
 		 */
 		info->screen_base = ioremap(phys_vmembase[m64_num], phys_size[m64_num]);
 		info->fix.smem_start = (unsigned long)info->screen_base; /* Fake! */
@@ -3661,12 +3749,12 @@ static void __devexit atyfb_remove(struc
 
 #ifdef CONFIG_MTRR
 	if (par->mtrr_reg >= 0) {
-	    mtrr_del(par->mtrr_reg, 0, 0);
-	    par->mtrr_reg = -1;
+		mtrr_del(par->mtrr_reg, 0, 0);
+		par->mtrr_reg = -1;
 	}
 	if (par->mtrr_aper >= 0) {
-	    mtrr_del(par->mtrr_aper, 0, 0);
-	    par->mtrr_aper = -1;
+		mtrr_del(par->mtrr_aper, 0, 0);
+		par->mtrr_aper = -1;
 	}
 #endif
 #ifndef __sparc__
@@ -3900,29 +3988,29 @@ static const struct dmi_system_id atyfb_
 
 static int __init atyfb_init(void)
 {
-    int err1 = 1, err2 = 1;
+	int err1 = 1, err2 = 1;
 #ifndef MODULE
-    char *option = NULL;
+	char *option = NULL;
 
-    if (fb_get_options("atyfb", &option))
-	return -ENODEV;
-    atyfb_setup(option);
+	if (fb_get_options("atyfb", &option))
+		return -ENODEV;
+	atyfb_setup(option);
 #endif
 
 #ifdef CONFIG_PCI
-    err1 = pci_register_driver(&atyfb_driver);
+	err1 = pci_register_driver(&atyfb_driver);
 #endif
 #ifdef CONFIG_ATARI
-    err2 = atyfb_atari_probe();
+	err2 = atyfb_atari_probe();
 #endif
 
-    if (err1 && err2)
-	return -ENODEV;
+	if (err1 && err2)
+		return -ENODEV;
 
-    if (dmi_check_system(atyfb_reboot_ids))
-	register_reboot_notifier(&atyfb_reboot_notifier);
+	if (dmi_check_system(atyfb_reboot_ids))
+		register_reboot_notifier(&atyfb_reboot_notifier);
 
-    return 0;
+	return 0;
 }
 
 static void __exit atyfb_exit(void)
@@ -3951,8 +4039,7 @@ MODULE_PARM_DESC(mclk, "int: override me
 module_param(xclk, int, 0);
 MODULE_PARM_DESC(xclk, "int: override accelerated engine clock");
 module_param(comp_sync, int, 0);
-MODULE_PARM_DESC(comp_sync,
-		 "Set composite sync signal to low (0) or high (1)");
+MODULE_PARM_DESC(comp_sync, "Set composite sync signal to low (0) or high (1)");
 module_param(mode, charp, 0);
 MODULE_PARM_DESC(mode, "Specify resolution as \"<xres>x<yres>[-<bpp>][@<refresh>]\" ");
 #ifdef CONFIG_MTRR
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-fix-hp-omnibook-500-reboot-hang.patch
atyfb-fix-alignment-for-block-writes.patch
atyfb-coding-style-cleanup.patch
platinumfb-misplaced-parenthesis.patch

