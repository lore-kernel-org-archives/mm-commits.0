From: akpm@linux-foundation.org
Subject: + at91sam9-cap9-watchdog-driver.patch added to -mm tree
Date: Tue, 03 Jun 2008 14:23:25 -0700
Message-ID: <200806032123.m53LNUNw020491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbYFCVYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 17:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avictor.za@gmail.com, linux@maxim.org.za, r.cerrato@til-technologies.fr, wim@iguana.be


The patch titled
     AT91SAM9/CAP9 watchdog driver
has been added to the -mm tree.  Its filename is
     at91sam9-cap9-watchdog-driver.patch

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
Subject: AT91SAM9/CAP9 watchdog driver
From: "Andrew Victor" <avictor.za@gmail.com>

Driver to support the internal watchdog peripheral found on Atmel's
AT91SAM9 and AT91CAP9 processors (ARM).

Signed-off-by: Renaud Cerrato <r.cerrato@til-technologies.fr>
Signed-off-by: Andrew Victor <linux@maxim.org.za>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig        |    8 
 drivers/watchdog/Makefile       |    1 
 drivers/watchdog/at91sam9_wdt.c |  263 ++++++++++++++++++++++++++++++
 3 files changed, 272 insertions(+)

diff -puN drivers/watchdog/Kconfig~at91sam9-cap9-watchdog-driver drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~at91sam9-cap9-watchdog-driver
+++ a/drivers/watchdog/Kconfig
@@ -66,6 +66,14 @@ config AT91RM9200_WATCHDOG
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.
 
+config AT91SAM9_WATCHDOG
+	tristate "AT91SAM9 / AT91CAP9 watchdog"
+	depends on ARCH_AT91 && !ARCH_AT91RM9200
+	select WATCHDOG_NOWAYOUT
+	help
+	  Watchdog timer embedded into Atmel AT91SAM9 and AT91CAP9 processors.
+	  This will reboot your system when the timeout is reached.
+
 config 21285_WATCHDOG
 	tristate "DC21285 watchdog"
 	depends on FOOTBRIDGE
diff -puN drivers/watchdog/Makefile~at91sam9-cap9-watchdog-driver drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile~at91sam9-cap9-watchdog-driver
+++ a/drivers/watchdog/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_USBPCWATCHDOG) += pcwd_usb.
 
 # ARM Architecture
 obj-$(CONFIG_AT91RM9200_WATCHDOG) += at91rm9200_wdt.o
+obj-$(CONFIG_AT91SAM9_WATCHDOG) += at91sam9_wdt.o
 obj-$(CONFIG_OMAP_WATCHDOG) += omap_wdt.o
 obj-$(CONFIG_21285_WATCHDOG) += wdt285.o
 obj-$(CONFIG_977_WATCHDOG) += wdt977.o
