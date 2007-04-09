From: akpm@linux-foundation.org
Subject: + zap_other_threads-remove-unneeded-exit_signal-change.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:16:23 -0700
Message-ID: <200704091916.l39JGNlQ021124@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56423 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXDITQs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:16:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     zap_other_threads: remove unneeded ->exit_signal change
has been added to the -mm tree.  Its filename is
     zap_other_threads-remove-unneeded-exit_signal-change.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: zap_other_threads: remove unneeded ->exit_signal change
From: Oleg Nesterov <oleg@tv-sign.ru>

We already depend on fact that all sub-threads have ->exit_signal == -1, no
need to set it in zap_other_threads().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 -----------
 1 files changed, 11 deletions(-)

diff -puN kernel/signal.c~zap_other_threads-remove-unneeded-exit_signal-change kernel/signal.c
--- a/kernel/signal.c~zap_other_threads-remove-unneeded-exit_signal-change
+++ a/kernel/signal.c
@@ -1032,17 +1032,6 @@ void zap_other_threads(struct task_struc
 		if (t->exit_state)
 			continue;
 
-		/*
-		 * We don't want to notify the parent, since we are
-		 * killed as part of a thread group due to another
-		 * thread doing an execve() or similar. So set the
-		 * exit signal to -1 to allow immediate reaping of
-		 * the process.  But don't detach the thread group
-		 * leader.
-		 */
-		if (t != p->group_leader)
-			t->exit_signal = -1;
-
 		/* SIGKILL will be handled before any pending SIGSTOP */
 		sigaddset(&t->pending.signal, SIGKILL);
 		signal_wake_up(t, 1);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-dvb.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-refrigerator-vs-thaw_process-race.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
add-a-new-deferrable-delayed-work-init.patch
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
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
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
dont-init-pgrp-and-__session-in-init_signals.patch
