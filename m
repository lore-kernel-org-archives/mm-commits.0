From: akpm@linux-foundation.org
Subject: + drivers-video-mmp-remove-legacy-hw-definitions.patch added to -mm tree
Date: Fri, 22 Mar 2013 12:36:12 -0700
Message-ID: <20130322193612.7935A5A4D85@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:38188 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3CVTgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 15:36:14 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so119960qeb.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 12:36:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zzhu3@marvell.com, FlorianSchandinat@gmx.de, cldu@marvell.com, ligq@marvell.com, pebolle@tiscali.nl


The patch titled
     Subject: drivers/video/mmp: remove legacy hw definitions
has been added to the -mm tree.  Its filename is
     drivers-video-mmp-remove-legacy-hw-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhou Zhu <zzhu3@marvell.com>
Subject: drivers/video/mmp: remove legacy hw definitions

Removed legacy hw definitions in hw/mmp_ctrl.h.  These definitions are for
earlier soc versions and are not supported in this driver.

Signed-off-by: Zhou Zhu <zzhu3@marvell.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Lisa Du <cldu@marvell.com>
Cc: Guoqing Li <ligq@marvell.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mmp/hw/mmp_ctrl.h |  479 ------------------------------
 1 file changed, 1 insertion(+), 478 deletions(-)

diff -puN drivers/video/mmp/hw/mmp_ctrl.h~drivers-video-mmp-remove-legacy-hw-definitions drivers/video/mmp/hw/mmp_ctrl.h
--- a/drivers/video/mmp/hw/mmp_ctrl.h~drivers-video-mmp-remove-legacy-hw-definitions
+++ a/drivers/video/mmp/hw/mmp_ctrl.h
@@ -961,56 +961,7 @@ struct lcd_regs {
 	LCD_TVG_CUTVLN : PN2_LCD_GRA_CUTVLN) : LCD_GRA_CUTVLN)
 
 /*
- * defined Video Memory Color format for DMA control 0 register
- * DMA0 bit[23:20]
- */
-#define VMODE_RGB565		0x0
-#define VMODE_RGB1555		0x1
-#define VMODE_RGB888PACKED	0x2
-#define VMODE_RGB888UNPACKED	0x3
-#define VMODE_RGBA888		0x4
-#define VMODE_YUV422PACKED	0x5
-#define VMODE_YUV422PLANAR	0x6
-#define VMODE_YUV420PLANAR	0x7
-#define VMODE_SMPNCMD		0x8
-#define VMODE_PALETTE4BIT	0x9
-#define VMODE_PALETTE8BIT	0xa
-#define VMODE_RESERVED		0xb
-
-/*
- * defined Graphic Memory Color format for DMA control 0 register
- * DMA0 bit[19:16]
- */
-#define GMODE_RGB565		0x0
-#define GMODE_RGB1555		0x1
-#define GMODE_RGB888PACKED	0x2
-#define GMODE_RGB888UNPACKED	0x3
-#define GMODE_RGBA888		0x4
-#define GMODE_YUV422PACKED	0x5
-#define GMODE_YUV422PLANAR	0x6
-#define GMODE_YUV420PLANAR	0x7
-#define GMODE_SMPNCMD		0x8
-#define GMODE_PALETTE4BIT	0x9
-#define GMODE_PALETTE8BIT	0xa
-#define GMODE_RESERVED		0xb
-
-/*
- * define for DMA control 1 register
- */
-#define DMA1_FRAME_TRIG		31 /* bit location */
-#define DMA1_VSYNC_MODE		28
-#define DMA1_VSYNC_INV		27
-#define DMA1_CKEY		24
-#define DMA1_CARRY		23
-#define DMA1_LNBUF_ENA		22
-#define DMA1_GATED_ENA		21
-#define DMA1_PWRDN_ENA		20
-#define DMA1_DSCALE		18
-#define DMA1_ALPHA_MODE		16
-#define DMA1_ALPHA		08
-#define DMA1_PXLCMD		00
-
-/*
+ * defined for Configure Dumb Mode
  * defined for Configure Dumb Mode
  * DUMB LCD Panel bit[31:28]
  */
