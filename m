From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mxc-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:12 -0700
Message-ID: <20130430185812.733685A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34211 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350Ab3D3S6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:13 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86872ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mxc: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mxc-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mxc: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-mxc.c
@@ -470,7 +470,7 @@ static int mxc_rtc_remove(struct platfor
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int mxc_rtc_suspend(struct device *dev)
 {
 	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
@@ -490,19 +490,14 @@ static int mxc_rtc_resume(struct device
 
 	return 0;
 }
-
-static struct dev_pm_ops mxc_rtc_pm_ops = {
-	.suspend	= mxc_rtc_suspend,
-	.resume		= mxc_rtc_resume,
-};
 #endif
 
+static SIMPLE_DEV_PM_OPS(mxc_rtc_pm_ops, mxc_rtc_suspend, mxc_rtc_resume);
+
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
 		   .name	= "mxc_rtc",
-#ifdef CONFIG_PM
 		   .pm		= &mxc_rtc_pm_ops,
-#endif
 		   .owner	= THIS_MODULE,
 	},
 	.id_table = imx_rtc_devtype,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

