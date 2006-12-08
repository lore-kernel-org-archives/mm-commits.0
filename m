From: akpm@osdl.org
Subject: - atyfb-improve-power-management.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:12 -0800
Message-ID: <200612082014.kB8KEC0V003149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59694 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946811AbWLHUOS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb: Improve power management
has been removed from the -mm tree.  Its filename was
     atyfb-improve-power-management.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Improve power management
From: Ville Syrjala <syrjala@sci.fi>

Some register were only set in aty_init() which is not called on resume.  I
added the aty_resume_chip() function to reset those registers on resume.

Susped-to-ram now works on a HP Omnibook 6000 with acpi_sleep=s3_bios.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb.h      |    2 +
 drivers/video/aty/atyfb_base.c |   61 ++++++++++++++++++++-----------
 drivers/video/aty/mach64_ct.c  |   39 +++++++++++++------
 3 files changed, 68 insertions(+), 34 deletions(-)

diff -puN drivers/video/aty/atyfb.h~atyfb-improve-power-management drivers/video/aty/atyfb.h
--- a/drivers/video/aty/atyfb.h~atyfb-improve-power-management
+++ a/drivers/video/aty/atyfb.h
@@ -185,6 +185,7 @@ struct atyfb_par {
 	int mtrr_aper;
 	int mtrr_reg;
 #endif
+	u32 mem_cntl;
 };
 
     /*
@@ -314,6 +315,7 @@ struct aty_pll_ops {
 	void (*set_pll)   (const struct fb_info * info, const union aty_pll * pll);
 	void (*get_pll)   (const struct fb_info *info, union aty_pll * pll);
 	int (*init_pll)   (const struct fb_info * info, union aty_pll * pll);
+	void (*resume_pll)(const struct fb_info *info, union aty_pll *pll);
 };
 
 extern const struct aty_pll_ops aty_pll_ati18818_1; /* ATI 18818 */
