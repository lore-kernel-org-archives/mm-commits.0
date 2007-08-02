From: akpm@linux-foundation.org
Subject: + rtc-periodic-irq-fix.patch added to -mm tree
Date: Thu, 02 Aug 2007 16:51:33 -0700
Message-ID: <200708022351.l72NpX93015613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756685AbXHBXvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Aug 2007 19:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alessandro.zummo@towertech.it, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     RTC: periodic irq fix
has been added to the -mm tree.  Its filename is
     rtc-periodic-irq-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC: periodic irq fix
From: Alessandro Zummo <alessandro.zummo@towertech.it>

Add kernel/kernel and kernel/user locking for the periodic irq feature of
the rtc class.

PIE ioctls are also supported.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c     |    1 +
 drivers/rtc/interface.c |   15 ++++++++++++---
 drivers/rtc/rtc-dev.c   |   33 +++++++++++----------------------
 3 files changed, 24 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/class.c~rtc-periodic-irq-fix drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-periodic-irq-fix
+++ a/drivers/rtc/class.c
@@ -153,6 +153,7 @@ struct rtc_device *rtc_device_register(c
 	mutex_init(&rtc->ops_lock);
 	spin_lock_init(&rtc->irq_lock);
 	spin_lock_init(&rtc->irq_task_lock);
+	init_waitqueue_head(&rtc->irq_queue);
 
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
 	snprintf(rtc->dev.bus_id, BUS_ID_SIZE, "rtc%d", id);
diff -puN drivers/rtc/interface.c~rtc-periodic-irq-fix drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-periodic-irq-fix
+++ a/drivers/rtc/interface.c
@@ -210,6 +210,10 @@ int rtc_irq_register(struct rtc_device *
 	if (task == NULL || task->func == NULL)
 		return -EINVAL;
 
+	/* Cannot register while the char dev is in use */
+	if (!(mutex_trylock(&rtc->char_lock)))
+		return -EBUSY;
+
 	spin_lock_irq(&rtc->irq_task_lock);
 	if (rtc->irq_task == NULL) {
 		rtc->irq_task = task;
@@ -217,13 +221,14 @@ int rtc_irq_register(struct rtc_device *
 	}
 	spin_unlock_irq(&rtc->irq_task_lock);
 
+	mutex_unlock(&rtc->char_lock);
+
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_register);
 
 void rtc_irq_unregister(struct rtc_device *rtc, struct rtc_task *task)
 {
-
 	spin_lock_irq(&rtc->irq_task_lock);
 	if (rtc->irq_task == task)
 		rtc->irq_task = NULL;
@@ -240,8 +245,10 @@ int rtc_irq_set_state(struct rtc_device 
 		return -ENXIO;
 
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
+	if (rtc->irq_task != NULL && task == NULL)
+		err = -EBUSY;
 	if (rtc->irq_task != task)
-		err = -ENXIO;
+		err = -EACCES;
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	if (err == 0)
@@ -260,8 +267,10 @@ int rtc_irq_set_freq(struct rtc_device *
 		return -ENXIO;
 
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
+	if (rtc->irq_task != NULL && task == NULL)
+		err = -EBUSY;
 	if (rtc->irq_task != task)
-		err = -ENXIO;
+		err = -EACCES;
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	if (err == 0) {
diff -puN drivers/rtc/rtc-dev.c~rtc-periodic-irq-fix drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-periodic-irq-fix
+++ a/drivers/rtc/rtc-dev.c
@@ -238,17 +238,6 @@ static int rtc_dev_ioctl(struct inode *i
 		break;
 	}
 
-	/* avoid conflicting IRQ users */
-	if (cmd == RTC_PIE_ON || cmd == RTC_PIE_OFF || cmd == RTC_IRQP_SET) {
-		spin_lock_irq(&rtc->irq_task_lock);
-		if (rtc->irq_task)
-			err = -EBUSY;
-		spin_unlock_irq(&rtc->irq_task_lock);
-
-		if (err < 0)
-			return err;
-	}
-
 	/* try the driver's ioctl interface */
 	if (ops->ioctl) {
 		err = ops->ioctl(rtc->dev.parent, cmd, arg);
@@ -338,18 +327,20 @@ static int rtc_dev_ioctl(struct inode *i
 		err = rtc_set_time(rtc, &tm);
 		break;
 
-	case RTC_IRQP_READ:
-		if (ops->irq_set_freq)
-			err = put_user(rtc->irq_freq, (unsigned long __user *)uarg);
-		else
-			err = -ENOTTY;
+	case RTC_PIE_ON:
+		err = rtc_irq_set_state(rtc, NULL, 1);
+		break;
+
+	case RTC_PIE_OFF:
+		err = rtc_irq_set_state(rtc, NULL, 0);
 		break;
 
 	case RTC_IRQP_SET:
-		if (ops->irq_set_freq)
-			err = rtc_irq_set_freq(rtc, rtc->irq_task, arg);
-		else
-			err = -ENOTTY;
+		err = rtc_irq_set_freq(rtc, NULL, arg);
+		break;
+
+	case RTC_IRQP_READ:
+		err = put_user(rtc->irq_freq, (unsigned long __user *)uarg);
 		break;
 
 #if 0
@@ -449,8 +440,6 @@ void rtc_dev_prepare(struct rtc_device *
 	rtc->dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
 
 	mutex_init(&rtc->char_lock);
-	spin_lock_init(&rtc->irq_lock);
-	init_waitqueue_head(&rtc->irq_queue);
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	INIT_WORK(&rtc->uie_task, rtc_uie_task);
 	setup_timer(&rtc->uie_timer, rtc_uie_timer, (unsigned long)rtc);
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

origin.patch
rtc-periodic-irq-fix.patch
