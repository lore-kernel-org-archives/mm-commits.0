From: akpm@linux-foundation.org
Subject: - pm-reduce-code-duplication-between-mainc-and-userc.patch removed from -mm tree
Date: Thu, 28 Jun 2007 15:04:29 -0700
Message-ID: <200706282204.l5SM4U07002513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36733 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758668AbXF1WEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     PM: Reduce code duplication between main.c and user.c
has been removed from the -mm tree.  Its filename was
     pm-reduce-code-duplication-between-mainc-and-userc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: PM: Reduce code duplication between main.c and user.c
From: Rafael J. Wysocki <rjw@sisk.pl>

The SNAPSHOT_S2RAM ioctl code is outdated and it should not duplicate the
suspend code in kernel/power/main.c.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c  |   89 +++++++++++++++++++++++------------------
 kernel/power/power.h |    3 -
 kernel/power/user.c  |   38 ++---------------
 3 files changed, 57 insertions(+), 73 deletions(-)

diff -puN kernel/power/main.c~pm-reduce-code-duplication-between-mainc-and-userc kernel/power/main.c
--- a/kernel/power/main.c~pm-reduce-code-duplication-between-mainc-and-userc
+++ a/kernel/power/main.c
@@ -66,14 +66,11 @@ static inline void pm_finish(suspend_sta
 
 /**
  *	suspend_prepare - Do prep work before entering low-power state.
- *	@state:		State we're entering.
  *
- *	This is common code that is called for each state that we're 
- *	entering. Allocate a console, stop all processes, then make sure
- *	the platform can enter the requested state.
+ *	This is common code that is called for each state that we're entering.
+ *	Run suspend notifiers, allocate a console and stop all processes.
  */
-
-static int suspend_prepare(suspend_state_t state)
+static int suspend_prepare(void)
 {
 	int error;
 	unsigned int free_pages;
@@ -92,38 +89,18 @@ static int suspend_prepare(suspend_state
 		goto Thaw;
 	}
 
-	if ((free_pages = global_page_state(NR_FREE_PAGES))
-			< FREE_PAGE_NUMBER) {
+	free_pages = global_page_state(NR_FREE_PAGES);
+	if (free_pages < FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
 		shrink_all_memory(FREE_PAGE_NUMBER - free_pages);
 		if (nr_free_pages() < FREE_PAGE_NUMBER) {
 			error = -ENOMEM;
 			printk(KERN_ERR "PM: No enough memory\n");
-			goto Thaw;
 		}
 	}
-
-	suspend_console();
-	error = device_suspend(PMSG_SUSPEND);
-	if (error) {
-		printk(KERN_ERR "Some devices failed to suspend\n");
-		goto Resume_console;
-	}
-	if (pm_ops->prepare) {
-		if ((error = pm_ops->prepare(state)))
-			goto Resume_devices;
-	}
-
-	error = disable_nonboot_cpus();
 	if (!error)
 		return 0;
 
-	enable_nonboot_cpus();
-	pm_finish(state);
- Resume_devices:
-	device_resume();
- Resume_console:
-	resume_console();
  Thaw:
 	thaw_processes();
 	pm_restore_console();
@@ -144,6 +121,12 @@ void __attribute__ ((weak)) arch_suspend
 	local_irq_enable();
 }
 
+/**
+ *	suspend_enter - enter the desired system sleep state.
+ *	@state:		state to enter
+ *
+ *	This function should be called after devices have been suspended.
+ */
 int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
@@ -163,21 +146,50 @@ int suspend_enter(suspend_state_t state)
 	return error;
 }
 
+/**
+ *	suspend_devices_and_enter - suspend devices and enter the desired system sleep
+ *			  state.
+ *	@state:		  state to enter
+ */
+int suspend_devices_and_enter(suspend_state_t state)
+{
+	int error;
+
+	if (!pm_ops)
+		return -ENOSYS;
+
+	suspend_console();
+	error = device_suspend(PMSG_SUSPEND);
+	if (error) {
+		printk(KERN_ERR "Some devices failed to suspend\n");
+		goto Resume_console;
+	}
+	if (pm_ops->prepare) {
+		error = pm_ops->prepare(state);
+		if (error)
+			goto Resume_devices;
+	}
+	error = disable_nonboot_cpus();
+	if (!error)
+		suspend_enter(state);
+
+	enable_nonboot_cpus();
+	pm_finish(state);
+ Resume_devices:
+	device_resume();
+ Resume_console:
+	resume_console();
+	return error;
+}
 
 /**
  *	suspend_finish - Do final work before exiting suspend sequence.
- *	@state:		State we're coming out of.
  *
  *	Call platform code to clean up, restart processes, and free the 
  *	console that we've allocated. This is not called for suspend-to-disk.
  */
-
-static void suspend_finish(suspend_state_t state)
+static void suspend_finish(void)
 {
-	enable_nonboot_cpus();
-	pm_finish(state);
-	device_resume();
-	resume_console();
 	thaw_processes();
 	pm_restore_console();
 	pm_notifier_call_chain(PM_POST_SUSPEND);
@@ -212,7 +224,6 @@ static inline int valid_state(suspend_st
  *	Then, do the setup for suspend, enter the state, and cleaup (after
  *	we've woken up).
  */
-
 static int enter_state(suspend_state_t state)
 {
 	int error;
@@ -223,14 +234,14 @@ static int enter_state(suspend_state_t s
 		return -EBUSY;
 
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
-	if ((error = suspend_prepare(state)))
+	if ((error = suspend_prepare()))
 		goto Unlock;
 
 	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
-	error = suspend_enter(state);
+	error = suspend_devices_and_enter(state);
 
 	pr_debug("PM: Finishing wakeup.\n");
-	suspend_finish(state);
+	suspend_finish();
  Unlock:
 	mutex_unlock(&pm_mutex);
 	return error;
diff -puN kernel/power/power.h~pm-reduce-code-duplication-between-mainc-and-userc kernel/power/power.h
--- a/kernel/power/power.h~pm-reduce-code-duplication-between-mainc-and-userc
+++ a/kernel/power/power.h
@@ -170,7 +170,6 @@ extern int swsusp_resume(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
 extern void swsusp_close(void);
-extern int suspend_enter(suspend_state_t state);
 
 struct timeval;
 /* kernel/power/swsusp.c */
@@ -178,6 +177,8 @@ extern void swsusp_show_speed(struct tim
 				unsigned int, char *);
 
 /* kernel/power/main.c */
+extern int suspend_enter(suspend_state_t state);
+extern int suspend_devices_and_enter(suspend_state_t state);
 extern struct blocking_notifier_head pm_chain_head;
 
 static inline int pm_notifier_call_chain(unsigned long val)
diff -puN kernel/power/user.c~pm-reduce-code-duplication-between-mainc-and-userc kernel/power/user.c
--- a/kernel/power/user.c~pm-reduce-code-duplication-between-mainc-and-userc
+++ a/kernel/power/user.c
@@ -255,47 +255,19 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_S2RAM:
-		if (!pm_ops) {
-			error = -ENOSYS;
-			break;
-		}
-
 		if (!data->frozen) {
 			error = -EPERM;
 			break;
 		}
-
 		if (!mutex_trylock(&pm_mutex)) {
 			error = -EBUSY;
 			break;
 		}
-
-		if (pm_ops->prepare) {
-			error = pm_ops->prepare(PM_SUSPEND_MEM);
-			if (error)
-				goto OutS3;
-		}
-
-		/* Put devices to sleep */
-		suspend_console();
-		error = device_suspend(PMSG_SUSPEND);
-		if (error) {
-			printk(KERN_ERR "Failed to suspend some devices.\n");
-		} else {
-			error = disable_nonboot_cpus();
-			if (!error) {
-				/* Enter S3, system is already frozen */
-				suspend_enter(PM_SUSPEND_MEM);
-				enable_nonboot_cpus();
-			}
-			/* Wake up devices */
-			device_resume();
-		}
-		resume_console();
-		if (pm_ops->finish)
-			pm_ops->finish(PM_SUSPEND_MEM);
-
- OutS3:
+		/*
+		 * Tasks are frozen and the notifiers have been called with
+		 * PM_HIBERNATION_PREPARE
+		 */
+		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
 		mutex_unlock(&pm_mutex);
 		break;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
pm-introduce-set_target-method-in-pm_ops.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
pm-reduce-code-duplication-between-mainc-and-userc.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
shrink_slab-handle-bad-shrinkers.patch
beeping-patch-for-debugging-acpi-sleep.patch
