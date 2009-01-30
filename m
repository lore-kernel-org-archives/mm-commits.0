From: akpm@linux-foundation.org
Subject: + kthreads-simplify-migration_thread-exit-path.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:49:26 -0800
Message-ID: <200901302149.n0ULnRvX025726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbZA3Vu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:50:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, hch@lst.de, mingo@elte.hu, rusty@rustcorp.com.au, vgusev@openvz.org, xemul@openvz.org


The patch titled
     kthreads: simplify migration_thread() exit path
has been added to the -mm tree.  Its filename is
     kthreads-simplify-migration_thread-exit-path.patch

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
Subject: kthreads: simplify migration_thread() exit path
From: Oleg Nesterov <oleg@redhat.com>

Now that kthread_stop() can be used even if the task has already exited,
we can kill the "wait_to_die:" loop in migration_thread().  But we must
pin rq->migration_thread after creation.

Actually, I don't think CPU_UP_CANCELED or CPU_DEAD should wait for
->migration_thread exit.  Perhaps we can simplify this code a bit more. 
migration_call() can set ->should_stop and forget about this thread.  But
we need a new helper in kthred.c for that.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Vitaliy Gusev <vgusev@openvz.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN kernel/sched.c~kthreads-simplify-migration_thread-exit-path kernel/sched.c
--- a/kernel/sched.c~kthreads-simplify-migration_thread-exit-path
+++ a/kernel/sched.c
@@ -6359,7 +6359,7 @@ static int migration_thread(void *data)
 
 		if (cpu_is_offline(cpu)) {
 			spin_unlock_irq(&rq->lock);
-			goto wait_to_die;
+			break;
 		}
 
 		if (rq->active_balance) {
@@ -6385,16 +6385,7 @@ static int migration_thread(void *data)
 		complete(&req->done);
 	}
 	__set_current_state(TASK_RUNNING);
-	return 0;
 
-wait_to_die:
-	/* Wait for kthread_stop */
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	__set_current_state(TASK_RUNNING);
 	return 0;
 }
 
@@ -6800,6 +6791,7 @@ migration_call(struct notifier_block *nf
 		rq = task_rq_lock(p, &flags);
 		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 		task_rq_unlock(rq, &flags);
+		get_task_struct(p);
 		cpu_rq(cpu)->migration_thread = p;
 		break;
 
@@ -6828,6 +6820,7 @@ migration_call(struct notifier_block *nf
 		kthread_bind(cpu_rq(cpu)->migration_thread,
 			     cpumask_any(cpu_online_mask));
 		kthread_stop(cpu_rq(cpu)->migration_thread);
+		put_task_struct(cpu_rq(cpu)->migration_thread);
 		cpu_rq(cpu)->migration_thread = NULL;
 		break;
 
@@ -6837,6 +6830,7 @@ migration_call(struct notifier_block *nf
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
+		put_task_struct(rq->migration_thread);
 		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		spin_lock_irq(&rq->lock);
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

