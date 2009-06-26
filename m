From: akpm@linux-foundation.org
Subject: + atyfb-fix-alignment-for-block-writes.patch added to -mm tree
Date: Fri, 26 Jun 2009 15:39:49 -0700
Message-ID: <200906262239.n5QMdnL3030857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbZFZWkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 18:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, krzysztof.h1@poczta.fm, mpatocka@redhat.com


The patch titled
     atyfb: fix alignment for block writes
has been added to the -mm tree.  Its filename is
     atyfb-fix-alignment-for-block-writes.patch

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
Subject: atyfb: fix alignment for block writes
From: Ville Syrjala <syrjala@sci.fi>

Block writes require 64 byte alignment.  Since block writes could be used
with SGRAM or WRAM also refine the memory type detection to check for
either type before deciding to use the 64 byte alignment.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Tested-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb.h        |    1 
 drivers/video/aty/atyfb_base.c   |   52 ++++++++++++++++++++++-------
 drivers/video/aty/mach64_accel.c |    7 ++-
 3 files changed, 46 insertions(+), 14 deletions(-)

diff -puN drivers/video/aty/atyfb.h~atyfb-fix-alignment-for-block-writes drivers/video/aty/atyfb.h
--- a/drivers/video/aty/atyfb.h~atyfb-fix-alignment-for-block-writes
+++ a/drivers/video/aty/atyfb.h
@@ -219,6 +219,7 @@ struct atyfb_par {
 #define M64F_XL_DLL		0x00080000
 #define M64F_MFB_FORCE_4	0x00100000
 #define M64F_HW_TRIPLE		0x00200000
+#define M64F_XL_MEM		0x00400000
     /*
      *  Register access
      */
diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-alignment-for-block-writes drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-alignment-for-block-writes
+++ a/drivers/video/aty/atyfb_base.c
@@ -363,8 +363,8 @@ static unsigned long phys_guiregbase[FB_
 #define ATI_CHIP_264GTPRO  (ATI_MODERN_SET | M64F_SDRAM_MAGIC_PLL | M64F_HW_TRIPLE | M64F_FIFO_32 | M64F_RESET_3D)
 #define ATI_CHIP_264LTPRO  (ATI_MODERN_SET | M64F_HW_TRIPLE | M64F_FIFO_32 | M64F_RESET_3D)
 
-#define ATI_CHIP_264XL     (ATI_MODERN_SET | M64F_HW_TRIPLE | M64F_FIFO_32 | M64F_RESET_3D | M64F_XL_DLL | M64F_MFB_FORCE_4)
-#define ATI_CHIP_MOBILITY  (ATI_MODERN_SET | M64F_HW_TRIPLE | M64F_FIFO_32 | M64F_RESET_3D | M64F_XL_DLL | M64F_MFB_FORCE_4 | M64F_MOBIL_BUS)
+#define ATI_CHIP_264XL     (ATI_MODERN_SET | M64F_HW_TRIPLE | M64F_FIFO_32 | M64F_RESET_3D | M64F_XL_DLL | M64F_MFB_FORCE_4 | M64F_XL_MEM)
+#define ATI_CHIP_MOBILITY  (ATI_MODERN_SET | M64F_HW_TRIPLE | M64F_FIFO_32 | M64F_RESET_3D | M64F_XL_DLL | M64F_MFB_FORCE_4 | M64F_XL_MEM | M64F_MOBIL_BUS)
 
 static struct {
 	u16 pci_id;
@@ -541,6 +541,7 @@ static char ram_edo[] __devinitdata = "E
 static char ram_sdram[] __devinitdata = "SDRAM (1:1)";
 static char ram_sgram[] __devinitdata = "SGRAM (1:1)";
 static char ram_sdram32[] __devinitdata = "SDRAM (2:1) (32-bit)";
+static char ram_wram[] __devinitdata = "WRAM";
 static char ram_off[] __devinitdata = "OFF";
 #endif /* CONFIG_FB_ATY_CT */
 
@@ -555,6 +556,10 @@ static char *aty_gx_ram[8] __devinitdata
 #ifdef CONFIG_FB_ATY_CT
 static char *aty_ct_ram[8] __devinitdata = {
 	ram_off, ram_dram, ram_edo, ram_edo,
+	ram_sdram, ram_sgram, ram_wram, ram_resv
+};
+static char *aty_xl_ram[8] __devinitdata = {
+	ram_off, ram_dram, ram_edo, ram_edo,
 	ram_sdram, ram_sgram, ram_sdram32, ram_resv
 };
 #endif /* CONFIG_FB_ATY_CT */
@@ -762,6 +767,17 @@ static void aty_set_crtc(const struct at
 #endif /* CONFIG_FB_ATY_GENERIC_LCD */
 }
 
+static u32 calc_line_length(struct atyfb_par *par, u32 vxres, u32 bpp)
+{
+	u32 line_length = vxres * bpp / 8;
+
+	if (par->ram_type == SGRAM ||
+	    (!M64_HAS(XL_MEM) && par->ram_type == WRAM))
+		line_length = (line_length + 63) & ~63;
+
+	return line_length;
+}
+
 static int aty_var_to_crtc(const struct fb_info *info,
 	const struct fb_var_screeninfo *var, struct crtc *crtc)
 {
@@ -771,13 +787,14 @@ static int aty_var_to_crtc(const struct 
 	u32 h_total, h_disp, h_sync_strt, h_sync_end, h_sync_dly, h_sync_wid, h_sync_pol;
 	u32 v_total, v_disp, v_sync_strt, v_sync_end, v_sync_wid, v_sync_pol, c_sync;
 	u32 pix_width, dp_pix_width, dp_chain_mask;
+	u32 line_length;
 
 	/* input */
-	xres = var->xres;
+	xres = (var->xres + 7) & ~7;
 	yres = var->yres;
-	vxres = var->xres_virtual;
+	vxres = (var->xres_virtual + 7) & ~7;
 	vyres = var->yres_virtual;
-	xoffset = var->xoffset;
+	xoffset = (var->xoffset + 7) & ~7;
 	yoffset = var->yoffset;
 	bpp = var->bits_per_pixel;
 	if (bpp == 16)
@@ -829,7 +846,9 @@ static int aty_var_to_crtc(const struct 
 	} else
 		FAIL("invalid bpp");
 
-	if (vxres * vyres * bpp / 8 > info->fix.smem_len)
+	line_length = calc_line_length(par, vxres, bpp);
+
+	if (vyres * line_length > info->fix.smem_len)
 		FAIL("not enough video RAM");
 
 	h_sync_pol = sync & FB_SYNC_HOR_HIGH_ACT ? 0 : 1;
@@ -971,7 +990,9 @@ static int aty_var_to_crtc(const struct 
 	crtc->xoffset = xoffset;
 	crtc->yoffset = yoffset;
 	crtc->bpp = bpp;
-	crtc->off_pitch = ((yoffset*vxres+xoffset)*bpp/64) | (vxres<<19);
+	crtc->off_pitch =
+		((yoffset * line_length + xoffset * bpp / 8) / 8) |
+		((line_length / bpp) << 22);
 	crtc->vline_crnt_vline = 0;
 
 	crtc->h_tot_disp = h_total | (h_disp<<16);
@@ -1396,7 +1417,9 @@ static int atyfb_set_par(struct fb_info 
 	}
 	aty_st_8(DAC_MASK, 0xff, par);
 
-	info->fix.line_length = var->xres_virtual * var->bits_per_pixel/8;
+	info->fix.line_length = calc_line_length(par, var->xres_virtual,
+						 var->bits_per_pixel);
+
 	info->fix.visual = var->bits_per_pixel <= 8 ?
 		FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_DIRECTCOLOR;
 
@@ -1507,10 +1530,12 @@ static void set_off_pitch(struct atyfb_p
 {
 	u32 xoffset = info->var.xoffset;
 	u32 yoffset = info->var.yoffset;
-	u32 vxres = par->crtc.vxres;
+	u32 line_length = info->fix.line_length;
 	u32 bpp = info->var.bits_per_pixel;
 
-	par->crtc.off_pitch = ((yoffset * vxres + xoffset) * bpp / 64) | (vxres << 19);
+	par->crtc.off_pitch =
+		((yoffset * line_length + xoffset * bpp / 8) / 8) |
+		((line_length / bpp) << 22);
 }
 
 
@@ -2203,7 +2228,7 @@ static void __devinit aty_calc_mem_refre
 	const int *refresh_tbl;
 	int i, size;
 
-	if (IS_XL(par->pci_id) || IS_MOBILITY(par->pci_id)) {
+	if (M64_HAS(XL_MEM)) {
 		refresh_tbl = ragexl_tbl;
 		size = ARRAY_SIZE(ragexl_tbl);
 	} else {
@@ -2337,7 +2362,10 @@ static int __devinit aty_init(struct fb_
 		par->pll_ops = &aty_pll_ct;
 		par->bus_type = PCI;
 		par->ram_type = (aty_ld_le32(CNFG_STAT0, par) & 0x07);
-		ramname = aty_ct_ram[par->ram_type];
+		if (M64_HAS(XL_MEM))
+			ramname = aty_xl_ram[par->ram_type];
+		else
+			ramname = aty_ct_ram[par->ram_type];
 		/* for many chips, the mclk is 67 MHz for SDRAM, 63 MHz otherwise */
 		if (par->pll_limits.mclk == 67 && par->ram_type < SDRAM)
 			par->pll_limits.mclk = 63;
diff -puN drivers/video/aty/mach64_accel.c~atyfb-fix-alignment-for-block-writes drivers/video/aty/mach64_accel.c
--- a/drivers/video/aty/mach64_accel.c~atyfb-fix-alignment-for-block-writes
+++ a/drivers/video/aty/mach64_accel.c
@@ -63,14 +63,17 @@ static void reset_GTC_3D_engine(const st
 void aty_init_engine(struct atyfb_par *par, struct fb_info *info)
 {
 	u32 pitch_value;
+	u32 vxres;
 
 	/* determine modal information from global mode structure */
-	pitch_value = info->var.xres_virtual;
+	pitch_value = info->fix.line_length / (info->var.bits_per_pixel / 8);
+	vxres = info->var.xres_virtual;
 
 	if (info->var.bits_per_pixel == 24) {
 		/* In 24 bpp, the engine is in 8 bpp - this requires that all */
 		/* horizontal coordinates and widths must be adjusted */
 		pitch_value *= 3;
+		vxres *= 3;
 	}
 
 	/* On GTC (RagePro), we need to reset the 3D engine before */
@@ -133,7 +136,7 @@ void aty_init_engine(struct atyfb_par *p
 	aty_st_le32(SC_LEFT, 0, par);
 	aty_st_le32(SC_TOP, 0, par);
 	aty_st_le32(SC_BOTTOM, par->crtc.vyres - 1, par);
-	aty_st_le32(SC_RIGHT, pitch_value - 1, par);
+	aty_st_le32(SC_RIGHT, vxres - 1, par);
 
 	/* set background color to minimum value (usually BLACK) */
 	aty_st_le32(DP_BKGD_CLR, 0, par);
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-fix-hp-omnibook-500-reboot-hang.patch
atyfb-fix-alignment-for-block-writes.patch
atyfb-coding-style-cleanup.patch
platinumfb-misplaced-parenthesis.patch

