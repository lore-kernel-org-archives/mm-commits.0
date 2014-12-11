From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1374-add-watchdog-support.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 11:07:27 -0800
Message-ID: <5489eb6f.Hf8zuA3LJ/ftZjmI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbaLKTH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: san@rosetechnology.dk, a.zummo@towertech.it, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1374.c: add watchdog support
has been removed from the -mm tree.  Its filename was
     rtc-ds1374-add-watchdog-support.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: S=F8ren Andersen <san@rosetechnology.dk>
Subject: drivers/rtc/rtc-ds1374.c: add watchdog support

Add support for the watchdog functionality of the DS1374 rtc.  Based on
the m41t80 watchdog functionality Note: watchdog uses the same register=
s
as alarm.

[akpm@linux-foundation.org: don't forget mutex_unlock() in ds1374_wdt_o=
pen() error path]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Soeren Andersen <san@rosetechnology.dk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    8 +
 drivers/rtc/rtc-ds1374.c |  285 +++++++++++++++++++++++++++++++++++++
 2 files changed, 293 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-ds1374-add-watchdog-support drivers/r=
tc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-ds1374-add-watchdog-support
+++ a/drivers/rtc/Kconfig
@@ -192,6 +192,14 @@ config RTC_DRV_DS1374
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1374.
=20
+config RTC_DRV_DS1374_WDT
+	bool "Dallas/Maxim DS1374 watchdog timer"
+	depends on RTC_DRV_DS1374
+	help
+	  If you say Y here you will get support for the
+	  watchdog timer in the Dallas Semiconductor DS1374
+	  real-time clock chips.
+
 config RTC_DRV_DS1672
 	tristate "Dallas/Maxim DS1672"
 	help
diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-add-watchdog-support driv=
ers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-add-watchdog-support
+++ a/drivers/rtc/rtc-ds1374.c
@@ -4,6 +4,7 @@
  * Based on code by Randy Vinson <rvinson@mvista.com>,
  * which was based on the m41t00.c by Mark Greer <mgreer@mvista.com>.
  *
+ * Copyright (C) 2014 Rose Technology
  * Copyright (C) 2006-2007 Freescale Semiconductor
  *
  * 2005 (c) MontaVista Software, Inc. This file is licensed under
@@ -26,6 +27,13 @@
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/pm.h>
+#ifdef CONFIG_RTC_DRV_DS1374_WDT
+#include <linux/fs.h>
+#include <linux/ioctl.h>
+#include <linux/miscdevice.h>
+#include <linux/reboot.h>
+#include <linux/watchdog.h>
+#endif
=20
 #define DS1374_REG_TOD0		0x00 /* Time of Day */
 #define DS1374_REG_TOD1		0x01
@@ -49,6 +57,14 @@ static const struct i2c_device_id ds1374
 };
 MODULE_DEVICE_TABLE(i2c, ds1374_id);
