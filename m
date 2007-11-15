From: akpm@linux-foundation.org
Subject: + rtc-ds1302-rtc-support.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:32:41 -0800
Message-ID: <200711152232.lAFMWfZE019333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48117 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421AbXKOWdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, a.zummo@towertech.it


The patch titled
     rtc: ds1302 rtc support
has been added to the -mm tree.  Its filename is
     rtc-ds1302-rtc-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: ds1302 rtc support
From: Paul Mundt <lethal@linux-sh.org>

This adds a basic ds1302 RTC driver, which is basically a cleanup and move
of the in-tree SH SecureEdge5410 code (which is currently located in
arch/sh/board/snapgear/rtc.c) to drivers/rtc.

This aims to be a building block that the M32R and CRIS code can be worked
on top of, so we can get rid of drivers/char/ds1302.c and
arch/cris/arch-v10/drivers/ds1302.c respectively, though more work is
needed for this.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    6 
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-ds1302.c |  262 +++++++++++++++++++++++++++++++++++++
 3 files changed, 269 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-ds1302-rtc-support drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-ds1302-rtc-support
+++ a/drivers/rtc/Kconfig
@@ -306,6 +306,12 @@ config RTC_DRV_DS1216
 	help
 	  If you say yes here you get support for the Dallas DS1216 RTC chips.
 
+config RTC_DRV_DS1302
+	tristate "Dallas DS1302"
+	depends on SH_SECUREEDGE5410
+	help
+	  If you say yes here you get support for the Dallas DS1302 RTC chips.
+
 config RTC_DRV_DS1553
 	tristate "Maxim/Dallas DS1553"
 	help
diff -puN drivers/rtc/Makefile~rtc-ds1302-rtc-support drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-ds1302-rtc-support
+++ a/drivers/rtc/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-a
 obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
+obj-$(CONFIG_RTC_DRV_DS1302)	+= rtc-ds1302.o
 obj-$(CONFIG_RTC_DRV_DS1307)	+= rtc-ds1307.o
 obj-$(CONFIG_RTC_DRV_DS1374)	+= rtc-ds1374.o
 obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
