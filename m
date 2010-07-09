From: akpm@linux-foundation.org
Subject: + s3c-fb-add-default-window-feature.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:08:46 -0700
Message-ID: <201007092308.o69N8kh0030942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653Ab0GIXJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: inki.dae@samsung.com, ben-linux@fluff.org, m.szyprowski@samsung.com, p.osciak@samsung.com


The patch titled
     s3c-fb: add default window feature.
has been added to the -mm tree.  Its filename is
     s3c-fb-add-default-window-feature.patch

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
Subject: s3c-fb: add default window feature.
From: InKi Dae <inki.dae@samsung.com>

s5pv210 has five window layers (window0 ~ 4), among them, window0 ~ 2
could be used for local path with fimc(capture device) and fimd writeback
feature so this patch makes default window layer for UI to be set at
machine code.

Signed-off-by: InKi Dae <inki.dae@samsung.com>
Reviewed-by: KyungMin Park <kyungmin.park.samsung.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/fb.h |    3 +++
 drivers/video/s3c-fb.c                  |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/arm/plat-samsung/include/plat/fb.h~s3c-fb-add-default-window-feature arch/arm/plat-samsung/include/plat/fb.h
--- a/arch/arm/plat-samsung/include/plat/fb.h~s3c-fb-add-default-window-feature
+++ a/arch/arm/plat-samsung/include/plat/fb.h
@@ -42,6 +42,7 @@ struct s3c_fb_pd_win {
  * @setup_gpio: Setup the external GPIO pins to the right state to transfer
  *		the data from the display system to the connected display
  *		device.
+ * @default_win: default window layer number to be used for UI layer.
  * @vidcon0: The base vidcon0 values to control the panel data format.
  * @vidcon1: The base vidcon1 values to control the panel data output.
  * @win: The setup data for each hardware window, or NULL for unused.
@@ -58,6 +59,8 @@ struct s3c_fb_platdata {
 
 	struct s3c_fb_pd_win	*win[S3C_FB_MAX_WIN];
 
+	u32			 default_win;
+
 	u32			 vidcon0;
 	u32			 vidcon1;
 };
diff -puN drivers/video/s3c-fb.c~s3c-fb-add-default-window-feature drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-add-default-window-feature
+++ a/drivers/video/s3c-fb.c
@@ -300,9 +300,9 @@ static int s3c_fb_set_par(struct fb_info
 	/* disable the window whilst we update it */
 	writel(0, regs + WINCON(win_no));
 
-	/* use window 0 as the basis for the lcd output timings */
+	/* use platform specified window as the basis for the lcd timings */
 
-	if (win_no == 0) {
+	if (win_no == sfb->pdata->default_win) {
 		clkdiv = s3c_fb_calc_pixclk(sfb, var->pixclock);
 
 		data = sfb->pdata->vidcon0;
@@ -636,7 +636,7 @@ static int s3c_fb_blank(int blank_mode, 
 	/* we're stuck with this until we can do something about overriding
 	 * the power control using the blanking event for a single fb.
 	 */
-	if (index == 0)
+	if (index == sfb->pdata->default_win)
 		s3c_fb_enable(sfb, blank_mode != FB_BLANK_POWERDOWN ? 1 : 0);
 
 	return 0;
_

Patches currently in -mm which might be from inki.dae@samsung.com are

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

