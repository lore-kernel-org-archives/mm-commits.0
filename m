From: akpm@linux-foundation.org
Subject: - do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:07 -0700
Message-ID: <200710180703.l9I737cT031406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761479AbXJRHq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, akinobu.mita@gmail.com, cpw@sgi.com, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(tasklist)
has been removed from the -mm tree.  Its filename was
     do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/sched.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN kernel/sched.c~do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist kernel/sched.c
--- a/kernel/sched.c~do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist
+++ a/kernel/sched.c
@@ -5060,6 +5060,17 @@ wait_to_die:
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
+{
+	int ret;
+
+	local_irq_disable();
+	ret = __migrate_task(p, src_cpu, dest_cpu);
+	local_irq_enable();
+	return ret;
+}
+
 /*
  * Figure out where task on dead CPU should go, use force if neccessary.
  * NOTE: interrupts should be disabled by the caller
@@ -5098,7 +5109,7 @@ static void move_task_off_dead_cpu(int d
 				       "longer affine to cpu%d\n",
 				       p->pid, p->comm, dead_cpu);
 		}
-	} while (!__migrate_task(p, dead_cpu, dest_cpu));
+	} while (!__migrate_task_irq(p, dead_cpu, dest_cpu));
 }
 
 /*
@@ -5126,7 +5137,7 @@ static void migrate_live_tasks(int src_c
 {
 	struct task_struct *p, *t;
 
-	write_lock_irq(&tasklist_lock);
+	read_lock(&tasklist_lock);
 
 	do_each_thread(t, p) {
 		if (p == current)
@@ -5136,7 +5147,7 @@ static void migrate_live_tasks(int src_c
 			move_task_off_dead_cpu(src_cpu, p);
 	} while_each_thread(t, p);
 
-	write_unlock_irq(&tasklist_lock);
+	read_unlock(&tasklist_lock);
 }
 
 /*
@@ -5214,11 +5225,10 @@ static void migrate_dead(unsigned int de
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
