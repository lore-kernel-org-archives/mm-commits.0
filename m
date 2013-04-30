From: akpm@linux-foundation.org
Subject: [merged] rtc-tegra-use-managed-rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:47 -0700
Message-ID: <20130430185647.7E2D631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56197 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3D3S4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:48 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so86855qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, jg1.han@samsung.com, swarren@nvidia.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: use managed rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-tegra-use-managed-rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tegra.c: use managed rtc_device_register()

Use devm_rtc_device_register() for registering RTC device.  This will
reduce the code for unregistering RTC device in cleanup path and remove
the implementation of remove callback of platform driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-tegra-use-managed-rtc_device_register drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-tegra-use-managed-rtc_device_register
+++ a/drivers/rtc/rtc-tegra.c
@@ -349,13 +349,12 @@ static int __init tegra_rtc_probe(struct
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register(
-		pdev->name, &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev,
+				dev_name(&pdev->dev), &tegra_rtc_ops,
+				THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
-		info->rtc_dev = NULL;
-		dev_err(&pdev->dev,
-			"Unable to register device (err=%d).\n",
+		dev_err(&pdev->dev, "Unable to register device (err=%d).\n",
 			ret);
 		return ret;
 	}
@@ -367,28 +366,12 @@ static int __init tegra_rtc_probe(struct
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device (err=%d).\n",
 			ret);
-		goto err_dev_unreg;
+		return ret;
 	}
 
 	dev_notice(&pdev->dev, "Tegra internal Real Time Clock\n");
 
 	return 0;
-
-err_dev_unreg:
-	rtc_device_unregister(info->rtc_dev);
-
-	return ret;
-}
-
-static int __exit tegra_rtc_remove(struct platform_device *pdev)
-{
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(info->rtc_dev);
-
-	platform_set_drvdata(pdev, NULL);
