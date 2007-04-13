From: akpm@linux-foundation.org
Subject: + make-kthread_create-more-scalable.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:31:25 -0700
Message-ID: <200704132131.l3DLVP1M009906@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53236 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030495AbXDMVbi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com


The patch titled
     make kthread_create() more scalable
has been added to the -mm tree.  Its filename is
     make-kthread_create-more-scalable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make kthread_create() more scalable
From: Oleg Nesterov <oleg@tv-sign.ru>

If kernel_thread(kthread) succeeds, kthread() can not fail on its path to
complete(&create->started) + schedule(). After that it can't be woken because
nobody can see the new task yet. This means:

	- we don't need tasklist_lock for find_task_by_pid().

	- create_kthread() doesn't need to wait for create->started. Instead,
	  kthread_create() first waits for create->created to get the result of
	  kernel_thread(), then waits for create->started to synchronize with
	  kthread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   42 ++++++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff -puN kernel/kthread.c~make-kthread_create-more-scalable kernel/kthread.c
--- a/kernel/kthread.c~make-kthread_create-more-scalable
+++ a/kernel/kthread.c
@@ -24,11 +24,11 @@ struct kthread_create_info
 	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
+	struct completion created;
 	struct completion started;
 
 	/* Result passed back to kthread_create() from kthreadd. */
-	struct task_struct *result;
-	struct completion done;
+	pid_t result;
 
 	struct list_head list;
 };
@@ -91,15 +91,9 @@ static void create_kthread(struct kthrea
 
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
-	if (pid < 0) {
-		create->result = ERR_PTR(pid);
-	} else {
-		wait_for_completion(&create->started);
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid(pid);
-		read_unlock(&tasklist_lock);
-	}
-	complete(&create->done);
+	create->result = pid;
+
+	complete(&create->created);
 }
 
 /**
@@ -127,27 +121,31 @@ struct task_struct *kthread_create(int (
 				   ...)
 {
 	struct kthread_create_info create;
+	struct task_struct *ret;
+	va_list args;
 
 	create.threadfn = threadfn;
 	create.data = data;
+	init_completion(&create.created);
 	init_completion(&create.started);
-	init_completion(&create.done);
 
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
-	wake_up_process(kthreadd_task);
 	spin_unlock(&kthread_create_lock);
+	wake_up_process(kthreadd_task);
 
-	wait_for_completion(&create.done);
+	wait_for_completion(&create.created);
+	if (create.result < 0)
+		return ERR_PTR(create.result);
+
+	wait_for_completion(&create.started);
+	ret = find_task_by_pid(create.result);
+
+	va_start(args, namefmt);
+	vsnprintf(ret->comm, sizeof(ret->comm), namefmt, args);
+	va_end(args);
 
-	if (!IS_ERR(create.result)) {
-		va_list args;
-		va_start(args, namefmt);
-		vsnprintf(create.result->comm, sizeof(create.result->comm),
-			  namefmt, args);
-		va_end(args);
-	}
-	return create.result;
+	return ret;
 }
 EXPORT_SYMBOL(kthread_create);
 
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
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-kthread_create-more-scalable.patch
dont-init-pgrp-and-__session-in-init_signals.patch
