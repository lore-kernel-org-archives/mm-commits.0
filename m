From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch added to -mm
 tree
Date: Thu, 19 Sep 2013 15:10:13 -0700
Message-ID: <523b7645.B65KIqrFhs07ELOq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3ISWKO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:10:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch added to -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:10:13 -0700


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-at91rm9200.c: use devm_* APIs

devm_* APIs are device managed and make code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~drivers-rtc-rtc-at91rm9200c-use-devm_-apis drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~drivers-rtc-rtc-at91rm9200c-use-devm_-apis
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -376,7 +376,8 @@ static int __init at91_rtc_probe(struct
 		return -ENXIO;
 	}
 
-	at91_rtc_regs = ioremap(regs->start, resource_size(regs));
+	at91_rtc_regs = devm_ioremap(&pdev->dev, regs->start,
+				     resource_size(regs));
 	if (!at91_rtc_regs) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		return -ENOMEM;
@@ -390,12 +391,12 @@ static int __init at91_rtc_probe(struct
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
 
-	ret = request_irq(irq, at91_rtc_interrupt,
+	ret = devm_request_irq(&pdev->dev, irq, at91_rtc_interrupt,
 				IRQF_SHARED,
 				"at91_rtc", pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ %d already in use.\n", irq);
-		goto err_unmap;
+		return ret;
 	}
 
 	/* cpu init code should really have flagged this device as
@@ -404,23 +405,14 @@ static int __init at91_rtc_probe(struct
 	if (!device_can_wakeup(&pdev->dev))
 		device_init_wakeup(&pdev->dev, 1);
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&at91_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto err_free_irq;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 	platform_set_drvdata(pdev, rtc);
 
 	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
-
-err_free_irq:
-	free_irq(irq, pdev);
-err_unmap:
-	iounmap(at91_rtc_regs);
-
-	return ret;
 }
 
 /*
@@ -428,16 +420,10 @@ err_unmap:
  */
 static int __exit at91_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
 	/* Disable all interrupts */
 	at91_rtc_write_idr(AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
-	free_irq(irq, pdev);
