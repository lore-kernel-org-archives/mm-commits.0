From: akpm@linux-foundation.org
Subject: [to-be-updated] s3c-fb-add-s5pv210-support-and-some-features.patch removed from -mm tree
Date: Thu, 20 May 2010 15:03:45 -0700
Message-ID: <201005202203.o4KM3jjs007636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172Ab0ETWE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 18:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeinki@gmail.com, ben-linux@fluff.org, inki.dae@samsung.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     s3c-fb: add s5pv210 support and some features
has been removed from the -mm tree.  Its filename was
     s3c-fb-add-s5pv210-support-and-some-features.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c-fb: add s5pv210 support and some features
From: InKi Dae <daeinki@gmail.com>

This patch is for s5pv210(or s5pc110) support and adds resizing and
default window features and also fixes distortendness situation on pixel
format more then 24bpp.

patch contents are as following:

- resizing feature.  when application tries to change framebuffer
  attributes(pixel format, resolution and so no), fb_set_var() is called
  by linux framebuffer(fbmem.c) at that time, s3c-fb sets attributes for
  setting porch and pixelclock to registers so setting would be failed
  because wrong clock was set.  this patch makes porch and pixelclock to
  be set only at initialization step.

- default window.  s5pv210 has five window layers (window0 ~ 4), among
  them, window0 ~ 2 could be used for local path with fimc(capture device)
  and fimd writeback feature so this patch makes default window layer for
  UI to be set at machine code.

- fix distortedness situation on pixel format more then 24bpp.  It has
  been working fine at 16bpp but in case of pixel format more then 24bpp
  it would occur distortedness situation on that mode.  so this patch set
  the word swap control bit of WINCONx to 1 as default value.  but it
  should be set to 0 in case that each ENLOCAL bit of WINCON0 ~ 2
  registers is enabled.  this issue would be solved with local path
  feature soon.

- s5pv210 support.  In case of fimd(display controller) of s5pv210,
  CH_ENABLE bit should be enabled to enable window layer.

and also I would add MIPI-DSI and mDNIe(Image enhancement device)
features(including device driver) in the near future.

Signed-off-by: InKi Dae <inki.dae@samsung.com>
Reviewed-by: KyungMin Park <kyungmin.park.samsung.com>
Cc: Ben Dooks <ben@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s5pv210/include/mach/regs-fb.h    |   95 +++++++++
 arch/arm/plat-samsung/include/plat/fb.h         |    1 
 arch/arm/plat-samsung/include/plat/regs-fb-v5.h |  138 ++++++++++++++
 arch/arm/plat-samsung/include/plat/regs-fb.h    |    1 
 drivers/video/Kconfig                           |    2 
 drivers/video/s3c-fb.c                          |  109 +++++++----
 6 files changed, 306 insertions(+), 40 deletions(-)

