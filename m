From: akpm@linux-foundation.org
Subject: + s3c-fb-automatically-calculate-pixel-clock-when-none-is-given.patch added to -mm tree
Date: Thu, 15 Jul 2010 12:36:20 -0700
Message-ID: <201007151936.o6FJaKPX015165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934474Ab0GOTgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 15:36:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuelenaere@gmail.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, p.osciak@samsung.com, rmk@arm.linux.org.uk


The patch titled
     s3c-fb: automatically calculate pixel clock when none is given
has been added to the -mm tree.  Its filename is
     s3c-fb-automatically-calculate-pixel-clock-when-none-is-given.patch

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
Subject: s3c-fb: automatically calculate pixel clock when none is given
From: Maurus Cuelenaere <mcuelenaere@gmail.com>

Add a simple algorithm which calculates the pixel clock based on the video
mode parameters.  This is only done when no pixel clock is supplied
through the platform data.

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: Pawel Osciak <p.osciak@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN drivers/video/s3c-fb.c~s3c-fb-automatically-calculate-pixel-clock-when-none-is-given drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-automatically-calculate-pixel-clock-when-none-is-given
+++ a/drivers/video/s3c-fb.c
@@ -1027,6 +1027,28 @@ static struct fb_ops s3c_fb_ops = {
 };
 
 /**
+ * s3c_fb_missing_pixclock() - calculates pixel clock
+ * @mode: The video mode to change.
+ *
+ * Calculate the pixel clock when none has been given through platform data.
+ */
+static void __devinit s3c_fb_missing_pixclock(struct fb_videomode *mode)
+{
+	u64 pixclk = 1000000000000ULL;
+	u32 div;
+
+	div  = mode->left_margin + mode->hsync_len + mode->right_margin +
+	       mode->xres;
+	div *= mode->upper_margin + mode->vsync_len + mode->lower_margin +
+	       mode->yres;
+	div *= mode->refresh ? : 60;
+
+	do_div(pixclk, div);
+
+	mode->pixclock = pixclk;
+}
+
+/**
  * s3c_fb_alloc_memory() - allocate display memory for framebuffer window
  * @sfb: The base resources for the hardware.
  * @win: The window to initialise memory for.
@@ -1364,6 +1386,9 @@ static int __devinit s3c_fb_probe(struct
 		if (!pd->win[win])
 			continue;
 
+		if (!pd->win[win]->win_mode.pixclock)
+			s3c_fb_missing_pixclock(&pd->win[win]->win_mode);
+
 		ret = s3c_fb_probe_win(sfb, win, fbdrv->win[win],
 				       &sfb->windows[win]);
 		if (ret < 0) {
_

Patches currently in -mm which might be from mcuelenaere@gmail.com are

linux-next.patch
s3c-fb-automatically-calculate-pixel-clock-when-none-is-given.patch
arm-samsung-remove-pixclock-from-several-boards.patch

