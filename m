From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-spear-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:14 -0700
Message-ID: <20130430185614.71B2A31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:47146 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab3D3S4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:15 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77357veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-spear: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-spear-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-spear: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-use-devm_rtc_device_register drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-spear.c
@@ -400,8 +400,8 @@ static int spear_rtc_probe(struct platfo
 	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
-	config->rtc = rtc_device_register(pdev->name, &pdev->dev,
-			&spear_rtc_ops, THIS_MODULE);
+	config->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&spear_rtc_ops, THIS_MODULE);
 	if (IS_ERR(config->rtc)) {
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 				PTR_ERR(config->rtc));
@@ -427,7 +427,6 @@ static int spear_rtc_remove(struct platf
 {
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(config->rtc);
 	spear_rtc_disable_interrupt(config);
 	clk_disable_unprepare(config->clk);
 	device_init_wakeup(&pdev->dev, 0);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

