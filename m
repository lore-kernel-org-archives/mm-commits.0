From: akpm@linux-foundation.org
Subject: - revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch removed from -mm tree
Date: Mon, 21 Jan 2008 14:25:55 -0800
Message-ID: <200801212225.m0LMPuAe023040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbYAUW0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 17:26:34 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m0LMPu8O030487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 21 Jan 2008 14:26:02 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-driver-pm-acquire-device-locks-prior-to-suspending
has been removed from the -mm tree.  Its filename was
     revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert gregkh-driver-pm-acquire-device-locks-prior-to-suspending
From: Andrew Morton <akpm@linux-foundation.org>

Deadlocks the t61p during suspend-to-RAM.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c        |   13 -
 drivers/base/power/main.c  |  442 ++++++++++++++---------------------
 drivers/base/power/power.h |   11 
 3 files changed, 187 insertions(+), 279 deletions(-)

diff -puN drivers/base/core.c~revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending drivers/base/core.c
--- a/drivers/base/core.c~revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending
+++ a/drivers/base/core.c
@@ -767,17 +767,11 @@ int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
-	int error;
-
-	error = pm_sleep_lock();
-	if (error)
-		return error;
+	int error = -EINVAL;
 
 	dev = get_device(dev);
-	if (!dev || !strlen(dev->bus_id)) {
-		error = -EINVAL;
-		goto Done;
-	}
+	if (!dev || !strlen(dev->bus_id))
+		goto Error;
 
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
 
@@ -841,7 +835,6 @@ int device_add(struct device *dev)
 	}
  Done:
 	put_device(dev);
-	pm_sleep_unlock();
 	return error;
  BusError:
 	device_pm_remove(dev);
diff -puN drivers/base/power/main.c~revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending drivers/base/power/main.c
--- a/drivers/base/power/main.c~revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending
+++ a/drivers/base/power/main.c
@@ -24,38 +24,17 @@
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/resume-trace.h>
-#include <linux/rwsem.h>
 
 #include "../base.h"
 #include "power.h"
 
-/*
- * The entries in the dpm_active list are in a depth first order, simply
- * because children are guaranteed to be discovered after parents, and
- * are inserted at the back of the list on discovery.
- *
- * All the other lists are kept in the same order, for consistency.
- * However the lists aren't always traversed in the same order.
- * Semaphores must be acquired from the top (i.e., front) down
- * and released in the opposite order.  Devices must be suspended
- * from the bottom (i.e., end) up and resumed in the opposite order.
- * That way no parent will be suspended while it still has an active
- * child.
- *
- * Since device_pm_add() may be called with a device semaphore held,
- * we must never try to acquire a device semaphore while holding
- * dpm_list_mutex.
- */
-
 LIST_HEAD(dpm_active);
-static LIST_HEAD(dpm_locked);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
 
+static DEFINE_MUTEX(dpm_mtx);
 static DEFINE_MUTEX(dpm_list_mtx);
 
-static DECLARE_RWSEM(pm_sleep_rwsem);
-
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
 
@@ -74,113 +53,30 @@ void device_pm_remove(struct device *dev
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
-
-	/* Don't remove a device while the PM core has it locked for suspend */
-	down(&dev->sem);
 	mutex_lock(&dpm_list_mtx);
 	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	up(&dev->sem);
-}
-
-/**
- *	pm_sleep_lock - mutual exclusion for registration and suspend
- *
- *	Returns 0 if no suspend is underway and device registration
- *	may proceed, otherwise -EBUSY.
- */
-int pm_sleep_lock(void)
-{
-	if (down_read_trylock(&pm_sleep_rwsem))
-		return 0;
-	return -EBUSY;
-}
-
-/**
- *	pm_sleep_unlock - mutual exclusion for registration and suspend
- *
- *	This routine undoes the effect of device_pm_add_lock
- *	when a device's registration is complete.
- */
-void pm_sleep_unlock(void)
-{
-	up_read(&pm_sleep_rwsem);
 }
 
 
 /*------------------------- Resume routines -------------------------*/
 
 /**
- *	resume_device_early - Power on one device (early resume).
- *	@dev:	Device.
- *
- *	Must be called with interrupts disabled.
- */
-static int resume_device_early(struct device *dev)
-{
-	int error = 0;
-
-	TRACE_DEVICE(dev);
-	TRACE_RESUME(0);
-
-	if (dev->bus && dev->bus->resume_early) {
-		dev_dbg(dev,"EARLY resume\n");
-		error = dev->bus->resume_early(dev);
-	}
-
-	TRACE_RESUME(error);
-	return error;
-}
-
-/**
- *	dpm_power_up - Power on all regular (non-sysdev) devices.
- *
- *	Walk the dpm_off_irq list and power each device up. This
- *	is used for devices that required they be powered down with
- *	interrupts disabled. As devices are powered on, they are moved
- *	to the dpm_off list.
- *
- *	Interrupts must be disabled when calling this.
- */
-static void dpm_power_up(void)
-{
-	while (!list_empty(&dpm_off_irq)) {
-		struct list_head *entry = dpm_off_irq.next;
-		struct device *dev = to_device(entry);
-
-		resume_device_early(dev);
-		list_move_tail(entry, &dpm_off);
-	}
-}
-
-/**
- *	device_power_up - Turn on all devices that need special attention.
- *
- *	Power on system devices, then devices that required we shut them down
- *	with interrupts disabled.
- *
- *	Must be called with interrupts disabled.
- */
-void device_power_up(void)
-{
-	sysdev_resume();
-	dpm_power_up();
-}
-EXPORT_SYMBOL_GPL(device_power_up);
-
-/**
  *	resume_device - Restore state for one device.
  *	@dev:	Device.
  *
  */
