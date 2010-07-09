From: akpm@linux-foundation.org
Subject: + s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:08:55 -0700
Message-ID: <201007092308.o69N8tcX030955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526Ab0GIXJq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, inki.dae@samsung.com, m.szyprowski@samsung.com, p.osciak@samsung.com


The patch titled
     s3c-fb: udpate to support s3c2416/s3c2443 style hardware
has been added to the -mm tree.  Its filename is
     s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch

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
Subject: s3c-fb: udpate to support s3c2416/s3c2443 style hardware
From: Ben Dooks <ben-linux@fluff.org>

Update the variant and window variant structures with the necessary
changes to support the older style of hardware where these are not in the
same place.

Add the support for the s3c2443/s3c2416 hardware by using the
platform-device s3c2443 to cover both, and add the initialisation data for
these.

Also change to including just the v4 header files for the moment until the
last of the merging of these is sorted out.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: KyungMin Park <kyungmin.park.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/regs-fb-v4.h |    8 
 arch/arm/plat-samsung/include/plat/regs-fb.h    |    4 
 drivers/video/s3c-fb.c                          |  162 +++++++++++---
 3 files changed, 136 insertions(+), 38 deletions(-)

diff -puN arch/arm/plat-samsung/include/plat/regs-fb-v4.h~s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware arch/arm/plat-samsung/include/plat/regs-fb-v4.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb-v4.h~s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware
+++ a/arch/arm/plat-samsung/include/plat/regs-fb-v4.h
@@ -40,16 +40,10 @@
 
 /* OSD1 and OSD4 do not have register D */
 
-#define VIDOSD_A(_win)				(0x40 + ((_win) * 16))
-#define VIDOSD_B(_win)				(0x44 + ((_win) * 16))
-#define VIDOSD_C(_win)				(0x48 + ((_win) * 16))
-#define VIDOSD_D(_win)				(0x4C + ((_win) * 16))
-
+#define VIDOSD_BASE				(0x40)
 
 #define VIDINTCON0				(0x130)
 
-#define WxKEYCONy(_win, _con)			((0x140 + ((_win) * 8)) + ((_con) * 4))
-
 /* WINCONx */
 
 #define WINCONx_CSCWIDTH_MASK			(0x3 << 26)
diff -puN arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware arch/arm/plat-samsung/include/plat/regs-fb.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware
+++ a/arch/arm/plat-samsung/include/plat/regs-fb.h
@@ -322,6 +322,10 @@
 #define VIDINTCON1_INT_FIFO			(1 << 0)
 
 /* Window colour-key control registers */
+#define WKEYCON					(0x140)	/* 6410,V210 */
+
+#define WKEYCON0				(0x00)
+#define WKEYCON1				(0x04)
 
 #define WxKEYCON0_KEYBL_EN			(1 << 26)
 #define WxKEYCON0_KEYEN_F			(1 << 25)
diff -puN drivers/video/s3c-fb.c~s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware
+++ a/drivers/video/s3c-fb.c
@@ -9,7 +9,7 @@
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * published by the Free Software FoundatIon.
 */
 
 #include <linux/kernel.h>
@@ -23,7 +23,7 @@
 #include <linux/io.h>
 
 #include <mach/map.h>
-#include <mach/regs-fb.h>
+#include <plat/regs-fb-v4.h>
 #include <plat/fb.h>
 
 /* This driver will export a number of framebuffer interfaces depending
@@ -52,13 +52,38 @@ struct s3c_fb;
 
 #define VALID_BPP(x) (1 << ((x) - 1))
 
+#define OSD_BASE(win, variant) ((variant).osd + ((win) * (variant).osd_stride))
+#define VIDOSD_A(win, variant) (OSD_BASE(win, variant) + 0x00)
+#define VIDOSD_B(win, variant) (OSD_BASE(win, variant) + 0x04)
+#define VIDOSD_C(win, variant) (OSD_BASE(win, variant) + 0x08)
+#define VIDOSD_D(win, variant) (OSD_BASE(win, variant) + 0x0C)
+
 /**
  * struct s3c_fb_variant - fb variant information
+ * @is_2443: Set if S3C2443/S3C2416 style hardware.
  * @nr_windows: The number of windows.
+ * @vidtcon: The base for the VIDTCONx registers
+ * @wincon: The base for the WINxCON registers.
+ * @winmap: The base for the WINxMAP registers.
+ * @keycon: The abse for the WxKEYCON registers.
+ * @buf_start: Offset of buffer start registers.
+ * @buf_size: Offset of buffer size registers.
+ * @buf_end: Offset of buffer end registers.
+ * @osd: The base for the OSD registers.
  * @palette: Address of palette memory, or 0 if none.
  */
 struct s3c_fb_variant {
+	unsigned int	is_2443:1;
 	unsigned short	nr_windows;
+	unsigned short	vidtcon;
+	unsigned short	wincon;
+	unsigned short	winmap;
+	unsigned short	keycon;
+	unsigned short	buf_start;
+	unsigned short	buf_end;
+	unsigned short	buf_size;
+	unsigned short	osd;
+	unsigned short	osd_stride;
 	unsigned short	palette[S3C_FB_MAX_WIN];
 };
 
