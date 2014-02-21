From: akpm@linux-foundation.org
Subject: + rtc-mc13xxx-change-rtc-validation-scheme.patch added to -mm
 tree
Date: Fri, 21 Feb 2014 15:10:04 -0800
Message-ID: <5307dccc.I1nf7sjPELbcU+1Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbaBUXKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:10:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, kernel@pengutronix.de, shc_work@mail.ru

Subject: + rtc-mc13xxx-change-rtc-validation-scheme.patch added to -mm tree
To: shc_work@mail.ru,kernel@pengutronix.de,u.kleine-koenig@pengutronix.de
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:10:04 -0800


The patch titled
     Subject: rtc: mc13xxx: change RTC validation scheme
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-change-rtc-validation-scheme.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-mc13xxx-change-rtc-validation-scheme.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-mc13xxx-change-rtc-validation-scheme.patch

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
Subject: rtc: mc13xxx: change RTC validation scheme

Datasheet says: "When the VSRTC voltage drops to the range of 0.9 - 0.8 V,
the RTCPORB reset signal is generated and the contents of the RTC will be
reset.  <skip>.  To inform the processor that the contents of the RTC are
no longer valid due to the reset, a timer reset interrupt function is
implemented with the RTCRSTI bit." This patch makes the RTC valid by
default until RTCRST interrupt occurs.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-change-rtc-validation-scheme drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-change-rtc-validation-scheme
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -64,12 +64,10 @@ static int mc13xxx_rtc_read_time(struct
 	unsigned long s1970;
 	int ret;
 
-	mc13xxx_lock(priv->mc13xxx);
+	if (!priv->valid)
+		return -ENODATA;
 
-	if (!priv->valid) {
-		ret = -ENODATA;
-		goto out;
-	}
+	mc13xxx_lock(priv->mc13xxx);
 
 	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days1);
 	if (unlikely(ret))
@@ -154,11 +152,14 @@ static int mc13xxx_rtc_set_mmss(struct d
 			goto out;
 	}
 
-	ret = mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_RTCRST);
-	if (unlikely(ret))
-		goto out;
+	if (!priv->valid) {
+		ret = mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_RTCRST);
+		if (unlikely(ret))
+			goto out;
+
+		ret = mc13xxx_irq_unmask(priv->mc13xxx, MC13XXX_IRQ_RTCRST);
+	}
 
-	ret = mc13xxx_irq_unmask(priv->mc13xxx, MC13XXX_IRQ_RTCRST);
 out:
 	priv->valid = !ret;
 
@@ -295,7 +296,7 @@ static irqreturn_t mc13xxx_rtc_reset_han
 	struct mc13xxx_rtc *priv = dev;
 	struct mc13xxx *mc13xxx = priv->mc13xxx;
 
-	dev_dbg(&priv->rtc->dev, "RTCRST\n");
+	dev_warn(&priv->rtc->dev, "Contents of the RTC are no longer valid\n");
 	priv->valid = 0;
 
 	mc13xxx_irq_mask(mc13xxx, irq);
@@ -308,7 +309,6 @@ static int __init mc13xxx_rtc_probe(stru
 	int ret;
 	struct mc13xxx_rtc *priv;
 	struct mc13xxx *mc13xxx;
-	int rtcrst_pending;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -316,6 +316,7 @@ static int __init mc13xxx_rtc_probe(stru
 
 	mc13xxx = dev_get_drvdata(pdev->dev.parent);
 	priv->mc13xxx = mc13xxx;
+	priv->valid = 1;
 
 	platform_set_drvdata(pdev, priv);
 
@@ -326,18 +327,13 @@ static int __init mc13xxx_rtc_probe(stru
 
 	mc13xxx_lock(mc13xxx);
 
+	mc13xxx_irq_ack(mc13xxx, MC13XXX_IRQ_RTCRST);
+
 	ret = mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_RTCRST,
 			mc13xxx_rtc_reset_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_reset_irq_request;
 
-	ret = mc13xxx_irq_status(mc13xxx, MC13XXX_IRQ_RTCRST,
-			NULL, &rtcrst_pending);
-	if (ret)
-		goto err_reset_irq_status;
-
-	priv->valid = !rtcrst_pending;
