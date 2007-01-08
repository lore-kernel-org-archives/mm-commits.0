From: akpm@osdl.org
Subject: + flush_cpu_workqueue-dont-flush-an-empty-worklist.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:51:12 -0800
Message-ID: <200701082351.l08NpCqV023177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbXAHXvd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com


The patch titled
     flush_cpu_workqueue: don't flush an empty ->worklist
has been added to the -mm tree.  Its filename is
     flush_cpu_workqueue-dont-flush-an-empty-worklist.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: flush_cpu_workqueue: don't flush an empty ->worklist
From: Oleg Nesterov <oleg@tv-sign.ru>

Now when we have ->current_work we can avoid adding a barrier and waiting
for its completition when cwq's queue is empty.

Note: this change is also useful if we change flush_workqueue() to also
check the dead CPUs.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff -puN kernel/workqueue.c~flush_cpu_workqueue-dont-flush-an-empty-worklist kernel/workqueue.c
--- a/kernel/workqueue.c~flush_cpu_workqueue-dont-flush-an-empty-worklist
+++ a/kernel/workqueue.c
@@ -404,12 +404,15 @@ static void wq_barrier_func(struct work_
 	complete(&barr->done);
 }
 
-static inline void init_wq_barrier(struct wq_barrier *barr)
+static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
+					struct wq_barrier *barr, int tail)
 {
 	INIT_WORK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
 
 	init_completion(&barr->done);
+
+	insert_work(cwq, &barr->work, tail);
 }
 
 static void flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
@@ -428,13 +431,20 @@ static void flush_cpu_workqueue(struct c
 		preempt_disable();
 	} else {
 		struct wq_barrier barr;
+		int active = 0;
 
-		init_wq_barrier(&barr);
-		__queue_work(cwq, &barr.work);
+		spin_lock_irq(&cwq->lock);
+		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
+			insert_wq_barrier(cwq, &barr, 1);
+			active = 1;
+		}
+		spin_unlock_irq(&cwq->lock);
 
-		preempt_enable();	/* Can no longer touch *cwq */
-		wait_for_completion(&barr.done);
-		preempt_disable();
+		if (active) {
+			preempt_enable();
+			wait_for_completion(&barr.done);
+			preempt_disable();
+		}
 	}
 }
 
@@ -475,8 +485,7 @@ static void wait_on_work(struct cpu_work
 
 	spin_lock_irq(&cwq->lock);
 	if (unlikely(cwq->current_work == work)) {
-		init_wq_barrier(&barr);
-		insert_work(cwq, &barr.work, 0);
+		insert_wq_barrier(cwq, &barr, 0);
 		running = 1;
 	}
 	spin_unlock_irq(&cwq->lock);
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
fix-flush_workqueue-vs-cpu_dead-race.patch
