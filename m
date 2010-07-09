From: akpm@linux-foundation.org
Subject: + s3c-fb-add-support-for-display-panning.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:09:07 -0700
Message-ID: <201007092309.o69N97SM030980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab0GIXJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com


The patch titled
     s3c-fb: add support for display panning
has been added to the -mm tree.  Its filename is
     s3c-fb-add-support-for-display-panning.patch

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
Subject: s3c-fb: add support for display panning
From: Pawel Osciak <p.osciak@samsung.com>

Supports all bpp modes.

The PRTCON register is used to disable in-hardware updates of registers
that store start and end addresses of framebuffer memory.  This prevents
display corruption in case we do not make it before VSYNC with updating
them atomically.  With this feature there is no need to wait for a VSYNC
interrupt before each such update.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/regs-fb.h |    7 +
 drivers/video/s3c-fb.c                       |   68 +++++++++++++++++
 2 files changed, 75 insertions(+)

diff -puN arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-support-for-display-panning arch/arm/plat-samsung/include/plat/regs-fb.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-support-for-display-panning
+++ a/arch/arm/plat-samsung/include/plat/regs-fb.h
@@ -112,6 +112,13 @@
 #define VIDCON2_ORGYCbCr			(1 << 8)
 #define VIDCON2_YUVORDCrCb			(1 << 7)
 
+/* PRTCON (S3C6410, S5PC100)
+ * Might not be present in the S3C6410 documentation,
+ * but tests prove it's there almost for sure; shouldn't hurt in any case.
+ */
+#define PRTCON					(0x0c)
+#define PRTCON_PROTECT				(1 << 11)
+
 /* VIDTCON0 */
 
 #define VIDTCON0_VBPDE_MASK			(0xff << 24)
diff -puN drivers/video/s3c-fb.c~s3c-fb-add-support-for-display-panning drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-add-support-for-display-panning
+++ a/drivers/video/s3c-fb.c
@@ -71,6 +71,7 @@ struct s3c_fb;
  * @buf_end: Offset of buffer end registers.
  * @osd: The base for the OSD registers.
  * @palette: Address of palette memory, or 0 if none.
+ * @has_prtcon: Set if has PRTCON register.
  */
 struct s3c_fb_variant {
 	unsigned int	is_2443:1;
@@ -85,6 +86,8 @@ struct s3c_fb_variant {
 	unsigned short	osd;
 	unsigned short	osd_stride;
 	unsigned short	palette[S3C_FB_MAX_WIN];
+
+	unsigned int	has_prtcon:1;
 };
 
 /**
@@ -379,6 +382,9 @@ static int s3c_fb_set_par(struct fb_info
 
 	info->fix.line_length = (var->xres_virtual * var->bits_per_pixel) / 8;
 
+	info->fix.xpanstep = info->var.xres_virtual > info->var.xres ? 1 : 0;
+	info->fix.ypanstep = info->var.yres_virtual > info->var.yres ? 1 : 0;
+
 	/* disable the window whilst we update it */
 	writel(0, regs + WINCON(win_no));
 
@@ -735,6 +741,63 @@ static int s3c_fb_blank(int blank_mode, 
 	return 0;
 }
 
+/**
+ * s3c_fb_pan_display() - Pan the display.
+ *
+ * Note that the offsets can be written to the device at any time, as their
+ * values are latched at each vsync automatically. This also means that only
+ * the last call to this function will have any effect on next vsync, but
+ * there is no need to sleep waiting for it to prevent tearing.
+ *
+ * @var: The screen information to verify.
+ * @info: The framebuffer device.
+ */
+static int s3c_fb_pan_display(struct fb_var_screeninfo *var,
+			      struct fb_info *info)
+{
+	struct s3c_fb_win *win	= info->par;
+	struct s3c_fb *sfb	= win->parent;
+	void __iomem *buf	= sfb->regs + win->index * 8;
+	unsigned int start_boff, end_boff;
+
+	/* Offset in bytes to the start of the displayed area */
+	start_boff = var->yoffset * info->fix.line_length;
+	/* X offset depends on the current bpp */
+	if (info->var.bits_per_pixel >= 8) {
+		start_boff += var->xoffset * (info->var.bits_per_pixel >> 3);
+	} else {
+		switch (info->var.bits_per_pixel) {
+		case 4:
+			start_boff += var->xoffset >> 1;
+			break;
+		case 2:
+			start_boff += var->xoffset >> 2;
+			break;
+		case 1:
+			start_boff += var->xoffset >> 3;
+			break;
+		default:
+			dev_err(sfb->dev, "invalid bpp\n");
+			return -EINVAL;
+		}
+	}
+	/* Offset in bytes to the end of the displayed area */
+	end_boff = start_boff + var->yres * info->fix.line_length;
+
+	/* Temporarily turn off per-vsync update from shadow registers until
+	 * both start and end addresses are updated to prevent corruption */
+	if (sfb->variant.has_prtcon)
+		writel(PRTCON_PROTECT, sfb->regs + PRTCON);
+
+	writel(info->fix.smem_start + start_boff, buf + sfb->variant.buf_start);
+	writel(info->fix.smem_start + end_boff, buf + sfb->variant.buf_end);
+
+	if (sfb->variant.has_prtcon)
+		writel(0, sfb->regs + PRTCON);
+
+	return 0;
+}
+
 static struct fb_ops s3c_fb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_check_var	= s3c_fb_check_var,
@@ -744,6 +807,7 @@ static struct fb_ops s3c_fb_ops = {
 	.fb_fillrect	= cfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
+	.fb_pan_display	= s3c_fb_pan_display,
 };
 
 /**
@@ -1243,6 +1307,8 @@ static struct s3c_fb_driverdata s3c_fb_d
 			[3] = 0x320,
 			[4] = 0x340,
 		},
+
+		.has_prtcon	= 1,
 	},
 	.win[0]	= &s3c_fb_data_64xx_wins[0],
 	.win[1]	= &s3c_fb_data_64xx_wins[1],
@@ -1271,6 +1337,8 @@ static struct s3c_fb_driverdata s3c_fb_d
 			[3] = 0x3000,
 			[4] = 0x3400,
 		},
+
+		.has_prtcon	= 1,
 	},
 	.win[0]	= &s3c_fb_data_64xx_wins[0],
 	.win[1]	= &s3c_fb_data_64xx_wins[1],
_

Patches currently in -mm which might be from p.osciak@samsung.com are

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
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