diff -puN /dev/null drivers/watchdog/at91sam9_wdt.c
--- /dev/null
+++ a/drivers/watchdog/at91sam9_wdt.c
@@ -0,0 +1,263 @@
+/*
+ * Watchdog driver for Atmel AT91SAM9x processors.
+ *
+ * Copyright (C) 2007 Renaud CERRATO r.cerrato@til-technologies.fr
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/*
+ * The Watchdog Timer Mode Register can be only written to once. If the
+ * timeout need to be set from Linux, be sure that the bootstrap or the
+ * bootloader doesn't write to this register.
+ */
+
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <linux/bitops.h>
+#include <linux/uaccess.h>
+
+#include <asm/arch/at91_wdt.h>
+
+
+#define WDT_MAX_TIME		16	/* seconds */
+
+static int wdt_timeout = -1;		/* invalid */
+
+module_param(wdt_timeout, int, 0);
+MODULE_PARM_DESC(wdt_timeout, "Watchdog time in seconds. (default = disabled)");
+
+
+static unsigned long at91wdt_busy;
+
+/* ......................................................................... */
+
+/*
+ * Reload the watchdog timer.  (ie, pat the watchdog)
+ */
+static inline void at91_wdt_reload(void)
+{
+	at91_sys_write(AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
+}
+
+/* ......................................................................... */
+
+/*
+ * Watchdog device is opened, and watchdog starts running.
+ */
+static int at91_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &at91wdt_busy))
+		return -EBUSY;
+
+	return nonseekable_open(inode, file);
+}
+
+/*
+ * Close the watchdog device.
+ */
+static int at91_wdt_close(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &at91wdt_busy);
+	return 0;
+}
+
+/*
+ * Change the watchdog time interval.
+ */
+static int at91_wdt_settimeout(int new_time)
+{
+	unsigned int reg, mr;
+	/*
+	 * All counting occurs at SLOW_CLOCK / 128 = 256 Hz
+	 *
+	 * Since WDV is a 12-bit counter, the maximum period is
+	 * 4096 / 256 = 16 seconds.
+	 */
+	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
+		return -EINVAL;
+
+	wdt_timeout = new_time;
+
+	/* Program the Watchdog */
+	reg = AT91_WDT_WDRSTEN			/* causes watchdog reset */
+		| AT91_WDT_WDRPROC		/* causes processor reset */
+		| AT91_WDT_WDDBGHLT		/* disabled in debug mode */
+		| AT91_WDT_WDD			/* restart at any time */
+		| (((wdt_timeout * 256) - 1) & AT91_WDT_WDV);
+	at91_sys_write(AT91_WDT_MR, reg);
+
+	/* Check if watchdog could be programmed */
+	mr = at91_sys_read(AT91_WDT_MR);
+	if (mr != reg) {
+		printk(KERN_ERR "at91sam9_wdt: Watchdog already programmed.\n");
+		return -EIO;
+	}
+
+	at91_wdt_reload();
+
+	printk(KERN_INFO "AT91SAM9 Watchdog enabled (%d seconds, nowayout)\n",
+			wdt_timeout);
+	return 0;
+}
+
+static struct watchdog_info at91_wdt_info = {
+	.identity	= "at91sam9 watchdog",
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+};
+
+/*
+ * Handle commands from user-space.
+ */
+static long at91_wdt_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_value, err;
+
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		at91_wdt_reload();	/* pat the watchdog */
+		return 0;
+
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &at91_wdt_info,
+				sizeof(at91_wdt_info)) ? -EFAULT : 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		err = at91_wdt_settimeout(new_value);
+		if (err)
+			return err;
+
+		return put_user(wdt_timeout, p);
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_timeout, p);
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	}
+	return -ENOTTY;
+}
+
+/*
+ * Pat the watchdog whenever device is written to.
+ */
+static ssize_t at91_wdt_write(struct file *file, const char *data,
+		size_t len, loff_t *ppos)
+{
+	at91_wdt_reload();		/* pat the watchdog */
+	return len;
+}
+
+/* ......................................................................... */
+
+static const struct file_operations at91wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.unlocked_ioctl	= at91_wdt_ioctl,
+	.open		= at91_wdt_open,
+	.release	= at91_wdt_close,
+	.write		= at91_wdt_write,
+};
+
+static struct miscdevice at91wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &at91wdt_fops,
+};
+
+static int __init at91wdt_probe(struct platform_device *pdev)
+{
+	int res;
+
+	if (at91wdt_miscdev.parent)
+		return -EBUSY;
+	at91wdt_miscdev.parent = &pdev->dev;
+
+	res = misc_register(&at91wdt_miscdev);
+	if (res)
+		return res;
+
+	/* Set watchdog */
+	if (at91_wdt_settimeout(wdt_timeout) == -EINVAL) {
+		pr_info("at91sam9_wdt: timeout must be between 1 and %d.\n",
+			WDT_MAX_TIME);
+		return 0;
+	}
+
+	return 0;
+}
+
+static int __exit at91wdt_remove(struct platform_device *pdev)
+{
+	int res;
+
+	res = misc_deregister(&at91wdt_miscdev);
+	if (!res)
+		at91wdt_miscdev.parent = NULL;
+
+	return res;
+}
+
+#ifdef CONFIG_PM
+
+static int at91wdt_suspend(struct platform_device *pdev, pm_message_t message)
+{
+	return 0;
+}
+
+static int at91wdt_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+#else
+#define at91wdt_suspend	NULL
+#define at91wdt_resume	NULL
+#endif
+
+static struct platform_driver at91wdt_driver = {
+	.remove		= __exit_p(at91wdt_remove),
+	.suspend	= at91wdt_suspend,
+	.resume		= at91wdt_resume,
+	.driver		= {
+		.name	= "at91_wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init at91sam_wdt_init(void)
+{
+	return platform_driver_probe(&at91wdt_driver, at91wdt_probe);
+}
+
+static void __exit at91sam_wdt_exit(void)
+{
+	platform_driver_unregister(&at91wdt_driver);
+}
+
+module_init(at91sam_wdt_init);
+module_exit(at91sam_wdt_exit);
+
+MODULE_AUTHOR("Renaud CERRATO");
+MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:at91_wdt");
_

Patches currently in -mm which might be from avictor.za@gmail.com are

at91sam9-cap9-watchdog-driver.patch

