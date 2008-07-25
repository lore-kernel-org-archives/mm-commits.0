From: akpm@linux-foundation.org
Subject: - coredump-simplify-core_state-nr_threads-calculation.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:56 -0700
Message-ID: <200807252259.m6PMxuFH003438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029AbYGYXGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: simplify core_state->nr_threads calculation
has been removed from the -mm tree.  Its filename was
     coredump-simplify-core_state-nr_threads-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: simplify core_state->nr_threads calculation
From: Oleg Nesterov <oleg@tv-sign.ru>

Change zap_process() to return int instead of incrementing
mm->core_state->nr_threads directly.  Change zap_threads() to set
mm->core_state only on success.

This patch restores the original size of .text, and more importantly now
->nr_threads is used in two places only.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff -puN fs/exec.c~coredump-simplify-core_state-nr_threads-calculation fs/exec.c
--- a/fs/exec.c~coredump-simplify-core_state-nr_threads-calculation
+++ a/fs/exec.c
@@ -1502,9 +1502,10 @@ out:
 	return ispipe;
 }
 
-static void zap_process(struct task_struct *start)
+static int zap_process(struct task_struct *start)
 {
 	struct task_struct *t;
+	int nr = 0;
 
 	start->signal->flags = SIGNAL_GROUP_EXIT;
 	start->signal->group_stop_count = 0;
@@ -1512,31 +1513,33 @@ static void zap_process(struct task_stru
 	t = start;
 	do {
 		if (t != current && t->mm) {
-			t->mm->core_state->nr_threads++;
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
+			nr++;
 		}
 	} while_each_thread(start, t);
+
+	return nr;
 }
 
 static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
-				int exit_code)
+				struct core_state *core_state, int exit_code)
 {
 	struct task_struct *g, *p;
 	unsigned long flags;
-	int err = -EAGAIN;
+	int nr = -EAGAIN;
 
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
+		mm->core_state = core_state;
 		tsk->signal->group_exit_code = exit_code;
-		zap_process(tsk);
-		err = 0;
+		nr = zap_process(tsk);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
-	if (err)
-		return err;
+	if (unlikely(nr < 0))
+		return nr;
 
-	if (atomic_read(&mm->mm_users) == mm->core_state->nr_threads + 1)
+	if (atomic_read(&mm->mm_users) == nr + 1)
 		goto done;
 	/*
 	 * We should find and kill all tasks which use this mm, and we should
@@ -1579,7 +1582,7 @@ static inline int zap_threads(struct tas
 			if (p->mm) {
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
-					zap_process(p);
+					nr += zap_process(p);
 					unlock_task_sighand(p, &flags);
 				}
 				break;
@@ -1588,7 +1591,8 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	return mm->core_state->nr_threads;
+	core_state->nr_threads = nr;
+	return nr;
 }
 
 static int coredump_wait(int exit_code)
@@ -1601,12 +1605,7 @@ static int coredump_wait(int exit_code)
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state.startup);
-	core_state.nr_threads = 0;
-	mm->core_state = &core_state;
-
-	core_waiters = zap_threads(tsk, mm, exit_code);
-	if (core_waiters < 0)
-		mm->core_state = NULL;
+	core_waiters = zap_threads(tsk, mm, &core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
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

