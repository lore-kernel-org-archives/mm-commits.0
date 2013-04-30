From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1742-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:44 -0700
Message-ID: <20130430185544.6EC6D5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:33967 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab3D3Szp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:45 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86755vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1742: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1742-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1742: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1742.c~rtc-rtc-ds1742-use-devm_rtc_device_register drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-rtc-ds1742-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ds1742.c
@@ -208,17 +208,14 @@ static int ds1742_rtc_probe(struct platf
 
 	pdata->last_jiffies = jiffies;
 	platform_set_drvdata(pdev, pdata);
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &ds1742_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
-	if (ret) {
-		dev_err(&pdev->dev, "creating nvram file in sysfs failed\n");
-		rtc_device_unregister(rtc);
-	}
+
 	return ret;
 }
 
@@ -227,7 +224,6 @@ static int ds1742_rtc_remove(struct plat
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

