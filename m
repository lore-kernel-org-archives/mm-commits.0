From: akpm@linux-foundation.org
Subject: + rtc-mc13xxx-request-irqs-after-rtc-registration.patch added to
 -mm tree
Date: Fri, 21 Feb 2014 15:10:01 -0800
Message-ID: <5307dcc9.PxaeLaSLTPxMkU3s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaBUXKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:10:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, kernel@pengutronix.de, shc_work@mail.ru

Subject: + rtc-mc13xxx-request-irqs-after-rtc-registration.patch added to -mm tree
To: shc_work@mail.ru,kernel@pengutronix.de,u.kleine-koenig@pengutronix.de
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:10:01 -0800


The patch titled
     Subject: rtc: mc13xxx: request IRQs after RTC registration
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-request-irqs-after-rtc-registration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-mc13xxx-request-irqs-after-rtc-registration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-mc13xxx-request-irqs-after-rtc-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: rtc: mc13xxx: request IRQs after RTC registration

Interrupts can appear after request_irq and interrupt handlers can use the
RTC device, but currently we register RTC after IRQs.  This patch changes
this order and simplify error path a bit.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |   32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-request-irqs-after-rtc-registration drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-request-irqs-after-rtc-registration
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -325,6 +325,11 @@ static int __init mc13xxx_rtc_probe(stru
 
 	platform_set_drvdata(pdev, priv);
 
+	priv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					     &mc13xxx_rtc_ops, THIS_MODULE);
+	if (IS_ERR(priv->rtc))
+		return PTR_ERR(priv->rtc);
+
 	mc13xxx_lock(mc13xxx);
 
 	ret = mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_RTCRST,
@@ -342,35 +347,20 @@ static int __init mc13xxx_rtc_probe(stru
 	ret = mc13xxx_irq_request_nounmask(mc13xxx, MC13XXX_IRQ_1HZ,
 			mc13xxx_rtc_update_handler, DRIVER_NAME, priv);
 	if (ret)
-		goto err_update_irq_request;
+		goto err_reset_irq_status;
 
 	ret = mc13xxx_irq_request_nounmask(mc13xxx, MC13XXX_IRQ_TODA,
 			mc13xxx_rtc_alarm_handler, DRIVER_NAME, priv);
-	if (ret)
-		goto err_alarm_irq_request;
-
-	mc13xxx_unlock(mc13xxx);
-
-	priv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
-					&mc13xxx_rtc_ops, THIS_MODULE);
-	if (IS_ERR(priv->rtc)) {
-		ret = PTR_ERR(priv->rtc);
-
-		mc13xxx_lock(mc13xxx);
-
-		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_TODA, priv);
-err_alarm_irq_request:
+	if (!ret)
+		goto err_reset_irq_request;
 
-		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_1HZ, priv);
-err_update_irq_request:
+	mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_1HZ, priv);
 
 err_reset_irq_status:
+	mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_RTCRST, priv);
 
-		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_RTCRST, priv);
 err_reset_irq_request:
