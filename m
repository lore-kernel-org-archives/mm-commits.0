From: akpm@linux-foundation.org
Subject: [merged] kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:59 -0800
Message-ID: <200902191917.n1JJHxFJ016431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbZBSTSs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:18:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, hch@lst.de, mingo@elte.hu, rusty@rustcorp.com.au, vgusev@openvz.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     kthreads: move sched-realeted initialization from kthreadd context
has been removed from the -mm tree.  Its filename was
     kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthreads: move sched-realeted initialization from kthreadd context
From: Oleg Nesterov <oleg@redhat.com>

kthreadd is the single thread which implements ths "create" request, move
sched_setscheduler/etc from create_kthread() to kthread_create() to
improve the scalability.

We should be careful with sched_setscheduler(), use _nochek helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Vitaliy Gusev <vgusev@openvz.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/kthread.c~kthreads-move-sched-realeted-initialization-from-kthreadd-context kernel/kthread.c
--- a/kernel/kthread.c~kthreads-move-sched-realeted-initialization-from-kthreadd-context
+++ a/kernel/kthread.c
@@ -97,19 +97,10 @@ static void create_kthread(struct kthrea
 
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
-	if (pid < 0) {
+	if (pid < 0)
 		create->result = ERR_PTR(pid);
-	} else {
-		struct sched_param param = { .sched_priority = 0 };
+	else
 		wait_for_completion(&create->started);
-		/*
-		 * root may have changed our (kthreadd's) priority or CPU mask.
-		 * The kernel thread should not inherit these properties.
-		 */
-		sched_setscheduler(create->result, SCHED_NORMAL, &param);
-		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, cpu_all_mask);
-	}
 	complete(&create->done);
 }
 
@@ -152,11 +143,20 @@ struct task_struct *kthread_create(int (
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
+		struct sched_param param = { .sched_priority = 0 };
 		va_list args;
+
 		va_start(args, namefmt);
 		vsnprintf(create.result->comm, sizeof(create.result->comm),
 			  namefmt, args);
 		va_end(args);
+		/*
+		 * root may have changed our (kthreadd's) priority or CPU mask.
+		 * The kernel thread should not inherit these properties.
+		 */
+		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
+		set_user_nice(create.result, KTHREAD_NICE_LEVEL);
+		set_cpus_allowed_ptr(create.result, cpu_all_mask);
 	}
 	return create.result;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
move-exit_ptrace-from-forget_original_parent-to-do_exit.patch
reparent-untrace-do-nothing-if-no-childs-tracees.patch
tracehook_notify_death-use-task_detached-helper.patch
ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch
ptrace_untrace-fix-the-signal_stop_stopped-check.patch
workqueue-avoid-recursion-in-run_workqueue.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

