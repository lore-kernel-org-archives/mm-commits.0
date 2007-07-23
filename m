From: akpm@linux-foundation.org
Subject: + freezer-do-not-send-signals-to-kernel-threads.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:48:19 -0700
Message-ID: <200707232348.l6NNmJPO018381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761230AbXGWXse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz


The patch titled
     freezer: do not send signals to kernel threads
has been added to the -mm tree.  Its filename is
     freezer-do-not-send-signals-to-kernel-threads.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: do not send signals to kernel threads
From: Rafael J. Wysocki <rjw@sisk.pl>

The freezer should not send signals to kernel threads, since that may lead to
subtle problems.  In particular, commit
b74d0deb968e1f85942f17080eace015ce3c332c has changed recalc_sigpending_tsk()
so that it doesn't clear TIF_SIGPENDING.  For this reason, if the freezer
continues to send fake signals to kernel threads and the freezing of kernel
threads fails, some of them may be running with TIF_SIGPENDING set forever.

Accordingly, recalc_sigpending_tsk() shouldn't set the task's TIF_SIGPENDING
flag if TIF_FREEZE is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/freezing-of-tasks.txt |   31 +++--
 kernel/power/process.c                    |  107 +++++++++++++-------
 kernel/signal.c                           |    1 
 3 files changed, 93 insertions(+), 46 deletions(-)

diff -puN Documentation/power/freezing-of-tasks.txt~freezer-do-not-send-signals-to-kernel-threads Documentation/power/freezing-of-tasks.txt
--- a/Documentation/power/freezing-of-tasks.txt~freezer-do-not-send-signals-to-kernel-threads
+++ a/Documentation/power/freezing-of-tasks.txt
@@ -19,12 +19,13 @@ we only consider hibernation, but the de
 Namely, as the first step of the hibernation procedure the function
 freeze_processes() (defined in kernel/power/process.c) is called.  It executes
 try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable tasks and
-sends a fake signal to each of them.  A task that receives such a signal and has
-TIF_FREEZE set, should react to it by calling the refrigerator() function
-(defined in kernel/power/process.c), which sets the task's PF_FROZEN flag,
-changes its state to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is
-cleared for it.  Then, we say that the task is 'frozen' and therefore the set of
-functions handling this mechanism is called 'the freezer' (these functions are
+either wakes them up, if they are kernel threads, or sends fake signals to them,
+if they are user space processes.  A task that has TIF_FREEZE set, should react
+to it by calling the function called refrigerator() (defined in
+kernel/power/process.c), which sets the task's PF_FROZEN flag, changes its state
+to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is cleared for it.
+Then, we say that the task is 'frozen' and therefore the set of functions
+handling this mechanism is referred to as 'the freezer' (these functions are
 defined in kernel/power/process.c and include/linux/freezer.h).  User space
 processes are generally frozen before kernel threads.
 
@@ -35,21 +36,27 @@ task enter refrigerator() if the flag is
 
 For user space processes try_to_freeze() is called automatically from the
 signal-handling code, but the freezable kernel threads need to call it
-explicitly in suitable places.  The code to do this may look like the following:
+explicitly in suitable places or use the wait_event_freezable() or
+wait_event_freezable_timeout() macros (defined in include/linux/freezer.h)
+that combine interruptible sleep with checking if TIF_FREEZE is set and calling
+try_to_freeze().  The main loop of a freezable kernel thread may look like the
+following one:
 
+	set_freezable();
 	do {
 		hub_events();
-		wait_event_interruptible(khubd_wait,
-					!list_empty(&hub_event_list));
-		try_to_freeze();
-	} while (!signal_pending(current));
+		wait_event_freezable(khubd_wait,
+				!list_empty(&hub_event_list) ||
+				kthread_should_stop());
+	} while (!kthread_should_stop() || !list_empty(&hub_event_list));
 
 (from drivers/usb/core/hub.c::hub_thread()).
 
 If a freezable kernel thread fails to call try_to_freeze() after the freezer has
 set TIF_FREEZE for it, the freezing of tasks will fail and the entire
 hibernation operation will be cancelled.  For this reason, freezable kernel
-threads must call try_to_freeze() somewhere.
+threads must call try_to_freeze() somewhere or use one of the
+wait_event_freezable() and wait_event_freezable_timeout() macros.
 
 After the system memory state has been restored from a hibernation image and
 devices have been reinitialized, the function thaw_processes() is called in
diff -puN kernel/power/process.c~freezer-do-not-send-signals-to-kernel-threads kernel/power/process.c
--- a/kernel/power/process.c~freezer-do-not-send-signals-to-kernel-threads
+++ a/kernel/power/process.c
@@ -75,21 +75,79 @@ void refrigerator(void)
 	__set_current_state(save);
 }
 
