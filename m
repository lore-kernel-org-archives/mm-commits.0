From: akpm@linux-foundation.org
Subject: - coredump-kill-mm-core_done.patch removed from -mm tree
Date: Tue, 15 Jul 2008 19:05:43 -0700
Message-ID: <200807160205.m6G25h3S000681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755156AbYGPCHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jul 2008 22:07:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     coredump: kill mm->core_done
has been removed from the -mm tree.  Its filename was
     coredump-kill-mm-core_done.patch

This patch was dropped because an updated version will be merged

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
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |   24 ++++++++++++++++++++++--
 include/linux/mm_types.h |    4 +---
 kernel/exit.c            |    8 +++++++-
 3 files changed, 30 insertions(+), 6 deletions(-)

diff -puN fs/exec.c~coredump-kill-mm-core_done fs/exec.c
--- a/fs/exec.c~coredump-kill-mm-core_done
+++ a/fs/exec.c
@@ -1603,7 +1603,6 @@ static int coredump_wait(int exit_code)
 	struct completion *vfork_done;
 	int core_waiters;
 
-	init_completion(&mm->core_done);
 	init_completion(&core_state.startup);
 	core_waiters = zap_threads(tsk, mm, &core_state, exit_code);
 	up_write(&mm->mmap_sem);
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
@@ -1811,7 +1831,7 @@ fail_unlock:
 		argv_free(helper_argv);
 
 	current->fsuid = fsuid;
-	complete_all(&mm->core_done);
+	coredump_finish(mm);
 fail:
 	return retval;
 }
diff -puN include/linux/mm_types.h~coredump-kill-mm-core_done include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-kill-mm-core_done
+++ a/include/linux/mm_types.h
@@ -228,9 +228,7 @@ struct mm_struct {
 
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
@@ -669,7 +669,13 @@ static void exit_mm(struct task_struct *
 		if (atomic_dec_and_test(&mm->core_state->nr_threads))
 			complete(&mm->core_state->startup);
 
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