=20
+#ifdef CONFIG_OF
+static const struct of_device_id ds1374_of_match[] =3D {
+	{ .compatible =3D "dallas,ds1374" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds1374_of_match);
+#endif
+
 struct ds1374 {
 	struct i2c_client *client;
 	struct rtc_device *rtc;
@@ -162,6 +178,7 @@ static int ds1374_set_time(struct device
 	return ds1374_write_rtc(client, itime, DS1374_REG_TOD0, 4);
 }
=20
+#ifndef CONFIG_RTC_DRV_DS1374_WDT
 /* The ds1374 has a decrementer for an alarm, rather than a comparator=
=2E
  * If the time of day is changed, then the alarm will need to be
  * reset.
@@ -263,6 +280,7 @@ out:
 	mutex_unlock(&ds1374->mutex);
 	return ret;
 }
+#endif
=20
 static irqreturn_t ds1374_irq(int irq, void *dev_id)
 {
@@ -307,6 +325,7 @@ unlock:
 	mutex_unlock(&ds1374->mutex);
 }
=20
+#ifndef CONFIG_RTC_DRV_DS1374_WDT
 static int ds1374_alarm_irq_enable(struct device *dev, unsigned int en=
abled)
 {
 	struct i2c_client *client =3D to_i2c_client(dev);
@@ -331,15 +350,260 @@ out:
 	mutex_unlock(&ds1374->mutex);
 	return ret;
 }
+#endif
=20
 static const struct rtc_class_ops ds1374_rtc_ops =3D {
 	.read_time =3D ds1374_read_time,
 	.set_time =3D ds1374_set_time,
+#ifndef CONFIG_RTC_DRV_DS1374_WDT
 	.read_alarm =3D ds1374_read_alarm,
 	.set_alarm =3D ds1374_set_alarm,
 	.alarm_irq_enable =3D ds1374_alarm_irq_enable,
+#endif
 };
=20
+#ifdef CONFIG_RTC_DRV_DS1374_WDT
+/*
+ *********************************************************************=
********
+ *
+ * Watchdog Driver
+ *
+ *********************************************************************=
********
+ */
+static struct i2c_client *save_client;
+/* Default margin */
+#define WD_TIMO 131762
+
+#define DRV_NAME "DS1374 Watchdog"
+
+static int wdt_margin =3D WD_TIMO;
+static unsigned long wdt_is_open;
+module_param(wdt_margin, int, 0);
+MODULE_PARM_DESC(wdt_margin, "Watchdog timeout in seconds (default 32s=
)");
+
+static const struct watchdog_info ds1374_wdt_info =3D {
+	.identity       =3D "DS1374 WTD",
+	.options        =3D WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+						WDIOF_MAGICCLOSE,
+};
+
+static int ds1374_wdt_settimeout(unsigned int timeout)
+{
+	int ret =3D -ENOIOCTLCMD;
+	int cr;
+
+	ret =3D cr =3D i2c_smbus_read_byte_data(save_client, DS1374_REG_CR);
+	if (ret < 0)
+		goto out;
+
+	/* Disable any existing watchdog/alarm before setting the new one */
+	cr &=3D ~DS1374_REG_CR_WACE;
+
+	ret =3D i2c_smbus_write_byte_data(save_client, DS1374_REG_CR, cr);
+	if (ret < 0)
+		goto out;
+
+	/* Set new watchdog time */
+	ret =3D ds1374_write_rtc(save_client, timeout, DS1374_REG_WDALM0, 3);
+	if (ret) {
+		pr_info("rtc-ds1374 - couldn't set new watchdog time\n");
+		goto out;
+	}
+
+	/* Enable watchdog timer */
+	cr |=3D DS1374_REG_CR_WACE | DS1374_REG_CR_WDALM;
+	cr &=3D ~DS1374_REG_CR_AIE;
+
+	ret =3D i2c_smbus_write_byte_data(save_client, DS1374_REG_CR, cr);
+	if (ret < 0)
+		goto out;
+
+	return 0;
+out:
+	return ret;
+}
+
+
+/*
+ * Reload the watchdog timer.  (ie, pat the watchdog)
+ */
+static void ds1374_wdt_ping(void)
+{
+	u32 val;
+	int ret =3D 0;
+
+	ret =3D ds1374_read_rtc(save_client, &val, DS1374_REG_WDALM0, 3);
+	if (ret)
+		pr_info("WD TICK FAIL!!!!!!!!!! %i\n", ret);
+}
+
+static void ds1374_wdt_disable(void)
+{
+	int ret =3D -ENOIOCTLCMD;
+	int cr;
+
+	cr =3D i2c_smbus_read_byte_data(save_client, DS1374_REG_CR);
+	/* Disable watchdog timer */
+	cr &=3D ~DS1374_REG_CR_WACE;
+
+	ret =3D i2c_smbus_write_byte_data(save_client, DS1374_REG_CR, cr);
+}
+
+/*
+ * Watchdog device is opened, and watchdog starts running.
+ */
+static int ds1374_wdt_open(struct inode *inode, struct file *file)
+{
+	struct ds1374 *ds1374 =3D i2c_get_clientdata(save_client);
+
+	if (MINOR(inode->i_rdev) =3D=3D WATCHDOG_MINOR) {
+		mutex_lock(&ds1374->mutex);
+		if (test_and_set_bit(0, &wdt_is_open)) {
+			mutex_unlock(&ds1374->mutex);
+			return -EBUSY;
+		}
+		/*
+		 *      Activate
+		 */
+		wdt_is_open =3D 1;
+		mutex_unlock(&ds1374->mutex);
+		return nonseekable_open(inode, file);
+	}
+	return -ENODEV;
+}
+
+/*
+ * Close the watchdog device.
+ */
+static int ds1374_wdt_release(struct inode *inode, struct file *file)
+{
+	if (MINOR(inode->i_rdev) =3D=3D WATCHDOG_MINOR)
+		clear_bit(0, &wdt_is_open);
+
+	return 0;
+}
+
+/*
+ * Pat the watchdog whenever device is written to.
+ */
+static ssize_t ds1374_wdt_write(struct file *file, const char __user *=
data,
+				size_t len, loff_t *ppos)
+{
+	if (len) {
+		ds1374_wdt_ping();
+		return 1;
+	}
+	return 0;
+}
+
+static ssize_t ds1374_wdt_read(struct file *file, char __user *data,
+				size_t len, loff_t *ppos)
+{
+	return 0;
+}
+
+/*
+ * Handle commands from user-space.
+ */
+static long ds1374_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	int new_margin, options;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user((struct watchdog_info __user *)arg,
+		&ds1374_wdt_info, sizeof(ds1374_wdt_info)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int __user *)arg);
+	case WDIOC_KEEPALIVE:
+		ds1374_wdt_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, (int __user *)arg))
+			return -EFAULT;
+
+		if (new_margin < 1 || new_margin > 16777216)
+			return -EINVAL;
+
+		wdt_margin =3D new_margin;
+		ds1374_wdt_settimeout(new_margin);
+		ds1374_wdt_ping();
+		/* fallthrough */
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_margin, (int __user *)arg);
+	case WDIOC_SETOPTIONS:
+		if (copy_from_user(&options, (int __user *)arg, sizeof(int)))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD) {
+			pr_info("rtc-ds1374: disable watchdog\n");
+			ds1374_wdt_disable();
+		}
+
+		if (options & WDIOS_ENABLECARD) {
+			pr_info("rtc-ds1374: enable watchdog\n");
+			ds1374_wdt_settimeout(wdt_margin);
+			ds1374_wdt_ping();
+		}
+
+		return -EINVAL;
+	}
+	return -ENOTTY;
+}
+
+static long ds1374_wdt_unlocked_ioctl(struct file *file, unsigned int =
cmd,
+			unsigned long arg)
+{
+	int ret;
+	struct ds1374 *ds1374 =3D i2c_get_clientdata(save_client);
+
+	mutex_lock(&ds1374->mutex);
+	ret =3D ds1374_wdt_ioctl(file, cmd, arg);
+	mutex_unlock(&ds1374->mutex);
+
+	return ret;
+}
+
+static int ds1374_wdt_notify_sys(struct notifier_block *this,
+			unsigned long code, void *unused)
+{
+	if (code =3D=3D SYS_DOWN || code =3D=3D SYS_HALT)
+		/* Disable Watchdog */
+		ds1374_wdt_disable();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations ds1374_wdt_fops =3D {
+	.owner			=3D THIS_MODULE,
+	.read			=3D ds1374_wdt_read,
+	.unlocked_ioctl		=3D ds1374_wdt_unlocked_ioctl,
+	.write			=3D ds1374_wdt_write,
+	.open                   =3D ds1374_wdt_open,
+	.release                =3D ds1374_wdt_release,
+	.llseek			=3D no_llseek,
+};
+
+static struct miscdevice ds1374_miscdev =3D {
+	.minor          =3D WATCHDOG_MINOR,
+	.name           =3D "watchdog",
+	.fops           =3D &ds1374_wdt_fops,
+};
+
+static struct notifier_block ds1374_wdt_notifier =3D {
+	.notifier_call =3D ds1374_wdt_notify_sys,
+};
+
+#endif /*CONFIG_RTC_DRV_DS1374_WDT*/
+/*
+ *********************************************************************=
********
+ *
+ *	Driver Interface
+ *
+ *********************************************************************=
********
+ */
 static int ds1374_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -378,12 +642,33 @@ static int ds1374_probe(struct i2c_clien
 		return PTR_ERR(ds1374->rtc);
 	}
=20
+#ifdef CONFIG_RTC_DRV_DS1374_WDT
+	save_client =3D client;
+	ret =3D misc_register(&ds1374_miscdev);
+	if (ret)
+		return ret;
+	ret =3D register_reboot_notifier(&ds1374_wdt_notifier);
+	if (ret) {
+		misc_deregister(&ds1374_miscdev);
+		return ret;
+	}
+	ds1374_wdt_settimeout(131072);
+#endif
+
 	return 0;
 }
=20
 static int ds1374_remove(struct i2c_client *client)
 {
 	struct ds1374 *ds1374 =3D i2c_get_clientdata(client);
+#ifdef CONFIG_RTC_DRV_DS1374_WDT
+	int res;
+
+	res =3D misc_deregister(&ds1374_miscdev);
+	if (!res)
+		ds1374_miscdev.parent =3D NULL;
+	unregister_reboot_notifier(&ds1374_wdt_notifier);
+#endif
=20
 	if (client->irq > 0) {
 		mutex_lock(&ds1374->mutex);
_

Patches currently in -mm which might be from san@rosetechnology.dk are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
