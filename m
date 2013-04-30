From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tegra-add-__init-__exit-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:06 -0700
Message-ID: <20130430185406.6E72531C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:50907 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3D3SyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:07 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so86657yen.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tegra: add __init/__exit annotation
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tegra-add-__init-__exit-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tegra: add __init/__exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-rtc-tegra-add-__init-__exit-annotation drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-rtc-tegra-add-__init-__exit-annotation
+++ a/drivers/rtc/rtc-tegra.c
@@ -309,7 +309,7 @@ static const struct of_device_id tegra_r
 };
 MODULE_DEVICE_TABLE(of, tegra_rtc_dt_match);
 
-static int tegra_rtc_probe(struct platform_device *pdev)
+static int __init tegra_rtc_probe(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info;
 	struct resource *res;
@@ -379,7 +379,7 @@ err_dev_unreg:
 	return ret;
 }
 
-static int tegra_rtc_remove(struct platform_device *pdev)
+static int __exit tegra_rtc_remove(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
 
@@ -439,7 +439,7 @@ static void tegra_rtc_shutdown(struct pl
 
 MODULE_ALIAS("platform:tegra_rtc");
 static struct platform_driver tegra_rtc_driver = {
-	.remove		= tegra_rtc_remove,
+	.remove		= __exit_p(tegra_rtc_remove),
 	.shutdown	= tegra_rtc_shutdown,
 	.driver		= {
 		.name	= "tegra_rtc",
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