-static int resume_device(struct device *dev)
+
+static int resume_device(struct device * dev)
 {
 	int error = 0;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
+	down(&dev->sem);
+
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
 		error = dev->bus->resume(dev);
@@ -196,68 +92,126 @@ static int resume_device(struct device *
 		error = dev->class->resume(dev);
 	}
 
+	up(&dev->sem);
+
 	TRACE_RESUME(error);
 	return error;
 }
 
-/**
- *	dpm_resume - Resume every device.
- *
- *	Resume the devices that have either not gone through
- *	the late suspend, or that did go through it but also
- *	went through the early resume.
- *
- *	Take devices from the dpm_off_list, resume them,
- *	and put them on the dpm_locked list.
- */
-static void dpm_resume(void)
+
+static int resume_device_early(struct device * dev)
 {
-	while(!list_empty(&dpm_off)) {
-		struct list_head *entry = dpm_off.next;
-		struct device *dev = to_device(entry);
+	int error = 0;
 
-		resume_device(dev);
-		list_move_tail(entry, &dpm_locked);
+	TRACE_DEVICE(dev);
+	TRACE_RESUME(0);
+	if (dev->bus && dev->bus->resume_early) {
+		dev_dbg(dev,"EARLY resume\n");
+		error = dev->bus->resume_early(dev);
 	}
+	TRACE_RESUME(error);
+	return error;
 }
 
-/**
- *	unlock_all_devices - Release each device's semaphore
- *
- *	Go through the dpm_off list.  Put each device on the dpm_active
- *	list and unlock it.
+/*
+ * Resume the devices that have either not gone through
+ * the late suspend, or that did go through it but also
+ * went through the early resume
  */
-static void unlock_all_devices(void)
+static void dpm_resume(void)
 {
 	mutex_lock(&dpm_list_mtx);
- 	while (!list_empty(&dpm_locked)) {
- 		struct list_head *entry = dpm_locked.prev;
- 		struct device *dev = to_device(entry);
-
- 		list_move(entry, &dpm_active);
- 		up(&dev->sem);
- 	}
+	while(!list_empty(&dpm_off)) {
+		struct list_head * entry = dpm_off.next;
+		struct device * dev = to_device(entry);
+
+		get_device(dev);
+		list_move_tail(entry, &dpm_active);
+
+		mutex_unlock(&dpm_list_mtx);
+		resume_device(dev);
+		mutex_lock(&dpm_list_mtx);
+		put_device(dev);
+	}
 	mutex_unlock(&dpm_list_mtx);
 }
 
+
 /**
  *	device_resume - Restore state of each device in system.
  *
- *	Resume all the devices, unlock them all, and allow new
- *	devices to be registered once again.
+ *	Walk the dpm_off list, remove each entry, resume the device,
+ *	then add it to the dpm_active list.
  */
+
 void device_resume(void)
 {
 	might_sleep();
+	mutex_lock(&dpm_mtx);
 	dpm_resume();
-	unlock_all_devices();
-	up_write(&pm_sleep_rwsem);
+	mutex_unlock(&dpm_mtx);
 }
+
 EXPORT_SYMBOL_GPL(device_resume);
 
 
+/**
+ *	dpm_power_up - Power on some devices.
+ *
+ *	Walk the dpm_off_irq list and power each device up. This
+ *	is used for devices that required they be powered down with
+ *	interrupts disabled. As devices are powered on, they are moved
+ *	to the dpm_active list.
+ *
+ *	Interrupts must be disabled when calling this.
+ */
+
+static void dpm_power_up(void)
+{
+	while(!list_empty(&dpm_off_irq)) {
+		struct list_head * entry = dpm_off_irq.next;
+		struct device * dev = to_device(entry);
+
+		list_move_tail(entry, &dpm_off);
+		resume_device_early(dev);
+	}
+}
+
+
+/**
+ *	device_power_up - Turn on all devices that need special attention.
+ *
+ *	Power on system devices then devices that required we shut them down
+ *	with interrupts disabled.
+ *	Called with interrupts disabled.
+ */
+
+void device_power_up(void)
+{
+	sysdev_resume();
+	dpm_power_up();
+}
+
+EXPORT_SYMBOL_GPL(device_power_up);
+
+
 /*------------------------- Suspend routines -------------------------*/
 
+/*
+ * The entries in the dpm_active list are in a depth first order, simply
+ * because children are guaranteed to be discovered after parents, and
+ * are inserted at the back of the list on discovery.
+ *
+ * All list on the suspend path are done in reverse order, so we operate
+ * on the leaves of the device tree (or forests, depending on how you want
+ * to look at it ;) first. As nodes are removed from the back of the list,
+ * they are inserted into the front of their destintation lists.
+ *
+ * Things are the reverse on the resume path - iterations are done in
+ * forward order, and nodes are inserted at the back of their destination
+ * lists. This way, the ancestors will be accessed before their descendents.
+ */
+
 static inline char *suspend_verb(u32 event)
 {
 	switch (event) {
@@ -268,6 +222,7 @@ static inline char *suspend_verb(u32 eve
 	}
 }
 
+
 static void
 suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
 {
@@ -277,69 +232,16 @@ suspend_device_dbg(struct device *dev, p
 }
 
 /**
- *	suspend_device_late - Shut down one device (late suspend).
- *	@dev:	Device.
- *	@state:	Power state device is entering.
- *
- *	This is called with interrupts off and only a single CPU running.
- */
-static int suspend_device_late(struct device *dev, pm_message_t state)
-{
-	int error = 0;
-
-	if (dev->bus && dev->bus->suspend_late) {
-		suspend_device_dbg(dev, state, "LATE ");
-		error = dev->bus->suspend_late(dev, state);
-		suspend_report_result(dev->bus->suspend_late, error);
-	}
-	return error;
-}
-
-/**
- *	device_power_down - Shut down special devices.
- *	@state:		Power state to enter.
- *
- *	Power down devices that require interrupts to be disabled
- *	and move them from the dpm_off list to the dpm_off_irq list.
- *	Then power down system devices.
- *
- *	Must be called with interrupts disabled and only one CPU running.
- */
-int device_power_down(pm_message_t state)
-{
-	int error = 0;
-
-	while (!list_empty(&dpm_off)) {
-		struct list_head *entry = dpm_off.prev;
-		struct device *dev = to_device(entry);
-
-		error = suspend_device_late(dev, state);
-		if (error) {
-			printk(KERN_ERR "Could not power down device %s: "
-					"error %d\n",
-					kobject_name(&dev->kobj), error);
-			break;
-		}
-		list_move(&dev->power.entry, &dpm_off_irq);
-	}
-
-	if (!error)
-		error = sysdev_suspend(state);
-	if (error)
-		dpm_power_up();
-	return error;
-}
-EXPORT_SYMBOL_GPL(device_power_down);
-
-/**
  *	suspend_device - Save state of one device.
  *	@dev:	Device.
  *	@state:	Power state device is entering.
  */
-int suspend_device(struct device *dev, pm_message_t state)
+
+static int suspend_device(struct device * dev, pm_message_t state)
 {
 	int error = 0;
 
+	down(&dev->sem);
 	if (dev->power.power_state.event) {
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
@@ -362,99 +264,123 @@ int suspend_device(struct device *dev, p
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
+	up(&dev->sem);
 	return error;
 }
 
-/**
- *	dpm_suspend - Suspend every device.
- *	@state:	Power state to put each device in.
- *
- *	Walk the dpm_locked list.  Suspend each device and move it
- *	to the dpm_off list.
- *
- *	(For historical reasons, if it returns -EAGAIN, that used to mean
- *	that the device would be called again with interrupts disabled.
- *	These days, we use the "suspend_late()" callback for that, so we
- *	print a warning and consider it an error).
+
+/*
+ * This is called with interrupts off, only a single CPU
+ * running. We can't acquire a mutex or semaphore (and we don't
+ * need the protection)
  */
-static int dpm_suspend(pm_message_t state)
+static int suspend_device_late(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	while (!list_empty(&dpm_locked)) {
-		struct list_head *entry = dpm_locked.prev;
-		struct device *dev = to_device(entry);
-
-		error = suspend_device(dev, state);
-		if (error) {
-			printk(KERN_ERR "Could not suspend device %s: "
-					"error %d%s\n",
-					kobject_name(&dev->kobj),
-					error,
-					(error == -EAGAIN ?
-					" (please convert to suspend_late)" :
-					""));
-			break;
-		}
- 		list_move(&dev->power.entry, &dpm_off);
+	if (dev->bus && dev->bus->suspend_late) {
+		suspend_device_dbg(dev, state, "LATE ");
+		error = dev->bus->suspend_late(dev, state);
+		suspend_report_result(dev->bus->suspend_late, error);
 	}
-
-	if (error)
-		dpm_resume();
 	return error;
 }
 
 /**
- *	lock_all_devices - Acquire every device's semaphore
+ *	device_suspend - Save state and stop all devices in system.
+ *	@state:		Power state to put each device in.
+ *
+ *	Walk the dpm_active list, call ->suspend() for each device, and move
+ *	it to the dpm_off list.
+ *
+ *	(For historical reasons, if it returns -EAGAIN, that used to mean
+ *	that the device would be called again with interrupts disabled.
+ *	These days, we use the "suspend_late()" callback for that, so we
+ *	print a warning and consider it an error).
+ *
+ *	If we get a different error, try and back out.
+ *
+ *	If we hit a failure with any of the devices, call device_resume()
+ *	above to bring the suspended devices back to life.
  *
- *	Go through the dpm_active list. Carefully lock each device's
- *	semaphore and put it in on the dpm_locked list.
  */
-static void lock_all_devices(void)
+
+int device_suspend(pm_message_t state)
 {
+	int error = 0;
+
+	might_sleep();
+	mutex_lock(&dpm_mtx);
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_active)) {
-		struct list_head *entry = dpm_active.next;
-		struct device *dev = to_device(entry);
-
-		/* Required locking order is dev->sem first,
-		 * then dpm_list_mutex.  Hence this awkward code.
-		 */
+	while (!list_empty(&dpm_active) && error == 0) {
+		struct list_head * entry = dpm_active.prev;
+		struct device * dev = to_device(entry);
+
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
-		down(&dev->sem);
+
+		error = suspend_device(dev, state);
+
 		mutex_lock(&dpm_list_mtx);
 
-		if (list_empty(entry))
-			up(&dev->sem);		/* Device was removed */
-		else
-			list_move_tail(entry, &dpm_locked);
+		/* Check if the device got removed */
+		if (!list_empty(&dev->power.entry)) {
+			/* Move it to the dpm_off list */
+			if (!error)
+				list_move(&dev->power.entry, &dpm_off);
+		}
+		if (error)
+			printk(KERN_ERR "Could not suspend device %s: "
+				"error %d%s\n",
+				kobject_name(&dev->kobj), error,
+				error == -EAGAIN ? " (please convert to suspend_late)" : "");
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	if (error)
+		dpm_resume();
+
+	mutex_unlock(&dpm_mtx);
+	return error;
 }
 
+EXPORT_SYMBOL_GPL(device_suspend);
+
 /**
- *	device_suspend - Save state and stop all devices in system.
+ *	device_power_down - Shut down special devices.
+ *	@state:		Power state to enter.
  *
- *	Prevent new devices from being registered, then lock all devices
- *	and suspend them.
+ *	Walk the dpm_off_irq list, calling ->power_down() for each device that
+ *	couldn't power down the device with interrupts enabled. When we're
+ *	done, power down system devices.
  */
-int device_suspend(pm_message_t state)
+
+int device_power_down(pm_message_t state)
 {
-	int error;
+	int error = 0;
+	struct device * dev;
 
-	might_sleep();
-	down_write(&pm_sleep_rwsem);
-	lock_all_devices();
-	error = dpm_suspend(state);
-	if (error) {
-		unlock_all_devices();
-		up_write(&pm_sleep_rwsem);
+	while (!list_empty(&dpm_off)) {
+		struct list_head * entry = dpm_off.prev;
+
+		dev = to_device(entry);
+		error = suspend_device_late(dev, state);
+		if (error)
+			goto Error;
+		list_move(&dev->power.entry, &dpm_off_irq);
 	}
+
+	error = sysdev_suspend(state);
+ Done:
 	return error;
+ Error:
+	printk(KERN_ERR "Could not power down device %s: "
+		"error %d\n", kobject_name(&dev->kobj), error);
+	dpm_power_up();
+	goto Done;
 }
-EXPORT_SYMBOL_GPL(device_suspend);
+
+EXPORT_SYMBOL_GPL(device_power_down);
 
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
diff -puN drivers/base/power/power.h~revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending drivers/base/power/power.h
--- a/drivers/base/power/power.h~revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending
+++ a/drivers/base/power/power.h
@@ -13,8 +13,6 @@ static inline struct device *to_device(s
 
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
-extern int pm_sleep_lock(void);
-extern void pm_sleep_unlock(void);
 
 #else /* CONFIG_PM_SLEEP */
 
@@ -27,15 +25,6 @@ static inline void device_pm_remove(stru
 {
 }
 
-static inline int pm_sleep_lock(void)
-{
-	return 0;
-}
-
-static inline void pm_sleep_unlock(void)
-{
-}
-
 #endif
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-ignore-acpi-video-devices-that-arent-present-in-hardware-checkpatch-fixes.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-alsa-disable-sound-pci-ice1712-ice1724c.patch
git-agpgart.patch
git-agpgart-intel-agp-dont-zero-an-already-registered-resource-during-resume.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
intel_agp-add-new-chipset-ids-checkpatch-fixes.patch
git-arm.patch
git-audit-master.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-cpufreq.patch
cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance.patch
revert-agk-dm-dm-loop.patch
git-powerpc.patch
git-powerpc-fixup.patch
include-asm-powerpc-nvramh-needs-listh.patch
include-asm-powerpc-nvramh-needs-listh-fix.patch
revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
intel-agp-enable-i915-recognition.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
git-dvb.patch
drivers-media-dvb-frontends-xc5000c-dont-return-garbage-from-xc5000_init.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
git-dvb-fix-drivers-media-video-bt8xx-bttv-driverc-build.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
git-hid.patch
revert-git-hrt.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-versus-driver-tree.patch
git-infiniband-fix-build-with-config_infiniband_ipoib_cm=n.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-fix-drivers-ata-sata_fslc.patch
fix-ide-mm-ide-use-ide_destroy_dmatable-instead-of-pci_unmap_sg.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-ubi-wlc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-scanc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-cdevc-unused-var.patch
git-ubi.patch
git-net.patch
git-net-fix-conflicts.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-netdev-all.patch
git-netdev-all-fix-conflicts.patch
git-netdev-all-fix-conflicts-fix.patch
git-net-vs-git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
git-battery.patch
bluetooth-uninlining.patch
net-sunrpc-schedc-revert-git-net-changes.patch
net-sunrpc-schedc-reapply-git-net-changes.patch
git-nfsd.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch
revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
fix-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fixup.patch
git-sched-fix-bug_on.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch
scsi-fix-isa-pcmcia-compile-problem-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
fix-gregkh-usb-usb-ti_usb-termios-cleanups.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
wdt-fix-locking-checkpatch-fixes.patch
drivers-net-wireless-iwlwifi-iwl-3945c-fix-printk-warning.patch
drivers-net-wireless-iwlwifi-iwl-4965c-fix-printk-warning.patch
drivers-net-wireless-rt2x00-rt2x00usbc-fix-uninitialized-var-warning.patch
git-ipwireless_cs.patch
revert-kvm-stuff-to-make-git-x86-apply.patch
git-x86.patch
git-x86-fixup.patch
git-x86-fixup-2.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
git-x86-pat-fix-checkpatch-fixes.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
git-newsetup.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
usbtouchscreen-fix-buffer-overflow-make-more-egalax-work.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
export-iov_shorten-for-ext4s-use-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
add-have_oprofile.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
