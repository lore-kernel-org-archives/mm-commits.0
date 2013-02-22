From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max8907-use-devm_request_threaded_irq.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:45:08 -0800
Message-ID: <20130222204508.9909531C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:59010 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3BVUpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:45:09 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so104253ghb.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:45:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-max8907: use devm_request_threaded_irq()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max8907-use-devm_request_threaded_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-max8907: use devm_request_threaded_irq()

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8907.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-max8907.c~rtc-rtc-max8907-use-devm_request_threaded_irq drivers/rtc/rtc-max8907.c
--- a/drivers/rtc/rtc-max8907.c~rtc-rtc-max8907-use-devm_request_threaded_irq
+++ a/drivers/rtc/rtc-max8907.c
@@ -205,8 +205,9 @@ static int max8907_rtc_probe(struct plat
 		goto err_unregister;
 	}
 
-	ret = request_threaded_irq(rtc->irq, NULL, max8907_irq_handler,
-				   IRQF_ONESHOT, "max8907-alarm0", rtc);
+	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+				max8907_irq_handler,
+				IRQF_ONESHOT, "max8907-alarm0", rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request IRQ%d: %d\n",
 			rtc->irq, ret);
@@ -224,7 +225,6 @@ static int max8907_rtc_remove(struct pla
 {
 	struct max8907_rtc *rtc = platform_get_drvdata(pdev);
 
-	free_irq(rtc->irq, rtc);
 	rtc_device_unregister(rtc->rtc_dev);
 
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

