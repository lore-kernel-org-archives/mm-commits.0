From: akpm@linux-foundation.org
Subject: [to-be-updated] rtc-add-ds1685-ds1687-rtc-driver.patch removed from -mm tree
Date: Wed, 10 Jun 2009 11:35:07 -0700
Message-ID: <200906101835.n5AIZ72M007555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbZFJSfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 14:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.fuchs@esd-electronics.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: add DS1685/DS1687 rtc driver
has been removed from the -mm tree.  Its filename was
     rtc-add-ds1685-ds1687-rtc-driver.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add DS1685/DS1687 rtc driver
From: Matthias Fuchs <matthias.fuchs@esd-electronics.com>

Add the rtc-ds1685 driver for DS1685/DS1687 rtc chips.

[a.zummo@towertech.it: replaced __devinit/__devexit due to platform_driver_probe]
Signed-off-by: Matthias Fuchs <matthias.fuchs@esd-electronics.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |   12 
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-ds1685.c |  470 +++++++++++++++++++++++++++++++++++++
 3 files changed, 483 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-ds1685-ds1687-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-ds1685-ds1687-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -166,6 +166,18 @@ config RTC_DRV_DS1672
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1672.
 
+config RTC_DRV_DS1685
+	tristate "Dallas/Maxim DS1685/DS1687"
+	help
+	  If you say yes here you get support for the
+	  Dallas/Maxim DS1685/DS1687 timekeeping chip.
+
+	  This RTC chip is used on EPPC-405-UC modules
+	  by electronic system design gmbh.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ds1685.
+
 config RTC_DRV_MAX6900
 	tristate "Maxim MAX6900"
 	help
diff -puN drivers/rtc/Makefile~rtc-add-ds1685-ds1687-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-ds1685-ds1687-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_RTC_DRV_DS1390)	+= rtc-ds13
 obj-$(CONFIG_RTC_DRV_DS1511)	+= rtc-ds1511.o
 obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
 obj-$(CONFIG_RTC_DRV_DS1672)	+= rtc-ds1672.o
+obj-$(CONFIG_RTC_DRV_DS1685)	+= rtc-ds1685.o
 obj-$(CONFIG_RTC_DRV_DS1742)	+= rtc-ds1742.o
 obj-$(CONFIG_RTC_DRV_DS3234)	+= rtc-ds3234.o
 obj-$(CONFIG_RTC_DRV_EFI)	+= rtc-efi.o
