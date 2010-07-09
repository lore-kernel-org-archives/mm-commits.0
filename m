From: akpm@linux-foundation.org
Subject: + s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:09:13 -0700
Message-ID: <201007092309.o69N9DEU030990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755553Ab0GIXJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com


The patch titled
     s3c-fb: add SHADOWCON shadow register locking support for S5PV210
has been added to the -mm tree.  Its filename is
     s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch

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
Subject: s3c-fb: add SHADOWCON shadow register locking support for S5PV210
From: Pawel Osciak <p.osciak@samsung.com>

S5PV210 allows per-window locking of register value updates from shadow
registers.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/regs-fb.h |    3 +
 drivers/video/s3c-fb.c                       |   40 +++++++++++++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

diff -puN arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210 arch/arm/plat-samsung/include/plat/regs-fb.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210
+++ a/arch/arm/plat-samsung/include/plat/regs-fb.h
@@ -220,6 +220,9 @@
 #define WINCON1_BPPMODE_25BPP_A1888		(0xd << 2)
 #define WINCON1_BPPMODE_28BPP_A4888		(0xd << 2)
 
+/* S5PV210 */
+#define SHADOWCON				(0x34)
+#define SHADOWCON_WINx_PROTECT(_win)		(1 << (10 + (_win)))
 
 #define VIDOSDxA_TOPLEFT_X_MASK			(0x7ff << 11)
 #define VIDOSDxA_TOPLEFT_X_SHIFT		(11)
diff -puN drivers/video/s3c-fb.c~s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210 drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210
+++ a/drivers/video/s3c-fb.c
@@ -79,6 +79,7 @@ struct s3c_fb;
  * @osd: The base for the OSD registers.
  * @palette: Address of palette memory, or 0 if none.
  * @has_prtcon: Set if has PRTCON register.
+ * @has_shadowcon: Set if has SHADOWCON register.
  */
 struct s3c_fb_variant {
 	unsigned int	is_2443:1;
@@ -95,6 +96,7 @@ struct s3c_fb_variant {
 	unsigned short	palette[S3C_FB_MAX_WIN];
 
 	unsigned int	has_prtcon:1;
+	unsigned int	has_shadowcon:1;
 };
 
 /**
@@ -363,6 +365,36 @@ static int s3c_fb_align_word(unsigned in
 }
 
 /**
+ * shadow_protect_win() - disable updating values from shadow registers at vsync
+ *
+ * @win: window to protect registers for
+ * @protect: 1 to protect (disable updates)
+ */
+static void shadow_protect_win(struct s3c_fb_win *win, bool protect)
+{
+	struct s3c_fb *sfb = win->parent;
+	u32 reg;
+
+	if (protect) {
+		if (sfb->variant.has_prtcon) {
+			writel(PRTCON_PROTECT, sfb->regs + PRTCON);
+		} else if (sfb->variant.has_shadowcon) {
+			reg = readl(sfb->regs + SHADOWCON);
+			writel(reg | SHADOWCON_WINx_PROTECT(win->index),
+				sfb->regs + SHADOWCON);
+		}
+	} else {
+		if (sfb->variant.has_prtcon) {
+			writel(0, sfb->regs + PRTCON);
+		} else if (sfb->variant.has_shadowcon) {
+			reg = readl(sfb->regs + SHADOWCON);
+			writel(reg & ~SHADOWCON_WINx_PROTECT(win->index),
+				sfb->regs + SHADOWCON);
+		}
+	}
+}
+
+/**
  * s3c_fb_set_par() - framebuffer request to set new framebuffer state.
  * @info: The framebuffer to change.
  *
@@ -810,14 +842,12 @@ static int s3c_fb_pan_display(struct fb_
 
 	/* Temporarily turn off per-vsync update from shadow registers until
 	 * both start and end addresses are updated to prevent corruption */
-	if (sfb->variant.has_prtcon)
-		writel(PRTCON_PROTECT, sfb->regs + PRTCON);
+	shadow_protect_win(win, 1);
 
 	writel(info->fix.smem_start + start_boff, buf + sfb->variant.buf_start);
 	writel(info->fix.smem_start + end_boff, buf + sfb->variant.buf_end);
 
-	if (sfb->variant.has_prtcon)
-		writel(0, sfb->regs + PRTCON);
+	shadow_protect_win(win, 0);
 
 	return 0;
 }
@@ -1530,6 +1560,8 @@ static struct s3c_fb_driverdata s3c_fb_d
 			[3] = 0x3000,
 			[4] = 0x3400,
 		},
+
+		.has_shadowcon	= 1,
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