diff -puN /dev/null drivers/rtc/rtc-ds1302.c
--- /dev/null
+++ a/drivers/rtc/rtc-ds1302.c
@@ -0,0 +1,262 @@
+/*
+ * Dallas DS1302 RTC Support
+ *
+ *  Copyright (C) 2002  David McCullough
+ *  Copyright (C) 2003 - 2007  Paul Mundt
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License version 2.  See the file "COPYING" in the main directory of
+ * this archive for more details.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/rtc.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/bcd.h>
+#include <asm/rtc.h>
+
+#define DRV_NAME	"rtc-ds1302"
+#define DRV_VERSION	"0.1.0"
+
+#define	RTC_CMD_READ	0x81		/* Read command */
+#define	RTC_CMD_WRITE	0x80		/* Write command */
+
+#define RTC_ADDR_RAM0	0x20		/* Address of RAM0 */
+#define RTC_ADDR_TCR	0x08		/* Address of trickle charge register */
+#define	RTC_ADDR_YEAR	0x06		/* Address of year register */
+#define	RTC_ADDR_DAY	0x05		/* Address of day of week register */
+#define	RTC_ADDR_MON	0x04		/* Address of month register */
+#define	RTC_ADDR_DATE	0x03		/* Address of day of month register */
+#define	RTC_ADDR_HOUR	0x02		/* Address of hour register */
+#define	RTC_ADDR_MIN	0x01		/* Address of minute register */
+#define	RTC_ADDR_SEC	0x00		/* Address of second register */
+
+#define	RTC_RESET	0x1000
+#define	RTC_IODATA	0x0800
+#define	RTC_SCLK	0x0400
+
+#ifdef CONFIG_SH_SECUREEDGE5410
+#include <asm/snapgear.h>
+#define set_dp(x)	SECUREEDGE_WRITE_IOPORT(x, 0x1c00)
+#define get_dp()	SECUREEDGE_READ_IOPORT()
+#else
+#error "Add support for your platform"
+#endif
+
+struct ds1302_rtc {
+	struct rtc_device *rtc_dev;
+	spinlock_t lock;
+};
+
+static void ds1302_sendbits(unsigned int val)
+{
+	int i;
+
+	for (i = 8; (i); i--, val >>= 1) {
+		set_dp((get_dp() & ~RTC_IODATA) | ((val & 0x1) ?
+			RTC_IODATA : 0));
+		set_dp(get_dp() | RTC_SCLK);	// clock high
+		set_dp(get_dp() & ~RTC_SCLK);	// clock low
+	}
+}
+
+static unsigned int ds1302_recvbits(void)
+{
+	unsigned int val;
+	int i;
+
+	for (i = 0, val = 0; (i < 8); i++) {
+		val |= (((get_dp() & RTC_IODATA) ? 1 : 0) << i);
+		set_dp(get_dp() | RTC_SCLK);	// clock high
+		set_dp(get_dp() & ~RTC_SCLK);	// clock low
+	}
+
+	return val;
+}
+
+static unsigned int ds1302_readbyte(unsigned int addr)
+{
+	unsigned int val;
+
+	set_dp(get_dp() & ~(RTC_RESET | RTC_IODATA | RTC_SCLK));
+
+	set_dp(get_dp() | RTC_RESET);
+	ds1302_sendbits(((addr & 0x3f) << 1) | RTC_CMD_READ);
+	val = ds1302_recvbits();
+	set_dp(get_dp() & ~RTC_RESET);
+
+	return val;
+}
+
+static void ds1302_writebyte(unsigned int addr, unsigned int val)
+{
+	set_dp(get_dp() & ~(RTC_RESET | RTC_IODATA | RTC_SCLK));
+	set_dp(get_dp() | RTC_RESET);
+	ds1302_sendbits(((addr & 0x3f) << 1) | RTC_CMD_WRITE);
+	ds1302_sendbits(val);
+	set_dp(get_dp() & ~RTC_RESET);
+}
+
+static int ds1302_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct ds1302_rtc *rtc = dev_get_drvdata(dev);
+
+	spin_lock_irq(&rtc->lock);
+
+	tm->tm_sec	= BCD2BIN(ds1302_readbyte(RTC_ADDR_SEC));
+	tm->tm_min	= BCD2BIN(ds1302_readbyte(RTC_ADDR_MIN));
+	tm->tm_hour	= BCD2BIN(ds1302_readbyte(RTC_ADDR_HOUR));
+	tm->tm_wday	= BCD2BIN(ds1302_readbyte(RTC_ADDR_DAY));
+	tm->tm_mday	= BCD2BIN(ds1302_readbyte(RTC_ADDR_DATE));
+	tm->tm_mon	= BCD2BIN(ds1302_readbyte(RTC_ADDR_MON)) - 1;
+	tm->tm_year	= BCD2BIN(ds1302_readbyte(RTC_ADDR_YEAR));
+
+	if (tm->tm_year < 70)
+		tm->tm_year += 100;
+
+	spin_unlock_irq(&rtc->lock);
+
+	dev_dbg(dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
+		"mday=%d, mon=%d, year=%d, wday=%d\n",
+		__FUNCTION__,
+		tm->tm_sec, tm->tm_min, tm->tm_hour,
+		tm->tm_mday, tm->tm_mon + 1, tm->tm_year, tm->tm_wday);
+
+	if (rtc_valid_tm(tm) < 0)
+		dev_err(dev, "invalid date\n");
+
+	return 0;
+}
+
+static int ds1302_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct ds1302_rtc *rtc = dev_get_drvdata(dev);
+
+	spin_lock_irq(&rtc->lock);
+
+	/* Stop RTC */
+	ds1302_writebyte(RTC_ADDR_SEC, ds1302_readbyte(RTC_ADDR_SEC) | 0x80);
+
+	ds1302_writebyte(RTC_ADDR_SEC, BIN2BCD(tm->tm_sec));
+	ds1302_writebyte(RTC_ADDR_MIN, BIN2BCD(tm->tm_min));
+	ds1302_writebyte(RTC_ADDR_HOUR, BIN2BCD(tm->tm_hour));
+	ds1302_writebyte(RTC_ADDR_DAY, BIN2BCD(tm->tm_wday));
+	ds1302_writebyte(RTC_ADDR_DATE, BIN2BCD(tm->tm_mday));
+	ds1302_writebyte(RTC_ADDR_MON, BIN2BCD(tm->tm_mon + 1));
+	ds1302_writebyte(RTC_ADDR_YEAR, BIN2BCD(tm->tm_year % 100));
+
+	/* Start RTC */
+	ds1302_writebyte(RTC_ADDR_SEC, ds1302_readbyte(RTC_ADDR_SEC) & ~0x80);
+
+	spin_unlock_irq(&rtc->lock);
+
+	return 0;
+}
+
+static int ds1302_rtc_ioctl(struct device *dev, unsigned int cmd,
+			    unsigned long arg)
+{
+	switch (cmd) {
+#ifdef RTC_SET_CHARGE
+	case RTC_SET_CHARGE:
+	{
+		struct ds1302_rtc *rtc = dev_get_drvdata(dev);
+		int tcs_val;
+
+		if (copy_from_user(&tcs_val, (int __user *)arg, sizeof(int)))
+			return -EFAULT;
+
+		spin_lock_irq(&rtc->lock);
+		ds1302_writebyte(RTC_ADDR_TCR, (0xa0 | tcs_val * 0xf));
+		spin_unlock_irq(&rtc->lock);
+		return 0;
+	}
+#endif
+	}
+
+	return -ENOIOCTLCMD;
+}
+
+static struct rtc_class_ops ds1302_rtc_ops = {
+	.read_time	= ds1302_rtc_read_time,
+	.set_time	= ds1302_rtc_set_time,
+	.ioctl		= ds1302_rtc_ioctl,
+};
+
+static int __devinit ds1302_rtc_probe(struct platform_device *pdev)
+{
+	struct ds1302_rtc *rtc;
+	int ret;
+
+	/* Reset */
+	set_dp(get_dp() & ~(RTC_RESET | RTC_IODATA | RTC_SCLK));
+
+	/* Write a magic value to the DS1302 RAM, and see if it sticks. */
+	ds1302_writebyte(RTC_ADDR_RAM0, 0x42);
+	if (ds1302_readbyte(RTC_ADDR_RAM0) != 0x42)
+		return -ENODEV;
+
+	rtc = kzalloc(sizeof(struct ds1302_rtc), GFP_KERNEL);
+	if (unlikely(!rtc))
+		return -ENOMEM;
+
+	spin_lock_init(&rtc->lock);
+	rtc->rtc_dev = rtc_device_register("ds1302", &pdev->dev,
+					   &ds1302_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc_dev)) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		goto out;
+	}
+
+	platform_set_drvdata(pdev, rtc);
+
+	return 0;
+out:
+	kfree(rtc);
+	return ret;
+}
+
+static int __devexit ds1302_rtc_remove(struct platform_device *pdev)
+{
+	struct ds1302_rtc *rtc = platform_get_drvdata(pdev);
+
+	if (likely(rtc->rtc_dev))
+		rtc_device_unregister(rtc->rtc_dev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	kfree(rtc);
+
+	return 0;
+}
+
+static struct platform_driver ds1302_platform_driver = {
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ds1302_rtc_probe,
+	.remove		= __devexit_p(ds1302_rtc_remove),
+};
+
+static int __init ds1302_rtc_init(void)
+{
+	return platform_driver_register(&ds1302_platform_driver);
+}
+
+static void __exit ds1302_rtc_exit(void)
+{
+	platform_driver_unregister(&ds1302_platform_driver);
+}
+
+module_init(ds1302_rtc_init);
+module_exit(ds1302_rtc_exit);
+
+MODULE_DESCRIPTION("Dallas DS1302 RTC driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_AUTHOR("Paul Mundt, David McCullough");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
git-sh.patch
kernel-printkc-concerns-about-the-console-handover.patch
rtc-ds1302-rtc-support.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
