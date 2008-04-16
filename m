From: akpm@linux-foundation.org
Subject: - pm-introduce-new-top-level-suspend-and-hibernation-callbacks.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:30 -0700
Message-ID: <200804162255.m3GMtUrL011128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbYDPW4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, lenb@kernel.org, pavel@ucw.cz, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     pm: introduce new top level suspend and hibernation callbacks
has been removed from the -mm tree.  Its filename was
     pm-introduce-new-top-level-suspend-and-hibernation-callbacks.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: pm: introduce new top level suspend and hibernation callbacks
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

Introduce 'struct pm_ops' and 'struct pm_ext_ops' ('ext' meaning 'exten=
ded')
representing suspend and hibernation operations for bus types, device c=
lasses,
device types and device drivers.

Modify the PM core to use 'struct pm_ops' and 'struct pm_ext_ops' objec=
ts, if
defined, instead of the ->suspend(), ->resume(), ->suspend_late(), and
->resume_early() callbacks (the old callbacks will be considered as leg=
acy and
gradually phased out).

The main purpose of doing this is to separate suspend (aka S2RAM and st=
andby)
callbacks from hibernation callbacks in such a way that the new callbac=
ks
won't take arguments and the semantics of each of them will be clearly
specified.  =A0This has been requested for multiple times by many peopl=
e,
including Linus himself, and the reason is that within the current sche=
me if
->resume() is called, for example, it's from hibernation or a
suspend/hibernation failure etc.?).

The second purpose is to make the suspend/hibernation callbacks more fl=
exible
so that device drivers can handle more than they can within the current
scheme.  For example, some drivers may need to prevent new children of =
the
device from being registered before their ->suspend() callbacks are exe=
cuted
or they may want to carry out some operations requiring the availabilit=
y of
some other devices, not directly bound via the parent-child relationshi=
p, in
order to prepare for the execution of ->suspend(), etc.

Ultimately, we'd like to stop using the freezing of tasks for suspend a=
nd
therefore the drivers' suspend/hibernation code will have to take care =
of the
handling of the user space during suspend/hibernation.  That, in turn, =
would
be difficult within the current scheme, without the new ->prepare() and
->complete() callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apm_32.c   |    8=20
 drivers/base/power/main.c  |  693 ++++++++++++++++++++++++++---------
 drivers/base/power/power.h |    2=20
 drivers/base/power/trace.c |    4=20
 include/linux/device.h     |    9=20
 include/linux/pm.h         |  314 ++++++++++++++-
 kernel/power/disk.c        |   20 -
 kernel/power/main.c        |    6=20
 8 files changed, 852 insertions(+), 204 deletions(-)

diff -puN arch/x86/kernel/apm_32.c~pm-introduce-new-top-level-suspend-a=
nd-hibernation-callbacks arch/x86/kernel/apm_32.c
--- a/arch/x86/kernel/apm_32.c~pm-introduce-new-top-level-suspend-and-h=
ibernation-callbacks
+++ a/arch/x86/kernel/apm_32.c
@@ -1208,9 +1208,9 @@ static int suspend(int vetoable)
 	if (err !=3D APM_SUCCESS)
 		apm_error("suspend", err);
 	err =3D (err =3D=3D APM_SUCCESS) ? 0 : -EIO;
-	device_power_up();
+	device_power_up(PMSG_RESUME);
 	local_irq_enable();
-	device_resume();
+	device_resume(PMSG_RESUME);
 	queue_event(APM_NORMAL_RESUME, NULL);
 	spin_lock(&user_list_lock);
 	for (as =3D user_list; as !=3D NULL; as =3D as->next) {
@@ -1235,7 +1235,7 @@ static void standby(void)
 		apm_error("standby", err);
=20
 	local_irq_disable();
-	device_power_up();
+	device_power_up(PMSG_RESUME);
 	local_irq_enable();
 }
=20
@@ -1321,7 +1321,7 @@ static void check_events(void)
 			ignore_bounce =3D 1;
 			if ((event !=3D APM_NORMAL_RESUME)
 			    || (ignore_normal_resume =3D=3D 0)) {
-				device_resume();
+				device_resume(PMSG_RESUME);
 				queue_event(event, NULL);
 			}
 			ignore_normal_resume =3D 0;
diff -puN drivers/base/power/main.c~pm-introduce-new-top-level-suspend-=
and-hibernation-callbacks drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-introduce-new-top-level-suspend-and-=
hibernation-callbacks
+++ a/drivers/base/power/main.c
@@ -12,11 +12,9 @@
  * and add it to the list of power-controlled devices. sysfs entries f=
or
  * controlling device power management will also be added.
  *
- * A different set of lists than the global subsystem list are used to
- * keep track of power info because we use different lists to hold
- * devices based on what stage of the power management process they
- * are in. The power domain dependencies may also differ from the
- * ancestral dependencies that the subsystem list maintains.
+ * A separate list is used for keeping track of power info, because th=
e power
+ * domain dependencies may differ from the ancestral dependencies that=
 the
+ * subsystem list maintains.
  */
=20
 #include <linux/device.h>
@@ -30,31 +28,40 @@
 #include "power.h"
=20
 /*
- * The entries in the dpm_active list are in a depth first order, simp=
ly
+ * The entries in the dpm_list list are in a depth first order, simply
  * because children are guaranteed to be discovered after parents, and
  * are inserted at the back of the list on discovery.
  *
- * All the other lists are kept in the same order, for consistency.
- * However the lists aren't always traversed in the same order.
- * Semaphores must be acquired from the top (i.e., front) down
- * and released in the opposite order.  Devices must be suspended
- * from the bottom (i.e., end) up and resumed in the opposite order.
- * That way no parent will be suspended while it still has an active
- * child.
- *
  * Since device_pm_add() may be called with a device semaphore held,
  * we must never try to acquire a device semaphore while holding
  * dpm_list_mutex.
  */
=20
-LIST_HEAD(dpm_active);
-static LIST_HEAD(dpm_off);
-static LIST_HEAD(dpm_off_irq);
+LIST_HEAD(dpm_list);
=20
 static DEFINE_MUTEX(dpm_list_mtx);
=20
-/* 'true' if all devices have been suspended, protected by dpm_list_mt=
x */
-static bool all_sleeping;
+/*
+ * Set once the preparation of devices for a PM transition has started=
, reset
+ * before starting to resume devices.  Protected by dpm_list_mtx.
+ */
+static bool transition_started;
+
+/**
+ *	device_pm_lock - lock the list of active devices used by the PM cor=
e
+ */
+void device_pm_lock(void)
+{
+	mutex_lock(&dpm_list_mtx);
+}
+
+/**
+ *	device_pm_unlock - unlock the list of active devices used by the PM=
 core
+ */
+void device_pm_unlock(void)
+{
+	mutex_unlock(&dpm_list_mtx);
+}
=20
 /**
  *	device_pm_add - add a device to the list of active devices
@@ -68,22 +75,32 @@ int device_pm_add(struct device *dev)
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
-	if ((dev->parent && dev->parent->power.sleeping) || all_sleeping) {
-		if (dev->parent->power.sleeping)
-			dev_warn(dev,
-				"parent %s is sleeping, will not add\n",
+	if (dev->parent) {
+		if (dev->parent->power.status >=3D DPM_SUSPENDING) {
+			dev_warn(dev, "parent %s is sleeping, will not add\n",
 				dev->parent->bus_id);
-		else
-			dev_warn(dev, "devices are sleeping, will not add\n");
-		WARN_ON(true);
-		error =3D -EBUSY;
-	} else {
-		error =3D dpm_sysfs_add(dev);
-		if (!error)
-			list_add_tail(&dev->power.entry, &dpm_active);
+			goto Refuse;
+		}
+	} else if (transition_started) {
+		/*
+		 * We refuse to register parentless devices while a PM
+		 * transition is in progress in order to avoid leaving them
+		 * unhandled down the road
+		 */
+		goto Refuse;
+	}
+	error =3D dpm_sysfs_add(dev);
+	if (!error) {
+		dev->power.status =3D DPM_ON;
+		list_add_tail(&dev->power.entry, &dpm_list);
 	}
