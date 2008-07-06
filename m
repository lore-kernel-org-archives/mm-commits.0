From: akpm@linux-foundation.org
Subject: + coredump-move-mm-core_waiters-into-struct-core_state.patch added to -mm tree
Date: Sun, 06 Jul 2008 12:24:20 -0700
Message-ID: <200807061924.m66JOL1U021277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841AbYGFTYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 15:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     coredump: move mm->core_waiters into struct core_state
has been added to the -mm tree.  Its filename is
     coredump-move-mm-core_waiters-into-struct-core_state.patch

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
Subject: coredump: move mm->core_waiters into struct core_state
From: Oleg Nesterov <oleg@tv-sign.ru>

Move mm->core_waiters into "struct core_state" allocated on stack.  This
shrinks mm_struct a little bit and allows further changes.

This patch mostly does s/core_waiters/core_state.  The only essential
change is that coredump_wait() must clear mm->core_state before return.

The coredump_wait()'s path is uglified and .text grows by 30 bytes, this
is fixed by the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |   21 +++++++++++----------
 include/linux/mm_types.h |    2 +-
 kernel/exit.c            |    8 ++++----
 kernel/fork.c            |    2 +-
 kernel/signal.c          |    4 ++--
 5 files changed, 19 insertions(+), 18 deletions(-)

diff -puN fs/exec.c~coredump-move-mm-core_waiters-into-struct-core_state fs/exec.c
--- a/fs/exec.c~coredump-move-mm-core_waiters-into-struct-core_state
+++ a/fs/exec.c
@@ -722,12 +722,10 @@ static int exec_mmap(struct mm_struct *m
 		 * Make sure that if there is a core dump in progress
 		 * for the old mm, we get out and die instead of going
 		 * through with the exec.  We must hold mmap_sem around
-		 * checking core_waiters and changing tsk->mm.  The
-		 * core-inducing thread will increment core_waiters for
-		 * each thread whose ->mm == old_mm.
+		 * checking core_state and changing tsk->mm.
 		 */
 		down_read(&old_mm->mmap_sem);
-		if (unlikely(old_mm->core_waiters)) {
+		if (unlikely(old_mm->core_state)) {
 			up_read(&old_mm->mmap_sem);
 			return -EINTR;
 		}
@@ -1514,7 +1512,7 @@ static void zap_process(struct task_stru
 	t = start;
 	do {
 		if (t != current && t->mm) {
-			t->mm->core_waiters++;
+			t->mm->core_state->nr_threads++;
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
 		}
@@ -1538,11 +1536,11 @@ static inline int zap_threads(struct tas
 	if (err)
 		return err;
 
-	if (atomic_read(&mm->mm_users) == mm->core_waiters + 1)
+	if (atomic_read(&mm->mm_users) == mm->core_state->nr_threads + 1)
 		goto done;
 	/*
 	 * We should find and kill all tasks which use this mm, and we should
-	 * count them correctly into mm->core_waiters. We don't take tasklist
+	 * count them correctly into ->nr_threads. We don't take tasklist
 	 * lock, but this is safe wrt:
 	 *
 	 * fork:
@@ -1590,7 +1588,7 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	return mm->core_waiters;
+	return mm->core_state->nr_threads;
 }
 
 static int coredump_wait(int exit_code)
@@ -1603,9 +1601,12 @@ static int coredump_wait(int exit_code)
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state.startup);
+	core_state.nr_threads = 0;
 	mm->core_state = &core_state;
 
 	core_waiters = zap_threads(tsk, mm, exit_code);
+	if (core_waiters < 0)
+		mm->core_state = NULL;
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
@@ -1623,8 +1624,8 @@ static int coredump_wait(int exit_code)
 
 	if (core_waiters)
 		wait_for_completion(&core_state.startup);
+	mm->core_state = NULL;
 fail:
-	BUG_ON(mm->core_waiters);
 	return core_waiters;
 }
 
@@ -1702,7 +1703,7 @@ int do_coredump(long signr, int exit_cod
 	/*
 	 * If another thread got here first, or we are not dumpable, bail out.
 	 */
-	if (mm->core_waiters || !get_dumpable(mm)) {
+	if (mm->core_state || !get_dumpable(mm)) {
 		up_write(&mm->mmap_sem);
 		goto fail;
 	}
diff -puN include/linux/mm_types.h~coredump-move-mm-core_waiters-into-struct-core_state include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-move-mm-core_waiters-into-struct-core_state
+++ a/include/linux/mm_types.h
@@ -165,6 +165,7 @@ struct vm_area_struct {
 };
 
 struct core_state {
+	int nr_threads;
 	struct completion startup;
 };
 
@@ -184,7 +185,6 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	int map_count;				/* number of VMAs */
-	int core_waiters;
 	struct rw_semaphore mmap_sem;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
diff -puN kernel/exit.c~coredump-move-mm-core_waiters-into-struct-core_state kernel/exit.c
--- a/kernel/exit.c~coredump-move-mm-core_waiters-into-struct-core_state
+++ a/kernel/exit.c
@@ -657,16 +657,16 @@ static void exit_mm(struct task_struct *
 		return;
 	/*
 	 * Serialize with any possible pending coredump.
-	 * We must hold mmap_sem around checking core_waiters
+	 * We must hold mmap_sem around checking core_state
 	 * and clearing tsk->mm.  The core-inducing thread
-	 * will increment core_waiters for each thread in the
+	 * will increment ->nr_threads for each thread in the
 	 * group with ->mm != NULL.
 	 */
 	down_read(&mm->mmap_sem);
-	if (mm->core_waiters) {
+	if (mm->core_state) {
 		up_read(&mm->mmap_sem);
 		down_write(&mm->mmap_sem);
-		if (!--mm->core_waiters)
+		if (!--mm->core_state->nr_threads)
 			complete(&mm->core_state->startup);
 		up_write(&mm->mmap_sem);
 
diff -puN kernel/fork.c~coredump-move-mm-core_waiters-into-struct-core_state kernel/fork.c
--- a/kernel/fork.c~coredump-move-mm-core_waiters-into-struct-core_state
+++ a/kernel/fork.c
@@ -418,7 +418,7 @@ static struct mm_struct * mm_init(struct
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags
 				  : MMF_DUMP_FILTER_DEFAULT;
-	mm->core_waiters = 0;
+	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
 	set_mm_counter(mm, anon_rss, 0);
diff -puN kernel/signal.c~coredump-move-mm-core_waiters-into-struct-core_state kernel/signal.c
--- a/kernel/signal.c~coredump-move-mm-core_waiters-into-struct-core_state
+++ a/kernel/signal.c
@@ -1480,10 +1480,10 @@ static inline int may_ptrace_stop(void)
 	 * is a deadlock situation, and pointless because our tracer
 	 * is dead so don't allow us to stop.
 	 * If SIGKILL was already sent before the caller unlocked
-	 * ->siglock we must see ->core_waiters != 0. Otherwise it
+	 * ->siglock we must see ->core_state != NULL. Otherwise it
 	 * is safe to enter schedule().
 	 */
-	if (unlikely(current->mm->core_waiters) &&
+	if (unlikely(current->mm->core_state) &&
 	    unlikely(current->mm == current->parent->mm))
 		return 0;
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
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
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

