From: akpm@linux-foundation.org
Subject: + rtc-add-alarm-update-irq-interfaces-version-5.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:26:11 -0800
Message-ID: <200811212026.mALKQB8F025302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890AbYKUU1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:27:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, anemo@mba.ocn.ne.jp, david-b@pacbell.net, ralf@linux-mips.org


The patch titled
     rtc: add alarm/update irq interfaces
has been added to the -mm tree.  Its filename is
     rtc-add-alarm-update-irq-interfaces-version-5.patch

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

UIE emulation should now be handled correctly and will work even for those
RTC drivers who cannot be configured to do both UIE and AIE.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig     |    6 +++-
 drivers/rtc/interface.c |   54 ++++++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-dev.c   |   51 ++++++++++++++++++++++++-----------
 include/linux/rtc.h     |    8 ++++-
 4 files changed, 101 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-add-alarm-update-irq-interfaces-version-5 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-alarm-update-irq-interfaces-version-5
+++ a/drivers/rtc/Kconfig
@@ -102,9 +102,13 @@ config RTC_INTF_DEV_UIE_EMUL
 	depends on RTC_INTF_DEV
 	help
 	  Provides an emulation for RTC_UIE if the underlying rtc chip
-	  driver does not expose RTC_UIE ioctls.  Those requests generate
+	  driver does not expose RTC_UIE ioctls. Those requests generate
 	  once-per-second update interrupts, used for synchronization.
 
+	  The emulation code will read the time from the hardware
+	  clock several times per second, please enable this option
+	  only if you know that you really need it.
+
 config RTC_DRV_TEST
 	tristate "Test driver/device"
 	help
diff -puN drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces-version-5 drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces-version-5
+++ a/drivers/rtc/interface.c
@@ -307,6 +307,60 @@ int rtc_set_alarm(struct rtc_device *rtc
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
+	else if (!rtc->ops->alarm_irq_enable)
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
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+	if (enabled == 0 && rtc->uie_irq_active) {
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_dev_update_irq_enable_emul(rtc, enabled);
+	}
+#endif
+
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->update_irq_enable)
+		err = -EINVAL;
+	else
+		err = rtc->ops->update_irq_enable(rtc->dev.parent, enabled);
+
+	mutex_unlock(&rtc->ops_lock);
+
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+	/*
+	 * Enable emulation if the driver did not provide
+	 * the update_irq_enable function pointer or if returned
+	 * -EINVAL to signal that it has been configured without
+	 * interrupts or that are not available at the moment.
+	 */
+	if (err == -EINVAL)
+		err = rtc_dev_update_irq_enable_emul(rtc, enabled);
+#endif
+	return err;
+}
+EXPORT_SYMBOL_GPL(rtc_update_irq_enable);
+
 /**
  * rtc_update_irq - report RTC periodic, alarm, and/or update irqs
  * @rtc: the rtc device
diff -puN drivers/rtc/rtc-dev.c~rtc-add-alarm-update-irq-interfaces-version-5 drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-add-alarm-update-irq-interfaces-version-5
+++ a/drivers/rtc/rtc-dev.c
@@ -92,10 +92,10 @@ static void rtc_uie_timer(unsigned long 
 	spin_unlock_irqrestore(&rtc->irq_lock, flags);
 }
 
-static void clear_uie(struct rtc_device *rtc)
+static int clear_uie(struct rtc_device *rtc)
 {
 	spin_lock_irq(&rtc->irq_lock);
-	if (rtc->irq_active) {
+	if (rtc->uie_irq_active) {
 		rtc->stop_uie_polling = 1;
 		if (rtc->uie_timer_active) {
 			spin_unlock_irq(&rtc->irq_lock);
@@ -108,9 +108,10 @@ static void clear_uie(struct rtc_device 
 			flush_scheduled_work();
 			spin_lock_irq(&rtc->irq_lock);
 		}
-		rtc->irq_active = 0;
+		rtc->uie_irq_active = 0;
 	}
 	spin_unlock_irq(&rtc->irq_lock);
+	return 0;
 }
 
 static int set_uie(struct rtc_device *rtc)
@@ -122,8 +123,8 @@ static int set_uie(struct rtc_device *rt
 	if (err)
 		return err;
 	spin_lock_irq(&rtc->irq_lock);
-	if (!rtc->irq_active) {
-		rtc->irq_active = 1;
+	if (!rtc->uie_irq_active) {
+		rtc->uie_irq_active = 1;
 		rtc->stop_uie_polling = 0;
 		rtc->oldsecs = tm.tm_sec;
 		rtc->uie_task_active = 1;
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
@@ -357,6 +368,22 @@ static long rtc_dev_ioctl(struct file *f
 		err = rtc_irq_set_state(rtc, NULL, 0);
 		break;
 
+	case RTC_AIE_ON:
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_alarm_irq_enable(rtc, 1);
+
+	case RTC_AIE_OFF:
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_alarm_irq_enable(rtc, 0);
+
+	case RTC_UIE_ON:
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_update_irq_enable(rtc, 1);
+
+	case RTC_UIE_OFF:
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_update_irq_enable(rtc, 0);
+
 	case RTC_IRQP_SET:
 		err = rtc_irq_set_freq(rtc, NULL, arg);
 		break;
@@ -401,17 +428,6 @@ static long rtc_dev_ioctl(struct file *f
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
@@ -440,7 +456,10 @@ static int rtc_dev_release(struct inode 
 	 * Leave the alarm alone; it may be set to trigger a system wakeup
 	 * later, or be used by kernel code, and is a one-shot event anyway.
 	 */
+
+	/* Keep ioctl until all drivers are converted */
 	rtc_dev_ioctl(file, RTC_UIE_OFF, 0);
+	rtc_update_irq_enable(rtc, 0);
 	rtc_irq_set_state(rtc, NULL, 0);
 
 	if (rtc->ops->release)
diff -puN include/linux/rtc.h~rtc-add-alarm-update-irq-interfaces-version-5 include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-add-alarm-update-irq-interfaces-version-5
+++ a/include/linux/rtc.h
@@ -145,6 +145,8 @@ struct rtc_class_ops {
 	int (*irq_set_state)(struct device *, int enabled);
 	int (*irq_set_freq)(struct device *, int freq);
 	int (*read_callback)(struct device *, int data);
+	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
+	int (*update_irq_enable)(struct device *, unsigned int enabled);
 };
 
 #define RTC_DEVICE_NAME_SIZE 20
@@ -181,7 +183,7 @@ struct rtc_device
 	struct timer_list uie_timer;
 	/* Those fields are protected by rtc->irq_lock */
 	unsigned int oldsecs;
-	unsigned int irq_active:1;
+	unsigned int uie_irq_active:1;
 	unsigned int stop_uie_polling:1;
 	unsigned int uie_task_active:1;
 	unsigned int uie_timer_active:1;
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
rtc-add-alarm-update-irq-interfaces-version-5.patch
rtc-rtc-ds1390-probe-sequence-and-misc-fixes.patch
rtc-kconfig-cleanup.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
rtc-rtc-max6902-fixes-v3.patch
rtc-rtc-ds3234-fixes-v2.patch

