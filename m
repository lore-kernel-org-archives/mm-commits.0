From: akpm@linux-foundation.org
Subject: [alternative-merged]
 rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc.patch removed
 from -mm tree
Date: Wed, 01 Apr 2015 12:21:15 -0700
Message-ID: <551c452b.WNISDUC+xJtdWSV1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbbDATVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2015 15:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phdm@macqel.be, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: add rtc-abx805, a driver for the Abracon AB 1805 i2c rtc
has been removed from the -mm tree.  Its filename was
     rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Philippe De Muyter <phdm@macqel.be>
Subject: rtc: add rtc-abx805, a driver for the Abracon AB 1805 i2c rtc

This is a basic driver for the ultra-low-power Abracon AB 1805 RTC chip. 
It allows reading and writing the time, and enables the supercapacitor/
battery charger.

[arnd@arndb.de: abx805 depends on i2c]
Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    8 +
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-abx805.c |  223 +++++++++++++++++++++++++++++++++++++
 3 files changed, 232 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc
+++ a/drivers/rtc/Kconfig
@@ -1081,6 +1081,14 @@ config RTC_DRV_AB8500
 	  Select this to enable the ST-Ericsson AB8500 power management IC RTC
 	  support. This chip contains a battery- and capacitor-backed RTC.
 
+config RTC_DRV_ABX805
+	tristate "Abracon AB X805 RTC"
+	depends on I2C
+	help
+	  Select this to enable support for the Abracon AB X805 RTC.
+	  AB X805 is the i2c flavour of the AB 18X5 family of ultra-low-power
+	  battery- and capacitor-backed RTC..
+
 config RTC_DRV_NUC900
 	tristate "NUC910/NUC920 RTC driver"
 	depends on ARCH_W90X900
diff -puN drivers/rtc/Makefile~rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc
+++ a/drivers/rtc/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_RTC_DRV_88PM80X)	+= rtc-88p
 obj-$(CONFIG_RTC_DRV_AB3100)	+= rtc-ab3100.o
 obj-$(CONFIG_RTC_DRV_AB8500)	+= rtc-ab8500.o
 obj-$(CONFIG_RTC_DRV_ABB5ZES3)	+= rtc-ab-b5ze-s3.o
