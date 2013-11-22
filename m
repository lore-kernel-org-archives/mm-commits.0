From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch added to -mm tree
Date: Thu, 21 Nov 2013 16:12:03 -0800
Message-ID: <528ea153.wNqr0QsSES15FA8b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KVAME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 19:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, ldewangan@nvidia.com

Subject: + drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch added to -mm tree
To: ldewangan@nvidia.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 16:12:03 -0800


The patch titled
     Subject: drivers/rtc/rtc-as3722: use devm for rtc and irq registration
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
