From: akpm@linux-foundation.org
Subject: - rtc-remove-bkl-for-ioctl.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:03 -0700
Message-ID: <200807242330.m6ONU3kA011456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756929AbYGXXac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, alan@lxorguk.ukuu.org.uk, corbet@lwn.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc: remove BKL for ioctl()
has been removed from the -mm tree.  Its filename was
     rtc-remove-bkl-for-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: remove BKL for ioctl()
From: David Brownell <david-b@pacbell.net>

Remove implicit use of BKL in ioctl() from the RTC framework.

Instead, the rtc->ops_lock is used.  That's the same lock that already
protects the RTC operations when they're issued through the exported
rtc_*() calls in drivers/rtc/interface.c ...  making this a bugfix, not
just a cleanup, since both ioctl calls and set_alarm() need to update IRQ
enable flags and that implies a common lock (which RTC drivers as a rule
do not provide on their own).

A new comment at the declaration of "struct rtc_class_ops" summarizes
current locking rules.  It's not clear to me that the exceptions listed
there should exist ...  if not, those are pre-existing problems which can
be fixed in a patch that doesn't relate to BKL removal.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |   58 ++++++++++++++++++++++++++--------------
 include/linux/rtc.h   |   17 +++++++++++
 2 files changed, 55 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/rtc-dev.c~rtc-remove-bkl-for-ioctl drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-remove-bkl-for-ioctl
+++ a/drivers/rtc/rtc-dev.c
@@ -209,7 +209,7 @@ static unsigned int rtc_dev_poll(struct 
 	return (data != 0) ? (POLLIN | POLLRDNORM) : 0;
 }
 
-static int rtc_dev_ioctl(struct inode *inode, struct file *file,
+static long rtc_dev_ioctl(struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
@@ -219,6 +219,10 @@ static int rtc_dev_ioctl(struct inode *i
 	struct rtc_wkalrm alarm;
 	void __user *uarg = (void __user *) arg;
 
+	err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return -EBUSY;
+
 	/* check that the calling task has appropriate permissions
 	 * for certain ioctls. doing this check here is useful
 	 * to avoid duplicate code in each driver.
@@ -227,26 +231,31 @@ static int rtc_dev_ioctl(struct inode *i
 	case RTC_EPOCH_SET:
 	case RTC_SET_TIME:
 		if (!capable(CAP_SYS_TIME))
-			return -EACCES;
+			err = -EACCES;
 		break;
 
 	case RTC_IRQP_SET:
 		if (arg > rtc->max_user_freq && !capable(CAP_SYS_RESOURCE))
-			return -EACCES;
+			err = -EACCES;
 		break;
 
 	case RTC_PIE_ON:
 		if (rtc->irq_freq > rtc->max_user_freq &&
 				!capable(CAP_SYS_RESOURCE))
-			return -EACCES;
+			err = -EACCES;
 		break;
 	}
 
+	if (err)
+		goto done;
+
 	/* try the driver's ioctl interface */
 	if (ops->ioctl) {
 		err = ops->ioctl(rtc->dev.parent, cmd, arg);
-		if (err != -ENOIOCTLCMD)
+		if (err != -ENOIOCTLCMD) {
+			mutex_unlock(&rtc->ops_lock);
 			return err;
+		}
 	}
 
 	/* if the driver does not provide the ioctl interface
@@ -265,15 +274,19 @@ static int rtc_dev_ioctl(struct inode *i
 
 	switch (cmd) {
 	case RTC_ALM_READ:
+		mutex_unlock(&rtc->ops_lock);
+
 		err = rtc_read_alarm(rtc, &alarm);
 		if (err < 0)
 			return err;
 
 		if (copy_to_user(uarg, &alarm.time, sizeof(tm)))
-			return -EFAULT;
-		break;
+			err = -EFAULT;
+		return err;
 
 	case RTC_ALM_SET:
+		mutex_unlock(&rtc->ops_lock);
+
 		if (copy_from_user(&alarm.time, uarg, sizeof(tm)))
 			return -EFAULT;
 
@@ -321,24 +334,26 @@ static int rtc_dev_ioctl(struct inode *i
 			}
 		}
 
-		err = rtc_set_alarm(rtc, &alarm);
-		break;
+		return rtc_set_alarm(rtc, &alarm);
 
 	case RTC_RD_TIME:
+		mutex_unlock(&rtc->ops_lock);
+
 		err = rtc_read_time(rtc, &tm);
 		if (err < 0)
 			return err;
 
 		if (copy_to_user(uarg, &tm, sizeof(tm)))
-			return -EFAULT;
-		break;
+			err = -EFAULT;
+		return err;
 
 	case RTC_SET_TIME:
+		mutex_unlock(&rtc->ops_lock);
+
 		if (copy_from_user(&tm, uarg, sizeof(tm)))
 			return -EFAULT;
 
-		err = rtc_set_time(rtc, &tm);
-		break;
+		return rtc_set_time(rtc, &tm);
 
 	case RTC_PIE_ON:
 		err = rtc_irq_set_state(rtc, NULL, 1);
@@ -376,34 +391,37 @@ static int rtc_dev_ioctl(struct inode *i
 		break;
 #endif
 	case RTC_WKALM_SET:
+		mutex_unlock(&rtc->ops_lock);
 		if (copy_from_user(&alarm, uarg, sizeof(alarm)))
 			return -EFAULT;
 
-		err = rtc_set_alarm(rtc, &alarm);
-		break;
+		return rtc_set_alarm(rtc, &alarm);
 
 	case RTC_WKALM_RD:
+		mutex_unlock(&rtc->ops_lock);
 		err = rtc_read_alarm(rtc, &alarm);
 		if (err < 0)
 			return err;
 
 		if (copy_to_user(uarg, &alarm, sizeof(alarm)))
-			return -EFAULT;
-		break;
+			err = -EFAULT;
+		return err;
 
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	case RTC_UIE_OFF:
 		clear_uie(rtc);
-		return 0;
+		break;
 
 	case RTC_UIE_ON:
-		return set_uie(rtc);
+		err = set_uie(rtc);
 #endif
 	default:
 		err = -ENOTTY;
 		break;
 	}
 
+done:
+	mutex_unlock(&rtc->ops_lock);
 	return err;
 }
 
@@ -432,7 +450,7 @@ static const struct file_operations rtc_
 	.llseek		= no_llseek,
 	.read		= rtc_dev_read,
 	.poll		= rtc_dev_poll,
-	.ioctl		= rtc_dev_ioctl,
+	.unlocked_ioctl	= rtc_dev_ioctl,
 	.open		= rtc_dev_open,
 	.release	= rtc_dev_release,
 	.fasync		= rtc_dev_fasync,
diff -puN include/linux/rtc.h~rtc-remove-bkl-for-ioctl include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-remove-bkl-for-ioctl
+++ a/include/linux/rtc.h
@@ -115,6 +115,23 @@ extern void rtc_time_to_tm(unsigned long
 
 extern struct class *rtc_class;
 
+/*
+ * For these RTC methods the device parameter is the physical device
+ * on whatever bus holds the hardware (I2C, Platform, SPI, etc), which
+ * was passed to rtc_device_register().  Its driver_data normally holds
+ * device state, including the rtc_device pointer for the RTC.
+ *
+ * Most of these methods are called with rtc_device.ops_lock held,
+ * through the rtc_*(struct rtc_device *, ...) calls.
+ *
+ * The (current) exceptions are mostly filesystem hooks:
+ *   - the proc() hook for procfs
+ *   - non-ioctl() chardev hooks:  open(), release(), read_callback()
+ *   - periodic irq calls:  irq_set_state(), irq_set_freq()
+ *
+ * REVISIT those periodic irq calls *do* have ops_lock when they're
+ * issued through ioctl() ...
+ */
 struct rtc_class_ops {
 	int (*open)(struct device *);
 	void (*release)(struct device *);
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch
mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

