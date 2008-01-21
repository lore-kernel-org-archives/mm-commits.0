From: akpm@linux-foundation.org
Subject: - pm-acquire-device-locks-on-suspend-rev-3.patch removed from -mm tree
Date: Mon, 21 Jan 2008 14:26:07 -0800
Message-ID: <200801212226.m0LMQ7i2023052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbYAUW1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 17:27:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     PM: acquire device locks on suspend
has been removed from the -mm tree.  Its filename was
     pm-acquire-device-locks-on-suspend-rev-3.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: PM: acquire device locks on suspend
=46rom: Rafael J. Wysocki <rjw@sisk.pl>
      Alan Stern <stern@rowland.harvard.edu>

Reorganize the way suspend and resume notifications are sent to drivers=
=2E=20
The major changes are that now the PM core acquires every device semaph=
ore
before calling the methods, and calls to device_add() during suspends w=
ill
fail, while calls to device_del() during suspends will block.

It also provides a way to safely remove a suspended device with the hel=
p of
the PM core, by using the device_pm_schedule_removal() callback introdu=
ced
specifically for this purpose, and updates two drivers (msr and cpuid) =
that
need to use it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpuid.c    |    6=20
 arch/x86/kernel/msr.c      |    6=20
 drivers/base/core.c        |   65 +++-
 drivers/base/power/main.c  |  504 ++++++++++++++++++++++-------------
 drivers/base/power/power.h |   12=20
 include/linux/device.h     |    8=20
 6 files changed, 414 insertions(+), 187 deletions(-)

diff -puN arch/x86/kernel/cpuid.c~pm-acquire-device-locks-on-suspend-re=
v-3 arch/x86/kernel/cpuid.c
--- a/arch/x86/kernel/cpuid.c~pm-acquire-device-locks-on-suspend-rev-3
+++ a/arch/x86/kernel/cpuid.c
@@ -157,15 +157,15 @@ static int __cpuinit cpuid_class_cpu_cal
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		err =3D cpuid_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		cpuid_device_destroy(cpu);
 		break;
+	case CPU_UP_CANCELED_FROZEN:
+		destroy_suspended_device(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
+		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
diff -puN arch/x86/kernel/msr.c~pm-acquire-device-locks-on-suspend-rev-=
3 arch/x86/kernel/msr.c
--- a/arch/x86/kernel/msr.c~pm-acquire-device-locks-on-suspend-rev-3
+++ a/arch/x86/kernel/msr.c
@@ -155,15 +155,15 @@ static int __cpuinit msr_class_cpu_callb
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		err =3D msr_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		msr_device_destroy(cpu);
 		break;
+	case CPU_UP_CANCELED_FROZEN:
+		destroy_suspended_device(msr_class, MKDEV(MSR_MAJOR, cpu));
+		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
diff -puN drivers/base/core.c~pm-acquire-device-locks-on-suspend-rev-3 =
drivers/base/core.c
--- a/drivers/base/core.c~pm-acquire-device-locks-on-suspend-rev-3
+++ a/drivers/base/core.c
@@ -767,11 +767,20 @@ int device_add(struct device *dev)
 {
 	struct device *parent =3D NULL;
 	struct class_interface *class_intf;
-	int error =3D -EINVAL;
+	int error;
+
+	error =3D pm_sleep_lock();
+	if (error) {
+		dev_warn(dev, "Suspicious %s during suspend\n", __FUNCTION__);
+		dump_stack();
+		return error;
+	}
=20
 	dev =3D get_device(dev);
-	if (!dev || !strlen(dev->bus_id))
+	if (!dev || !strlen(dev->bus_id)) {
+		error =3D -EINVAL;
 		goto Error;
+	}
=20
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
=20
@@ -835,6 +844,7 @@ int device_add(struct device *dev)
 	}
  Done:
 	put_device(dev);
+	pm_sleep_unlock();
 	return error;
  BusError:
 	device_pm_remove(dev);
@@ -926,6 +936,7 @@ void device_del(struct device * dev)
 	struct device * parent =3D dev->parent;
 	struct class_interface *class_intf;
=20
+	device_pm_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
 	if (MAJOR(dev->devt))
@@ -961,7 +972,6 @@ void device_del(struct device * dev)
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
-	device_pm_remove(dev);
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	cleanup_device_parent(dev);
 	kobject_del(&dev->kobj);
@@ -1139,14 +1149,11 @@ error:
 EXPORT_SYMBOL_GPL(device_create);
=20
 /**
- * device_destroy - removes a device that was created with device_crea=
te()
+ * find_device - finds a device that was created with device_create()
  * @class: pointer to the struct class that this device was registered=
 with
  * @devt: the dev_t of the device that was previously registered
- *
- * This call unregisters and cleans up a device that was created with =
a
- * call to device_create().
  */
-void device_destroy(struct class *class, dev_t devt)
+static struct device *find_device(struct class *class, dev_t devt)
 {
 	struct device *dev =3D NULL;
 	struct device *dev_tmp;
@@ -1159,12 +1166,54 @@ void device_destroy(struct class *class,
 		}
 	}
 	up(&class->sem);
+	return dev;
+}
+
+/**
+ * device_destroy - removes a device that was created with device_crea=
te()
+ * @class: pointer to the struct class that this device was registered=
 with
+ * @devt: the dev_t of the device that was previously registered
+ *
+ * This call unregisters and cleans up a device that was created with =
a
+ * call to device_create().
+ */
+void device_destroy(struct class *class, dev_t devt)
+{
+	struct device *dev;
=20
+	dev =3D find_device(class, devt);
 	if (dev)
 		device_unregister(dev);
 }
 EXPORT_SYMBOL_GPL(device_destroy);
