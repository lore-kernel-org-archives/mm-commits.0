From: akpm@linux-foundation.org
Subject: - migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:10 -0700
Message-ID: <200710180703.l9I73Adv031409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761420AbXJRHqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, akinobu.mita@gmail.com, cpw@sgi.com, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     migration_call(CPU_DEAD): use spin_lock_irq() instead of task_rq_lock()
has been removed from the -mm tree.  Its filename was
     migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: migration_call(CPU_DEAD): use spin_lock_irq() instead of task_rq_lock()
From: Oleg Nesterov <oleg@tv-sign.ru>

Change migration_call(CPU_DEAD) to use direct spin_lock_irq() instead of
task_rq_lock(rq->idle), rq->idle can't change its task_rq().

This makes the code a bit more symmetrical with migrate_dead_tasks()'s path
which uses spin_lock_irq/spin_unlock_irq.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock kernel/sched.c
--- a/kernel/sched.c~migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock
+++ a/kernel/sched.c
@@ -5457,14 +5457,14 @@ migration_call(struct notifier_block *nf
 		kthread_stop(rq->migration_thread);
 		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
-		rq = task_rq_lock(rq->idle, &flags);
+		spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
 		deactivate_task(rq, rq->idle, 0);
 		rq->idle->static_prio = MAX_PRIO;
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
-		task_rq_unlock(rq, &flags);
+		spin_unlock_irq(&rq->lock);
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-x86.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
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
pid-namespaces-allow-cloning-of-new-namespace-merge-fix.patch
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
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
fix-tsk-exit_state-usage-resend.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
