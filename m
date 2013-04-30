From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1553-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:41 -0700
Message-ID: <20130430185541.72A925A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39651 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab3D3Szm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:42 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so86732vbf.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1553: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1553-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1553: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1553.c~rtc-rtc-ds1553-use-devm_rtc_device_register drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-rtc-ds1553-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ds1553.c
@@ -326,15 +326,14 @@ static int ds1553_rtc_probe(struct platf
 		}
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &ds1553_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
-	if (ret)
-		rtc_device_unregister(rtc);
+
 	return ret;
 }
 
@@ -343,7 +342,6 @@ static int ds1553_rtc_remove(struct plat
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
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

