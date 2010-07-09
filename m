From: akpm@linux-foundation.org
Subject: + s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:08:50 -0700
Message-ID: <201007092308.o69N8oPU030949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab0GIXJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, inki.dae@samsung.com, m.szyprowski@samsung.com, p.osciak@samsung.com


The patch titled
     s3c-fb: only init window colour key controls for windows with blending
has been added to the -mm tree.  Its filename is
     s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch

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
Subject: s3c-fb: only init window colour key controls for windows with blending
From: Ben Dooks <ben-linux@fluff.org>

The driver clears all windows, but also sets the windows' colour key
controls at the same time.  However, the last window does not have these
registers as it is always blended into the previous window.

Move the colour key initialisation into the probe, and run it for only
nr_win-1 windows.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: KyungMin Park <kyungmin.park.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/video/s3c-fb.c~s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending
+++ a/drivers/video/s3c-fb.c
@@ -845,9 +845,6 @@ static void s3c_fb_clear_win(struct s3c_
 	void __iomem *regs = sfb->regs;
 
 	writel(0, regs + WINCON(win));
-	writel(0xffffff, regs + WxKEYCONy(win, 0));
-	writel(0xffffff, regs + WxKEYCONy(win, 1));
-
 	writel(0, regs + VIDOSD_A(win));
 	writel(0, regs + VIDOSD_B(win));
 	writel(0, regs + VIDOSD_C(win));
@@ -920,6 +917,12 @@ static int __devinit s3c_fb_probe(struct
 	for (win = 0; win < S3C_FB_MAX_WIN; win++)
 		s3c_fb_clear_win(sfb, win);
 
+	/* initialise colour key controls */
+	for (win = 0; win < (S3C_FB_MAX_WIN - 1); win++) {
+		writel(0xffffff, sfb->regs + WxKEYCONy(win, 0));
+		writel(0xffffff, sfb->regs + WxKEYCONy(win, 1));
+	}
+
 	/* we have the register setup, start allocating framebuffers */
 
 	for (win = 0; win < S3C_FB_MAX_WIN; win++) {
@@ -1020,6 +1023,11 @@ static int s3c_fb_resume(struct platform
 	for (win_no = 0; win_no < S3C_FB_MAX_WIN; win_no++)
 		s3c_fb_clear_win(sfb, win_no);
 
+	for (win_no = 0; win_no < S3C_FB_MAX_WIN - 1; win_no++) {
+		writel(0xffffff, sfb->regs + WxKEYCONy(win_no, 1));
+		writel(0xffffff, sfb->regs + WxKEYCONy(win_no, 1));
+	}
+
 	/* restore framebuffers */
 	for (win_no = 0; win_no < S3C_FB_MAX_WIN; win_no++) {
 		win = sfb->windows[win_no];
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

