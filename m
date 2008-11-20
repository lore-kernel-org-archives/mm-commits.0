From: akpm@linux-foundation.org
Subject: - tmiofb-fix-compilation-with-accel-disabled.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:31 -0800
Message-ID: <200811202042.mAKKgVCA006997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755437AbYKTUsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:48:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     tmiofb: fix compilation with ACCEL disabled
has been removed from the -mm tree.  Its filename was
     tmiofb-fix-compilation-with-accel-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmiofb: fix compilation with ACCEL disabled
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Restore support for compiling tmiofb with acceleration disabled.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tmiofb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/video/tmiofb.c~tmiofb-fix-compilation-with-accel-disabled drivers/video/tmiofb.c
--- a/drivers/video/tmiofb.c~tmiofb-fix-compilation-with-accel-disabled
+++ a/drivers/video/tmiofb.c
@@ -222,6 +222,9 @@ static irqreturn_t tmiofb_irq(int irq, v
 	unsigned int bbisc = tmio_ioread16(par->lcr + LCR_BBISC);
 
 
+	tmio_iowrite16(bbisc, par->lcr + LCR_BBISC);
+
+#ifdef CONFIG_FB_TMIO_ACCELL
 	/*
 	 * We were in polling mode and now we got correct irq.
 	 * Switch back to IRQ-based sync of command FIFO
@@ -231,9 +234,6 @@ static irqreturn_t tmiofb_irq(int irq, v
 		par->use_polling = false;
 	}
 
-	tmio_iowrite16(bbisc, par->lcr + LCR_BBISC);
-
-#ifdef CONFIG_FB_TMIO_ACCELL
 	if (bbisc & 1)
 		wake_up(&par->wait_acc);
 #endif
@@ -938,7 +938,9 @@ static void tmiofb_dump_regs(struct plat
 static int tmiofb_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
+#ifdef CONFIG_FB_TMIO_ACCELL
 	struct tmiofb_par *par = info->par;
+#endif
 	struct mfd_cell *cell = dev->dev.platform_data;
 	int retval = 0;
 
@@ -950,12 +952,14 @@ static int tmiofb_suspend(struct platfor
 		info->fbops->fb_sync(info);
 
 
+#ifdef CONFIG_FB_TMIO_ACCELL
 	/*
 	 * The fb should be usable even if interrupts are disabled (and they are
 	 * during suspend/resume). Switch temporary to forced polling.
 	 */
 	printk(KERN_INFO "tmiofb: switching to polling\n");
 	par->use_polling = true;
+#endif
 	tmiofb_hw_stop(dev);
 
 	if (cell->suspend)
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

origin.patch

