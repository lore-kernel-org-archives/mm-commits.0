From: akpm@linux-foundation.org
Subject: [merged] backlight-kb3886_bl-convert-kb3886bl-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:02 -0700
Message-ID: <20130430185202.740925A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:38848 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3SwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:03 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so86411qcr.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: kb3886_bl: convert kb3886bl to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-kb3886_bl-convert-kb3886bl-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: kb3886_bl: convert kb3886bl to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/kb3886_bl.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/kb3886_bl.c~backlight-kb3886_bl-convert-kb3886bl-to-dev_pm_ops drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~backlight-kb3886_bl-convert-kb3886bl-to-dev_pm_ops
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -106,29 +106,28 @@ static int kb3886bl_send_intensity(struc
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int kb3886bl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int kb3886bl_suspend(struct device *dev)
 {
-	struct backlight_device *bd = platform_get_drvdata(pdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	kb3886bl_flags |= KB3886BL_SUSPENDED;
 	backlight_update_status(bd);
 	return 0;
 }
 
-static int kb3886bl_resume(struct platform_device *pdev)
+static int kb3886bl_resume(struct device *dev)
 {
-	struct backlight_device *bd = platform_get_drvdata(pdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	kb3886bl_flags &= ~KB3886BL_SUSPENDED;
 	backlight_update_status(bd);
 	return 0;
 }
-#else
-#define kb3886bl_suspend	NULL
-#define kb3886bl_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(kb3886bl_pm_ops, kb3886bl_suspend, kb3886bl_resume);
+
 static int kb3886bl_get_intensity(struct backlight_device *bd)
 {
 	return kb3886bl_intensity;
@@ -179,10 +178,9 @@ static int kb3886bl_remove(struct platfo
 static struct platform_driver kb3886bl_driver = {
 	.probe		= kb3886bl_probe,
 	.remove		= kb3886bl_remove,
-	.suspend	= kb3886bl_suspend,
-	.resume		= kb3886bl_resume,
 	.driver		= {
 		.name	= "kb3886-bl",
+		.pm	= &kb3886bl_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

