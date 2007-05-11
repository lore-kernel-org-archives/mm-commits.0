From: akpm@linux-foundation.org
Subject: - freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch removed from -mm tree
Date: Fri, 11 May 2007 12:28:35 -0700
Message-ID: <200705111928.l4BJSZ71024549@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761616AbXEKT3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:29:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, aneesh.kumar@gmail.com, ego@in.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     freezer: close theoretical race between refrigerator and thaw_tasks
has been removed from the -mm tree.  Its filename was
     freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: freezer: close theoretical race between refrigerator and thaw_tasks
From: Rafael J. Wysocki <rjw@sisk.pl>

If the freezing of tasks fails and a task is preempted in refrigerator()
before calling frozen_process(), then thaw_tasks() may run before this task is
frozen.  In that case the task will freeze and no one will thaw it.

To fix this race we can call freezing(current) in refrigerator() along with
frozen_process(current) under the task_lock() which also should be taken in
the error path of try_to_freeze_tasks() as well as in thaw_process(). 
Moreover, if thaw_process() additionally clears TIF_FREEZE for tasks that are
not frozen, we can be sure that all tasks are thawed and there are no pending
"freeze" requests after thaw_tasks() has run.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    4 ++++
 kernel/power/process.c  |   12 +++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN include/linux/freezer.h~freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks
+++ a/include/linux/freezer.h
@@ -40,11 +40,15 @@ static inline void do_not_freeze(struct 
  */
 static inline int thaw_process(struct task_struct *p)
 {
+	task_lock(p);
 	if (frozen(p)) {
 		p->flags &= ~PF_FROZEN;
+		task_unlock(p);
 		wake_up_process(p);
 		return 1;
 	}
+	clear_tsk_thread_flag(p, TIF_FREEZE);
+	task_unlock(p);
 	return 0;
 }
 
diff -puN kernel/power/process.c~freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks kernel/power/process.c
--- a/kernel/power/process.c~freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks
+++ a/kernel/power/process.c
@@ -38,10 +38,18 @@ void refrigerator(void)
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	long save;
+
+	task_lock(current);
+	if (freezing(current)) {
+		frozen_process(current);
+		task_unlock(current);
+	} else {
+		task_unlock(current);
+		return;
+	}
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
-	frozen_process(current);
 	spin_lock_irq(&current->sighand->siglock);
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
@@ -158,10 +166,12 @@ static unsigned int try_to_freeze_tasks(
 			if (is_user_space(p) == !freeze_user_space)
 				continue;
 
+			task_lock(p);
 			if (freezeable(p) && !frozen(p))
 				printk(KERN_ERR " %s\n", p->comm);
 
 			cancel_freezing(p);
+			task_unlock(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 	}
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