diff -puN /dev/null drivers/rtc/rtc-ds1685.c
--- /dev/null
+++ a/drivers/rtc/rtc-ds1685.c
@@ -0,0 +1,470 @@
+/*
+ * An rtc driver for the Dallas DS1685/DS1687
+ *
+ * Copyright (C) 2009 Matthias Fuchs <matthias.fuchs@esd-electronics.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/bcd.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+#define DRV_VERSION		"0.1"
+
+#define NVRAM_SIZE_B0		114
+#define NVRAM_SIZE_B1		128
+#define NVRAM_SIZE		(NVRAM_SIZE_B0 + NVRAM_SIZE_B1)
+
+#define RTC_SECONDS		0
+#define RTC_MINUTES		2
+#define RTC_HOURS		4
+#define RTC_DAY			6
+#define RTC_DATE		7
+#define RTC_MONTH		8
+#define RTC_YEAR		9
+
+#define RTC_CONTROLA		0x0a
+#define RTC_CONTROLB		0x0b
+#define RTC_CONTROLC		0x0c
+#define RTC_CONTROLD		0x0d
+#define RTC_NVRAM_START_B0	0x0e
+
+/* bits in control A register */
+#define RTC_DV2			0x40
+#define RTC_DV1			0x20
+#define RTC_DV0			0x10
+
+/* bits in control B register */
+#define RTC_SET			0x80
+#define RTC_DM			0x04
+#define RTC_2412		0x02
+
+/* bits in control D register */
+#define RTC_VRT			0x80
+
+/* bank 1 only registers */
+#define RTC_MODEL		0x40
+#define RTC_CENTURY		0x48
+#define RTC_RAM_ADDR		0x50
+#define RTC_RAM_DATA		0x53
+
+struct rtc_plat_data {
+	struct rtc_device *rtc;
+	void __iomem *ioaddr;
+	size_t size;
+	resource_size_t baseaddr;
+	unsigned long last_jiffies;
+};
+
+static int ds1685_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	unsigned int ctrla, ctrlb;
+
+	/* set SET bit */
+	ctrlb = readb(ioaddr + RTC_CONTROLB);
+	ctrlb |= RTC_SET;
+	writeb(ctrlb, ioaddr + RTC_CONTROLB);
+
+	writeb(bin2bcd(tm->tm_year % 100), ioaddr + RTC_YEAR);
+	writeb(bin2bcd(tm->tm_mon + 1), ioaddr + RTC_MONTH);
+	writeb(bin2bcd(tm->tm_wday), ioaddr + RTC_DAY);
+	writeb(bin2bcd(tm->tm_mday), ioaddr + RTC_DATE);
+	writeb(bin2bcd(tm->tm_hour), ioaddr + RTC_HOURS);
+	writeb(bin2bcd(tm->tm_min), ioaddr + RTC_MINUTES);
+	writeb(bin2bcd(tm->tm_sec), ioaddr + RTC_SECONDS);
+
+	/* switch to 2nd bank */
+	ctrla = readb(ioaddr + RTC_CONTROLA);
+	ctrla |= RTC_DV0;
+	writeb(ctrla, ioaddr + RTC_CONTROLA);
+
+	writeb(bin2bcd((tm->tm_year + 1900) / 100), ioaddr + RTC_CENTURY);
+
+	/* switch back to original bank */
+	ctrla &= ~RTC_DV0;
+	writeb(ctrla, ioaddr + RTC_CONTROLA);
+
+	/* clear SET bit */
+	ctrlb &= ~RTC_SET;
+	writeb(ctrlb, ioaddr + RTC_CONTROLB);
+
+	return 0;
+}
+
+static int ds1685_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	unsigned int century, year, month, day, hour, minute, second, week;
+	unsigned int ctrla, ctrlb;
+
+	/* give enough time to update RTC in case of continuous read */
+	if (pdata->last_jiffies == jiffies)
+		msleep(1);
+	pdata->last_jiffies = jiffies;
+
+	/* set SET bit */
+	ctrlb = readb(ioaddr + RTC_CONTROLB);
+	ctrlb |= RTC_SET;
+	writeb(ctrlb, ioaddr + RTC_CONTROLB);
+
+	second = readb(ioaddr + RTC_SECONDS);
+	minute = readb(ioaddr + RTC_MINUTES);
+	hour = readb(ioaddr + RTC_HOURS);
+	day = readb(ioaddr + RTC_DATE);
+	week = readb(ioaddr + RTC_DAY);
+	month = readb(ioaddr + RTC_MONTH);
+	year = readb(ioaddr + RTC_YEAR);
+
+	/* switch to 2nd bank */
+	ctrla = readb(ioaddr + RTC_CONTROLA);
+	ctrla |= RTC_DV0;
+	writeb(ctrla, ioaddr + RTC_CONTROLA);
+
+	century = readb(ioaddr + RTC_CENTURY);
+
+	/* switch back to original bank */
+	ctrla &= ~RTC_DV0;
+	writeb(ctrla, ioaddr + RTC_CONTROLA);
+
+	/* clear SET bit */
+	ctrlb &= ~RTC_SET;
+	writeb(ctrlb, ioaddr + RTC_CONTROLB);
+
+	tm->tm_sec = bcd2bin(second);
+	tm->tm_min = bcd2bin(minute);
+	tm->tm_hour = bcd2bin(hour);
+	tm->tm_mday = bcd2bin(day);
+	tm->tm_wday = bcd2bin(week);
+	tm->tm_mon = bcd2bin(month) - 1;
+
+	/* year is 1900 + tm->tm_year */
+	tm->tm_year = bcd2bin(year) + bcd2bin(century) * 100 - 1900;
+
+	return rtc_valid_tm(tm);
+}
+
+static int ds1685_get_ssn(struct rtc_plat_data *pdata, u8 *ssn)
+{
+	void __iomem *ioaddr = pdata->ioaddr;
+	int i;
+	unsigned int ctrl;
+
+	/* switch to 2nd bank */
+	ctrl = readb(ioaddr + RTC_CONTROLA);
+	ctrl |= RTC_DV0;
+	writeb(ctrl, ioaddr + RTC_CONTROLA);
+
+	/* read silicon serial number */
+	for (i = 0; i < 8; i++)
+		ssn[i] = readb(ioaddr + RTC_MODEL + i);
+
+	/* switch back to original bank */
+	ctrl &= ~RTC_DV0;
+	writeb(ctrl, ioaddr + RTC_CONTROLA);
+
+	return 0;
+}
+
+static int ds1685_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	unsigned int val;
+	u8 ssn[8];
+
+	mutex_lock(&pdata->rtc->ops_lock);
+	val = readb(ioaddr + RTC_CONTROLD);
+	ds1685_get_ssn(pdata, ssn);
+	mutex_unlock(&pdata->rtc->ops_lock);
+
+	seq_printf(seq, "battery\t\t: %s\n",
+		   (val & RTC_VRT) ? "ok" : "exhausted");
+	seq_printf(seq, "serial#\t\t: "
+		   "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+		   ssn[0], ssn[1], ssn[2], ssn[3],
+		   ssn[4], ssn[5], ssn[6], ssn[7]);
+	return 0;
+}
+
+static const struct rtc_class_ops ds1685_rtc_ops = {
+	.proc		= ds1685_rtc_proc,
+	.read_time	= ds1685_rtc_read_time,
+	.set_time	= ds1685_rtc_set_time,
+};
+
+static ssize_t ds1685_nvram_read(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t size)
+{
+	struct platform_device *pdev =
+		to_platform_device(container_of(kobj, struct device, kobj));
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	ssize_t count;
+
+	mutex_lock(&pdata->rtc->ops_lock);
+	for (count = 0; size > 0 && pos < NVRAM_SIZE_B0; count++, size--)
+		*buf++ = readb(ioaddr + RTC_NVRAM_START_B0 + pos++);
+
+	if (size > 0) {
+		unsigned int ctrl = readb(ioaddr + RTC_CONTROLA);
+		/* switch to 2nd bank */
+		ctrl |= RTC_DV0;
+		writeb(ctrl, ioaddr + RTC_CONTROLA);
+
+		for (count = 0; size > 0 && pos < NVRAM_SIZE; count++, size--) {
+			writeb(pos - NVRAM_SIZE_B0, ioaddr + RTC_RAM_ADDR);
+			*buf++ = readb(ioaddr + RTC_RAM_DATA);
+			pos++;
+		}
+
+		/* switch back to original bank */
+		ctrl &= ~RTC_DV0;
+		writeb(ctrl, ioaddr + RTC_CONTROLA);
+	}
+	mutex_unlock(&pdata->rtc->ops_lock);
+	return count;
+}
+
+static ssize_t ds1685_nvram_write(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t pos, size_t size)
+{
+	struct platform_device *pdev =
+		to_platform_device(container_of(kobj, struct device, kobj));
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	ssize_t count;
+
+	mutex_lock(&pdata->rtc->ops_lock);
+	for (count = 0; size > 0 && pos < NVRAM_SIZE_B0; count++, size--)
+		writeb(*buf++, ioaddr +  RTC_NVRAM_START_B0 + pos++);
+
+	if (size > 0) {
+		unsigned int ctrl = readb(ioaddr + RTC_CONTROLA);
+		/* switch to 2nd bank */
+		ctrl |= RTC_DV0;
+		writeb(ctrl, ioaddr + RTC_CONTROLA);
+
+		for (count = 0; size > 0 && pos < NVRAM_SIZE; count++, size--) {
+			writeb(pos - NVRAM_SIZE_B0, ioaddr + RTC_RAM_ADDR);
+			writeb(*buf++, ioaddr + RTC_RAM_DATA);
+			pos++;
+		}
+
+		/* switch back to original bank */
+		ctrl &= ~RTC_DV0;
+		writeb(ctrl, ioaddr + RTC_CONTROLA);
+	}
+	mutex_unlock(&pdata->rtc->ops_lock);
+
+	return count;
+}
+
+static struct bin_attribute ds1685_nvram_attr = {
+	.attr = {
+		.name = "nvram",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.read = ds1685_nvram_read,
+	.write = ds1685_nvram_write,
+	.size = NVRAM_SIZE
+};
+
+static ssize_t
+ds1685_sysfs_show_battery(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	unsigned int val;
+
+	mutex_lock(&pdata->rtc->ops_lock);
+	val = readb(ioaddr + RTC_CONTROLD);
+	mutex_unlock(&pdata->rtc->ops_lock);
+
+	return sprintf(buf, "%s\n", (val & RTC_VRT) ? "ok" : "exhausted");
+}
+
+static DEVICE_ATTR(battery, S_IRUGO, ds1685_sysfs_show_battery, NULL);
+
+static ssize_t
+ds1685_sysfs_show_serial(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	u8 ssn[8];
+
+	mutex_lock(&pdata->rtc->ops_lock);
+	ds1685_get_ssn(pdata, ssn);
+	mutex_unlock(&pdata->rtc->ops_lock);
+
+	return sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+		       ssn[0], ssn[1], ssn[2], ssn[3],
+		       ssn[4], ssn[5], ssn[6], ssn[7]);
+}
+
+static DEVICE_ATTR(serial, S_IRUGO, ds1685_sysfs_show_serial, NULL);
+
+static int ds1685_sysfs_register(struct device *dev)
+{
+	int err;
+
+	err = sysfs_create_bin_file(&dev->kobj, &ds1685_nvram_attr);
+	if (err)
+		return err;
+
+	err = device_create_file(dev, &dev_attr_battery);
+	if (err) {
+		sysfs_remove_bin_file(&dev->kobj, &ds1685_nvram_attr);
+		return err;
+	}
+
+	err = device_create_file(dev, &dev_attr_serial);
+	if (err) {
+		device_remove_file(dev, &dev_attr_battery);
+		sysfs_remove_bin_file(&dev->kobj, &ds1685_nvram_attr);
+		return err;
+	}
+
+	return 0;
+}
+
+static int ds1685_sysfs_unregister(struct device *dev)
+{
+	sysfs_remove_bin_file(&dev->kobj, &ds1685_nvram_attr);
+	device_remove_file(dev, &dev_attr_battery);
+	device_remove_file(dev, &dev_attr_serial);
+
+	return 0;
+}
+
+static int __init ds1685_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtc;
+	struct resource *res;
+	unsigned int ctrl;
+	struct rtc_plat_data *pdata = NULL;
+	void __iomem *ioaddr = NULL;
+	int ret = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdata->size = resource_size(res);
+	if (!request_mem_region(res->start, pdata->size, pdev->name)) {
+		ret = -EBUSY;
+		goto out;
+	}
+	pdata->baseaddr = res->start;
+
+	ioaddr = ioremap(pdata->baseaddr, pdata->size);
+	if (!ioaddr) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	pdata->ioaddr = ioaddr;
+
+	/* turn RTC on if it was not on */
+	ctrl = readb(ioaddr + RTC_CONTROLA);
+	if (!(ctrl & RTC_DV1)) {
+		dev_warn(&pdev->dev,
+			 "oscillator stop detected - enabled!\n");
+		ctrl |= RTC_DV1;
+	}
+	ctrl &= ~RTC_DV2;
+	ctrl &= ~RTC_DV0; /* enable original bank */
+	writeb(ctrl, ioaddr + RTC_CONTROLA);
+
+	if (!(readb(ioaddr + RTC_CONTROLD) & RTC_VRT))
+		dev_warn(&pdev->dev, "low battery detected.\n");
+
+	ctrl = readb(ioaddr + RTC_CONTROLB);
+	if ((ctrl & RTC_DM) || (!(ctrl & RTC_2412))) {
+		dev_dbg(&pdev->dev, "only 24-hr BCD mode supported\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	rtc = rtc_device_register(pdev->name, &pdev->dev,
+				  &ds1685_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		goto out;
+	}
+	pdata->rtc = rtc;
+	pdata->last_jiffies = jiffies;
+	platform_set_drvdata(pdev, pdata);
+	ret = ds1685_sysfs_register(&pdev->dev);
+	if (ret)
+		goto out;
+	return 0;
+ out:
+	if (pdata->rtc)
+		rtc_device_unregister(pdata->rtc);
+	if (pdata->ioaddr)
+		iounmap(pdata->ioaddr);
+	if (pdata->baseaddr)
+		release_mem_region(pdata->baseaddr, pdata->size);
+	kfree(pdata);
+	return ret;
+}
+
+static int __exit ds1685_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+
+	ds1685_sysfs_unregister(&pdev->dev);
+	rtc_device_unregister(pdata->rtc);
+	iounmap(pdata->ioaddr);
+	release_mem_region(pdata->baseaddr, pdata->size);
+	kfree(pdata);
+	return 0;
+}
+
+static struct platform_driver ds1685_rtc_driver = {
+	.remove		= __exit_p(ds1685_rtc_remove),
+	.driver		= {
+		.name	= "rtc-ds1685",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static __init int ds1685_init(void)
+{
+	return platform_driver_probe(&ds1685_rtc_driver, ds1685_rtc_probe);
+}
+
+static __exit void ds1685_exit(void)
+{
+	platform_driver_unregister(&ds1685_rtc_driver);
+}
+
+module_init(ds1685_init);
+module_exit(ds1685_exit);
+
+MODULE_AUTHOR("Matthias Fuchs <matthias.fuchs@esd-electronics.com>");
+MODULE_DESCRIPTION("Dallas DS1685/DS1687 RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:rtc-ds1685");
_

Patches currently in -mm which might be from matthias.fuchs@esd-electronics.com are

rtc-add-ds1685-ds1687-rtc-driver.patch

