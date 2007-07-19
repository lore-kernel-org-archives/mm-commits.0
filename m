From: akpm@linux-foundation.org
Subject: - freezer-avoid-freezing-kernel-threads-prematurely.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:10 -0700
Message-ID: <200707192000.l6JK0ADm019426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758898AbXGSUcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, nigel@nigel.suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Freezer: avoid freezing kernel threads prematurely
has been removed from the -mm tree.  Its filename was
     freezer-avoid-freezing-kernel-threads-prematurely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Freezer: avoid freezing kernel threads prematurely
From: Rafael J. Wysocki <rjw@sisk.pl>

Kernel threads should not have TIF_FREEZE set when user space processes are
being frozen, since otherwise some of them might be frozen prematurely.
To prevent this from happening we can (1) make exit_mm() unset TIF_FREEZE
unconditionally just after clearing tsk->mm and (2) make try_to_freeze_tasks()
check if p->mm is different from zero and PF_BORROWED_MM is unset in p->flags
when user space processes are to be frozen.

Namely, when user space processes are being frozen, we only should set
TIF_FREEZE for tasks that have p->mm different from NULL and don't have
PF_BORROWED_MM set in p->flags.  For this reason task_lock() must be used to
prevent try_to_freeze_tasks() from racing with use_mm()/unuse_mm(), in which
p->mm and p->flags.PF_BORROWED_MM are changed under task_lock(p).  Also, we
need to prevent the following scenario from happening:

* daemonize() is called by a task spawned from a user space code path
* freezer checks if the task has p->mm set and the result is positive
* task enters exit_mm() and clears its TIF_FREEZE
* freezer sets TIF_FREEZE for the task
* task calls try_to_freeze() and goes to the refrigerator, which is wrong at
  that point

This requires us to acquire task_lock(p) before p->flags.PF_BORROWED_MM and
p->mm are examined and release it after TIF_FREEZE is set for p (or it turns
out that TIF_FREEZE should not be set).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    9 ++---
 kernel/exit.c           |    3 +
 kernel/power/process.c  |   64 +++++++++++++++++++-------------------
 3 files changed, 41 insertions(+), 35 deletions(-)

diff -puN include/linux/freezer.h~freezer-avoid-freezing-kernel-threads-prematurely include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-avoid-freezing-kernel-threads-prematurely
+++ a/include/linux/freezer.h
@@ -25,7 +25,7 @@ static inline int freezing(struct task_s
 /*
  * Request that a process be frozen
  */
-static inline void freeze(struct task_struct *p)
+static inline void set_freeze_flag(struct task_struct *p)
 {
 	set_tsk_thread_flag(p, TIF_FREEZE);
 }
@@ -33,7 +33,7 @@ static inline void freeze(struct task_st
 /*
  * Sometimes we may need to cancel the previous 'freeze' request
  */
-static inline void do_not_freeze(struct task_struct *p)
+static inline void clear_freeze_flag(struct task_struct *p)
 {
 	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
@@ -56,7 +56,7 @@ static inline int thaw_process(struct ta
 		wake_up_process(p);
 		return 1;
 	}
-	clear_tsk_thread_flag(p, TIF_FREEZE);
+	clear_freeze_flag(p);
 	task_unlock(p);
 	return 0;
 }
@@ -129,7 +129,8 @@ static inline void set_freezable(void)
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
-static inline void freeze(struct task_struct *p) { BUG(); }
+static inline void set_freeze_flag(struct task_struct *p) {}
+static inline void clear_freeze_flag(struct task_struct *p) {}
 static inline int thaw_process(struct task_struct *p) { return 1; }
 
 static inline void refrigerator(void) {}
diff -puN kernel/exit.c~freezer-avoid-freezing-kernel-threads-prematurely kernel/exit.c
--- a/kernel/exit.c~freezer-avoid-freezing-kernel-threads-prematurely
+++ a/kernel/exit.c
@@ -45,6 +45,7 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -594,6 +595,8 @@ static void exit_mm(struct task_struct *
 	tsk->mm = NULL;
 	up_read(&mm->mmap_sem);
 	enter_lazy_tlb(mm, current);
+	/* We don't want this task to be frozen prematurely */
+	clear_freeze_flag(tsk);
 	task_unlock(tsk);
 	mmput(mm);
 }
diff -puN kernel/power/process.c~freezer-avoid-freezing-kernel-threads-prematurely kernel/power/process.c
--- a/kernel/power/process.c~freezer-avoid-freezing-kernel-threads-prematurely
+++ a/kernel/power/process.c
@@ -40,7 +40,7 @@ static inline void frozen_process(void)
 		current->flags |= PF_FROZEN;
 		wmb();
 	}
-	clear_tsk_thread_flag(current, TIF_FREEZE);
+	clear_freeze_flag(current);
 }
 
 /* Refrigerator is place where frozen processes are stored :-). */
