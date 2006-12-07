From: akpm@osdl.org
Subject: - rtc-ds1743-support.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:24 -0800
Message-ID: <200612072315.kB7NFOGu030723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53574 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163890AbWLGXP6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:15:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tr@newtec.dk, a.zummo@towertech.it, anemo@mba.ocn.ne.jp, mm-commits@vger.kernel.org


The patch titled
     rtc: ds1743 support
has been removed from the -mm tree.  Its filename was
     rtc-ds1743-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: ds1743 support
From: Torsten Ertbjerg Rasmussen <tr@newtec.dk>

The real time clocks ds1742 and ds1743 differs only in the size of the
nvram.  This patch changes the existing ds1742 driver to support also
ds1743.  The main change is that the nvram size is determined from the
resource attached to the device.

The patch have benefitted from suggestions from Atsushi Nemeto, who is the
author of the ds1742 driver.

Signed-off-by: Torsten Rasmussen Rasmussen <tr@newtec.dk>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/Kconfig      |    4 +-
 drivers/rtc/rtc-ds1742.c |   67 +++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 30 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-ds1743-support drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-ds1743-support
+++ a/drivers/rtc/Kconfig
@@ -154,11 +154,11 @@ config RTC_DRV_DS1672
 	  will be called rtc-ds1672.
 
 config RTC_DRV_DS1742
-	tristate "Dallas DS1742"
+	tristate "Dallas DS1742/1743"
 	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
-	  Dallas DS1742 timekeeping chip.
+	  Dallas DS1742/1743 timekeeping chip.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1742.
diff -puN drivers/rtc/rtc-ds1742.c~rtc-ds1743-support drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-ds1743-support
+++ a/drivers/rtc/rtc-ds1742.c
@@ -6,6 +6,10 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ * Copyright (C) 2006 Torsten Ertbjerg Rasmussen <tr@newtec.dk>
+ *  - nvram size determined from resource
+ *  - this ds1742 driver now supports ds1743.
  */
 
 #include <linux/bcd.h>
@@ -17,20 +21,19 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
-#define DRV_VERSION "0.2"
+#define DRV_VERSION "0.3"
 
-#define RTC_REG_SIZE		0x800
-#define RTC_OFFSET		0x7f8
+#define RTC_SIZE		8
 
-#define RTC_CONTROL		(RTC_OFFSET + 0)
-#define RTC_CENTURY		(RTC_OFFSET + 0)
-#define RTC_SECONDS		(RTC_OFFSET + 1)
-#define RTC_MINUTES		(RTC_OFFSET + 2)
-#define RTC_HOURS		(RTC_OFFSET + 3)
-#define RTC_DAY			(RTC_OFFSET + 4)
-#define RTC_DATE		(RTC_OFFSET + 5)
-#define RTC_MONTH		(RTC_OFFSET + 6)
-#define RTC_YEAR		(RTC_OFFSET + 7)
+#define RTC_CONTROL		0
+#define RTC_CENTURY		0
+#define RTC_SECONDS		1
+#define RTC_MINUTES		2
+#define RTC_HOURS		3
+#define RTC_DAY			4
+#define RTC_DATE		5
+#define RTC_MONTH		6
+#define RTC_YEAR		7
 
 #define RTC_CENTURY_MASK	0x3f
 #define RTC_SECONDS_MASK	0x7f
@@ -48,7 +51,10 @@
 
 struct rtc_plat_data {
 	struct rtc_device *rtc;
-	void __iomem *ioaddr;
+	void __iomem *ioaddr_nvram;
+	void __iomem *ioaddr_rtc;
+	size_t size_nvram;
+	size_t size;
 	unsigned long baseaddr;
 	unsigned long last_jiffies;
 };