+ End:
 	mutex_unlock(&dpm_list_mtx);
 	return error;
+ Refuse:
+	WARN_ON(true);
+	error =3D -EBUSY;
+	goto End;
 }
=20
 /**
@@ -103,73 +120,241 @@ void device_pm_remove(struct device *dev
 	mutex_unlock(&dpm_list_mtx);
 }
=20
+/**
+ *	pm_op - execute the PM operation appropiate for given PM event
+ *	@dev:	Device.
+ *	@ops:	PM operations to choose from.
+ *	@state:	PM transition of the system being carried out.
+ */
+static int pm_op(struct device *dev, struct pm_ops *ops, pm_message_t =
state)
+{
+	int error =3D 0;
+
+	switch (state.event) {
+#ifdef CONFIG_SUSPEND
+	case PM_EVENT_SUSPEND:
+		if (ops->suspend) {
+			error =3D ops->suspend(dev);
+			suspend_report_result(ops->suspend, error);
+		}
+		break;
+	case PM_EVENT_RESUME:
+		if (ops->resume) {
+			error =3D ops->resume(dev);
+			suspend_report_result(ops->resume, error);
+		}
+		break;
+#endif /* CONFIG_SUSPEND */
+#ifdef CONFIG_HIBERNATION
+	case PM_EVENT_FREEZE:
+	case PM_EVENT_QUIESCE:
+		if (ops->freeze) {
+			error =3D ops->freeze(dev);
+			suspend_report_result(ops->freeze, error);
+		}
+		break;
+	case PM_EVENT_HIBERNATE:
+		if (ops->poweroff) {
+			error =3D ops->poweroff(dev);
+			suspend_report_result(ops->poweroff, error);
+		}
+		break;
+	case PM_EVENT_THAW:
+	case PM_EVENT_RECOVER:
+		if (ops->thaw) {
+			error =3D ops->thaw(dev);
+			suspend_report_result(ops->thaw, error);
+		}
+		break;
+	case PM_EVENT_RESTORE:
+		if (ops->restore) {
+			error =3D ops->restore(dev);
+			suspend_report_result(ops->restore, error);
+		}
+		break;
+#endif /* CONFIG_HIBERNATION */
+	default:
+		error =3D -EINVAL;
+	}
+	return error;
+}
+
+/**
+ *	pm_noirq_op - execute the PM operation appropiate for given PM even=
t
+ *	@dev:	Device.
+ *	@ops:	PM operations to choose from.
+ *	@state: PM transition of the system being carried out.
+ *
+ *	The operation is executed with interrupts disabled by the only rema=
ining
+ *	functional CPU in the system.
+ */
+static int pm_noirq_op(struct device *dev, struct pm_ext_ops *ops,
+			pm_message_t state)
+{
+	int error =3D 0;
+
+	switch (state.event) {
+#ifdef CONFIG_SUSPEND
+	case PM_EVENT_SUSPEND:
+		if (ops->suspend_noirq) {
+			error =3D ops->suspend_noirq(dev);
+			suspend_report_result(ops->suspend_noirq, error);
+		}
+		break;
+	case PM_EVENT_RESUME:
+		if (ops->resume_noirq) {
+			error =3D ops->resume_noirq(dev);
+			suspend_report_result(ops->resume_noirq, error);
+		}
+		break;
+#endif /* CONFIG_SUSPEND */
+#ifdef CONFIG_HIBERNATION
+	case PM_EVENT_FREEZE:
+	case PM_EVENT_QUIESCE:
+		if (ops->freeze_noirq) {
+			error =3D ops->freeze_noirq(dev);
+			suspend_report_result(ops->freeze_noirq, error);
+		}
+		break;
+	case PM_EVENT_HIBERNATE:
+		if (ops->poweroff_noirq) {
+			error =3D ops->poweroff_noirq(dev);
+			suspend_report_result(ops->poweroff_noirq, error);
+		}
+		break;
+	case PM_EVENT_THAW:
+	case PM_EVENT_RECOVER:
+		if (ops->thaw_noirq) {
+			error =3D ops->thaw_noirq(dev);
+			suspend_report_result(ops->thaw_noirq, error);
+		}
+		break;
+	case PM_EVENT_RESTORE:
+		if (ops->restore_noirq) {
+			error =3D ops->restore_noirq(dev);
+			suspend_report_result(ops->restore_noirq, error);
+		}
+		break;
+#endif /* CONFIG_HIBERNATION */
+	default:
+		error =3D -EINVAL;
+	}
+	return error;
+}
+
+static char *pm_verb(int event)
+{
+	switch (event) {
+	case PM_EVENT_SUSPEND:
+		return "suspend";
+	case PM_EVENT_RESUME:
+		return "resume";
+	case PM_EVENT_FREEZE:
+		return "freeze";
+	case PM_EVENT_QUIESCE:
+		return "quiesce";
+	case PM_EVENT_HIBERNATE:
+		return "hibernate";
+	case PM_EVENT_THAW:
+		return "thaw";
+	case PM_EVENT_RESTORE:
+		return "restore";
+	default:
+		return "(unknown PM event)";
+	}
+}
+
+static void pm_dev_dbg(struct device *dev, pm_message_t state, char *i=
nfo)
+{
+	dev_dbg(dev, "%s%s%s\n", info, pm_verb(state.event),
+		((state.event & PM_EVENT_SLEEP) && device_may_wakeup(dev)) ?
+		", may wakeup" : "");
+}
+
+static void pm_dev_err(struct device *dev, pm_message_t state, char *i=
nfo,
+			int error)
+{
+	printk(KERN_ERR "PM: Device %s failed to %s%s: error %d\n",
+		kobject_name(&dev->kobj), pm_verb(state.event), info, error);
+}
+
 /*------------------------- Resume routines -------------------------*=
/
=20
 /**
- *	resume_device_early - Power on one device (early resume).
+ *	resume_device_noirq - Power on one device (early resume).
  *	@dev:	Device.
+ *	@state: PM transition of the system being carried out.
  *
  *	Must be called with interrupts disabled.
  */
