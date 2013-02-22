From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tps80031-use-devm_request_threaded_irq.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:59 -0800
Message-ID: <20130222204459.9096431C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:53685 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3BVUpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:45:00 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103944vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:45:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tps80031: use devm_request_threaded_irq()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tps80031-use-devm_request_threaded_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tps80031: use devm_request_threaded_irq()

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps80031.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-tps80031.c~rtc-rtc-tps80031-use-devm_request_threaded_irq drivers/rtc/rtc-tps80031.c
--- a/drivers/rtc/rtc-tps80031.c~rtc-rtc-tps80031-use-devm_request_threaded_irq
+++ a/drivers/rtc/rtc-tps80031.c
@@ -285,7 +285,8 @@ static int tps80031_rtc_probe(struct pla
 		return ret;
 	}
 
-	ret = request_threaded_irq(rtc->irq, NULL, tps80031_rtc_irq,
+	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+			tps80031_rtc_irq,
 			IRQF_ONESHOT | IRQF_EARLY_RESUME,
 			dev_name(&pdev->dev), rtc);
 	if (ret < 0) {
@@ -302,7 +303,6 @@ static int tps80031_rtc_remove(struct pl
 {
 	struct tps80031_rtc *rtc = platform_get_drvdata(pdev);
 
-	free_irq(rtc->irq, rtc);
 	rtc_device_unregister(rtc->rtc);
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

