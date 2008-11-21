From: akpm@linux-foundation.org
Subject: - rtc-add-alarm-update-irq-interfaces-version-3.patch removed from -mm tree
Date: Fri, 21 Nov 2008 12:25:01 -0800
Message-ID: <200811212025.mALKP1FS024694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921AbYKUUZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:25:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: add alarm/update irq interfaces, version 3
has been removed from the -mm tree.  Its filename was
     rtc-add-alarm-update-irq-interfaces-version-3.patch

This patch was dropped because it was folded into rtc-add-alarm-update-irq-interfaces-version-2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add alarm/update irq interfaces, version 3
From: Alessandro Zummo <a.zummo@towertech.it>

This patch adds standard interfaces for alarm/update irqs enabling. 
Drivers are no more required to implement equivalent ioctl code as rtc-dev
will provide it.

UIE emulation should now be handled correctly.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    4 ++++
 drivers/rtc/rtc-dev.c   |   16 +++++++---------
 include/linux/rtc.h     |    2 ++
 3 files changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces-version-3 drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-add-alarm-update-irq-interfaces-version-3
+++ a/drivers/rtc/interface.c
@@ -334,7 +334,11 @@ int rtc_update_irq_enable(struct rtc_dev
 	if (!rtc->ops)
 		err = -ENODEV;
 	else if (!rtc->ops->update_irq_enable)
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+		err = rtc_dev_update_irq_enable_emul(rtc, enabled);
+#else
 		err = -EINVAL;
+#endif
 	else
 		err = rtc->ops->update_irq_enable(rtc->dev.parent, enabled);
 
diff -puN drivers/rtc/rtc-dev.c~rtc-add-alarm-update-irq-interfaces-version-3 drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-add-alarm-update-irq-interfaces-version-3
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
@@ -135,14 +136,14 @@ static int set_uie(struct rtc_device *rt
 	return 0;
 }
 
-static int
-rtc_dev_update_irq_enable_emul(struct rtc_device *rtc, unsigned int enabled)
+int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc, unsigned int enabled)
 {
 	if (enabled)
-		set_uie(rtc);
+		return set_uie(rtc);
 	else
-		clear_uie(rtc);
+		return clear_uie(rtc);
 }
+EXPORT_SYMBOL(rtc_dev_update_irq_enable_emul);
 
 #endif /* CONFIG_RTC_INTF_DEV_UIE_EMUL */
 
@@ -460,7 +461,7 @@ static int rtc_dev_release(struct inode 
 	 * later, or be used by kernel code, and is a one-shot event anyway.
 	 */
 
-	/* Keep ioctl all drivers are converted */
+	/* Keep ioctl until all drivers are converted */
 	rtc_dev_ioctl(file, RTC_UIE_OFF, 0);
 	rtc_update_irq_enable(rtc, 0);
 	rtc_irq_set_state(rtc, NULL, 0);
@@ -500,9 +501,6 @@ void rtc_dev_prepare(struct rtc_device *
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	INIT_WORK(&rtc->uie_task, rtc_uie_task);
 	setup_timer(&rtc->uie_timer, rtc_uie_timer, (unsigned long)rtc);
-
-	if (rtc->ops->update_irq_enable == NULL)
-		rtc->ops->update_irq_enable = rtc_dev_update_irq_enable_emul;
 #endif
 
 	cdev_init(&rtc->char_dev, &rtc_dev_fops);
diff -puN include/linux/rtc.h~rtc-add-alarm-update-irq-interfaces-version-3 include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-add-alarm-update-irq-interfaces-version-3
+++ a/include/linux/rtc.h
@@ -220,6 +220,8 @@ extern int rtc_irq_set_freq(struct rtc_d
 				struct rtc_task *task, int freq);
 extern int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled);
 extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
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
rtc-add-alarm-update-irq-interfaces-version-3.patch
rtc-add-alarm-update-irq-interfaces-version-5.patch
rtc-rtc-ds1390-probe-sequence-and-misc-fixes.patch
rtc-kconfig-cleanup.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
rtc-rtc-max6902-fixes-v3.patch
rtc-rtc-ds3234-fixes-v2.patch

