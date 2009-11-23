From: akpm@linux-foundation.org
Subject: + rtc-add-driver-for-bq32000-i2c-rtc.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:31:50 -0800
Message-ID: <200911232131.nANLVowO003032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756788AbZKWVcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosmo@semihalf.com, a.zummo@towertech.it


The patch titled
     rtc: add driver for BQ32000 I2C RTC
has been added to the -mm tree.  Its filename is
     rtc-add-driver-for-bq32000-i2c-rtc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add driver for BQ32000 I2C RTC
From: Piotr Ziecik <kosmo@semihalf.com>

This patch adds basic support for Texas Instruments BQ32000 I2C RTC.  Only
time reading/writing is implemented.  Advanced features, such as trickle
charger and crystal calibration are not supported.

Signed-off-by: Piotr Ziecik <kosmo@semihalf.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig     |    9 +
 drivers/rtc/Makefile    |    1 
 drivers/rtc/rtc-bq32k.c |  204 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-driver-for-bq32000-i2c-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-driver-for-bq32000-i2c-rtc
+++ a/drivers/rtc/Kconfig
@@ -242,6 +242,15 @@ config RTC_DRV_M41T80_WDT
 	  If you say Y here you will get support for the
 	  watchdog timer in the ST M41T60 and M41T80 RTC chips series.
 
+config RTC_DRV_BQ32K
+	tristate "TI BQ32000"
+	help
+	  If you say Y here you will get support for the TI
+	  BQ32000 I2C RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-bq32k.
+
 config RTC_DRV_DM355EVM
 	tristate "TI DaVinci DM355 EVM RTC"
 	depends on MFD_DM355EVM_MSP
diff -puN drivers/rtc/Makefile~rtc-add-driver-for-bq32000-i2c-rtc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-driver-for-bq32000-i2c-rtc
+++ a/drivers/rtc/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-a
 obj-$(CONFIG_RTC_DRV_AT91SAM9)	+= rtc-at91sam9.o
 obj-$(CONFIG_RTC_DRV_AU1XXX)	+= rtc-au1xxx.o
 obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
+obj-$(CONFIG_RTC_DRV_BQ32K)	+= rtc-bq32k.o
 obj-$(CONFIG_RTC_DRV_BQ4802)	+= rtc-bq4802.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
