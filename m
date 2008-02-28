From: akpm@linux-foundation.org
Subject: + pm-do-not-acquire-device-semaphores-upfront-during-suspend.patch added to -mm tree
Date: Wed, 27 Feb 2008 18:29:12 -0800
Message-ID: <200802280229.m1S2TCZO011356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbYB1Ca1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 21:30:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, gregkh@suse.de, lenb@kernel.org, pavel@ucw.cz, stern@rowland.harvard.edu, xhejtman@ics.muni.cz, zdenek.kabelac@gmail.com


The patch titled
     PM: do not acquire device semaphores upfront during suspend
has been added to the -mm tree.  Its filename is
     pm-do-not-acquire-device-semaphores-upfront-during-suspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM: do not acquire device semaphores upfront during suspend
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the code that acquires all device semaphores from the suspend code path
as it causes multiple problems to appear (most notably,
http://bugzilla.kernel.org/show_bug.cgi?id=10030) and revert the change
introduced by commit 4145ed6dc597a9bea5f6ae8c574653b2de10620f depending on the
code being removed.

Remove pm_sleep_lock()/pm_sleep_unlock() from device_add() to avoid the issue
reported at http://bugzilla.kernel.org/show_bug.cgi?id=9874.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c       |    8 --
 drivers/base/power/main.c |  106 +++++-------------------------------
 drivers/usb/core/usb.c    |    2 
 3 files changed, 17 insertions(+), 99 deletions(-)

diff -puN drivers/base/core.c~pm-do-not-acquire-device-semaphores-upfront-during-suspend drivers/base/core.c
--- a/drivers/base/core.c~pm-do-not-acquire-device-semaphores-upfront-during-suspend
+++ a/drivers/base/core.c
@@ -771,13 +771,6 @@ int device_add(struct device *dev)
 	struct class_interface *class_intf;
 	int error;
 
-	error = pm_sleep_lock();
-	if (error) {
-		dev_warn(dev, "Suspicious %s during suspend\n", __FUNCTION__);
-		dump_stack();
-		return error;
-	}
-
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
 		error = -EINVAL;
@@ -844,7 +837,6 @@ int device_add(struct device *dev)
 	}
  Done:
 	put_device(dev);
-	pm_sleep_unlock();
 	return error;
  BusError:
 	device_pm_remove(dev);
diff -puN drivers/base/power/main.c~pm-do-not-acquire-device-semaphores-upfront-during-suspend drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-do-not-acquire-device-semaphores-upfront-during-suspend
+++ a/drivers/base/power/main.c
@@ -48,7 +48,6 @@
  */
 
 LIST_HEAD(dpm_active);
-static LIST_HEAD(dpm_locked);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
 static LIST_HEAD(dpm_destroy);
@@ -81,28 +80,6 @@ void device_pm_add(struct device *dev)
  */
 void device_pm_remove(struct device *dev)
 {
-	/*
-	 * If this function is called during a suspend, it will be blocked,
-	 * because we're holding the device's semaphore at that time, which may
-	 * lead to a deadlock.  In that case we want to print a warning.
-	 * However, it may also be called by unregister_dropped_devices() with
-	 * the device's semaphore released, in which case the warning should
-	 * not be printed.
-	 */
-	if (down_trylock(&dev->sem)) {
-		if (down_read_trylock(&pm_sleep_rwsem)) {
-			/* No suspend in progress, wait on dev->sem */
-			down(&dev->sem);
-			up_read(&pm_sleep_rwsem);
-		} else {
-			/* Suspend in progress, we may deadlock */
-			dev_warn(dev, "Suspicious %s during suspend\n",
-				__FUNCTION__);
-			dump_stack();
-			/* The user has been warned ... */
-			down(&dev->sem);
-		}
-	}
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
@@ -110,7 +87,6 @@ void device_pm_remove(struct device *dev
 	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	up(&dev->sem);
 }
 
 /**
@@ -230,6 +206,8 @@ static int resume_device(struct device *
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
+	down(&dev->sem);
+
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
 		error = dev->bus->resume(dev);
@@ -245,6 +223,8 @@ static int resume_device(struct device *
 		error = dev->class->resume(dev);
 	}
 
+	up(&dev->sem);
+
 	TRACE_RESUME(error);
 	return error;
 }
@@ -266,7 +246,7 @@ static void dpm_resume(void)
 		struct list_head *entry = dpm_off.next;
 		struct device *dev = to_device(entry);
 
-		list_move_tail(entry, &dpm_locked);
+		list_move_tail(entry, &dpm_active);
 		mutex_unlock(&dpm_list_mtx);
 		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
@@ -275,25 +255,6 @@ static void dpm_resume(void)
 }
 
 /**
- *	unlock_all_devices - Release each device's semaphore
- *
- *	Go through the dpm_off list.  Put each device on the dpm_active
- *	list and unlock it.
- */
-static void unlock_all_devices(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_locked)) {
-		struct list_head *entry = dpm_locked.prev;
-		struct device *dev = to_device(entry);
-
-		list_move(entry, &dpm_active);
-		up(&dev->sem);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-/**
  *	unregister_dropped_devices - Unregister devices scheduled for removal
  *
  *	Unregister all devices on the dpm_destroy list.
@@ -305,7 +266,6 @@ static void unregister_dropped_devices(v
 		struct list_head *entry = dpm_destroy.next;
 		struct device *dev = to_device(entry);
 
-		up(&dev->sem);
 		mutex_unlock(&dpm_list_mtx);
 		/* This also removes the device from the list */
 		device_unregister(dev);
@@ -324,7 +284,6 @@ void device_resume(void)
 {
 	might_sleep();
 	dpm_resume();
-	unlock_all_devices();
 	unregister_dropped_devices();
 	up_write(&pm_sleep_rwsem);
 }
@@ -388,18 +347,15 @@ int device_power_down(pm_message_t state
 		struct list_head *entry = dpm_off.prev;
 		struct device *dev = to_device(entry);
 
-		list_del_init(&dev->power.entry);
 		error = suspend_device_late(dev, state);
 		if (error) {
 			printk(KERN_ERR "Could not power down device %s: "
 					"error %d\n",
 					kobject_name(&dev->kobj), error);
-			if (list_empty(&dev->power.entry))
-				list_add(&dev->power.entry, &dpm_off);
 			break;
 		}
-		if (list_empty(&dev->power.entry))
-			list_add(&dev->power.entry, &dpm_off_irq);
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &dpm_off_irq);
 	}
 
 	if (!error)
