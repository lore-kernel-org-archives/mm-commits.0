From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:36 -0700
Message-ID: <200808062056.m76KuaBH014684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758306AbYHFU5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     blackfin RTC driver: wait for the write complete interrupt complete before sleeping
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin RTC driver: wait for the write complete interrupt complete before sleeping
From: Mike Frysinger <vapier.adi@gmail.com>

Since we use the write complete interrupt, wait for it
to complete before sleeping so we don't wake right back up due to it

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping
+++ a/drivers/rtc/rtc-bfin.c
@@ -435,9 +435,10 @@ static int __devexit bfin_rtc_remove(str
 #ifdef CONFIG_PM
 static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev)) {
 		enable_irq_wake(IRQ_RTC);
-	else
+		bfin_rtc_sync_pending(&pdev->dev);
+	} else
 		bfin_rtc_int_clear(-1);
 
 	return 0;
_

Patches currently in -mm which might be from vapier.adi@gmail.com are


