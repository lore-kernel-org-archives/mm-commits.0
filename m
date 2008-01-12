From: akpm@linux-foundation.org
Subject: - pm-introduce-destroy_suspended_device.patch removed from -mm tree
Date: Fri, 11 Jan 2008 16:49:26 -0800
Message-ID: <200801120049.m0C0nQx1006363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762856AbYALAuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 19:50:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ak@suse.de, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, mingo@elte.hu, pavel@suse.cz, stern@rowland.harvard.edu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     PM: Introduce destroy_suspended_device()
has been removed from the -mm tree.  Its filename was
     pm-introduce-destroy_suspended_device.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM: Introduce destroy_suspended_device()
From: Rafael J. Wysocki <rjw@sisk.pl>

It sometimes is necessary to destroy a device object during a suspend or
hibernation, but the PM core is supposed to control all device objects in that
cases.  For this reason, it is necessary to introduce a mechanism allowing one
to ask the PM core to remove a device object corresponding to a suspended
device on one's behalf.

Define function destroy_suspended_device() that will schedule the removal of a
device object corresponding to a suspended device by the PM core during the
subsequent resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c        |   44 +++++++++++++++++++++++++++++++----
 drivers/base/power/main.c  |   35 ++++++++++++++++++++-------
 drivers/base/power/power.h |    1 
 include/linux/device.h     |    8 ++++++
 4 files changed, 74 insertions(+), 14 deletions(-)

diff -puN drivers/base/core.c~pm-introduce-destroy_suspended_device drivers/base/core.c
--- a/drivers/base/core.c~pm-introduce-destroy_suspended_device
+++ a/drivers/base/core.c
@@ -1139,14 +1139,11 @@ error:
 EXPORT_SYMBOL_GPL(device_create);
 
 /**
- * device_destroy - removes a device that was created with device_create()
+ * find_device - finds a device that was created with device_create()
  * @class: pointer to the struct class that this device was registered with
  * @devt: the dev_t of the device that was previously registered
- *
- * This call unregisters and cleans up a device that was created with a
- * call to device_create().
  */
-void device_destroy(struct class *class, dev_t devt)
+static struct device *find_device(struct class *class, dev_t devt)
 {
 	struct device *dev = NULL;
 	struct device *dev_tmp;
@@ -1159,12 +1156,49 @@ void device_destroy(struct class *class,
 		}
 	}
 	up(&class->sem);
+	return dev;
+}
 
+/**
+ * device_destroy - removes a device that was created with device_create()
+ * @class: pointer to the struct class that this device was registered with
+ * @devt: the dev_t of the device that was previously registered
+ *
+ * This call unregisters and cleans up a device that was created with a
+ * call to device_create().
+ */
+void device_destroy(struct class *class, dev_t devt)
+{
+	struct device *dev;
+
+	dev = find_device(class, devt);
 	if (dev)
 		device_unregister(dev);
 }
 EXPORT_SYMBOL_GPL(device_destroy);
 
+#ifdef CONFIG_PM_SLEEP
+/**
+ * destroy_suspended_device - schedules the removal of a suspended device
+ * @class: pointer to the struct class that this device was registered with
+ * @devt: the dev_t of the device that was previously registered
+ *
+ * This call notifies the PM core of the necessity to unregister a suspended
+ * device created with a call to device_create() (devices cannot be
+ * unregistered directly while suspended, since the PM core controls them in
+ * that cases).
+ */
+void destroy_suspended_device(struct class *class, dev_t devt)
+{
+	struct device *dev;
+
+	dev = find_device(class, devt);
+	if (dev)
+		device_pm_schedule_removal(dev);
+}
+EXPORT_SYMBOL_GPL(destroy_suspended_device);
+#endif /* CONFIG_PM_SLEEP */
+
 /**
  * device_rename - renames a device
  * @dev: the pointer to the struct device to be renamed
diff -puN drivers/base/power/main.c~pm-introduce-destroy_suspended_device drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-introduce-destroy_suspended_device
+++ a/drivers/base/power/main.c
@@ -31,6 +31,7 @@
 LIST_HEAD(dpm_active);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
+static LIST_HEAD(dpm_destroy);
 
 static DEFINE_MUTEX(dpm_mtx);
 static DEFINE_MUTEX(dpm_list_mtx);
@@ -59,6 +60,16 @@ void device_pm_remove(struct device *dev
 	mutex_unlock(&dpm_list_mtx);
 }
 
+void device_pm_schedule_removal(struct device *dev)
+{
+	pr_debug("PM: Removing info for %s:%s\n",
+		 dev->bus ? dev->bus->name : "No Bus",
+		 kobject_name(&dev->kobj));
+	mutex_lock(&dpm_list_mtx);
+	list_move_tail(&dev->power.entry, &dpm_destroy);
+	mutex_unlock(&dpm_list_mtx);
+}
+
 
 /*------------------------- Resume routines -------------------------*/
 
