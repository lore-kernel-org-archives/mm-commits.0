From: akpm@linux-foundation.org
Subject: + kthreads-rework-kthread_stop.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:49:22 -0800
Message-ID: <200901302149.n0ULnMNI025676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbZA3VvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:51:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, hch@lst.de, mingo@elte.hu, rusty@rustcorp.com.au, vgusev@openvz.org, xemul@openvz.org


The patch titled
     kthreads: rework kthread_stop()
has been added to the -mm tree.  Its filename is
     kthreads-rework-kthread_stop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthreads: rework kthread_stop()
From: Oleg Nesterov <oleg@redhat.com>

Based on Eric's patch which in turn was based on my patch.

kthread_stop() has the nasty problems:

- it runs unpredictably long with the global semaphore held.

- it deadlocks if kthread itself does kthread_stop() before it obeys
  the kthread_should_stop() request.

- it is not useable if kthread exits on its own, see for example the
  ugly "wait_to_die:" hack in migration_thread()

- it is not possible to just tell kthread it should stop, we must always
  wait for its exit.

With this patch kthread() allocates all neccesary data (struct kthread) on
its own stack, globals kthread_stop_xxx are deleted.  ->vfork_done is used
as a pointer into "struct kthread", this means kthread_stop() can easily
wait for kthread's exit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Vitaliy Gusev <vgusev@openvz.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   69 ++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 41 deletions(-)

diff -puN kernel/kthread.c~kthreads-rework-kthread_stop kernel/kthread.c
--- a/kernel/kthread.c~kthreads-rework-kthread_stop
+++ a/kernel/kthread.c
@@ -39,17 +39,13 @@ struct kthread_create_info
 	struct list_head list;
 };
 
-struct kthread_stop_info
-{
-	struct task_struct *k;
-	int err;
-	struct completion done;
+struct kthread {
+	int should_stop;
+	struct completion exited;
 };
 
-/* Thread stopping is done by setthing this var: lock serializes
- * multiple kthread_stop calls. */
-static DEFINE_MUTEX(kthread_stop_lock);
-static struct kthread_stop_info kthread_stop_info;
+#define to_kthread(tsk)	\
+	container_of((tsk)->vfork_done, struct kthread, exited)
 
 /**
  * kthread_should_stop - should this kthread return now?
@@ -60,20 +56,22 @@ static struct kthread_stop_info kthread_
  */
 int kthread_should_stop(void)
 {
-	return (kthread_stop_info.k == current);
+	return to_kthread(current)->should_stop;
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
 static int kthread(void *_create)
 {
+	/* Copy data: it's on kthread's stack */
 	struct kthread_create_info *create = _create;
-	int (*threadfn)(void *data);
-	void *data;
-	int ret = -EINTR;
+	int (*threadfn)(void *data) = create->threadfn;
+	void *data = create->data;
+	struct kthread self;
+	int ret;
 
-	/* Copy data: it's on kthread's stack */
-	threadfn = create->threadfn;
-	data = create->data;
+	self.should_stop = 0;
+	init_completion(&self.exited);
+	current->vfork_done = &self.exited;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -81,15 +79,12 @@ static int kthread(void *_create)
 	complete(&create->done);
 	schedule();
 
-	if (!kthread_should_stop())
+	ret = -EINTR;
+	if (!self.should_stop)
 		ret = threadfn(data);
 
-	/* It might have exited on its own, w/o kthread_stop.  Check. */
-	if (kthread_should_stop()) {
-		kthread_stop_info.err = ret;
-		complete(&kthread_stop_info.done);
-	}
-	return 0;
+	/* we can't just return, we must preserve "self" on stack */
+	do_exit(ret);
 }
 
 static void create_kthread(struct kthread_create_info *create)
@@ -199,30 +194,22 @@ EXPORT_SYMBOL(kthread_bind);
  */
 int kthread_stop(struct task_struct *k)
 {
+	struct kthread *kthread;
 	int ret;
 
-	mutex_lock(&kthread_stop_lock);
-
-	/* It could exit after stop_info.k set, but before wake_up_process. */
+	trace_sched_kthread_stop(k);
 	get_task_struct(k);
 
-	trace_sched_kthread_stop(k);
+	kthread = to_kthread(k);
+	barrier(); /* it might have exited */
+	if (k->vfork_done != NULL) {
+		kthread->should_stop = 1;
+		wake_up_process(k);
+		wait_for_completion(&kthread->exited);
+	}
+	ret = k->exit_code;
 
-	/* Must init completion *before* thread sees kthread_stop_info.k */
-	init_completion(&kthread_stop_info.done);
-	smp_wmb();
-
-	/* Now set kthread_should_stop() to true, and wake it up. */
-	kthread_stop_info.k = k;
-	wake_up_process(k);
 	put_task_struct(k);
-
-	/* Once it dies, reset stop ptr, gather result and we're done. */
-	wait_for_completion(&kthread_stop_info.done);
-	kthread_stop_info.k = NULL;
-	ret = kthread_stop_info.err;
-	mutex_unlock(&kthread_stop_lock);
-
 	trace_sched_kthread_stop_ret(ret);
 
 	return ret;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
wait-prevent-exclusive-waiter-starvation.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-cleanup-ptrace-pathes.patch
kthread-dont-looking-for-a-task-in-create_kthread-2.patch
kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

