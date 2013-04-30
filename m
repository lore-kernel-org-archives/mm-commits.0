From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-stmp3xxx-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:01 -0700
Message-ID: <20130430190101.705DC5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56338 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580Ab3D3TBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:02 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so88756qab.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-stmp3xxx: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-stmp3xxx-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-stmp3xxx: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stmp3xxx.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-stmp3xxx.c~rtc-rtc-stmp3xxx-use-devm_-functions drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~rtc-rtc-stmp3xxx-use-devm_-functions
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -225,11 +225,7 @@ static int stmp3xxx_rtc_remove(struct pl
 
 	writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
 			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
-	free_irq(rtc_data->irq_alarm, &pdev->dev);
-	rtc_device_unregister(rtc_data->rtc);
 	platform_set_drvdata(pdev, NULL);
-	iounmap(rtc_data->io);
-	kfree(rtc_data);
 
 	return 0;
 }
@@ -240,22 +236,20 @@ static int stmp3xxx_rtc_probe(struct pla
 	struct resource *r;
 	int err;
 
-	rtc_data = kzalloc(sizeof *rtc_data, GFP_KERNEL);
+	rtc_data = devm_kzalloc(&pdev->dev, sizeof(*rtc_data), GFP_KERNEL);
 	if (!rtc_data)
 		return -ENOMEM;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
 		dev_err(&pdev->dev, "failed to get resource\n");
-		err = -ENXIO;
-		goto out_free;
+		return -ENXIO;
 	}
 
-	rtc_data->io = ioremap(r->start, resource_size(r));
+	rtc_data->io = devm_ioremap(&pdev->dev, r->start, resource_size(r));
 	if (!rtc_data->io) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		err = -EIO;
-		goto out_free;
+		return -EIO;
 	}
 
 	rtc_data->irq_alarm = platform_get_irq(pdev, 0);
@@ -263,8 +257,7 @@ static int stmp3xxx_rtc_probe(struct pla
 	if (!(readl(STMP3XXX_RTC_STAT + rtc_data->io) &
 			STMP3XXX_RTC_STAT_RTC_PRESENT)) {
 		dev_err(&pdev->dev, "no device onboard\n");
-		err = -ENODEV;
-		goto out_remap;
+		return -ENODEV;
 	}
 
 	platform_set_drvdata(pdev, rtc_data);
@@ -279,31 +272,26 @@ static int stmp3xxx_rtc_probe(struct pla
 			STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
 			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 
-	rtc_data->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc_data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&stmp3xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_data->rtc)) {
 		err = PTR_ERR(rtc_data->rtc);
-		goto out_remap;
+		goto out;
 	}
 
-	err = request_irq(rtc_data->irq_alarm, stmp3xxx_rtc_interrupt, 0,
-			"RTC alarm", &pdev->dev);
+	err = devm_request_irq(&pdev->dev, rtc_data->irq_alarm,
+			stmp3xxx_rtc_interrupt, 0, "RTC alarm", &pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
 			rtc_data->irq_alarm);
-		goto out_irq_alarm;
+		goto out;
 	}
 
 	stmp3xxx_wdt_register(pdev);
 	return 0;
 
-out_irq_alarm:
-	rtc_device_unregister(rtc_data->rtc);
-out_remap:
+out:
 	platform_set_drvdata(pdev, NULL);
-	iounmap(rtc_data->io);
-out_free:
-	kfree(rtc_data);
 	return err;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

