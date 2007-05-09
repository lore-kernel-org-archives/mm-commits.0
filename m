From: akpm@linux-foundation.org
Subject: - freezer-task-exit_state-should-be-treated-as-bolean.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:23 -0700
Message-ID: <200705090244.l492iNBQ008585@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbXEICow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, nickpiggin@yahoo.com.au, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     freezer: task->exit_state should be treated as bolean
has been removed from the -mm tree.  Its filename was
     freezer-task-exit_state-should-be-treated-as-bolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer: task->exit_state should be treated as bolean
From: Oleg Nesterov <oleg@tv-sign.ru>

Except for BUG_ON() checks, we should not use EXIT_XXXX defines outside of
exit/wait paths.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/power/process.c~freezer-task-exit_state-should-be-treated-as-bolean kernel/power/process.c
--- a/kernel/power/process.c~freezer-task-exit_state-should-be-treated-as-bolean
+++ a/kernel/power/process.c
@@ -25,10 +25,9 @@
 
 static inline int freezeable(struct task_struct * p)
 {
-	if ((p == current) || 
+	if ((p == current) ||
 	    (p->flags & PF_NOFREEZE) ||
-	    (p->exit_state == EXIT_ZOMBIE) ||
-	    (p->exit_state == EXIT_DEAD))
+	    (p->exit_state != 0))
 		return 0;
 	return 1;
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
dm-raid1-one-kmirrord-per-mirror.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
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
make-cancel_rearming_delayed_work-reliable-spelling.patch
make-cancel_rearming_delayed_work-reliable-fix.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
dont-init-pgrp-and-__session-in-init_signals.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
vmstat-use-our-own-timer-events-fix.patch
