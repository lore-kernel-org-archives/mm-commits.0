From: akpm@linux-foundation.org
Subject: - s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:58 -0700
Message-ID: <200805270727.m4R7RwaA014805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756147AbYE0H3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-fbdev@fluff.org, arnaud.patard@rtp-net.org, ben-linux@fluff.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     S3C2410: ensure that FB_BLANK_POWERDOWN shuts down the controller
has been removed from the -mm tree.  Its filename was
     s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: S3C2410: ensure that FB_BLANK_POWERDOWN shuts down the controller
From: Ben Dooks <ben-fbdev@fluff.org>

When a blank level of FB_BLANK_POWERDOWN is used, we should shut down the
controller so that it no longer tries to produce any panel signals or
data, and shuts down the DMA which is not needed.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   49 +++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller
+++ a/drivers/video/s3c2410fb.c
@@ -580,6 +580,27 @@ static int s3c2410fb_setcolreg(unsigned 
 	return 0;
 }
 
+/* s3c2410fb_lcd_enable
+ *
+ * shutdown the lcd controller
+ */
+static void s3c2410fb_lcd_enable(struct s3c2410fb_info *fbi, int enable)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (enable)
+		fbi->regs.lcdcon1 |= S3C2410_LCDCON1_ENVID;
+	else
+		fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_ENVID;
+
+	writel(fbi->regs.lcdcon1, fbi->io + S3C2410_LCDCON1);
+
+	local_irq_restore(flags);
+}
+
+
 /*
  *      s3c2410fb_blank
  *	@blank_mode: the blank mode we want.
@@ -589,9 +610,6 @@ static int s3c2410fb_setcolreg(unsigned 
  *	blanking succeeded, != 0 if un-/blanking failed due to e.g. a
  *	video mode which doesn't support it. Implements VESA suspend
  *	and powerdown modes on hardware that supports disabling hsync/vsync:
- *	blank_mode == 2: suspend vsync
- *	blank_mode == 3: suspend hsync
- *	blank_mode == 4: powerdown
  *
  *	Returns negative errno on error, or zero on success.
  *
@@ -605,6 +623,12 @@ static int s3c2410fb_blank(int blank_mod
 
 	tpal_reg += is_s3c2412(fbi) ? S3C2412_TPAL : S3C2410_TPAL;
 
+	if (blank_mode == FB_BLANK_POWERDOWN) {
+		s3c2410fb_lcd_enable(fbi, 0);
+	} else {
+		s3c2410fb_lcd_enable(fbi, 1);
+	}
+
 	if (blank_mode == FB_BLANK_UNBLANK)
 		writel(0x0, tpal_reg);
 	else {
@@ -983,21 +1007,6 @@ static int __init s3c2412fb_probe(struct
 	return s3c24xxfb_probe(pdev, DRV_S3C2412);
 }
 
-/* s3c2410fb_stop_lcd
- *
- * shutdown the lcd controller
- */
-static void s3c2410fb_stop_lcd(struct s3c2410fb_info *fbi)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_ENVID;
-	writel(fbi->regs.lcdcon1, fbi->io + S3C2410_LCDCON1);
-
-	local_irq_restore(flags);
-}
 
 /*
  *  Cleanup
@@ -1010,7 +1019,7 @@ static int s3c2410fb_remove(struct platf
 
 	unregister_framebuffer(fbinfo);
 
-	s3c2410fb_stop_lcd(info);
+	s3c2410fb_lcd_enable(info, 0);
 	msleep(1);
 
 	s3c2410fb_unmap_video_memory(fbinfo);
@@ -1043,7 +1052,7 @@ static int s3c2410fb_suspend(struct plat
 	struct fb_info	   *fbinfo = platform_get_drvdata(dev);
 	struct s3c2410fb_info *info = fbinfo->par;
 
-	s3c2410fb_stop_lcd(info);
+	s3c2410fb_lcd_enable(info, 0);
 
 	/* sleep before disabling the clock, we need to ensure
 	 * the LCD DMA engine is not going to get back on the bus
_

Patches currently in -mm which might be from ben-fbdev@fluff.org are