diff -puN /dev/null arch/arm/mach-s5pv210/include/mach/regs-fb.h
--- /dev/null
+++ a/arch/arm/mach-s5pv210/include/mach/regs-fb.h
@@ -0,0 +1,95 @@
+/*
+ * Copyright 2009 Samsung Electronics Co.
+ *   Pawel Osciak <p.osciak@samsung.com>
+ *
+ * Machine-specific framebuffer definitions for Samsung S5PC110.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARCH_MACH_REGS_FB_H
+#define __ASM_ARCH_MACH_REGS_FB_H __FILE__
+
+#include <plat/regs-fb-v5.h>
+
+/* WINCONx */
+#define WINCONx_BUFSTATUS_H				(1 << 31)
+#define WINCONx_BUFSEL_H				(1 << 30)
+#define WINCONx_LIMIT_ON				(1 << 29)
+#define WINCONx_EQ709					(1 << 28)
+
+
+/* VIDCON3 */
+#define VIDCON3						(0x0c)
+#define VIDCON3_VE_ON					(1 << 20)
+#define VIDCON3_CG_ON					(1 << 18)
+#define VIDCON3_GM_ON					(1 << 16)
+#define VIDCON3_HU_CSC_F_NARROW				(1 << 14)
+#define VIDCON3_HU_CSC_F_EQ709				(1 << 13)
+#define VIDCON3_HU_CSC_F_EN				(1 << 12)
+#define VIDCON3_HU_CSC_B_NARROW				(1 << 10)
+#define VIDCON3_HU_CSC_B_EQ709				(1 << 9)
+#define VIDCON3_HU_CSC_B_EN				(1 << 8)
+#define VIDCON3_HUE_EN					(1 << 7)
+#define VIDCON3_PC_DIR_NEG				(1 << 1)
+#define VIDCON3_PC_EN					(1 << 0)
+
+
+/* VIDTCON3 */
+#define VIDTCON3					(0x1c)
+#define VIDTCON3_VSYNC_EN				(1 << 31)
+#define VIDTCON3_FRM_EN					(1 << 29)
+#define VIDTCON3_INVFRM_LOW				(1 << 28)
+#define VIDTCON3_FRMVRATE_MASK				0xf
+#define VIDTCON3_FRMVRATE_SHIFT				(24)
+#define VIDTCON3_FRMVFPD_MASK				0xff
+#define VIDTCON3_FRMVFPD_SHIFT				(8)
+#define VIDTCON3_FRMVSPW_MASK				0xff
+#define VIDTCON3_FRMVSPW_SHIFT				(0)
+
+
+#define SHADOWCON					(0x34)
+#define SHADOWCON_CH_ENABLE(x)				(1 << x)
+#define SHADOWCON_CH_DISABLE(x)				(0 << x)
+#define SHADOWCON_CH_LOCAL_ENABLE(x)			(1 << (x + 5))
+#define SHADOWCON_CH_LOCAL_DISABLE(x)			(0 << (x + 5))
+/* Set to disable window 4-0 shadow registers' update */
+#define SHADOWCON_W4_PROTECT				(1 << 14)
+#define SHADOWCON_W3_PROTECT				(1 << 13)
+#define SHADOWCON_W2_PROTECT				(1 << 12)
+#define SHADOWCON_W1_PROTECT				(1 << 11)
+#define SHADOWCON_W0_PROTECT				(1 << 10)
+
+
+/* Video buffer address shadow registers (read-only) */
+#define VIDW_BUF_START_SHADOW(_buf)			(0x20a0 + ((_buf) * 8))
+#define VIDW_BUF_END_SHADOW(_buf)			(0x20d0 + ((_buf) * 8))
+
+/* For windows 1-4 */
+#define WxKEY_ALPHA(_win)				(0x160 + ((_win) * 4))
+
+#define COLORGAINCON					(0x1c0)
+#define VESFRCON0					(0x1c4)
+#define VESFRCON1					(0x1c8)
+#define VESFRCON2					(0x1cc)
+
+/* Hue matrix coefficients */
+#define HUECOEF00					(0x1ec)
+#define HUECOEF01					(0x1f0)
+#define HUECOEF10					(0x1f4)
+#define HUECOEF11					(0x1f8)
+#define HUEOFFSET					(0x1fc)
+
+/* RTQOS control for windows 0-4*/
+#define WxRTQOSCON(_win)				(0x264 + ((_win) * 4))
+
+/* Gamma LUT data for index I1 and I0, where
+ * I0 = _index, I1 = _index + 1.
+ */
+#define GAMMALUT_BASE					(0x37c)
+#define GAMMALUT_I1I0(_index)			(GAMMALUT_BASE + ((_index) * 4))
+
+#endif /* __ASM_ARCH_MACH_REGS_FB_H */
+
diff -puN arch/arm/plat-samsung/include/plat/fb.h~s3c-fb-add-s5pv210-support-and-some-features arch/arm/plat-samsung/include/plat/fb.h
--- a/arch/arm/plat-samsung/include/plat/fb.h~s3c-fb-add-s5pv210-support-and-some-features
+++ a/arch/arm/plat-samsung/include/plat/fb.h
@@ -50,6 +50,7 @@ struct s3c_fb_platdata {
 	void	(*setup_gpio)(void);
 
 	struct s3c_fb_pd_win	*win[S3C_FB_MAX_WIN];
+	u32			default_win;
 
 	u32			 vidcon0;
 	u32			 vidcon1;
diff -puN /dev/null arch/arm/plat-samsung/include/plat/regs-fb-v5.h
--- /dev/null
+++ a/arch/arm/plat-samsung/include/plat/regs-fb-v5.h
@@ -0,0 +1,138 @@
+/*
+ * Copyright 2009 Samsung Electronics Co.
+ *   Pawel Osciak <p.osciak@samsung.com>
+ *
+ * Common framebuffer register definitions for Samsung S5PC1xx family.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARCH_REGS_FB_V5_H
+#define __ASM_ARCH_REGS_FB_V5_H __FILE__
+
+#include <plat/regs-fb-v4.h>
+
+/* VP1 interface timing control */
+#define VP1CON0						(0x118)
+#define VP1_RATECON_EN					(1 << 31)
+#define VP1_CLKRATE_MASK				(0xff)
+
+#define VP1CON1						(0x11c)
+#define VP1_VTREGCON_EN					(1 << 31)
+#define VP1_VBPD_MASK					(0xfff)
+#define VP1_VBPD_SHIFT					(16)
+
+
+#define WPALCON_H					(0x19c)
+#define WPALCON_L					(0x1a0)
+
+/* Pallete contro for WPAL0 and WPAL1 is the same as in S3C64xx, but
+ * different for WPAL2-4
+ */
+/* In WPALCON_L (aka WPALCON) */
+#define WPALCON_W1PAL_32BPP_A888			(0x7 << 3)
+#define WPALCON_W0PAL_32BPP_A888			(0x7 << 0)
+
+/* W2PAL-W4PAL consist of one bit from WPALCON_L and two from WPALCON_H,
+ * e.g. W2PAL[2..0] is made of (WPALCON_H[10..9], WPALCON_L[6]).
+ */
+#define WPALCON_L_WxPAL_L_MASK				(0x1)
+#define WPALCON_L_W2PAL_L_SHIFT				(6)
+#define WPALCON_L_W3PAL_L_SHIFT				(7)
+#define WPALCON_L_W4PAL_L_SHIFT				(8)
+
+#define WPALCON_L_WxPAL_H_MASK				(0x3)
+#define WPALCON_H_W2PAL_H_SHIFT				(9)
+#define WPALCON_H_W3PAL_H_SHIFT				(13)
+#define WPALCON_H_W4PAL_H_SHIFT				(17)
+
+/* Per-window alpha value registers */
+/* For window 0 8-bit alpha values are in VIDW0ALPHAx,
+ * for windows 1-4 alpha values consist of two parts, the 4 low bits are
+ * taken from VIDWxALPHAx and 4 high bits are from VIDOSDxC,
+ * e.g. WIN1_ALPHA0_B[7..0] = (VIDOSD1C[3..0], VIDW1ALPHA0[3..0])
+ */
+#define VIDWxALPHA0(_win)				(0x200 + (_win * 8))
+#define VIDWxALPHA1(_win)				(0x204 + (_win * 8))
+
+/* Only for window 0 in VIDW0ALPHAx. */
+#define VIDW0ALPHAx_R(_x)				((_x) << 16)
+#define VIDW0ALPHAx_R_MASK				(0xff << 16)
+#define VIDW0ALPHAx_R_SHIFT				(16)
+#define VIDW0ALPHAx_G(_x)				((_x) << 8)
+#define VIDW0ALPHAx_G_MASK				(0xff << 8)
+#define VIDW0ALPHAx_G_SHIFT				(8)
+#define VIDW0ALPHAx_B(_x)				((_x) << 0)
+#define VIDW0ALPHAx_B_MASK				(0xff << 0)
+#define VIDW0ALPHAx_B_SHIFT				(0)
+
+/* Low 4 bits of alpha0-1 for windows 1-4 */
+#define VIDW14ALPHAx_R_L(_x)				((_x) << 16)
+#define VIDW14ALPHAx_R_L_MASK				(0xf << 16)
+#define VIDW14ALPHAx_R_L_SHIFT				(16)
+#define VIDW14ALPHAx_G_L(_x)				((_x) << 8)
+#define VIDW14ALPHAx_G_L_MASK				(0xf << 8)
+#define VIDW14ALPHAx_G_L_SHIFT				(8)
+#define VIDW14ALPHAx_B_L(_x)				((_x) << 0)
+#define VIDW14ALPHAx_B_L_MASK				(0xf << 0)
+#define VIDW14ALPHAx_B_L_SHIFT				(0)
+
+
+/* Per-window blending equation control registers */
+#define BLENDEQx(_win)					(0x244 + ((_win) * 4))
+#define BLENDEQ1					(0x244)
+#define BLENDEQ2					(0x248)
+#define BLENDEQ3					(0x24c)
+#define BLENDEQ4					(0x250)
+
+#define BLENDEQx_Q_FUNC(_x)				((_x) << 18)
+#define BLENDEQx_Q_FUNC_MASK				(0xf << 18)
+#define BLENDEQx_P_FUNC(_x)				((_x) << 12)
+#define BLENDEQx_P_FUNC_MASK				(0xf << 12)
+#define BLENDEQx_B_FUNC(_x)				((_x) << 6)
+#define BLENDEQx_B_FUNC_MASK				(0xf << 6)
+#define BLENDEQx_A_FUNC(_x)				((_x) << 0)
+#define BLENDEQx_A_FUNC_MASK				(0xf << 0)
+
+#define BLENDCON					(0x260)
+#define BLENDCON_8BIT_ALPHA				(1 << 0)
+
+/* Per-window palette base addresses (start of palette memory).
+ * Each window palette area consists of 256 32-bit entries.
+ * START is the first address (entry 0th), END is the address of 255th entry.
+ */
+#define WIN0_PAL_BASE					(0x2400)
+#define WIN0_PAL_END					(0x27fc)
+#define WIN1_PAL_BASE					(0x2800)
+#define WIN1_PAL_END					(0x2bfc)
+#define WIN2_PAL_BASE					(0x2c00)
+#define WIN2_PAL_END					(0x2ffc)
+#define WIN3_PAL_BASE					(0x3000)
+#define WIN3_PAL_END					(0x33fc)
+#define WIN4_PAL_BASE					(0x3400)
+#define WIN4_PAL_END					(0x37fc)
+
+#define WIN0_PAL(_entry)			(WIN0_PAL_BASE + ((_entry) * 4))
+#define WIN1_PAL(_entry)			(WIN1_PAL_BASE + ((_entry) * 4))
+#define WIN2_PAL(_entry)			(WIN2_PAL_BASE + ((_entry) * 4))
+#define WIN3_PAL(_entry)			(WIN3_PAL_BASE + ((_entry) * 4))
+#define WIN4_PAL(_entry)			(WIN4_PAL_BASE + ((_entry) * 4))
+
+static inline unsigned int s3c_fb_pal_reg(unsigned int window, int reg)
+{
+	switch (window) {
+	case 0: return WIN0_PAL(reg);
+	case 1: return WIN1_PAL(reg);
+	case 2: return WIN2_PAL(reg);
+	case 3: return WIN3_PAL(reg);
+	case 4: return WIN4_PAL(reg);
+	}
+
+	BUG();
+}
+
+
+#endif /* __ASM_ARCH_REGS_FB_V5_H */
+
diff -puN arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-s5pv210-support-and-some-features arch/arm/plat-samsung/include/plat/regs-fb.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-s5pv210-support-and-some-features
+++ a/arch/arm/plat-samsung/include/plat/regs-fb.h
@@ -173,6 +173,7 @@
 #define WINCONx_BITSWP				(1 << 18)
 #define WINCONx_BYTSWP				(1 << 17)
 #define WINCONx_HAWSWP				(1 << 16)
+#define WINCONx_WSWP				(1 << 15)
 #define WINCONx_BURSTLEN_MASK			(0x3 << 9)
 #define WINCONx_BURSTLEN_SHIFT			(9)
 #define WINCONx_BURSTLEN_16WORD			(0x0 << 9)
diff -puN drivers/video/Kconfig~s3c-fb-add-s5pv210-support-and-some-features drivers/video/Kconfig
--- a/drivers/video/Kconfig~s3c-fb-add-s5pv210-support-and-some-features
+++ a/drivers/video/Kconfig
@@ -1927,7 +1927,7 @@ config FB_TMIO_ACCELL
 
 config FB_S3C
 	tristate "Samsung S3C framebuffer support"
-	depends on FB && ARCH_S3C64XX
+	depends on FB && (ARCH_S3C64XX || ARCH_S5PV210)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff -puN drivers/video/s3c-fb.c~s3c-fb-add-s5pv210-support-and-some-features drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-add-s5pv210-support-and-some-features
+++ a/drivers/video/s3c-fb.c
@@ -268,9 +268,8 @@ static int s3c_fb_set_par(struct fb_info
 	void __iomem *regs = sfb->regs;
 	int win_no = win->index;
 	u32 osdc_data = 0;
-	u32 data;
+	u32 data, shadow;
 	u32 pagewidth;
-	int clkdiv;
 
 	dev_dbg(sfb->dev, "setting framebuffer parameters\n");
 
@@ -300,42 +299,7 @@ static int s3c_fb_set_par(struct fb_info
 	/* disable the window whilst we update it */
 	writel(0, regs + WINCON(win_no));
 
-	/* use window 0 as the basis for the lcd output timings */
-
-	if (win_no == 0) {
-		clkdiv = s3c_fb_calc_pixclk(sfb, var->pixclock);
-
-		data = sfb->pdata->vidcon0;
-		data &= ~(VIDCON0_CLKVAL_F_MASK | VIDCON0_CLKDIR);
-
-		if (clkdiv > 1)
-			data |= VIDCON0_CLKVAL_F(clkdiv-1) | VIDCON0_CLKDIR;
-		else
-			data &= ~VIDCON0_CLKDIR;	/* 1:1 clock */
-
-		/* write the timing data to the panel */
-
-		data |= VIDCON0_ENVID | VIDCON0_ENVID_F;
-		writel(data, regs + VIDCON0);
-
-		data = VIDTCON0_VBPD(var->upper_margin - 1) |
-		       VIDTCON0_VFPD(var->lower_margin - 1) |
-		       VIDTCON0_VSPW(var->vsync_len - 1);
-
-		writel(data, regs + VIDTCON0);
-
-		data = VIDTCON1_HBPD(var->left_margin - 1) |
-		       VIDTCON1_HFPD(var->right_margin - 1) |
-		       VIDTCON1_HSPW(var->hsync_len - 1);
-
-		writel(data, regs + VIDTCON1);
-
-		data = VIDTCON2_LINEVAL(var->yres - 1) |
-		       VIDTCON2_HOZVAL(var->xres - 1);
-		writel(data, regs + VIDTCON2);
-	}
-
-	/* write the buffer address */
+		/* write the buffer address */
 
 	writel(info->fix.smem_start, regs + VIDW_BUF_START(win_no));
 
@@ -372,6 +336,9 @@ static int s3c_fb_set_par(struct fb_info
 
 	data = WINCONx_ENWIN;
 
+	shadow = readl(sfb->regs + SHADOWCON);
+	shadow |= SHADOWCON_CH_ENABLE(win_no);
+
 	/* note, since we have to round up the bits-per-pixel, we end up
 	 * relying on the bitfield information for r/g/b/a to work out
 	 * exactly which mode of operation is intended. */
@@ -424,6 +391,7 @@ static int s3c_fb_set_par(struct fb_info
 		else
 			data |= WINCON0_BPPMODE_24BPP_888;
 
+		data |= WINCONx_WSWP;
 		data |= WINCONx_BURSTLEN_16WORD;
 		break;
 	}
@@ -444,6 +412,61 @@ static int s3c_fb_set_par(struct fb_info
 
 	writel(data, regs + WINCON(win_no));
 	writel(0x0, regs + WINxMAP(win_no));
+	writel(shadow, sfb->regs + SHADOWCON);
+
+	return 0;
+}
+
+/**
+ * s3c_fb_set_timing() - s3c_fb_probe_win request to set timing such as pixel clock,
+ * 				porch and so on.
+ * @info: The framebuffer to initialize.
+ *
+ * s3c_fb_probe_win request to initialize the specified framebuffer
+ */
+static int s3c_fb_set_timing(struct fb_info *info)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct s3c_fb_win *win = info->par;
+	struct s3c_fb *sfb = win->parent;
+	void __iomem *regs = sfb->regs;
+	int win_no = win->index;
+	int clkdiv;
+	u32 data;
+
+	/* use window 0 as the basis for the lcd output timings */
+	if (win_no == sfb->pdata->default_win) {
+		clkdiv = s3c_fb_calc_pixclk(sfb, var->pixclock);
+
+		data = sfb->pdata->vidcon0;
+		data &= ~(VIDCON0_CLKVAL_F_MASK | VIDCON0_CLKDIR);
+
+		if (clkdiv > 1)
+			data |= VIDCON0_CLKVAL_F(clkdiv-1) | VIDCON0_CLKDIR;
+		else
+			data &= ~VIDCON0_CLKDIR;	/* 1:1 clock */
+
+		/* write the timing data to the panel */
+
+		data |= VIDCON0_ENVID | VIDCON0_ENVID_F;
+		writel(data, regs + VIDCON0);
+
+		data = VIDTCON0_VBPD(var->upper_margin - 1) |
+		       VIDTCON0_VFPD(var->lower_margin - 1) |
+		       VIDTCON0_VSPW(var->vsync_len - 1);
+
+		writel(data, regs + VIDTCON0);
+
+		data = VIDTCON1_HBPD(var->left_margin - 1) |
+		       VIDTCON1_HFPD(var->right_margin - 1) |
+		       VIDTCON1_HSPW(var->hsync_len - 1);
+
+		writel(data, regs + VIDTCON1);
+
+		data = VIDTCON2_LINEVAL(var->yres - 1) |
+		       VIDTCON2_HOZVAL(var->xres - 1);
+		writel(data, regs + VIDTCON2);
+	}
 
 	return 0;
 }
@@ -636,7 +659,7 @@ static int s3c_fb_blank(int blank_mode, 
 	/* we're stuck with this until we can do something about overriding
 	 * the power control using the blanking event for a single fb.
 	 */
-	if (index == 0)
+	if (index == sfb->pdata->default_win)
 		s3c_fb_enable(sfb, blank_mode != FB_BLANK_POWERDOWN ? 1 : 0);
 
 	return 0;
@@ -724,12 +747,18 @@ static void s3c_fb_free_memory(struct s3
  */
 static void s3c_fb_release_win(struct s3c_fb *sfb, struct s3c_fb_win *win)
 {
+	u32 shadow;
+
 	if (win->fbinfo) {
 		unregister_framebuffer(win->fbinfo);
 		fb_dealloc_cmap(&win->fbinfo->cmap);
 		s3c_fb_free_memory(sfb, win);
 		framebuffer_release(win->fbinfo);
 	}
+
+	shadow = readl(sfb->regs + SHADOWCON);
+	shadow &= ~SHADOWCON_CH_DISABLE(win->index);
+	writel(shadow, sfb->regs + SHADOWCON);
 }
 
 /**
@@ -816,6 +845,8 @@ static int __devinit s3c_fb_probe_win(st
 
 	s3c_fb_set_par(fbinfo);
 
+	s3c_fb_set_timing(fbinfo);
+
 	dev_dbg(sfb->dev, "about to register framebuffer\n");
 
 	/* run the check_var and set_par on our configuration. */
_

Patches currently in -mm which might be from daeinki@gmail.com are

backlight-add-s6e63m0-amoled-lcd-panel-driver.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-update.patch
s3c-fb-add-s5pv210-support-and-some-features.patch

