From: akpm@linux-foundation.org
Subject: + pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:12:39 -0700
Message-ID: <200706261912.l5QJCdAR032634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759534AbXFZTOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:14:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz, u.luckas@road.de


The patch titled
     PM: prevent frozen user mode helpers from failing the freezing of tasks
has been added to the -mm tree.  Its filename is
     pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: prevent frozen user mode helpers from failing the freezing of tasks
From: Rafael J. Wysocki <rjw@sisk.pl>

At present, if a user mode helper is running while
usermodehelper_pm_callback() is executed, the helper may be frozen and the
completion in call_usermodehelper_exec() won't be completed until user
space processes are thawed.  As a result, the freezing of kernel threads
may fail, which is not desirable.

Prevent this from happening by introducing a counter of running user mode
helpers and allowing usermodehelper_pm_callback() to succeed for action =
PM_HIBERNATION_PREPARE or action = PM_SUSPEND_PREPARE only if there are no
helpers running.  [Namely, usermodehelper_pm_callback() waits for at most
RUNNING_HELPERS_TIMEOUT for the number of running helpers to become zero
and fails if that doesn't happen.]

Special thanks to Uli Luckas <u.luckas@road.de>, Pavel Machek
<pavel@ucw.cz> and Oleg Nesterov <oleg@tv-sign.ru> for reviewing the
previous versions of this patch and for very useful comments.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Uli Luckas <u.luckas@road.de>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   78 +++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 68 insertions(+), 10 deletions(-)

diff -puN kernel/kmod.c~pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2 kernel/kmod.c
--- a/kernel/kmod.c~pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2
+++ a/kernel/kmod.c
@@ -41,14 +41,6 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
-/*
- * If set, both call_usermodehelper_keys() and call_usermodehelper_pipe() exit
- * immediately returning -EBUSY.  Used for preventing user land processes from
- * being created after the user land has been frozen during a system-wide
- * hibernation or suspend operation.
- */
-static int usermodehelper_disabled;
-
 #ifdef CONFIG_KMOD
 
 /*
@@ -275,15 +267,55 @@ static void __call_usermodehelper(struct
 	}
 }
 
+#ifdef CONFIG_PM
+/*
+ * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
+ * (used for preventing user land processes from being created after the user
+ * land has been frozen during a system-wide hibernation or suspend operation).
+ */
+static int usermodehelper_disabled;
+
+/* Number of helpers running */
+static atomic_t running_helpers = ATOMIC_INIT(0);
+
+/*
+ * Wait queue head used by usermodehelper_pm_callback() to wait for all running
+ * helpers to finish.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
+
+/*
+ * Time to wait for running_helpers to become zero before the setting of
+ * usermodehelper_disabled in usermodehelper_pm_callback() fails
+ */
+#define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
+
 static int usermodehelper_pm_callback(struct notifier_block *nfb,
 					unsigned long action,
 					void *ignored)
 {
+	long retval;
+
 	switch (action) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		usermodehelper_disabled = 1;
-		return NOTIFY_OK;
+		smp_mb();
+		/*
+		 * From now on call_usermodehelper_exec() won't start any new
+		 * helpers, so it is sufficient if running_helpers turns out to
+		 * be zero at one point (it may be increased later, but that
+		 * doesn't matter).
+		 */
+		retval = wait_event_timeout(running_helpers_waitq,
+					atomic_read(&running_helpers) == 0,
+					RUNNING_HELPERS_TIMEOUT);
+		if (retval) {
+			return NOTIFY_OK;
+		} else {
+			usermodehelper_disabled = 0;
+			return NOTIFY_BAD;
+		}
 	case PM_POST_HIBERNATION:
 	case PM_POST_SUSPEND:
 		usermodehelper_disabled = 0;
@@ -293,6 +325,30 @@ static int usermodehelper_pm_callback(st
 	return NOTIFY_DONE;
 }
 
+static void helper_lock(void)
+{
+	atomic_inc(&running_helpers);
+	smp_mb__after_atomic_inc();
+}
+
+static void helper_unlock(void)
+{
+	if (atomic_dec_and_test(&running_helpers))
+		wake_up(&running_helpers_waitq);
+}
+
+static void register_pm_notifier_callback(void)
+{
+	pm_notifier(usermodehelper_pm_callback, 0);
+}
+#else /* CONFIG_PM */
+#define usermodehelper_disabled	0
+
+static inline void helper_lock(void) {}
+static inline void helper_unlock(void) {}
+static inline void register_pm_notifier_callback(void) {}
+#endif /* CONFIG_PM */
+
 /**
  * call_usermodehelper_setup - prepare to call a usermode helper
  * @path - path to usermode executable
@@ -397,6 +453,7 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval;
 
+	helper_lock();
 	if (sub_info->path[0] == '\0') {
 		retval = 0;
 		goto out;
@@ -418,6 +475,7 @@ int call_usermodehelper_exec(struct subp
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
+	helper_unlock();
 	return retval;
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
@@ -459,5 +517,5 @@ void __init usermodehelper_init(void)
 {
 	khelper_wq = create_singlethread_workqueue("khelper");
 	BUG_ON(!khelper_wq);
-	pm_notifier(usermodehelper_pm_callback, 0);
+	register_pm_notifier_callback();
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

x86_64-set-the-irq_chip-name-for-lapic.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs-v2.patch
x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs-v2-fix.patch
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
