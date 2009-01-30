From: akpm@linux-foundation.org
Subject: + kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:49:12 -0800
Message-ID: <200901302149.n0ULnCKP025468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813AbZA3VvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:51:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, hch@lst.de, mingo@elte.hu, rusty@rustcorp.com.au, vgusev@openvz.org, xemul@openvz.org


The patch titled
     kthreads: move sched-realeted initialization from kthreadd context
has been added to the -mm tree.  Its filename is
     kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch

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

 kernel/kthread.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN kernel/kthread.c~kthreads-move-sched-realeted-initialization-from-kthreadd-context kernel/kthread.c
--- a/kernel/kthread.c~kthreads-move-sched-realeted-initialization-from-kthreadd-context
+++ a/kernel/kthread.c
@@ -102,15 +102,7 @@ static void create_kthread(struct kthrea
 	if (pid < 0) {
 		create->result = ERR_PTR(pid);
 	} else {
-		struct sched_param param = { .sched_priority = 0 };
 		wait_for_completion(&create->started);
-		/*
-		 * root may have changed our (kthreadd's) priority or CPU mask.
-		 * The kernel thread should not inherit these properties.
-		 */
-		sched_setscheduler(create->result, SCHED_NORMAL, &param);
-		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
 	}
 	complete(&create->done);
 }
@@ -154,11 +146,20 @@ struct task_struct *kthread_create(int (
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
+		set_cpus_allowed_ptr(create.result, CPU_MASK_ALL_PTR);
 	}
 	return create.result;
 }
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