=20
+#ifdef CONFIG_PM_SLEEP
+/**
+ * destroy_suspended_device - asks the PM core to remove a suspended d=
evice
+ * @class: pointer to the struct class that this device was registered=
 with
+ * @devt: the dev_t of the device that was previously registered
+ *
+ * This call notifies the PM core of the necessity to unregister a sus=
pended
+ * device created with a call to device_create() (devices cannot be
+ * unregistered directly while suspended, since the PM core holds thei=
r
+ * semaphores at that time).
+ *
+ * It can only be called within the scope of a system sleep transition=
=2E =A0In
+ * practice this means it has to be directly or indirectly invoked eit=
her by
+ * a suspend or resume method, or by the PM core (e.g. via
+ * disable_nonboot_cpus() or enable_nonboot_cpus()).
+ */
+void destroy_suspended_device(struct class *class, dev_t devt)
+{
+	struct device *dev;
+
+	dev =3D find_device(class, devt);
+	if (dev)
+		device_pm_schedule_removal(dev);
+}
+EXPORT_SYMBOL_GPL(destroy_suspended_device);
+#endif /* CONFIG_PM_SLEEP */
+
 /**
  * device_rename - renames a device
  * @dev: the pointer to the struct device to be renamed
diff -puN drivers/base/power/main.c~pm-acquire-device-locks-on-suspend-=
rev-3 drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-acquire-device-locks-on-suspend-rev-=
3
+++ a/drivers/base/power/main.c
@@ -24,20 +24,45 @@
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/resume-trace.h>
+#include <linux/rwsem.h>
=20
 #include "../base.h"
 #include "power.h"
=20
+/*
+ * The entries in the dpm_active list are in a depth first order, simp=
ly
+ * because children are guaranteed to be discovered after parents, and
+ * are inserted at the back of the list on discovery.
+ *
+ * All the other lists are kept in the same order, for consistency.
+ * However the lists aren't always traversed in the same order.
+ * Semaphores must be acquired from the top (i.e., front) down
+ * and released in the opposite order.  Devices must be suspended
+ * from the bottom (i.e., end) up and resumed in the opposite order.
+ * That way no parent will be suspended while it still has an active
+ * child.
+ *
+ * Since device_pm_add() may be called with a device semaphore held,
+ * we must never try to acquire a device semaphore while holding
+ * dpm_list_mutex.
+ */
+
 LIST_HEAD(dpm_active);
+static LIST_HEAD(dpm_locked);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
+static LIST_HEAD(dpm_destroy);
=20
-static DEFINE_MUTEX(dpm_mtx);
 static DEFINE_MUTEX(dpm_list_mtx);
