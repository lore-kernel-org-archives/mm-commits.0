From: akpm@linux-foundation.org
Subject: + coredump-kill-mm-core_done.patch added to -mm tree
Date: Tue, 15 Jul 2008 19:08:27 -0700
Message-ID: <200807160208.m6G28R9K000814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697AbYGPCIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jul 2008 22:08:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     coredump: kill mm->core_done
has been added to the -mm tree.  Its filename is
     coredump-kill-mm-core_done.patch

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
Subject: coredump: kill mm->core_done
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that we have core_state->dumper list we can use it to wake up the
sub-threads waiting for the coredump completion.

This uglifies the code and .text grows by 47 bytes, but otoh mm_struct
lessens by sizeof(struct completion).  Also, with this change we can
decouple exit_mm() from the coredumping code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |   25 ++++++++++++++++++++++---
 include/linux/mm_types.h |    4 +---
 kernel/exit.c            |    8 +++++++-
 3 files changed, 30 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~coredump-kill-mm-core_done fs/exec.c
--- a/fs/exec.c~coredump-kill-mm-core_done
+++ a/fs/exec.c
@@ -1602,7 +1602,6 @@ static int coredump_wait(int exit_code, 
 	struct completion *vfork_done;
 	int core_waiters;
 
-	init_completion(&mm->core_done);
 	init_completion(&core_state->startup);
 	core_state->dumper.task = tsk;
 	core_state->dumper.next = NULL;
@@ -1628,6 +1627,27 @@ fail:
 	return core_waiters;
 }
 
+static void coredump_finish(struct mm_struct *mm)
+{
+	struct core_thread *curr, *next;
+	struct task_struct *task;
+
+	next = mm->core_state->dumper.next;
+	while ((curr = next) != NULL) {
+		next = curr->next;
+		task = curr->task;
+		/*
+		 * see exit_mm(), curr->task must not see
+		 * ->task == NULL before we read ->next.
+		 */
+		smp_mb();
+		curr->task = NULL;
+		wake_up_process(task);
+	}
+
+	mm->core_state = NULL;
+}
+
 /*
  * set_dumpable converts traditional three-value dumpable to two flags and
  * stores them into mm->flags.  It modifies lower two bits of mm->flags, but
@@ -1812,8 +1832,7 @@ fail_unlock:
 		argv_free(helper_argv);
 
 	current->fsuid = fsuid;
-	complete_all(&mm->core_done);
-	mm->core_state = NULL;
+	coredump_finish(mm);
 fail:
 	return retval;
 }
diff -puN include/linux/mm_types.h~coredump-kill-mm-core_done include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-kill-mm-core_done
+++ a/include/linux/mm_types.h
@@ -234,9 +234,7 @@ struct mm_struct {
 
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
-	/* coredumping support */
-	struct core_state *core_state;
-	struct completion core_done;
+	struct core_state *core_state; /* coredumping support */
 
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;	/* aio lock */
diff -puN kernel/exit.c~coredump-kill-mm-core_done kernel/exit.c
--- a/kernel/exit.c~coredump-kill-mm-core_done
+++ a/kernel/exit.c
@@ -678,7 +678,13 @@ static void exit_mm(struct task_struct *
 		if (atomic_dec_and_test(&core_state->nr_threads))
 			complete(&core_state->startup);
 
-		wait_for_completion(&mm->core_done);
+		for (;;) {
+			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			if (!self.task) /* see coredump_finish() */
+				break;
+			schedule();
+		}
+		__set_task_state(tsk, TASK_RUNNING);
 		down_read(&mm->mmap_sem);
 	}
 	atomic_inc(&mm->mm_count);
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

