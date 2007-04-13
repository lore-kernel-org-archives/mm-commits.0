From: akpm@linux-foundation.org
Subject: + wait_for_helper-remove-unneeded-do_sigaction.patch added to -mm tree
Date: Fri, 13 Apr 2007 13:53:17 -0700
Message-ID: <200704132053.l3DKrHIb009146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50885 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXDMUxc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 16:53:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, rusty@rustcorp.com.au


The patch titled
     wait_for_helper: remove unneeded do_sigaction()
has been added to the -mm tree.  Its filename is
     wait_for_helper-remove-unneeded-do_sigaction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wait_for_helper: remove unneeded do_sigaction()
From: Oleg Nesterov <oleg@tv-sign.ru>

allow_signal(SIGCHLD) does all necessary job, no need to call do_sigaction()
prior to.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    5 -----
 1 files changed, 5 deletions(-)

diff -puN kernel/kmod.c~wait_for_helper-remove-unneeded-do_sigaction kernel/kmod.c
--- a/kernel/kmod.c~wait_for_helper-remove-unneeded-do_sigaction
+++ a/kernel/kmod.c
@@ -185,14 +185,9 @@ static int wait_for_helper(void *data)
 {
 	struct subprocess_info *sub_info = data;
 	pid_t pid;
-	struct k_sigaction sa;
 
 	/* Install a handler: if SIGCLD isn't handled sys_wait4 won't
 	 * populate the status, but will return -ECHILD. */
-	sa.sa.sa_handler = SIG_IGN;
-	sa.sa.sa_flags = 0;
-	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
-	do_sigaction(SIGCHLD, &sa, NULL);
 	allow_signal(SIGCHLD);
 
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

kernel-doc-fix-plisth-comments.patch
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
kthread-dont-depend-on-work-queues-take-2.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
usbatm_heavy_init-dont-use-clone_sighand.patch
pnpbios_thread_init-dont-use-clone_sighand.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
dont-init-pgrp-and-__session-in-init_signals.patch
