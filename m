From: akpm@linux-foundation.org
Subject: - rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:46 -0700
Message-ID: <200707172305.l6HN5klv011951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932873AbXGQXQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, ab@mycable.de, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: watchdog support for rtc-m41t80 driver
has been removed from the -mm tree.  Its filename was
     rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: watchdog support for rtc-m41t80 driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add a watchdog driver interface to rtc-m41t80 driver.  This is derived from
works by Alexander Bigga <ab@mycable.de>

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Alexander Bigga <ab@mycable.de>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    7 
 drivers/rtc/rtc-m41t80.c |  288 +++++++++++++++++++++++++++++++++++++
 2 files changed, 295 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-watchdog-support-for-rtc-m41t80-driver-take-2 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-watchdog-support-for-rtc-m41t80-driver-take-2
+++ a/drivers/rtc/Kconfig
@@ -224,6 +224,13 @@ config RTC_DRV_M41T80
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-m41t80.
 
+config RTC_DRV_M41T80_WDT
+	bool "ST M41T80 series RTC watchdog timer"
+	depends on RTC_DRV_M41T80
+	help
+	  If you say Y here you will get support for the
+	  watchdog timer in ST M41T80 RTC chips series.
+
 comment "SPI RTC drivers"
 	depends on RTC_CLASS && SPI_MASTER
 
diff -puN drivers/rtc/rtc-m41t80.c~rtc-watchdog-support-for-rtc-m41t80-driver-take-2 drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-watchdog-support-for-rtc-m41t80-driver-take-2
+++ a/drivers/rtc/rtc-m41t80.c
@@ -20,6 +20,13 @@
 #include <linux/i2c.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
+#ifdef CONFIG_RTC_DRV_M41T80_WDT
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/reboot.h>
+#include <linux/fs.h>
+#include <linux/ioctl.h>
+#endif
 
 #define M41T80_REG_SSEC	0
 #define M41T80_REG_SEC	1
@@ -480,6 +487,268 @@ static int m41t80_sysfs_register(struct 
 }
 #endif
 
