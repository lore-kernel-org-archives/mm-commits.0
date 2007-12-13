From: akpm@linux-foundation.org
Subject: + revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch added to -mm tree
Date: Wed, 12 Dec 2007 23:42:42 -0800
Message-ID: <200712130742.lBD7gkCp020748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbXLMHnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 02:43:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, rjw@sisk.pl, stern@rowland.harvard.edu


The patch titled
     revert gregkh-driver-pm-acquire-device-locks-prior-to-suspending
has been added to the -mm tree.  Its filename is
     revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -786,17 +786,11 @@ int device_add(struct device *dev)
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
 
@@ -861,7 +855,6 @@ int device_add(struct device *dev)
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

revert-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi-ia64-build-fix.patch
git-acpi-build-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cpufreq.patch
git-cpufreq-query_current_values_with_pending_wait-build-fix.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
dm-persistent_read_metadata-warning-fix.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm.patch
git-drm-oops-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
git-dvb-fix-build-in-drivers-media-dvb-frontends-tda18271h.patch
git-dvb-one-videobuf_read_start-is-enough.patch
git-dvb-drivers-media-dvb-frontends-zl10353c-avoid-64-bit-divide.patch
git-dvb-drivers-media-video-et61x251-et61x251_corec-fix-warnings.patch
media-video-usbvision-add-mutex_unlock-to-error-paths-fix.patch
i2c-fix-drivers-media-video-bt866c.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
gfs2-avoid-64-bit-divide.patch
git-hid.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long-fix.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
mips-fix-makefile-borkage.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
git-net-fix-drivers-net-ns83820c-build.patch
net-use-mutex_is_locked-for-assert_rtnl.patch
tipc-fix-semaphore-handling.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
backlight-omap1-backlight-driver-fix.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
quirk-enable-msi-mapping-on-ht1000.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
git-sched-fix-warning-in-kernel-softlockupcwatchdog.patch
kernel-time-make-tick_do_broadcast-static.patch
git-sh.patch
git-scsi-misc-fix-build-in-drivers-scsi-scsi_tgt_libc.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
hptiop-add-more-adapter-models-and-other-fixes-fix-2.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
add-support-for-sb1-hardware-watchdog-fix.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-__vdso_getcpu-warning-fix.patch
git-x86-fix-allnoconfig-build.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
bonding-locking-fix.patch
iwlwifi3945-4965-fix-rate-control-algo-reference-leak-fix.patch
bcm43xx_debugfs-sscanf-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-optimise-the-clearing-of-__gfp_zero.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
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
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
sync_sb_inodes-propagate-errors.patch
add-have_oprofile.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-fix.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.patch
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
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
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
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
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
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
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
