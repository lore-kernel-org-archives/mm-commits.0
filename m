From: akpm@osdl.org
Subject: + workqueue-dont-clear-cwq-thread-until-it-exits.patch added to -mm tree
Date: Thu, 11 Jan 2007 15:58:48 -0800
Message-ID: <200701112358.l0BNwm0Y007097@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822AbXAKX7J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 18:59:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, venkatesh.pallipadi@intel.com


The patch titled
     workqueue: don't clear cwq->thread until it exits
has been added to the -mm tree.  Its filename is
     workqueue-dont-clear-cwq-thread-until-it-exits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: don't clear cwq->thread until it exits
From: Oleg Nesterov <oleg@tv-sign.ru>

Pointed out by Srivatsa Vaddagiri.

cleanup_workqueue_thread() sets cwq->thread = NULL and does kthread_stop().
This breaks the "if (cwq->thread == current)" logic in flush_cpu_workqueue()
and leads to deadlock.

Kill the thead first, then clear cwq->thread. workqueue_mutex protects us
from create_workqueue_thread() so we don't need cwq->lock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff -puN kernel/workqueue.c~workqueue-dont-clear-cwq-thread-until-it-exits kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-dont-clear-cwq-thread-until-it-exits
+++ a/kernel/workqueue.c
@@ -625,17 +625,12 @@ EXPORT_SYMBOL_GPL(__create_workqueue);
 
 static void cleanup_workqueue_thread(struct workqueue_struct *wq, int cpu)
 {
-	struct cpu_workqueue_struct *cwq;
-	unsigned long flags;
-	struct task_struct *p;
+	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
-	cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	spin_lock_irqsave(&cwq->lock, flags);
-	p = cwq->thread;
-	cwq->thread = NULL;
-	spin_unlock_irqrestore(&cwq->lock, flags);
-	if (p)
-		kthread_stop(p);
+	if (cwq->thread) {
+		kthread_stop(cwq->thread);
+		cwq->thread = NULL;
+	}
 }
 
 /**
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-block.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
