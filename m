From: akpm@linux-foundation.org
Subject: + tracehook-wait_task_inactive.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:31:14 -0700
Message-ID: <200807170831.m6H8VEGO007018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966AbYGQIkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: wait_task_inactive
has been added to the -mm tree.  Its filename is
     tracehook-wait_task_inactive.patch

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
Subject: tracehook: wait_task_inactive
From: Roland McGrath <roland@redhat.com>

This extends wait_task_inactive() with a new argument so it can be used in
a "soft" mode where it will check for the task changing state unexpectedly
and back off.  There is no change to existing callers.  This lays the
groundwork to allow robust, noninvasive tracing that can try to sample a
blocked thread but back off safely if it wakes up.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    4 ++--
 include/linux/sched.h      |    8 ++++++--
 kernel/kthread.c           |    2 +-
 kernel/ptrace.c            |    2 +-
 kernel/sched.c             |   29 +++++++++++++++++++++++++++--
 5 files changed, 37 insertions(+), 8 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~tracehook-wait_task_inactive arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~tracehook-wait_task_inactive
+++ a/arch/ia64/kernel/perfmon.c
@@ -2626,7 +2626,7 @@ pfm_task_incompatible(pfm_context_t *ctx
 	/*
 	 * make sure the task is off any CPU
 	 */
-	wait_task_inactive(task);
+	wait_task_inactive(task, 0);
 
 	/* more to come... */
 
@@ -4774,7 +4774,7 @@ recheck:
 
 		UNPROTECT_CTX(ctx, flags);
 
-		wait_task_inactive(task);
+		wait_task_inactive(task, 0);
 
 		PROTECT_CTX(ctx, flags);
 
diff -puN include/linux/sched.h~tracehook-wait_task_inactive include/linux/sched.h
--- a/include/linux/sched.h~tracehook-wait_task_inactive
+++ a/include/linux/sched.h
@@ -1872,9 +1872,13 @@ extern void set_task_comm(struct task_st
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
-extern void wait_task_inactive(struct task_struct * p);
+extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
-#define wait_task_inactive(p)	do { } while (0)
+static inline unsigned long wait_task_inactive(struct task_struct *p,
+					       long match_state)
+{
+	return 1;
+}
 #endif
 
 #define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
diff -puN kernel/kthread.c~tracehook-wait_task_inactive kernel/kthread.c
--- a/kernel/kthread.c~tracehook-wait_task_inactive
+++ a/kernel/kthread.c
@@ -157,7 +157,7 @@ void kthread_bind(struct task_struct *k,
 		return;
 	}
 	/* Must have done schedule() in kthread() before we set_task_cpu */
-	wait_task_inactive(k);
+	wait_task_inactive(k, 0);
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
 	k->rt.nr_cpus_allowed = 1;
diff -puN kernel/ptrace.c~tracehook-wait_task_inactive kernel/ptrace.c
--- a/kernel/ptrace.c~tracehook-wait_task_inactive
+++ a/kernel/ptrace.c
@@ -107,7 +107,7 @@ int ptrace_check_attach(struct task_stru
 	read_unlock(&tasklist_lock);
 
 	if (!ret && !kill)
-		wait_task_inactive(child);
+		ret = wait_task_inactive(child, TASK_TRACED) ? 0 : -ESRCH;
 
 	/* All systems go.. */
 	return ret;
diff -puN kernel/sched.c~tracehook-wait_task_inactive kernel/sched.c
--- a/kernel/sched.c~tracehook-wait_task_inactive
+++ a/kernel/sched.c
@@ -1946,16 +1946,24 @@ migrate_task(struct task_struct *p, int 
 /*
  * wait_task_inactive - wait for a thread to unschedule.
  *
+ * If @match_state is nonzero, it's the @p->state value just checked and
+ * not expected to change.  If it changes, i.e. @p might have woken up,
+ * then return zero.  When we succeed in waiting for @p to be off its CPU,
+ * we return a positive number (its total switch count).  If a second call
+ * a short while later returns the same number, the caller can be sure that
+ * @p has remained unscheduled the whole time.
+ *
  * The caller must ensure that the task *will* unschedule sometime soon,
  * else this function might spin for a *long* time. This function can't
  * be called with interrupts off, or it may introduce deadlock with
  * smp_call_function() if an IPI is sent by the same process we are
  * waiting to become inactive.
  */
-void wait_task_inactive(struct task_struct *p)
+unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 {
 	unsigned long flags;
 	int running, on_rq;
+	unsigned long ncsw;
 	struct rq *rq;
 
 	for (;;) {
@@ -1978,8 +1986,11 @@ void wait_task_inactive(struct task_stru
 		 * return false if the runqueue has changed and p
 		 * is actually now running somewhere else!
 		 */
-		while (task_running(rq, p))
+		while (task_running(rq, p)) {
+			if (match_state && unlikely(p->state != match_state))
+				return 0;
 			cpu_relax();
+		}
 
 		/*
 		 * Ok, time to look more closely! We need the rq
@@ -1989,9 +2000,21 @@ void wait_task_inactive(struct task_stru
 		rq = task_rq_lock(p, &flags);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
+		ncsw = 0;
+		if (!match_state || p->state == match_state) {
+			ncsw = p->nivcsw + p->nvcsw;
+			if (unlikely(!ncsw))
+				ncsw = 1;
+		}
 		task_rq_unlock(rq, &flags);
 
 		/*
+		 * If it changed from the expected state, bail out now.
+		 */
+		if (unlikely(!ncsw))
+			break;
+
+		/*
 		 * Was it really running after all now that we
 		 * checked with the proper locks actually held?
 		 *
@@ -2023,6 +2046,8 @@ void wait_task_inactive(struct task_stru
 		 */
 		break;
 	}
+
+	return ncsw;
 }
 
 /***
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

