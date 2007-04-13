From: akpm@linux-foundation.org
Subject: + make-kthread_stop-scalable.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:32:30 -0700
Message-ID: <200704132132.l3DLWUmH009924@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53282 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030503AbXDMVch (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     make kthread_stop() scalable
has been added to the -mm tree.  Its filename is
     make-kthread_stop-scalable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make kthread_stop() scalable
From: Oleg Nesterov <oleg@tv-sign.ru>

It's a shame kthread_stop() (may take a while!) runs with a global
semaphore held.  With this patch kthread() allocates all neccesary data
(struct kthread) on its own stack, globals kthread_stop_xxx are deleted.

HACKS:

	- re-use task_struct->set_child_tid to point to "struct kthread"

	- use do_exit() directly to preserve "struct kthread" on stack

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   98 ++++++++++++++++++++++++---------------------
 1 files changed, 54 insertions(+), 44 deletions(-)

diff -puN kernel/kthread.c~make-kthread_stop-scalable kernel/kthread.c
--- a/kernel/kthread.c~make-kthread_stop-scalable
+++ a/kernel/kthread.c
@@ -17,7 +17,25 @@
 
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
-struct task_struct *kthreadd_task;
+struct task_struct *kthreadd_task __read_mostly;
+
+struct kthread {
+	int should_stop;
+	struct task_struct *task;
+
+	struct completion exited;
+	int err;
+};
+
+static inline struct kthread *to_kthread(struct task_struct *t)
+{
+	return (void*)t->set_child_tid;
+}
+
+static inline void set_kthread(struct kthread *self)
+{
+	current->set_child_tid = (void __user*)self;
+}
 
 struct kthread_create_info
 {
@@ -27,24 +45,12 @@ struct kthread_create_info
 	struct completion created;
 	struct completion started;
 
-	/* Result passed back to kthread_create() from kthreadd. */
-	pid_t result;
+	/* Result passed back to kthread_create() from kthread. */
+	struct kthread *result;
 
 	struct list_head list;
 };
 
-struct kthread_stop_info
-{
-	struct task_struct *k;
-	int err;
-	struct completion done;
-};
-
-/* Thread stopping is done by setthing this var: lock serializes
- * multiple kthread_stop calls. */
-static DEFINE_MUTEX(kthread_stop_lock);
-static struct kthread_stop_info kthread_stop_info;
-
 /**
  * kthread_should_stop - should this kthread return now?
  *
@@ -54,20 +60,28 @@ static struct kthread_stop_info kthread_
  */
 int kthread_should_stop(void)
 {
-	return (kthread_stop_info.k == current);
+	return to_kthread(current)->should_stop;
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
 static int kthread(void *_create)
 {
-	struct kthread_create_info *create = _create;
-	int (*threadfn)(void *data);
-	void *data;
-	int ret = -EINTR;
+	struct kthread self = {
+		.task = current,
+		.err = -EINTR,
+	};
 
 	/* Copy data: it's on kthread's stack */
-	threadfn = create->threadfn;
-	data = create->data;
+	struct kthread_create_info *create = _create;
+	int (*threadfn)(void *data) = create->threadfn;
+	void *data = create->data;
+
+	/*
+	 * This should be enough to assure that self is still on
+	 * stack when we enter do_exit()
+	 */
+	set_kthread(&self);
+	create->result = &self;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -75,13 +89,13 @@ static int kthread(void *_create)
 	schedule();
 
 	if (!kthread_should_stop())
-		ret = threadfn(data);
+		self.err = threadfn(data);
 
-	/* It might have exited on its own, w/o kthread_stop.  Check. */
-	if (kthread_should_stop()) {
-		kthread_stop_info.err = ret;
-		complete(&kthread_stop_info.done);
-	}
+	/* It might have exited on its own, w/o kthread_stop. Check. */
+	if (kthread_should_stop())
+		complete(&self.exited);
+
+	do_exit(0);
 	return 0;
 }
 
@@ -91,7 +105,7 @@ static void create_kthread(struct kthrea
 
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
-	create->result = pid;
+	create->result = ERR_PTR(pid);
 
 	complete(&create->created);
 }
@@ -135,11 +149,11 @@ struct task_struct *kthread_create(int (
 	wake_up_process(kthreadd_task);
 
 	wait_for_completion(&create.created);
-	if (create.result < 0)
-		return ERR_PTR(create.result);
+	if (IS_ERR(create.result))
+		return (void*)create.result;
 
 	wait_for_completion(&create.started);
-	ret = find_task_by_pid(create.result);
+	ret = create.result->task;
 
 	va_start(args, namefmt);
 	vsnprintf(ret->comm, sizeof(ret->comm), namefmt, args);
@@ -183,27 +197,23 @@ EXPORT_SYMBOL(kthread_bind);
  */
 int kthread_stop(struct task_struct *k)
 {
+	struct kthread *kthread;
 	int ret;
 
-	mutex_lock(&kthread_stop_lock);
-
 	/* It could exit after stop_info.k set, but before wake_up_process. */
 	get_task_struct(k);
+	kthread = to_kthread(k);
 
-	/* Must init completion *before* thread sees kthread_stop_info.k */
-	init_completion(&kthread_stop_info.done);
+	/* Must init completion *before* thread sees ->should_stop */
+	init_completion(&kthread->exited);
 	smp_wmb();
-
-	/* Now set kthread_should_stop() to true, and wake it up. */
-	kthread_stop_info.k = k;
+	kthread->should_stop = 1;
 	wake_up_process(k);
-	put_task_struct(k);
 
 	/* Once it dies, reset stop ptr, gather result and we're done. */
-	wait_for_completion(&kthread_stop_info.done);
-	kthread_stop_info.k = NULL;
-	ret = kthread_stop_info.err;
-	mutex_unlock(&kthread_stop_lock);
+	wait_for_completion(&kthread->exited);
+	ret = kthread->err;
+	put_task_struct(k);
 
 	return ret;
 }
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
make-kthread_stop-scalable.patch
dont-init-pgrp-and-__session-in-init_signals.patch
