From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-stmp3xxx-convert-stmp3xxx_rtcdrv-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:26 -0700
Message-ID: <20130430190126.730405A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:38682 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab3D3TB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:27 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so87422ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-stmp3xxx: convert stmp3xxx_rtcdrv to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-stmp3xxx-convert-stmp3xxx_rtcdrv-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-stmp3xxx: convert stmp3xxx_rtcdrv to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stmp3xxx.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-stmp3xxx.c~rtc-rtc-stmp3xxx-convert-stmp3xxx_rtcdrv-to-dev_pm_ops drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~rtc-rtc-stmp3xxx-convert-stmp3xxx_rtcdrv-to-dev_pm_ops
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -297,15 +297,15 @@ out:
 	return err;
 }
 
-#ifdef CONFIG_PM
-static int stmp3xxx_rtc_suspend(struct platform_device *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int stmp3xxx_rtc_suspend(struct device *dev)
 {
 	return 0;
 }
 
-static int stmp3xxx_rtc_resume(struct platform_device *dev)
+static int stmp3xxx_rtc_resume(struct device *dev)
 {
-	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	mxs_reset_block(rtc_data->io);
 	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
@@ -314,11 +314,11 @@ static int stmp3xxx_rtc_resume(struct pl
 			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
 	return 0;
 }
-#else
-#define stmp3xxx_rtc_suspend	NULL
-#define stmp3xxx_rtc_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(stmp3xxx_rtc_pm_ops, stmp3xxx_rtc_suspend,
+			stmp3xxx_rtc_resume);
+
 static const struct of_device_id rtc_dt_ids[] = {
 	{ .compatible = "fsl,stmp3xxx-rtc", },
 	{ /* sentinel */ }
@@ -328,11 +328,10 @@ MODULE_DEVICE_TABLE(of, rtc_dt_ids);
 static struct platform_driver stmp3xxx_rtcdrv = {
 	.probe		= stmp3xxx_rtc_probe,
 	.remove		= stmp3xxx_rtc_remove,
-	.suspend	= stmp3xxx_rtc_suspend,
-	.resume		= stmp3xxx_rtc_resume,
 	.driver		= {
 		.name	= "stmp3xxx-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &stmp3xxx_rtc_pm_ops,
 		.of_match_table = of_match_ptr(rtc_dt_ids),
 	},
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

