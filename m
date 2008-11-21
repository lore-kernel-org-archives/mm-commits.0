From: akpm@linux-foundation.org
Subject: - rtc-add-alarm-update-irq-interfaces-version-2.patch removed from -mm tree
Date: Fri, 21 Nov 2008 12:26:02 -0800
Message-ID: <200811212026.mALKQ2lw025213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727AbYKUU0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: add alarm/update irq interfaces
has been removed from the -mm tree.  Its filename was
     rtc-add-alarm-update-irq-interfaces-version-2.patch

This patch was dropped because an updated version will be merged

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
DESC
rtc: add alarm/update irq interfaces, version 3
EDESC

This patch adds standard interfaces for alarm/update irqs enabling. 
Drivers are no more required to implement equivalent ioctl code as rtc-dev
will provide it.

UIE emulation should now be handled correctly.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   40 ++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-dev.c   |   47 ++++++++++++++++++++++++++++----------
 include/linux/rtc.h     |    6 ++++
 3 files changed, 81 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces-version-2 drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces-version-2
+++ a/drivers/rtc/interface.c
@@ -307,6 +307,46 @@ int rtc_set_alarm(struct rtc_device *rtc
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
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+		err = rtc_dev_update_irq_enable_emul(rtc, enabled);
+#else
+		err = -EINVAL;
+#endif
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
@@ -92,7 +92,7 @@ static void rtc_uie_timer(unsigned long 
 	spin_unlock_irqrestore(&rtc->irq_lock, flags);
 }
 
-static void clear_uie(struct rtc_device *rtc)
+static int clear_uie(struct rtc_device *rtc)
 {
 	spin_lock_irq(&rtc->irq_lock);
 	if (rtc->irq_active) {
@@ -111,6 +111,7 @@ static void clear_uie(struct rtc_device 
 		rtc->irq_active = 0;
 	}
 	spin_unlock_irq(&rtc->irq_lock);
+	return 0;
 }
 
 static int set_uie(struct rtc_device *rtc)
@@ -134,6 +135,16 @@ static int set_uie(struct rtc_device *rt
 	spin_unlock_irq(&rtc->irq_lock);
 	return 0;
 }
+
+int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc, unsigned int enabled)
+{
+	if (enabled)
+		return set_uie(rtc);
+	else
+		return clear_uie(rtc);
+}
+EXPORT_SYMBOL(rtc_dev_update_irq_enable_emul);
+
 #endif /* CONFIG_RTC_INTF_DEV_UIE_EMUL */
 
 static ssize_t
@@ -357,6 +368,26 @@ static long rtc_dev_ioctl(struct file *f
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
@@ -401,17 +432,6 @@ static long rtc_dev_ioctl(struct file *f
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
@@ -440,7 +460,10 @@ static int rtc_dev_release(struct inode 
 	 * Leave the alarm alone; it may be set to trigger a system wakeup
 	 * later, or be used by kernel code, and is a one-shot event anyway.
 	 */
+
+	/* Keep ioctl until all drivers are converted */
 	rtc_dev_ioctl(file, RTC_UIE_OFF, 0);
+	rtc_update_irq_enable(rtc, 0);
 	rtc_irq_set_state(rtc, NULL, 0);
 
 	if (rtc->ops->release)
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
@@ -216,6 +218,10 @@ extern int rtc_irq_set_state(struct rtc_
 				struct rtc_task *task, int enabled);
 extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
+extern int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled);
+extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
+extern int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc,
+						unsigned int enabled);
 
 typedef struct rtc_task {
 	void (*func)(void *private_data);
_

Patches currently in -mm which might be from a.zummo@towertech.it are

origin.patch
genrtc-disable-genrtc-on-blackfin-systems.patch
rtc-ds1307-smbus-compatibility.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2.patch
rtc-driver-for-pxa27x-and-pxa3xx-soc.patch
rtc-pxa27x-pxa3xx-driver-fixes-revised.patch
rtc-add-alarm-update-irq-interfaces-version-2.patch
rtc-add-alarm-update-irq-interfaces-version-5.patch
rtc-rtc-ds1390-probe-sequence-and-misc-fixes.patch
rtc-kconfig-cleanup.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
rtc-rtc-max6902-fixes-v3.patch
rtc-rtc-ds3234-fixes-v2.patch

