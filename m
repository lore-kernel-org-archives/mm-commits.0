From: akpm@linux-foundation.org
Subject: - coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:00 -0700
Message-ID: <200807252300.m6PN00eG003447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755088AbYGYXGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: construct the list of coredumping threads at startup time
has been removed from the -mm tree.  Its filename was
     coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: construct the list of coredumping threads at startup time
From: Oleg Nesterov <oleg@tv-sign.ru>

binfmt->core_dump() has to iterate over the all threads in system in order
to find the coredumping threads and construct the list using the
GFP_ATOMIC allocations.

With this patch each thread allocates the list node on exit_mm()'s stack and
adds itself to the list.

This allows us to do further changes:

	- simplify ->core_dump()

	- change exit_mm() to clear ->mm first, then wait for ->core_done.
	  this makes the coredumping process visible to oom_kill

	- kill mm->core_done

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    2 ++
 include/linux/mm_types.h |    6 ++++++
 kernel/exit.c            |   15 ++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~coredump-construct-the-list-of-coredumping-threads-at-startup-time fs/exec.c
--- a/fs/exec.c~coredump-construct-the-list-of-coredumping-threads-at-startup-time
+++ a/fs/exec.c
@@ -1604,6 +1604,8 @@ static int coredump_wait(int exit_code, 
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state->startup);
+	core_state->dumper.task = tsk;
+	core_state->dumper.next = NULL;
 	core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
diff -puN include/linux/mm_types.h~coredump-construct-the-list-of-coredumping-threads-at-startup-time include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-construct-the-list-of-coredumping-threads-at-startup-time
+++ a/include/linux/mm_types.h
@@ -159,8 +159,14 @@ struct vm_area_struct {
 #endif
 };
 
+struct core_thread {
+	struct task_struct *task;
+	struct core_thread *next;
+};
+
 struct core_state {
 	atomic_t nr_threads;
+	struct core_thread dumper;
 	struct completion startup;
 };
 
diff -puN kernel/exit.c~coredump-construct-the-list-of-coredumping-threads-at-startup-time kernel/exit.c
--- a/kernel/exit.c~coredump-construct-the-list-of-coredumping-threads-at-startup-time
+++ a/kernel/exit.c
@@ -664,6 +664,7 @@ assign_new_owner:
 static void exit_mm(struct task_struct * tsk)
 {
 	struct mm_struct *mm = tsk->mm;
+	struct core_state *core_state;
 
 	mm_release(tsk, mm);
 	if (!mm)
@@ -676,11 +677,19 @@ static void exit_mm(struct task_struct *
 	 * group with ->mm != NULL.
 	 */
 	down_read(&mm->mmap_sem);
-	if (mm->core_state) {
+	core_state = mm->core_state;
+	if (core_state) {
+		struct core_thread self;
 		up_read(&mm->mmap_sem);
 
-		if (atomic_dec_and_test(&mm->core_state->nr_threads))
-			complete(&mm->core_state->startup);
+		self.task = tsk;
+		self.next = xchg(&core_state->dumper.next, &self);
+		/*
+		 * Implies mb(), the result of xchg() must be visible
+		 * to core_state->dumper.
+		 */
+		if (atomic_dec_and_test(&core_state->nr_threads))
+			complete(&core_state->startup);
 
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