=20
-int (*platform_enable_wakeup)(struct device *dev, int is_on);
+static DECLARE_RWSEM(pm_sleep_rwsem);
=20
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
=20
+/**
+ *	device_pm_add - add a device to the list of active devices
+ *	@dev:	Device to be added to the list
+ */
 void device_pm_add(struct device *dev)
 {
 	pr_debug("PM: Adding info for %s:%s\n",
@@ -48,8 +73,36 @@ void device_pm_add(struct device *dev)
 	mutex_unlock(&dpm_list_mtx);
 }
=20
+/**
+ *	device_pm_remove - remove a device from the list of active devices
+ *	@dev:	Device to be removed from the list
+ *
+ *	This function also removes the device's PM-related sysfs attributes=
=2E
+ */
 void device_pm_remove(struct device *dev)
 {
+	/*
+	 * If this function is called during a suspend, it will be blocked,
+	 * because we're holding the device's semaphore at that time, which m=
ay
+	 * lead to a deadlock. =A0In that case we want to print a warning.
+	 * However, it may also be called by unregister_dropped_devices() wit=
h
+	 * the device's semaphore released, in which case the warning should
+	 * not be printed.
+	 */
+	if (down_trylock(&dev->sem)) {
+		if (down_read_trylock(&pm_sleep_rwsem)) {
+			/* No suspend in progress, wait on dev->sem */
+			down(&dev->sem);
+			up_read(&pm_sleep_rwsem);
+		} else {
+			/* Suspend in progress, we may deadlock */
+			dev_warn(dev, "Suspicious %s during suspend\n",
+				__FUNCTION__);
+			dump_stack();
+			/* The user has been warned ... */
+			down(&dev->sem);
+		}
+	}
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
@@ -57,25 +110,124 @@ void device_pm_remove(struct device *dev
 	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
+	up(&dev->sem);
+}
+
+/**
+ *	device_pm_schedule_removal - schedule the removal of a suspended de=
vice
+ *	@dev:	Device to destroy
+ *
+ *	Moves the device to the dpm_destroy list for further processing by
+ *	unregister_dropped_devices().
+ */
+void device_pm_schedule_removal(struct device *dev)
+{
+	pr_debug("PM: Preparing for removal: %s:%s\n",
+		dev->bus ? dev->bus->name : "No Bus",
+		kobject_name(&dev->kobj));
+	mutex_lock(&dpm_list_mtx);
+	list_move_tail(&dev->power.entry, &dpm_destroy);
+	mutex_unlock(&dpm_list_mtx);
+}
+
+/**
+ *	pm_sleep_lock - mutual exclusion for registration and suspend
+ *
+ *	Returns 0 if no suspend is underway and device registration
+ *	may proceed, otherwise -EBUSY.
+ */
+int pm_sleep_lock(void)
+{
+	if (down_read_trylock(&pm_sleep_rwsem))
+		return 0;
+
+	return -EBUSY;
+}
+
+/**
+ *	pm_sleep_unlock - mutual exclusion for registration and suspend
+ *
+ *	This routine undoes the effect of device_pm_add_lock
+ *	when a device's registration is complete.
+ */
+void pm_sleep_unlock(void)
+{
+	up_read(&pm_sleep_rwsem);
 }
=20
=20
 /*------------------------- Resume routines -------------------------*=
/
=20
 /**
- *	resume_device - Restore state for one device.
+ *	resume_device_early - Power on one device (early resume).
  *	@dev:	Device.
  *
+ *	Must be called with interrupts disabled.
  */
-
-static int resume_device(struct device * dev)
+static int resume_device_early(struct device *dev)
 {
 	int error =3D 0;
=20
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
=20
-	down(&dev->sem);
+	if (dev->bus && dev->bus->resume_early) {
+		dev_dbg(dev,"EARLY resume\n");
+		error =3D dev->bus->resume_early(dev);
+	}
+
+	TRACE_RESUME(error);
+	return error;
+}
+
+/**
+ *	dpm_power_up - Power on all regular (non-sysdev) devices.
+ *
+ *	Walk the dpm_off_irq list and power each device up. This
+ *	is used for devices that required they be powered down with
+ *	interrupts disabled. As devices are powered on, they are moved
+ *	to the dpm_off list.
+ *
+ *	Must be called with interrupts disabled and only one CPU running.
+ */
+static void dpm_power_up(void)
+{
+
+	while (!list_empty(&dpm_off_irq)) {
+		struct list_head *entry =3D dpm_off_irq.next;
+		struct device *dev =3D to_device(entry);
+
+		list_move_tail(entry, &dpm_off);
+		resume_device_early(dev);
+	}
+}
+
+/**
+ *	device_power_up - Turn on all devices that need special attention.
+ *
+ *	Power on system devices, then devices that required we shut them do=
wn
+ *	with interrupts disabled.
+ *
+ *	Must be called with interrupts disabled.
+ */
+void device_power_up(void)
+{
+	sysdev_resume();
+	dpm_power_up();
+}
+EXPORT_SYMBOL_GPL(device_power_up);
+
+/**
+ *	resume_device - Restore state for one device.
+ *	@dev:	Device.
+ *
+ */
+static int resume_device(struct device *dev)
+{
+	int error =3D 0;
+
+	TRACE_DEVICE(dev);
+	TRACE_RESUME(0);
=20
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
@@ -92,126 +244,94 @@ static int resume_device(struct device *
 		error =3D dev->class->resume(dev);
 	}
=20
-	up(&dev->sem);
-
-	TRACE_RESUME(error);
-	return error;
-}
-
-
-static int resume_device_early(struct device * dev)
-{
-	int error =3D 0;
-
-	TRACE_DEVICE(dev);
-	TRACE_RESUME(0);
-	if (dev->bus && dev->bus->resume_early) {
-		dev_dbg(dev,"EARLY resume\n");
-		error =3D dev->bus->resume_early(dev);
-	}
 	TRACE_RESUME(error);
 	return error;
 }
=20
-/*
- * Resume the devices that have either not gone through
- * the late suspend, or that did go through it but also
- * went through the early resume
+/**
+ *	dpm_resume - Resume every device.
+ *
+ *	Resume the devices that have either not gone through
+ *	the late suspend, or that did go through it but also
+ *	went through the early resume.
+ *
+ *	Take devices from the dpm_off_list, resume them,
+ *	and put them on the dpm_locked list.
  */
 static void dpm_resume(void)
 {
 	mutex_lock(&dpm_list_mtx);
 	while(!list_empty(&dpm_off)) {
-		struct list_head * entry =3D dpm_off.next;
-		struct device * dev =3D to_device(entry);
-
-		get_device(dev);
-		list_move_tail(entry, &dpm_active);
+		struct list_head *entry =3D dpm_off.next;
+		struct device *dev =3D to_device(entry);
=20
+		list_move_tail(entry, &dpm_locked);
 		mutex_unlock(&dpm_list_mtx);
 		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
-		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
 }
=20
-
 /**
- *	device_resume - Restore state of each device in system.
+ *	unlock_all_devices - Release each device's semaphore
  *
- *	Walk the dpm_off list, remove each entry, resume the device,
- *	then add it to the dpm_active list.
+ *	Go through the dpm_off list.  Put each device on the dpm_active
+ *	list and unlock it.
  */
-
-void device_resume(void)
+static void unlock_all_devices(void)
 {
-	might_sleep();
-	mutex_lock(&dpm_mtx);
-	dpm_resume();
-	mutex_unlock(&dpm_mtx);
+	mutex_lock(&dpm_list_mtx);
+ 	while (!list_empty(&dpm_locked)) {
+ 		struct list_head *entry =3D dpm_locked.prev;
+ 		struct device *dev =3D to_device(entry);
+
+ 		list_move(entry, &dpm_active);
+ 		up(&dev->sem);
+ 	}
+	mutex_unlock(&dpm_list_mtx);
 }
=20
-EXPORT_SYMBOL_GPL(device_resume);
-
-
 /**
- *	dpm_power_up - Power on some devices.
- *
- *	Walk the dpm_off_irq list and power each device up. This
- *	is used for devices that required they be powered down with
- *	interrupts disabled. As devices are powered on, they are moved
- *	to the dpm_active list.
+ *	unregister_dropped_devices - Unregister devices scheduled for remov=
al
  *
- *	Interrupts must be disabled when calling this.
+ *	Unregister all devices on the dpm_destroy list.
  */
-
-static void dpm_power_up(void)
+static void unregister_dropped_devices(void)
 {
-	while(!list_empty(&dpm_off_irq)) {
-		struct list_head * entry =3D dpm_off_irq.next;
-		struct device * dev =3D to_device(entry);
+	mutex_lock(&dpm_list_mtx);
+	while (!list_empty(&dpm_destroy)) {
+		struct list_head *entry =3D dpm_destroy.next;
+		struct device *dev =3D to_device(entry);
=20
-		list_move_tail(entry, &dpm_off);
-		resume_device_early(dev);
+		up(&dev->sem);
+		mutex_unlock(&dpm_list_mtx);
+		/* This also removes the device from the list */
+		device_unregister(dev);
+		mutex_lock(&dpm_list_mtx);
 	}
+	mutex_unlock(&dpm_list_mtx);
 }
=20
-
 /**
- *	device_power_up - Turn on all devices that need special attention.
+ *	device_resume - Restore state of each device in system.
  *
- *	Power on system devices then devices that required we shut them dow=
n
- *	with interrupts disabled.
- *	Called with interrupts disabled.
+ *	Resume all the devices, unlock them all, and allow new
+ *	devices to be registered once again.
  */
-
-void device_power_up(void)
+void device_resume(void)
 {
-	sysdev_resume();
-	dpm_power_up();
+	might_sleep();
+	dpm_resume();
+	unlock_all_devices();
+	unregister_dropped_devices();
+	up_write(&pm_sleep_rwsem);
 }
-
-EXPORT_SYMBOL_GPL(device_power_up);
+EXPORT_SYMBOL_GPL(device_resume);
=20
=20
 /*------------------------- Suspend routines -------------------------=
*/
=20
-/*
- * The entries in the dpm_active list are in a depth first order, simp=
ly
- * because children are guaranteed to be discovered after parents, and
- * are inserted at the back of the list on discovery.
- *
- * All list on the suspend path are done in reverse order, so we opera=
te
- * on the leaves of the device tree (or forests, depending on how you =
want
- * to look at it ;) first. As nodes are removed from the back of the l=
ist,
- * they are inserted into the front of their destintation lists.
- *
- * Things are the reverse on the resume path - iterations are done in
- * forward order, and nodes are inserted at the back of their destinat=
ion
- * lists. This way, the ancestors will be accessed before their descen=
dents.
- */
-
 static inline char *suspend_verb(u32 event)
 {
 	switch (event) {
@@ -222,7 +342,6 @@ static inline char *suspend_verb(u32 eve
 	}
 }
=20
-
 static void
 suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
 {
@@ -232,16 +351,73 @@ suspend_device_dbg(struct device *dev, p
 }
=20
 /**
- *	suspend_device - Save state of one device.
+ *	suspend_device_late - Shut down one device (late suspend).
  *	@dev:	Device.
  *	@state:	Power state device is entering.
+ *
+ *	This is called with interrupts off and only a single CPU running.
  */
+static int suspend_device_late(struct device *dev, pm_message_t state)
+{
+	int error =3D 0;
=20
-static int suspend_device(struct device * dev, pm_message_t state)
+	if (dev->bus && dev->bus->suspend_late) {
+		suspend_device_dbg(dev, state, "LATE ");
+		error =3D dev->bus->suspend_late(dev, state);
+		suspend_report_result(dev->bus->suspend_late, error);
+	}
+	return error;
+}
+
+/**
+ *	device_power_down - Shut down special devices.
+ *	@state:		Power state to enter.
+ *
+ *	Power down devices that require interrupts to be disabled
+ *	and move them from the dpm_off list to the dpm_off_irq list.
+ *	Then power down system devices.
+ *
+ *	Must be called with interrupts disabled and only one CPU running.
+ */
+int device_power_down(pm_message_t state)
+{
+	int error =3D 0;
+
+	while (!list_empty(&dpm_off)) {
+		struct list_head *entry =3D dpm_off.prev;
+		struct device *dev =3D to_device(entry);
+
+		list_del_init(&dev->power.entry);
+		error =3D suspend_device_late(dev, state);
+		if (error) {
+			printk(KERN_ERR "Could not power down device %s: "
+					"error %d\n",
+					kobject_name(&dev->kobj), error);
+			if (list_empty(&dev->power.entry))
+				list_add(&dev->power.entry, &dpm_off);
+			break;
+		}
+		if (list_empty(&dev->power.entry))
+			list_add(&dev->power.entry, &dpm_off_irq);
+	}
+
+	if (!error)
+		error =3D sysdev_suspend(state);
+	if (error)
+		dpm_power_up();
+	return error;
+}
+EXPORT_SYMBOL_GPL(device_power_down);
+
+/**
+ *	suspend_device - Save state of one device.
+ *	@dev:	Device.
+ *	@state:	Power state device is entering.
+ */
+int suspend_device(struct device *dev, pm_message_t state)
 {
 	int error =3D 0;
=20
-	down(&dev->sem);
 	if (dev->power.power_state.event) {
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
@@ -264,123 +440,105 @@ static int suspend_device(struct device=20
 		error =3D dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
-	up(&dev->sem);
-	return error;
-}
-
-
-/*
- * This is called with interrupts off, only a single CPU
- * running. We can't acquire a mutex or semaphore (and we don't
- * need the protection)
- */
-static int suspend_device_late(struct device *dev, pm_message_t state)
-{
-	int error =3D 0;
-
-	if (dev->bus && dev->bus->suspend_late) {
-		suspend_device_dbg(dev, state, "LATE ");
-		error =3D dev->bus->suspend_late(dev, state);
-		suspend_report_result(dev->bus->suspend_late, error);
-	}
 	return error;
 }
=20
 /**
- *	device_suspend - Save state and stop all devices in system.
- *	@state:		Power state to put each device in.
+ *	dpm_suspend - Suspend every device.
+ *	@state:	Power state to put each device in.
  *
- *	Walk the dpm_active list, call ->suspend() for each device, and mov=
e
- *	it to the dpm_off list.
+ *	Walk the dpm_locked list.  Suspend each device and move it
+ *	to the dpm_off list.
  *
  *	(For historical reasons, if it returns -EAGAIN, that used to mean
  *	that the device would be called again with interrupts disabled.
  *	These days, we use the "suspend_late()" callback for that, so we
  *	print a warning and consider it an error).
- *
- *	If we get a different error, try and back out.
- *
- *	If we hit a failure with any of the devices, call device_resume()
- *	above to bring the suspended devices back to life.
- *
  */
-
-int device_suspend(pm_message_t state)
+static int dpm_suspend(pm_message_t state)
 {
 	int error =3D 0;
=20
-	might_sleep();
-	mutex_lock(&dpm_mtx);
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_active) && error =3D=3D 0) {
-		struct list_head * entry =3D dpm_active.prev;
-		struct device * dev =3D to_device(entry);
+	while (!list_empty(&dpm_locked)) {
+		struct list_head *entry =3D dpm_locked.prev;
+		struct device *dev =3D to_device(entry);
=20
-		get_device(dev);
+		list_del_init(&dev->power.entry);
 		mutex_unlock(&dpm_list_mtx);
-
 		error =3D suspend_device(dev, state);
-
-		mutex_lock(&dpm_list_mtx);
-
-		/* Check if the device got removed */
-		if (!list_empty(&dev->power.entry)) {
-			/* Move it to the dpm_off list */
-			if (!error)
-				list_move(&dev->power.entry, &dpm_off);
-		}
-		if (error)
+		if (error) {
 			printk(KERN_ERR "Could not suspend device %s: "
-				"error %d%s\n",
-				kobject_name(&dev->kobj), error,
-				error =3D=3D -EAGAIN ? " (please convert to suspend_late)" : "");
-		put_device(dev);
+					"error %d%s\n",
+					kobject_name(&dev->kobj),
+					error,
+					(error =3D=3D -EAGAIN ?
+					" (please convert to suspend_late)" :
+					""));
+			mutex_lock(&dpm_list_mtx);
+			if (list_empty(&dev->power.entry))
+				list_add(&dev->power.entry, &dpm_locked);
+			mutex_unlock(&dpm_list_mtx);
+			break;
+		}
+		mutex_lock(&dpm_list_mtx);
+		if (list_empty(&dev->power.entry))
+ 			list_add(&dev->power.entry, &dpm_off);
 	}
 	mutex_unlock(&dpm_list_mtx);
-	if (error)
-		dpm_resume();
=20
-	mutex_unlock(&dpm_mtx);
 	return error;
 }
=20
-EXPORT_SYMBOL_GPL(device_suspend);
-
 /**
- *	device_power_down - Shut down special devices.
- *	@state:		Power state to enter.
+ *	lock_all_devices - Acquire every device's semaphore
  *
- *	Walk the dpm_off_irq list, calling ->power_down() for each device t=
hat
- *	couldn't power down the device with interrupts enabled. When we're
- *	done, power down system devices.
+ *	Go through the dpm_active list. Carefully lock each device's
+ *	semaphore and put it in on the dpm_locked list.
  */
-
-int device_power_down(pm_message_t state)
+static void lock_all_devices(void)
 {
-	int error =3D 0;
-	struct device * dev;
-
-	while (!list_empty(&dpm_off)) {
-		struct list_head * entry =3D dpm_off.prev;
+	mutex_lock(&dpm_list_mtx);
+	while (!list_empty(&dpm_active)) {
+		struct list_head *entry =3D dpm_active.next;
+		struct device *dev =3D to_device(entry);
+
+		/* Required locking order is dev->sem first,
+		 * then dpm_list_mutex.  Hence this awkward code.
+		 */
+		get_device(dev);
+		mutex_unlock(&dpm_list_mtx);
+		down(&dev->sem);
+		mutex_lock(&dpm_list_mtx);
=20
-		dev =3D to_device(entry);
-		error =3D suspend_device_late(dev, state);
-		if (error)
-			goto Error;
-		list_move(&dev->power.entry, &dpm_off_irq);
+		if (list_empty(entry))
+			up(&dev->sem);		/* Device was removed */
+		else
+			list_move_tail(entry, &dpm_locked);
+		put_device(dev);
 	}
+	mutex_unlock(&dpm_list_mtx);
+}
+
+/**
+ *	device_suspend - Save state and stop all devices in system.
+ *
+ *	Prevent new devices from being registered, then lock all devices
+ *	and suspend them.
+ */
+int device_suspend(pm_message_t state)
+{
+	int error;
=20
-	error =3D sysdev_suspend(state);
- Done:
+	might_sleep();
+	down_write(&pm_sleep_rwsem);
+	lock_all_devices();
+	error =3D dpm_suspend(state);
+	if (error)
+		device_resume();
 	return error;
- Error:
-	printk(KERN_ERR "Could not power down device %s: "
-		"error %d\n", kobject_name(&dev->kobj), error);
-	dpm_power_up();
-	goto Done;
 }
-
-EXPORT_SYMBOL_GPL(device_power_down);
+EXPORT_SYMBOL_GPL(device_suspend);
=20
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
diff -puN drivers/base/power/power.h~pm-acquire-device-locks-on-suspend=
-rev-3 drivers/base/power/power.h
--- a/drivers/base/power/power.h~pm-acquire-device-locks-on-suspend-rev=
-3
+++ a/drivers/base/power/power.h
@@ -13,6 +13,9 @@ static inline struct device *to_device(s
=20
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
+extern void device_pm_schedule_removal(struct device *);
+extern int pm_sleep_lock(void);
+extern void pm_sleep_unlock(void);
=20
 #else /* CONFIG_PM_SLEEP */
=20
@@ -25,6 +28,15 @@ static inline void device_pm_remove(stru
 {
 }
=20
+static inline int pm_sleep_lock(void)
+{
+	return 0;
+}
+
+static inline void pm_sleep_unlock(void)
+{
+}
+
 #endif
=20
 #ifdef CONFIG_PM
diff -puN include/linux/device.h~pm-acquire-device-locks-on-suspend-rev=
-3 include/linux/device.h
--- a/include/linux/device.h~pm-acquire-device-locks-on-suspend-rev-3
+++ a/include/linux/device.h
@@ -518,6 +518,14 @@ extern struct device *device_create(stru
 				    dev_t devt, const char *fmt, ...)
 				    __attribute__((format(printf,4,5)));
 extern void device_destroy(struct class *cls, dev_t devt);
+#ifdef CONFIG_PM_SLEEP
+extern void destroy_suspended_device(struct class *cls, dev_t devt);
+#else /* !CONFIG_PM_SLEEP */
+static inline void destroy_suspended_device(struct class *cls, dev_t d=
evt)
+{
+	device_destroy(cls, devt);
+}
+#endif /* !CONFIG_PM_SLEEP */
=20
 /*
  * Platform "fixup" functions - allow the platform to have their say
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_perfor=
mance.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
pm-acquire-device-locks-on-suspend-rev-3.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-newsetup.patch
git-xfs.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