@@ -419,6 +375,8 @@ static int suspend_device(struct device 
 {
 	int error = 0;
 
+	down(&dev->sem);
+
 	if (dev->class && dev->class->suspend) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
@@ -436,6 +394,9 @@ static int suspend_device(struct device 
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
+
+	up(&dev->sem);
+
 	return error;
 }
 
@@ -456,11 +417,10 @@ static int dpm_suspend(pm_message_t stat
 	int error = 0;
 
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_locked)) {
-		struct list_head *entry = dpm_locked.prev;
+	while (!list_empty(&dpm_active)) {
+		struct list_head *entry = dpm_active.prev;
 		struct device *dev = to_device(entry);
 
-		list_del_init(&dev->power.entry);
 		mutex_unlock(&dpm_list_mtx);
 		error = suspend_device(dev, state);
 		if (error) {
@@ -471,14 +431,11 @@ static int dpm_suspend(pm_message_t stat
 					(error == -EAGAIN ?
 					" (please convert to suspend_late)" :
 					""));
-			mutex_lock(&dpm_list_mtx);
-			if (list_empty(&dev->power.entry))
-				list_add(&dev->power.entry, &dpm_locked);
 			break;
 		}
 		mutex_lock(&dpm_list_mtx);
-		if (list_empty(&dev->power.entry))
-			list_add(&dev->power.entry, &dpm_off);
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &dpm_off);
 	}
 	mutex_unlock(&dpm_list_mtx);
 
@@ -486,36 +443,6 @@ static int dpm_suspend(pm_message_t stat
 }
 
 /**
- *	lock_all_devices - Acquire every device's semaphore
- *
- *	Go through the dpm_active list. Carefully lock each device's
- *	semaphore and put it in on the dpm_locked list.
- */
-static void lock_all_devices(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_active)) {
-		struct list_head *entry = dpm_active.next;
-		struct device *dev = to_device(entry);
-
-		/* Required locking order is dev->sem first,
-		 * then dpm_list_mutex.  Hence this awkward code.
-		 */
-		get_device(dev);
-		mutex_unlock(&dpm_list_mtx);
-		down(&dev->sem);
-		mutex_lock(&dpm_list_mtx);
-
-		if (list_empty(entry))
-			up(&dev->sem);		/* Device was removed */
-		else
-			list_move_tail(entry, &dpm_locked);
-		put_device(dev);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-/**
  *	device_suspend - Save state and stop all devices in system.
  *	@state: new power management state
  *
@@ -528,7 +455,6 @@ int device_suspend(pm_message_t state)
 
 	might_sleep();
 	down_write(&pm_sleep_rwsem);
-	lock_all_devices();
 	error = dpm_suspend(state);
 	if (error)
 		device_resume();
diff -puN drivers/usb/core/usb.c~pm-do-not-acquire-device-semaphores-upfront-during-suspend drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~pm-do-not-acquire-device-semaphores-upfront-during-suspend
+++ a/drivers/usb/core/usb.c
@@ -234,7 +234,7 @@ static int ksuspend_usb_init(void)
 	 * singlethreaded.  Its job doesn't justify running on more
 	 * than one CPU.
 	 */
-	ksuspend_usb_wq = create_singlethread_workqueue("ksuspend_usbd");
+	ksuspend_usb_wq = create_freezeable_workqueue("ksuspend_usbd");
 	if (!ksuspend_usb_wq)
 		return -ENOMEM;
 	return 0;
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
git-xfs.patch
pm-do-not-acquire-device-semaphores-upfront-during-suspend.patch
shrink_slab-handle-bad-shrinkers.patch
