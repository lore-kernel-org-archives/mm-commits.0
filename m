From: akpm@linux-foundation.org
Subject: - rtc-convert-mutex-to-bitfield.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:23:59 -0800
Message-ID: <200712010023.lB10NxDg032026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330AbXLAA1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     RTC: convert mutex to bitfield
has been removed from the -mm tree.  Its filename was
     rtc-convert-mutex-to-bitfield.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RTC: convert mutex to bitfield
From: Jiri Kosina <jkosina@suse.cz>

RTC code is using mutex to assure exclusive access to /dev/rtc.  This is
however wrong usage, as it leaves the mutex locked when returning into
userspace, which is unacceptable.

Convert rtc->char_lock into bit operation.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    4 ++--
 drivers/rtc/rtc-dev.c   |   12 ++++--------
 include/linux/rtc.h     |    5 ++++-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-convert-mutex-to-bitfield drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-convert-mutex-to-bitfield
+++ a/drivers/rtc/interface.c
@@ -293,7 +293,7 @@ int rtc_irq_register(struct rtc_device *
 		return -EINVAL;
 
 	/* Cannot register while the char dev is in use */
-	if (!(mutex_trylock(&rtc->char_lock)))
+	if (test_and_set_bit(RTC_DEV_BUSY, &rtc->flags))
 		return -EBUSY;
 
 	spin_lock_irq(&rtc->irq_task_lock);
@@ -303,7 +303,7 @@ int rtc_irq_register(struct rtc_device *
 	}
 	spin_unlock_irq(&rtc->irq_task_lock);
 
-	mutex_unlock(&rtc->char_lock);
+	clear_bit(RTC_DEV_BUSY, &rtc->flags);
 
 	return retval;
 }
diff -puN drivers/rtc/rtc-dev.c~rtc-convert-mutex-to-bitfield drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-convert-mutex-to-bitfield
+++ a/drivers/rtc/rtc-dev.c
@@ -26,10 +26,7 @@ static int rtc_dev_open(struct inode *in
 					struct rtc_device, char_dev);
 	const struct rtc_class_ops *ops = rtc->ops;
 
-	/* We keep the lock as long as the device is in use
-	 * and return immediately if busy
-	 */
-	if (!(mutex_trylock(&rtc->char_lock)))
+	if (test_and_set_bit(RTC_DEV_BUSY, &rtc->flags))
 		return -EBUSY;
 
 	file->private_data = rtc;
@@ -43,8 +40,8 @@ static int rtc_dev_open(struct inode *in
 		return 0;
 	}
 
-	/* something has gone wrong, release the lock */
-	mutex_unlock(&rtc->char_lock);
+	/* something has gone wrong */
+	clear_bit(RTC_DEV_BUSY, &rtc->flags);
 	return err;
 }
 
@@ -405,7 +402,7 @@ static int rtc_dev_release(struct inode 
 	if (rtc->ops->release)
 		rtc->ops->release(rtc->dev.parent);
 
-	mutex_unlock(&rtc->char_lock);
+	clear_bit(RTC_DEV_BUSY, &rtc->flags);
 	return 0;
 }
 
@@ -440,7 +437,6 @@ void rtc_dev_prepare(struct rtc_device *
 
 	rtc->dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
 
-	mutex_init(&rtc->char_lock);
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	INIT_WORK(&rtc->uie_task, rtc_uie_task);
 	setup_timer(&rtc->uie_timer, rtc_uie_timer, (unsigned long)rtc);
diff -puN include/linux/rtc.h~rtc-convert-mutex-to-bitfield include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-convert-mutex-to-bitfield
+++ a/include/linux/rtc.h
@@ -133,6 +133,9 @@ struct rtc_class_ops {
 #define RTC_DEVICE_NAME_SIZE 20
 struct rtc_task;
 
+/* flags */
+#define RTC_DEV_BUSY 0
+
 struct rtc_device
 {
 	struct device dev;
@@ -145,7 +148,7 @@ struct rtc_device
 	struct mutex ops_lock;
 
 	struct cdev char_dev;
-	struct mutex char_lock;
+	unsigned long flags;
 
 	unsigned long irq_data;
 	spinlock_t irq_lock;
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-hid.patch
fujitsu-application-panel-driver.patch
elantech-touchpad-driver.patch
git-ipwireless_cs.patch
git-x86.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
