From: akpm@linux-foundation.org
Subject: - pm-introduce-hibernation-and-suspend-notifiers.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:19 -0700
Message-ID: <200707192000.l6JK0JqO019438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932101AbXGSU1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     PM: introduce hibernation and suspend notifiers
has been removed from the -mm tree.  Its filename was
     pm-introduce-hibernation-and-suspend-notifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PM: introduce hibernation and suspend notifiers
From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to register hibernation and suspend notifiers, so that
subsystems can perform hibernation-related or suspend-related operations that
should not be carried out by device drivers' .suspend() and .resume()
routines.

[akpm@linux-foundation.org: build fixes]
[akpm@linux-foundation.org: cleanups]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/notifiers.txt |   50 ++++++++++++++++++++++++++++
 include/linux/notifier.h          |    6 +++
 include/linux/suspend.h           |   48 ++++++++++++++++++++++++--
 kernel/power/disk.c               |   16 ++++++--
 kernel/power/main.c               |    9 +++++
 kernel/power/power.h              |   10 +++++
 kernel/power/user.c               |   11 ++++--
 7 files changed, 138 insertions(+), 12 deletions(-)

diff -puN /dev/null Documentation/power/notifiers.txt
--- /dev/null
+++ a/Documentation/power/notifiers.txt
@@ -0,0 +1,50 @@
+Suspend notifiers
+	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+
+There are some operations that device drivers may want to carry out in their
+.suspend() routines, but shouldn't, because they can cause the hibernation or
+suspend to fail. For example, a driver may want to allocate a substantial amount
+of memory (like 50 MB) in .suspend(), but that shouldn't be done after the
+swsusp's memory shrinker has run.
+
+Also, there may be some operations, that subsystems want to carry out before a
+hibernation/suspend or after a restore/resume, requiring the system to be fully
+functional, so the drivers' .suspend() and .resume() routines are not suitable
+for this purpose.  For example, device drivers may want to upload firmware to
+their devices after a restore from a hibernation image, but they cannot do it by
+calling request_firmware() from their .resume() routines (user land processes
+are frozen at this point).  The solution may be to load the firmware into
+memory before processes are frozen and upload it from there in the .resume()
+routine.  Of course, a hibernation notifier may be used for this purpose.
+
+The subsystems that have such needs can register suspend notifiers that will be
+called upon the following events by the suspend core:
+
+PM_HIBERNATION_PREPARE	The system is going to hibernate or suspend, tasks will
+			be frozen immediately.
+
+PM_POST_HIBERNATION	The system memory state has been restored from a
+			hibernation image or an error occured during the
+			hibernation.  Device drivers' .resume() callbacks have
+			been executed and tasks have been thawed.
+
+PM_SUSPEND_PREPARE	The system is preparing for a suspend.
+
+PM_POST_SUSPEND		The system has just resumed or an error occured during
+			the suspend.	Device drivers' .resume() callbacks have
+			been executed and tasks have been thawed.
+
+It is generally assumed that whatever the notifiers do for
+PM_HIBERNATION_PREPARE, should be undone for PM_POST_HIBERNATION.  Analogously,
+operations performed for PM_SUSPEND_PREPARE should be reversed for
+PM_POST_SUSPEND.  Additionally, all of the notifiers are called for
+PM_POST_HIBERNATION if one of them fails for PM_HIBERNATION_PREPARE, and
+all of the notifiers are called for PM_POST_SUSPEND if one of them fails for
+PM_SUSPEND_PREPARE.
+
+The hibernation and suspend notifiers are called with pm_mutex held.  They are
+defined in the usual way, but their last argument is meaningless (it is always
+NULL).  To register and/or unregister a suspend notifier use the functions
+register_pm_notifier() and unregister_pm_notifier(), respectively, defined in
+include/linux/suspend.h .  If you don't need to unregister the notifier, you can
+also use the pm_notifier() macro defined in include/linux/suspend.h .
diff -puN include/linux/notifier.h~pm-introduce-hibernation-and-suspend-notifiers include/linux/notifier.h
--- a/include/linux/notifier.h~pm-introduce-hibernation-and-suspend-notifiers
+++ a/include/linux/notifier.h
@@ -212,5 +212,11 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
 #define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
 
+/* Hibernation and suspend events */
+#define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
+#define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
+#define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
+#define PM_POST_SUSPEND		0x0004 /* Suspend finished */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff -puN include/linux/suspend.h~pm-introduce-hibernation-and-suspend-notifiers include/linux/suspend.h
--- a/include/linux/suspend.h~pm-introduce-hibernation-and-suspend-notifiers
+++ a/include/linux/suspend.h
@@ -54,7 +54,8 @@ struct hibernation_ops {
 	void (*restore_cleanup)(void);
 };
 
-#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+#ifdef CONFIG_PM
+#ifdef CONFIG_SOFTWARE_SUSPEND
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
 static inline void register_nosave_region(unsigned long b, unsigned long e)
