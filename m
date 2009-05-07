From: akpm@linux-foundation.org
Subject: [merged] rcu_sched_grace_period-kill-the-bogus-flush_signals.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:50 -0700
Message-ID: <200905071916.n47JGoi7020669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482AbZEGTUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:20:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu_sched_grace_period(): kill the bogus flush_signals()
has been removed from the -mm tree.  Its filename was
     rcu_sched_grace_period-kill-the-bogus-flush_signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu_sched_grace_period(): kill the bogus flush_signals()
From: Oleg Nesterov <oleg@redhat.com>

As a kernel thread, rcu_sched_grace_period() runs with all signals
ignored.  It can never receive a signal even if it sleeps in
TASK_INTERRUPTIBLE, it needs the explicit allow_signal() to be visible for
signals.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupreempt.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN kernel/rcupreempt.c~rcu_sched_grace_period-kill-the-bogus-flush_signals kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu_sched_grace_period-kill-the-bogus-flush_signals
+++ a/kernel/rcupreempt.c
@@ -1356,17 +1356,11 @@ static int rcu_sched_grace_period(void *
 
 		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
 		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
-		ret = 0;
+		ret = 0; /* unused */
 		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
 			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
 			ret);
 
-		/*
-		 * Signals would prevent us from sleeping, and we cannot
-		 * do much with them in any case.  So flush them.
-		 */
-		if (ret)
-			flush_signals(current);
 		couldsleepnext = 0;
 
 	} while (!kthread_should_stop());
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
ptrace-do-not-use-task_lock-for-attach.patch
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch

