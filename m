From: akpm@linux-foundation.org
Subject: - workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:12:13 -0800
Message-ID: <200703060112.l261CDr1007274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44303 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738AbXCFBM3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:12:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     workqueue-dont-save-interrupts-in-run_workqueue-update 2
has been removed from the -mm tree.  Its filename was
     workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch

This patch was dropped because it was folded into workqueue-dont-save-interrupts-in-run_workqueue.patch

------------------------------------------------------
Subject: workqueue-dont-save-interrupts-in-run_workqueue-update 2
From: Oleg Nesterov <oleg@tv-sign.ru>

Add might_sleep() checks to flush_xxx() functions.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN kernel/workqueue.c~workqueue-dont-save-interrupts-in-run_workqueue-update-2 kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-dont-save-interrupts-in-run_workqueue-update-2
+++ a/kernel/workqueue.c
@@ -393,6 +393,8 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
+	might_sleep();
+
 	if (is_single_threaded(wq))
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
 	else {
@@ -439,6 +441,8 @@ void flush_work(struct workqueue_struct 
 {
 	struct cpu_workqueue_struct *cwq;
 
+	might_sleep();
+
 	cwq = get_wq_data(work);
 	/* Was it ever queued ? */
 	if (!cwq)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
bonding-replace-system-timer-with-work-queue.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-refrigerator-vs-thaw_process-race.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
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
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch
workqueue-introduce-wq_per_cpu-helper.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
workqueue-kill-noautorel-works.patch
worker_thread-dont-play-with-signals.patch
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
