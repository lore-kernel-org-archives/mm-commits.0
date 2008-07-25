From: akpm@linux-foundation.org
Subject: - coredump-turn-core_state-nr_threads-into-atomic_t.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:57 -0700
Message-ID: <200807252259.m6PMxvai003441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852AbYGYXGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: turn core_state->nr_threads into atomic_t
has been removed from the -mm tree.  Its filename was
     coredump-turn-core_state-nr_threads-into-atomic_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: turn core_state->nr_threads into atomic_t
From: Oleg Nesterov <oleg@tv-sign.ru>

Turn core_state->nr_threads into atomic_t and kill now unneeded
down_write(&mm->mmap_sem) in exit_mm().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    2 +-
 include/linux/mm_types.h |    2 +-
 kernel/exit.c            |    5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~coredump-turn-core_state-nr_threads-into-atomic_t fs/exec.c
--- a/fs/exec.c~coredump-turn-core_state-nr_threads-into-atomic_t
+++ a/fs/exec.c
@@ -1591,7 +1591,7 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	core_state->nr_threads = nr;
+	atomic_set(&core_state->nr_threads, nr);
 	return nr;
 }
 
diff -puN include/linux/mm_types.h~coredump-turn-core_state-nr_threads-into-atomic_t include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-turn-core_state-nr_threads-into-atomic_t
+++ a/include/linux/mm_types.h
@@ -160,7 +160,7 @@ struct vm_area_struct {
 };
 
 struct core_state {
-	int nr_threads;
+	atomic_t nr_threads;
 	struct completion startup;
 };
 
diff -puN kernel/exit.c~coredump-turn-core_state-nr_threads-into-atomic_t kernel/exit.c
--- a/kernel/exit.c~coredump-turn-core_state-nr_threads-into-atomic_t
+++ a/kernel/exit.c
@@ -678,10 +678,9 @@ static void exit_mm(struct task_struct *
 	down_read(&mm->mmap_sem);
 	if (mm->core_state) {
 		up_read(&mm->mmap_sem);
-		down_write(&mm->mmap_sem);
-		if (!--mm->core_state->nr_threads)
+
+		if (atomic_dec_and_test(&mm->core_state->nr_threads))
 			complete(&mm->core_state->startup);
-		up_write(&mm->mmap_sem);
 
 		wait_for_completion(&mm->core_done);
 		down_read(&mm->mmap_sem);
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

