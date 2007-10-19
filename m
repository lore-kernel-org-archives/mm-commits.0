From: akpm@linux-foundation.org
Subject: - remove-struct-task_structio_wait.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:33 -0700
Message-ID: <200710190341.l9J3fXJm012828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934407AbXJSDzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Remove struct task_struct::io_wait
has been removed from the -mm tree.  Its filename was
     remove-struct-task_structio_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove struct task_struct::io_wait
From: Alexey Dobriyan <adobriyan@gmail.com>

Hell knows what happened in commit 63b05203af57e7de4f3bb63b8b81d43bc196d32b
during 2.6.9 development.  Commit introduced io_wait field which remained
write-only than and still remains write-only.

Also garbage collect macros which "use" io_wait.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c              |   16 ++--------------
 include/linux/aio.h   |   12 ------------
 include/linux/sched.h |    7 -------
 kernel/fork.c         |    1 -
 4 files changed, 2 insertions(+), 34 deletions(-)

diff -puN fs/aio.c~remove-struct-task_structio_wait fs/aio.c
--- a/fs/aio.c~remove-struct-task_structio_wait
+++ a/fs/aio.c
@@ -710,18 +710,9 @@ static ssize_t aio_run_iocb(struct kiocb
 
 	/*
 	 * Now we are all set to call the retry method in async
-	 * context. By setting this thread's io_wait context
-	 * to point to the wait queue entry inside the currently
-	 * running iocb for the duration of the retry, we ensure
-	 * that async notification wakeups are queued by the
-	 * operation instead of blocking waits, and when notified,
-	 * cause the iocb to be kicked for continuation (through
-	 * the aio_wake_function callback).
+	 * context.
 	 */
-	BUG_ON(current->io_wait != NULL);
-	current->io_wait = &iocb->ki_wait;
 	ret = retry(iocb);
-	current->io_wait = NULL;
 
 	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
 		BUG_ON(!list_empty(&iocb->ki_wait.task_list));
@@ -1508,10 +1499,7 @@ static ssize_t aio_setup_iocb(struct kio
  * 	Simply triggers a retry of the operation via kick_iocb.
  *
  * 	This callback is specified in the wait queue entry in
- *	a kiocb	(current->io_wait points to this wait queue
- *	entry when an aio operation executes; it is used
- * 	instead of a synchronous wait when an i/o blocking
- *	condition is encountered during aio).
+ *	a kiocb.
  *
  * Note:
  * This routine is executed with the wait queue lock held.
diff -puN include/linux/aio.h~remove-struct-task_structio_wait include/linux/aio.h
--- a/include/linux/aio.h~remove-struct-task_structio_wait
+++ a/include/linux/aio.h
@@ -232,18 +232,6 @@ int FASTCALL(io_submit_one(struct kioctx
 		__put_ioctx(kioctx);					\
 } while (0)
 
-#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))
-
-/* may be used for debugging */
-#define warn_if_async()							\
-do {									\
-	if (in_aio()) {							\
-		printk(KERN_ERR "%s(%s:%d) called in async context!\n",	\
-			__FUNCTION__, __FILE__, __LINE__);		\
-		dump_stack();						\
-	}								\
-} while (0)
-
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
 #include <linux/aio_abi.h>
diff -puN include/linux/sched.h~remove-struct-task_structio_wait include/linux/sched.h
--- a/include/linux/sched.h~remove-struct-task_structio_wait
+++ a/include/linux/sched.h
@@ -1110,13 +1110,6 @@ struct task_struct {
 
 	unsigned long ptrace_message;
 	siginfo_t *last_siginfo; /* For ptrace use.  */
-/*
- * current io wait handle: wait queue entry to use for io waits
- * If this thread is processing aio, this points at the waitqueue
- * inside the currently handled kiocb. It may be NULL (i.e. default
- * to a stack based synchronous wait) if its doing sync IO.
- */
-	wait_queue_t *io_wait;
 #ifdef CONFIG_TASK_XACCT
 /* i/o counters(bytes read/written, #syscalls */
 	u64 rchar, wchar, syscr, syscw;
diff -puN kernel/fork.c~remove-struct-task_structio_wait kernel/fork.c
--- a/kernel/fork.c~remove-struct-task_structio_wait
+++ a/kernel/fork.c
@@ -1084,7 +1084,6 @@ static struct task_struct *copy_process(
 	p->security = NULL;
 #endif
 	p->io_context = NULL;
-	p->io_wait = NULL;
 	p->audit_context = NULL;
 	cpuset_fork(p);
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
