From: akpm@linux-foundation.org
Subject: + rtc-add-alarm-update-irq-interfaces-version-2.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:02:54 -0800
Message-ID: <200811122302.mACN2sKF010050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbYKLXDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:03:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: add alarm/update irq interfaces
has been added to the -mm tree.  Its filename is
     rtc-add-alarm-update-irq-interfaces-version-2.patch

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
Subject: rtc: add alarm/update irq interfaces
From: Alessandro Zummo <a.zummo@towertech.it>

Add standard interfaces for alarm/update irqs enabling.  Drivers are no
more required to implement equivalent ioctl code as rtc-dev will provide
it.

UIE emulation should now be handled correctly.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   36 +++++++++++++++++++++++++++++
 drivers/rtc/rtc-dev.c   |   47 +++++++++++++++++++++++++++++---------
 include/linux/rtc.h     |    4 +++
 3 files changed, 76 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces-version-2 drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces-version-2
+++ a/drivers/rtc/interface.c
@@ -307,6 +307,42 @@ int rtc_set_alarm(struct rtc_device *rtc
 }
 EXPORT_SYMBOL_GPL(rtc_set_alarm);
 
+int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
+{
+	int err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return err;
+
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (rtc->ops->alarm_irq_enable)
+		err = -EINVAL;
+	else
+		err = rtc->ops->alarm_irq_enable(rtc->dev.parent, enabled);
+
+	mutex_unlock(&rtc->ops_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(rtc_alarm_irq_enable);
+
+int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
+{
+	int err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return err;
+
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->update_irq_enable)
+		err = -EINVAL;
+	else
+		err = rtc->ops->update_irq_enable(rtc->dev.parent, enabled);
+
+	mutex_unlock(&rtc->ops_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(rtc_update_irq_enable);
+
 /**
  * rtc_update_irq - report RTC periodic, alarm, and/or update irqs
  * @rtc: the rtc device
diff -puN drivers/rtc/rtc-dev.c~rtc-add-alarm-update-irq-interfaces-version-2 drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-add-alarm-update-irq-interfaces-version-2
+++ a/drivers/rtc/rtc-dev.c
@@ -134,6 +134,16 @@ static int set_uie(struct rtc_device *rt
 	spin_unlock_irq(&rtc->irq_lock);
 	return 0;
 }
+
+static int
+rtc_dev_update_irq_enable_emul(struct rtc_device *rtc, unsigned int enabled)
+{
+	if (enabled)
+		set_uie(rtc);
+	else
+		clear_uie(rtc);
+}
+
 #endif /* CONFIG_RTC_INTF_DEV_UIE_EMUL */
 
 static ssize_t
@@ -357,6 +367,26 @@ static long rtc_dev_ioctl(struct file *f
 		err = rtc_irq_set_state(rtc, NULL, 0);
 		break;
 
+	case RTC_AIE_ON:
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_alarm_irq_enable(rtc, 1);
+		break;
+
+	case RTC_AIE_OFF:
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_alarm_irq_enable(rtc, 0);
+		break;
+
+	case RTC_UIE_ON:
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_update_irq_enable(rtc, 1);
+		break;
+
+	case RTC_UIE_OFF:
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_update_irq_enable(rtc, 0);
+		break;
+
 	case RTC_IRQP_SET:
 		err = rtc_irq_set_freq(rtc, NULL, arg);
 		break;
@@ -401,17 +431,6 @@ static long rtc_dev_ioctl(struct file *f
 			err = -EFAULT;
 		return err;
 
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-	case RTC_UIE_OFF:
-		mutex_unlock(&rtc->ops_lock);
-		clear_uie(rtc);
-		return 0;
-
-	case RTC_UIE_ON:
-		mutex_unlock(&rtc->ops_lock);
-		err = set_uie(rtc);
-		return err;
-#endif
 	default:
 		err = -ENOTTY;
 		break;
@@ -440,7 +459,10 @@ static int rtc_dev_release(struct inode 
 	 * Leave the alarm alone; it may be set to trigger a system wakeup
 	 * later, or be used by kernel code, and is a one-shot event anyway.
 	 */
+
+	/* Keep ioctl all drivers are converted */
 	rtc_dev_ioctl(file, RTC_UIE_OFF, 0);
+	rtc_update_irq_enable(rtc, 0);
 	rtc_irq_set_state(rtc, NULL, 0);
 
 	if (rtc->ops->release)
@@ -478,6 +500,9 @@ void rtc_dev_prepare(struct rtc_device *
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	INIT_WORK(&rtc->uie_task, rtc_uie_task);
 	setup_timer(&rtc->uie_timer, rtc_uie_timer, (unsigned long)rtc);
+
+	if (rtc->ops->update_irq_enable == NULL)
+		rtc->ops->update_irq_enable = rtc_dev_update_irq_enable_emul;
 #endif
 
 	cdev_init(&rtc->char_dev, &rtc_dev_fops);
diff -puN include/linux/rtc.h~rtc-add-alarm-update-irq-interfaces-version-2 include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-add-alarm-update-irq-interfaces-version-2
+++ a/include/linux/rtc.h
@@ -145,6 +145,8 @@ struct rtc_class_ops {
 	int (*irq_set_state)(struct device *, int enabled);
 	int (*irq_set_freq)(struct device *, int freq);
 	int (*read_callback)(struct device *, int data);
+	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
+	int (*update_irq_enable)(struct device *, unsigned int enabled);
 };
 
 #define RTC_DEVICE_NAME_SIZE 20
@@ -216,6 +218,8 @@ extern int rtc_irq_set_state(struct rtc_
 				struct rtc_task *task, int enabled);
 extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
+extern int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled);
+extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
 
 typedef struct rtc_task {
 	void (*func)(void *private_data);
_

Patches currently in -mm which might be from a.zummo@towertech.it are

rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch
add-dallas-ds1390-93-94-rtc-chips.patch
rtc-ds1307-smbus-compatibility.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
rtc-add-alarm-update-irq-interfaces-version-2.patch

