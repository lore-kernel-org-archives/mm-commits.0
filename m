From: akpm@linux-foundation.org
Subject: [merged] kthreads-simplify-the-startup-synchronization.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:06 -0700
Message-ID: <200906182247.n5IMl64d006174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759043AbZFRWsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, hch@lst.de, mingo@elte.hu, rusty@rustcorp.com.au, vgusev@openvz.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     kthreads: simplify the startup synchronization
has been removed from the -mm tree.  Its filename was
     kthreads-simplify-the-startup-synchronization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthreads: simplify the startup synchronization
From: Oleg Nesterov <oleg@redhat.com>

We use two completions two create the kernel thread, this is a bit ugly. 
kthread() wakes up create_kthread() via ->started, then create_kthread()
wakes up the caller kthread_create() via ->done.  But kthread() does not
need to wait for kthread(), it can just return.  Instead kthread() itself
can wake up the caller of kthread_create().

Kill kthread_create_info->started, ->done is enough.  This improves the
scalability a bit and sijmplifies the code.

The only problem if kernel_thread() fails, in that case create_kthread()
must do complete(&create->done).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Vitaliy Gusev <vgusev@openvz.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/kthread.c~kthreads-simplify-the-startup-synchronization kernel/kthread.c
--- a/kernel/kthread.c~kthreads-simplify-the-startup-synchronization
+++ a/kernel/kthread.c
@@ -27,7 +27,6 @@ struct kthread_create_info
 	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
-	struct completion started;
 
 	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
@@ -75,7 +74,7 @@ static int kthread(void *_create)
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
 	create->result = current;
-	complete(&create->started);
+	complete(&create->done);
 	schedule();
 
 	if (!kthread_should_stop())
@@ -95,11 +94,10 @@ static void create_kthread(struct kthrea
 
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
-	if (pid < 0)
+	if (pid < 0) {
 		create->result = ERR_PTR(pid);
-	else
-		wait_for_completion(&create->started);
-	complete(&create->done);
+		complete(&create->done);
+	}
 }
 
 /**
@@ -130,7 +128,6 @@ struct task_struct *kthread_create(int (
 
 	create.threadfn = threadfn;
 	create.data = data;
-	init_completion(&create.started);
 	init_completion(&create.done);
 
 	spin_lock(&kthread_create_lock);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

