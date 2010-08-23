From: akpm@linux-foundation.org
Subject: + rtc-bfin-add-debug-markers-to-suspend-resume-paths.patch added to -mm tree
Date: Mon, 23 Aug 2010 12:15:42 -0700
Message-ID: <201008231915.o7NJFgEx009667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754346Ab0HWTQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 15:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it


The patch titled
     rtc-bfin: add debug markers to suspend/resume paths
has been added to the -mm tree.  Its filename is
     rtc-bfin-add-debug-markers-to-suspend-resume-paths.patch

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
Subject: rtc-bfin: add debug markers to suspend/resume paths
From: Mike Frysinger <vapier@gentoo.org>

The rest of the driver had debug markings already.  This also standardizes
the usage of "dev" a bit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~rtc-bfin-add-debug-markers-to-suspend-resume-paths drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-bfin-add-debug-markers-to-suspend-resume-paths
+++ a/drivers/rtc/rtc-bfin.c
@@ -2,7 +2,7 @@
  * Blackfin On-Chip Real Time Clock Driver
  *  Supports BF51x/BF52x/BF53[123]/BF53[467]/BF54x
  *
- * Copyright 2004-2009 Analog Devices Inc.
+ * Copyright 2004-2010 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -427,9 +427,13 @@ static int __devexit bfin_rtc_remove(str
 #ifdef CONFIG_PM
 static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	if (device_may_wakeup(&pdev->dev)) {
+	struct device *dev = &pdev->dev;
+
+	dev_dbg_stamp(dev);
+
+	if (device_may_wakeup(dev)) {
 		enable_irq_wake(IRQ_RTC);
-		bfin_rtc_sync_pending(&pdev->dev);
+		bfin_rtc_sync_pending(dev);
 	} else
 		bfin_rtc_int_clear(0);
 
@@ -438,7 +442,11 @@ static int bfin_rtc_suspend(struct platf
 
 static int bfin_rtc_resume(struct platform_device *pdev)
 {
-	if (device_may_wakeup(&pdev->dev))
+	struct device *dev = &pdev->dev;
+
+	dev_dbg_stamp(dev);
+
+	if (device_may_wakeup(dev))
 		disable_irq_wake(IRQ_RTC);
 
 	/*
_

Patches currently in -mm which might be from vapier@gentoo.org are

rtc-bfin-fix-inverted-logic-in-suspend-path.patch
rtc-bfin-fix-state-restoration-when-resuming.patch
linux-next.patch
m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch
rtc-bfin-shrink-optimize-interrupt-handler-a-bit.patch
rtc-bfin-add-debug-markers-to-suspend-resume-paths.patch

