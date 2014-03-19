From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition.patch
 added to -mm tree
Date: Wed, 19 Mar 2014 16:14:31 -0700
Message-ID: <532a24d7.N7iBiTgL/fOow696%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140AbaCSXOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 19:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, shc_work@mail.ru

Subject: + drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition.patch added to -mm tree
To: shc_work@mail.ru,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 16:14:31 -0700


The patch titled
     Subject: drivers/rtc/rtc-mc13xxx.c: fix potential race condition
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition.patch

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
Subject: drivers/rtc/rtc-mc13xxx.c: fix potential race condition

RTC drivers must not return an error after device registration.  This
patch makes RTC registration as the last action.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -247,8 +247,6 @@ static irqreturn_t mc13xxx_rtc_alarm_han
 	struct mc13xxx_rtc *priv = dev;
 	struct mc13xxx *mc13xxx = priv->mc13xxx;
 
-	dev_dbg(&priv->rtc->dev, "Alarm\n");
-
 	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_AF);
 
 	mc13xxx_irq_ack(mc13xxx, irq);
@@ -261,8 +259,6 @@ static irqreturn_t mc13xxx_rtc_update_ha
 	struct mc13xxx_rtc *priv = dev;
 	struct mc13xxx *mc13xxx = priv->mc13xxx;
 
-	dev_dbg(&priv->rtc->dev, "1HZ\n");
-
 	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_UF);
 
 	mc13xxx_irq_ack(mc13xxx, irq);
@@ -283,7 +279,6 @@ static irqreturn_t mc13xxx_rtc_reset_han
 	struct mc13xxx_rtc *priv = dev;
 	struct mc13xxx *mc13xxx = priv->mc13xxx;
 
-	dev_warn(&priv->rtc->dev, "Contents of the RTC are no longer valid\n");
 	priv->valid = 0;
 
 	mc13xxx_irq_mask(mc13xxx, irq);
@@ -307,11 +302,6 @@ static int __init mc13xxx_rtc_probe(stru
 
 	platform_set_drvdata(pdev, priv);
 
-	priv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
-					     &mc13xxx_rtc_ops, THIS_MODULE);
-	if (IS_ERR(priv->rtc))
-		return PTR_ERR(priv->rtc);
-
 	mc13xxx_lock(mc13xxx);
 
 	mc13xxx_irq_ack(mc13xxx, MC13XXX_IRQ_RTCRST);
@@ -319,24 +309,30 @@ static int __init mc13xxx_rtc_probe(stru
 	ret = mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_RTCRST,
 			mc13xxx_rtc_reset_handler, DRIVER_NAME, priv);
 	if (ret)
-		goto err_reset_irq_request;
+		goto err_irq_request;
 
 	ret = mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_1HZ,
 			mc13xxx_rtc_update_handler, DRIVER_NAME, priv);
 	if (ret)
-		goto err_reset_irq_status;
+		goto err_irq_request;
 
 	ret = mc13xxx_irq_request_nounmask(mc13xxx, MC13XXX_IRQ_TODA,
 			mc13xxx_rtc_alarm_handler, DRIVER_NAME, priv);
-	if (!ret)
-		goto err_reset_irq_request;
+	if (ret)
+		goto err_irq_request;
 
-	mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_1HZ, priv);
+	mc13xxx_unlock(mc13xxx);
+
+	priv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					     &mc13xxx_rtc_ops, THIS_MODULE);
+
+	return 0;
 
-err_reset_irq_status:
+err_irq_request:
+	mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_TODA, priv);
+	mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_1HZ, priv);
 	mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_RTCRST, priv);
 
-err_reset_irq_request:
 	mc13xxx_unlock(mc13xxx);
 
 	return ret;
_

Patches currently in -mm which might be from shc_work@mail.ru are

rtc-mc13xxx-remove-__exit_p.patch
rtc-mc13xxx-request-irqs-after-rtc-registration.patch
rtc-mc13xxx-simplify-alarm_irq_enable.patch
rtc-mc13xxx-fix-1hz-interrupt.patch
rtc-mc13xxx-change-rtc-validation-scheme.patch
rtc-mc13xxx-make-rtc_read_time-more-readable.patch
rtc-verify-a-critical-argument-to-rtc_update_irq-before-using-it.patch
drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition.patch
linux-next.patch

