From: akpm@linux-foundation.org
Subject: [merged] rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:41 -0700
Message-ID: <20130430185641.7FEA65A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:34594 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347Ab3D3S4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:42 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86775ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, jg1.han@samsung.com, swarren@nvidia.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: use struct dev_pm_ops for power management
has been removed from the -mm tree.  Its filename was
     rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tegra.c: use struct dev_pm_ops for power management

Make the Tegra RTC controller driver define its PM callbacks through a
struct dev_pm_ops object rather than by using legacy PM hooks in struct
platform_driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-tegra-use-struct-dev_pm_ops-for-power-management drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-tegra-use-struct-dev_pm_ops-for-power-management
+++ a/drivers/rtc/rtc-tegra.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 
 /* set to 1 = busy every eight 32kHz clocks during copy of sec+msec to AHB */
 #define TEGRA_RTC_REG_BUSY			0x004
@@ -391,10 +392,9 @@ static int __exit tegra_rtc_remove(struc
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int tegra_rtc_suspend(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
+	struct tegra_rtc_info *info = dev_get_drvdata(dev);
 
 	tegra_rtc_wait_while_busy(dev);
 
@@ -416,10 +416,9 @@ static int tegra_rtc_suspend(struct plat
 	return 0;
 }
 
-static int tegra_rtc_resume(struct platform_device *pdev)
+static int tegra_rtc_resume(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
+	struct tegra_rtc_info *info = dev_get_drvdata(dev);
 
 	dev_vdbg(dev, "Resume (device_may_wakeup=%d)\n",
 		device_may_wakeup(dev));
@@ -431,6 +430,8 @@ static int tegra_rtc_resume(struct platf
 }
 #endif
 
+static SIMPLE_DEV_PM_OPS(tegra_rtc_pm_ops, tegra_rtc_suspend, tegra_rtc_resume);
+
 static void tegra_rtc_shutdown(struct platform_device *pdev)
 {
 	dev_vdbg(&pdev->dev, "disabling interrupts.\n");
@@ -445,11 +446,8 @@ static struct platform_driver tegra_rtc_
 		.name	= "tegra_rtc",
 		.owner	= THIS_MODULE,
 		.of_match_table = tegra_rtc_dt_match,
+		.pm	= &tegra_rtc_pm_ops,
 	},
-#ifdef CONFIG_PM_SLEEP
-	.suspend	= tegra_rtc_suspend,
-	.resume		= tegra_rtc_resume,
-#endif
 };
 
 module_platform_driver_probe(tegra_rtc_driver, tegra_rtc_probe);
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
linux-next.patch

