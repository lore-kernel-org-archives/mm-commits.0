From: akpm@linux-foundation.org
Subject: + rtc-rtc-dm355evm-driver.patch added to -mm tree
Date: Mon, 26 Jan 2009 18:47:29 -0800
Message-ID: <200901270247.n0R2lTEQ008660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbZA0CsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 21:48:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, a.zummo@towertech.it, khilman@deeprootsystems.com


The patch titled
     rtc: rtc-dm355evm driver
has been added to the -mm tree.  Its filename is
     rtc-rtc-dm355evm-driver.patch

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
Subject: rtc: rtc-dm355evm driver

From David Brownell <dbrownell@users.sourceforge.net>

Simple RTC driver for the MSP430 firmware on the DM355 EVM board.  Other
than not supporting atomic reads/writes of all four bytes, this is
reasonable as a basic no-alarm RTC.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |    6 +
 drivers/rtc/Makefile       |    1 
 drivers/rtc/rtc-dm355evm.c |  175 +++++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-rtc-dm355evm-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rtc-dm355evm-driver
+++ a/drivers/rtc/Kconfig
@@ -241,6 +241,12 @@ config RTC_DRV_M41T80_WDT
 	  If you say Y here you will get support for the
 	  watchdog timer in the ST M41T60 and M41T80 RTC chips series.
 
+config RTC_DRV_DM355EVM
+	tristate "TI DaVinci DM355 EVM RTC"
+	depends on MFD_DM355EVM_MSP
+	help
+	  Supports the RTC firmware in the MSP430 on the DM355 EVM.
+
 config RTC_DRV_TWL92330
 	boolean "TI TWL92330/Menelaus"
 	depends on MENELAUS
diff -puN drivers/rtc/Makefile~rtc-rtc-dm355evm-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-rtc-dm355evm-driver
+++ a/drivers/rtc/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_RTC_DRV_AT91SAM9)	+= rtc-at
 obj-$(CONFIG_RTC_DRV_AU1XXX)	+= rtc-au1xxx.o
 obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
+obj-$(CONFIG_RTC_DRV_DM355EVM)	+= rtc-dm355evm.o
 obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
 obj-$(CONFIG_RTC_DRV_DS1286)	+= rtc-ds1286.o
 obj-$(CONFIG_RTC_DRV_DS1302)	+= rtc-ds1302.o
diff -puN /dev/null drivers/rtc/rtc-dm355evm.c
--- /dev/null
+++ a/drivers/rtc/rtc-dm355evm.c
@@ -0,0 +1,175 @@
+/*
+ * rtc-dm355evm.c - access battery-backed counter in MSP430 firmware
+ *
+ * Copyright (c) 2008 by David Brownell
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+
+#include <linux/i2c/dm355evm_msp.h>
+
+
+/*
+ * The MSP430 firmware on the DM355 EVM uses a watch crystal to feed
+ * a 1 Hz counter.  When a backup battery is supplied, that makes a
+ * reasonable RTC for applications where alarms and non-NTP drift
+ * compensation aren't important.
+ *
+ * The only real glitch is the inability to read or write all four
+ * counter bytes atomically:  the count may increment in the middle
+ * of an operation, causing trouble when the LSB rolls over.
+ *
+ * This driver was tested with firmware revision A4.
+ */
+union evm_time {
+	u8	bytes[4];
+	u32	value;
+};
+
+static int dm355evm_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	union evm_time	time;
+	int		status;
+	int		tries = 0;
+
+	do {
+		/*
+		 * Read LSB(0) to MSB(3) bytes.  Defend against the counter
+		 * rolling over by re-reading until the value is stable,
+		 * and assuming the four reads take at most a few seconds.
+		 */
+		status = dm355evm_msp_read(DM355EVM_MSP_RTC_0);
+		if (status < 0)
+			return status;
+		if (tries && time.bytes[0] == status)
+			break;
+		time.bytes[0] = status;
+
+		status = dm355evm_msp_read(DM355EVM_MSP_RTC_1);
+		if (status < 0)
+			return status;
+		if (tries && time.bytes[1] == status)
+			break;
+		time.bytes[1] = status;
+
+		status = dm355evm_msp_read(DM355EVM_MSP_RTC_2);
+		if (status < 0)
+			return status;
+		if (tries && time.bytes[2] == status)
+			break;
+		time.bytes[2] = status;
+
+		status = dm355evm_msp_read(DM355EVM_MSP_RTC_3);
+		if (status < 0)
+			return status;
+		if (tries && time.bytes[3] == status)
+			break;
+		time.bytes[3] = status;
+
+	} while (++tries < 5);
+
+	dev_dbg(dev, "read timestamp %08x\n", time.value);
+
+	rtc_time_to_tm(le32_to_cpu(time.value), tm);
+	return 0;
+}
+
+static int dm355evm_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	union evm_time	time;
+	unsigned long	value;
+	int		status;
+
+	rtc_tm_to_time(tm, &value);
+	time.value = cpu_to_le32(value);
+
+	dev_dbg(dev, "write timestamp %08x\n", time.value);
+
+	/*
+	 * REVISIT handle non-atomic writes ... maybe just retry until
+	 * byte[1] sticks (no rollover)?
+	 */
+	status = dm355evm_msp_write(time.bytes[0], DM355EVM_MSP_RTC_0);
+	if (status < 0)
+		return status;
+
+	status = dm355evm_msp_write(time.bytes[1], DM355EVM_MSP_RTC_1);
+	if (status < 0)
+		return status;
+
+	status = dm355evm_msp_write(time.bytes[2], DM355EVM_MSP_RTC_2);
+	if (status < 0)
+		return status;
+
+	status = dm355evm_msp_write(time.bytes[3], DM355EVM_MSP_RTC_3);
+	if (status < 0)
+		return status;
+
+	return 0;
+}
+
+static struct rtc_class_ops dm355evm_rtc_ops = {
+	.read_time	= dm355evm_rtc_read_time,
+	.set_time	= dm355evm_rtc_set_time,
+};
+
+/*----------------------------------------------------------------------*/
+
+static int __devinit dm355evm_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtc;
+
+	rtc = rtc_device_register(pdev->name,
+				  &pdev->dev, &dm355evm_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
+			PTR_ERR(rtc));
+		return PTR_ERR(rtc);
+	}
+	platform_set_drvdata(pdev, rtc);
+
+	return 0;
+}
+
+static int __devexit dm355evm_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_device *rtc = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(rtc);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+/*
+ * I2C is used to talk to the MSP430, but this platform device is
+ * exposed by an MFD driver that manages I2C communications.
+ */
+static struct platform_driver rtc_dm355evm_driver = {
+	.probe		= dm355evm_rtc_probe,
+	.remove		= __devexit_p(dm355evm_rtc_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "rtc-dm355evm",
+	},
+};
+
+static int __init dm355evm_rtc_init(void)
+{
+	return platform_driver_register(&rtc_dm355evm_driver);
+}
+module_init(dm355evm_rtc_init);
+
+static void __exit dm355evm_rtc_exit(void)
+{
+	platform_driver_unregister(&rtc_dm355evm_driver);
+}
+module_exit(dm355evm_rtc_exit);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

gpiolib-fix-request-related-issue.patch
linux-next.patch
mmc-fixes-and-enhancements-for-the-mmc-spi-driver.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch
rtc-rtc-dm355evm-driver.patch

