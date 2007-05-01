From: akpm@linux-foundation.org
Subject: + workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch added to -mm tree
Date: Tue, 01 May 2007 15:25:53 -0700
Message-ID: <200705012225.l41MPrjk008108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbXEAW0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 18:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, rjw@sisk.pl


The patch titled
     workqueues: shift kthread_bind() from CPU_UP_PREPARE to CPU_ONLINE
has been added to the -mm tree.  Its filename is
     workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueues: shift kthread_bind() from CPU_UP_PREPARE to CPU_ONLINE
From: Oleg Nesterov <oleg@tv-sign.ru>

CPU_UP_PREPARE binds cwq->thread to the new CPU.  So CPU_UP_CANCELED tries to
wake up the task which is bound to the failed CPU.

With this patch we don't bind cwq->thread until CPU becomes online.  The first
wake_up() after kthread_create() is a bit special, make a simple helper for
that.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff -puN kernel/workqueue.c~workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online
+++ a/kernel/workqueue.c
@@ -668,15 +668,21 @@ static int create_workqueue_thread(struc
 
 	cwq->thread = p;
 	cwq->should_stop = 0;
-	if (!is_single_threaded(wq))
-		kthread_bind(p, cpu);
-
-	if (is_single_threaded(wq) || cpu_online(cpu))
-		wake_up_process(p);
 
 	return 0;
 }
 
+static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
+{
+	struct task_struct *p = cwq->thread;
+
+	if (p != NULL) {
+		if (cpu >= 0)
+			kthread_bind(p, cpu);
+		wake_up_process(p);
+	}
+}
+
 struct workqueue_struct *__create_workqueue(const char *name,
 					    int singlethread, int freezeable)
 {
@@ -702,6 +708,7 @@ struct workqueue_struct *__create_workqu
 	if (singlethread) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
+		start_workqueue_thread(cwq, -1);
 	} else {
 		mutex_lock(&workqueue_mutex);
 		list_add(&wq->list, &workqueues);
@@ -711,6 +718,7 @@ struct workqueue_struct *__create_workqu
 			if (err || !cpu_online(cpu))
 				continue;
 			err = create_workqueue_thread(cwq, cpu);
+			start_workqueue_thread(cwq, cpu);
 		}
 		mutex_unlock(&workqueue_mutex);
 	}
@@ -808,12 +816,11 @@ static int __devinit workqueue_cpu_callb
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
-			wake_up_process(cwq->thread);
+			start_workqueue_thread(cwq, cpu);
 			break;
 
 		case CPU_UP_CANCELED:
-			if (cwq->thread)
-				wake_up_process(cwq->thread);
+			start_workqueue_thread(cwq, -1);
 		case CPU_DEAD:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-dvb.patch
fix-refrigerator-vs-thaw_process-race.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
futex-restartable-futex_wait.patch
add-support-for-deferrable-timers-respun.patch
add-a-new-deferrable-delayed-work-init.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
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
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
workqueue-introduce-wq_per_cpu-helper.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
workqueue-kill-noautorel-works.patch
worker_thread-dont-play-with-signals.patch
worker_thread-fix-racy-try_to_freeze-usage.patch
zap_other_threads-remove-unneeded-exit_signal-change.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
____call_usermodehelper-dont-flush_signals.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
kthread-dont-depend-on-work-queues-take-2.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
usbatm_heavy_init-dont-use-clone_sighand.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
dont-init-pgrp-and-__session-in-init_signals.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