+#ifdef CONFIG_RTC_DRV_M41T80_WDT
+/*
+ *****************************************************************************
+ *
+ * Watchdog Driver
+ *
+ *****************************************************************************
+ */
+static struct i2c_client *save_client;
+
+/* Default margin */
+#define WD_TIMO 60		/* 1..31 seconds */
+
+static int wdt_margin = WD_TIMO;
+module_param(wdt_margin, int, 0);
+MODULE_PARM_DESC(wdt_margin, "Watchdog timeout in seconds (default 60s)");
+
+static unsigned long wdt_is_open;
+static int boot_flag;
+
+/**
+ *	wdt_ping:
+ *
+ *	Reload counter one with the watchdog timeout. We don't bother reloading
+ *	the cascade counter.
+ */
+static void wdt_ping(void)
+{
+	unsigned char i2c_data[2];
+	struct i2c_msg msgs1[1] = {
+		{
+			.addr	= save_client->addr,
+			.flags	= 0,
+			.len	= 2,
+			.buf	= i2c_data,
+		},
+	};
+	i2c_data[0] = 0x09;		/* watchdog register */
+
+	if (wdt_margin > 31)
+		i2c_data[1] = (wdt_margin & 0xFC) | 0x83; /* resolution = 4s */
+	else
+		/*
+		 * WDS = 1 (0x80), mulitplier = WD_TIMO, resolution = 1s (0x02)
+		 */
+		i2c_data[1] = wdt_margin<<2 | 0x82;
+
+	i2c_transfer(save_client->adapter, msgs1, 1);
+}
+
+/**
+ *	wdt_disable:
+ *
+ *	disables watchdog.
+ */
+static void wdt_disable(void)
+{
+	unsigned char i2c_data[2], i2c_buf[0x10];
+	struct i2c_msg msgs0[2] = {
+		{
+			.addr	= save_client->addr,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= i2c_data,
+		},
+		{
+			.addr	= save_client->addr,
+			.flags	= I2C_M_RD,
+			.len	= 1,
+			.buf	= i2c_buf,
+		},
+	};
+	struct i2c_msg msgs1[1] = {
+		{
+			.addr	= save_client->addr,
+			.flags	= 0,
+			.len	= 2,
+			.buf	= i2c_data,
+		},
+	};
+
+	i2c_data[0] = 0x09;
+	i2c_transfer(save_client->adapter, msgs0, 2);
+
+	i2c_data[0] = 0x09;
+	i2c_data[1] = 0x00;
+	i2c_transfer(save_client->adapter, msgs1, 1);
+}
+
+/**
+ *	wdt_write:
+ *	@file: file handle to the watchdog
+ *	@buf: buffer to write (unused as data does not matter here
+ *	@count: count of bytes
+ *	@ppos: pointer to the position to write. No seeks allowed
+ *
+ *	A write to a watchdog device is defined as a keepalive signal. Any
+ *	write of data will do, as we we don't define content meaning.
+ */
+static ssize_t wdt_write(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	/*  Can't seek (pwrite) on this device
+	if (ppos != &file->f_pos)
+	return -ESPIPE;
+	*/
+	if (count) {
+		wdt_ping();
+		return 1;
+	}
+	return 0;
+}
+
+static ssize_t wdt_read(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+/**
+ *	wdt_ioctl:
+ *	@inode: inode of the device
+ *	@file: file handle to the device
+ *	@cmd: watchdog command
+ *	@arg: argument pointer
+ *
+ *	The watchdog API defines a common set of functions for all watchdogs
+ *	according to their available features. We only actually usefully support
+ *	querying capabilities and current status.
+ */
+static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		     unsigned long arg)
+{
+	int new_margin, rv;
+	static struct watchdog_info ident = {
+		.options = WDIOF_POWERUNDER | WDIOF_KEEPALIVEPING |
+			WDIOF_SETTIMEOUT,
+		.firmware_version = 1,
+		.identity = "M41T80 WTD"
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user((struct watchdog_info __user *)arg, &ident,
+				    sizeof(ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(boot_flag, (int __user *)arg);
+	case WDIOC_KEEPALIVE:
+		wdt_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, (int __user *)arg))
+			return -EFAULT;
+		/* Arbitrary, can't find the card's limits */
+		if (new_margin < 1 || new_margin > 124)
+			return -EINVAL;
+		wdt_margin = new_margin;
+		wdt_ping();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_margin, (int __user *)arg);
+
+	case WDIOC_SETOPTIONS:
+		if (copy_from_user(&rv, (int __user *)arg, sizeof(int)))
+			return -EFAULT;
+
+		if (rv & WDIOS_DISABLECARD) {
+			printk(KERN_INFO
+			       "rtc-m41t80: disable watchdog\n");
+			wdt_disable();
+		}
+
+		if (rv & WDIOS_ENABLECARD) {
+			printk(KERN_INFO
+			       "rtc-m41t80: enable watchdog\n");
+			wdt_ping();
+		}
+
+		return -EINVAL;
+	}
+	return -ENOTTY;
+}
+
+/**
+ *	wdt_open:
+ *	@inode: inode of device
+ *	@file: file handle to device
+ *
+ */
+static int wdt_open(struct inode *inode, struct file *file)
+{
+	if (MINOR(inode->i_rdev) == WATCHDOG_MINOR) {
+		if (test_and_set_bit(0, &wdt_is_open))
+			return -EBUSY;
+		/*
+		 *	Activate
+		 */
+		wdt_is_open = 1;
+		return 0;
+	}
+	return -ENODEV;
+}
+
+/**
+ *	wdt_close:
+ *	@inode: inode to board
+ *	@file: file handle to board
+ *
+ */
+static int wdt_release(struct inode *inode, struct file *file)
+{
+	if (MINOR(inode->i_rdev) == WATCHDOG_MINOR)
+		clear_bit(0, &wdt_is_open);
+	return 0;
+}
+
+/**
+ *	notify_sys:
+ *	@this: our notifier block
+ *	@code: the event being reported
+ *	@unused: unused
+ *
+ *	Our notifier is called on system shutdowns. We want to turn the card
+ *	off at reboot otherwise the machine will reboot again during memory
+ *	test or worse yet during the following fsck. This would suck, in fact
+ *	trust me - if it happens it does suck.
+ */
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+			  void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		/* Disable Watchdog */
+		wdt_disable();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations wdt_fops = {
+	.owner	= THIS_MODULE,
+	.read	= wdt_read,
+	.ioctl	= wdt_ioctl,
+	.write	= wdt_write,
+	.open	= wdt_open,
+	.release = wdt_release,
+};
+
+static struct miscdevice wdt_dev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &wdt_fops,
+};
+
+/*
+ *	The WDT card needs to learn about soft shutdowns in order to
+ *	turn the timebomb registers off.
+ */
+static struct notifier_block wdt_notifier = {
+	.notifier_call = wdt_notify_sys,
+};
+#endif /* CONFIG_RTC_DRV_M41T80_WDT */
+
 /*
  *****************************************************************************
  *
@@ -572,6 +841,19 @@ static int m41t80_probe(struct i2c_clien
 	if (rc)
 		goto exit;
 
+#ifdef CONFIG_RTC_DRV_M41T80_WDT
+	if (chip->features & M41T80_FEATURE_HT) {
+		rc = misc_register(&wdt_dev);
+		if (rc)
+			goto exit;
+		rc = register_reboot_notifier(&wdt_notifier);
+		if (rc) {
+			misc_deregister(&wdt_dev);
+			goto exit;
+		}
+		save_client = client;
+	}
+#endif
 	return 0;
 
 st_err:
@@ -595,6 +877,12 @@ static int m41t80_remove(struct i2c_clie
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
 	struct rtc_device *rtc = clientdata->rtc;
 
+#ifdef CONFIG_RTC_DRV_M41T80_WDT
+	if (clientdata->chip->features & M41T80_FEATURE_HT) {
+		misc_deregister(&wdt_dev);
+		unregister_reboot_notifier(&wdt_notifier);
+	}
+#endif
 	if (rtc)
 		rtc_device_unregister(rtc);
 	kfree(clientdata);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-kbuild.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
