From: akpm@linux-foundation.org
Subject: + rtc-add-support-for-epson-rtc-9701je-v2.patch added to -mm tree
Date: Tue, 22 Jan 2008 02:12:18 -0800
Message-ID: <200801221012.m0MAC7b6015862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515AbYAVKMl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 05:12:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, a.zummo@towertech.it, damm@igel.co.jp, david-b@pacbell.net


The patch titled
     rtc: add support for Epson RTC-9701JE V2
has been added to the -mm tree.  Its filename is
     rtc-add-support-for-epson-rtc-9701je-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add support for Epson RTC-9701JE V2
From: Magnus Damm <magnus.damm@gmail.com>

Add support for the Epson RTC-9701JE SPI RTC device.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig     |    9 +
 drivers/rtc/Makefile    |    1 
 drivers/rtc/rtc-r9701.c |  195 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-support-for-epson-rtc-9701je-v2 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-support-for-epson-rtc-9701je-v2
+++ a/drivers/rtc/Kconfig
@@ -265,6 +265,15 @@ config RTC_DRV_MAX6902
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max6902.
 
+config RTC_DRV_R9701
+	tristate "Epson RTC-9701JE"
+	help
+	  If you say yes here you will get support for the
+	  Epson RTC-9701JE SPI RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-r9701.
+
 config RTC_DRV_RS5C348
 	tristate "Ricoh RS5C348A/B"
 	help
diff -puN drivers/rtc/Makefile~rtc-add-support-for-epson-rtc-9701je-v2 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-support-for-epson-rtc-9701je-v2
+++ a/drivers/rtc/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
+obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
 obj-$(CONFIG_RTC_DRV_RS5C372)	+= rtc-rs5c372.o