@@ -1050,18 +1001,6 @@ struct lcd_regs {
 #define	 CFG_CYC_BURST_LEN16			(1<<4)
 #define	 CFG_CYC_BURST_LEN8			(0<<4)
 
-/*
- * defined Dumb Panel Clock Divider register
- * SCLK_Source bit[31]
- */
- /* 0: PLL clock select*/
-#define AXI_BUS_SEL			0x80000000
-#define CCD_CLK_SEL			0x40000000
-#define DCON_CLK_SEL			0x20000000
-#define ENA_CLK_INT_DIV			CONFIG_FB_DOVE_CLCD_SCLK_DIV
-#define IDLE_CLK_INT_DIV		0x1	  /* idle Integer Divider */
-#define DIS_CLK_INT_DIV			0x0	  /* Disable Integer Divider */
-
 /* SRAM ID */
 #define SRAMID_GAMMA_YR			0x0
 #define SRAMID_GAMMA_UG			0x1
@@ -1471,422 +1410,6 @@ struct dsi_regs {
 #define LVDS_FREQ_OFFSET_MODE_CK_DIV4_OUT	(0x1 << 1)
 #define LVDS_FREQ_OFFSET_MODE_EN		(0x1 << 0)
 
-/* VDMA */
-struct vdma_ch_regs {
-#define VDMA_DC_SADDR_1		0x320
-#define VDMA_DC_SADDR_2		0x3A0
-#define VDMA_DC_SZ_1		0x324
-#define VDMA_DC_SZ_2		0x3A4
-#define VDMA_CTRL_1		0x328
-#define VDMA_CTRL_2		0x3A8
-#define VDMA_SRC_SZ_1		0x32C
-#define VDMA_SRC_SZ_2		0x3AC
-#define VDMA_SA_1		0x330
-#define VDMA_SA_2		0x3B0
-#define VDMA_DA_1		0x334
-#define VDMA_DA_2		0x3B4
-#define VDMA_SZ_1		0x338
-#define VDMA_SZ_2		0x3B8
-	u32	dc_saddr;
-	u32	dc_size;
-	u32	ctrl;
-	u32	src_size;
-	u32	src_addr;
-	u32	dst_addr;
-	u32	dst_size;
-#define VDMA_PITCH_1		0x33C
-#define VDMA_PITCH_2		0x3BC
-#define VDMA_ROT_CTRL_1		0x340
-#define VDMA_ROT_CTRL_2		0x3C0
-#define VDMA_RAM_CTRL0_1	0x344
-#define VDMA_RAM_CTRL0_2	0x3C4
-#define VDMA_RAM_CTRL1_1	0x348
-#define VDMA_RAM_CTRL1_2	0x3C8
-	u32	pitch;
-	u32	rot_ctrl;
-	u32	ram_ctrl0;
-	u32	ram_ctrl1;
-
-};
-struct vdma_regs {
-#define VDMA_ARBR_CTRL		0x300
-#define VDMA_IRQR		0x304
-#define VDMA_IRQM		0x308
-#define VDMA_IRQS		0x30C
-#define VDMA_MDMA_ARBR_CTRL	0x310
-	u32	arbr_ctr;
-	u32	irq_raw;
-	u32	irq_mask;
-	u32	irq_status;
-	u32	mdma_arbr_ctrl;
-	u32	reserved[3];
-
-	struct vdma_ch_regs	ch1;
-	u32	reserved2[21];
-	struct vdma_ch_regs	ch2;
-};
-
-/* CMU */
-#define CMU_PIP_DE_H_CFG	0x0008
-#define CMU_PRI1_H_CFG		0x000C
-#define CMU_PRI2_H_CFG		0x0010
-#define CMU_ACE_MAIN_DE1_H_CFG	0x0014
-#define CMU_ACE_MAIN_DE2_H_CFG	0x0018
-#define CMU_ACE_PIP_DE1_H_CFG	0x001C
-#define CMU_ACE_PIP_DE2_H_CFG	0x0020
-#define CMU_PIP_DE_V_CFG	0x0024
-#define CMU_PRI_V_CFG		0x0028
-#define CMU_ACE_MAIN_DE_V_CFG	0x002C
-#define CMU_ACE_PIP_DE_V_CFG	0x0030
-#define CMU_BAR_0_CFG		0x0034
-#define CMU_BAR_1_CFG		0x0038
-#define CMU_BAR_2_CFG		0x003C
-#define CMU_BAR_3_CFG		0x0040
-#define CMU_BAR_4_CFG		0x0044
-#define CMU_BAR_5_CFG		0x0048
-#define CMU_BAR_6_CFG		0x004C
-#define CMU_BAR_7_CFG		0x0050
-#define CMU_BAR_8_CFG		0x0054
-#define CMU_BAR_9_CFG		0x0058
-#define CMU_BAR_10_CFG		0x005C
-#define CMU_BAR_11_CFG		0x0060
-#define CMU_BAR_12_CFG		0x0064
-#define CMU_BAR_13_CFG		0x0068
-#define CMU_BAR_14_CFG		0x006C
-#define CMU_BAR_15_CFG		0x0070
-#define CMU_BAR_CTRL		0x0074
-#define PATTERN_TOTAL		0x0078
-#define PATTERN_ACTIVE		0x007C
-#define PATTERN_FRONT_PORCH	0x0080
-#define PATTERN_BACK_PORCH	0x0084
-#define CMU_CLK_CTRL		0x0088
-
-#define CMU_ICSC_M_C0_L		0x0900
-#define CMU_ICSC_M_C0_H		0x0901
-#define CMU_ICSC_M_C1_L		0x0902
-#define CMU_ICSC_M_C1_H		0x0903
-#define CMU_ICSC_M_C2_L		0x0904
-#define CMU_ICSC_M_C2_H		0x0905
-#define CMU_ICSC_M_C3_L		0x0906
-#define CMU_ICSC_M_C3_H		0x0907
-#define CMU_ICSC_M_C4_L		0x0908
-#define CMU_ICSC_M_C4_H		0x0909
-#define CMU_ICSC_M_C5_L		0x090A
-#define CMU_ICSC_M_C5_H		0x090B
-#define CMU_ICSC_M_C6_L		0x090C
-#define CMU_ICSC_M_C6_H		0x090D
-#define CMU_ICSC_M_C7_L		0x090E
-#define CMU_ICSC_M_C7_H		0x090F
-#define CMU_ICSC_M_C8_L		0x0910
-#define CMU_ICSC_M_C8_H		0x0911
-#define CMU_ICSC_M_O1_0		0x0914
-#define CMU_ICSC_M_O1_1		0x0915
-#define CMU_ICSC_M_O1_2		0x0916
-#define CMU_ICSC_M_O2_0		0x0918
-#define CMU_ICSC_M_O2_1		0x0919
-#define CMU_ICSC_M_O2_2		0x091A
-#define CMU_ICSC_M_O3_0		0x091C
-#define CMU_ICSC_M_O3_1		0x091D
-#define CMU_ICSC_M_O3_2		0x091E
-#define CMU_ICSC_P_C0_L		0x0920
-#define CMU_ICSC_P_C0_H		0x0921
-#define CMU_ICSC_P_C1_L		0x0922
-#define CMU_ICSC_P_C1_H		0x0923
-#define CMU_ICSC_P_C2_L		0x0924
-#define CMU_ICSC_P_C2_H		0x0925
-#define CMU_ICSC_P_C3_L		0x0926
-#define CMU_ICSC_P_C3_H		0x0927
-#define CMU_ICSC_P_C4_L		0x0928
-#define CMU_ICSC_P_C4_H		0x0929
-#define CMU_ICSC_P_C5_L		0x092A
-#define CMU_ICSC_P_C5_H		0x092B
-#define CMU_ICSC_P_C6_L		0x092C
-#define CMU_ICSC_P_C6_H		0x092D
-#define CMU_ICSC_P_C7_L		0x092E
-#define CMU_ICSC_P_C7_H		0x092F
-#define CMU_ICSC_P_C8_L		0x0930
-#define CMU_ICSC_P_C8_H		0x0931
-#define CMU_ICSC_P_O1_0		0x0934
-#define CMU_ICSC_P_O1_1		0x0935
-#define CMU_ICSC_P_O1_2		0x0936
-#define CMU_ICSC_P_O2_0		0x0938
-#define CMU_ICSC_P_O2_1		0x0939
-#define CMU_ICSC_P_O2_2		0x093A
-#define CMU_ICSC_P_O3_0		0x093C
-#define CMU_ICSC_P_O3_1		0x093D
-#define CMU_ICSC_P_O3_2		0x093E
-#define CMU_BR_M_EN		0x0940
-#define CMU_BR_M_TH1_L		0x0942
-#define CMU_BR_M_TH1_H		0x0943
-#define CMU_BR_M_TH2_L		0x0944
-#define CMU_BR_M_TH2_H		0x0945
-#define CMU_ACE_M_EN		0x0950
-#define CMU_ACE_M_WFG1		0x0951
-#define CMU_ACE_M_WFG2		0x0952
-#define CMU_ACE_M_WFG3		0x0953
-#define CMU_ACE_M_TH0		0x0954
-#define CMU_ACE_M_TH1		0x0955
-#define CMU_ACE_M_TH2		0x0956
-#define CMU_ACE_M_TH3		0x0957
-#define CMU_ACE_M_TH4		0x0958
-#define CMU_ACE_M_TH5		0x0959
-#define CMU_ACE_M_OP0_L		0x095A
-#define CMU_ACE_M_OP0_H		0x095B
-#define CMU_ACE_M_OP5_L		0x095C
-#define CMU_ACE_M_OP5_H		0x095D
-#define CMU_ACE_M_GB2		0x095E
-#define CMU_ACE_M_GB3		0x095F
-#define CMU_ACE_M_MS1		0x0960
-#define CMU_ACE_M_MS2		0x0961
-#define CMU_ACE_M_MS3		0x0962
-#define CMU_BR_P_EN		0x0970
-#define CMU_BR_P_TH1_L		0x0972
-#define CMU_BR_P_TH1_H		0x0973
-#define CMU_BR_P_TH2_L		0x0974
-#define CMU_BR_P_TH2_H		0x0975
-#define CMU_ACE_P_EN		0x0980
-#define CMU_ACE_P_WFG1		0x0981
-#define CMU_ACE_P_WFG2		0x0982
-#define CMU_ACE_P_WFG3		0x0983
-#define CMU_ACE_P_TH0		0x0984
-#define CMU_ACE_P_TH1		0x0985
-#define CMU_ACE_P_TH2		0x0986
-#define CMU_ACE_P_TH3		0x0987
-#define CMU_ACE_P_TH4		0x0988
-#define CMU_ACE_P_TH5		0x0989
-#define CMU_ACE_P_OP0_L		0x098A
-#define CMU_ACE_P_OP0_H		0x098B
-#define CMU_ACE_P_OP5_L		0x098C
-#define CMU_ACE_P_OP5_H		0x098D
-#define CMU_ACE_P_GB2		0x098E
-#define CMU_ACE_P_GB3		0x098F
-#define CMU_ACE_P_MS1		0x0990
-#define CMU_ACE_P_MS2		0x0991
-#define CMU_ACE_P_MS3		0x0992
-#define CMU_FTDC_M_EN		0x09A0
-#define CMU_FTDC_P_EN		0x09A1
-#define CMU_FTDC_INLOW_L	0x09A2
-#define CMU_FTDC_INLOW_H	0x09A3
-#define CMU_FTDC_INHIGH_L	0x09A4
-#define CMU_FTDC_INHIGH_H	0x09A5
-#define CMU_FTDC_OUTLOW_L	0x09A6
-#define CMU_FTDC_OUTLOW_H	0x09A7
-#define CMU_FTDC_OUTHIGH_L	0x09A8
-#define CMU_FTDC_OUTHIGH_H	0x09A9
-#define CMU_FTDC_YLOW		0x09AA
-#define CMU_FTDC_YHIGH		0x09AB
-#define CMU_FTDC_CH1		0x09AC
-#define CMU_FTDC_CH2_L		0x09AE
-#define CMU_FTDC_CH2_H		0x09AF
-#define CMU_FTDC_CH3_L		0x09B0
-#define CMU_FTDC_CH3_H		0x09B1
-#define CMU_FTDC_1_C00_6	0x09B2
-#define CMU_FTDC_1_C01_6	0x09B8
-#define CMU_FTDC_1_C11_6	0x09BE
-#define CMU_FTDC_1_C10_6	0x09C4
-#define CMU_FTDC_1_OFF00_6	0x09CA
-#define CMU_FTDC_1_OFF10_6	0x09D0
-#define CMU_HS_M_EN		0x0A00
-#define CMU_HS_M_AX1_L		0x0A02
-#define CMU_HS_M_AX1_H		0x0A03
-#define CMU_HS_M_AX2_L		0x0A04
-#define CMU_HS_M_AX2_H		0x0A05
-#define CMU_HS_M_AX3_L		0x0A06
-#define CMU_HS_M_AX3_H		0x0A07
-#define CMU_HS_M_AX4_L		0x0A08
-#define CMU_HS_M_AX4_H		0x0A09
-#define CMU_HS_M_AX5_L		0x0A0A
-#define CMU_HS_M_AX5_H		0x0A0B
-#define CMU_HS_M_AX6_L		0x0A0C
-#define CMU_HS_M_AX6_H		0x0A0D
-#define CMU_HS_M_AX7_L		0x0A0E
-#define CMU_HS_M_AX7_H		0x0A0F
-#define CMU_HS_M_AX8_L		0x0A10
-#define CMU_HS_M_AX8_H		0x0A11
-#define CMU_HS_M_AX9_L		0x0A12
-#define CMU_HS_M_AX9_H		0x0A13
-#define CMU_HS_M_AX10_L		0x0A14
-#define CMU_HS_M_AX10_H		0x0A15
-#define CMU_HS_M_AX11_L		0x0A16
-#define CMU_HS_M_AX11_H		0x0A17
-#define CMU_HS_M_AX12_L		0x0A18
-#define CMU_HS_M_AX12_H		0x0A19
-#define CMU_HS_M_AX13_L		0x0A1A
-#define CMU_HS_M_AX13_H		0x0A1B
-#define CMU_HS_M_AX14_L		0x0A1C
-#define CMU_HS_M_AX14_H		0x0A1D
-#define CMU_HS_M_H1_H14		0x0A1E
-#define CMU_HS_M_S1_S14		0x0A2C
-#define CMU_HS_M_GL		0x0A3A
-#define CMU_HS_M_MAXSAT_RGB_Y_L	0x0A3C
-#define CMU_HS_M_MAXSAT_RGB_Y_H	0x0A3D
-#define CMU_HS_M_MAXSAT_RCR_L	0x0A3E
-#define CMU_HS_M_MAXSAT_RCR_H	0x0A3F
-#define CMU_HS_M_MAXSAT_RCB_L	0x0A40
-#define CMU_HS_M_MAXSAT_RCB_H	0x0A41
-#define CMU_HS_M_MAXSAT_GCR_L	0x0A42
-#define CMU_HS_M_MAXSAT_GCR_H	0x0A43
-#define CMU_HS_M_MAXSAT_GCB_L	0x0A44
-#define CMU_HS_M_MAXSAT_GCB_H	0x0A45
-#define CMU_HS_M_MAXSAT_BCR_L	0x0A46
-#define CMU_HS_M_MAXSAT_BCR_H	0x0A47
-#define CMU_HS_M_MAXSAT_BCB_L	0x0A48
-#define CMU_HS_M_MAXSAT_BCB_H	0x0A49
-#define CMU_HS_M_ROFF_L		0x0A4A
-#define CMU_HS_M_ROFF_H		0x0A4B
-#define CMU_HS_M_GOFF_L		0x0A4C
-#define CMU_HS_M_GOFF_H		0x0A4D
-#define CMU_HS_M_BOFF_L		0x0A4E
-#define CMU_HS_M_BOFF_H		0x0A4F
-#define CMU_HS_P_EN		0x0A50
-#define CMU_HS_P_AX1_L		0x0A52
-#define CMU_HS_P_AX1_H		0x0A53
-#define CMU_HS_P_AX2_L		0x0A54
-#define CMU_HS_P_AX2_H		0x0A55
-#define CMU_HS_P_AX3_L		0x0A56
-#define CMU_HS_P_AX3_H		0x0A57
-#define CMU_HS_P_AX4_L		0x0A58
-#define CMU_HS_P_AX4_H		0x0A59
-#define CMU_HS_P_AX5_L		0x0A5A
-#define CMU_HS_P_AX5_H		0x0A5B
-#define CMU_HS_P_AX6_L		0x0A5C
-#define CMU_HS_P_AX6_H		0x0A5D
-#define CMU_HS_P_AX7_L		0x0A5E
-#define CMU_HS_P_AX7_H		0x0A5F
-#define CMU_HS_P_AX8_L		0x0A60
-#define CMU_HS_P_AX8_H		0x0A61
-#define CMU_HS_P_AX9_L		0x0A62
-#define CMU_HS_P_AX9_H		0x0A63
-#define CMU_HS_P_AX10_L		0x0A64
-#define CMU_HS_P_AX10_H		0x0A65
-#define CMU_HS_P_AX11_L		0x0A66
-#define CMU_HS_P_AX11_H		0x0A67
-#define CMU_HS_P_AX12_L		0x0A68
-#define CMU_HS_P_AX12_H		0x0A69
-#define CMU_HS_P_AX13_L		0x0A6A
-#define CMU_HS_P_AX13_H		0x0A6B
-#define CMU_HS_P_AX14_L		0x0A6C
-#define CMU_HS_P_AX14_H		0x0A6D
-#define CMU_HS_P_H1_H14		0x0A6E
-#define CMU_HS_P_S1_S14		0x0A7C
-#define CMU_HS_P_GL		0x0A8A
-#define CMU_HS_P_MAXSAT_RGB_Y_L	0x0A8C
-#define CMU_HS_P_MAXSAT_RGB_Y_H	0x0A8D
-#define CMU_HS_P_MAXSAT_RCR_L	0x0A8E
-#define CMU_HS_P_MAXSAT_RCR_H	0x0A8F
-#define CMU_HS_P_MAXSAT_RCB_L	0x0A90
-#define CMU_HS_P_MAXSAT_RCB_H	0x0A91
-#define CMU_HS_P_MAXSAT_GCR_L	0x0A92
-#define CMU_HS_P_MAXSAT_GCR_H	0x0A93
-#define CMU_HS_P_MAXSAT_GCB_L	0x0A94
-#define CMU_HS_P_MAXSAT_GCB_H	0x0A95
-#define CMU_HS_P_MAXSAT_BCR_L	0x0A96
-#define CMU_HS_P_MAXSAT_BCR_H	0x0A97
-#define CMU_HS_P_MAXSAT_BCB_L	0x0A98
-#define CMU_HS_P_MAXSAT_BCB_H	0x0A99
-#define CMU_HS_P_ROFF_L		0x0A9A
-#define CMU_HS_P_ROFF_H		0x0A9B
-#define CMU_HS_P_GOFF_L		0x0A9C
-#define CMU_HS_P_GOFF_H		0x0A9D
-#define CMU_HS_P_BOFF_L		0x0A9E
-#define CMU_HS_P_BOFF_H		0x0A9F
-#define CMU_GLCSC_M_C0_L	0x0AA0
-#define CMU_GLCSC_M_C0_H	0x0AA1
-#define CMU_GLCSC_M_C1_L	0x0AA2
-#define CMU_GLCSC_M_C1_H	0x0AA3
-#define CMU_GLCSC_M_C2_L	0x0AA4
-#define CMU_GLCSC_M_C2_H	0x0AA5
-#define CMU_GLCSC_M_C3_L	0x0AA6
-#define CMU_GLCSC_M_C3_H	0x0AA7
-#define CMU_GLCSC_M_C4_L	0x0AA8
-#define CMU_GLCSC_M_C4_H	0x0AA9
-#define CMU_GLCSC_M_C5_L	0x0AAA
-#define CMU_GLCSC_M_C5_H	0x0AAB
-#define CMU_GLCSC_M_C6_L	0x0AAC
-#define CMU_GLCSC_M_C6_H	0x0AAD
-#define CMU_GLCSC_M_C7_L	0x0AAE
-#define CMU_GLCSC_M_C7_H	0x0AAF
-#define CMU_GLCSC_M_C8_L	0x0AB0
-#define CMU_GLCSC_M_C8_H	0x0AB1
-#define CMU_GLCSC_M_O1_1	0x0AB4
-#define CMU_GLCSC_M_O1_2	0x0AB5
-#define CMU_GLCSC_M_O1_3	0x0AB6
-#define CMU_GLCSC_M_O2_1	0x0AB8
-#define CMU_GLCSC_M_O2_2	0x0AB9
-#define CMU_GLCSC_M_O2_3	0x0ABA
-#define CMU_GLCSC_M_O3_1	0x0ABC
-#define CMU_GLCSC_M_O3_2	0x0ABD
-#define CMU_GLCSC_M_O3_3	0x0ABE
-#define CMU_GLCSC_P_C0_L	0x0AC0
-#define CMU_GLCSC_P_C0_H	0x0AC1
-#define CMU_GLCSC_P_C1_L	0x0AC2
-#define CMU_GLCSC_P_C1_H	0x0AC3
-#define CMU_GLCSC_P_C2_L	0x0AC4
-#define CMU_GLCSC_P_C2_H	0x0AC5
-#define CMU_GLCSC_P_C3_L	0x0AC6
-#define CMU_GLCSC_P_C3_H	0x0AC7
-#define CMU_GLCSC_P_C4_L	0x0AC8
-#define CMU_GLCSC_P_C4_H	0x0AC9
-#define CMU_GLCSC_P_C5_L	0x0ACA
-#define CMU_GLCSC_P_C5_H	0x0ACB
-#define CMU_GLCSC_P_C6_L	0x0ACC
-#define CMU_GLCSC_P_C6_H	0x0ACD
-#define CMU_GLCSC_P_C7_L	0x0ACE
-#define CMU_GLCSC_P_C7_H	0x0ACF
-#define CMU_GLCSC_P_C8_L	0x0AD0
-#define CMU_GLCSC_P_C8_H	0x0AD1
-#define CMU_GLCSC_P_O1_1	0x0AD4
-#define CMU_GLCSC_P_O1_2	0x0AD5
-#define CMU_GLCSC_P_O1_3	0x0AD6
-#define CMU_GLCSC_P_O2_1	0x0AD8
-#define CMU_GLCSC_P_O2_2	0x0AD9
-#define CMU_GLCSC_P_O2_3	0x0ADA
-#define CMU_GLCSC_P_O3_1	0x0ADC
-#define CMU_GLCSC_P_O3_2	0x0ADD
-#define CMU_GLCSC_P_O3_3	0x0ADE
-#define CMU_PIXVAL_M_EN		0x0AE0
-#define CMU_PIXVAL_P_EN		0x0AE1
-
-#define CMU_CLK_CTRL_TCLK	0x0
-#define CMU_CLK_CTRL_SCLK	0x2
-#define CMU_CLK_CTRL_MSK	0x2
-#define CMU_CLK_CTRL_ENABLE	0x1
-
-#define LCD_TOP_CTRL_TV		0x2
-#define LCD_TOP_CTRL_PN		0x0
-#define LCD_TOP_CTRL_SEL_MSK	0x2
-#define LCD_IO_CMU_IN_SEL_MSK	(0x3 << 20)
-#define LCD_IO_CMU_IN_SEL_TV	0
-#define LCD_IO_CMU_IN_SEL_PN	1
-#define LCD_IO_CMU_IN_SEL_PN2	2
-#define LCD_IO_TV_OUT_SEL_MSK	(0x3 << 26)
-#define LCD_IO_PN_OUT_SEL_MSK	(0x3 << 24)
-#define LCD_IO_PN2_OUT_SEL_MSK	(0x3 << 28)
-#define LCD_IO_TV_OUT_SEL_NON	3
-#define LCD_IO_PN_OUT_SEL_NON	3
-#define LCD_IO_PN2_OUT_SEL_NON	3
-#define LCD_TOP_CTRL_CMU_ENABLE 0x1
-#define LCD_IO_OVERL_MSK	0xC00000
-#define LCD_IO_OVERL_TV		0x0
-#define LCD_IO_OVERL_LCD1	0x400000
-#define LCD_IO_OVERL_LCD2	0xC00000
-#define HINVERT_MSK		0x4
-#define VINVERT_MSK		0x8
-#define HINVERT_LEN		0x2
-#define VINVERT_LEN		0x3
-
-#define CMU_CTRL		0x88
-#define CMU_CTRL_A0_MSK		0x6
-#define CMU_CTRL_A0_TV		0x0
-#define CMU_CTRL_A0_LCD1	0x1
-#define CMU_CTRL_A0_LCD2	0x2
-#define CMU_CTRL_A0_HDMI	0x3
-
-#define ICR_DRV_ROUTE_OFF	0x0
-#define ICR_DRV_ROUTE_TV	0x1
-#define ICR_DRV_ROUTE_LCD1	0x2
-#define ICR_DRV_ROUTE_LCD2	0x3
