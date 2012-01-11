From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:18 -0800
Message-ID: <20120111213219.0ABD120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:45125 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AKVcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:21 -0500
Received: by wgbdt14 with SMTP id dt14so43003wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-wm831x.c: remove unused period IRQ handler
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: drivers/rtc/rtc-wm831x.c: remove unused period IRQ handler

Due to changes in the RTC core the period interrupt is now unused so
delete the code managing it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm831x.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN drivers/rtc/rtc-wm831x.c~drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler
+++ a/drivers/rtc/rtc-wm831x.c
@@ -324,15 +324,6 @@ static irqreturn_t wm831x_alm_irq(int ir
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t wm831x_per_irq(int irq, void *data)
-{
-	struct wm831x_rtc *wm831x_rtc = data;
-
-	rtc_update_irq(wm831x_rtc->rtc, 1, RTC_IRQF | RTC_UF);
-
-	return IRQ_HANDLED;
-}
-
 static const struct rtc_class_ops wm831x_rtc_ops = {
 	.read_time = wm831x_rtc_readtime,
 	.set_mmss = wm831x_rtc_set_mmss,
@@ -405,7 +396,6 @@ static int wm831x_rtc_probe(struct platf
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_rtc *wm831x_rtc;
-	int per_irq = platform_get_irq_byname(pdev, "PER");
 	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 	int ret = 0;
 
@@ -433,14 +423,6 @@ static int wm831x_rtc_probe(struct platf
 		goto err;
 	}
 
-	ret = request_threaded_irq(per_irq, NULL, wm831x_per_irq,
-				   IRQF_TRIGGER_RISING, "RTC period",
-				   wm831x_rtc);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "Failed to request periodic IRQ %d: %d\n",
-			per_irq, ret);
-	}
