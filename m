From: akpm@linux-foundation.org
Subject: + rtc-add-basic-support-for-st-m41t93-spi-rtc.patch added to -mm tree
Date: Thu, 07 Apr 2011 15:08:00 -0700
Message-ID: <201104072208.p37M80jg003012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466Ab1DGWIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 18:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: N.Voss@weinmann.de, a.zummo@towertech.it, grant.likely@secretlab.ca, n.voss@weinmann.de


The patch titled
     rtc: add basic support for ST M41T93 SPI RTC
has been added to the -mm tree.  Its filename is
     rtc-add-basic-support-for-st-m41t93-spi-rtc.patch

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
Subject: rtc: add basic support for ST M41T93 SPI RTC
From: "Voss, Nikolaus" <N.Voss@weinmann.de>

Add basic support for ST m41t93 SPI RTCs.  Tested with factory-new and
with "run-in" species with and without backup batteries.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    9 +
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-m41t93.c |  225 +++++++++++++++++++++++++++++++++++++
 3 files changed, 235 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-basic-support-for-st-m41t93-spi-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-basic-support-for-st-m41t93-spi-rtc
+++ a/drivers/rtc/Kconfig
@@ -378,6 +378,15 @@ comment "SPI RTC drivers"
 
 if SPI_MASTER
 
+config RTC_DRV_M41T93
+        tristate "ST M41T93"
+        help
+          If you say yes here you will get support for the
+          ST M41T93 SPI RTC chip.
+
+          This driver can also be built as a module. If so, the module
+          will be called rtc-m41t93.
+
 config RTC_DRV_M41T94
 	tristate "ST M41T94"
 	help
diff -puN drivers/rtc/Makefile~rtc-add-basic-support-for-st-m41t93-spi-rtc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-basic-support-for-st-m41t93-spi-rtc
+++ a/drivers/rtc/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_RTC_DRV_ISL12022)	+= rtc-is
 obj-$(CONFIG_RTC_DRV_JZ4740)	+= rtc-jz4740.o
 obj-$(CONFIG_RTC_DRV_LPC32XX)	+= rtc-lpc32xx.o
 obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
+obj-$(CONFIG_RTC_DRV_M41T93)	+= rtc-m41t93.o
 obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t94.o
 obj-$(CONFIG_RTC_DRV_M48T35)	+= rtc-m48t35.o
 obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