-static void freeze_task(struct task_struct *p)
+static void fake_signal_wake_up(struct task_struct *p, int resume)
 {
 	unsigned long flags;
 
-	if (!freezing(p)) {
+	spin_lock_irqsave(&p->sighand->siglock, flags);
+	signal_wake_up(p, resume);
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+}
+
+static void send_fake_signal(struct task_struct *p)
+{
+	if (p->state == TASK_STOPPED)
+		force_sig_specific(SIGSTOP, p);
+	fake_signal_wake_up(p, p->state == TASK_STOPPED);
+}
+
+static int has_mm(struct task_struct *p)
+{
+	return (p->mm && !(p->flags & PF_BORROWED_MM));
+}
+
+/**
+ *	freeze_task - send a freeze request to given task
+ *	@p: task to send the request to
+ *	@with_mm_only: if set, the request will only be sent if the task has its
+ *		own mm
+ *	Return value: 0, if @with_mm_only is set and the task has no mm of its
+ *		own or the task is frozen, 1, otherwise
+ *
+ *	The freeze request is sent by seting the tasks's TIF_FREEZE flag and
+ *	either sending a fake signal to it or waking it up, depending on whether
+ *	or not it has its own mm (ie. it is a user land task).  If @with_mm_only
+ *	is set and the task has no mm of its own (ie. it is a kernel thread),
+ *	its TIF_FREEZE flag should not be set.
+ *
+ *	The task_lock() is necessary to prevent races with exit_mm() or
+ *	use_mm()/unuse_mm() from occuring.
+ */
+static int freeze_task(struct task_struct *p, int with_mm_only)
+{
+	int ret = 1;
+
+	task_lock(p);
+	if (freezing(p)) {
+		if (has_mm(p)) {
+			if (!signal_pending(p))
+				fake_signal_wake_up(p, 0);
+		} else {
+			if (with_mm_only)
+				ret = 0;
+			else
+				wake_up_state(p, TASK_INTERRUPTIBLE);
+		}
+	} else {
 		rmb();
-		if (!frozen(p)) {
-			set_freeze_flag(p);
-			if (p->state == TASK_STOPPED)
-				force_sig_specific(SIGSTOP, p);
-			spin_lock_irqsave(&p->sighand->siglock, flags);
-			signal_wake_up(p, p->state == TASK_STOPPED);
-			spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		if (frozen(p)) {
+			ret = 0;
+		} else {
+			if (has_mm(p)) {
+				set_freeze_flag(p);
+				send_fake_signal(p);
+			} else {
+				if (with_mm_only) {
+					ret = 0;
+				} else {
+					set_freeze_flag(p);
+					wake_up_state(p, TASK_INTERRUPTIBLE);
+				}
+			}
 		}
 	}
+	task_unlock(p);
+	return ret;
 }
 
 static void cancel_freezing(struct task_struct *p)
@@ -119,31 +177,14 @@ static int try_to_freeze_tasks(int freez
 			if (frozen(p) || !freezeable(p))
 				continue;
 
-			if (freeze_user_space) {
-				if (p->state == TASK_TRACED &&
-				    frozen(p->parent)) {
-					cancel_freezing(p);
-					continue;
-				}
-				/*
-				 * Kernel threads should not have TIF_FREEZE set
-				 * at this point, so we must ensure that either
-				 * p->mm is not NULL *and* PF_BORROWED_MM is
-				 * unset, or TIF_FRREZE is left unset.
-				 * The task_lock() is necessary to prevent races
-				 * with exit_mm() or use_mm()/unuse_mm() from
-				 * occuring.
-				 */
-				task_lock(p);
-				if (!p->mm || (p->flags & PF_BORROWED_MM)) {
-					task_unlock(p);
-					continue;
-				}
-				freeze_task(p);
-				task_unlock(p);
-			} else {
-				freeze_task(p);
+			if (p->state == TASK_TRACED && frozen(p->parent)) {
+				cancel_freezing(p);
+				continue;
 			}
+
+			if (!freeze_task(p, freeze_user_space))
+				continue;
+
 			if (!freezer_should_skip(p))
 				todo++;
 		} while_each_thread(g, p);
diff -puN kernel/signal.c~freezer-do-not-send-signals-to-kernel-threads kernel/signal.c
--- a/kernel/signal.c~freezer-do-not-send-signals-to-kernel-threads
+++ a/kernel/signal.c
@@ -99,7 +99,6 @@ static inline int has_pending_signals(si
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
 	if (t->signal->group_stop_count > 0 ||
-	    (freezing(t)) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
shrink_slab-handle-bad-shrinkers.patch
