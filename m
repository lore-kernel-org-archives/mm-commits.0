From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-88pm80x-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:26 -0700
Message-ID: <20130430185526.77A6F5A426B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:57971 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219Ab3D3Sz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:27 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77286veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-88pm80x: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-88pm80x-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-88pm80x: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm80x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-use-devm_rtc_device_register drivers/rtc/rtc-88pm80x.c
--- a/drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-88pm80x.c
@@ -312,7 +312,7 @@ static int pm80x_rtc_probe(struct platfo
 	}
 	rtc_tm_to_time(&tm, &ticks);
 
-	info->rtc_dev = rtc_device_register("88pm80x-rtc", &pdev->dev,
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "88pm80x-rtc",
 					    &pm80x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
@@ -346,7 +346,6 @@ static int pm80x_rtc_remove(struct platf
 {
 	struct pm80x_rtc_info *info = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(info->rtc_dev);
 	pm80x_free_irq(info->chip, info->irq, info);
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

