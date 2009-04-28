From: akpm@linux-foundation.org
Subject: + kthreads-simplify-migration_thread-exit-path.patch added to -mm tree
Date: Tue, 28 Apr 2009 12:49:08 -0700
Message-ID: <200904281949.n3SJn8OB000712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbZD1Tyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 15:54:55 -0400
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
@@ -6868,7 +6868,7 @@ static int migration_thread(void *data)
 
 		if (cpu_is_offline(cpu)) {
 			spin_unlock_irq(&rq->lock);
-			goto wait_to_die;
+			break;
 		}
 
 		if (rq->active_balance) {
@@ -6894,16 +6894,7 @@ static int migration_thread(void *data)
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
 
@@ -7309,6 +7300,7 @@ migration_call(struct notifier_block *nf
 		rq = task_rq_lock(p, &flags);
 		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 		task_rq_unlock(rq, &flags);
+		get_task_struct(p);
 		cpu_rq(cpu)->migration_thread = p;
 		break;
 
@@ -7337,6 +7329,7 @@ migration_call(struct notifier_block *nf
 		kthread_bind(cpu_rq(cpu)->migration_thread,
 			     cpumask_any(cpu_online_mask));
 		kthread_stop(cpu_rq(cpu)->migration_thread);
+		put_task_struct(cpu_rq(cpu)->migration_thread);
 		cpu_rq(cpu)->migration_thread = NULL;
 		break;
 
@@ -7346,6 +7339,7 @@ migration_call(struct notifier_block *nf
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
linux-next.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

