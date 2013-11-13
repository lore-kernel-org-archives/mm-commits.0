From: akpm@linux-foundation.org
Subject: [merged] kthread-make-kthread_create-killable.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:36:56 -0800
Message-ID: <5283e2e8.oLdfyv6BXiQHyr7c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3KMUg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:36:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp

Subject: [merged] kthread-make-kthread_create-killable.patch removed from -mm tree
To: penguin-kernel@I-love.SAKURA.ne.jp,oleg@redhat.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:36:56 -0800


The patch titled
     Subject: kthread: make kthread_create() killable
has been removed from the -mm tree.  Its filename was
     kthread-make-kthread_create-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: kthread: make kthread_create() killable

Any user process callers of wait_for_completion() except global init
process might be chosen by the OOM killer while waiting for completion()
call by some other process which does memory allocation.  See
CVE-2012-4398 "kernel: request_module() OOM local DoS" can happen.

When such users are chosen by the OOM killer when they are waiting for
completion() in TASK_UNINTERRUPTIBLE, the system will be kept stressed due
to memory starvation because the OOM killer cannot kill such users.

kthread_create() is one of such users and this patch fixes the problem for
kthreadd by making kthread_create() killable - the same approach used for
fixing CVE-2012-4398.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   73 +++++++++++++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 18 deletions(-)

diff -puN kernel/kthread.c~kthread-make-kthread_create-killable kernel/kthread.c
--- a/kernel/kthread.c~kthread-make-kthread_create-killable
+++ a/kernel/kthread.c
@@ -33,7 +33,7 @@ struct kthread_create_info
 
 	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
-	struct completion done;
+	struct completion *done;
 
 	struct list_head list;
 };
@@ -178,6 +178,7 @@ static int kthread(void *_create)
 	struct kthread_create_info *create = _create;
 	int (*threadfn)(void *data) = create->threadfn;
 	void *data = create->data;
+	struct completion *done;
 	struct kthread self;
 	int ret;
 
@@ -187,10 +188,16 @@ static int kthread(void *_create)
 	init_completion(&self.parked);
 	current->vfork_done = &self.exited;
 
+	/* If user was SIGKILLed, I release the structure. */
+	done = xchg(&create->done, NULL);
+	if (!done) {
+		kfree(create);
+		do_exit(-EINTR);
+	}
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
 	create->result = current;
-	complete(&create->done);
+	complete(done);
 	schedule();
 
 	ret = -EINTR;
@@ -223,8 +230,15 @@ static void create_kthread(struct kthrea
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
 	if (pid < 0) {
+		/* If user was SIGKILLed, I release the structure. */
+		struct completion *done = xchg(&create->done, NULL);
+
+		if (!done) {
+			kfree(create);
+			return;
+		}
 		create->result = ERR_PTR(pid);
-		complete(&create->done);
+		complete(done);
 	}
 }
 
@@ -255,36 +269,59 @@ struct task_struct *kthread_create_on_no
 					   const char namefmt[],
 					   ...)
 {
-	struct kthread_create_info create;
-
-	create.threadfn = threadfn;
-	create.data = data;
-	create.node = node;
-	init_completion(&create.done);
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct task_struct *task;
+	struct kthread_create_info *create = kmalloc(sizeof(*create),
+						     GFP_KERNEL);
+
+	if (!create)
+		return ERR_PTR(-ENOMEM);
+	create->threadfn = threadfn;
+	create->data = data;
+	create->node = node;
+	create->done = &done;
 
 	spin_lock(&kthread_create_lock);
-	list_add_tail(&create.list, &kthread_create_list);
+	list_add_tail(&create->list, &kthread_create_list);
 	spin_unlock(&kthread_create_lock);
 
 	wake_up_process(kthreadd_task);
-	wait_for_completion(&create.done);
-
-	if (!IS_ERR(create.result)) {
+	/*
+	 * Wait for completion in killable state, for I might be chosen by
+	 * the OOM killer while kthreadd is trying to allocate memory for
+	 * new kernel thread.
+	 */
+	if (unlikely(wait_for_completion_killable(&done))) {
+		/*
+		 * If I was SIGKILLed before kthreadd (or new kernel thread)
+		 * calls complete(), leave the cleanup of this structure to
+		 * that thread.
+		 */
+		if (xchg(&create->done, NULL))
+			return ERR_PTR(-ENOMEM);
+		/*
+		 * kthreadd (or new kernel thread) will call complete()
+		 * shortly.
+		 */
+		wait_for_completion(&done);
+	}
+	task = create->result;
+	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
 		va_list args;
 
 		va_start(args, namefmt);
-		vsnprintf(create.result->comm, sizeof(create.result->comm),
-			  namefmt, args);
+		vsnprintf(task->comm, sizeof(task->comm), namefmt, args);
 		va_end(args);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
 		 * The kernel thread should not inherit these properties.
 		 */
-		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
-		set_cpus_allowed_ptr(create.result, cpu_all_mask);
+		sched_setscheduler_nocheck(task, SCHED_NORMAL, &param);
+		set_cpus_allowed_ptr(task, cpu_all_mask);
 	}
-	return create.result;
+	kfree(create);
+	return task;
 }
 EXPORT_SYMBOL(kthread_create_on_node);
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

origin.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

