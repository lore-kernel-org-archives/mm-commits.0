From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-bfin-convert-bfin_rtc_driver-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:12 -0700
Message-ID: <20130430190112.70D5E31C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:43516 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596Ab3D3TBN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:13 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so77933ves.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-bfin: convert bfin_rtc_driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-bfin-convert-bfin_rtc_driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-bfin: convert bfin_rtc_driver to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~rtc-rtc-bfin-convert-bfin_rtc_driver-to-dev_pm_ops drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-rtc-bfin-convert-bfin_rtc_driver-to-dev_pm_ops
+++ a/drivers/rtc/rtc-bfin.c
@@ -396,11 +396,9 @@ static int bfin_rtc_remove(struct platfo
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int bfin_rtc_suspend(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-
 	dev_dbg_stamp(dev);
 
 	if (device_may_wakeup(dev)) {
@@ -412,10 +410,8 @@ static int bfin_rtc_suspend(struct platf
 	return 0;
 }
 
-static int bfin_rtc_resume(struct platform_device *pdev)
+static int bfin_rtc_resume(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-
 	dev_dbg_stamp(dev);
 
 	if (device_may_wakeup(dev))
@@ -434,20 +430,18 @@ static int bfin_rtc_resume(struct platfo
 
 	return 0;
 }
-#else
-# define bfin_rtc_suspend NULL
-# define bfin_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(bfin_rtc_pm_ops, bfin_rtc_suspend, bfin_rtc_resume);
+
 static struct platform_driver bfin_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-bfin",
 		.owner	= THIS_MODULE,
+		.pm	= &bfin_rtc_pm_ops,
 	},
 	.probe		= bfin_rtc_probe,
 	.remove		= bfin_rtc_remove,
-	.suspend	= bfin_rtc_suspend,
-	.resume		= bfin_rtc_resume,
 };
 
 module_platform_driver(bfin_rtc_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

