From: akpm@linux-foundation.org
Subject: + s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:09:21 -0700
Message-ID: <201007092309.o69N9LRL031009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669Ab0GIXJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com


The patch titled
     s3c-fb: add support for DMA channel control on S5PV210
has been added to the -mm tree.  Its filename is
     s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

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
Subject: s3c-fb: add support for DMA channel control on S5PV210
From: Pawel Osciak <p.osciak@samsung.com>

S5PV210 SoCs allow enabling/disabling DMA channels per window.  For a
window to display data from framebuffer memory, its channel has to be
enabled.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/regs-fb.h |    4 ++++
 drivers/video/s3c-fb.c                       |   15 +++++++++++++++
 2 files changed, 19 insertions(+)

diff -puN arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-support-for-dma-channel-control-on-s5pv210 arch/arm/plat-samsung/include/plat/regs-fb.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-support-for-dma-channel-control-on-s5pv210
+++ a/arch/arm/plat-samsung/include/plat/regs-fb.h
@@ -223,6 +223,10 @@
 /* S5PV210 */
 #define SHADOWCON				(0x34)
 #define SHADOWCON_WINx_PROTECT(_win)		(1 << (10 + (_win)))
+/* DMA channels (all windows) */
+#define SHADOWCON_CHx_ENABLE(_win)		(1 << (_win))
+/* Local input channels (windows 0-2) */
+#define SHADOWCON_CHx_LOCAL_ENABLE(_win)	(1 << (5 + (_win)))
 
 #define VIDOSDxA_TOPLEFT_X_MASK			(0x7ff << 11)
 #define VIDOSDxA_TOPLEFT_X_SHIFT		(11)
diff -puN drivers/video/s3c-fb.c~s3c-fb-add-support-for-dma-channel-control-on-s5pv210 drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-add-support-for-dma-channel-control-on-s5pv210
+++ a/drivers/video/s3c-fb.c
@@ -634,6 +634,13 @@ static int s3c_fb_set_par(struct fb_info
 	writel(data, regs + sfb->variant.wincon + (win_no * 4));
 	writel(0x0, regs + sfb->variant.winmap + (win_no * 4));
 
+	/* Enable DMA channel for this window */
+	if (sfb->variant.has_shadowcon) {
+		data = readl(sfb->regs + SHADOWCON);
+		data |= SHADOWCON_CHx_ENABLE(win_no);
+		writel(data, sfb->regs + SHADOWCON);
+	}
+
 	shadow_protect_win(win, 0);
 
 	return 0;
@@ -1091,7 +1098,15 @@ static void s3c_fb_free_memory(struct s3
  */
 static void s3c_fb_release_win(struct s3c_fb *sfb, struct s3c_fb_win *win)
 {
+	u32 data;
+
 	if (win->fbinfo) {
+		if (sfb->variant.has_shadowcon) {
+			data = readl(sfb->regs + SHADOWCON);
+			data &= ~SHADOWCON_CHx_ENABLE(win->index);
+			data &= ~SHADOWCON_CHx_LOCAL_ENABLE(win->index);
+			writel(data, sfb->regs + SHADOWCON);
+		}
 		unregister_framebuffer(win->fbinfo);
 		if (win->fbinfo->cmap.len)
 			fb_dealloc_cmap(&win->fbinfo->cmap);
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

