From: akpm@linux-foundation.org
Subject: - lxfb-clean-up-register-definitions.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:51 -0700
Message-ID: <200804282158.m3SLwpQQ018523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965373AbYD1V7K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     lxfb: clean up register definitions
has been removed from the -mm tree.  Its filename was
     lxfb-clean-up-register-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: clean up register definitions
From: Andres Salomon <dilinger@queued.net>

 - Rename various bitfield defines to match the data sheet names.
 - Rename DF_ register definitions to VP_ to match the data sheet;
   ie, DF_PAR -> VP_PAR.
 - for GP/DC registers, rather than defining to specific addresses, use
   an enum to number them sequentially and just multiply by 4 (bytes) to
   access them (in read_*/write_* functions).
 - for VP/FP registers, use an enum and multiple by 8 (bytes).  They're
   64bit registers.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h      |  439 ++++++++++++++++++++----------
 drivers/video/geode/lxfb_core.c |    6 
 drivers/video/geode/lxfb_ops.c  |  164 +++++------
 3 files changed, 385 insertions(+), 224 deletions(-)

diff -puN drivers/video/geode/lxfb.h~lxfb-clean-up-register-definitions drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-clean-up-register-definitions
+++ a/drivers/video/geode/lxfb.h
@@ -54,181 +54,342 @@ void lx_set_palette_reg(struct fb_info *
 #define DC_SPARE_PIX8_PAN_FIX              0x00000010
 #define DC_SPARE_FIRST_REQ_MASK            0x00000002
 
-/* Registers */
 
-#define DC_UNLOCK         0x00
-#define  DC_UNLOCK_CODE   0x4758
+/* Graphics Processor registers (table 6-29 from the data book) */
+enum gp_registers {
+	GP_DST_OFFSET = 0,
+	GP_SRC_OFFSET,
+	GP_STRIDE,
+	GP_WID_HEIGHT,
+
+	GP_SRC_COLOR_FG,
+	GP_SRC_COLOR_BG,
+	GP_PAT_COLOR_0,
+	GP_PAT_COLOR_1,
+
+	GP_PAT_COLOR_2,
+	GP_PAT_COLOR_3,
+	GP_PAT_COLOR_4,
+	GP_PAT_COLOR_5,
+
+	GP_PAT_DATA_0,
+	GP_PAT_DATA_1,
+	GP_RASTER_MODE,
+	GP_VECTOR_MODE,
+
+	GP_BLT_MODE,
+	GP_BLT_STATUS,
+	GP_HST_SRC,
+	GP_BASE_OFFSET,
+
+	GP_CMD_TOP,
+	GP_CMD_BOT,
+	GP_CMD_READ,
+	GP_CMD_WRITE,
+
+	GP_CH3_OFFSET,
+	GP_CH3_MODE_STR,
+	GP_CH3_WIDHI,
+	GP_CH3_HSRC,
+
+	GP_LUT_INDEX,
+	GP_LUT_DATA,
+	GP_INT_CNTRL, /* 0x78 */
+};
+
+#define GP_BLT_STATUS_CE		(1 << 4)	/* cmd buf empty */
+#define GP_BLT_STATUS_PB		(1 << 0)	/* primative busy */
+
+
+/* Display Controller registers (table 6-47 from the data book) */
+enum dc_registers {
+	DC_UNLOCK = 0,
+	DC_GENERAL_CFG,
+	DC_DISPLAY_CFG,
+	DC_ARB_CFG,
+
+	DC_FB_ST_OFFSET,
+	DC_CB_ST_OFFSET,
+	DC_CURS_ST_OFFSET,
+	DC_RSVD_0,
+
+	DC_VID_Y_ST_OFFSET,
+	DC_VID_U_ST_OFFSET,
+	DC_VID_V_ST_OFFSET,
+	DC_DV_TOP,
+
+	DC_LINE_SIZE,
+	DC_GFX_PITCH,
+	DC_VID_YUV_PITCH,
+	DC_RSVD_1,
+
+	DC_H_ACTIVE_TIMING,
+	DC_H_BLANK_TIMING,
+	DC_H_SYNC_TIMING,
+	DC_RSVD_2,
+
+	DC_V_ACTIVE_TIMING,
+	DC_V_BLANK_TIMING,
+	DC_V_SYNC_TIMING,
+	DC_FB_ACTIVE,
+
+	DC_CURSOR_X,
+	DC_CURSOR_Y,
+	DC_RSVD_3,
+	DC_LINE_CNT,
+
+	DC_PAL_ADDRESS,
+	DC_PAL_DATA,
+	DC_DFIFO_DIAG,
+	DC_CFIFO_DIAG,
+
+	DC_VID_DS_DELTA,
+	DC_GLIU0_MEM_OFFSET,
+	DC_DV_CTL,
+	DC_DV_ACCESS,
+
+	DC_GFX_SCALE,
+	DC_IRQ_FILT_CTL,
+	DC_FILT_COEFF1,
+	DC_FILT_COEFF2,
+
+	DC_VBI_EVEN_CTL,
+	DC_VBI_ODD_CTL,
+	DC_VBI_HOR,
+	DC_VBI_LN_ODD,
+
+	DC_VBI_LN_EVEN,
+	DC_VBI_PITCH,
+	DC_CLR_KEY,
+	DC_CLR_KEY_MASK,
+
+	DC_CLR_KEY_X,
+	DC_CLR_KEY_Y,
+	DC_IRQ,
+	DC_RSVD_4,
+
+	DC_RSVD_5,
+	DC_GENLK_CTL,
+	DC_VID_EVEN_Y_ST_OFFSET,
+	DC_VID_EVEN_U_ST_OFFSET,
+
+	DC_VID_EVEN_V_ST_OFFSET,
+	DC_V_ACTIVE_EVEN_TIMING,
+	DC_V_BLANK_EVEN_TIMING,
+	DC_V_SYNC_EVEN_TIMING,	/* 0xec */
+};
+
+#define DC_UNLOCK_LOCK			0x00000000
+#define DC_UNLOCK_UNLOCK		0x00004758	/* magic value */
+
+#define DC_GENERAL_CFG_FDTY		(1 << 17)
+#define DC_GENERAL_CFG_DFHPEL_SHIFT	(12)
+#define DC_GENERAL_CFG_DFHPSL_SHIFT	(8)
+#define DC_GENERAL_CFG_VGAE		(1 << 7)
+#define DC_GENERAL_CFG_DECE		(1 << 6)
+#define DC_GENERAL_CFG_CMPE		(1 << 5)
+#define DC_GENERAL_CFG_VIDE		(1 << 3)
+#define DC_GENERAL_CFG_DFLE		(1 << 0)
+
+#define DC_DISPLAY_CFG_VISL		(1 << 27)
+#define DC_DISPLAY_CFG_PALB		(1 << 25)
+#define DC_DISPLAY_CFG_DCEN		(1 << 24)
+#define DC_DISPLAY_CFG_DISP_MODE_24BPP	(1 << 9)
+#define DC_DISPLAY_CFG_DISP_MODE_16BPP	(1 << 8)
+#define DC_DISPLAY_CFG_DISP_MODE_8BPP	(0)
+#define DC_DISPLAY_CFG_TRUP		(1 << 6)
+#define DC_DISPLAY_CFG_VDEN		(1 << 4)
+#define DC_DISPLAY_CFG_GDEN		(1 << 3)
+#define DC_DISPLAY_CFG_TGEN		(1 << 0)
+
+#define DC_DV_TOP_DV_TOP_EN		(1 << 0)
+
+#define DC_DV_CTL_DV_LINE_SIZE		((1 << 10) | (1 << 11))
+#define DC_DV_CTL_DV_LINE_SIZE_1K	(0)
+#define DC_DV_CTL_DV_LINE_SIZE_2K	(1 << 10)
+#define DC_DV_CTL_DV_LINE_SIZE_4K	(1 << 11)
+#define DC_DV_CTL_DV_LINE_SIZE_8K	((1 << 10) | (1 << 11))
+
+#define DC_CLR_KEY_CLR_KEY_EN		(1 << 24)
+
+#define DC_IRQ_VIP_VSYNC_IRQ_STATUS	(1 << 21)	/* undocumented? */
+#define DC_IRQ_STATUS			(1 << 20)	/* undocumented? */
+#define DC_IRQ_VIP_VSYNC_LOSS_IRQ_MASK	(1 << 1)
+#define DC_IRQ_MASK			(1 << 0)
+
+#define DC_GENLK_CTL_FLICK_SEL_MASK	(0x0F << 28)
+#define DC_GENLK_CTL_ALPHA_FLICK_EN	(1 << 25)
+#define DC_GENLK_CTL_FLICK_EN		(1 << 24)
+#define DC_GENLK_CTL_GENLK_EN		(1 << 18)
+
+
+/*
+ * Video Processor registers (table 6-71).
+ * There is space for 64 bit values, but we never use more than the
+ * lower 32 bits.  The actual register save/restore code only bothers
+ * to restore those 32 bits.
+ */
+enum vp_registers {
+	VP_VCFG = 0,
+	VP_DCFG,
+
+	VP_VX,
+	VP_VY,
+
+	VP_SCL,
+	VP_VCK,
+
+	VP_VCM,
+	VP_PAR,
+
+	VP_PDR,
+	VP_SLR,
+
+	VP_MISC,
+	VP_CCS,
+
+	VP_VYS,
+	VP_VXS,
+
+	VP_RSVD_0,
+	VP_VDC,
+
+	VP_RSVD_1,
+	VP_CRC,
+
+	VP_CRC32,
+	VP_VDE,
+
+	VP_CCK,
+	VP_CCM,
+
+	VP_CC1,
+	VP_CC2,
+
+	VP_A1X,
+	VP_A1Y,
+
+	VP_A1C,
+	VP_A1T,
+
+	VP_A2X,
+	VP_A2Y,
+
+	VP_A2C,
+	VP_A2T,
+
+	VP_A3X,
+	VP_A3Y,
+
+	VP_A3C,
+	VP_A3T,
+
+	VP_VRR,
+	VP_AWT,
+
+	VP_VTM,
+	VP_VYE,
+
+	VP_A1YE,
+	VP_A2YE,
+
+	VP_A3YE,	/* 0x150 */
+};
+
+#define VP_VCFG_VID_EN			(1 << 0)
+
+#define VP_DCFG_GV_GAM			(1 << 21)
+#define VP_DCFG_PWR_SEQ_DELAY		((1 << 17) | (1 << 18) | (1 << 19))
+#define VP_DCFG_PWR_SEQ_DELAY_DEFAULT	(1 << 19)	/* undocumented */
+#define VP_DCFG_CRT_SYNC_SKW		((1 << 14) | (1 << 15) | (1 << 16))
+#define VP_DCFG_CRT_SYNC_SKW_DEFAULT	(1 << 16)
+#define VP_DCFG_CRT_VSYNC_POL		(1 << 9)
+#define VP_DCFG_CRT_HSYNC_POL		(1 << 8)
+#define VP_DCFG_DAC_BL_EN		(1 << 3)
+#define VP_DCFG_VSYNC_EN		(1 << 2)
+#define VP_DCFG_HSYNC_EN		(1 << 1)
+#define VP_DCFG_CRT_EN			(1 << 0)
+
+#define VP_MISC_APWRDN			(1 << 11)
+#define VP_MISC_DACPWRDN		(1 << 10)
+#define VP_MISC_BYP_BOTH		(1 << 0)
+
+
+/*
+ * Flat Panel registers (table 6-71).
+ * Also 64 bit registers; see above note about 32-bit handling.
+ */
+
+/* we're actually in the VP register space, starting at address 0x400 */
+#define VP_FP_START	0x400
+
+enum fp_registers {
+	FP_PT1 = 0,
+	FP_PT2,
+
+	FP_PM,
+	FP_DFC,
+
+	FP_RSVD_0,
+	FP_RSVD_1,
+
+	FP_RSVD_2,
+	FP_RSVD_3,
+
+	FP_RSVD_4,
+	FP_DCA,
+
+	FP_DMD,
+	FP_CRC, /* 0x458 */
+};
 
-#define DC_GENERAL_CFG    0x04
-#define  DC_GCFG_DFLE     (1 << 0)
-#define  DC_GCFG_VIDE     (1 << 3)
-#define  DC_GCFG_VGAE     (1 << 7)
-#define  DC_GCFG_CMPE     (1 << 5)
-#define  DC_GCFG_DECE     (1 << 6)
-#define  DC_GCFG_FDTY     (1 << 17)
-
-#define DC_DISPLAY_CFG    0x08
-#define  DC_DCFG_TGEN     (1 << 0)
-#define  DC_DCFG_GDEN     (1 << 3)
-#define  DC_DCFG_VDEN     (1 << 4)
-#define  DC_DCFG_TRUP     (1 << 6)
-#define  DC_DCFG_DCEN     (1 << 24)
-#define  DC_DCFG_PALB     (1 << 25)
-#define  DC_DCFG_VISL     (1 << 27)
-
-#define  DC_DCFG_16BPP           0x0
-
-#define  DC_DCFG_DISP_MODE_MASK  0x00000300
-#define  DC_DCFG_DISP_MODE_8BPP  0x00000000
-#define  DC_DCFG_DISP_MODE_16BPP 0x00000100
-#define  DC_DCFG_DISP_MODE_24BPP 0x00000200
-#define  DC_DCFG_DISP_MODE_32BPP 0x00000300
-
-
-#define DC_ARB_CFG        0x0C
-
-#define DC_FB_START       0x10
-#define DC_CB_START       0x14
-#define DC_CURSOR_START   0x18
-
-#define DC_DV_TOP          0x2C
-#define DC_DV_TOP_ENABLE   (1 << 0)
-
-#define DC_LINE_SIZE       0x30
-#define DC_GRAPHICS_PITCH  0x34
-#define DC_H_ACTIVE_TIMING 0x40
-#define DC_H_BLANK_TIMING  0x44
-#define DC_H_SYNC_TIMING   0x48
-#define DC_V_ACTIVE_TIMING 0x50
-#define DC_V_BLANK_TIMING  0x54
-#define DC_V_SYNC_TIMING   0x58
-#define DC_FB_ACTIVE       0x5C
-
-#define DC_PAL_ADDRESS     0x70
-#define DC_PAL_DATA        0x74
-
-#define DC_PHY_MEM_OFFSET  0x84
-
-#define DC_DV_CTL          0x88
-#define DC_DV_LINE_SIZE_MASK               0x00000C00
-#define DC_DV_LINE_SIZE_1024               0x00000000
-#define DC_DV_LINE_SIZE_2048               0x00000400
-#define DC_DV_LINE_SIZE_4096               0x00000800
-#define DC_DV_LINE_SIZE_8192               0x00000C00
-
-
-#define DC_GFX_SCALE       0x90
-#define DC_IRQ_FILT_CTL    0x94
-
-
-#define DC_IRQ               0xC8
-#define  DC_IRQ_MASK         (1 << 0)
-#define  DC_VSYNC_IRQ_MASK   (1 << 1)
-#define  DC_IRQ_STATUS       (1 << 20)
-#define  DC_VSYNC_IRQ_STATUS (1 << 21)
-
-#define DC_GENLCK_CTRL      0xD4
-#define  DC_GENLCK_ENABLE   (1 << 18)
-#define  DC_GC_ALPHA_FLICK_ENABLE  (1 << 25)
-#define  DC_GC_FLICKER_FILTER_ENABLE (1 << 24)
-#define  DC_GC_FLICKER_FILTER_MASK (0x0F << 28)
-
-#define DC_COLOR_KEY       0xB8
-#define DC_CLR_KEY_ENABLE (1 << 24)
-
-
-#define DC3_DV_LINE_SIZE_MASK               0x00000C00
-#define DC3_DV_LINE_SIZE_1024               0x00000000
-#define DC3_DV_LINE_SIZE_2048               0x00000400
-#define DC3_DV_LINE_SIZE_4096               0x00000800
-#define DC3_DV_LINE_SIZE_8192               0x00000C00
-
-#define DF_VIDEO_CFG       0x0
-#define  DF_VCFG_VID_EN    (1 << 0)
-
-#define DF_DISPLAY_CFG     0x08
-
-#define DF_DCFG_CRT_EN     (1 << 0)
-#define DF_DCFG_HSYNC_EN   (1 << 1)
-#define DF_DCFG_VSYNC_EN   (1 << 2)
-#define DF_DCFG_DAC_BL_EN  (1 << 3)
-#define DF_DCFG_CRT_HSYNC_POL  (1 << 8)
-#define DF_DCFG_CRT_VSYNC_POL  (1 << 9)
-#define DF_DCFG_GV_PAL_BYP     (1 << 21)
-
-#define DF_DCFG_CRT_SYNC_SKW_INIT 0x10000
-#define DF_DCFG_CRT_SYNC_SKW_MASK  0x1c000
-
-#define DF_DCFG_PWR_SEQ_DLY_INIT     0x80000
-#define DF_DCFG_PWR_SEQ_DLY_MASK     0xe0000
-
-#define DF_MISC            0x50
-
-#define  DF_MISC_GAM_BYPASS (1 << 0)
-#define  DF_MISC_DAC_PWRDN  (1 << 10)
-#define  DF_MISC_A_PWRDN    (1 << 11)
-
-#define DF_PAR             0x38
-#define DF_PDR             0x40
-#define DF_ALPHA_CONTROL_1 0xD8
-#define DF_VIDEO_REQUEST   0x120
-
-#define DF_PANEL_TIM1      0x400
-#define DF_DEFAULT_TFT_PMTIM1 0x0
-
-#define DF_PANEL_TIM2      0x408
-#define DF_DEFAULT_TFT_PMTIM2 0x08000000
-
-#define DF_FP_PM             0x410
-#define  DF_FP_PM_P          (1 << 24)
-
-#define DF_DITHER_CONTROL    0x418
-#define DF_DEFAULT_TFT_DITHCTL                  0x00000070
-#define GP_BLT_STATUS      0x44
-#define  GP_BS_BLT_BUSY    (1 << 0)
-#define  GP_BS_CB_EMPTY    (1 << 4)
+#define FP_PT2_SCRC			(1 << 27)	/* shfclk free */
+
+#define FP_PM_P				(1 << 24)	/* panel power ctl */
+
+#define FP_DFC_BC			((1 << 4) | (1 << 5) | (1 << 6))
 
 
 /* register access functions */
 
 static inline uint32_t read_gp(struct lxfb_par *par, int reg)
 {
-	return readl(par->gp_regs + reg);
+	return readl(par->gp_regs + 4*reg);
 }
 
 static inline void write_gp(struct lxfb_par *par, int reg, uint32_t val)
 {
-	writel(val, par->gp_regs + reg);
+	writel(val, par->gp_regs + 4*reg);
 }
 
 static inline uint32_t read_dc(struct lxfb_par *par, int reg)
 {
-	return readl(par->dc_regs + reg);
+	return readl(par->dc_regs + 4*reg);
 }
 
 static inline void write_dc(struct lxfb_par *par, int reg, uint32_t val)
 {
-	writel(val, par->dc_regs + reg);
+	writel(val, par->dc_regs + 4*reg);
 }
 
 static inline uint32_t read_vp(struct lxfb_par *par, int reg)
 {
-	return readl(par->df_regs + reg);
+	return readl(par->df_regs + 8*reg);
 }
 
 static inline void write_vp(struct lxfb_par *par, int reg, uint32_t val)
 {
-	writel(val, par->df_regs + reg);
+	writel(val, par->df_regs + 8*reg);
 }
 
 static inline uint32_t read_fp(struct lxfb_par *par, int reg)
 {
-	return readl(par->df_regs + reg);
+	return readl(par->df_regs + 8*reg + VP_FP_START);
 }
 
 static inline void write_fp(struct lxfb_par *par, int reg, uint32_t val)
 {
-	writel(val, par->df_regs + reg);
+	writel(val, par->df_regs + 8*reg + VP_FP_START);
 }
 
 #endif
diff -puN drivers/video/geode/lxfb_core.c~lxfb-clean-up-register-definitions drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-clean-up-register-definitions
+++ a/drivers/video/geode/lxfb_core.c
@@ -366,9 +366,9 @@ static int __init lxfb_map_video_memory(
 	if (par->df_regs == NULL)
 		return ret;
 
-	write_dc(par, DC_UNLOCK, DC_UNLOCK_CODE);
-	write_dc(par, DC_PHY_MEM_OFFSET, info->fix.smem_start & 0xFF000000);
-	write_dc(par, DC_UNLOCK, 0);
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
+	write_dc(par, DC_GLIU0_MEM_OFFSET, info->fix.smem_start & 0xFF000000);
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_LOCK);
 
 	dev_info(&dev->dev, "%d KB of video memory at 0x%lx\n",
 		 info->fix.smem_len / 1024, info->fix.smem_start);
diff -puN drivers/video/geode/lxfb_ops.c~lxfb-clean-up-register-definitions drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~lxfb-clean-up-register-definitions
+++ a/drivers/video/geode/lxfb_ops.c
@@ -210,47 +210,47 @@ static void lx_graphics_disable(struct f
 
 	/* Note:  This assumes that the video is in a quitet state */
 
-	write_vp(par, DF_ALPHA_CONTROL_1, 0);
-	write_vp(par, DF_ALPHA_CONTROL_1 + 32, 0);
-	write_vp(par, DF_ALPHA_CONTROL_1 + 64, 0);
+	write_vp(par, VP_A1T, 0);
+	write_vp(par, VP_A2T, 0);
+	write_vp(par, VP_A3T, 0);
 
 	/* Turn off the VGA and video enable */
-	val = read_dc(par, DC_GENERAL_CFG) & ~(DC_GCFG_VGAE | DC_GCFG_VIDE);
+	val = read_dc(par, DC_GENERAL_CFG) & ~(DC_GENERAL_CFG_VGAE |
+			DC_GENERAL_CFG_VIDE);
 
 	write_dc(par, DC_GENERAL_CFG, val);
 
-	val = read_vp(par, DF_VIDEO_CFG) & ~DF_VCFG_VID_EN;
-	write_vp(par, DF_VIDEO_CFG, val);
+	val = read_vp(par, VP_VCFG) & ~VP_VCFG_VID_EN;
+	write_vp(par, VP_VCFG, val);
 
-	write_dc(par, DC_IRQ, DC_IRQ_MASK | DC_VSYNC_IRQ_MASK | DC_IRQ_STATUS |
-			DC_VSYNC_IRQ_STATUS);
+	write_dc(par, DC_IRQ, DC_IRQ_MASK | DC_IRQ_VIP_VSYNC_LOSS_IRQ_MASK |
+			DC_IRQ_STATUS | DC_IRQ_VIP_VSYNC_IRQ_STATUS);
 
-	val = read_dc(par, DC_GENLCK_CTRL) & ~DC_GENLCK_ENABLE;
-	write_dc(par, DC_GENLCK_CTRL, val);
+	val = read_dc(par, DC_GENLK_CTL) & ~DC_GENLK_CTL_GENLK_EN;
+	write_dc(par, DC_GENLK_CTL, val);
 
-	val = read_dc(par, DC_COLOR_KEY) & ~DC_CLR_KEY_ENABLE;
-	write_dc(par, DC_COLOR_KEY, val & ~DC_CLR_KEY_ENABLE);
+	val = read_dc(par, DC_CLR_KEY);
+	write_dc(par, DC_CLR_KEY, val & ~DC_CLR_KEY_CLR_KEY_EN);
 
 	/* We don't actually blank the panel, due to the long latency
 	   involved with bringing it back */
 
-	val = read_vp(par, DF_MISC) | DF_MISC_DAC_PWRDN;
-	write_vp(par, DF_MISC, val);
+	val = read_vp(par, VP_MISC) | VP_MISC_DACPWRDN;
+	write_vp(par, VP_MISC, val);
 
 	/* Turn off the display */
 
-	val = read_vp(par, DF_DISPLAY_CFG);
-	write_vp(par, DF_DISPLAY_CFG, val &
-			~(DF_DCFG_CRT_EN | DF_DCFG_HSYNC_EN |
-			DF_DCFG_VSYNC_EN | DF_DCFG_DAC_BL_EN));
+	val = read_vp(par, VP_DCFG);
+	write_vp(par, VP_DCFG, val & ~(VP_DCFG_CRT_EN | VP_DCFG_HSYNC_EN |
+			VP_DCFG_VSYNC_EN | VP_DCFG_DAC_BL_EN));
 
 	gcfg = read_dc(par, DC_GENERAL_CFG);
-	gcfg &= ~(DC_GCFG_CMPE | DC_GCFG_DECE);
+	gcfg &= ~(DC_GENERAL_CFG_CMPE | DC_GENERAL_CFG_DECE);
 	write_dc(par, DC_GENERAL_CFG, gcfg);
 
 	/* Turn off the TGEN */
 	val = read_dc(par, DC_DISPLAY_CFG);
-	val &= ~DC_DCFG_TGEN;
+	val &= ~DC_DISPLAY_CFG_TGEN;
 	write_dc(par, DC_DISPLAY_CFG, val);
 
 	/* Wait 1000 usecs to ensure that the TGEN is clear */
@@ -258,14 +258,14 @@ static void lx_graphics_disable(struct f
 
 	/* Turn off the FIFO loader */
 
-	gcfg &= ~DC_GCFG_DFLE;
+	gcfg &= ~DC_GENERAL_CFG_DFLE;
 	write_dc(par, DC_GENERAL_CFG, gcfg);
 
 	/* Lastly, wait for the GP to go idle */
 
 	do {
 		val = read_gp(par, GP_BLT_STATUS);
-	} while ((val & GP_BS_BLT_BUSY) || !(val & GP_BS_CB_EMPTY));
+	} while ((val & GP_BLT_STATUS_PB) || !(val & GP_BLT_STATUS_CE));
 }
 
 static void lx_graphics_enable(struct fb_info *info)
@@ -274,30 +274,30 @@ static void lx_graphics_enable(struct fb
 	u32 temp, config;
 
 	/* Set the video request register */
-	write_vp(par, DF_VIDEO_REQUEST, 0);
+	write_vp(par, VP_VRR, 0);
 
 	/* Set up the polarities */
 
-	config = read_vp(par, DF_DISPLAY_CFG);
+	config = read_vp(par, VP_DCFG);
 
-	config &= ~(DF_DCFG_CRT_SYNC_SKW_MASK | DF_DCFG_PWR_SEQ_DLY_MASK |
-		  DF_DCFG_CRT_HSYNC_POL     | DF_DCFG_CRT_VSYNC_POL);
+	config &= ~(VP_DCFG_CRT_SYNC_SKW | VP_DCFG_PWR_SEQ_DELAY |
+			VP_DCFG_CRT_HSYNC_POL | VP_DCFG_CRT_VSYNC_POL);
 
-	config |= (DF_DCFG_CRT_SYNC_SKW_INIT | DF_DCFG_PWR_SEQ_DLY_INIT  |
-		   DF_DCFG_GV_PAL_BYP);
+	config |= (VP_DCFG_CRT_SYNC_SKW_DEFAULT | VP_DCFG_PWR_SEQ_DELAY_DEFAULT
+			| VP_DCFG_GV_GAM);
 
 	if (info->var.sync & FB_SYNC_HOR_HIGH_ACT)
-		config |= DF_DCFG_CRT_HSYNC_POL;
+		config |= VP_DCFG_CRT_HSYNC_POL;
 
 	if (info->var.sync & FB_SYNC_VERT_HIGH_ACT)
-		config |= DF_DCFG_CRT_VSYNC_POL;
+		config |= VP_DCFG_CRT_VSYNC_POL;
 
 	if (par->output & OUTPUT_PANEL) {
 		u32 msrlo, msrhi;
 
-		write_fp(par, DF_PANEL_TIM1, DF_DEFAULT_TFT_PMTIM1);
-		write_fp(par, DF_PANEL_TIM2, DF_DEFAULT_TFT_PMTIM2);
-		write_fp(par, DF_DITHER_CONTROL, DF_DEFAULT_TFT_DITHCTL);
+		write_fp(par, FP_PT1, 0);
+		write_fp(par, FP_PT2, FP_PT2_SCRC);
+		write_fp(par, FP_DFC, FP_DFC_BC);
 
 		msrlo = DF_DEFAULT_TFT_PAD_SEL_LOW;
 		msrhi = DF_DEFAULT_TFT_PAD_SEL_HIGH;
@@ -306,27 +306,27 @@ static void lx_graphics_enable(struct fb
 	}
 
 	if (par->output & OUTPUT_CRT) {
-		config |= DF_DCFG_CRT_EN   | DF_DCFG_HSYNC_EN |
-			DF_DCFG_VSYNC_EN | DF_DCFG_DAC_BL_EN;
+		config |= VP_DCFG_CRT_EN | VP_DCFG_HSYNC_EN |
+				VP_DCFG_VSYNC_EN | VP_DCFG_DAC_BL_EN;
 	}
 
-	write_vp(par, DF_DISPLAY_CFG, config);
+	write_vp(par, VP_DCFG, config);
 
 	/* Turn the CRT dacs back on */
 
 	if (par->output & OUTPUT_CRT) {
-		temp = read_vp(par, DF_MISC);
-		temp &= ~(DF_MISC_DAC_PWRDN  | DF_MISC_A_PWRDN);
-		write_vp(par, DF_MISC, temp);
+		temp = read_vp(par, VP_MISC);
+		temp &= ~(VP_MISC_DACPWRDN | VP_MISC_APWRDN);
+		write_vp(par, VP_MISC, temp);
 	}
 
 	/* Turn the panel on (if it isn't already) */
 
 	if (par->output & OUTPUT_PANEL) {
-		temp = read_fp(par, DF_FP_PM);
+		temp = read_fp(par, FP_PM);
 
 		if (!(temp & 0x09))
-			write_fp(par, DF_FP_PM, temp | DF_FP_PM_P);
+			write_fp(par, FP_PM, temp | FP_PM_P);
 	}
 }
 
@@ -357,7 +357,7 @@ void lx_set_mode(struct fb_info *info)
 	int vactive, vblankstart, vsyncstart, vsyncend, vblankend, vtotal;
 
 	/* Unlock the DC registers */
-	write_dc(par, DC_UNLOCK, DC_UNLOCK_CODE);
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
 
 	lx_graphics_disable(info);
 
@@ -384,45 +384,45 @@ void lx_set_mode(struct fb_info *info)
 	/* Clear the various buffers */
 	/* FIXME:  Adjust for panning here */
 
-	write_dc(par, DC_FB_START, 0);
-	write_dc(par, DC_CB_START, 0);
-	write_dc(par, DC_CURSOR_START, 0);
+	write_dc(par, DC_FB_ST_OFFSET, 0);
+	write_dc(par, DC_CB_ST_OFFSET, 0);
+	write_dc(par, DC_CURS_ST_OFFSET, 0);
 
 	/* FIXME: Add support for interlacing */
 	/* FIXME: Add support for scaling */
 
-	val = read_dc(par, DC_GENLCK_CTRL);
-	val &= ~(DC_GC_ALPHA_FLICK_ENABLE |
-		 DC_GC_FLICKER_FILTER_ENABLE | DC_GC_FLICKER_FILTER_MASK);
+	val = read_dc(par, DC_GENLK_CTL);
+	val &= ~(DC_GENLK_CTL_ALPHA_FLICK_EN | DC_GENLK_CTL_FLICK_EN |
+			DC_GENLK_CTL_FLICK_SEL_MASK);
 
 	/* Default scaling params */
 
 	write_dc(par, DC_GFX_SCALE, (0x4000 << 16) | 0x4000);
 	write_dc(par, DC_IRQ_FILT_CTL, 0);
-	write_dc(par, DC_GENLCK_CTRL, val);
+	write_dc(par, DC_GENLK_CTL, val);
 
 	/* FIXME:  Support compression */
 
 	if (info->fix.line_length > 4096)
-		dv = DC_DV_LINE_SIZE_8192;
+		dv = DC_DV_CTL_DV_LINE_SIZE_8K;
 	else if (info->fix.line_length > 2048)
-		dv = DC_DV_LINE_SIZE_4096;
+		dv = DC_DV_CTL_DV_LINE_SIZE_4K;
 	else if (info->fix.line_length > 1024)
-		dv = DC_DV_LINE_SIZE_2048;
+		dv = DC_DV_CTL_DV_LINE_SIZE_2K;
 	else
-		dv = DC_DV_LINE_SIZE_1024;
+		dv = DC_DV_CTL_DV_LINE_SIZE_1K;
 
 	max = info->fix.line_length * info->var.yres;
 	max = (max + 0x3FF) & 0xFFFFFC00;
 
-	write_dc(par, DC_DV_TOP, max | DC_DV_TOP_ENABLE);
+	write_dc(par, DC_DV_TOP, max | DC_DV_TOP_DV_TOP_EN);
 
-	val = read_dc(par, DC_DV_CTL) & ~DC_DV_LINE_SIZE_MASK;
+	val = read_dc(par, DC_DV_CTL) & ~DC_DV_CTL_DV_LINE_SIZE;
 	write_dc(par, DC_DV_CTL, val | dv);
 
 	size = info->var.xres * (info->var.bits_per_pixel >> 3);
 
-	write_dc(par, DC_GRAPHICS_PITCH, info->fix.line_length >> 3);
+	write_dc(par, DC_GFX_PITCH, info->fix.line_length >> 3);
 	write_dc(par, DC_LINE_SIZE, (size + 7) >> 3);
 
 	/* Set default watermark values */
@@ -435,32 +435,33 @@ void lx_set_mode(struct fb_info *info)
 	msrval |= DC_SPARE_DISABLE_VFIFO_WM | DC_SPARE_DISABLE_INIT_VID_PRI;
 	wrmsrl(MSR_LX_SPARE_MSR, msrval);
 
-	gcfg = DC_GCFG_DFLE;   /* Display fifo enable */
-	gcfg |= 0xB600;         /* Set default priority */
-	gcfg |= DC_GCFG_FDTY;  /* Set the frame dirty mode */
-
-	dcfg  = DC_DCFG_VDEN;  /* Enable video data */
-	dcfg |= DC_DCFG_GDEN;  /* Enable graphics */
-	dcfg |= DC_DCFG_TGEN;  /* Turn on the timing generator */
-	dcfg |= DC_DCFG_TRUP;  /* Update timings immediately */
-	dcfg |= DC_DCFG_PALB;  /* Palette bypass in > 8 bpp modes */
-	dcfg |= DC_DCFG_VISL;
-	dcfg |= DC_DCFG_DCEN;  /* Always center the display */
+	gcfg = DC_GENERAL_CFG_DFLE;   /* Display fifo enable */
+	gcfg |= (0x6 << DC_GENERAL_CFG_DFHPSL_SHIFT) | /* default priority */
+			(0xb << DC_GENERAL_CFG_DFHPEL_SHIFT);
+	gcfg |= DC_GENERAL_CFG_FDTY;  /* Set the frame dirty mode */
+
+	dcfg  = DC_DISPLAY_CFG_VDEN;  /* Enable video data */
+	dcfg |= DC_DISPLAY_CFG_GDEN;  /* Enable graphics */
+	dcfg |= DC_DISPLAY_CFG_TGEN;  /* Turn on the timing generator */
+	dcfg |= DC_DISPLAY_CFG_TRUP;  /* Update timings immediately */
+	dcfg |= DC_DISPLAY_CFG_PALB;  /* Palette bypass in > 8 bpp modes */
+	dcfg |= DC_DISPLAY_CFG_VISL;
+	dcfg |= DC_DISPLAY_CFG_DCEN;  /* Always center the display */
 
 	/* Set the current BPP mode */
 
 	switch (info->var.bits_per_pixel) {
 	case 8:
-		dcfg |= DC_DCFG_DISP_MODE_8BPP;
+		dcfg |= DC_DISPLAY_CFG_DISP_MODE_8BPP;
 		break;
 
 	case 16:
-		dcfg |= DC_DCFG_DISP_MODE_16BPP | DC_DCFG_16BPP;
+		dcfg |= DC_DISPLAY_CFG_DISP_MODE_16BPP;
 		break;
 
 	case 32:
 	case 24:
-		dcfg |= DC_DCFG_DISP_MODE_24BPP;
+		dcfg |= DC_DISPLAY_CFG_DISP_MODE_24BPP;
 		break;
 	}
 
@@ -504,7 +505,7 @@ void lx_set_mode(struct fb_info *info)
 	write_dc(par, DC_GENERAL_CFG, gcfg);
 
 	/* Lock the DC registers */
-	write_dc(par, DC_UNLOCK, 0);
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_LOCK);
 }
 
 void lx_set_palette_reg(struct fb_info *info, unsigned regno,
@@ -550,26 +551,25 @@ int lx_blank_display(struct fb_info *inf
 		return -EINVAL;
 	}
 
-	dcfg = read_vp(par, DF_DISPLAY_CFG);
-	dcfg &= ~(DF_DCFG_DAC_BL_EN
-		  | DF_DCFG_HSYNC_EN | DF_DCFG_VSYNC_EN);
+	dcfg = read_vp(par, VP_DCFG);
+	dcfg &= ~(VP_DCFG_DAC_BL_EN | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN);
 	if (!blank)
-		dcfg |= DF_DCFG_DAC_BL_EN;
+		dcfg |= VP_DCFG_DAC_BL_EN;
 	if (hsync)
-		dcfg |= DF_DCFG_HSYNC_EN;
+		dcfg |= VP_DCFG_HSYNC_EN;
 	if (vsync)
-		dcfg |= DF_DCFG_VSYNC_EN;
-	write_vp(par, DF_DISPLAY_CFG, dcfg);
+		dcfg |= VP_DCFG_VSYNC_EN;
+	write_vp(par, VP_DCFG, dcfg);
 
 	/* Power on/off flat panel */
 
 	if (par->output & OUTPUT_PANEL) {
-		fp_pm = read_fp(par, DF_FP_PM);
+		fp_pm = read_fp(par, FP_PM);
 		if (blank_mode == FB_BLANK_POWERDOWN)
-			fp_pm &= ~DF_FP_PM_P;
+			fp_pm &= ~FP_PM_P;
 		else
-			fp_pm |= DF_FP_PM_P;
-		write_fp(par, DF_FP_PM, fp_pm);
+			fp_pm |= FP_PM_P;
+		write_fp(par, FP_PM, fp_pm);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