diff -puN /dev/null drivers/rtc/rtc-bq32k.c
--- /dev/null
+++ a/drivers/rtc/rtc-bq32k.c
@@ -0,0 +1,204 @@
+/*
+ * Driver for TI BQ32000 RTC.
+ *
+ * Copyright (C) 2009 Semihalf.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/rtc.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/bcd.h>
+
+#define BQ32K_SECONDS		0x00	/* Seconds register address */
+#define BQ32K_SECONDS_MASK	0x7F	/* Mask over seconds value */
+#define BQ32K_STOP		0x80	/* Oscillator Stop flat */
+
+#define BQ32K_MINUTES		0x01	/* Minutes register address */
+#define BQ32K_MINUTES_MASK	0x7F	/* Mask over minutes value */
+#define BQ32K_OF		0x80	/* Oscillator Failure flag */
+
+#define BQ32K_HOURS_MASK	0x3F	/* Mask over hours value */
+#define BQ32K_CENT		0x40	/* Century flag */
+#define BQ32K_CENT_EN		0x80	/* Century flag enable bit */
+
+struct bq32k_regs {
+	uint8_t		seconds;
+	uint8_t		minutes;
+	uint8_t		cent_hours;
+	uint8_t		day;
+	uint8_t		date;
+	uint8_t		month;
+	uint8_t		years;
+};
+
+static struct i2c_driver bq32k_driver;
+
+static int bq32k_read(struct device *dev, void *data, uint8_t off, uint8_t len)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_msg msgs[] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &off,
+		}, {
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = data,
+		}
+	};
+
+	if (i2c_transfer(client->adapter, msgs, 2) == 2)
+		return 0;
+
+	return -EIO;
+}
+
+static int bq32k_write(struct device *dev, void *data, uint8_t off, uint8_t len)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	uint8_t buffer[len + 1];
+
+	buffer[0] = off;
+	memcpy(&buffer[1], data, len);
+
+	if (i2c_master_send(client, buffer, len + 1) == len + 1)
+		return 0;
+
+	return -EIO;
+}
+
+static int bq32k_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct bq32k_regs regs;
+	int error;
+
+	error = bq32k_read(dev, &regs, 0, sizeof(regs));
+	if (error)
+		return error;
+
+	tm->tm_sec = bcd2bin(regs.seconds & BQ32K_SECONDS_MASK);
+	tm->tm_min = bcd2bin(regs.minutes & BQ32K_SECONDS_MASK);
+	tm->tm_hour = bcd2bin(regs.cent_hours & BQ32K_HOURS_MASK);
+	tm->tm_mday = bcd2bin(regs.date);
+	tm->tm_wday = bcd2bin(regs.day) - 1;
+	tm->tm_mon = bcd2bin(regs.month) - 1;
+	tm->tm_year = bcd2bin(regs.years) +
+				((regs.cent_hours & BQ32K_CENT) ? 100 : 0);
+
+	return rtc_valid_tm(tm);
+}
+
+static int bq32k_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct bq32k_regs regs;
+
+	regs.seconds = bin2bcd(tm->tm_sec);
+	regs.minutes = bin2bcd(tm->tm_min);
+	regs.cent_hours = bin2bcd(tm->tm_hour) | BQ32K_CENT_EN;
+	regs.day = bin2bcd(tm->tm_wday + 1);
+	regs.date = bin2bcd(tm->tm_mday);
+	regs.month = bin2bcd(tm->tm_mon + 1);
+
+	if (tm->tm_year >= 100) {
+		regs.cent_hours |= BQ32K_CENT;
+		regs.years = bin2bcd(tm->tm_year - 100);
+	} else
+		regs.years = bin2bcd(tm->tm_year);
+
+	return bq32k_write(dev, &regs, 0, sizeof(regs));
+}
+
+static const struct rtc_class_ops bq32k_rtc_ops = {
+	.read_time	= bq32k_rtc_read_time,
+	.set_time	= bq32k_rtc_set_time,
+};
+
+static int bq32k_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct rtc_device *rtc;
+	uint8_t reg;
+	int error;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -ENODEV;
+
+	/* Check Oscillator Stop flag */
+	error = bq32k_read(dev, &reg, BQ32K_SECONDS, 1);
+	if (!error && (reg & BQ32K_STOP)) {
+		dev_warn(dev, "Oscillator was halted. Restarting...\n");
+		reg &= ~BQ32K_STOP;
+		error = bq32k_write(dev, &reg, BQ32K_SECONDS, 1);
+	}
+	if (error)
+		return error;
+
+	/* Check Oscillator Failure flag */
+	error = bq32k_read(dev, &reg, BQ32K_MINUTES, 1);
+	if (!error && (reg & BQ32K_OF)) {
+		dev_warn(dev, "Oscillator Failure. Check RTC battery.\n");
+		reg &= ~BQ32K_OF;
+		error = bq32k_write(dev, &reg, BQ32K_MINUTES, 1);
+	}
+	if (error)
+		return error;
+
+	rtc = rtc_device_register(bq32k_driver.driver.name, &client->dev,
+						&bq32k_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	i2c_set_clientdata(client, rtc);
+
+	return 0;
+}
+
+static int __devexit bq32k_remove(struct i2c_client *client)
+{
+	struct rtc_device *rtc = i2c_get_clientdata(client);
+
+	rtc_device_unregister(rtc);
+	return 0;
+}
+
+static const struct i2c_device_id bq32k_id[] = {
+	{ "bq32000", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, bq32k_id);
+
+static struct i2c_driver bq32k_driver = {
+	.driver = {
+		.name	= "bq32k",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= bq32k_probe,
+	.remove		= __devexit_p(bq32k_remove),
+	.id_table	= bq32k_id,
+};
+
+static __init int bq32k_init(void)
+{
+	return i2c_add_driver(&bq32k_driver);
+}
+module_init(bq32k_init);
+
+static __exit void bq32k_exit(void)
+{
+	i2c_del_driver(&bq32k_driver);
+}
+module_exit(bq32k_exit);
+
+MODULE_AUTHOR("Semihalf, Piotr Ziecik <kosmo@semihalf.com>");
+MODULE_DESCRIPTION("TI BQ32000 I2C RTC driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from kosmo@semihalf.com are

rtc-add-driver-for-bq32000-i2c-rtc.patch

