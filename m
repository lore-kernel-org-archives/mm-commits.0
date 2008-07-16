From: akpm@linux-foundation.org
Subject: + coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch added to -mm tree
Date: Wed, 16 Jul 2008 13:22:12 -0700
Message-ID: <200807162022.m6GKMDmn011221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbYGPUWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 16:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, dhowells@redhat.com, roland@redhat.com


The patch titled
     coredump: exit_mm: clear ->mm first, then play with ->core_state
has been added to the -mm tree.  Its filename is
     coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: exit_mm: clear ->mm first, then play with ->core_state
From: Oleg Nesterov <oleg@tv-sign.ru>

With the previous changes the sub-threads which participate in coredump do
not need to have the valid ->mm when the coredump is in progress, now we
can decouple exit_mm() from coredumping code.

Change exit_mm() to clear ->mm first, then play with mm->core_state.  This
simplifies the code because we can avoid unlock/lock games with
->mmap_sem, and more importantly this makes the coredumping process
visible to oom_kill.  Currently the PF_EXITING task can sleep with ->mm !=
NULL "unpredictably" long.

The patch moves the coredumping code to the new function for the readability.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    4 ++--
 kernel/exit.c |   47 +++++++++++++++++++++++++----------------------
 2 files changed, 27 insertions(+), 24 deletions(-)

diff -puN fs/exec.c~coredump-exit_mm-clear-mm-first-then-play-with-core_state fs/exec.c
--- a/fs/exec.c~coredump-exit_mm-clear-mm-first-then-play-with-core_state
+++ a/fs/exec.c
@@ -1637,8 +1637,8 @@ static void coredump_finish(struct mm_st
 		next = curr->next;
 		task = curr->task;
 		/*
-		 * see exit_mm(), curr->task must not see
-		 * ->task == NULL before we read ->next.
+		 * see exit_coredump(), curr->task must not
+		 * see ->task == NULL before we read ->next.
 		 */
 		smp_mb();
 		curr->task = NULL;
diff -puN kernel/exit.c~coredump-exit_mm-clear-mm-first-then-play-with-core_state kernel/exit.c
--- a/kernel/exit.c~coredump-exit_mm-clear-mm-first-then-play-with-core_state
+++ a/kernel/exit.c
@@ -644,6 +644,28 @@ assign_new_owner:
 }
 #endif /* CONFIG_MM_OWNER */
 
+static void exit_coredump(struct task_struct * tsk,
+				struct core_state *core_state)
+{
+	struct core_thread self;
+
+	self.task = tsk;
+	self.next = xchg(&core_state->dumper.next, &self);
+	/*
+	 * Implies mb(), the result of xchg() must be visible
+	 * to core_state->dumper.
+	 */
+	if (atomic_dec_and_test(&core_state->nr_threads))
+		complete(&core_state->startup);
+
+	for (;;) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if (!self.task) /* see coredump_finish() */
+			break;
+		schedule();
+	}
+	__set_task_state(tsk, TASK_RUNNING);
+}
 /*
  * Turn us into a lazy TLB process if we
  * aren't already..
@@ -665,28 +687,6 @@ static void exit_mm(struct task_struct *
 	 */
 	down_read(&mm->mmap_sem);
 	core_state = mm->core_state;
-	if (core_state) {
-		struct core_thread self;
-		up_read(&mm->mmap_sem);
-
-		self.task = tsk;
-		self.next = xchg(&core_state->dumper.next, &self);
-		/*
-		 * Implies mb(), the result of xchg() must be visible
-		 * to core_state->dumper.
-		 */
-		if (atomic_dec_and_test(&core_state->nr_threads))
-			complete(&core_state->startup);
-
-		for (;;) {
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-			if (!self.task) /* see coredump_finish() */
-				break;
-			schedule();
-		}
-		__set_task_state(tsk, TASK_RUNNING);
-		down_read(&mm->mmap_sem);
-	}
 	atomic_inc(&mm->mm_count);
 	BUG_ON(mm != tsk->active_mm);
 	/* more a memory barrier than a real lock */
@@ -699,6 +699,9 @@ static void exit_mm(struct task_struct *
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
+
+	if (core_state)
+		exit_coredump(tsk, core_state);
 }
 
 static void
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
workqueues-lockdep-annotations-for-flush_work.patch
workqueues-queue_work-can-use-queue_work_on.patch
workqueues-schedule_on_each_cpu-can-use-schedule_work_on.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

