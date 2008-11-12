From: akpm@linux-foundation.org
Subject: - rtc-add-alarm-update-irq-interfaces.patch removed from -mm tree
Date: Wed, 12 Nov 2008 13:40:50 -0800
Message-ID: <200811122140.mACLepJh001412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbYKLVlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 16:41:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: add alarm/update irq interfaces
has been removed from the -mm tree.  Its filename was
     rtc-add-alarm-update-irq-interfaces.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add alarm/update irq interfaces
From: Alessandro Zummo <a.zummo@towertech.it>

Add standard interfaces for alarm/update irqs enabling.  Drivers are no
more required to implement equivalent ioctl code as rtc-dev will provide
it.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-dev.c   |   16 ++++++++++++++++
 include/linux/rtc.h     |    4 ++++
 3 files changed, 56 insertions(+)

diff -puN drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces
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
diff -puN drivers/rtc/rtc-dev.c~rtc-add-alarm-update-irq-interfaces drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-add-alarm-update-irq-interfaces
+++ a/drivers/rtc/rtc-dev.c
@@ -357,6 +357,22 @@ static long rtc_dev_ioctl(struct file *f
 		err = rtc_irq_set_state(rtc, NULL, 0);
 		break;
 
+	case RTC_AIE_ON:
+		err = rtc_alarm_irq_enable(rtc, 1);
+		break;
+
+	case RTC_AIE_OFF:
+		err = rtc_alarm_irq_enable(rtc, 0);
+		break;
+
+	case RTC_UIE_ON:
+		err = rtc_update_irq_enable(rtc, 1);
+		break;
+
+	case RTC_UIE_OFF:
+		err = rtc_update_irq_enable(rtc, 0);
+		break;
+
 	case RTC_IRQP_SET:
 		err = rtc_irq_set_freq(rtc, NULL, arg);
 		break;
diff -puN include/linux/rtc.h~rtc-add-alarm-update-irq-interfaces include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-add-alarm-update-irq-interfaces
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
rtc-add-alarm-update-irq-interfaces.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch

