From: akpm@linux-foundation.org
Subject: - add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch removed from -mm tree
Date: Wed, 09 May 2007 02:18:30 -0700
Message-ID: <200705090918.l499IUSX018992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbXEIJTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     add-suspend-related-notifications-for-cpu-hotplug-cleanup
has been removed from the -mm tree.  Its filename was
     add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch

This patch was dropped because it was folded into add-suspend-related-notifications-for-cpu-hotplug.patch

------------------------------------------------------
Subject: add-suspend-related-notifications-for-cpu-hotplug-cleanup
From: Oleg Nesterov <oleg@tv-sign.ru>

Oops. I completely misread the ->cpus_allowed check in try_to_wake_up(), and
so workqueue_cpu_callback() needs a simple fix: CPU_UP_CANCELED should rebind
cwq->thread. Or, better, we should not bind the task until CPU_ONLINE.

I'll send the patch soon, but it conflicts with Rafael's

	add-suspend-related-notifications-for-cpu-hotplug.patch

, so I am sending this cleanup first to make them independent.

Actually, I believe almost all subsystems could be simplified as well, most
of them don't care about CPU_TASKS_FROZEN bit.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/workqueue.c~add-suspend-related-notifications-for-cpu-hotplug-cleanup kernel/workqueue.c
--- a/kernel/workqueue.c~add-suspend-related-notifications-for-cpu-hotplug-cleanup
+++ a/kernel/workqueue.c
@@ -757,6 +757,8 @@ static int __devinit workqueue_cpu_callb
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
 
+	action &= ~CPU_TASKS_FROZEN;
+
 	switch (action) {
 	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&workqueue_mutex);
@@ -767,7 +769,6 @@ static int __devinit workqueue_cpu_callb
 		return NOTIFY_OK;
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		cpu_set(cpu, cpu_populated_map);
 	}
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
dm-raid1-one-kmirrord-per-mirror.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
relay-use-plain-timer-instead-of-delayed-work.patch
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
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
make-cancel_rearming_delayed_work-reliable.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
vmstat-use-our-own-timer-events.patch