@@ -75,17 +75,16 @@ void refrigerator(void)
 	current->state = save;
 }
 
-static inline void freeze_process(struct task_struct *p)
+static void freeze_task(struct task_struct *p)
 {
 	unsigned long flags;
 
 	if (!freezing(p)) {
 		rmb();
 		if (!frozen(p)) {
+			set_freeze_flag(p);
 			if (p->state == TASK_STOPPED)
 				force_sig_specific(SIGSTOP, p);
-
-			freeze(p);
 			spin_lock_irqsave(&p->sighand->siglock, flags);
 			signal_wake_up(p, p->state == TASK_STOPPED);
 			spin_unlock_irqrestore(&p->sighand->siglock, flags);
@@ -99,18 +98,13 @@ static void cancel_freezing(struct task_
 
 	if (freezing(p)) {
 		pr_debug("  clean up: %s\n", p->comm);
-		do_not_freeze(p);
+		clear_freeze_flag(p);
 		spin_lock_irqsave(&p->sighand->siglock, flags);
 		recalc_sigpending_and_wake(p);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
 
-static inline int is_user_space(struct task_struct *p)
-{
-	return p->mm && !(p->flags & PF_BORROWED_MM);
-}
-
 static unsigned int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
@@ -122,20 +116,34 @@ static unsigned int try_to_freeze_tasks(
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (!freezeable(p))
-				continue;
-
-			if (frozen(p))
+			if (frozen(p) || !freezeable(p))
 				continue;
 
-			if (p->state == TASK_TRACED && frozen(p->parent)) {
-				cancel_freezing(p);
-				continue;
+			if (freeze_user_space) {
+				if (p->state == TASK_TRACED &&
+				    frozen(p->parent)) {
+					cancel_freezing(p);
+					continue;
+				}
+				/*
+				 * Kernel threads should not have TIF_FREEZE set
+				 * at this point, so we must ensure that either
+				 * p->mm is not NULL *and* PF_BORROWED_MM is
+				 * unset, or TIF_FRREZE is left unset.
+				 * The task_lock() is necessary to prevent races
+				 * with exit_mm() or use_mm()/unuse_mm() from
+				 * occuring.
+				 */
+				task_lock(p);
+				if (!p->mm || (p->flags & PF_BORROWED_MM)) {
+					task_unlock(p);
+					continue;
+				}
+				freeze_task(p);
+				task_unlock(p);
+			} else {
+				freeze_task(p);
 			}
-			if (freeze_user_space && !is_user_space(p))
-				continue;
-
-			freeze_process(p);
 			if (!freezer_should_skip(p))
 				todo++;
 		} while_each_thread(g, p);
@@ -152,22 +160,16 @@ static unsigned int try_to_freeze_tasks(
 		 * but it cleans up leftover PF_FREEZE requests.
 		 */
 		printk("\n");
-		printk(KERN_ERR "Stopping %s timed out after %d seconds "
+		printk(KERN_ERR "Freezing of %s timed out after %d seconds "
 				"(%d tasks refusing to freeze):\n",
-				freeze_user_space ? "user space processes" :
-					"kernel threads",
+				freeze_user_space ? "user space " : "tasks ",
 				TIMEOUT / HZ, todo);
 		show_state();
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (freeze_user_space && !is_user_space(p))
-				continue;
-
 			task_lock(p);
-			if (freezeable(p) && !frozen(p) &&
-			    !freezer_should_skip(p))
+			if (freezing(p) && !freezer_should_skip(p))
 				printk(KERN_ERR " %s\n", p->comm);
-
 			cancel_freezing(p);
 			task_unlock(p);
 		} while_each_thread(g, p);
@@ -211,7 +213,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (!freezeable(p))
 			continue;
 
-		if (is_user_space(p) == !thaw_user_space)
+		if (!p->mm == thaw_user_space)
 			continue;
 
 		thaw_process(p);
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
