From: akpm@linux-foundation.org
Subject: + rtc-add-support-of-nvram-for-maxim-dallas-rtc-ds1343.patch
 added to -mm tree
Date: Tue, 10 Jun 2014 16:22:40 -0700
Message-ID: <53979340.vyuTePs72MT3ZnZG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaFJXWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 19:22:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, ravi23ganiga@gmail.com

Subject: + rtc-add-support-of-nvram-for-maxim-dallas-rtc-ds1343.patch added to -mm tree
To: ravi23ganiga@gmail.com,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 16:22:40 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1343.c: add support of nvram for maxim dallas rtc ds1343
has been added to the -mm tree.  Its filename is
     rtc-add-support-of-nvram-for-maxim-dallas-rtc-ds1343.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-support-of-nvram-for-maxim-dallas-rtc-ds1343.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-support-of-nvram-for-maxim-dallas-rtc-ds1343.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: drivers/rtc/rtc-ds1343.c: add support of nvram for maxim dallas rtc ds1343

This is a patch to add support of nvram for maxim dallas rtc ds1343.

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1343.c |   75 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1343.c~rtc-add-support-of-nvram-for-maxim-dallas-rtc-ds1343 drivers/rtc/rtc-ds1343.c
--- a/drivers/rtc/rtc-ds1343.c~rtc-add-support-of-nvram-for-maxim-dallas-rtc-ds1343
+++ a/drivers/rtc/rtc-ds1343.c
@@ -4,6 +4,7 @@
  * Real Time Clock
  *
  * Author : Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
+ *	    Ankur Srivastava <sankurece@gmail.com> : DS1343 Nvram Support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -45,6 +46,9 @@
 #define DS1343_CONTROL_REG	0x0F
 #define DS1343_STATUS_REG	0x10
 #define DS1343_TRICKLE_REG	0x11
+#define DS1343_NVRAM		0x20
+
+#define DS1343_NVRAM_LEN	96
 
 /* DS1343 Control Registers bits */
 #define DS1343_EOSC		0x80
@@ -149,6 +153,64 @@ static ssize_t ds1343_store_glitchfilter
 static DEVICE_ATTR(glitch_filter, S_IRUGO | S_IWUSR, ds1343_show_glitchfilter,
 			ds1343_store_glitchfilter);
 
+static ssize_t ds1343_nvram_write(struct file *filp, struct kobject *kobj,
+			struct bin_attribute *attr,
+			char *buf, loff_t off, size_t count)
+{
+	int ret;
+	unsigned char address;
+	struct device *dev = kobj_to_dev(kobj);
+	struct ds1343_priv *priv = dev_get_drvdata(dev);
+
+	if (unlikely(!count))
+		return count;
+
+	if ((count + off) > DS1343_NVRAM_LEN)
+		count = DS1343_NVRAM_LEN - off;
+
+	address = DS1343_NVRAM + off;
+
+	ret = regmap_bulk_write(priv->map, address, buf, count);
+	if (ret < 0)
+		dev_err(&priv->spi->dev, "Error in nvram write %d", ret);
+
+	return (ret < 0) ? ret : count;
+}
+
+
+static ssize_t ds1343_nvram_read(struct file *filp, struct kobject *kobj,
+				struct bin_attribute *attr,
+				char *buf, loff_t off, size_t count)
+{
+	int ret;
+	unsigned char address;
+	struct device *dev = kobj_to_dev(kobj);
+	struct ds1343_priv *priv = dev_get_drvdata(dev);
+
+	if (unlikely(!count))
+		return count;
+
+	if ((count + off) > DS1343_NVRAM_LEN)
+		count = DS1343_NVRAM_LEN - off;
+
+	address = DS1343_NVRAM + off;
+
+	ret = regmap_bulk_read(priv->map, address, buf, count);
+	if (ret < 0)
+		dev_err(&priv->spi->dev, "Error in nvram read %d\n", ret);
+
+	return (ret < 0) ? ret : count;
+}
+
+
+static struct bin_attribute nvram_attr = {
+	.attr.name	= "nvram",
+	.attr.mode	= S_IRUGO | S_IWUSR,
+	.read		= ds1343_nvram_read,
+	.write		= ds1343_nvram_write,
+	.size		= DS1343_NVRAM_LEN,
+};
+
 static ssize_t ds1343_show_alarmstatus(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -274,12 +336,16 @@ static int ds1343_sysfs_register(struct
 	if (err)
 		goto error1;
 
+	err = device_create_bin_file(dev, &nvram_attr);
+	if (err)
+		goto error2;
+
 	if (priv->irq <= 0)
 		return err;
 
 	err = device_create_file(dev, &dev_attr_alarm_mode);
 	if (err)
-		goto error2;
+		goto error3;
 
 	err = device_create_file(dev, &dev_attr_alarm_status);
 	if (!err)
@@ -287,6 +353,9 @@ static int ds1343_sysfs_register(struct
 
 	device_remove_file(dev, &dev_attr_alarm_mode);
 
+error3:
+	device_remove_bin_file(dev, &nvram_attr);
+
 error2:
 	device_remove_file(dev, &dev_attr_trickle_charger);
 
@@ -302,6 +371,7 @@ static void ds1343_sysfs_unregister(stru
 
 	device_remove_file(dev, &dev_attr_glitch_filter);
 	device_remove_file(dev, &dev_attr_trickle_charger);
+	device_remove_bin_file(dev, &nvram_attr);
 
 	if (priv->irq <= 0)
 		return;
@@ -684,6 +754,7 @@ static struct spi_driver ds1343_driver =
 module_spi_driver(ds1343_driver);
 
 MODULE_DESCRIPTION("DS1343 RTC SPI Driver");
-MODULE_AUTHOR("Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>");
+MODULE_AUTHOR("Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>,"
+		"Ankur Srivastava <sankurece@gmail.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DS1343_DRV_VERSION);
_

Patches currently in -mm which might be from ravi23ganiga@gmail.com are

origin.patch
rtc-add-support-of-nvram-for-maxim-dallas-rtc-ds1343.patch

