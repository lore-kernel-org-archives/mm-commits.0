From: akpm@linux-foundation.org
Subject: - coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:54 -0700
Message-ID: <200807252259.m6PMxsJO003432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYGYXAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: turn mm->core_startup_done into the pointer to struct core_state
has been removed from the -mm tree.  Its filename was
     coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: turn mm->core_startup_done into the pointer to struct core_state
From: Oleg Nesterov <oleg@tv-sign.ru>

mm->core_startup_done points to "struct completion startup_done" allocated
on the coredump_wait()'s stack.  Introduce the new structure, core_state,
which holds this "struct completion".  This way we can add more info
visible to the threads participating in coredump without enlarging
mm_struct.

No changes in affected .o files.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    8 ++++----
 include/linux/mm_types.h |    7 ++++++-
 kernel/exit.c            |    2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/exec.c~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state fs/exec.c
--- a/fs/exec.c~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state
+++ a/fs/exec.c
@@ -1597,13 +1597,13 @@ static int coredump_wait(int exit_code)
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	struct completion startup_done;
+	struct core_state core_state;
 	struct completion *vfork_done;
 	int core_waiters;
 
 	init_completion(&mm->core_done);
-	init_completion(&startup_done);
-	mm->core_startup_done = &startup_done;
+	init_completion(&core_state.startup);
+	mm->core_state = &core_state;
 
 	core_waiters = zap_threads(tsk, mm, exit_code);
 	up_write(&mm->mmap_sem);
@@ -1622,7 +1622,7 @@ static int coredump_wait(int exit_code)
 	}
 
 	if (core_waiters)
-		wait_for_completion(&startup_done);
+		wait_for_completion(&core_state.startup);
 fail:
 	BUG_ON(mm->core_waiters);
 	return core_waiters;
diff -puN include/linux/mm_types.h~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state
+++ a/include/linux/mm_types.h
@@ -159,6 +159,10 @@ struct vm_area_struct {
 #endif
 };
 
+struct core_state {
+	struct completion startup;
+};
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -220,7 +224,8 @@ struct mm_struct {
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
-	struct completion *core_startup_done, core_done;
+	struct core_state *core_state;
+	struct completion core_done;
 
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;	/* aio lock */
diff -puN kernel/exit.c~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state kernel/exit.c
--- a/kernel/exit.c~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state
+++ a/kernel/exit.c
@@ -680,7 +680,7 @@ static void exit_mm(struct task_struct *
 		up_read(&mm->mmap_sem);
 		down_write(&mm->mmap_sem);
 		if (!--mm->core_waiters)
-			complete(mm->core_startup_done);
+			complete(&mm->core_state->startup);
 		up_write(&mm->mmap_sem);
 
 		wait_for_completion(&mm->core_done);
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