+obj-$(CONFIG_RTC_DRV_ABX805)	+= rtc-abx805.o
 obj-$(CONFIG_RTC_DRV_ARMADA38X)	+= rtc-armada38x.o
 obj-$(CONFIG_RTC_DRV_AS3722)	+= rtc-as3722.o
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
diff -puN /dev/null drivers/rtc/rtc-abx805.c
--- /dev/null
+++ a/drivers/rtc/rtc-abx805.c
@@ -0,0 +1,223 @@
+/*
+ * A driver for the I2C members of the Abracon AB 18X5 RTC family,
+ * and compatible: AB 1805 and AB 0805
+ *
+ * Copyright 2014-2015 Macq S.A.
+ *
+ * Author: Philippe De Muyter <phdm@macqel.be>
+ *
+ * Based on rtc-em3027.c by Mike Rapoport <mike@compulab.co.il>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/i2c.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/module.h>
+
+/* Registers */
+
+#define ABX805_REG_SECONDS		0x01
+#define ABX805_REG_CONFIGURATION_KEY	0x1f
+#define		KEY_ENABLE_MISC_REGISTERS_WRITE_ACCESS	0x90
+#define ABX805_REG_TRICKLE		0x20
+#define		TRICKLE_CHARGE_ENABLE		0xA0
+#define		TRICKLE_STANDARD_DIODE		0x8
+#define		TRICKLE_SCHOTTKY_DIODE		0x4
+#define		TRICKLE_OUTPUT_RESISTOR_3KOHM	0x1
+#define		TRICKLE_OUTPUT_RESISTOR_6KOHM	0x2
+#define		TRICKLE_OUTPUT_RESISTOR_11KOHM	0x3
+#define ABX805_REG_ID0			0x28
+
+static struct i2c_driver abx805_driver;
+
+static int abx805_read_multiple_regs(struct i2c_client *client,
+				     u8 *buf, u8 addr0, int len)
+{
+	u8 addr = addr0;
+	struct i2c_msg msgs[] = {
+		{/* setup read addr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = &addr
+		},
+		{/* read into buf */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = buf
+		},
+	};
+
+	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int abx805_enable_trickle_charger(struct i2c_client *client)
+{
+	u8 buf[2];
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.len = 2,
+		.buf = buf,
+	};
+
+	/*
+	 * Write 0x90 in the configuration key register (0x1F) to enable
+	 * the access to the Trickle register
+	 */
+	buf[0] = ABX805_REG_CONFIGURATION_KEY;
+	buf[1] = 0x9D;
+
+	/* write register */
+	if ((i2c_transfer(client->adapter, &msg, 1)) != 1) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
+		return -EIO;
+	}
+
+	buf[0] = ABX805_REG_TRICKLE;
+	buf[1] = TRICKLE_CHARGE_ENABLE | TRICKLE_SCHOTTKY_DIODE |
+		 TRICKLE_OUTPUT_RESISTOR_3KOHM;
+
+	/* write register */
+	if ((i2c_transfer(client->adapter, &msg, 1)) != 1) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int abx805_get_time(struct device *dev, struct rtc_time *tm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 buf[7];
+	int err;
+
+	dev_dbg(dev, "abx805_get_time\n");
+	/* read time/date registers */
+	err = abx805_read_multiple_regs(client, buf, ABX805_REG_SECONDS,
+					sizeof(buf));
+	if (err) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return err;
+	}
+
+	tm->tm_sec	= bcd2bin(buf[0]);
+	tm->tm_min	= bcd2bin(buf[1]);
+	tm->tm_hour	= bcd2bin(buf[2]);
+	tm->tm_mday	= bcd2bin(buf[3]);
+	tm->tm_mon	= bcd2bin(buf[4]) - 1;
+	tm->tm_year	= bcd2bin(buf[5]) + 100;
+	tm->tm_wday	= bcd2bin(buf[6]);
+
+	return 0;
+}
+
+static int abx805_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 buf[8];
+
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.len = 8,
+		.buf = buf,	/* write time/date */
+	};
+
+	dev_dbg(dev, "abx805_set_time\n");
+	buf[0] = ABX805_REG_SECONDS;
+	buf[1] = bin2bcd(tm->tm_sec);
+	buf[2] = bin2bcd(tm->tm_min);
+	buf[3] = bin2bcd(tm->tm_hour);
+	buf[4] = bin2bcd(tm->tm_mday);
+	buf[5] = bin2bcd(tm->tm_mon + 1);
+	buf[6] = bin2bcd(tm->tm_year % 100);
+	buf[7] = bin2bcd(tm->tm_wday);
+
+	/* write time/date registers */
+	if ((i2c_transfer(client->adapter, &msg, 1)) != 1) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static const struct rtc_class_ops abx805_rtc_ops = {
+	.read_time = abx805_get_time,
+	.set_time = abx805_set_time,
+};
+
+static int abx805_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	int err;
+	struct rtc_device *rtc;
+	char buf[7];
+	unsigned int partnumber;
+	unsigned int majrev, minrev;
+	unsigned int lot;
+	unsigned int wafer;
+	unsigned int uid;
+
+	dev_info(&client->dev, "abx805_probe\n");
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -ENODEV;
+
+	err = abx805_read_multiple_regs(client, buf, ABX805_REG_ID0,
+					sizeof(buf));
+	if (err)
+		return err;
+
+	partnumber = (buf[0] << 8) | buf[1];
+	majrev = buf[2] >> 3;
+	minrev = buf[2] & 0x7;
+	lot = ((buf[4] & 0x80) << 2) | ((buf[6] & 0x80) << 1) | buf[3];
+	uid = ((buf[4] & 0x7f) << 8) | buf[5];
+	wafer = (buf[6] & 0x7c) >> 2;
+	dev_info(&client->dev, "model %04x, revision %u.%u, lot %x, wafer %x, uid %x\n",
+			partnumber, majrev, minrev, lot, wafer, uid);
+
+	abx805_enable_trickle_charger(client);
+
+	rtc = devm_rtc_device_register(&client->dev, abx805_driver.driver.name,
+				  &abx805_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	i2c_set_clientdata(client, rtc);
+
+	return 0;
+}
+
+static int abx805_remove(struct i2c_client *client)
+{
+	return 0;
+}
+
+static struct i2c_device_id abx805_id[] = {
+	{ "abx805-rtc", 0 },
+	{ }
+};
+
+static struct i2c_driver abx805_driver = {
+	.driver = {
+		   .name = "abx805-rtc",
+	},
+	.probe = &abx805_probe,
+	.remove = &abx805_remove,
+	.id_table = abx805_id,
+};
+
+module_i2c_driver(abx805_driver);
+
+MODULE_AUTHOR("Philippe De Muyter <phdm@macqel.be>");
+MODULE_DESCRIPTION("Abracon AB X805 RTC driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from phdm@macqel.be are

rtc-add-abracon-abx80x-driver.patch
rtc-add-abracon-abx80x-driver-fix.patch

