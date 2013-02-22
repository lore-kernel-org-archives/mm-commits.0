From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-wm831x-use-devm_request_threaded_irq.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:45:02 -0800
Message-ID: <20130222204502.EB2D15A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:63073 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3BVUpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:45:03 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so104051qcs.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:45:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-wm831x: use devm_request_threaded_irq()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-wm831x-use-devm_request_threaded_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-wm831x: use devm_request_threaded_irq()

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm831x.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-wm831x.c~rtc-rtc-wm831x-use-devm_request_threaded_irq drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~rtc-rtc-wm831x-use-devm_request_threaded_irq
+++ a/drivers/rtc/rtc-wm831x.c
@@ -443,9 +443,10 @@ static int wm831x_rtc_probe(struct platf
 		goto err;
 	}
 
-	ret = request_threaded_irq(alm_irq, NULL, wm831x_alm_irq,
-				   IRQF_TRIGGER_RISING, "RTC alarm",
-				   wm831x_rtc);
+	ret = devm_request_threaded_irq(&pdev->dev, alm_irq, NULL,
+				wm831x_alm_irq,
+				IRQF_TRIGGER_RISING, "RTC alarm",
+				wm831x_rtc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
 			alm_irq, ret);
@@ -462,9 +463,7 @@ err:
 static int wm831x_rtc_remove(struct platform_device *pdev)
 {
 	struct wm831x_rtc *wm831x_rtc = platform_get_drvdata(pdev);
-	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 
-	free_irq(alm_irq, wm831x_rtc);
 	rtc_device_unregister(wm831x_rtc->rtc);
 
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