@@ -113,11 +124,14 @@ static int resume_device_early(struct de
 	return error;
 }
 
-/*
- * Resume the devices that have either not gone through
- * the late suspend, or that did go through it but also
- * went through the early resume
+/**
+ *	dpm_resume - Restore state of each device in system.
+ *
+ *	Walk the dpm_off list, remove each entry, resume the device,
+ *	then add it to the dpm_active list.  Unregister devices scheduled for
+ *	removal.
  */
+
 static void dpm_resume(void)
 {
 	mutex_lock(&dpm_list_mtx);
@@ -134,14 +148,17 @@ static void dpm_resume(void)
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
-}
+	/* Unregister devices scheduled for removal */
+	while (!list_empty(&dpm_destroy)) {
+		struct list_head *entry = dpm_destroy.next;
+		struct device *dev = to_device(entry);
 
+		device_unregister(dev);
+	}
+}
 
 /**
- *	device_resume - Restore state of each device in system.
- *
- *	Walk the dpm_off list, remove each entry, resume the device,
- *	then add it to the dpm_active list.
+ *	device_resume - Invoke dpm_resume() under dpm_mtx.
  */
 
 void device_resume(void)
diff -puN drivers/base/power/power.h~pm-introduce-destroy_suspended_device drivers/base/power/power.h
--- a/drivers/base/power/power.h~pm-introduce-destroy_suspended_device
+++ a/drivers/base/power/power.h
@@ -13,6 +13,7 @@ static inline struct device *to_device(s
 
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
+extern void device_pm_schedule_removal(struct device *);
 
 #else /* CONFIG_PM_SLEEP */
 
diff -puN include/linux/device.h~pm-introduce-destroy_suspended_device include/linux/device.h
--- a/include/linux/device.h~pm-introduce-destroy_suspended_device
+++ a/include/linux/device.h
@@ -518,6 +518,14 @@ extern struct device *device_create(stru
 				    dev_t devt, const char *fmt, ...)
 				    __attribute__((format(printf,4,5)));
 extern void device_destroy(struct class *cls, dev_t devt);
+#ifdef CONFIG_PM_SLEEP
+extern void destroy_suspended_device(struct class *cls, dev_t devt);
+#else /* !CONFIG_PM_SLEEP */
+static inline void destroy_suspended_device(struct class *cls, dev_t devt)
+{
+	device_destroy(cls, devt);
+}
+#endif /* !CONFIG_PM_SLEEP */
 
 /*
  * Platform "fixup" functions - allow the platform to have their say
_

Patches currently in -mm which might be from rjw@sisk.pl are

reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case.patch
git-acpi.patch
suspend-introduce-begin-and-end-callbacks.patch
acpi-separate-invocations-of-_gts-and-_bfs-from-_pts-and-_wak.patch
acpi-separate-disabling-of-gpes-from-_pts.patch
acpi-suspend-call-_pts-before-suspending-devices.patch
hibernation-introduce-begin-and-end-callbacks.patch
acpi-hibernation-call-_pts-before-suspending-devices.patch
acpi-print-message-before-calling-_pts.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
pm-introduce-destroy_suspended_device.patch
pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2.patch
pm-do-not-destroy-create-devices-while-suspended-in-mce_64c.patch
pm-do-not-destroy-create-devices-while-suspended-in-cpuidc.patch
pm-acquire-device-locks-on-suspend-rev-3.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
git-x86.patch
git-xfs.patch
cpufreq-initialise-default-governor-before-use.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
remove-obsolete-sys-devices-power-state-docs.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