@@ -57,7 +63,7 @@ static int ds1742_rtc_set_time(struct de
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	void __iomem *ioaddr = pdata->ioaddr;
+	void __iomem *ioaddr = pdata->ioaddr_rtc;
 	u8 century;
 
 	century = BIN2BCD((tm->tm_year + 1900) / 100);
@@ -82,7 +88,7 @@ static int ds1742_rtc_read_time(struct d
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	void __iomem *ioaddr = pdata->ioaddr;
+	void __iomem *ioaddr = pdata->ioaddr_rtc;
 	unsigned int year, month, day, hour, minute, second, week;
 	unsigned int century;
 
@@ -127,10 +133,10 @@ static ssize_t ds1742_nvram_read(struct 
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	void __iomem *ioaddr = pdata->ioaddr;
+	void __iomem *ioaddr = pdata->ioaddr_nvram;
 	ssize_t count;
 
-	for (count = 0; size > 0 && pos < RTC_OFFSET; count++, size--)
+	for (count = 0; size > 0 && pos < pdata->size_nvram; count++, size--)
 		*buf++ = readb(ioaddr + pos++);
 	return count;
 }
@@ -141,10 +147,10 @@ static ssize_t ds1742_nvram_write(struct
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	void __iomem *ioaddr = pdata->ioaddr;
+	void __iomem *ioaddr = pdata->ioaddr_nvram;
 	ssize_t count;
 
-	for (count = 0; size > 0 && pos < RTC_OFFSET; count++, size--)
+	for (count = 0; size > 0 && pos < pdata->size_nvram; count++, size--)
 		writeb(*buf++, ioaddr + pos++);
 	return count;
 }
@@ -155,7 +161,6 @@ static struct bin_attribute ds1742_nvram
 		.mode = S_IRUGO | S_IWUGO,
 		.owner = THIS_MODULE,
 	},
-	.size = RTC_OFFSET,
 	.read = ds1742_nvram_read,
 	.write = ds1742_nvram_write,
 };
@@ -175,19 +180,23 @@ static int __init ds1742_rtc_probe(struc
 	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	if (!request_mem_region(res->start, RTC_REG_SIZE, pdev->name)) {
+	pdata->size = res->end - res->start + 1;
+	if (!request_mem_region(res->start, pdata->size, pdev->name)) {
 		ret = -EBUSY;
 		goto out;
 	}
 	pdata->baseaddr = res->start;
-	ioaddr = ioremap(pdata->baseaddr, RTC_REG_SIZE);
+	ioaddr = ioremap(pdata->baseaddr, pdata->size);
 	if (!ioaddr) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	pdata->ioaddr = ioaddr;
+	pdata->ioaddr_nvram = ioaddr;
+	pdata->size_nvram = pdata->size - RTC_SIZE;
+	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
 
 	/* turn RTC on if it was not on */
+	ioaddr = pdata->ioaddr_rtc;
 	sec = readb(ioaddr + RTC_SECONDS);
 	if (sec & RTC_STOP) {
 		sec &= RTC_SECONDS_MASK;
@@ -208,6 +217,8 @@ static int __init ds1742_rtc_probe(struc
 	pdata->rtc = rtc;
 	pdata->last_jiffies = jiffies;
 	platform_set_drvdata(pdev, pdata);
+	ds1742_nvram_attr.size = max(ds1742_nvram_attr.size,
+				     pdata->size_nvram);
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1742_nvram_attr);
 	if (ret)
 		goto out;
@@ -215,10 +226,10 @@ static int __init ds1742_rtc_probe(struc
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (ioaddr)
-		iounmap(ioaddr);
+	if (pdata->ioaddr_nvram)
+		iounmap(pdata->ioaddr_nvram);
 	if (pdata->baseaddr)
-		release_mem_region(pdata->baseaddr, RTC_REG_SIZE);
+		release_mem_region(pdata->baseaddr, pdata->size);
 	kfree(pdata);
 	return ret;
 }
@@ -229,8 +240,8 @@ static int __devexit ds1742_rtc_remove(s
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1742_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	iounmap(pdata->ioaddr);
-	release_mem_region(pdata->baseaddr, RTC_REG_SIZE);
+	iounmap(pdata->ioaddr_nvram);
+	release_mem_region(pdata->baseaddr, pdata->size);
 	kfree(pdata);
 	return 0;
 }
_

Patches currently in -mm which might be from tr@newtec.dk are

origin.patch