diff -puN /dev/null drivers/rtc/rtc-r9701.c
--- /dev/null
+++ a/drivers/rtc/rtc-r9701.c
@@ -0,0 +1,195 @@
+/* drivers/rtc/rtc-r9701.c
+ *
+ * Driver for Epson RTC-9701JE
+ *
+ * Copyright (C) 2008 Magnus Damm
+ *
+ * Based on drivers/rtc/rtc-max6902.c
+ *
+ * Copyright (C) 2006 8D Technologies inc.
+ * Copyright (C) 2004 Compulab Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/rtc.h>
+#include <linux/spi/spi.h>
+#include <linux/bcd.h>
+#include <linux/delay.h>
+#include <linux/bitops.h>
+
+#define RSECCNT	0x00	/* Second Counter */
+#define RMINCNT	0x01	/* Minute Counter */
+#define RHRCNT	0x02	/* Hour Counter */
+#define RWKCNT	0x03	/* Week Counter */
+#define RDAYCNT	0x04	/* Day Counter */
+#define RMONCNT	0x05	/* Month Counter */
+#define RYRCNT	0x06	/* Year Counter */
+#define R100CNT	0x07	/* Y100 Counter */
+#define RMINAR	0x08	/* Minute Alarm */
+#define RHRAR	0x09	/* Hour Alarm */
+#define RWKAR	0x0a	/* Week/Day Alarm */
+#define RTIMCNT	0x0c	/* Interval Timer */
+#define REXT	0x0d	/* Extension Register */
+#define RFLAG	0x0e	/* RTC Flag Register */
+#define RCR	0x0f	/* RTC Control Register */
+
+static int write_reg(struct device *dev, int address, unsigned char data)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	unsigned char buf[2];
+
+	buf[0] = address & 0x7f;
+	buf[1] = data;
+
+	return spi_write(spi, buf, ARRAY_SIZE(buf));
+}
+
+static int read_regs(struct device *dev, unsigned char *regs, int no_regs)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u8 txbuf[1], rxbuf[1];
+	int k, ret;
+
+	ret = 0;
+
+	for (k = 0; ret == 0 && k < no_regs; k++) {
+		txbuf[0] = 0x80 | regs[k];
+		ret = spi_write_then_read(spi, txbuf, 1, rxbuf, 1);
+		regs[k] = rxbuf[0];
+	}
+
+	return ret;
+}
+
+static int r9701_get_datetime(struct device *dev, struct rtc_time *dt)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	unsigned long time;
+	int ret;
+	unsigned char buf[] = { RSECCNT, RMINCNT, RHRCNT,
+				RDAYCNT, RMONCNT, RYRCNT };
+
+	ret = read_regs(&spi->dev, buf, ARRAY_SIZE(buf));
+	if (ret)
+		return ret;
+
+	memset(dt, 0, sizeof(*dt));
+
+	dt->tm_sec = BCD2BIN(buf[0]); /* RSECCNT */
+	dt->tm_min = BCD2BIN(buf[1]); /* RMINCNT */
+	dt->tm_hour = BCD2BIN(buf[2]); /* RHRCNT */
+
+	dt->tm_mday = BCD2BIN(buf[3]); /* RDAYCNT */
+	dt->tm_mon = BCD2BIN(buf[4]) - 1; /* RMONCNT */
+	dt->tm_year = BCD2BIN(buf[5]) + 100; /* RYRCNT */
+
+	/* the rtc device may contain illegal values on power up
+	 * according to the data sheet. make sure they are valid.
+	 */
+
+	ret = rtc_valid_tm(dt);
+	if (ret)
+		return ret;
+
+	/* don't bother with yday, wday and isdst.
+	 * let the rtc core calculate them for us.
+	 */
+
+	rtc_tm_to_time(dt, &time);
+	rtc_time_to_tm(time, dt);
+	return 0;
+}
+
+static int r9701_set_datetime(struct device *dev, struct rtc_time *dt)
+{
+	int ret, year;
+
+	year = dt->tm_year + 1900;
+	if (year >= 2100 || year < 2000)
+		return -EINVAL;
+
+	ret = write_reg(dev, RHRCNT, BIN2BCD(dt->tm_hour));
+	ret |= write_reg(dev, RMINCNT, BIN2BCD(dt->tm_min));
+	ret |= write_reg(dev, RSECCNT, BIN2BCD(dt->tm_sec));
+	ret |= write_reg(dev, RDAYCNT, BIN2BCD(dt->tm_mday));
+	ret |= write_reg(dev, RMONCNT, BIN2BCD(dt->tm_mon + 1));
+	ret |= write_reg(dev, RYRCNT, BIN2BCD(dt->tm_year - 100));
+	ret |= write_reg(dev, RWKCNT, 1 << dt->tm_wday);
+
+	return ret;
+}
+
+static const struct rtc_class_ops r9701_rtc_ops = {
+	.read_time	= r9701_get_datetime,
+	.set_time	= r9701_set_datetime,
+};
+
+static int __devinit r9701_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	unsigned char tmp;
+	int res;
+
+	rtc = rtc_device_register("r9701",
+				&spi->dev, &r9701_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	dev_set_drvdata(&spi->dev, rtc);
+
+	spi->mode = SPI_MODE_3;
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	tmp = R100CNT;
+	res = read_regs(&spi->dev, &tmp, 1);
+	if (res || tmp != 0x20) {
+		rtc_device_unregister(rtc);
+		return res;
+	}
+
+	return 0;
+}
+
+static int __devexit r9701_remove(struct spi_device *spi)
+{
+	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
+
+	rtc_device_unregister(rtc);
+	return 0;
+}
+
+static struct spi_driver r9701_driver = {
+	.driver = {
+		.name	= "rtc-r9701",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= r9701_probe,
+	.remove = __devexit_p(r9701_remove),
+};
+
+static __init int r9701_init(void)
+{
+	return spi_register_driver(&r9701_driver);
+}
+module_init(r9701_init);
+
+static __exit void r9701_exit(void)
+{
+	spi_unregister_driver(&r9701_driver);
+}
+module_exit(r9701_exit);
+
+MODULE_DESCRIPTION("r9701 spi RTC driver");
+MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

usb-dma-bounce-buffer-support-v3.patch
usb-dma-bounce-buffer-support-v3-checkpatch-fixes.patch
usb-dma-bounce-buffer-support-v3-fix.patch
usb-ohci-sm501-driver-v2.patch
usb-ohci-sm501-driver-v2-fix.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