@@ -72,16 +73,14 @@ extern unsigned long get_safe_page(gfp_t
 
 extern void hibernation_set_ops(struct hibernation_ops *ops);
 extern int hibernate(void);
-#else
-static inline void register_nosave_region(unsigned long b, unsigned long e) {}
-static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
+#else /* CONFIG_SOFTWARE_SUSPEND */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
 static inline void hibernation_set_ops(struct hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
-#endif /* defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND) */
+#endif /* CONFIG_SOFTWARE_SUSPEND */
 
 void save_processor_state(void);
 void restore_processor_state(void);
@@ -89,4 +88,43 @@ struct saved_context;
 void __save_processor_state(struct saved_context *ctxt);
 void __restore_processor_state(struct saved_context *ctxt);
 
+/* kernel/power/main.c */
+extern struct blocking_notifier_head pm_chain_head;
+
+static inline int register_pm_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&pm_chain_head, nb);
+}
+
+static inline int unregister_pm_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&pm_chain_head, nb);
+}
+
+#define pm_notifier(fn, pri) {				\
+	static struct notifier_block fn##_nb =			\
+		{ .notifier_call = fn, .priority = pri };	\
+	register_pm_notifier(&fn##_nb);			\
+}
+#else /* CONFIG_PM */
+
+static inline int register_pm_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int unregister_pm_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+#define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
+#endif /* CONFIG_PM */
+
+#if !defined CONFIG_SOFTWARE_SUSPEND || !defined(CONFIG_PM)
+static inline void register_nosave_region(unsigned long b, unsigned long e)
+{
+}
+#endif
+
 #endif /* _LINUX_SWSUSP_H */
diff -puN kernel/power/disk.c~pm-introduce-hibernation-and-suspend-notifiers kernel/power/disk.c
--- a/kernel/power/disk.c~pm-introduce-hibernation-and-suspend-notifiers
+++ a/kernel/power/disk.c
@@ -281,9 +281,16 @@ int hibernate(void)
 {
 	int error;
 
+	mutex_lock(&pm_mutex);
 	/* The snapshot device should not be opened while we're running */
-	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
-		return -EBUSY;
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+		error = -EBUSY;
+		goto Unlock;
+	}
+
+	error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+	if (error)
+		goto Exit;
 
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
@@ -294,7 +301,6 @@ int hibernate(void)
 	if (error)
 		goto Finish;
 
-	mutex_lock(&pm_mutex);
 	if (hibernation_mode == HIBERNATION_TESTPROC) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
@@ -316,12 +322,14 @@ int hibernate(void)
 		swsusp_free();
 	}
  Thaw:
-	mutex_unlock(&pm_mutex);
 	unprepare_processes();
  Finish:
 	free_basic_memory_bitmaps();
  Exit:
+	pm_notifier_call_chain(PM_POST_HIBERNATION);
 	atomic_inc(&snapshot_device_available);
+ Unlock:
+	mutex_unlock(&pm_mutex);
 	return error;
 }
 
diff -puN kernel/power/main.c~pm-introduce-hibernation-and-suspend-notifiers kernel/power/main.c
--- a/kernel/power/main.c~pm-introduce-hibernation-and-suspend-notifiers
+++ a/kernel/power/main.c
@@ -23,6 +23,8 @@
 
 #include "power.h"
 
+BLOCKING_NOTIFIER_HEAD(pm_chain_head);
+
 /*This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
 
@@ -78,6 +80,10 @@ static int suspend_prepare(suspend_state
 	if (!pm_ops || !pm_ops->enter)
 		return -EPERM;
 
+	error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
 	pm_prepare_console();
 
 	if (freeze_processes()) {
@@ -125,6 +131,8 @@ static int suspend_prepare(suspend_state
  Thaw:
 	thaw_processes();
 	pm_restore_console();
+ Finish:
+	pm_notifier_call_chain(PM_POST_SUSPEND);
 	return error;
 }
 
@@ -176,6 +184,7 @@ static void suspend_finish(suspend_state
 	resume_console();
 	thaw_processes();
 	pm_restore_console();
+	pm_notifier_call_chain(PM_POST_SUSPEND);
 }
 
 
diff -puN kernel/power/power.h~pm-introduce-hibernation-and-suspend-notifiers kernel/power/power.h
--- a/kernel/power/power.h~pm-introduce-hibernation-and-suspend-notifiers
+++ a/kernel/power/power.h
@@ -173,5 +173,15 @@ extern void swsusp_close(void);
 extern int suspend_enter(suspend_state_t state);
 
 struct timeval;
+/* kernel/power/swsusp.c */
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
+
+/* kernel/power/main.c */
+extern struct blocking_notifier_head pm_chain_head;
+
+static inline int pm_notifier_call_chain(unsigned long val)
+{
+	return (blocking_notifier_call_chain(&pm_chain_head, val, NULL)
+			== NOTIFY_BAD) ? -EINVAL : 0;
+}
diff -puN kernel/power/user.c~pm-introduce-hibernation-and-suspend-notifiers kernel/power/user.c
--- a/kernel/power/user.c~pm-introduce-hibernation-and-suspend-notifiers
+++ a/kernel/power/user.c
@@ -151,10 +151,14 @@ static int snapshot_ioctl(struct inode *
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
-		if (freeze_processes()) {
-			thaw_processes();
-			error = -EBUSY;
+		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+		if (!error) {
+			error = freeze_processes();
+			if (error)
+				thaw_processes();
 		}
+		if (error)
+			pm_notifier_call_chain(PM_POST_HIBERNATION);
 		mutex_unlock(&pm_mutex);
 		if (!error)
 			data->frozen = 1;
@@ -165,6 +169,7 @@ static int snapshot_ioctl(struct inode *
 			break;
 		mutex_lock(&pm_mutex);
 		thaw_processes();
+		pm_notifier_call_chain(PM_POST_HIBERNATION);
 		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch
