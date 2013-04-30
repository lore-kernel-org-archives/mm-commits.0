From: akpm@linux-foundation.org
Subject: [merged] backlight-tdo24m-convert-tdo24m-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:12 -0700
Message-ID: <20130430185212.6FC375A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:33105 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3SwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:14 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so86492vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tdo24m: convert tdo24m to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-tdo24m-convert-tdo24m-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tdo24m: convert tdo24m to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tdo24m.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/tdo24m.c~backlight-tdo24m-convert-tdo24m-to-dev_pm_ops drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~backlight-tdo24m-convert-tdo24m-to-dev_pm_ops
+++ a/drivers/video/backlight/tdo24m.c
@@ -412,25 +412,24 @@ static int tdo24m_remove(struct spi_devi
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tdo24m_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int tdo24m_suspend(struct device *dev)
 {
-	struct tdo24m *lcd = spi_get_drvdata(spi);
+	struct tdo24m *lcd = dev_get_drvdata(dev);
 
 	return tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int tdo24m_resume(struct spi_device *spi)
+static int tdo24m_resume(struct device *dev)
 {
-	struct tdo24m *lcd = spi_get_drvdata(spi);
+	struct tdo24m *lcd = dev_get_drvdata(dev);
 
 	return tdo24m_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define tdo24m_suspend	NULL
-#define tdo24m_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(tdo24m_pm_ops, tdo24m_suspend, tdo24m_resume);
+
 /* Power down all displays on reboot, poweroff or halt */
 static void tdo24m_shutdown(struct spi_device *spi)
 {
@@ -443,12 +442,11 @@ static struct spi_driver tdo24m_driver =
 	.driver = {
 		.name		= "tdo24m",
 		.owner		= THIS_MODULE,
+		.pm		= &tdo24m_pm_ops,
 	},
 	.probe		= tdo24m_probe,
 	.remove		= tdo24m_remove,
 	.shutdown	= tdo24m_shutdown,
-	.suspend	= tdo24m_suspend,
-	.resume		= tdo24m_resume,
 };
 
 module_spi_driver(tdo24m_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

