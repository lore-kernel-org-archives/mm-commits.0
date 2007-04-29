From: akpm@linux-foundation.org
Subject: - pm-introduce-suspend-notifiers-rev-2.patch removed from -mm tree
Date: Sun, 29 Apr 2007 12:15:46 -0700
Message-ID: <200704291915.l3TJFkr3021755@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbXD2TQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 15:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     PM: Introduce suspend notifiers
has been removed from the -mm tree.  Its filename was
     pm-introduce-suspend-notifiers-rev-2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: PM: Introduce suspend notifiers
From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to register suspend notifiers so that subsystems can perform
suspend-related operations that should not be carried out by device drivers'
.suspend() and .resume() routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/suspend-notifiers.txt |   48 ++++++++++++++++++
 include/linux/notifier.h                  |    6 ++
 include/linux/suspend.h                   |   19 +++++++
 kernel/power/Makefile                     |    2 
 kernel/power/disk.c                       |   23 ++++++++-
 kernel/power/main.c                       |   16 +++++-
 kernel/power/notify.c                     |   51 ++++++++++++++++++++
 kernel/power/power.h                      |    3 +
 kernel/power/user.c                       |   45 +++++++++++++----
 9 files changed, 199 insertions(+), 14 deletions(-)

diff -puN /dev/null Documentation/power/suspend-notifiers.txt
--- /dev/null
+++ a/Documentation/power/suspend-notifiers.txt
@@ -0,0 +1,48 @@
+Suspend notifiers
+	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+
+There are some operations that device drivers may want to carry out in their
+.suspend() routines, but shouldn't, because they can cause a suspend to fail.
+For example, a driver may want to allocate a substantial amount of memory
+(like 50 MB) in .suspend(), but that shouldn't be done after the swsusp's memory
+shrinker has run.  Also, there may be some operations, that subsystems may want
+to carry out before a suspend or after a resume, requiring the system to be
+fully functional, so the drivers' .suspend() and .resume() routines are not
+suitable for this purpose.
+
+The subsystems that have such needs can register suspend notifiers that will be
+notified of the following events by the suspend core:
+
+SUSPEND_PREPARE		the system is going to suspend, tasks will be frozen
+			immediately
+
+SUSPEND_ENTER_PREPARE	tasks have been frozen, memory is going to be freed
+			and devices are going to be suspended
+
+SUSPEND_THAW_PREPARE	devices have been resumed, tasks will be thawed
+			immediately
+
+SUSPEND_FINISHED	the resume is complete, the system is fully functional
+
+SUSPEND_RESTORE_PREPARE	the system is preparing to restore the swsusp's suspend
+			image, tasks have been frozen and devices are going to
+			be suspended
+
+It is generally assumed that whatever the notifiers do for SUSPEND_PREPARE,
+should be undone for SUSPEND_FINISHED, and what is done for
+SUSPEND_ENTER_PREPARE, should be undone for SUSPEND_FINISHED (eg. if memory is
+allocated for SUSPEND_ENTER_PREPARE, it should be freed for SUSPEND_FINISHED).
+Moreover, if the SUSPEND_PREPARE hooks are called, SUSPEND_FINISHED will be
+called too and if SUSPEND_ENTER_PREPARE are called, SUSPEND_THAW_PREPARE will be
+called either, even if the suspend fails.  This way, for example, the memory
+allocated with SUSPEND_ENTER_PREPARE can always be freed with
+SUSPEND_THAW_PREPARE and need not be leaked in case the suspend fails.
+
+The suspend notifiers are called with pm_mutex held.
+
+The suspend notifiers are defined in the usual way, but their last argument is
+meaningless (it is always NULL).  To register and/or unregister a suspend
+notifier use the functions register_suspend_notifier() and
+unregister_suspend_notifier(), respectively, defined in kernel/power/notify.c .
+If you don't need to unregister the notifier, you can also use the
+suspend_notifier() macro defined in include/linux/suspend.h .
diff -puN include/linux/notifier.h~pm-introduce-suspend-notifiers-rev-2 include/linux/notifier.h
--- a/include/linux/notifier.h~pm-introduce-suspend-notifiers-rev-2
+++ a/include/linux/notifier.h
@@ -187,5 +187,11 @@ extern int srcu_notifier_call_chain(stru
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 
+#define SUSPEND_PREPARE		0x0002 /* Going to freeze tasks */
+#define SUSPEND_ENTER_PREPARE	0x0003 /* Tasks are frozen, we are suspending */
+#define SUSPEND_THAW_PREPARE	0x0004 /* Going to thaw frozen tasks */
+#define SUSPEND_FINISHED	0x0005 /* Tasks have been thawed */
+#define SUSPEND_RESTORE_PREPARE	0x0006 /* STD restore is going to happen */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff -puN include/linux/suspend.h~pm-introduce-suspend-notifiers-rev-2 include/linux/suspend.h
--- a/include/linux/suspend.h~pm-introduce-suspend-notifiers-rev-2
+++ a/include/linux/suspend.h
@@ -52,4 +52,23 @@ struct saved_context;
 void __save_processor_state(struct saved_context *ctxt);
 void __restore_processor_state(struct saved_context *ctxt);
 
+#ifdef CONFIG_PM
+int register_suspend_notifier(struct notifier_block *nb);
+void unregister_suspend_notifier(struct notifier_block *nb);
+
+#define suspend_notifier(fn, pri) {				\
+	static struct notifier_block fn##_nb =			\
+		{ .notifier_call = fn, .priority = pri };	\
+	register_suspend_notifier(&fn##_nb);			\
+}
+#else /* CONFIG_PM */
+static inline int register_suspend_notifier(struct notifier_block *nb) {
+	return 0;
+}
+static inline void unregister_suspend_notifier(struct notifier_block *nb) {
+}
+
+#define suspend_notifier(fn, pri)	do { (void)(fn); } while (0)
+#endif /* CONFIG_PM */
+
 #endif /* _LINUX_SWSUSP_H */
diff -puN kernel/power/Makefile~pm-introduce-suspend-notifiers-rev-2 kernel/power/Makefile
--- a/kernel/power/Makefile~pm-introduce-suspend-notifiers-rev-2
+++ a/kernel/power/Makefile
@@ -3,7 +3,7 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o process.o console.o
+obj-y				:= main.o process.o console.o notify.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
diff -puN kernel/power/disk.c~pm-introduce-suspend-notifiers-rev-2 kernel/power/disk.c
--- a/kernel/power/disk.c~pm-introduce-suspend-notifiers-rev-2
+++ a/kernel/power/disk.c
@@ -139,10 +139,18 @@ int pm_suspend_disk(void)
 	if (error)
 		goto Exit;
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
 	error = prepare_processes();
 	if (error)
 		goto Finish;
 
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Thaw;
+
 	if (pm_disk_mode == PM_DISK_TESTPROC) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
@@ -205,8 +213,10 @@ int pm_suspend_disk(void)
 	device_resume();
 	resume_console();
  Thaw:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	unprepare_processes();
  Finish:
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 	free_basic_memory_bitmaps();
  Exit:
 	atomic_inc(&snapshot_device_available);
@@ -267,6 +277,10 @@ static int software_resume(void)
 	if (error)
 		goto Finish;
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Done;
+
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = prepare_processes();
 	if (error) {
@@ -279,9 +293,13 @@ static int software_resume(void)
 	error = swsusp_read();
 	if (error) {
 		swsusp_free();
-		goto Thaw;
+		goto Unprepare;
 	}
 
+	error = suspend_notifier_call_chain(SUSPEND_RESTORE_PREPARE);
+	if (error)
+		goto Thaw;
+
 	pr_debug("PM: Preparing devices for restore.\n");
 
 	suspend_console();
@@ -299,9 +317,12 @@ static int software_resume(void)
 	device_resume();
 	resume_console();
  Thaw:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
+ Unprepare:
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	unprepare_processes();
  Done:
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 	free_basic_memory_bitmaps();
  Finish:
 	atomic_inc(&snapshot_device_available);
diff -puN kernel/power/main.c~pm-introduce-suspend-notifiers-rev-2 kernel/power/main.c
--- a/kernel/power/main.c~pm-introduce-suspend-notifiers-rev-2
+++ a/kernel/power/main.c
@@ -86,11 +86,20 @@ static int suspend_prepare(suspend_state
 
 	pm_prepare_console();
 
+	error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
 	if (freeze_processes()) {
 		error = -EAGAIN;
-		goto Thaw;
+		thaw_processes();
+		goto Finish;
 	}
 
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Thaw;
+
 	if ((free_pages = global_page_state(NR_FREE_PAGES))
 			< FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
@@ -123,8 +132,11 @@ static int suspend_prepare(suspend_state
 	device_resume();
 	resume_console();
  Thaw:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	thaw_processes();
+ Finish:
 	pm_restore_console();
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 	return error;
 }
 
@@ -174,8 +186,10 @@ static void suspend_finish(suspend_state
 	pm_finish(state);
 	device_resume();
 	resume_console();
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	thaw_processes();
 	pm_restore_console();
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
 }
 
 
diff -puN /dev/null kernel/power/notify.c
--- /dev/null
+++ a/kernel/power/notify.c
@@ -0,0 +1,51 @@
+/*
+ * linux/kernel/power/notify.c
+ *
+ * This file contains functions used for registering and calling suspend
+ * notifiers that can be used by subsystems for carrying out some special
+ * suspend-related operations.
+ *
+ * Copyright (C) 2007 Rafael J. Wysocki <rjw@sisk.pl>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/suspend.h>
+
+static DEFINE_MUTEX(suspend_notifier_lock);
+
+static RAW_NOTIFIER_HEAD(suspend_chain);
+
+int register_suspend_notifier(struct notifier_block *nb)
+{
+	int ret;
+	mutex_lock(&suspend_notifier_lock);
+	ret = raw_notifier_chain_register(&suspend_chain, nb);
+	mutex_unlock(&suspend_notifier_lock);
+	return ret;
+}
+EXPORT_SYMBOL(register_suspend_notifier);
+
+void unregister_suspend_notifier(struct notifier_block *nb)
+{
+	mutex_lock(&suspend_notifier_lock);
+	raw_notifier_chain_unregister(&suspend_chain, nb);
+	mutex_unlock(&suspend_notifier_lock);
+}
+EXPORT_SYMBOL(unregister_suspend_notifier);
+
+int suspend_notifier_call_chain(unsigned long val)
+{
+	int error = 0;
+
+	mutex_lock(&suspend_notifier_lock);
+	if (raw_notifier_call_chain(&suspend_chain, val, NULL) == NOTIFY_BAD)
+		error = -EINVAL;
+
+	mutex_unlock(&suspend_notifier_lock);
+	return error;
+}
diff -puN kernel/power/power.h~pm-introduce-suspend-notifiers-rev-2 kernel/power/power.h
--- a/kernel/power/power.h~pm-introduce-suspend-notifiers-rev-2
+++ a/kernel/power/power.h
@@ -170,3 +170,6 @@ extern int suspend_enter(suspend_state_t
 struct timeval;
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
+
+/* kernel/power/notify.c */
+extern int suspend_notifier_call_chain(unsigned long val);
diff -puN kernel/power/user.c~pm-introduce-suspend-notifiers-rev-2 kernel/power/user.c
--- a/kernel/power/user.c~pm-introduce-suspend-notifiers-rev-2
+++ a/kernel/power/user.c
@@ -75,6 +75,18 @@ static int snapshot_open(struct inode *i
 	return 0;
 }
 
+static void snapshot_unfreeze(struct snapshot_data *data)
+{
+	if (!data->frozen)
+		return;
+
+	mutex_lock(&pm_mutex);
+	thaw_processes();
+	suspend_notifier_call_chain(SUSPEND_FINISHED);
+	mutex_unlock(&pm_mutex);
+	data->frozen = 0;
+}
+
 static int snapshot_release(struct inode *inode, struct file *filp)
 {
 	struct snapshot_data *data;
@@ -83,11 +95,7 @@ static int snapshot_release(struct inode
 	free_basic_memory_bitmaps();
 	data = filp->private_data;
 	free_all_swap_pages(data->swap);
-	if (data->frozen) {
-		mutex_lock(&pm_mutex);
-		thaw_processes();
-		mutex_unlock(&pm_mutex);
-	}
+	snapshot_unfreeze(data);
 	atomic_inc(&snapshot_device_available);
 	return 0;
 }
@@ -147,6 +155,10 @@ static inline int snapshot_suspend(int p
 	int error;
 
 	mutex_lock(&pm_mutex);
+	error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+	if (error)
+		goto Finish;
+
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
@@ -175,6 +187,7 @@ static inline int snapshot_suspend(int p
 	device_resume();
 	resume_console();
  Finish:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	mutex_unlock(&pm_mutex);
 	return error;
 }
@@ -185,6 +198,10 @@ static inline int snapshot_restore(int p
 
 	mutex_lock(&pm_mutex);
 	pm_prepare_console();
+	error = suspend_notifier_call_chain(SUSPEND_RESTORE_PREPARE);
+	if (error)
+		goto Finish;
+
 	if (platform_suspend) {
 		error = platform_prepare();
 		if (error)
@@ -207,6 +224,7 @@ static inline int snapshot_restore(int p
 	device_resume();
 	resume_console();
  Finish:
+	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 	pm_restore_console();
 	mutex_unlock(&pm_mutex);
 	return error;
@@ -235,8 +253,13 @@ static int snapshot_ioctl(struct inode *
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
+		error = suspend_notifier_call_chain(SUSPEND_PREPARE);
+		if (error)
+			break;
+
 		if (freeze_processes()) {
 			thaw_processes();
+			suspend_notifier_call_chain(SUSPEND_FINISHED);
 			error = -EBUSY;
 		}
 		mutex_unlock(&pm_mutex);
@@ -245,12 +268,7 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_UNFREEZE:
-		if (!data->frozen)
-			break;
-		mutex_lock(&pm_mutex);
-		thaw_processes();
-		mutex_unlock(&pm_mutex);
-		data->frozen = 0;
+		snapshot_unfreeze(data);
 		break;
 
 	case SNAPSHOT_ATOMIC_SNAPSHOT:
@@ -349,6 +367,10 @@ static int snapshot_ioctl(struct inode *
 			break;
 		}
 
+		error = suspend_notifier_call_chain(SUSPEND_ENTER_PREPARE);
+		if (error)
+			goto OutS3;
+
 		if (pm_ops->prepare) {
 			error = pm_ops->prepare(PM_SUSPEND_MEM);
 			if (error)
@@ -375,6 +397,7 @@ static int snapshot_ioctl(struct inode *
 			pm_ops->finish(PM_SUSPEND_MEM);
 
  OutS3:
+		suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
 		mutex_unlock(&pm_mutex);
 		break;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-implement-pm_opsvalid-for-everybody-fix.patch
power-management-force-pm_opsvalid-callback-to-be.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
freezer-remove-pf_nofreeze-from-handle_initrd.patch
swsusp-use-rbtree-for-tracking-allocated-swap.patch
freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
swsusp-fix-snapshot_release.patch
swsusp-free-more-memory.patch
pm-introduce-suspend-notifiers-rev-2.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
