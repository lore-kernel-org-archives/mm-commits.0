From: akpm@linux-foundation.org
Subject: - coredump-move-mm-core_waiters-into-struct-core_state.patch removed from -mm tree
Date: Mon, 30 Jun 2008 16:39:54 -0700
Message-ID: <200806302339.m5UNdsoO031436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYF3XkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: move mm->core_waiters into struct core_state
has been removed from the -mm tree.  Its filename was
     coredump-move-mm-core_waiters-into-struct-core_state.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: move mm->core_waiters into struct core_state
From: Oleg Nesterov <oleg@tv-sign.ru>

Move mm->core_waiters into "struct core_state" allocated on stack. This
shrinks mm_struct a little bit and allows further changes.

This patch mostly does s/core_waiters/core_state. The only essential
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
 4 files changed, 17 insertions(+), 16 deletions(-)

diff -puN fs/exec.c~coredump-move-mm-core_waiters-into-struct-core_state fs/exec.c
--- a/fs/exec.c~coredump-move-mm-core_waiters-into-struct-core_state
+++ a/fs/exec.c
@@ -724,12 +724,10 @@ static int exec_mmap(struct mm_struct *m
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
@@ -1516,7 +1514,7 @@ static void zap_process(struct task_stru
 	t = start;
 	do {
 		if (t != current && t->mm) {
-			t->mm->core_waiters++;
+			t->mm->core_state->nr_threads++;
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
 		}
@@ -1540,11 +1538,11 @@ static inline int zap_threads(struct tas
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
@@ -1592,7 +1590,7 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	return mm->core_waiters;
+	return mm->core_state->nr_threads;
 }
 
 static int coredump_wait(int exit_code)
@@ -1605,9 +1603,12 @@ static int coredump_wait(int exit_code)
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state.startup);
+	core_state.nr_threads = 0;
 	mm->core_state = &core_state;
 
 	core_waiters = zap_threads(tsk, mm, exit_code);
+	if (core_waiters < 0)
+		mm->core_state = NULL;
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
@@ -1625,8 +1626,8 @@ static int coredump_wait(int exit_code)
 
 	if (core_waiters)
 		wait_for_completion(&core_state.startup);
+	mm->core_state = NULL;
 fail:
-	BUG_ON(mm->core_waiters);
 	return core_waiters;
 }
 
@@ -1704,7 +1705,7 @@ int do_coredump(long signr, int exit_cod
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
@@ -160,6 +160,7 @@ struct vm_area_struct {
 };
 
 struct core_state {
+	int nr_threads;
 	struct completion startup;
 };
 
@@ -179,7 +180,6 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	int map_count;				/* number of VMAs */
-	int core_waiters;
 	struct rw_semaphore mmap_sem;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
diff -puN kernel/exit.c~coredump-move-mm-core_waiters-into-struct-core_state kernel/exit.c
--- a/kernel/exit.c~coredump-move-mm-core_waiters-into-struct-core_state
+++ a/kernel/exit.c
@@ -662,16 +662,16 @@ static void exit_mm(struct task_struct *
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
@@ -406,7 +406,7 @@ static struct mm_struct * mm_init(struct
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags
 				  : MMF_DUMP_FILTER_DEFAULT;
-	mm->core_waiters = 0;
+	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
 	set_mm_counter(mm, anon_rss, 0);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
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
ptrace-never-sleep-in-task_traced-if-sigkilled.patch
ptrace-kill-may_ptrace_stop.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

