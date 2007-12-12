From: akpm@linux-foundation.org
Subject: + add-arch_ptrace_stop.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:51:58 -0800
Message-ID: <200712120551.lBC5pwin028309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbXLLFxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:53:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ptesarik@suse.cz, tony.luck@intel.com, willy@debian.org


The patch titled
     Add arch_ptrace_stop
has been added to the -mm tree.  Its filename is
     add-arch_ptrace_stop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add arch_ptrace_stop
From: Roland McGrath <roland@redhat.com>

This adds support to allow asm/ptrace.h to define two new macros,
arch_ptrace_stop_needed and arch_ptrace_stop.  These control special
machine-specific actions to be done before a ptrace stop.  The new code
compiles away to nothing when the new macros are not defined.  This is the
case on all machines to begin with.

On ia64, these macros will be defined to solve the long-standing issue of
ptrace vs register backing store.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Petr Tesarik <ptesarik@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |   35 +++++++++++++++++++++++++++++++++++
 kernel/signal.c        |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 1 deletion(-)

diff -puN include/linux/ptrace.h~add-arch_ptrace_stop include/linux/ptrace.h
--- a/include/linux/ptrace.h~add-arch_ptrace_stop
+++ a/include/linux/ptrace.h
@@ -203,6 +203,41 @@ static inline void user_enable_block_ste
 }
 #endif	/* arch_has_block_step */
 
+#ifndef arch_ptrace_stop_needed
+/**
+ * arch_ptrace_stop_needed - Decide whether arch_ptrace_stop() should be called
+ * @code:	current->exit_code value ptrace will stop with
+ * @info:	siginfo_t pointer (or %NULL) for signal ptrace will stop with
+ *
+ * This is called with the siglock held, to decide whether or not it's
+ * necessary to release the siglock and call arch_ptrace_stop() with the
+ * same @code and @info arguments.  It can be defined to a constant if
+ * arch_ptrace_stop() is never required, or always is.  On machines where
+ * this makes sense, it should be defined to a quick test to optimize out
+ * calling arch_ptrace_stop() when it would be superfluous.  For example,
+ * if the thread has not been back to user mode since the last stop, the
+ * thread state might indicate that nothing needs to be done.
+ */
+#define arch_ptrace_stop_needed(code, info)	(0)
+#endif
+
+#ifndef arch_ptrace_stop
+/**
+ * arch_ptrace_stop - Do machine-specific work before stopping for ptrace
+ * @code:	current->exit_code value ptrace will stop with
+ * @info:	siginfo_t pointer (or %NULL) for signal ptrace will stop with
+ *
+ * This is called with no locks held when arch_ptrace_stop_needed() has
+ * just returned nonzero.  It is allowed to block, e.g. for user memory
+ * access.  The arch can have machine-specific work to be done before
+ * ptrace stops.  On ia64, register backing store gets written back to user
+ * memory here.  Since this can be costly (requires dropping the siglock),
+ * we only do it when the arch requires it for this particular stop, as
+ * indicated by arch_ptrace_stop_needed().
+ */
+#define arch_ptrace_stop(code, info)		do { } while (0)
+#endif
+
 #endif
 
 #endif
diff -puN kernel/signal.c~add-arch_ptrace_stop kernel/signal.c
--- a/kernel/signal.c~add-arch_ptrace_stop
+++ a/kernel/signal.c
@@ -1577,6 +1577,17 @@ static inline int may_ptrace_stop(void)
 }
 
 /*
+ * Return nonzero if there is a SIGKILL that should be waking us up.
+ * Called with the siglock held.
+ */
+static int sigkill_pending(struct task_struct *tsk)
+{
+	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
+		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
+		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
+}
+
+/*
  * This must be called with current->sighand->siglock held.
  *
  * This should be the path for all ptrace stops.
@@ -1589,6 +1600,26 @@ static inline int may_ptrace_stop(void)
  */
 static void ptrace_stop(int exit_code, int nostop_code, siginfo_t *info)
 {
+	int killed = 0;
+
+	if (arch_ptrace_stop_needed(exit_code, info)) {
+		/*
+		 * The arch code has something special to do before a
+		 * ptrace stop.  This is allowed to block, e.g. for faults
+		 * on user stack pages.  We can't keep the siglock while
+		 * calling arch_ptrace_stop, so we must release it now.
+		 * To preserve proper semantics, we must do this before
+		 * any signal bookkeeping like checking group_stop_count.
+		 * Meanwhile, a SIGKILL could come in before we retake the
+		 * siglock.  That must prevent us from sleeping in TASK_TRACED.
+		 * So after regaining the lock, we must check for SIGKILL.
+		 */
+		spin_unlock_irq(&current->sighand->siglock);
+		arch_ptrace_stop(exit_code, info);
+		spin_lock_irq(&current->sighand->siglock);
+		killed = sigkill_pending(current);
+	}
+
 	/*
 	 * If there is a group stop in progress,
 	 * we must participate in the bookkeeping.
@@ -1604,7 +1635,7 @@ static void ptrace_stop(int exit_code, i
 	spin_unlock_irq(&current->sighand->siglock);
 	try_to_freeze();
 	read_lock(&tasklist_lock);
-	if (may_ptrace_stop()) {
+	if (!unlikely(killed) && may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();
_

Patches currently in -mm which might be from roland@redhat.com are

get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
git-x86.patch
use-__set_task_state-for-traced-stopped-tasks.patch
do_wait-remove-one-else-if-branch.patch
add-arch_ptrace_stop.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
do_wait-fix-security-checks-fix.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
fix-group-stop-with-exit-race.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
linux-kernel-markers-create-modpost-file.patch
