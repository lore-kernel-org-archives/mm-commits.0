From: akpm@linux-foundation.org
Subject: - watchdog-driver-for-at32ap700x-devices.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:38 -0700
Message-ID: <200706121858.l5CIwcYC018545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbXFLTHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:07:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, hskinnemoen@atmel.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Watchdog driver for AT32AP700X devices
has been removed from the -mm tree.  Its filename was
     watchdog-driver-for-at32ap700x-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Watchdog driver for AT32AP700X devices
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Add support for the built in watchdog in AT32AP700X devices.

Tested on AT32AP7000 and ATSTK1000.

Hardware documentation can be found in the AT32AP7000 datasheet.

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/Kconfig          |   20 +
 drivers/char/watchdog/Makefile         |    3 
 drivers/char/watchdog/at32ap700x_wdt.c |  313 +++++++++++++++++++++++
 3 files changed, 336 insertions(+)

diff -puN drivers/char/watchdog/Kconfig~watchdog-driver-for-at32ap700x-devices drivers/char/watchdog/Kconfig
--- a/drivers/char/watchdog/Kconfig~watchdog-driver-for-at32ap700x-devices
+++ a/drivers/char/watchdog/Kconfig
@@ -187,6 +187,26 @@ config PNX4008_WATCHDOG
 
 	  Say N if you are unsure.
 
+# AVR32 Architecture
+
+config AT32AP700X_WDT
+	tristate "AT32AP700x watchdog"
+	depends on WATCHDOG && CPU_AT32AP7000
+	help
+	  Watchdog timer embedded into AT32AP700x devices. This will reboot
+	  your system when the timeout is reached.
+
+config AT32AP700X_WDT_TIMEOUT
+	int "Timeout value for AT32AP700x watchdog"
+	depends on AT32AP700X_WDT
+	default "2"
+	range 1 2
+	help
+	  Sets the timeout value for the watchdog in AT32AP700x devices.
+	  Limited by hardware to be 1 or 2 seconds.
+
+	  Set to 2 seconds by default.
+
 # X86 (i386 + ia64 + x86_64) Architecture
 
 config ACQUIRE_WDT
diff -puN drivers/char/watchdog/Makefile~watchdog-driver-for-at32ap700x-devices drivers/char/watchdog/Makefile
--- a/drivers/char/watchdog/Makefile~watchdog-driver-for-at32ap700x-devices
+++ a/drivers/char/watchdog/Makefile
@@ -36,6 +36,9 @@ obj-$(CONFIG_MPCORE_WATCHDOG) += mpcore_
 obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_wdt.o
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
 
