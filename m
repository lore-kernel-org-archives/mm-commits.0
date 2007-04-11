From: akpm@linux-foundation.org
Subject: - reparent-kernel-threads-to-swapper.patch removed from -mm tree
Date: Tue, 10 Apr 2007 23:49:51 -0700
Message-ID: <200704110649.l3B6npKR030710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33837 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXDKGuX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, ebiederm@xmission.com, holt@sgi.com, jengelh@linux01.gwdg.de, mingo@elte.hu, roland@redhat.com, serge@hallyn.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     reparent kernel threads to swapper
has been removed from the -mm tree.  Its filename was
     reparent-kernel-threads-to-swapper.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: reparent kernel threads to swapper
From: Oleg Nesterov <oleg@tv-sign.ru>

A lot of kernel threads parented to /sbin/init slow down do_wait() when a
non-detached (user-space) process exits.  Change reparent_kthread() to use
init_task as a parent.  Since init_task can't go away, we don't need to put
the caller on init_task.children list.

NOTE: pstree doesn't show kernel threads with this patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~reparent-kernel-threads-to-swapper kernel/exit.c
--- a/kernel/exit.c~reparent-kernel-threads-to-swapper
+++ a/kernel/exit.c
@@ -257,11 +257,11 @@ static int has_stopped_jobs(struct pid *
 }
 
 /**
- * reparent_kthread - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
+ * reparent_kthread - Reparent the calling kernel thread to swapper.
  *
  * If a kernel thread is launched as a result of a system call, or if
- * it ever exits, it should generally reparent itself to init so that
- * it is correctly cleaned up on exit.
+ * it ever exits, it should generally reparent itself so that it is
+ * correctly cleaned up on exit.
  *
  * The various task state such as scheduling policy and priority may have
  * been inherited from a user process, so we reset them to sane values here.
@@ -274,9 +274,8 @@ void reparent_kthread(void)
 
 	ptrace_unlink(current);
 	remove_parent(current);
-	current->parent = init_pid_ns.child_reaper;
+	current->parent = &init_task;
 	current->real_parent = current->parent;
-	add_parent(current);
 
 	/* make the task auto-reap */
 	current->exit_signal = -1;
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
reparent-kernel-threads-to-swapper.patch
dont-init-pgrp-and-__session-in-init_signals.patch
