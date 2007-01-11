From: akpm@osdl.org
Subject: + fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch added to -mm tree
Date: Wed, 10 Jan 2007 23:21:22 -0800
Message-ID: <200701110721.l0B7LMRE019296@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965320AbXAKHWJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 02:22:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suparna@in.ibm.com, mingo@elte.hu


The patch titled
     fsaio: add a default io wait bit field in task struct
has been added to the -mm tree.  Its filename is
     fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fsaio: add a default io wait bit field in task struct
From: Suparna Bhattacharya <suparna@in.ibm.com>

Allocates space for the default io wait queue entry (actually a wait bit
entry) in the task struct.  Doing so simplifies the patches for AIO wait page
allowing for cleaner and more efficient implementation, at the cost of 28
additional bytes in task struct vs allocation on demand on-stack.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |   11 +++++++----
 kernel/fork.c         |    3 ++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN include/linux/sched.h~fsaio-add-a-default-io-wait-bit-field-in-task-struct include/linux/sched.h
--- a/include/linux/sched.h~fsaio-add-a-default-io-wait-bit-field-in-task-struct
+++ a/include/linux/sched.h
@@ -1004,11 +1004,14 @@ struct task_struct {
 
 	unsigned long ptrace_message;
 	siginfo_t *last_siginfo; /* For ptrace use.  */
+
+/* Space for default IO wait bit entry used for synchronous IO waits */
+	struct wait_bit_queue __wait;
 /*
- * current io wait handle: wait queue entry to use for io waits
- * If this thread is processing aio, this points at the waitqueue
- * inside the currently handled kiocb. It may be NULL (i.e. default
- * to a stack based synchronous wait) if its doing sync IO.
+ * Current IO wait handle: wait queue entry to use for IO waits
+ * If this thread is processing AIO, this points at the waitqueue
+ * inside the currently handled kiocb. Otherwise, points to the
+ * default IO wait field (i.e &__wait.wait above).
  */
 	wait_queue_t *io_wait;
 /* i/o counters(bytes read/written, #syscalls */
diff -puN kernel/fork.c~fsaio-add-a-default-io-wait-bit-field-in-task-struct kernel/fork.c
--- a/kernel/fork.c~fsaio-add-a-default-io-wait-bit-field-in-task-struct
+++ a/kernel/fork.c
@@ -1052,7 +1052,8 @@ static struct task_struct *copy_process(
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->security = NULL;
 	p->io_context = NULL;
-	p->io_wait = NULL;
+	init_wait_bit_task(&p->__wait, p);
+	p->io_wait = &p->__wait.wait;
 	p->audit_context = NULL;
 	cpuset_fork(p);
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from suparna@in.ibm.com are

aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
