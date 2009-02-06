From: akpm@linux-foundation.org
Subject: [merged] atyfb-fix-config_-namespace-violations.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:20 -0800
Message-ID: <200902061938.n16JcKTQ012244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbZBFTia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     atyfb: fix CONFIG_ namespace violations
has been removed from the -mm tree.  Its filename was
     atyfb-fix-config_-namespace-violations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb: fix CONFIG_ namespace violations
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix namespace violations by changing non-kconfig CONFIG_ names to CNFG_*.

Fixes breakage in staging/, which adds a real CONFIG_PANEL.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c    |    8 ++++----
 drivers/video/aty/atyfb_base.c  |   22 +++++++++++-----------
 drivers/video/aty/radeon_base.c |   10 +++++-----
 drivers/video/aty/radeon_pm.c   |   18 +++++++++---------
 include/video/aty128.h          |    4 ++--
 include/video/mach64.h          |   24 ++++++++++++------------
 include/video/radeon.h          |   18 +++++++++---------
 7 files changed, 52 insertions(+), 52 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~atyfb-fix-config_-namespace-violations drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~atyfb-fix-config_-namespace-violations
+++ a/drivers/video/aty/aty128fb.c
@@ -1475,7 +1475,7 @@ static int aty128fb_set_par(struct fb_in
 	aty128_set_pll(&par->pll, par);
 	aty128_set_fifo(&par->fifo_reg, par);
 
-	config = aty_ld_le32(CONFIG_CNTL) & ~3;
+	config = aty_ld_le32(CNFG_CNTL) & ~3;
 
 #if defined(__BIG_ENDIAN)
 	if (par->crtc.bpp == 32)
@@ -1484,7 +1484,7 @@ static int aty128fb_set_par(struct fb_in
 		config |= 1;	/* make aperture do 16 bit swapping */
 #endif
 
-	aty_st_le32(CONFIG_CNTL, config);
+	aty_st_le32(CNFG_CNTL, config);
 	aty_st_8(CRTC_EXT_CNTL + 1, 0);	/* turn the video back on */
 
 	info->fix.line_length = (par->crtc.vxres * par->crtc.bpp) >> 3;
@@ -1875,7 +1875,7 @@ static int __devinit aty128_init(struct 
 	u32 dac;
 
 	/* Get the chip revision */
-	chip_rev = (aty_ld_le32(CONFIG_CNTL) >> 16) & 0x1F;
+	chip_rev = (aty_ld_le32(CNFG_CNTL) >> 16) & 0x1F;
 
 	strcpy(video_card, "Rage128 XX ");
 	video_card[8] = ent->device >> 8;
@@ -2057,7 +2057,7 @@ static int __devinit aty128_probe(struct
 
 	/* Grab memory size from the card */
 	// How does this relate to the resource length from the PCI hardware?
-	par->vram_size = aty_ld_le32(CONFIG_MEMSIZE) & 0x03FFFFFF;
+	par->vram_size = aty_ld_le32(CNFG_MEMSIZE) & 0x03FFFFFF;
 
 	/* Virtualize the framebuffer */
 	info->screen_base = ioremap(fb_addr, par->vram_size);
diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-config_-namespace-violations drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-config_-namespace-violations
+++ a/drivers/video/aty/atyfb_base.c
@@ -135,7 +135,7 @@
 #if defined(CONFIG_PM) || defined(CONFIG_PMAC_BACKLIGHT) || \
 defined (CONFIG_FB_ATY_GENERIC_LCD) || defined(CONFIG_FB_ATY_BACKLIGHT)
 static const u32 lt_lcd_regs[] = {
-	CONFIG_PANEL_LG,
+	CNFG_PANEL_LG,
 	LCD_GEN_CNTL_LG,
 	DSTN_CONTROL_LG,
 	HFB_PITCH_ADDR_LG,
@@ -446,7 +446,7 @@ static int __devinit correct_chipset(str
 	par->pll_limits.ecp_max = aty_chips[i].ecp_max;
 	par->features = aty_chips[i].features;
 
-	chip_id = aty_ld_le32(CONFIG_CHIP_ID, par);
+	chip_id = aty_ld_le32(CNFG_CHIP_ID, par);
 	type = chip_id & CFG_CHIP_TYPE;
 	rev = (chip_id & CFG_CHIP_REV) >> 24;
 
@@ -629,7 +629,7 @@ static void aty_get_crtc(const struct at
 		    crtc->lcd_index = aty_ld_le32(LCD_INDEX, par);
 		    aty_st_le32(LCD_INDEX, crtc->lcd_index, par);
 		}
-		crtc->lcd_config_panel = aty_ld_lcd(CONFIG_PANEL, par);
+		crtc->lcd_config_panel = aty_ld_lcd(CNFG_PANEL, par);
 		crtc->lcd_gen_cntl = aty_ld_lcd(LCD_GEN_CNTL, par);
 
 
@@ -676,7 +676,7 @@ static void aty_set_crtc(const struct at
 		aty_st_le32(CRTC_GEN_CNTL, crtc->gen_cntl & ~(CRTC_EXT_DISP_EN | CRTC_EN), par);
 
 		/* update non-shadow registers first */
-		aty_st_lcd(CONFIG_PANEL, crtc->lcd_config_panel, par);
+		aty_st_lcd(CNFG_PANEL, crtc->lcd_config_panel, par);
 		aty_st_lcd(LCD_GEN_CNTL, crtc->lcd_gen_cntl &
 			~(CRTC_RW_SELECT | SHADOW_EN | SHADOW_RW_EN), par);
 
@@ -858,7 +858,7 @@ static int aty_var_to_crtc(const struct 
 		if (!M64_HAS(MOBIL_BUS))
 			crtc->lcd_index |= CRTC2_DISPLAY_DIS;
 
-		crtc->lcd_config_panel = aty_ld_lcd(CONFIG_PANEL, par) | 0x4000;
+		crtc->lcd_config_panel = aty_ld_lcd(CNFG_PANEL, par) | 0x4000;
 		crtc->lcd_gen_cntl = aty_ld_lcd(LCD_GEN_CNTL, par) & ~CRTC_RW_SELECT;
 
 		crtc->lcd_gen_cntl &=
@@ -2254,7 +2254,7 @@ static int __devinit aty_init(struct fb_
 	if (!M64_HAS(INTEGRATED)) {
 		u32 stat0;
 		u8 dac_type, dac_subtype, clk_type;
-		stat0 = aty_ld_le32(CONFIG_STAT0, par);
+		stat0 = aty_ld_le32(CNFG_STAT0, par);
 		par->bus_type = (stat0 >> 0) & 0x07;
 		par->ram_type = (stat0 >> 3) & 0x07;
 		ramname = aty_gx_ram[par->ram_type];
@@ -2324,7 +2324,7 @@ static int __devinit aty_init(struct fb_
 		par->dac_ops = &aty_dac_ct;
 		par->pll_ops = &aty_pll_ct;
 		par->bus_type = PCI;
-		par->ram_type = (aty_ld_le32(CONFIG_STAT0, par) & 0x07);
+		par->ram_type = (aty_ld_le32(CNFG_STAT0, par) & 0x07);
 		ramname = aty_ct_ram[par->ram_type];
 		/* for many chips, the mclk is 67 MHz for SDRAM, 63 MHz otherwise */
 		if (par->pll_limits.mclk == 67 && par->ram_type < SDRAM)
@@ -2433,7 +2433,7 @@ static int __devinit aty_init(struct fb_
 		}
 
 	if (M64_HAS(MAGIC_VRAM_SIZE)) {
-		if (aty_ld_le32(CONFIG_STAT1, par) & 0x40000000)
+		if (aty_ld_le32(CNFG_STAT1, par) & 0x40000000)
 			info->fix.smem_len += 0x400000;
 	}
 
@@ -2946,7 +2946,7 @@ static int __devinit atyfb_setup_sparc(s
 		 * Fix PROMs idea of MEM_CNTL settings...
 		 */
 		mem = aty_ld_le32(MEM_CNTL, par);
-		chip_id = aty_ld_le32(CONFIG_CHIP_ID, par);
+		chip_id = aty_ld_le32(CNFG_CHIP_ID, par);
 		if (((chip_id & CFG_CHIP_TYPE) == VT_CHIP_ID) && !((chip_id >> 24) & 1)) {
 			switch (mem & 0x0f) {
 			case 3:
@@ -2964,7 +2964,7 @@ static int __devinit atyfb_setup_sparc(s
 			default:
 				break;
 			}
-			if ((aty_ld_le32(CONFIG_STAT0, par) & 7) >= SDRAM)
+			if ((aty_ld_le32(CNFG_STAT0, par) & 7) >= SDRAM)
 				mem &= ~(0x00700000);
 		}
 		mem &= ~(0xcf80e000);	/* Turn off all undocumented bits. */
@@ -3572,7 +3572,7 @@ static int __init atyfb_atari_probe(void
 		}
 
 		/* Fake pci_id for correct_chipset() */
-		switch (aty_ld_le32(CONFIG_CHIP_ID, par) & CFG_CHIP_TYPE) {
+		switch (aty_ld_le32(CNFG_CHIP_ID, par) & CFG_CHIP_TYPE) {
 		case 0x00d7:
 			par->pci_id = PCI_CHIP_MACH64GX;
 			break;
diff -puN drivers/video/aty/radeon_base.c~atyfb-fix-config_-namespace-violations drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~atyfb-fix-config_-namespace-violations
+++ a/drivers/video/aty/radeon_base.c
@@ -1936,8 +1936,8 @@ static void fixup_memory_mappings(struct
 	OUTREG(CRTC_GEN_CNTL, save_crtc_gen_cntl | CRTC_DISP_REQ_EN_B);
 	mdelay(100);
 
-	aper_base = INREG(CONFIG_APER_0_BASE);
-	aper_size = INREG(CONFIG_APER_SIZE);
+	aper_base = INREG(CNFG_APER_0_BASE);
+	aper_size = INREG(CNFG_APER_SIZE);
 
 #ifdef SET_MC_FB_FROM_APERTURE
 	/* Set framebuffer to be at the same address as set in PCI BAR */
@@ -2024,11 +2024,11 @@ static void radeon_identify_vram(struct 
                      ~CRTC_H_CUTOFF_ACTIVE_EN);
           }
         } else {
-          tmp = INREG(CONFIG_MEMSIZE);
+          tmp = INREG(CNFG_MEMSIZE);
         }
 
 	/* mem size is bits [28:0], mask off the rest */
-	rinfo->video_ram = tmp & CONFIG_MEMSIZE_MASK;
+	rinfo->video_ram = tmp & CNFG_MEMSIZE_MASK;
 
 	/*
 	 * Hack to get around some busted production M6's
@@ -2228,7 +2228,7 @@ static int __devinit radeonfb_pci_regist
 	 */
 	rinfo->errata = 0;
 	if (rinfo->family == CHIP_FAMILY_R300 &&
-	    (INREG(CONFIG_CNTL) & CFG_ATI_REV_ID_MASK)
+	    (INREG(CNFG_CNTL) & CFG_ATI_REV_ID_MASK)
 	    == CFG_ATI_REV_A11)
 		rinfo->errata |= CHIP_ERRATA_R300_CG;
 
diff -puN drivers/video/aty/radeon_pm.c~atyfb-fix-config_-namespace-violations drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~atyfb-fix-config_-namespace-violations
+++ a/drivers/video/aty/radeon_pm.c
@@ -333,7 +333,7 @@ static void radeon_pm_enable_dynamic_mod
 	if (!rinfo->has_CRTC2) {
                 tmp = INPLL(pllSCLK_CNTL);
 
-		if ((INREG(CONFIG_CNTL) & CFG_ATI_REV_ID_MASK) > CFG_ATI_REV_A13)
+		if ((INREG(CNFG_CNTL) & CFG_ATI_REV_ID_MASK) > CFG_ATI_REV_A13)
                     tmp &= ~(SCLK_CNTL__FORCE_CP	| SCLK_CNTL__FORCE_RB);
                 tmp &= ~(SCLK_CNTL__FORCE_HDP		| SCLK_CNTL__FORCE_DISP1 |
 			 SCLK_CNTL__FORCE_TOP		| SCLK_CNTL__FORCE_SE   |
@@ -468,9 +468,9 @@ static void radeon_pm_enable_dynamic_mod
 
 	/*RAGE_6::A11 A12 A12N1 A13, RV250::A11 A12, R300*/
 	if ((rinfo->family == CHIP_FAMILY_RV250 &&
-	     ((INREG(CONFIG_CNTL) & CFG_ATI_REV_ID_MASK) < CFG_ATI_REV_A13)) ||
+	     ((INREG(CNFG_CNTL) & CFG_ATI_REV_ID_MASK) < CFG_ATI_REV_A13)) ||
 	    ((rinfo->family == CHIP_FAMILY_RV100) &&
-	     ((INREG(CONFIG_CNTL) & CFG_ATI_REV_ID_MASK) <= CFG_ATI_REV_A13))) {
+	     ((INREG(CNFG_CNTL) & CFG_ATI_REV_ID_MASK) <= CFG_ATI_REV_A13))) {
 		tmp |= SCLK_CNTL__FORCE_CP;
 		tmp |= SCLK_CNTL__FORCE_VIP;
 	}
@@ -486,7 +486,7 @@ static void radeon_pm_enable_dynamic_mod
 		/* RV200::A11 A12 RV250::A11 A12 */
 		if (((rinfo->family == CHIP_FAMILY_RV200) ||
 		     (rinfo->family == CHIP_FAMILY_RV250)) &&
-		    ((INREG(CONFIG_CNTL) & CFG_ATI_REV_ID_MASK) < CFG_ATI_REV_A13))
+		    ((INREG(CNFG_CNTL) & CFG_ATI_REV_ID_MASK) < CFG_ATI_REV_A13))
 			tmp |= SCLK_MORE_CNTL__FORCEON;
 
 		OUTPLL(pllSCLK_MORE_CNTL, tmp);
@@ -497,7 +497,7 @@ static void radeon_pm_enable_dynamic_mod
 	/* RV200::A11 A12, RV250::A11 A12 */
 	if (((rinfo->family == CHIP_FAMILY_RV200) ||
 	     (rinfo->family == CHIP_FAMILY_RV250)) &&
-	    ((INREG(CONFIG_CNTL) & CFG_ATI_REV_ID_MASK) < CFG_ATI_REV_A13)) {
+	    ((INREG(CNFG_CNTL) & CFG_ATI_REV_ID_MASK) < CFG_ATI_REV_A13)) {
 		tmp = INPLL(pllPLL_PWRMGT_CNTL);
 		tmp |= PLL_PWRMGT_CNTL__TCL_BYPASS_DISABLE;
 		OUTPLL(pllPLL_PWRMGT_CNTL, tmp);
@@ -702,7 +702,7 @@ static void radeon_pm_restore_regs(struc
 	OUTREG(DISPLAY_BASE_ADDR, rinfo->save_regs[31]);
 	OUTREG(MC_AGP_LOCATION, rinfo->save_regs[32]);
 	OUTREG(CRTC2_DISPLAY_BASE_ADDR, rinfo->save_regs[33]);
-	OUTREG(CONFIG_MEMSIZE, rinfo->video_ram);
+	OUTREG(CNFG_MEMSIZE, rinfo->video_ram);
 
 	OUTREG(DISP_MISC_CNTL, rinfo->save_regs[9]);
 	OUTREG(DISP_PWR_MAN, rinfo->save_regs[10]);
@@ -1723,7 +1723,7 @@ static void radeon_reinitialize_M10(stru
 	OUTREG(CRTC2_DISPLAY_BASE_ADDR, rinfo->save_regs[33]);
 	OUTREG(MC_FB_LOCATION, rinfo->save_regs[30]);
 	OUTREG(OV0_BASE_ADDR, rinfo->save_regs[80]);
-	OUTREG(CONFIG_MEMSIZE, rinfo->video_ram);
+	OUTREG(CNFG_MEMSIZE, rinfo->video_ram);
 	OUTREG(BUS_CNTL, rinfo->save_regs[36]);
 	OUTREG(BUS_CNTL1, rinfo->save_regs[14]);
 	OUTREG(MPP_TB_CONFIG, rinfo->save_regs[37]);
@@ -1961,7 +1961,7 @@ static void radeon_pm_m9p_reconfigure_mc
 	OUTMC(rinfo, ixMC_CHP_IO_CNTL_B1, rinfo->save_regs[68] /*0x141555ff*/);
 	OUTMC(rinfo, ixMC_IMP_CNTL_0, rinfo->save_regs[71] /*0x00009249*/);
 	OUTREG(MC_IND_INDEX, 0);
-	OUTREG(CONFIG_MEMSIZE, rinfo->video_ram);
+	OUTREG(CNFG_MEMSIZE, rinfo->video_ram);
 
 	mdelay(20);
 }
@@ -2361,7 +2361,7 @@ static void radeon_reinitialize_QW(struc
 	OUTMC(rinfo, ixMC_IMP_CNTL_0, 0x00009249);
 	OUTREG(MC_IND_INDEX, 0);
 
-	OUTREG(CONFIG_MEMSIZE, rinfo->video_ram);
+	OUTREG(CNFG_MEMSIZE, rinfo->video_ram);
 
 	radeon_pm_full_reset_sdram(rinfo);
 
diff -puN include/video/aty128.h~atyfb-fix-config_-namespace-violations include/video/aty128.h
--- a/include/video/aty128.h~atyfb-fix-config_-namespace-violations
+++ a/include/video/aty128.h
@@ -21,9 +21,9 @@
 #define I2C_CNTL_1				0x0094
 #define PALETTE_INDEX				0x00b0
 #define PALETTE_DATA				0x00b4
-#define CONFIG_CNTL				0x00e0
+#define CNFG_CNTL				0x00e0
 #define GEN_RESET_CNTL				0x00f0
-#define CONFIG_MEMSIZE				0x00f8
+#define CNFG_MEMSIZE				0x00f8
 #define MEM_CNTL				0x0140
 #define MEM_POWER_MISC				0x015c
 #define AGP_BASE				0x0170
diff -puN include/video/mach64.h~atyfb-fix-config_-namespace-violations include/video/mach64.h
--- a/include/video/mach64.h~atyfb-fix-config_-namespace-violations
+++ a/include/video/mach64.h
@@ -103,7 +103,7 @@
 #define CUR_HORZ_VERT_OFF	0x0070	/* Dword offset 0_1C */
 #define CUR2_HORZ_VERT_OFF	0x0070	/* Dword offset 0_1C */
 
-#define CONFIG_PANEL_LG		0x0074	/* Dword offset 0_1D (LG) */
+#define CNFG_PANEL_LG		0x0074	/* Dword offset 0_1D (LG) */
 
 /* General I/O Control */
 #define GP_IO			0x0078	/* Dword offset 0_1E */
@@ -146,8 +146,8 @@
 #define CLOCK_SEL_CNTL		0x0090	/* Dword offset 0_24 */
 
 /* Configuration */
-#define CONFIG_STAT1		0x0094	/* Dword offset 0_25 */
-#define CONFIG_STAT2		0x0098	/* Dword offset 0_26 */
+#define CNFG_STAT1		0x0094	/* Dword offset 0_25 */
+#define CNFG_STAT2		0x0098	/* Dword offset 0_26 */
 
 /* Bus Control */
 #define BUS_CNTL		0x00A0	/* Dword offset 0_28 */
@@ -190,9 +190,9 @@
 #define POWER_MANAGEMENT_LG	0x00D8	/* Dword offset 0_36 (LG) */
 
 /* Configuration */
-#define CONFIG_CNTL		0x00DC	/* Dword offset 0_37 (CT, ET, VT) */
-#define CONFIG_CHIP_ID		0x00E0	/* Dword offset 0_38 */
-#define CONFIG_STAT0		0x00E4	/* Dword offset 0_39 */
+#define CNFG_CNTL		0x00DC	/* Dword offset 0_37 (CT, ET, VT) */
+#define CNFG_CHIP_ID		0x00E0	/* Dword offset 0_38 */
+#define CNFG_STAT0		0x00E4	/* Dword offset 0_39 */
 
 /* Test and Debug */
 #define CRC_SIG			0x00E8	/* Dword offset 0_3A */
@@ -851,17 +851,17 @@
 #define PLL_YCLK_CNTL		0x29
 #define PM_DYN_CLK_CNTL		0x2A
 
-/* CONFIG_CNTL register constants */
+/* CNFG_CNTL register constants */
 #define APERTURE_4M_ENABLE	1
 #define APERTURE_8M_ENABLE	2
 #define VGA_APERTURE_ENABLE	4
 
-/* CONFIG_STAT0 register constants (GX, CX) */
+/* CNFG_STAT0 register constants (GX, CX) */
 #define CFG_BUS_TYPE		0x00000007
 #define CFG_MEM_TYPE		0x00000038
 #define CFG_INIT_DAC_TYPE	0x00000e00
 
-/* CONFIG_STAT0 register constants (CT, ET, VT) */
+/* CNFG_STAT0 register constants (CT, ET, VT) */
 #define CFG_MEM_TYPE_xT		0x00000007
 
 #define ISA			0
@@ -942,7 +942,7 @@
 #define PCI_ATI_VENDOR_ID	0x1002
 
 
-/* CONFIG_CHIP_ID register constants */
+/* CNFG_CHIP_ID register constants */
 #define CFG_CHIP_TYPE		0x0000FFFF
 #define CFG_CHIP_CLASS		0x00FF0000
 #define CFG_CHIP_REV		0xFF000000
@@ -951,7 +951,7 @@
 #define CFG_CHIP_MINOR		0xC0000000
 
 
-/* Chip IDs read from CONFIG_CHIP_ID */
+/* Chip IDs read from CNFG_CHIP_ID */
 
 /* mach64GX family */
 #define GX_CHIP_ID	0xD7	/* mach64GX (ATI888GX00) */
@@ -1254,7 +1254,7 @@
 #define CRTC2_DISPLAY_DIS	0x00000400
 
 /* LCD register indices */
-#define CONFIG_PANEL		0x00
+#define CNFG_PANEL		0x00
 #define LCD_GEN_CNTL		0x01
 #define DSTN_CONTROL		0x02
 #define HFB_PITCH_ADDR		0x03
diff -puN include/video/radeon.h~atyfb-fix-config_-namespace-violations include/video/radeon.h
--- a/include/video/radeon.h~atyfb-fix-config_-namespace-violations
+++ a/include/video/radeon.h
@@ -11,13 +11,13 @@
 #define HI_STAT                                0x004C  
 #define BUS_CNTL1                              0x0034
 #define I2C_CNTL_1			       0x0094  
-#define CONFIG_CNTL                            0x00E0  
-#define CONFIG_MEMSIZE                         0x00F8  
-#define CONFIG_APER_0_BASE                     0x0100  
-#define CONFIG_APER_1_BASE                     0x0104  
-#define CONFIG_APER_SIZE                       0x0108  
-#define CONFIG_REG_1_BASE                      0x010C  
-#define CONFIG_REG_APER_SIZE                   0x0110  
+#define CNFG_CNTL                              0x00E0
+#define CNFG_MEMSIZE                           0x00F8
+#define CNFG_APER_0_BASE                       0x0100
+#define CNFG_APER_1_BASE                       0x0104
+#define CNFG_APER_SIZE                         0x0108
+#define CNFG_REG_1_BASE                        0x010C
+#define CNFG_REG_APER_SIZE                     0x0110
 #define PAD_AGPINPUT_DELAY                     0x0164  
 #define PAD_CTLR_STRENGTH                      0x0168  
 #define PAD_CTLR_UPDATE                        0x016C
@@ -509,7 +509,7 @@
 /* CLOCK_CNTL_INDEX bit constants */
 #define PLL_WR_EN                                  0x00000080
 
-/* CONFIG_CNTL bit constants */
+/* CNFG_CNTL bit constants */
 #define CFG_VGA_RAM_EN                             0x00000100
 #define CFG_ATI_REV_ID_MASK			   (0xf << 16)
 #define CFG_ATI_REV_A11				   (0 << 16)
@@ -980,7 +980,7 @@
 
 /* masks */
 
-#define CONFIG_MEMSIZE_MASK		0x1f000000
+#define CNFG_MEMSIZE_MASK		0x1f000000
 #define MEM_CFG_TYPE			0x40000000
 #define DST_OFFSET_MASK			0x003fffff
 #define DST_PITCH_MASK			0x3fc00000
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uv-fix-header-struct-usage.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch

