From: akpm@linux-foundation.org
Subject: - drivers-media-video-cpia_ppc-dont-use-_work_nar.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:10 -0800
Message-ID: <200703152157.l2FLvAPL027615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42371 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbXCOV5j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, dhowells@redhat.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/cpia_pp.c: don't use _WORK_NAR
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cpia_ppc-dont-use-_work_nar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/media/video/cpia_pp.c: don't use _WORK_NAR
From: Oleg Nesterov <oleg@tv-sign.ru>

pp_cam_entry->cb_task need not to be _NOAUTOREL ... because in fact it is
never used ???

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-By: David Howells <dhowells@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cpia_pp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/media/video/cpia_pp.c~drivers-media-video-cpia_ppc-dont-use-_work_nar drivers/media/video/cpia_pp.c
--- a/drivers/media/video/cpia_pp.c~drivers-media-video-cpia_ppc-dont-use-_work_nar
+++ a/drivers/media/video/cpia_pp.c
@@ -141,7 +141,6 @@ static void cpia_pp_run_callback(struct 
 	cam = container_of(work, struct pp_cam_entry, cb_task);
 	cb_func = cam->cb_func;
 	cb_data = cam->cb_data;
-	work_release(work);
 
 	cb_func(cb_data);
 }
@@ -682,7 +681,7 @@ static int cpia_pp_registerCallback(void
 	if(cam->port->irq != PARPORT_IRQ_NONE) {
 		cam->cb_func = cb;
 		cam->cb_data = cbdata;
-		INIT_WORK_NAR(&cam->cb_task, cpia_pp_run_callback);
+		INIT_WORK(&cam->cb_task, cpia_pp_run_callback);
 	} else {
 		retval = -1;
 	}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
git-dvb.patch
bonding-replace-system-timer-with-work-queue.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-refrigerator-vs-thaw_process-race.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
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