diff -puN drivers/video/aty/atyfb_base.c~atyfb-improve-power-management drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-improve-power-management
+++ a/drivers/video/aty/atyfb_base.c
@@ -242,6 +242,7 @@ static int atyfb_sync(struct fb_info *in
      */
 
 static int aty_init(struct fb_info *info);
+static void aty_resume_chip(struct fb_info *info);
 #ifdef CONFIG_ATARI
 static int store_video_par(char *videopar, unsigned char m64_num);
 #endif
@@ -1971,6 +1972,7 @@ static void atyfb_palette(int enter)
 
 #if defined(CONFIG_PM) && defined(CONFIG_PCI)
 
+#ifdef CONFIG_PPC_PMAC
 /* Power management routines. Those are used for PowerBook sleep.
  */
 static int aty_power_mgmt(int sleep, struct atyfb_par *par)
@@ -2027,21 +2029,13 @@ static int aty_power_mgmt(int sleep, str
 
 	return timeout ? 0 : -EIO;
 }
+#endif
 
 static int atyfb_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
 
-#ifndef CONFIG_PPC_PMAC
-	/* HACK ALERT ! Once I find a proper way to say to each driver
-	 * individually what will happen with it's PCI slot, I'll change
-	 * that. On laptops, the AGP slot is just unclocked, so D2 is
-	 * expected, while on desktops, the card is powered off
-	 */
-	return 0;
-#endif /* CONFIG_PPC_PMAC */
-
 	if (state.event == pdev->dev.power.power_state.event)
 		return 0;
 
@@ -2059,6 +2053,7 @@ static int atyfb_pci_suspend(struct pci_
 	par->asleep = 1;
 	par->lock_blank = 1;
 
+#ifdef CONFIG_PPC_PMAC
 	/* Set chip to "suspend" mode */
 	if (aty_power_mgmt(1, par)) {
 		par->asleep = 0;
@@ -2068,6 +2063,9 @@ static int atyfb_pci_suspend(struct pci_
 		release_console_sem();
 		return -EIO;
 	}
+#else
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+#endif
 
 	release_console_sem();
 
@@ -2086,8 +2084,15 @@ static int atyfb_pci_resume(struct pci_d
 
 	acquire_console_sem();
 
+#ifdef CONFIG_PPC_PMAC
 	if (pdev->dev.power.power_state.event == 2)
 		aty_power_mgmt(0, par);
+#else
+	pci_set_power_state(pdev, PCI_D0);
+#endif
+
+	aty_resume_chip(info);
+
 	par->asleep = 0;
 
 	/* Restore display */
@@ -2339,7 +2344,6 @@ static int __devinit aty_init(struct fb_
 	const char *ramname = NULL, *xtal;
 	int gtb_memsize, has_var = 0;
 	struct fb_var_screeninfo var;
-	u32 i;
 
 	init_waitqueue_head(&par->vblank.wait);
 	spin_lock_init(&par->int_lock);
@@ -2470,10 +2474,10 @@ static int __devinit aty_init(struct fb_
 	if(par->pll_ops->get_pll)
 		par->pll_ops->get_pll(info, &saved_pll);
 
-	i = aty_ld_le32(MEM_CNTL, par);
+	par->mem_cntl = aty_ld_le32(MEM_CNTL, par);
 	gtb_memsize = M64_HAS(GTB_DSP);
 	if (gtb_memsize)
-		switch (i & 0xF) {	/* 0xF used instead of MEM_SIZE_ALIAS */
+		switch (par->mem_cntl & 0xF) {	/* 0xF used instead of MEM_SIZE_ALIAS */
 		case MEM_SIZE_512K:
 			info->fix.smem_len = 0x80000;
 			break;
@@ -2495,7 +2499,7 @@ static int __devinit aty_init(struct fb_
 		default:
 			info->fix.smem_len = 0x80000;
 	} else
-		switch (i & MEM_SIZE_ALIAS) {
+		switch (par->mem_cntl & MEM_SIZE_ALIAS) {
 		case MEM_SIZE_512K:
 			info->fix.smem_len = 0x80000;
 			break;
@@ -2525,20 +2529,20 @@ static int __devinit aty_init(struct fb_
 
 	if (vram) {
 		info->fix.smem_len = vram * 1024;
-		i = i & ~(gtb_memsize ? 0xF : MEM_SIZE_ALIAS);
+		par->mem_cntl &= ~(gtb_memsize ? 0xF : MEM_SIZE_ALIAS);
 		if (info->fix.smem_len <= 0x80000)
-			i |= MEM_SIZE_512K;
+			par->mem_cntl |= MEM_SIZE_512K;
 		else if (info->fix.smem_len <= 0x100000)
-			i |= MEM_SIZE_1M;
+			par->mem_cntl |= MEM_SIZE_1M;
 		else if (info->fix.smem_len <= 0x200000)
-			i |= gtb_memsize ? MEM_SIZE_2M_GTB : MEM_SIZE_2M;
+			par->mem_cntl |= gtb_memsize ? MEM_SIZE_2M_GTB : MEM_SIZE_2M;
 		else if (info->fix.smem_len <= 0x400000)
-			i |= gtb_memsize ? MEM_SIZE_4M_GTB : MEM_SIZE_4M;
+			par->mem_cntl |= gtb_memsize ? MEM_SIZE_4M_GTB : MEM_SIZE_4M;
 		else if (info->fix.smem_len <= 0x600000)
-			i |= gtb_memsize ? MEM_SIZE_6M_GTB : MEM_SIZE_6M;
+			par->mem_cntl |= gtb_memsize ? MEM_SIZE_6M_GTB : MEM_SIZE_6M;
 		else
-			i |= gtb_memsize ? MEM_SIZE_8M_GTB : MEM_SIZE_8M;
-		aty_st_le32(MEM_CNTL, i, par);
+			par->mem_cntl |= gtb_memsize ? MEM_SIZE_8M_GTB : MEM_SIZE_8M;
+		aty_st_le32(MEM_CNTL, par->mem_cntl, par);
 	}
 
 	/*
@@ -2584,6 +2588,8 @@ static int __devinit aty_init(struct fb_
 #endif
 	if(par->pll_ops->init_pll)
 		par->pll_ops->init_pll(info, &par->pll);
+	if (par->pll_ops->resume_pll)
+		par->pll_ops->resume_pll(info, &par->pll);
 
 	/*
 	 *  Last page of 8 MB (4 MB on ISA) aperture is MMIO,
@@ -2755,6 +2761,19 @@ aty_init_exit:
 	return -1;
 }
 
+static void aty_resume_chip(struct fb_info *info)
+{
+	struct atyfb_par *par = info->par;
+
+	aty_st_le32(MEM_CNTL, par->mem_cntl, par);
+
+	if (par->pll_ops->resume_pll)
+		par->pll_ops->resume_pll(info, &par->pll);
+
+	if (par->aux_start)
+		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
+}
+
 #ifdef CONFIG_ATARI
 static int __devinit store_video_par(char *video_str, unsigned char m64_num)
 {
diff -puN drivers/video/aty/mach64_ct.c~atyfb-improve-power-management drivers/video/aty/mach64_ct.c
--- a/drivers/video/aty/mach64_ct.c~atyfb-improve-power-management
+++ a/drivers/video/aty/mach64_ct.c
@@ -398,8 +398,8 @@ static int __devinit aty_init_pll_ct(con
 				     union aty_pll *pll)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
-	u8 mpost_div, xpost_div, sclk_post_div_real, sclk_fb_div, spll_cntl2;
-	u32 q, i, memcntl, trp;
+	u8 mpost_div, xpost_div, sclk_post_div_real;
+	u32 q, memcntl, trp;
 	u32 dsp_config, dsp_on_off, vga_dsp_config, vga_dsp_on_off;
 #ifdef DEBUG
 	int pllmclk, pllsclk;
@@ -575,14 +575,30 @@ static int __devinit aty_init_pll_ct(con
 			mpost_div += (q <  32*8);
 		}
 		sclk_post_div_real = postdividers[mpost_div];
-		sclk_fb_div = q * sclk_post_div_real / 8;
-		spll_cntl2 = mpost_div << 4;
+		pll->ct.sclk_fb_div = q * sclk_post_div_real / 8;
+		pll->ct.spll_cntl2 = mpost_div << 4;
 #ifdef DEBUG
-		pllsclk = (1000000 * 2 * sclk_fb_div) /
+		pllsclk = (1000000 * 2 * pll->ct.sclk_fb_div) /
 			(par->ref_clk_per * pll->ct.pll_ref_div);
 		printk("atyfb(%s): use sclk, pllsclk=%d MHz, sclk=mclk=%d MHz\n",
 			__FUNCTION__, pllsclk, pllsclk / sclk_post_div_real);
 #endif
+	}
+
+	/* Disable the extra precision pixel clock controls since we do not use them. */
+	pll->ct.ext_vpll_cntl = aty_ld_pll_ct(EXT_VPLL_CNTL, par);
+	pll->ct.ext_vpll_cntl &= ~(EXT_VPLL_EN | EXT_VPLL_VGA_EN | EXT_VPLL_INSYNC);
+
+	return 0;
+}
+
+static void aty_resume_pll_ct(const struct fb_info *info,
+			      union aty_pll *pll)
+{
+	struct atyfb_par *par = info->par;
+
+	if (par->mclk_per != par->xclk_per) {
+		int i;
 		/*
 		* This disables the sclk, crashes the computer as reported:
 		* aty_st_pll_ct(SPLL_CNTL2, 3, info);
@@ -590,8 +606,8 @@ static int __devinit aty_init_pll_ct(con
 		* So it seems the sclk must be enabled before it is used;
 		* so PLL_GEN_CNTL must be programmed *after* the sclk.
 		*/
-		aty_st_pll_ct(SCLK_FB_DIV, sclk_fb_div, par);
-		aty_st_pll_ct(SPLL_CNTL2, spll_cntl2, par);
+		aty_st_pll_ct(SCLK_FB_DIV, pll->ct.sclk_fb_div, par);
+		aty_st_pll_ct(SPLL_CNTL2, pll->ct.spll_cntl2, par);
 		/*
 		 * The sclk has been started. However, I believe the first clock
 		 * ticks it generates are not very stable. Hope this primitive loop
@@ -605,11 +621,7 @@ static int __devinit aty_init_pll_ct(con
 	aty_st_pll_ct(PLL_GEN_CNTL, pll->ct.pll_gen_cntl, par);
 	aty_st_pll_ct(MCLK_FB_DIV, pll->ct.mclk_fb_div, par);
 	aty_st_pll_ct(PLL_EXT_CNTL, pll->ct.pll_ext_cntl, par);
-	/* Disable the extra precision pixel clock controls since we do not use them. */
-	aty_st_pll_ct(EXT_VPLL_CNTL, aty_ld_pll_ct(EXT_VPLL_CNTL, par) &
-		~(EXT_VPLL_EN | EXT_VPLL_VGA_EN | EXT_VPLL_INSYNC), par);
-
-	return 0;
+	aty_st_pll_ct(EXT_VPLL_CNTL, pll->ct.ext_vpll_cntl, par);
 }
 
 static int dummy(void)
@@ -626,5 +638,6 @@ const struct aty_pll_ops aty_pll_ct = {
 	.pll_to_var	= aty_pll_to_var_ct,
 	.set_pll	= aty_set_pll_ct,
 	.get_pll	= aty_get_pll_ct,
-	.init_pll       = aty_init_pll_ct
+	.init_pll	= aty_init_pll_ct,
+	.resume_pll	= aty_resume_pll_ct,
 };
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-improve-power-management.patch

