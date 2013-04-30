From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-spear-convert-spear_rtc_driver-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:23 -0700
Message-ID: <20130430190123.730495A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:47741 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3D3TBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:24 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87676vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-spear: convert spear_rtc_driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-spear-convert-spear_rtc_driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-spear: convert spear_rtc_driver to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-convert-spear_rtc_driver-to-dev_pm_ops drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-convert-spear_rtc_driver-to-dev_pm_ops
+++ a/drivers/rtc/rtc-spear.c
@@ -434,10 +434,10 @@ static int spear_rtc_remove(struct platf
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
-static int spear_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int spear_rtc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 	int irq;
 
@@ -453,8 +453,9 @@ static int spear_rtc_suspend(struct plat
 	return 0;
 }
 
-static int spear_rtc_resume(struct platform_device *pdev)
+static int spear_rtc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 	int irq;
 
@@ -472,12 +473,10 @@ static int spear_rtc_resume(struct platf
 
 	return 0;
 }
-
-#else
-#define spear_rtc_suspend	NULL
-#define spear_rtc_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(spear_rtc_pm_ops, spear_rtc_suspend, spear_rtc_resume);
+
 static void spear_rtc_shutdown(struct platform_device *pdev)
 {
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
@@ -497,11 +496,10 @@ MODULE_DEVICE_TABLE(of, spear_rtc_id_tab
 static struct platform_driver spear_rtc_driver = {
 	.probe = spear_rtc_probe,
 	.remove = spear_rtc_remove,
-	.suspend = spear_rtc_suspend,
-	.resume = spear_rtc_resume,
 	.shutdown = spear_rtc_shutdown,
 	.driver = {
 		.name = "rtc-spear",
+		.pm = &spear_rtc_pm_ops,
 		.of_match_table = of_match_ptr(spear_rtc_id_table),
 	},
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

