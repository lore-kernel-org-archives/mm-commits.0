From: akpm@linux-foundation.org
Subject: - coredump-make-mm-core_state-visible-to-core_dump.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:58 -0700
Message-ID: <200807252259.m6PMxwpE003444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894AbYGYXGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: make mm->core_state visible to ->core_dump()
has been removed from the -mm tree.  Its filename was
     coredump-make-mm-core_state-visible-to-core_dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: make mm->core_state visible to ->core_dump()
From: Oleg Nesterov <oleg@tv-sign.ru>

Move the "struct core_state core_state" from coredump_wait() to
do_coredump(), this makes mm->core_state visible to binfmt->core_dump().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~coredump-make-mm-core_state-visible-to-core_dump fs/exec.c
--- a/fs/exec.c~coredump-make-mm-core_state-visible-to-core_dump
+++ a/fs/exec.c
@@ -1595,17 +1595,16 @@ done:
 	return nr;
 }
 
-static int coredump_wait(int exit_code)
+static int coredump_wait(int exit_code, struct core_state *core_state)
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	struct core_state core_state;
 	struct completion *vfork_done;
 	int core_waiters;
 
 	init_completion(&mm->core_done);
-	init_completion(&core_state.startup);
-	core_waiters = zap_threads(tsk, mm, &core_state, exit_code);
+	init_completion(&core_state->startup);
+	core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
@@ -1622,8 +1621,7 @@ static int coredump_wait(int exit_code)
 	}
 
 	if (core_waiters)
-		wait_for_completion(&core_state.startup);
-	mm->core_state = NULL;
+		wait_for_completion(&core_state->startup);
 fail:
 	return core_waiters;
 }
@@ -1679,6 +1677,7 @@ int get_dumpable(struct mm_struct *mm)
 
 int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 {
+	struct core_state core_state;
 	char corename[CORENAME_MAX_SIZE + 1];
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
@@ -1717,7 +1716,7 @@ int do_coredump(long signr, int exit_cod
 		current->fsuid = 0;	/* Dump root private */
 	}
 
-	retval = coredump_wait(exit_code);
+	retval = coredump_wait(exit_code, &core_state);
 	if (retval < 0)
 		goto fail;
 
@@ -1812,6 +1811,7 @@ fail_unlock:
 
 	current->fsuid = fsuid;
 	complete_all(&mm->core_done);
+	mm->core_state = NULL;
 fail:
 	return retval;
 }
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