-static int resume_device_early(struct device *dev)
+static int resume_device_noirq(struct device *dev, pm_message_t state)
 {
 	int error =3D 0;
=20
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
=20
-	if (dev->bus && dev->bus->resume_early) {
-		dev_dbg(dev, "EARLY resume\n");
+	if (!dev->bus)
+		goto End;
+
+	if (dev->bus->pm) {
+		pm_dev_dbg(dev, state, "EARLY ");
+		error =3D pm_noirq_op(dev, dev->bus->pm, state);
+	} else if (dev->bus->resume_early) {
+		pm_dev_dbg(dev, state, "legacy EARLY ");
 		error =3D dev->bus->resume_early(dev);
 	}
-
+ End:
 	TRACE_RESUME(error);
 	return error;
 }
=20
 /**
  *	dpm_power_up - Power on all regular (non-sysdev) devices.
+ *	@state: PM transition of the system being carried out.
  *
- *	Walk the dpm_off_irq list and power each device up. This
- *	is used for devices that required they be powered down with
- *	interrupts disabled. As devices are powered on, they are moved
- *	to the dpm_off list.
+ *	Execute the appropriate "noirq resume" callback for all devices mar=
ked
+ *	as DPM_OFF_IRQ.
  *
  *	Must be called with interrupts disabled and only one CPU running.
  */
-static void dpm_power_up(void)
+static void dpm_power_up(pm_message_t state)
 {
+	struct device *dev;
=20
-	while (!list_empty(&dpm_off_irq)) {
-		struct list_head *entry =3D dpm_off_irq.next;
-		struct device *dev =3D to_device(entry);
-
-		list_move_tail(entry, &dpm_off);
-		resume_device_early(dev);
-	}
+	list_for_each_entry(dev, &dpm_list, power.entry)
+		if (dev->power.status > DPM_OFF) {
+			int error;
+
+			dev->power.status =3D DPM_OFF;
+			error =3D resume_device_noirq(dev, state);
+			if (error)
+				pm_dev_err(dev, state, " early", error);
+		}
 }
=20
 /**
  *	device_power_up - Turn on all devices that need special attention.
+ *	@state: PM transition of the system being carried out.
  *
  *	Power on system devices, then devices that required we shut them do=
wn
  *	with interrupts disabled.
  *
  *	Must be called with interrupts disabled.
  */
-void device_power_up(void)
+void device_power_up(pm_message_t state)
 {
 	sysdev_resume();
-	dpm_power_up();
+	dpm_power_up(state);
 }
 EXPORT_SYMBOL_GPL(device_power_up);
=20
 /**
  *	resume_device - Restore state for one device.
  *	@dev:	Device.
- *
+ *	@state: PM transition of the system being carried out.
  */
-static int resume_device(struct device *dev)
+static int resume_device(struct device *dev, pm_message_t state)
 {
 	int error =3D 0;
=20
@@ -178,21 +363,40 @@ static int resume_device(struct device *
=20
 	down(&dev->sem);
=20
-	if (dev->bus && dev->bus->resume) {
-		dev_dbg(dev,"resuming\n");
-		error =3D dev->bus->resume(dev);
+	if (dev->bus) {
+		if (dev->bus->pm) {
+			pm_dev_dbg(dev, state, "");
+			error =3D pm_op(dev, &dev->bus->pm->base, state);
+		} else if (dev->bus->resume) {
+			pm_dev_dbg(dev, state, "legacy ");
+			error =3D dev->bus->resume(dev);
+		}
+		if (error)
+			goto End;
 	}
=20
-	if (!error && dev->type && dev->type->resume) {
-		dev_dbg(dev,"resuming\n");
-		error =3D dev->type->resume(dev);
+	if (dev->type) {
+		if (dev->type->pm) {
+			pm_dev_dbg(dev, state, "type ");
+			error =3D pm_op(dev, dev->type->pm, state);
+		} else if (dev->type->resume) {
+			pm_dev_dbg(dev, state, "legacy type ");
+			error =3D dev->type->resume(dev);
+		}
+		if (error)
+			goto End;
 	}
=20
-	if (!error && dev->class && dev->class->resume) {
-		dev_dbg(dev,"class resume\n");
-		error =3D dev->class->resume(dev);
+	if (dev->class) {
+		if (dev->class->pm) {
+			pm_dev_dbg(dev, state, "class ");
+			error =3D pm_op(dev, dev->class->pm, state);
+		} else if (dev->class->resume) {
+			pm_dev_dbg(dev, state, "legacy class ");
+			error =3D dev->class->resume(dev);
+		}
 	}
-
+ End:
 	up(&dev->sem);
=20
 	TRACE_RESUME(error);
@@ -201,78 +405,161 @@ static int resume_device(struct device *
=20
 /**
  *	dpm_resume - Resume every device.
+ *	@state: PM transition of the system being carried out.
  *
- *	Resume the devices that have either not gone through
- *	the late suspend, or that did go through it but also
- *	went through the early resume.
+ *	Execute the appropriate "resume" callback for all devices the statu=
s of
+ *	which indicates that they are inactive.
+ */
+static void dpm_resume(pm_message_t state)
+{
+	struct list_head list;
+
+	INIT_LIST_HEAD(&list);
+	mutex_lock(&dpm_list_mtx);
+	transition_started =3D false;
+	while (!list_empty(&dpm_list)) {
+		struct device *dev =3D to_device(dpm_list.next);
+
+		get_device(dev);
+		if (dev->power.status >=3D DPM_OFF) {
+			int error;
+
+			dev->power.status =3D DPM_RESUMING;
+			mutex_unlock(&dpm_list_mtx);
+
+			error =3D resume_device(dev, state);
+
+			mutex_lock(&dpm_list_mtx);
+			if (error)
+				pm_dev_err(dev, state, "", error);
+		} else if (dev->power.status =3D=3D DPM_SUSPENDING) {
+			/* Allow new children of the device to be registered */
+			dev->power.status =3D DPM_RESUMING;
+		}
+		if (!list_empty(&dev->power.entry))
+			list_move_tail(&dev->power.entry, &list);
+		put_device(dev);
+	}
+	list_splice(&list, &dpm_list);
+	mutex_unlock(&dpm_list_mtx);
+}
+
+/**
+ *	complete_device - Complete a PM transition for given device
+ *	@dev:	Device.
+ *	@state: PM transition of the system being carried out.
+ */
+static void complete_device(struct device *dev, pm_message_t state)
+{
+	down(&dev->sem);
+
+	if (dev->class && dev->class->pm && dev->class->pm->complete) {
+		pm_dev_dbg(dev, state, "completing class ");
+		dev->class->pm->complete(dev);
+	}
+
+	if (dev->type && dev->type->pm && dev->type->pm->complete) {
+		pm_dev_dbg(dev, state, "completing type ");
+		dev->type->pm->complete(dev);
+	}
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->base.complete) {
+		pm_dev_dbg(dev, state, "completing ");
+		dev->bus->pm->base.complete(dev);
+	}
+
+	up(&dev->sem);
+}
+
+/**
+ *	dpm_complete - Complete a PM transition for all devices.
+ *	@state: PM transition of the system being carried out.
  *
- *	Take devices from the dpm_off_list, resume them,
- *	and put them on the dpm_locked list.
+ *	Execute the ->complete() callbacks for all devices that are not mar=
ked
+ *	as DPM_ON.
  */
-static void dpm_resume(void)
+static void dpm_complete(pm_message_t state)
 {
+	struct list_head list;
+
+	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
-	all_sleeping =3D false;
-	while(!list_empty(&dpm_off)) {
-		struct list_head *entry =3D dpm_off.next;
-		struct device *dev =3D to_device(entry);
+	while (!list_empty(&dpm_list)) {
+		struct device *dev =3D to_device(dpm_list.prev);
=20
-		list_move_tail(entry, &dpm_active);
-		dev->power.sleeping =3D false;
-		mutex_unlock(&dpm_list_mtx);
-		resume_device(dev);
-		mutex_lock(&dpm_list_mtx);
+		get_device(dev);
+		if (dev->power.status > DPM_ON) {
+			dev->power.status =3D DPM_ON;
+			mutex_unlock(&dpm_list_mtx);
+
+			complete_device(dev, state);
+
+			mutex_lock(&dpm_list_mtx);
+		}
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &list);
+		put_device(dev);
 	}
+	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 }
=20
 /**
  *	device_resume - Restore state of each device in system.
+ *	@state: PM transition of the system being carried out.
  *
  *	Resume all the devices, unlock them all, and allow new
  *	devices to be registered once again.
  */
-void device_resume(void)
+void device_resume(pm_message_t state)
 {
 	might_sleep();
-	dpm_resume();
+	dpm_resume(state);
+	dpm_complete(state);
 }
 EXPORT_SYMBOL_GPL(device_resume);
=20
=20
 /*------------------------- Suspend routines -------------------------=
*/
=20
-static inline char *suspend_verb(u32 event)
+/**
+ *	resume_event - return a PM message representing the resume event
+ *	               corresponding to given sleep state.
+ *	@sleep_state: PM message representing a sleep state.
+ */
+static pm_message_t resume_event(pm_message_t sleep_state)
 {
-	switch (event) {
-	case PM_EVENT_SUSPEND:	return "suspend";
-	case PM_EVENT_FREEZE:	return "freeze";
-	case PM_EVENT_PRETHAW:	return "prethaw";
-	default:		return "(unknown suspend event)";
+	switch (sleep_state.event) {
+	case PM_EVENT_SUSPEND:
+		return PMSG_RESUME;
+	case PM_EVENT_FREEZE:
+	case PM_EVENT_QUIESCE:
+		return PMSG_RECOVER;
+	case PM_EVENT_HIBERNATE:
+		return PMSG_RESTORE;
 	}
-}
-
-static void
-suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
-{
-	dev_dbg(dev, "%s%s%s\n", info, suspend_verb(state.event),
-		((state.event =3D=3D PM_EVENT_SUSPEND) && device_may_wakeup(dev)) ?
-		", may wakeup" : "");
+	return PMSG_ON;
 }
=20
 /**
- *	suspend_device_late - Shut down one device (late suspend).
+ *	suspend_device_noirq - Shut down one device (late suspend).
  *	@dev:	Device.
- *	@state:	Power state device is entering.
+ *	@state: PM transition of the system being carried out.
  *
  *	This is called with interrupts off and only a single CPU running.
  */
-static int suspend_device_late(struct device *dev, pm_message_t state)
+static int suspend_device_noirq(struct device *dev, pm_message_t state=
)
 {
 	int error =3D 0;
=20
-	if (dev->bus && dev->bus->suspend_late) {
-		suspend_device_dbg(dev, state, "LATE ");
+	if (!dev->bus)
+		return 0;
+
+	if (dev->bus->pm) {
+		pm_dev_dbg(dev, state, "LATE ");
+		error =3D pm_noirq_op(dev, dev->bus->pm, state);
+	} else if (dev->bus->suspend_late) {
+		pm_dev_dbg(dev, state, "legacy LATE ");
 		error =3D dev->bus->suspend_late(dev, state);
 		suspend_report_result(dev->bus->suspend_late, error);
 	}
@@ -281,37 +568,30 @@ static int suspend_device_late(struct de
=20
 /**
  *	device_power_down - Shut down special devices.
- *	@state:		Power state to enter.
+ *	@state: PM transition of the system being carried out.
  *
- *	Power down devices that require interrupts to be disabled
- *	and move them from the dpm_off list to the dpm_off_irq list.
+ *	Power down devices that require interrupts to be disabled.
  *	Then power down system devices.
  *
  *	Must be called with interrupts disabled and only one CPU running.
  */
 int device_power_down(pm_message_t state)
 {
+	struct device *dev;
 	int error =3D 0;
=20
-	while (!list_empty(&dpm_off)) {
-		struct list_head *entry =3D dpm_off.prev;
-		struct device *dev =3D to_device(entry);
-
-		error =3D suspend_device_late(dev, state);
+	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
+		error =3D suspend_device_noirq(dev, state);
 		if (error) {
-			printk(KERN_ERR "Could not power down device %s: "
-					"error %d\n",
-					kobject_name(&dev->kobj), error);
+			pm_dev_err(dev, state, " late", error);
 			break;
 		}
-		if (!list_empty(&dev->power.entry))
-			list_move(&dev->power.entry, &dpm_off_irq);
+		dev->power.status =3D DPM_OFF_IRQ;
 	}
-
 	if (!error)
 		error =3D sysdev_suspend(state);
 	if (error)
-		dpm_power_up();
+		dpm_power_up(resume_event(state));
 	return error;
 }
 EXPORT_SYMBOL_GPL(device_power_down);
@@ -319,7 +599,7 @@ EXPORT_SYMBOL_GPL(device_power_down);
 /**
  *	suspend_device - Save state of one device.
  *	@dev:	Device.
- *	@state:	Power state device is entering.
+ *	@state: PM transition of the system being carried out.
  */
 static int suspend_device(struct device *dev, pm_message_t state)
 {
@@ -327,24 +607,43 @@ static int suspend_device(struct device=20
=20
 	down(&dev->sem);
=20
-	if (dev->class && dev->class->suspend) {
-		suspend_device_dbg(dev, state, "class ");
-		error =3D dev->class->suspend(dev, state);
-		suspend_report_result(dev->class->suspend, error);
-	}
-
-	if (!error && dev->type && dev->type->suspend) {
-		suspend_device_dbg(dev, state, "type ");
-		error =3D dev->type->suspend(dev, state);
-		suspend_report_result(dev->type->suspend, error);
-	}
-
-	if (!error && dev->bus && dev->bus->suspend) {
-		suspend_device_dbg(dev, state, "");
-		error =3D dev->bus->suspend(dev, state);
-		suspend_report_result(dev->bus->suspend, error);
+	if (dev->class) {
+		if (dev->class->pm) {
+			pm_dev_dbg(dev, state, "class ");
+			error =3D pm_op(dev, dev->class->pm, state);
+		} else if (dev->class->suspend) {
+			pm_dev_dbg(dev, state, "legacy class ");
+			error =3D dev->class->suspend(dev, state);
+			suspend_report_result(dev->class->suspend, error);
+		}
+		if (error)
+			goto End;
+	}
+
+	if (dev->type) {
+		if (dev->type->pm) {
+			pm_dev_dbg(dev, state, "type ");
+			error =3D pm_op(dev, dev->type->pm, state);
+		} else if (dev->type->suspend) {
+			pm_dev_dbg(dev, state, "legacy type ");
+			error =3D dev->type->suspend(dev, state);
+			suspend_report_result(dev->type->suspend, error);
+		}
+		if (error)
+			goto End;
 	}
=20
+	if (dev->bus) {
+		if (dev->bus->pm) {
+			pm_dev_dbg(dev, state, "");
+			error =3D pm_op(dev, &dev->bus->pm->base, state);
+		} else if (dev->bus->suspend) {
+			pm_dev_dbg(dev, state, "legacy ");
+			error =3D dev->bus->suspend(dev, state);
+			suspend_report_result(dev->bus->suspend, error);
+		}
+	}
+ End:
 	up(&dev->sem);
=20
 	return error;
@@ -352,67 +651,141 @@ static int suspend_device(struct device=20
=20
 /**
  *	dpm_suspend - Suspend every device.
- *	@state:	Power state to put each device in.
+ *	@state: PM transition of the system being carried out.
  *
- *	Walk the dpm_locked list.  Suspend each device and move it
- *	to the dpm_off list.
- *
- *	(For historical reasons, if it returns -EAGAIN, that used to mean
- *	that the device would be called again with interrupts disabled.
- *	These days, we use the "suspend_late()" callback for that, so we
- *	print a warning and consider it an error).
+ *	Execute the appropriate "suspend" callbacks for all devices.
  */
 static int dpm_suspend(pm_message_t state)
 {
+	struct list_head list;
 	int error =3D 0;
=20
+	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_active)) {
-		struct list_head *entry =3D dpm_active.prev;
-		struct device *dev =3D to_device(entry);
-
-		WARN_ON(dev->parent && dev->parent->power.sleeping);
+	while (!list_empty(&dpm_list)) {
+		struct device *dev =3D to_device(dpm_list.prev);
=20
-		dev->power.sleeping =3D true;
+		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
+
 		error =3D suspend_device(dev, state);
+
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
-			printk(KERN_ERR "Could not suspend device %s: "
-					"error %d%s\n",
-					kobject_name(&dev->kobj),
-					error,
-					(error =3D=3D -EAGAIN ?
-					" (please convert to suspend_late)" :
-					""));
-			dev->power.sleeping =3D false;
+			pm_dev_err(dev, state, "", error);
+			put_device(dev);
 			break;
 		}
+		dev->power.status =3D DPM_OFF;
 		if (!list_empty(&dev->power.entry))
-			list_move(&dev->power.entry, &dpm_off);
+			list_move(&dev->power.entry, &list);
+		put_device(dev);
 	}
-	if (!error)
-		all_sleeping =3D true;
+	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
+	return error;
+}
+
+/**
+ *	prepare_device - Execute the ->prepare() callback(s) for given devi=
ce.
+ *	@dev:	Device.
+ *	@state: PM transition of the system being carried out.
+ */
+static int prepare_device(struct device *dev, pm_message_t state)
+{
+	int error =3D 0;
+
+	down(&dev->sem);
+
+	if (dev->bus && dev->bus->pm && dev->bus->pm->base.prepare) {
+		pm_dev_dbg(dev, state, "preparing ");
+		error =3D dev->bus->pm->base.prepare(dev);
+		suspend_report_result(dev->bus->pm->base.prepare, error);
+		if (error)
+			goto End;
+	}
+
+	if (dev->type && dev->type->pm && dev->type->pm->prepare) {
+		pm_dev_dbg(dev, state, "preparing type ");
+		error =3D dev->type->pm->prepare(dev);
+		suspend_report_result(dev->type->pm->prepare, error);
+		if (error)
+			goto End;
+	}
+
+	if (dev->class && dev->class->pm && dev->class->pm->prepare) {
+		pm_dev_dbg(dev, state, "preparing class ");
+		error =3D dev->class->pm->prepare(dev);
+		suspend_report_result(dev->class->pm->prepare, error);
+	}
+ End:
+	up(&dev->sem);
+
+	return error;
+}
+
+/**
+ *	dpm_prepare - Prepare all devices for a PM transition.
+ *	@state: PM transition of the system being carried out.
+ *
+ *	Execute the ->prepare() callback for all devices.
+ */
+static int dpm_prepare(pm_message_t state)
+{
+	struct list_head list;
+	int error =3D 0;
+
+	INIT_LIST_HEAD(&list);
+	mutex_lock(&dpm_list_mtx);
+	transition_started =3D true;
+	while (!list_empty(&dpm_list)) {
+		struct device *dev =3D to_device(dpm_list.next);
+
+		get_device(dev);
+		dev->power.status =3D DPM_PREPARING;
+		mutex_unlock(&dpm_list_mtx);
+
+		error =3D prepare_device(dev, state);
=20
+		mutex_lock(&dpm_list_mtx);
+		if (error) {
+			dev->power.status =3D DPM_ON;
+			if (error =3D=3D -EAGAIN) {
+				put_device(dev);
+				continue;
+			}
+			printk(KERN_ERR "PM: Failed to prepare device %s "
+				"for power transition: error %d\n",
+				kobject_name(&dev->kobj), error);
+			put_device(dev);
+			break;
+		}
+		dev->power.status =3D DPM_SUSPENDING;
+		if (!list_empty(&dev->power.entry))
+			list_move_tail(&dev->power.entry, &list);
+		put_device(dev);
+	}
+	list_splice(&list, &dpm_list);
+	mutex_unlock(&dpm_list_mtx);
 	return error;
 }
=20
 /**
  *	device_suspend - Save state and stop all devices in system.
- *	@state: new power management state
+ *	@state: PM transition of the system being carried out.
  *
- *	Prevent new devices from being registered, then lock all devices
- *	and suspend them.
+ *	Prepare and suspend all devices.
  */
 int device_suspend(pm_message_t state)
 {
 	int error;
=20
 	might_sleep();
-	error =3D dpm_suspend(state);
+	error =3D dpm_prepare(state);
+	if (!error)
+		error =3D dpm_suspend(state);
 	if (error)
-		device_resume();
+		device_resume(resume_event(state));
 	return error;
 }
 EXPORT_SYMBOL_GPL(device_suspend);
diff -puN drivers/base/power/power.h~pm-introduce-new-top-level-suspend=
-and-hibernation-callbacks drivers/base/power/power.h
--- a/drivers/base/power/power.h~pm-introduce-new-top-level-suspend-and=
-hibernation-callbacks
+++ a/drivers/base/power/power.h
@@ -4,7 +4,7 @@
  * main.c
  */
=20
-extern struct list_head dpm_active;	/* The active device list */
+extern struct list_head dpm_list;	/* The active device list */
=20
 static inline struct device *to_device(struct list_head *entry)
 {
diff -puN drivers/base/power/trace.c~pm-introduce-new-top-level-suspend=
-and-hibernation-callbacks drivers/base/power/trace.c
--- a/drivers/base/power/trace.c~pm-introduce-new-top-level-suspend-and=
-hibernation-callbacks
+++ a/drivers/base/power/trace.c
@@ -188,9 +188,9 @@ static int show_file_hash(unsigned int v
 static int show_dev_hash(unsigned int value)
 {
 	int match =3D 0;
-	struct list_head * entry =3D dpm_active.prev;
+	struct list_head *entry =3D dpm_list.prev;
=20
-	while (entry !=3D &dpm_active) {
+	while (entry !=3D &dpm_list) {
 		struct device * dev =3D to_device(entry);
 		unsigned int hash =3D hash_string(DEVSEED, dev->bus_id, DEVHASH);
 		if (hash =3D=3D value) {
diff -puN include/linux/device.h~pm-introduce-new-top-level-suspend-and=
-hibernation-callbacks include/linux/device.h
--- a/include/linux/device.h~pm-introduce-new-top-level-suspend-and-hib=
ernation-callbacks
+++ a/include/linux/device.h
@@ -69,6 +69,8 @@ struct bus_type {
 	int (*resume_early)(struct device *dev);
 	int (*resume)(struct device *dev);
=20
+	struct pm_ext_ops *pm;
+
 	struct bus_type_private *p;
 };
=20
@@ -132,6 +134,8 @@ struct device_driver {
 	int (*resume) (struct device *dev);
 	struct attribute_group **groups;
=20
+	struct pm_ops *pm;
+
 	struct driver_private *p;
 };
=20
@@ -202,6 +206,8 @@ struct class {
=20
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
+
+	struct pm_ops *pm;
 };
=20
 extern int __must_check class_register(struct class *class);
@@ -345,8 +351,11 @@ struct device_type {
 	struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
 	void (*release)(struct device *dev);
+
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
+
+	struct pm_ops *pm;
 };
=20
 /* interface for exporting device attributes */
diff -puN include/linux/pm.h~pm-introduce-new-top-level-suspend-and-hib=
ernation-callbacks include/linux/pm.h
--- a/include/linux/pm.h~pm-introduce-new-top-level-suspend-and-hiberna=
tion-callbacks
+++ a/include/linux/pm.h
@@ -114,7 +114,9 @@ typedef struct pm_message {
 	int event;
 } pm_message_t;
=20
-/*
+/**
+ * struct pm_ops - device PM callbacks
+ *
  * Several driver power state transitions are externally visible, affe=
cting
  * the state of pending I/O queues and (for drivers that touch hardwar=
e)
  * interrupts, wakeups, DMA, and other hardware state.  There may also=
 be
@@ -122,6 +124,284 @@ typedef struct pm_message {
  * to the rest of the driver stack (such as a driver that's ON gating =
off
  * clocks which are not in active use).
  *
+ * The externally visible transitions are handled with the help of the=
 following
+ * callbacks included in this structure:
+ *
+ * @prepare: Prepare the device for the upcoming transition, but do NO=
T change
+ *	its hardware state.  Prevent new children of the device from being
+ *	registered after @prepare() returns (the driver's subsystem and
+ *	generally the rest of the kernel is supposed to prevent new calls t=
o the
+ *	probe method from being made too once @prepare() has succeeded).  I=
f
+ *	@prepare() detects a situation it cannot handle (e.g. registration =
of a
+ *	child already in progress), it may return -EAGAIN, so that the PM c=
ore
+ *	can execute it once again (e.g. after the new child has been regist=
ered)
+ *	to recover from the race condition.  This method is executed for al=
l
+ *	kinds of suspend transitions and is followed by one of the suspend
+ *	callbacks: @suspend(), @freeze(), or @poweroff().
+ *	The PM core executes @prepare() for all devices before starting to
+ *	execute suspend callbacks for any of them, so drivers may assume al=
l of
+ *	the other devices to be present and functional while @prepare() is =
being
+ *	executed.  In particular, it is safe to make GFP_KERNEL memory
+ *	allocations from within @prepare().  However, drivers may NOT assum=
e
+ *	anything about the availability of the user space at that time and =
it
+ *	is not correct to request firmware from within @prepare() (it's too
+ *	late to do that).  [To work around this limitation, drivers may
+ *	register suspend and hibernation notifiers that are executed before=
 the
+ *	freezing of tasks.]
+ *
+ * @complete: Undo the changes made by @prepare().  This method is exe=
cuted for
+ *	all kinds of resume transitions, following one of the resume callba=
cks:
+ *	@resume(), @thaw(), @restore().  Also called if the state transitio=
n
+ *	fails before the driver's suspend callback (@suspend(), @freeze(),
+ *	@poweroff()) can be executed (e.g. if the suspend callback fails fo=
r one
+ *	of the other devices that the PM core has unsuccessfully attempted =
to
+ *	suspend earlier).
+ *	The PM core executes @complete() after it has executed the appropri=
ate
+ *	resume callback for all devices.
+ *
+ * @suspend: Executed before putting the system into a sleep state in =
which the
+ *	contents of main memory are preserved.  Quiesce the device, put it =
into
+ *	a low power state appropriate for the upcoming system state (such a=
s
+ *	PCI_D3hot), and enable wakeup events as appropriate.
+ *
+ * @resume: Executed after waking the system up from a sleep state in =
which the
+ *	contents of main memory were preserved.  Put the device into the
+ *	appropriate state, according to the information saved in memory by =
the
+ *	preceding @suspend().  The driver starts working again, responding =
to
+ *	hardware events and software requests.  The hardware may have gone
+ *	through a power-off reset, or it may have maintained state from the
+ *	previous suspend() which the driver may rely on while resuming.  On=
 most
+ *	platforms, there are no restrictions on availability of resources l=
ike
+ *	clocks during @resume().
+ *
+ * @freeze: Hibernation-specific, executed before creating a hibernati=
on image.
+ *	Quiesce operations so that a consistent image can be created, but d=
o NOT
+ *	otherwise put the device into a low power device state and do NOT e=
mit
+ *	system wakeup events.  Save in main memory the device settings to b=
e
+ *	used by @restore() during the subsequent resume from hibernation or=
 by
+ *	the subsequent @thaw(), if the creation of the image or the restora=
tion
+ *	of main memory contents from it fails.
+ *
+ * @thaw: Hibernation-specific, executed after creating a hibernation =
image OR
+ *	if the creation of the image fails.  Also executed after a failing
+ *	attempt to restore the contents of main memory from such an image.
+ *	Undo the changes made by the preceding @freeze(), so the device can=
 be
+ *	operated in the same way as immediately before the call to @freeze(=
).
+ *
+ * @poweroff: Hibernation-specific, executed after saving a hibernatio=
n image.
+ *	Quiesce the device, put it into a low power state appropriate for t=
he
+ *	upcoming system state (such as PCI_D3hot), and enable wakeup events=
 as
+ *	appropriate.
+ *
+ * @restore: Hibernation-specific, executed after restoring the conten=
ts of main
+ *	memory from a hibernation image.  Driver starts working again,
+ *	responding to hardware events and software requests.  Drivers may N=
OT
+ *	make ANY assumptions about the hardware state right prior to @resto=
re().
+ *	On most platforms, there are no restrictions on availability of
+ *	resources like clocks during @restore().
+ *
+ * All of the above callbacks, except for @complete(), return error co=
des.
+ * However, the error codes returned by the resume operations, @resume=
(),
+ * @thaw(), and @restore(), do not cause the PM core to abort the resu=
me
+ * transition during which they are returned.  The error codes returne=
d in
+ * that cases are only printed by the PM core to the system logs for d=
ebugging
+ * purposes.  Still, it is recommended that drivers only return error =
codes
+ * from their resume methods in case of an unrecoverable failure (i.e.=
 when the
+ * device being handled refuses to resume and becomes unusable) to all=
ow us to
+ * modify the PM core in the future, so that it can avoid attempting t=
o handle
+ * devices that failed to resume and their children.
+ *
+ * It is allowed to unregister devices while the above callbacks are b=
eing
+ * executed.  However, it is not allowed to unregister a device from w=
ithin any
+ * of its own callbacks.
+ */
+
+struct pm_ops {
+	int (*prepare)(struct device *dev);
+	void (*complete)(struct device *dev);
+	int (*suspend)(struct device *dev);
+	int (*resume)(struct device *dev);
+	int (*freeze)(struct device *dev);
+	int (*thaw)(struct device *dev);
+	int (*poweroff)(struct device *dev);
+	int (*restore)(struct device *dev);
+};
+
+/**
+ * struct pm_ext_ops - extended device PM callbacks
+ *
+ * Some devices require certain operations related to suspend and hibe=
rnation
+ * to be carried out with interrupts disabled.  Thus, 'struct pm_ext_o=
ps' below
+ * is defined, adding callbacks to be executed with interrupts disable=
d to
+ * 'struct pm_ops'.
+ *
+ * The following callbacks included in 'struct pm_ext_ops' are execute=
d with
+ * the nonboot CPUs switched off and with interrupts disabled on the o=
nly
+ * functional CPU.  They also are executed with the PM core list of de=
vices
+ * locked, so they must NOT unregister any devices.
+ *
+ * @suspend_noirq: Complete the operations of ->suspend() by carrying =
out any
+ *	actions required for suspending the device that need interrupts to =
be
+ *	disabled
+ *
+ * @resume_noirq: Prepare for the execution of ->resume() by carrying =
out any
+ *	actions required for resuming the device that need interrupts to be
+ *	disabled
+ *
+ * @freeze_noirq: Complete the operations of ->freeze() by carrying ou=
t any
+ *	actions required for freezing the device that need interrupts to be
+ *	disabled
+ *
+ * @thaw_noirq: Prepare for the execution of ->thaw() by carrying out =
any
+ *	actions required for thawing the device that need interrupts to be
+ *	disabled
+ *
+ * @poweroff_noirq: Complete the operations of ->poweroff() by carryin=
g out any
+ *	actions required for handling the device that need interrupts to be
+ *	disabled
+ *
+ * @restore_noirq: Prepare for the execution of ->restore() by carryin=
g out any
+ *	actions required for restoring the operations of the device that ne=
ed
+ *	interrupts to be disabled
+ *
+ * All of the above callbacks return error codes, but the error codes =
returned
+ * by the resume operations, @resume_noirq(), @thaw_noirq(), and
+ * @restore_noirq(), do not cause the PM core to abort the resume tran=
sition
+ * during which they are returned.  The error codes returned in that c=
ases are
+ * only printed by the PM core to the system logs for debugging purpos=
es.
+ * Still, as stated above, it is recommended that drivers only return =
error
+ * codes from their resume methods if the device being handled fails t=
o resume
+ * and is not usable any more.
+ */
+
+struct pm_ext_ops {
+	struct pm_ops base;
+	int (*suspend_noirq)(struct device *dev);
+	int (*resume_noirq)(struct device *dev);
+	int (*freeze_noirq)(struct device *dev);
+	int (*thaw_noirq)(struct device *dev);
+	int (*poweroff_noirq)(struct device *dev);
+	int (*restore_noirq)(struct device *dev);
+};
+
+/**
+ * PM_EVENT_ messages
+ *
+ * The following PM_EVENT_ messages are defined for the internal use o=
f the PM
+ * core, in order to provide a mechanism allowing the high level suspe=
nd and
+ * hibernation code to convey the necessary information to the device =
PM core
+ * code:
+ *
+ * ON		No transition.
+ *
+ * FREEZE 	System is going to hibernate, call ->prepare() and ->freeze=
()
+ *		for all devices.
+ *
+ * SUSPEND	System is going to suspend, call ->prepare() and ->suspend(=
)
+ *		for all devices.
+ *
+ * HIBERNATE	Hibernation image has been saved, call ->prepare() and
+ *		->poweroff() for all devices.
+ *
+ * QUIESCE	Contents of main memory are going to be restored from a (lo=
aded)
+ *		hibernation image, call ->prepare() and ->freeze() for all
+ *		devices.
+ *
+ * RESUME	System is resuming, call ->resume() and ->complete() for all
+ *		devices.
+ *
+ * THAW		Hibernation image has been created, call ->thaw() and
+ *		->complete() for all devices.
+ *
+ * RESTORE	Contents of main memory have been restored from a hibernati=
on
+ *		image, call ->restore() and ->complete() for all devices.
+ *
+ * RECOVER	Creation of a hibernation image or restoration of the main
+ *		memory contents from a hibernation image has failed, call
+ *		->thaw() and ->complete() for all devices.
+ */
+
+#define PM_EVENT_ON		0x0000
+#define PM_EVENT_FREEZE 	0x0001
+#define PM_EVENT_SUSPEND	0x0002
+#define PM_EVENT_HIBERNATE	0x0004
+#define PM_EVENT_QUIESCE	0x0008
+#define PM_EVENT_RESUME		0x0010
+#define PM_EVENT_THAW		0x0020
+#define PM_EVENT_RESTORE	0x0040
+#define PM_EVENT_RECOVER	0x0080
+
+#define PM_EVENT_SLEEP	(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
+
+#define PMSG_FREEZE	((struct pm_message){ .event =3D PM_EVENT_FREEZE, =
})
+#define PMSG_QUIESCE	((struct pm_message){ .event =3D PM_EVENT_QUIESCE=
, })
+#define PMSG_SUSPEND	((struct pm_message){ .event =3D PM_EVENT_SUSPEND=
, })
+#define PMSG_HIBERNATE	((struct pm_message){ .event =3D PM_EVENT_HIBER=
NATE, })
+#define PMSG_RESUME	((struct pm_message){ .event =3D PM_EVENT_RESUME, =
})
+#define PMSG_THAW	((struct pm_message){ .event =3D PM_EVENT_THAW, })
+#define PMSG_RESTORE	((struct pm_message){ .event =3D PM_EVENT_RESTORE=
, })
+#define PMSG_RECOVER	((struct pm_message){ .event =3D PM_EVENT_RECOVER=
, })
+#define PMSG_ON		((struct pm_message){ .event =3D PM_EVENT_ON, })
+
+/**
+ * Device power management states
+ *
+ * These state labels are used internally by the PM core to indicate t=
he current
+ * status of a device with respect to the PM core operations.
+ *
+ * DPM_ON		Device is regarded as operational.  Set this way
+ *			initially and when ->complete() is about to be called.
+ *			Also set when ->prepare() fails.
+ *
+ * DPM_PREPARING	Device is going to be prepared for a PM transition.  =
Set
+ *			when ->prepare() is about to be called.
+ *
+ * DPM_RESUMING		Device is going to be resumed.  Set when ->resume(),
+ *			->thaw(), or ->restore() is about to be called.
+ *
+ * DPM_SUSPENDING	Device has been prepared for a power transition.  Se=
t
+ *			when ->prepare() has just succeeded.
+ *
+ * DPM_OFF		Device is regarded as inactive.  Set immediately after
+ *			->suspend(), ->freeze(), or ->poweroff() has succeeded.
+ *			Also set when ->resume()_noirq, ->thaw_noirq(), or
+ *			->restore_noirq() is about to be called.
+ *
+ * DPM_OFF_IRQ		Device is in a "deep sleep".  Set immediately after
+ *			->suspend_noirq(), ->freeze_noirq(), or
+ *			->poweroff_noirq() has just succeeded.
+ */
+
+enum dpm_state {
+	DPM_INVALID,
+	DPM_ON,
+	DPM_PREPARING,
+	DPM_RESUMING,
+	DPM_SUSPENDING,
+	DPM_OFF,
+	DPM_OFF_IRQ,
+};
+
+struct dev_pm_info {
+	pm_message_t		power_state;
+	unsigned		can_wakeup:1;
+	unsigned		should_wakeup:1;
+	enum dpm_state		status;		/* Owned by the PM core */
+#ifdef	CONFIG_PM_SLEEP
+	struct list_head	entry;
+#endif
+};
+
+/*
+ * The PM_EVENT_ messages are also used by drivers implementing the le=
gacy
+ * suspend framework, based on the ->suspend() and ->resume() callback=
s common
+ * for suspend and hibernation transitions, according to the rules bel=
ow.
+ */
+
+/* Necessary, because several drivers use PM_EVENT_PRETHAW */
+#define PM_EVENT_PRETHAW PM_EVENT_QUIESCE
+
+/*
  * One transition is triggered by resume(), after a suspend() call; th=
e
  * message is implicit:
  *
@@ -166,35 +446,13 @@ typedef struct pm_message {
  * or from system low-power states such as standby or suspend-to-RAM.
  */
=20
-#define PM_EVENT_ON 0
-#define PM_EVENT_FREEZE 1
-#define PM_EVENT_SUSPEND 2
-#define PM_EVENT_HIBERNATE 4
-#define PM_EVENT_PRETHAW 8
-
-#define PM_EVENT_SLEEP	(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
-
-#define PMSG_FREEZE	((struct pm_message){ .event =3D PM_EVENT_FREEZE, =
})
-#define PMSG_PRETHAW	((struct pm_message){ .event =3D PM_EVENT_PRETHAW=
, })
-#define PMSG_SUSPEND	((struct pm_message){ .event =3D PM_EVENT_SUSPEND=
, })
-#define PMSG_HIBERNATE	((struct pm_message){ .event =3D PM_EVENT_HIBER=
NATE, })
-#define PMSG_ON		((struct pm_message){ .event =3D PM_EVENT_ON, })
-
-struct dev_pm_info {
-	pm_message_t		power_state;
-	unsigned		can_wakeup:1;
-	unsigned		should_wakeup:1;
-	bool			sleeping:1;	/* Owned by the PM core */
-#ifdef	CONFIG_PM_SLEEP
-	struct list_head	entry;
-#endif
-};
+#ifdef CONFIG_PM_SLEEP
+extern void device_pm_lock(void);
+extern void device_power_up(pm_message_t state);
+extern void device_resume(pm_message_t state);
=20
+extern void device_pm_unlock(void);
 extern int device_power_down(pm_message_t state);
