From: akpm@linux-foundation.org
Subject: - coredump-move-mm-core_waiters-into-struct-core_state.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:55 -0700
Message-ID: <200807252259.m6PMxt0Q003435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbYGYXAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: move mm->core_waiters into struct core_state
has been removed from the -mm tree.  Its filename was
     coredump-move-mm-core_waiters-into-struct-core_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -670,16 +670,16 @@ static void exit_mm(struct task_struct *
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
@@ -400,7 +400,7 @@ static struct mm_struct * mm_init(struct
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

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

