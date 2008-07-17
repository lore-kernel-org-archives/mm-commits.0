From: akpm@linux-foundation.org
Subject: + tracehook-release_task.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:30:45 -0700
Message-ID: <200807170830.m6H8UjZi006965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228AbYGQIbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:31:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: release_task
has been added to the -mm tree.  Its filename is
     tracehook-release_task.patch

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
Subject: tracehook: release_task
From: Roland McGrath <roland@redhat.com>

This moves the ptrace-related logic from release_task into tracehook.h and
ptrace.h inlines.  It provides clean hooks both before and after locking
tasklist_lock, for future tracing logic to do more cleanup without the
lock.

This also changes release_task() itself in the rare "zap_leader" case to
set the leader to EXIT_DEAD before iterating.  This maintains the
invariant that release_task() only ever handles a task in EXIT_DEAD.  This
is a common-sense invariant that is already always true except in this one
arcane case of zombie leader whose parent ignores SIGCHLD.

This change is harmless and only costs one store in this one rare case. 
It keeps the expected state more consisently sane, which is nicer when
debugging weirdness in release_task().  It also lets some future code in
the tracehook entry points rely on this invariant for bookkeeping.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h    |   13 +++++++++++++
 include/linux/tracehook.h |   28 ++++++++++++++++++++++++++++
 kernel/exit.c             |   21 +++++++++------------
 3 files changed, 50 insertions(+), 12 deletions(-)

diff -puN include/linux/ptrace.h~tracehook-release_task include/linux/ptrace.h
--- a/include/linux/ptrace.h~tracehook-release_task
+++ a/include/linux/ptrace.h
@@ -176,6 +176,19 @@ static inline void ptrace_init_task(stru
 	}
 }
 
+/**
+ * ptrace_release_task - final ptrace-related cleanup of a zombie being reaped
+ * @task:	task in %EXIT_DEAD state
+ *
+ * Called with write_lock(&tasklist_lock) held.
+ */
+static inline void ptrace_release_task(struct task_struct *task)
+{
+	BUG_ON(!list_empty(&task->ptraced));
+	ptrace_unlink(task);
+	BUG_ON(!list_empty(&task->ptrace_entry));
+}
+
 #ifndef force_successful_syscall_return
 /*
  * System call handlers that, upon successful completion, need to return a
diff -puN include/linux/tracehook.h~tracehook-release_task include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-release_task
+++ a/include/linux/tracehook.h
@@ -228,4 +228,32 @@ static inline void tracehook_report_vfor
 	ptrace_event(PT_TRACE_VFORK_DONE, PTRACE_EVENT_VFORK_DONE, pid);
 }
 
+/**
+ * tracehook_prepare_release_task - task is being reaped, clean up tracing
+ * @task:		task in %EXIT_DEAD state
+ *
+ * This is called in release_task() just before @task gets finally reaped
+ * and freed.  This would be the ideal place to remove and clean up any
+ * tracing-related state for @task.
+ *
+ * Called with no locks held.
+ */
+static inline void tracehook_prepare_release_task(struct task_struct *task)
+{
+}
+
+/**
+ * tracehook_finish_release_task - task is being reaped, clean up tracing
+ * @task:		task in %EXIT_DEAD state
+ *
+ * This is called in release_task() when @task is being in the middle of
+ * being reaped.  After this, there must be no tracing entanglements.
+ *
+ * Called with write_lock_irq(&tasklist_lock) held.
+ */
+static inline void tracehook_finish_release_task(struct task_struct *task)
+{
+	ptrace_release_task(task);
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/exit.c~tracehook-release_task kernel/exit.c
--- a/kernel/exit.c~tracehook-release_task
+++ a/kernel/exit.c
@@ -163,27 +163,17 @@ static void delayed_put_task_struct(stru
 	put_task_struct(container_of(rhp, struct task_struct, rcu));
 }
 
-/*
- * Do final ptrace-related cleanup of a zombie being reaped.
- *
- * Called with write_lock(&tasklist_lock) held.
- */
-static void ptrace_release_task(struct task_struct *p)
-{
-	BUG_ON(!list_empty(&p->ptraced));
-	ptrace_unlink(p);
-	BUG_ON(!list_empty(&p->ptrace_entry));
-}
 
 void release_task(struct task_struct * p)
 {
 	struct task_struct *leader;
 	int zap_leader;
 repeat:
+	tracehook_prepare_release_task(p);
 	atomic_dec(&p->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
-	ptrace_release_task(p);
+	tracehook_finish_release_task(p);
 	__exit_signal(p);
 
 	/*
@@ -205,6 +195,13 @@ repeat:
 		 * that case.
 		 */
 		zap_leader = task_detached(leader);
+
+		/*
+		 * This maintains the invariant that release_task()
+		 * only runs on a task in EXIT_DEAD, just for sanity.
+		 */
+		if (zap_leader)
+			leader->exit_state = EXIT_DEAD;
 	}
 
 	write_unlock_irq(&tasklist_lock);
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
ptrace-do_wait-reorganization.patch
ptrace-ptrace-children-revamp.patch
ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild.patch
ptrace-fix-dangling-zombie-when-new-parent-ignores-children.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch
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