@@ -308,6 +333,7 @@ static int s3c_fb_set_par(struct fb_info
 	struct s3c_fb_win *win = info->par;
 	struct s3c_fb *sfb = win->parent;
 	void __iomem *regs = sfb->regs;
+	void __iomem *buf = regs;
 	int win_no = win->index;
 	u32 osdc_data = 0;
 	u32 data;
@@ -357,6 +383,9 @@ static int s3c_fb_set_par(struct fb_info
 
 		/* write the timing data to the panel */
 
+		if (sfb->variant.is_2443)
+			data |= (1 << 5);
+
 		data |= VIDCON0_ENVID | VIDCON0_ENVID_F;
 		writel(data, regs + VIDCON0);
 
@@ -364,41 +393,45 @@ static int s3c_fb_set_par(struct fb_info
 		       VIDTCON0_VFPD(var->lower_margin - 1) |
 		       VIDTCON0_VSPW(var->vsync_len - 1);
 
-		writel(data, regs + VIDTCON0);
+		writel(data, regs + sfb->variant.vidtcon);
 
 		data = VIDTCON1_HBPD(var->left_margin - 1) |
 		       VIDTCON1_HFPD(var->right_margin - 1) |
 		       VIDTCON1_HSPW(var->hsync_len - 1);
 
-		writel(data, regs + VIDTCON1);
+		/* VIDTCON1 */
+		writel(data, regs + sfb->variant.vidtcon + 4);
 
 		data = VIDTCON2_LINEVAL(var->yres - 1) |
 		       VIDTCON2_HOZVAL(var->xres - 1);
-		writel(data, regs + VIDTCON2);
+		writel(data, regs +sfb->variant.vidtcon + 8 );
 	}
 
 	/* write the buffer address */
 
-	writel(info->fix.smem_start, regs + VIDW_BUF_START(win_no));
+	/* start and end registers stride is 8 */
+	buf = regs + win_no * 8;
+
+	writel(info->fix.smem_start, buf + sfb->variant.buf_start);
 
 	data = info->fix.smem_start + info->fix.line_length * var->yres;
-	writel(data, regs + VIDW_BUF_END(win_no));
+	writel(data, buf + sfb->variant.buf_end);
 
 	pagewidth = (var->xres * var->bits_per_pixel) >> 3;
 	data = VIDW_BUF_SIZE_OFFSET(info->fix.line_length - pagewidth) |
 	       VIDW_BUF_SIZE_PAGEWIDTH(pagewidth);
-	writel(data, regs + VIDW_BUF_SIZE(win_no));
+	writel(data, regs + sfb->variant.buf_size + (win_no * 4));
 
 	/* write 'OSD' registers to control position of framebuffer */
 
 	data = VIDOSDxA_TOPLEFT_X(0) | VIDOSDxA_TOPLEFT_Y(0);
-	writel(data, regs + VIDOSD_A(win_no));
+	writel(data, regs + VIDOSD_A(win_no, sfb->variant));
 
 	data = VIDOSDxB_BOTRIGHT_X(s3c_fb_align_word(var->bits_per_pixel,
 						     var->xres - 1)) |
 	       VIDOSDxB_BOTRIGHT_Y(var->yres - 1);
 
-	writel(data, regs + VIDOSD_B(win_no));
+	writel(data, regs + VIDOSD_B(win_no, sfb->variant));
 
 	data = var->xres * var->yres;
 
@@ -407,10 +440,10 @@ static int s3c_fb_set_par(struct fb_info
 		VIDISD14C_ALPHA1_B(0xf);
 
 	if (win->variant.has_osd_d) {
-		writel(data, regs + VIDOSD_D(win_no));
-		writel(osdc_data, regs + VIDOSD_C(win_no));
+		writel(data, regs + VIDOSD_D(win_no, sfb->variant));
+		writel(osdc_data, regs + VIDOSD_C(win_no, sfb->variant));
 	} else
-		writel(data, regs + VIDOSD_C(win_no));
+		writel(data, regs + VIDOSD_C(win_no, sfb->variant));
 
 	data = WINCONx_ENWIN;
 
@@ -471,9 +504,10 @@ static int s3c_fb_set_par(struct fb_info
 		break;
 	}
 
-	/* It has no color key control register for window0 */
+	/* Enable the colour keying for the window below this one */
 	if (win_no > 0) {
 		u32 keycon0_data = 0, keycon1_data = 0;
+		void __iomem *keycon = regs + sfb->variant.keycon;
 
 		keycon0_data = ~(WxKEYCON0_KEYBL_EN |
 				WxKEYCON0_KEYEN_F |
@@ -481,12 +515,14 @@ static int s3c_fb_set_par(struct fb_info
 
 		keycon1_data = WxKEYCON1_COLVAL(0xffffff);
 
-		writel(keycon0_data, regs + WxKEYCONy(win_no-1, 0));
-		writel(keycon1_data, regs + WxKEYCONy(win_no-1, 1));
+		keycon += (win_no - 1) * 8;
+
+		writel(keycon0_data, keycon + WKEYCON0);
+		writel(keycon1_data, keycon + WKEYCON1);
 	}
 
-	writel(data, regs + WINCON(win_no));
-	writel(0x0, regs + WINxMAP(win_no));
+	writel(data, regs + sfb->variant.wincon + (win_no * 4));
+	writel(0x0, regs + sfb->variant.winmap + (win_no * 4));
 
 	return 0;
 }
@@ -634,7 +670,7 @@ static int s3c_fb_blank(int blank_mode, 
 
 	dev_dbg(sfb->dev, "blank mode %d\n", blank_mode);
 
-	wincon = readl(sfb->regs + WINCON(index));
+	wincon = readl(sfb->regs + sfb->variant.wincon + (index * 4));
 
 	switch (blank_mode) {
 	case FB_BLANK_POWERDOWN:
@@ -645,11 +681,11 @@ static int s3c_fb_blank(int blank_mode, 
 	case FB_BLANK_NORMAL:
 		/* disable the DMA and display 0x0 (black) */
 		writel(WINxMAP_MAP | WINxMAP_MAP_COLOUR(0x0),
-		       sfb->regs + WINxMAP(index));
+		       sfb->regs + sfb->variant.winmap + (index * 4));
 		break;
 
 	case FB_BLANK_UNBLANK:
-		writel(0x0, sfb->regs + WINxMAP(index));
+		writel(0x0, sfb->regs + sfb->variant.winmap + (index * 4));
 		wincon |= WINCONx_ENWIN;
 		sfb->enabled |= (1 << index);
 		break;
@@ -660,7 +696,7 @@ static int s3c_fb_blank(int blank_mode, 
 		return 1;
 	}
 
-	writel(wincon, sfb->regs + WINCON(index));
+	writel(wincon, sfb->regs + sfb->variant.wincon + (index * 4));
 
 	/* Check the enabled state to see if we need to be running the
 	 * main LCD interface, as if there are no active windows then
@@ -796,7 +832,7 @@ static int __devinit s3c_fb_probe_win(st
 	int palette_size;
 	int ret;
 
-	dev_dbg(sfb->dev, "probing window %d\n", win_no);
+	dev_dbg(sfb->dev, "probing window %d, variant %p\n", win_no, variant);
 
 	palette_size = variant->palette_sz * 4;
 
@@ -889,10 +925,10 @@ static void s3c_fb_clear_win(struct s3c_
 {
 	void __iomem *regs = sfb->regs;
 
-	writel(0, regs + WINCON(win));
-	writel(0, regs + VIDOSD_A(win));
-	writel(0, regs + VIDOSD_B(win));
-	writel(0, regs + VIDOSD_C(win));
+	writel(0, regs + sfb->variant.wincon + (win * 4));
+	writel(0, regs + VIDOSD_A(win, sfb->variant));
+	writel(0, regs + VIDOSD_B(win, sfb->variant));
+	writel(0, regs + VIDOSD_C(win, sfb->variant));
 }
 
 static int __devinit s3c_fb_probe(struct platform_device *pdev)
@@ -924,6 +960,8 @@ static int __devinit s3c_fb_probe(struct
 		return -ENOMEM;
 	}
 
+	dev_dbg(dev, "allocate new framebuffer %p\n", sfb);
+
 	sfb->dev = dev;
 	sfb->pdata = pd;
 	sfb->variant = fbdrv->variant;
@@ -973,8 +1011,11 @@ static int __devinit s3c_fb_probe(struct
 
 	/* initialise colour key controls */
 	for (win = 0; win < (fbdrv->variant.nr_windows - 1); win++) {
-		writel(0xffffff, sfb->regs + WxKEYCONy(win, 0));
-		writel(0xffffff, sfb->regs + WxKEYCONy(win, 1));
+		void __iomem *regs = sfb->regs + sfb->variant.keycon;
+
+		regs += (win * 8);
+		writel(0xffffff, regs + WKEYCON0);
+		writel(0xffffff, regs + WKEYCON1);
 	}
 
 	/* we have the register setup, start allocating framebuffers */
@@ -1079,8 +1120,11 @@ static int s3c_fb_resume(struct platform
 		s3c_fb_clear_win(sfb, win_no);
 
 	for (win_no = 0; win_no < sfb->variant.nr_windows - 1; win_no++) {
-		writel(0xffffff, sfb->regs + WxKEYCONy(win_no, 1));
-		writel(0xffffff, sfb->regs + WxKEYCONy(win_no, 1));
+		void __iomem *regs = sfb->regs + sfb->variant.keycon;
+
+		regs += (win_no * 8);
+		writel(0xffffff, regs + WKEYCON0);
+		writel(0xffffff, regs + WKEYCON1);
 	}
 
 	/* restore framebuffers */
@@ -1149,6 +1193,15 @@ static struct s3c_fb_win_variant s3c_fb_
 static struct s3c_fb_driverdata s3c_fb_data_64xx __devinitdata = {
 	.variant = {
 		.nr_windows	= 5,
+		.vidtcon	= VIDTCON0,
+		.wincon		= WINCON(0),
+		.winmap		= WINxMAP(0),
+		.keycon		= WKEYCON,
+		.osd		= VIDOSD_BASE,
+		.osd_stride	= 16,
+		.buf_start	= VIDW_BUF_START(0),
+		.buf_size	= VIDW_BUF_SIZE(0),
+		.buf_end	= VIDW_BUF_END(0),
 
 		.palette = {
 			[0] = 0x400,
@@ -1168,6 +1221,15 @@ static struct s3c_fb_driverdata s3c_fb_d
 static struct s3c_fb_driverdata s3c_fb_data_s5p __devinitdata = {
 	.variant = {
 		.nr_windows	= 5,
+		.vidtcon	= VIDTCON0,
+		.wincon		= WINCON(0),
+		.winmap		= WINxMAP(0),
+		.keycon		= WKEYCON,
+		.osd		= VIDOSD_BASE,
+		.osd_stride	= 16,
+		.buf_start	= VIDW_BUF_START(0),
+		.buf_size	= VIDW_BUF_SIZE(0),
+		.buf_end	= VIDW_BUF_END(0),
 
 		.palette = {
 			[0] = 0x2400,
@@ -1184,6 +1246,41 @@ static struct s3c_fb_driverdata s3c_fb_d
 	.win[4]	= &s3c_fb_data_64xx_wins[4],
 };
 
+/* S3C2443/S3C2416 style hardware */
+static struct s3c_fb_driverdata s3c_fb_data_s3c2443 __devinitdata = {
+	.variant = {
+		.nr_windows	= 2,
+		.is_2443	= 1,
+
+		.vidtcon	= 0x08,
+		.wincon		= 0x14,
+		.winmap		= 0xd0,
+		.keycon		= 0xb0,
+		.osd		= 0x28,
+		.osd_stride	= 12,
+		.buf_start	= 0x64,
+		.buf_size	= 0x94,
+		.buf_end	= 0x7c,
+
+		.palette = {
+			[0] = 0x400,
+			[1] = 0x800,
+		},
+	},
+	.win[0] = &(struct s3c_fb_win_variant) {
+		.palette_sz	= 256,
+		.valid_bpp	= VALID_BPP1248 | VALID_BPP(16) | VALID_BPP(24),
+	},
+	.win[1] = &(struct s3c_fb_win_variant) {
+		.has_osd_c	= 1,
+		.palette_sz	= 256,
+		.valid_bpp	= (VALID_BPP1248 | VALID_BPP(16) |
+				   VALID_BPP(18) | VALID_BPP(19) |
+				   VALID_BPP(24) | VALID_BPP(25) |
+				   VALID_BPP(28)),
+	},
+};
+
 static struct platform_device_id s3c_fb_driver_ids[] = {
 	{
 		.name		= "s3c-fb",
@@ -1191,6 +1288,9 @@ static struct platform_device_id s3c_fb_
 	}, {
 		.name		= "s5p-fb",
 		.driver_data	= (unsigned long)&s3c_fb_data_s5p,
+	}, {
+		.name		= "s3c2443-fb",
+		.driver_data	= (unsigned long)&s3c_fb_data_s3c2443,
 	},
 	{},
 };
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-fix-section-mismatch.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch
panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch

