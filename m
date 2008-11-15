From: akpm@linux-foundation.org
Subject: + tmiofb-fix-compilation-with-accel-disabled.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:27:37 -0800
Message-ID: <200811150027.mAF0Rbgp019773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbYKOA2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     tmiofb: fix compilation with ACCEL disabled
has been added to the -mm tree.  Its filename is
     tmiofb-fix-compilation-with-accel-disabled.patch

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

tmiofb-fix-compilation-with-accel-disabled.patch

