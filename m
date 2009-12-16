From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1742-fix-races-around-device-registration.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:30 -0800
Message-ID: <200912162034.nBGKYUmR013026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763206AbZLPUej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1742: fix races around device registration
has been removed from the -mm tree.  Its filename was
     rtc-ds1742-fix-races-around-device-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1742: fix races around device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

* Call dev_set_drvdata before rtc device creation
* Use devres APIs and simplify error/remove path

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |   51 +++++++++++--------------------------
 1 file changed, 16 insertions(+), 35 deletions(-)

diff -puN drivers/rtc/rtc-ds1742.c~rtc-ds1742-fix-races-around-device-registration drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-ds1742-fix-races-around-device-registration
+++ a/drivers/rtc/rtc-ds1742.c
@@ -21,7 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
-#define DRV_VERSION "0.3"
+#define DRV_VERSION "0.4"
 
 #define RTC_SIZE		8
 
@@ -55,7 +55,6 @@ struct rtc_plat_data {
 	void __iomem *ioaddr_rtc;
 	size_t size_nvram;
 	size_t size;
-	resource_size_t baseaddr;
 	unsigned long last_jiffies;
 	struct bin_attribute nvram_attr;
 };
@@ -163,27 +162,24 @@ static int __devinit ds1742_rtc_probe(st
 	struct rtc_device *rtc;
 	struct resource *res;
 	unsigned int cen, sec;
-	struct rtc_plat_data *pdata = NULL;
-	void __iomem *ioaddr = NULL;
+	struct rtc_plat_data *pdata;
+	void __iomem *ioaddr;
 	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 	pdata->size = res->end - res->start + 1;
-	if (!request_mem_region(res->start, pdata->size, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	pdata->baseaddr = res->start;
-	ioaddr = ioremap(pdata->baseaddr, pdata->size);
-	if (!ioaddr) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
+		pdev->name))
+		return -EBUSY;
+	ioaddr = devm_ioremap(&pdev->dev, res->start, pdata->size);
+	if (!ioaddr)
+		return -ENOMEM;
+
 	pdata->ioaddr_nvram = ioaddr;
 	pdata->size_nvram = pdata->size - RTC_SIZE;
 	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
@@ -207,31 +203,19 @@ static int __devinit ds1742_rtc_probe(st
 	if (!(readb(ioaddr + RTC_DAY) & RTC_BATT_FLAG))
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
+	pdata->last_jiffies = jiffies;
+	platform_set_drvdata(pdev, pdata);
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &ds1742_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto out;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
-	pdata->last_jiffies = jiffies;
-	platform_set_drvdata(pdev, pdata);
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 	if (ret) {
 		dev_err(&pdev->dev, "creating nvram file in sysfs failed\n");
-		goto out;
+		rtc_device_unregister(rtc);
 	}
-
-	return 0;
- out:
-	if (pdata->rtc)
-		rtc_device_unregister(pdata->rtc);
-	if (pdata->ioaddr_nvram)
-		iounmap(pdata->ioaddr_nvram);
-	if (pdata->baseaddr)
-		release_mem_region(pdata->baseaddr, pdata->size);
-	kfree(pdata);
 	return ret;
 }
 
@@ -241,9 +225,6 @@ static int __devexit ds1742_rtc_remove(s
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	iounmap(pdata->ioaddr_nvram);
-	release_mem_region(pdata->baseaddr, pdata->size);
-	kfree(pdata);
 	return 0;
 }
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch

