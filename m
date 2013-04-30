From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-stk17ta8-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:17 -0700
Message-ID: <20130430185617.6F56C5A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:34321 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab3D3S4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:18 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so86874yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-stk17ta8: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-stk17ta8-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-stk17ta8: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stk17ta8.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-rtc-stk17ta8-use-devm_rtc_device_register drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-rtc-stk17ta8-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -336,14 +336,13 @@ static int stk17ta8_rtc_probe(struct pla
 		}
 	}
 
-	pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &stk17ta8_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pdata->rtc))
 		return PTR_ERR(pdata->rtc);
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
-	if (ret)
-		rtc_device_unregister(pdata->rtc);
+
 	return ret;
 }
 
@@ -352,7 +351,6 @@ static int stk17ta8_rtc_remove(struct pl
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	if (pdata->irq > 0)
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

