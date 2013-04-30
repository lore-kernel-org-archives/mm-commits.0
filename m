From: akpm@linux-foundation.org
Subject: [merged] backlight-omap1-convert-omapbl-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:45 -0700
Message-ID: <20130430185245.7270931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60466 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3Swq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:46 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so87785qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: omap1: convert omapbl to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-omap1-convert-omapbl-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: omap1: convert omapbl to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/omap1_bl.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/video/backlight/omap1_bl.c~backlight-omap1-convert-omapbl-to-dev_pm_ops drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-omap1-convert-omapbl-to-dev_pm_ops
+++ a/drivers/video/backlight/omap1_bl.c
@@ -71,27 +71,24 @@ static void omapbl_blank(struct omap_bac
 	}
 }
 
-#ifdef CONFIG_PM
-static int omapbl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int omapbl_suspend(struct device *dev)
 {
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = bl_get_data(dev);
+	struct backlight_device *bl_dev = dev_get_drvdata(dev);
+	struct omap_backlight *bl = bl_get_data(bl_dev);
 
 	omapbl_blank(bl, FB_BLANK_POWERDOWN);
 	return 0;
 }
 
-static int omapbl_resume(struct platform_device *pdev)
+static int omapbl_resume(struct device *dev)
 {
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = bl_get_data(dev);
+	struct backlight_device *bl_dev = dev_get_drvdata(dev);
+	struct omap_backlight *bl = bl_get_data(bl_dev);
 
 	omapbl_blank(bl, bl->powermode);
 	return 0;
 }
-#else
-#define omapbl_suspend	NULL
-#define omapbl_resume	NULL
 #endif
 
 static int omapbl_set_power(struct backlight_device *dev, int state)
@@ -182,13 +179,14 @@ static int omapbl_remove(struct platform
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(omapbl_pm_ops, omapbl_suspend, omapbl_resume);
+
 static struct platform_driver omapbl_driver = {
 	.probe		= omapbl_probe,
 	.remove		= omapbl_remove,
-	.suspend	= omapbl_suspend,
-	.resume		= omapbl_resume,
 	.driver		= {
 		.name	= "omap-bl",
+		.pm	= &omapbl_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

