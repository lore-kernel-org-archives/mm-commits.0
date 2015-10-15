From: akpm@linux-foundation.org
Subject: [to-be-updated]
 revert-kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch
 removed from -mm tree
Date: Thu, 15 Oct 2015 12:29:03 -0700
Message-ID: <561ffe7f.vODCBA9GlNmBmlcg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbJOT3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:29:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, cl@linux.com, fweisbec@gmail.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "kmod: handle UMH_WAIT_PROC from system unbound workqueue"
has been removed from the -mm tree.  Its filename was
     revert-kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: Revert "kmod: handle UMH_WAIT_PROC from system unbound workqueue"

This reverts bb304a5c6fc63d8506c ("kmod: handle UMH_WAIT_PROC from system
unbound workqueue") because this patch leads to kthread zombies.

call_usermodehelper_exec_sync() does fork() + wait() with "unignored"
SIGCHLD.  What we have missed is that this worker thread can have other
children previously forked by call_usermodehelper_exec_work() without
UMH_WAIT_PROC.  If such a child exits in between it becomes a zombie and
nobody can reap it (unless/until this worker thread exits too).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff -puN kernel/kmod.c~revert-kmod-handle-umh_wait_proc-from-system-unbound-workqueue kernel/kmod.c
--- a/kernel/kmod.c~revert-kmod-handle-umh_wait_proc-from-system-unbound-workqueue
+++ a/kernel/kmod.c
@@ -265,9 +265,15 @@ out:
 	do_exit(0);
 }
 
-/* Handles UMH_WAIT_PROC.  */
-static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
+/*
+ * Handles UMH_WAIT_PROC. Our parent (unbound workqueue) might not be able to
+ * run enough instances to handle usermodehelper completions without blocking
+ * some other pending requests. That's why we use a kernel thread dedicated for
+ * that purpose.
+ */
+static int call_usermodehelper_exec_sync(void *data)
 {
+	struct subprocess_info *sub_info = data;
 	pid_t pid;
 
 	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
@@ -281,9 +287,9 @@ static void call_usermodehelper_exec_syn
 		 * Normally it is bogus to call wait4() from in-kernel because
 		 * wait4() wants to write the exit code to a userspace address.
 		 * But call_usermodehelper_exec_sync() always runs as kernel
-		 * thread (workqueue) and put_user() to a kernel address works
-		 * OK for kernel threads, due to their having an mm_segment_t
-		 * which spans the entire address space.
+		 * thread and put_user() to a kernel address works OK for kernel
+		 * threads, due to their having an mm_segment_t which spans the
+		 * entire address space.
 		 *
 		 * Thus the __user pointer cast is valid here.
 		 */
@@ -298,21 +304,19 @@ static void call_usermodehelper_exec_syn
 			sub_info->retval = ret;
 	}
 
-	/* Restore default kernel sig handler */
-	kernel_sigaction(SIGCHLD, SIG_IGN);
-
 	umh_complete(sub_info);
+	do_exit(0);
 }
 
 /*
- * We need to create the usermodehelper kernel thread from a task that is affine
+ * This function doesn't strictly needs to be called asynchronously. But we
+ * need to create the usermodehelper kernel threads from a task that is affine
  * to an optimized set of CPUs (or nohz housekeeping ones) such that they
  * inherit a widest affinity irrespective of call_usermodehelper() callers with
  * possibly reduced affinity (eg: per-cpu workqueues). We don't want
  * usermodehelper targets to contend a busy CPU.
  *
- * Unbound workqueues provide such wide affinity and allow to block on
- * UMH_WAIT_PROC requests without blocking pending request (up to some limit).
+ * Unbound workqueues provide such wide affinity.
  *
  * Besides, workqueues provide the privilege level that caller might not have
  * to perform the usermodehelper request.
@@ -322,18 +326,18 @@ static void call_usermodehelper_exec_wor
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
+	pid_t pid;
 
-	if (sub_info->wait & UMH_WAIT_PROC) {
-		call_usermodehelper_exec_sync(sub_info);
-	} else {
-		pid_t pid;
-
+	if (sub_info->wait & UMH_WAIT_PROC)
+		pid = kernel_thread(call_usermodehelper_exec_sync, sub_info,
+				    CLONE_FS | CLONE_FILES | SIGCHLD);
+	else
 		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
 				    SIGCHLD);
-		if (pid < 0) {
-			sub_info->retval = pid;
-			umh_complete(sub_info);
-		}
+
+	if (pid < 0) {
+		sub_info->retval = pid;
+		umh_complete(sub_info);
 	}
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

mmoom-fix-potentially-killing-unrelated-process-fix.patch
mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