-extern void device_power_up(void);
-extern void device_resume(void);
-
-#ifdef CONFIG_PM_SLEEP
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
=20
diff -puN kernel/power/disk.c~pm-introduce-new-top-level-suspend-and-hi=
bernation-callbacks kernel/power/disk.c
--- a/kernel/power/disk.c~pm-introduce-new-top-level-suspend-and-hibern=
ation-callbacks
+++ a/kernel/power/disk.c
@@ -193,6 +193,7 @@ static int create_image(int platform_mod
 	if (error)
 		return error;
=20
+	device_pm_lock();
 	local_irq_disable();
 	/* At this point, device_suspend() has been called, but *not*
 	 * device_power_down(). We *must* call device_power_down() now.
@@ -224,9 +225,10 @@ static int create_image(int platform_mod
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
-	device_power_up();
+	device_power_up(in_suspend ? PMSG_RECOVER : PMSG_RESTORE);
  Enable_irqs:
 	local_irq_enable();
+	device_pm_unlock();
 	return error;
 }
=20
@@ -280,7 +282,7 @@ int hibernation_snapshot(int platform_mo
  Finish:
 	platform_finish(platform_mode);
  Resume_devices:
-	device_resume();
+	device_resume(in_suspend ? PMSG_RECOVER : PMSG_RESTORE);
  Resume_console:
 	resume_console();
  Close:
@@ -300,8 +302,9 @@ static int resume_target_kernel(void)
 {
 	int error;
=20
+	device_pm_lock();
 	local_irq_disable();
-	error =3D device_power_down(PMSG_PRETHAW);
+	error =3D device_power_down(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting resume\n");
@@ -329,9 +332,10 @@ static int resume_target_kernel(void)
 	swsusp_free();
 	restore_processor_state();
 	touch_softlockup_watchdog();
-	device_power_up();
+	device_power_up(PMSG_THAW);
  Enable_irqs:
 	local_irq_enable();
+	device_pm_unlock();
 	return error;
 }
=20
@@ -350,7 +354,7 @@ int hibernation_restore(int platform_mod
=20
 	pm_prepare_console();
 	suspend_console();
-	error =3D device_suspend(PMSG_PRETHAW);
+	error =3D device_suspend(PMSG_QUIESCE);
 	if (error)
 		goto Finish;
=20
@@ -362,7 +366,7 @@ int hibernation_restore(int platform_mod
 		enable_nonboot_cpus();
 	}
 	platform_restore_cleanup(platform_mode);
-	device_resume();
+	device_resume(PMSG_RECOVER);
  Finish:
 	resume_console();
 	pm_restore_console();
@@ -403,6 +407,7 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Finish;
=20
+	device_pm_lock();
 	local_irq_disable();
 	error =3D device_power_down(PMSG_HIBERNATE);
 	if (!error) {
@@ -411,6 +416,7 @@ int hibernation_platform_enter(void)
 		while (1);
 	}
 	local_irq_enable();
+	device_pm_unlock();
=20
 	/*
 	 * We don't need to reenable the nonboot CPUs or resume consoles, sin=
ce
@@ -419,7 +425,7 @@ int hibernation_platform_enter(void)
  Finish:
 	hibernation_ops->finish();
  Resume_devices:
-	device_resume();
+	device_resume(PMSG_RESTORE);
  Resume_console:
 	resume_console();
  Close:
diff -puN kernel/power/main.c~pm-introduce-new-top-level-suspend-and-hi=
bernation-callbacks kernel/power/main.c
--- a/kernel/power/main.c~pm-introduce-new-top-level-suspend-and-hibern=
ation-callbacks
+++ a/kernel/power/main.c
@@ -228,6 +228,7 @@ static int suspend_enter(suspend_state_t
 {
 	int error =3D 0;
=20
+	device_pm_lock();
 	arch_suspend_disable_irqs();
 	BUG_ON(!irqs_disabled());
=20
@@ -239,10 +240,11 @@ static int suspend_enter(suspend_state_t
 	if (!suspend_test(TEST_CORE))
 		error =3D suspend_ops->enter(state);
=20
-	device_power_up();
+	device_power_up(PMSG_RESUME);
  Done:
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
+	device_pm_unlock();
 	return error;
 }
=20
@@ -291,7 +293,7 @@ int suspend_devices_and_enter(suspend_st
 	if (suspend_ops->finish)
 		suspend_ops->finish();
  Resume_devices:
-	device_resume();
+	device_resume(PMSG_RESUME);
  Resume_console:
 	resume_console();
  Close:
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
power-replace-remaining-__function__-occurrences.patch
s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-v=
t-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-v=
t-switch-fix.patch
proc-switch-proc-apm-to-seq_file-interface.patch
shrink_slab-handle-bad-shrinkers.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
