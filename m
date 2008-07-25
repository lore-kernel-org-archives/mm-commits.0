From: akpm@linux-foundation.org
Subject: - coredump-kill-mm-core_done.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:06 -0700
Message-ID: <200807252300.m6PN06PJ003554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754611AbYGYXGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: kill mm->core_done
has been removed from the -mm tree.  Its filename was
     coredump-kill-mm-core_done.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -229,9 +229,7 @@ struct mm_struct {
 
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
@@ -691,7 +691,13 @@ static void exit_mm(struct task_struct *
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

