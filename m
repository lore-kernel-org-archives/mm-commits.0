From: akpm@linux-foundation.org
Subject: + do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:46:03 -0700
Message-ID: <200708242346.l7ONk31P020813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757361AbXHXXqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, akinobu.mita@gmail.com, cpw@sgi.com, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com


The patch titled
     do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(tasklist)
has been added to the -mm tree.  Its filename is
     do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(tasklist)
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently move_task_off_dead_cpu() is called under
write_lock_irq(tasklist).  This means it can't use task_lock() which is
needed to improve migrating to take task's ->cpuset into account.

Change the code to call move_task_off_dead_cpu() with irqs enabled, and
change migrate_live_tasks() to use read_lock(tasklist).

This all is a preparation for the futher changes proposed by Cliff Wickman, see
	http://marc.info/?t=117327786100003

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff -puN kernel/sched.c~do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist kernel/sched.c
--- a/kernel/sched.c~do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist
+++ a/kernel/sched.c
@@ -5099,7 +5099,7 @@ static void move_task_off_dead_cpu(int d
 	unsigned long flags;
 	cpumask_t mask;
 	struct rq *rq;
-	int dest_cpu;
+	int dest_cpu, done;
 
 restart:
 	/* On same node? */
@@ -5128,7 +5128,11 @@ restart:
 			       "longer affine to cpu%d\n",
 			       p->pid, p->comm, dead_cpu);
 	}
-	if (!__migrate_task(p, dead_cpu, dest_cpu))
+
+	local_irq_disable();
+	done = __migrate_task(p, dead_cpu, dest_cpu);
+	local_irq_enable();
+	if (!done)
 		goto restart;
 }
 
@@ -5157,7 +5161,7 @@ static void migrate_live_tasks(int src_c
 {
 	struct task_struct *p, *t;
 
-	write_lock_irq(&tasklist_lock);
+	read_lock(&tasklist_lock);
 
 	do_each_thread(t, p) {
 		if (p == current)
@@ -5167,7 +5171,7 @@ static void migrate_live_tasks(int src_c
 			move_task_off_dead_cpu(src_cpu, p);
 	} while_each_thread(t, p);
 
-	write_unlock_irq(&tasklist_lock);
+	read_unlock(&tasklist_lock);
 }
 
 /*
@@ -5231,11 +5235,10 @@ static void migrate_dead(unsigned int de
 	 * Drop lock around migration; if someone else moves it,
 	 * that's OK.  No task can be added to this CPU, so iteration is
 	 * fine.
-	 * NOTE: interrupts should be left disabled  --dev@
 	 */
-	spin_unlock(&rq->lock);
+	spin_unlock_irq(&rq->lock);
 	move_task_off_dead_cpu(dead_cpu, p);
-	spin_lock(&rq->lock);
+	spin_lock_irq(&rq->lock);
 
 	put_task_struct(p);
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
setpgidchild-fails-if-the-child-was-forked-by-sub-thread.patch
sigqueue_free-fix-the-race-with-collect_signal.patch
git-dvb.patch
rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
zap_other_threads-dont-optimize-thread_group_empty-case.patch
wait_task_zombie-dont-fight-with-non-existing-race-with-a-dying-ptracee.patch
__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
exec-simplify-sighand-switching.patch
exec-simplify-the-new-sighand-allocation.patch
exec-consolidate-2-fast-paths.patch
exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch
do_sigaction-dont-worry-about-signal_pending.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
make-access-to-tasks-nsproxy-lighter.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
fix-tsk-exit_state-usage-resend.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
