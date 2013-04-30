From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sa1100-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:59 -0700
Message-ID: <20130430190059.6FF705A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63592 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574Ab3D3TBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:00 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so87288ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-sa1100: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sa1100-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sa1100: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sa1100.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-sa1100.c~rtc-rtc-sa1100-use-devm_-functions drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-rtc-sa1100-use-devm_-functions
+++ a/drivers/rtc/rtc-sa1100.c
@@ -234,14 +234,13 @@ static int sa1100_rtc_probe(struct platf
 	if (irq_1hz < 0 || irq_alarm < 0)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(struct sa1100_rtc), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct sa1100_rtc), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
-	info->clk = clk_get(&pdev->dev, NULL);
+	info->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(info->clk)) {
 		dev_err(&pdev->dev, "failed to find rtc clock source\n");
-		ret = PTR_ERR(info->clk);
-		goto err_clk;
+		return PTR_ERR(info->clk);
 	}
 	info->irq_1hz = irq_1hz;
 	info->irq_alarm = irq_alarm;
@@ -268,8 +267,8 @@ static int sa1100_rtc_probe(struct platf
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &sa1100_rtc_ops,
-		THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &sa1100_rtc_ops,
+					THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
 		ret = PTR_ERR(rtc);
@@ -306,9 +305,6 @@ err_dev:
 	clk_disable_unprepare(info->clk);
 err_enable_clk:
 	platform_set_drvdata(pdev, NULL);
-	clk_put(info->clk);
-err_clk:
-	kfree(info);
 	return ret;
 }
 
@@ -317,11 +313,8 @@ static int sa1100_rtc_remove(struct plat
 	struct sa1100_rtc *info = platform_get_drvdata(pdev);
 
 	if (info) {
-		rtc_device_unregister(info->rtc);
 		clk_disable_unprepare(info->clk);
-		clk_put(info->clk);
 		platform_set_drvdata(pdev, NULL);
-		kfree(info);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