+# AVR32 Architecture
+obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
+
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
diff -puN /dev/null drivers/char/watchdog/at32ap700x_wdt.c
--- /dev/null
+++ a/drivers/char/watchdog/at32ap700x_wdt.c
@@ -0,0 +1,313 @@
+/*
+ * Watchdog driver for Atmel AT32AP700X devices
+ *
+ * Copyright (C) 2005-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+#include <asm/uaccess.h>
+#include <asm/io.h>
+
+#define TIMEOUT_MIN		1
+#define TIMEOUT_DEFAULT		CONFIG_AT32AP700X_WDT_TIMEOUT
+#define TIMEOUT_MAX		2
+
+/* Watchdog registers and write/read macro */
+#define WDT_CTRL		0x00
+#define WDT_CTRL_EN		   0
+#define WDT_CTRL_PSEL		   8
+#define WDT_CTRL_KEY		  24
+
+#define WDT_CLR			0x04
+
+#define WDT_BIT(name)		(1 << WDT_##name)
+#define WDT_BF(name,value)	((value) << WDT_##name)
+
+#define wdt_readl(dev,reg)				\
+	__raw_readl((dev)->regs + WDT_##reg)
+#define wdt_writel(dev,reg,value)			\
+	__raw_writel((value), (dev)->regs + WDT_##reg)
+
+struct wdt_at32ap700x {
+	void __iomem		*regs;
+	int			timeout;
+	int			users;
+	struct miscdevice	miscdev;
+};
+
+static struct wdt_at32ap700x *wdt;
+
+/*
+ * Disable the watchdog.
+ */
+static void inline at32_wdt_stop(void)
+{
+	unsigned long psel = wdt_readl(wdt, CTRL) & WDT_BF(CTRL_PSEL, 0x0f);
+	wdt_writel(wdt, CTRL, psel | WDT_BF(CTRL_KEY, 0x55));
+	wdt_writel(wdt, CTRL, psel | WDT_BF(CTRL_KEY, 0xaa));
+}
+
+/*
+ * Enable and reset the watchdog.
+ */
+static void inline at32_wdt_start(void)
+{
+	/* 0xf is 2^16 divider = 2 sec, 0xe is 2^15 divider = 1 sec */
+	unsigned long psel = (wdt->timeout > 1) ? 0xf : 0xe;
+
+	wdt_writel(wdt, CTRL, WDT_BIT(CTRL_EN)
+			| WDT_BF(CTRL_PSEL, psel)
+			| WDT_BF(CTRL_KEY, 0x55));
+	wdt_writel(wdt, CTRL, WDT_BIT(CTRL_EN)
+			| WDT_BF(CTRL_PSEL, psel)
+			| WDT_BF(CTRL_KEY, 0xaa));
+}
+
+/*
+ * Pat the watchdog timer.
+ */
+static void inline at32_wdt_pat(void)
+{
+	wdt_writel(wdt, CLR, 0x42);
+}
+
+/*
+ * Watchdog device is opened, and watchdog starts running.
+ */
+static int at32_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(1, &wdt->users))
+		return -EBUSY;
+
+	at32_wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+/*
+ * Close the watchdog device. If CONFIG_WATCHDOG_NOWAYOUT is _not_ defined then
+ * the watchdog is also disabled.
+ */
+static int at32_wdt_close(struct inode *inode, struct file *file)
+{
+#ifndef CONFIG_WATCHDOG_NOWAYOUT
+	at32_wdt_stop();
+#endif
+	clear_bit(1, &wdt->users);
+	return 0;
+}
+
+/*
+ * Change the watchdog time interval.
+ */
+static int at32_wdt_settimeout(int time)
+{
+	/*
+	 * All counting occurs at 1 / SLOW_CLOCK (32 kHz) and max prescaler is
+	 * 2 ^ 16 allowing up to 2 seconds timeout.
+	 */
+	if ((time < TIMEOUT_MIN) || (time > TIMEOUT_MAX))
+		return -EINVAL;
+
+	/* Set new watchdog time. It will be used when at32_wdt_start() is called. */
+	wdt->timeout = time;
+	return 0;
+}
+
+static struct watchdog_info at32_wdt_info = {
+	.identity	= "at32ap700x watchdog",
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+};
+
+/*
+ * Handle commands from user-space.
+ */
+static int at32_wdt_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int time;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+
+	switch(cmd) {
+	case WDIOC_KEEPALIVE:
+		at32_wdt_pat();
+		ret = 0;
+		break;
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(argp, &at32_wdt_info,
+				sizeof(at32_wdt_info)) ? -EFAULT : 0;
+		break;
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+		ret = at32_wdt_settimeout(time);
+		if (ret)
+			break;
+		/* Enable new time value */
+		at32_wdt_start();
+		/* fall through */
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(wdt->timeout, p);
+		break;
+	case WDIOC_GETSTATUS: /* fall through */
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, p);
+		break;
+	case WDIOC_SETOPTIONS:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+		if (time & WDIOS_DISABLECARD)
+			at32_wdt_stop();
+		if (time & WDIOS_ENABLECARD)
+			at32_wdt_start();
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+static ssize_t at32_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+{
+	at32_wdt_pat();
+	return len;
+}
+
+static const struct file_operations at32_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.ioctl		= at32_wdt_ioctl,
+	.open		= at32_wdt_open,
+	.release	= at32_wdt_close,
+	.write		= at32_wdt_write,
+};
+
+static int __init at32_wdt_probe(struct platform_device *pdev)
+{
+	struct resource	*regs;
+	int ret;
+
+	if (wdt) {
+		dev_dbg(&pdev->dev, "only 1 wdt instance supported.\n");
+		return -EBUSY;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_dbg(&pdev->dev, "missing mmio resource\n");
+		return -ENXIO;
+	}
+
+	wdt = kzalloc(sizeof(struct wdt_at32ap700x), GFP_KERNEL);
+	if (!wdt) {
+		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
+		return -ENOMEM;
+	}
+
+	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	wdt->users = 0;
+	wdt->miscdev.minor = WATCHDOG_MINOR;
+	wdt->miscdev.name = "watchdog";
+	wdt->miscdev.fops = &at32_wdt_fops;
+
+	if (at32_wdt_settimeout(TIMEOUT_DEFAULT)) {
+		at32_wdt_settimeout(TIMEOUT_MAX);
+		dev_dbg(&pdev->dev,
+			"default timeout invalid, set to %d sec.\n",
+			TIMEOUT_MAX);
+	}
+
+	ret = misc_register(&wdt->miscdev);
+	if (ret) {
+		dev_dbg(&pdev->dev, "failed to register wdt miscdev\n");
+		goto err_register;
+	}
+
+	platform_set_drvdata(pdev, wdt);
+	wdt->miscdev.parent = &pdev->dev;
+	dev_info(&pdev->dev, "AT32AP700X WDT at 0x%p\n", wdt->regs);
+
+	return 0;
+
+err_register:
+	kfree(wdt);
+	wdt = NULL;
+	return ret;
+}
+
+static int __exit at32_wdt_remove(struct platform_device *pdev)
+{
+	if (wdt && platform_get_drvdata(pdev) == wdt) {
+		misc_deregister(&wdt->miscdev);
+		kfree(wdt);
+		wdt = NULL;
+		platform_set_drvdata(pdev, NULL);
+	}
+
+	return 0;
+}
+
+static void at32_wdt_shutdown(struct platform_device *pdev)
+{
+	at32_wdt_stop();
+}
+
+#ifdef CONFIG_PM
+static int at32_wdt_suspend(struct platform_device *pdev, pm_message_t message)
+{
+	at32_wdt_stop();
+	return 0;
+}
+
+static int at32_wdt_resume(struct platform_device *pdev)
+{
+	if (wdt->users)
+		at32_wdt_start();
+	return 0;
+}
+#endif
+
+static struct platform_driver at32_wdt_driver = {
+	.remove		= __exit_p(at32_wdt_remove),
+#ifdef CONFIG_PM
+	.suspend	= at32_wdt_suspend,
+	.resume		= at32_wdt_resume,
+#endif
+	.driver		= {
+		.name	= "at32_wdt",
+		.owner	= THIS_MODULE,
+	},
+	.shutdown	= at32_wdt_shutdown,
+};
+
+static int __init at32_wdt_init(void)
+{
+	return platform_driver_probe(&at32_wdt_driver, at32_wdt_probe);
+}
+module_init(at32_wdt_init);
+
+static void __exit at32_wdt_exit(void)
+{
+	platform_driver_unregister(&at32_wdt_driver);
+}
+module_exit(at32_wdt_exit);
+
+MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_DESCRIPTION("Watchdog driver for Atmel AT32AP700X");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-avr32.patch
git-watchdog.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