diff -puN /dev/null drivers/rtc/rtc-m41t93.c
--- /dev/null
+++ a/drivers/rtc/rtc-m41t93.c
@@ -0,0 +1,225 @@
+/*
+ *
+ * Driver for ST M41T93 SPI RTC
+ *
+ * (c) 2010 Nikolaus Voss, Weinmann Medical GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bcd.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/spi/spi.h>
+
+#define M41T93_REG_SSEC			0
+#define M41T93_REG_ST_SEC		1
+#define M41T93_REG_MIN			2
+#define M41T93_REG_CENT_HOUR		3
+#define M41T93_REG_WDAY			4
+#define M41T93_REG_DAY			5
+#define M41T93_REG_MON			6
+#define M41T93_REG_YEAR			7
+
+
+#define M41T93_REG_ALM_HOUR_HT		0xc
+#define M41T93_REG_FLAGS		0xf
+
+#define M41T93_FLAG_ST			(1 << 7)
+#define M41T93_FLAG_OF			(1 << 2)
+#define M41T93_FLAG_BL			(1 << 4)
+#define M41T93_FLAG_HT			(1 << 6)
+
+static inline int m41t93_set_reg(struct spi_device *spi, u8 addr, u8 data)
+{
+	u8 buf[2];
+
+	/* MSB must be '1' to write */
+	buf[0] = addr | 0x80;
+	buf[1] = data;
+
+	return spi_write(spi, buf, sizeof(buf));
+}
+
+static int m41t93_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u8 buf[9] = {0x80};        /* write cmd + 8 data bytes */
+	u8 * const data = &buf[1]; /* ptr to first data byte */
+
+	dev_dbg(dev, "%s secs=%d, mins=%d, "
+		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
+		"write", tm->tm_sec, tm->tm_min,
+		tm->tm_hour, tm->tm_mday,
+		tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	if (tm->tm_year < 100) {
+		dev_warn(&spi->dev, "unsupported date (before 2000-01-01).\n");
+		return -EINVAL;
+	}
+
+	data[M41T93_REG_SSEC]		= 0;
+	data[M41T93_REG_ST_SEC]		= bin2bcd(tm->tm_sec);
+	data[M41T93_REG_MIN]		= bin2bcd(tm->tm_min);
+	data[M41T93_REG_CENT_HOUR]	= bin2bcd(tm->tm_hour) |
+						((tm->tm_year/100-1) << 6);
+	data[M41T93_REG_DAY]		= bin2bcd(tm->tm_mday);
+	data[M41T93_REG_WDAY]		= bin2bcd(tm->tm_wday + 1);
+	data[M41T93_REG_MON]		= bin2bcd(tm->tm_mon + 1);
+	data[M41T93_REG_YEAR]		= bin2bcd(tm->tm_year % 100);
+
+	return spi_write(spi, buf, sizeof(buf));
+}
+
+
+static int m41t93_get_time(struct device *dev, struct rtc_time *tm)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	const u8 start_addr = 0;
+	u8 buf[8];
+	int century_after_1900;
+	int tmp;
+	int ret = 0;
+
+	/* Check status of clock. Two states must be considered:
+	   1. halt bit (HT) is set: the clock is running but update of readout
+	      registers has been disabled due to power failure. This is normal
+	      case after poweron. Time is valid after resetting HT bit.
+	   2. oscillator fail bit (OF) is set. Oscillator has be stopped and
+	      time is invalid:
+	      a) OF can be immeditely reset.
+	      b) OF cannot be immediately reset: oscillator has to be restarted.
+	*/
+	tmp = spi_w8r8(spi, M41T93_REG_ALM_HOUR_HT);
+	if (tmp < 0)
+		return tmp;
+
+	if (tmp & M41T93_FLAG_HT) {
+		dev_dbg(&spi->dev, "HT bit is set, reenable clock update.\n");
+		m41t93_set_reg(spi, M41T93_REG_ALM_HOUR_HT,
+			       tmp & ~M41T93_FLAG_HT);
+	}
+
+	tmp = spi_w8r8(spi, M41T93_REG_FLAGS);
+	if (tmp < 0)
+		return tmp;
+
+	if (tmp & M41T93_FLAG_OF) {
+		ret = -EINVAL;
+		dev_warn(&spi->dev, "OF bit is set, resetting.\n");
+		m41t93_set_reg(spi, M41T93_REG_FLAGS, tmp & ~M41T93_FLAG_OF);
+
+		tmp = spi_w8r8(spi, M41T93_REG_FLAGS);
+		if (tmp < 0)
+			return tmp;
+		else if (tmp & M41T93_FLAG_OF) {
+			u8 reset_osc = buf[M41T93_REG_ST_SEC] | M41T93_FLAG_ST;
+
+			dev_warn(&spi->dev,
+				 "OF bit is still set, kickstarting clock.\n");
+			m41t93_set_reg(spi, M41T93_REG_ST_SEC, reset_osc);
+			reset_osc &= ~M41T93_FLAG_ST;
+			m41t93_set_reg(spi, M41T93_REG_ST_SEC, reset_osc);
+		}
+	}
+
+	if (tmp & M41T93_FLAG_BL)
+		dev_warn(&spi->dev, "BL bit is set, replace battery.\n");
+
+	/* read actual time/date */
+	tmp = spi_write_then_read(spi, &start_addr, 1, buf, sizeof(buf));
+	if (tmp < 0)
+		return tmp;
+
+	tm->tm_sec	= bcd2bin(buf[M41T93_REG_ST_SEC]);
+	tm->tm_min	= bcd2bin(buf[M41T93_REG_MIN]);
+	tm->tm_hour	= bcd2bin(buf[M41T93_REG_CENT_HOUR] & 0x3f);
+	tm->tm_mday	= bcd2bin(buf[M41T93_REG_DAY]);
+	tm->tm_mon	= bcd2bin(buf[M41T93_REG_MON]) - 1;
+	tm->tm_wday	= bcd2bin(buf[M41T93_REG_WDAY] & 0x0f) - 1;
+
+	century_after_1900 = (buf[M41T93_REG_CENT_HOUR] >> 6) + 1;
+	tm->tm_year = bcd2bin(buf[M41T93_REG_YEAR]) + century_after_1900 * 100;
+
+	dev_dbg(dev, "%s secs=%d, mins=%d, "
+		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
+		"read", tm->tm_sec, tm->tm_min,
+		tm->tm_hour, tm->tm_mday,
+		tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	return ret < 0 ? ret : rtc_valid_tm(tm);
+}
+
+
+static const struct rtc_class_ops m41t93_rtc_ops = {
+	.read_time	= m41t93_get_time,
+	.set_time	= m41t93_set_time,
+};
+
+static struct spi_driver m41t93_driver;
+
+static int __devinit m41t93_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	int res;
+
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	res = spi_w8r8(spi, M41T93_REG_WDAY);
+	if (res < 0 || (res & 0xf8) != 0) {
+		dev_err(&spi->dev, "not found 0x%x.\n", res);
+		return -ENODEV;
+	}
+
+	rtc = rtc_device_register(m41t93_driver.driver.name,
+		&spi->dev, &m41t93_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	dev_set_drvdata(&spi->dev, rtc);
+
+	return 0;
+}
+
+
+static int __devexit m41t93_remove(struct spi_device *spi)
+{
+	struct rtc_device *rtc = platform_get_drvdata(spi);
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	return 0;
+}
+
+static struct spi_driver m41t93_driver = {
+	.driver = {
+		.name	= "rtc-m41t93",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= m41t93_probe,
+	.remove = __devexit_p(m41t93_remove),
+};
+
+static __init int m41t93_init(void)
+{
+	return spi_register_driver(&m41t93_driver);
+}
+module_init(m41t93_init);
+
+static __exit void m41t93_exit(void)
+{
+	spi_unregister_driver(&m41t93_driver);
+}
+module_exit(m41t93_exit);
+
+MODULE_AUTHOR("Nikolaus Voss <n.voss@weinmann.de>");
+MODULE_DESCRIPTION("Driver for ST M41T93 SPI RTC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-m41t93");
_

Patches currently in -mm which might be from N.Voss@weinmann.de are

rtc-add-basic-support-for-st-m41t93-spi-rtc.patch

