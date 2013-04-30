From: akpm@linux-foundation.org
Subject: [merged] backlight-ltv350qv-convert-ltv350qv-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:10 -0700
Message-ID: <20130430185210.6FAB55A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36876 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101Ab3D3SwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:11 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so86485vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ltv350qv: convert ltv350qv to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-ltv350qv-convert-ltv350qv-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ltv350qv: convert ltv350qv to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ltv350qv.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-convert-ltv350qv-to-dev_pm_ops drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-convert-ltv350qv-to-dev_pm_ops
+++ a/drivers/video/backlight/ltv350qv.c
@@ -271,25 +271,24 @@ static int ltv350qv_remove(struct spi_de
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ltv350qv_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int ltv350qv_suspend(struct device *dev)
 {
-	struct ltv350qv *lcd = spi_get_drvdata(spi);
+	struct ltv350qv *lcd = dev_get_drvdata(dev);
 
 	return ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int ltv350qv_resume(struct spi_device *spi)
+static int ltv350qv_resume(struct device *dev)
 {
-	struct ltv350qv *lcd = spi_get_drvdata(spi);
+	struct ltv350qv *lcd = dev_get_drvdata(dev);
 
 	return ltv350qv_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define ltv350qv_suspend	NULL
-#define ltv350qv_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(ltv350qv_pm_ops, ltv350qv_suspend, ltv350qv_resume);
+
 /* Power down all displays on reboot, poweroff or halt */
 static void ltv350qv_shutdown(struct spi_device *spi)
 {
@@ -302,13 +301,12 @@ static struct spi_driver ltv350qv_driver
 	.driver = {
 		.name		= "ltv350qv",
 		.owner		= THIS_MODULE,
+		.pm		= &ltv350qv_pm_ops,
 	},
 
 	.probe		= ltv350qv_probe,
 	.remove		= ltv350qv_remove,
 	.shutdown	= ltv350qv_shutdown,
-	.suspend	= ltv350qv_suspend,
-	.resume		= ltv350qv_resume,
 };
 
 module_spi_driver(ltv350qv_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

