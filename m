From: akpm@linux-foundation.org
Subject: - fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch removed from -mm tree
Date: Wed, 09 May 2007 03:04:38 -0700
Message-ID: <200705091004.l49A4c6r020767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbXEIKEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suparna@in.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fsaio: add a default io wait bit field in task struct
has been removed from the -mm tree.  Its filename was
     fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fsaio: add a default io wait bit field in task struct
From: Suparna Bhattacharya <suparna@in.ibm.com>

Allocates space for the default io wait queue entry (actually a wait bit
entry) in the task struct.  Doing so simplifies the patches for AIO wait page
allowing for cleaner and more efficient implementation, at the cost of 28
additional bytes in task struct vs allocation on demand on-stack.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   11 +++++++----
 kernel/fork.c         |    3 ++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN include/linux/sched.h~fsaio-add-a-default-io-wait-bit-field-in-task-struct include/linux/sched.h
--- a/include/linux/sched.h~fsaio-add-a-default-io-wait-bit-field-in-task-struct
+++ a/include/linux/sched.h
@@ -1003,11 +1003,14 @@ struct task_struct {
 
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
 #ifdef CONFIG_TASK_XACCT
diff -puN kernel/fork.c~fsaio-add-a-default-io-wait-bit-field-in-task-struct kernel/fork.c
--- a/kernel/fork.c~fsaio-add-a-default-io-wait-bit-field-in-task-struct
+++ a/kernel/fork.c
@@ -1056,7 +1056,8 @@ static struct task_struct *copy_process(
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

aio-is-unlikely.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
