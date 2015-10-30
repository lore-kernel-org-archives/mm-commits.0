From: akpm@linux-foundation.org
Subject: [merged]
 kmod-dont-run-async-usermode-helper-as-a-child-of-kworker-thread.patch
 removed from -mm tree
Date: Fri, 30 Oct 2015 12:44:31 -0700
Message-ID: <5633c89f.JhAl6VrRku6mD786%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbbJ3Toc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Oct 2015 15:44:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, cl@linux.com, fweisbec@gmail.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: don't run async usermode helper as a child of kworker thread
has been removed from the -mm tree.  Its filename was
     kmod-dont-run-async-usermode-helper-as-a-child-of-kworker-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kmod: don't run async usermode helper as a child of kworker thread

call_usermodehelper_exec_sync() does fork() + wait() with "unignored"
SIGCHLD.  What we have missed is that this worker thread can have other
children previously forked by call_usermodehelper_exec_work() without
UMH_WAIT_PROC.  If such a child exits in between it becomes a zombie
because auto-reaping only works if SIGCHLD is ignored, and nobody can reap
it (unless/until this worker thread exits too).

Change the !UMH_WAIT_PROC case to use CLONE_PARENT.

Note: this is only first step.  All PF_KTHREAD tasks, even created by
kernel_thread() should have ->parent == kthreadd by default.

Fixes: bb304a5c6fc63d8506c ("kmod: handle UMH_WAIT_PROC from system unbound workqueue")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~kmod-dont-run-async-usermode-helper-as-a-child-of-kworker-thread kernel/kmod.c
--- a/kernel/kmod.c~kmod-dont-run-async-usermode-helper-as-a-child-of-kworker-thread
+++ a/kernel/kmod.c
@@ -327,9 +327,13 @@ static void call_usermodehelper_exec_wor
 		call_usermodehelper_exec_sync(sub_info);
 	} else {
 		pid_t pid;
-
+		/*
+		 * Use CLONE_PARENT to reparent it to kthreadd; we do not
+		 * want to pollute current->children, and we need a parent
+		 * that always ignores SIGCHLD to ensure auto-reaping.
+		 */
 		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
-				    SIGCHLD);
+				    CLONE_PARENT | SIGCHLD);
 		if (pid < 0) {
 			sub_info->retval = pid;
 			umh_complete(sub_info);
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

