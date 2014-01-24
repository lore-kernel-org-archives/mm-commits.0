From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:02:26 -0800
Message-ID: <52e2b8c2.SfNK7Z6kkN/q3/pG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbaAXTC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, ldewangan@nvidia.com

Subject: [merged] drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch removed from -mm tree
To: ldewangan@nvidia.com,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:26 -0800


The patch titled
     Subject: drivers/rtc/rtc-as3722: use devm for rtc and irq registration
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-as3722: use devm for rtc and irq registration

Use devm_* calls for rtc and irq registration and get rid of
remove callback for platform driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-as3722.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff -puN drivers/rtc/rtc-as3722.c~drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration drivers/rtc/rtc-as3722.c
--- a/drivers/rtc/rtc-as3722.c~drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration
+++ a/drivers/rtc/rtc-as3722.c
@@ -198,7 +198,7 @@ static int as3722_rtc_probe(struct platf
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	as3722_rtc->rtc = rtc_device_register("as3722", &pdev->dev,
+	as3722_rtc->rtc = devm_rtc_device_register(&pdev->dev, "as3722-rtc",
 				&as3722_rtc_ops, THIS_MODULE);
 	if (IS_ERR(as3722_rtc->rtc)) {
 		ret = PTR_ERR(as3722_rtc->rtc);
@@ -209,28 +209,16 @@ static int as3722_rtc_probe(struct platf
 	as3722_rtc->alarm_irq = platform_get_irq(pdev, 0);
 	dev_info(&pdev->dev, "RTC interrupt %d\n", as3722_rtc->alarm_irq);
 
-	ret = request_threaded_irq(as3722_rtc->alarm_irq, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, as3722_rtc->alarm_irq, NULL,
 			as3722_alarm_irq, IRQF_ONESHOT | IRQF_EARLY_RESUME,
 			"rtc-alarm", as3722_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
 				as3722_rtc->alarm_irq, ret);
-		goto scrub;
+		return ret;
 	}
 	disable_irq(as3722_rtc->alarm_irq);
 	return 0;
-scrub:
-	rtc_device_unregister(as3722_rtc->rtc);
-	return ret;
-}
-
-static int as3722_rtc_remove(struct platform_device *pdev)
-{
-	struct as3722_rtc *as3722_rtc = platform_get_drvdata(pdev);
