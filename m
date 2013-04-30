From: akpm@linux-foundation.org
Subject: [merged] backlight-hp680_bl-convert-hp680bl-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:00 -0700
Message-ID: <20130430185200.7021C5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36450 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3SwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:01 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86229ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: hp680_bl: convert hp680bl to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-hp680_bl-convert-hp680bl-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: hp680_bl: convert hp680bl to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hp680_bl.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/hp680_bl.c~backlight-hp680_bl-convert-hp680bl-to-dev_pm_ops drivers/video/backlight/hp680_bl.c
--- a/drivers/video/backlight/hp680_bl.c~backlight-hp680_bl-convert-hp680bl-to-dev_pm_ops
+++ a/drivers/video/backlight/hp680_bl.c
@@ -64,29 +64,28 @@ static void hp680bl_send_intensity(struc
 }
 
 
-#ifdef CONFIG_PM
-static int hp680bl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int hp680bl_suspend(struct device *dev)
 {
-	struct backlight_device *bd = platform_get_drvdata(pdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	hp680bl_suspended = 1;
 	hp680bl_send_intensity(bd);
 	return 0;
 }
 
-static int hp680bl_resume(struct platform_device *pdev)
+static int hp680bl_resume(struct device *dev)
 {
-	struct backlight_device *bd = platform_get_drvdata(pdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	hp680bl_suspended = 0;
 	hp680bl_send_intensity(bd);
 	return 0;
 }
-#else
-#define hp680bl_suspend	NULL
-#define hp680bl_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(hp680bl_pm_ops, hp680bl_suspend, hp680bl_resume);
+
 static int hp680bl_set_intensity(struct backlight_device *bd)
 {
 	hp680bl_send_intensity(bd);
@@ -140,10 +139,9 @@ static int hp680bl_remove(struct platfor
 static struct platform_driver hp680bl_driver = {
 	.probe		= hp680bl_probe,
 	.remove		= hp680bl_remove,
-	.suspend	= hp680bl_suspend,
-	.resume		= hp680bl_resume,
 	.driver		= {
 		.name	= "hp680-bl",
+		.pm	= &hp680bl_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

