From: akpm@linux-foundation.org
Subject: + ptrace_stop-fix-racy-nonstop_code-setting.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:25:13 -0800
Message-ID: <200711270525.lAR5PDrN028920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbXK0F0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:26:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     ptrace_stop: fix racy nonstop_code setting
has been added to the -mm tree.  Its filename is
     ptrace_stop-fix-racy-nonstop_code-setting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ptrace_stop: fix racy nonstop_code setting
From: Oleg Nesterov <oleg@tv-sign.ru>

If the tracer is gone and we are not going to stop, ptrace_stop() sets
->exit_code = nostop_code.  However, the tracer could actually clear the
exit code before detaching.  In that case get_signal_to_deliver() "resends"
the signal which was cancelled by the debugger.  For example, it is
possible that a quick PTRACE_ATTACH + PTRACE_DETACH can leave the tracee in
STOPPED state.

Change the behaviour of ptrace_stop().  If the caller is ptrace notify(),
we should always clear ->exit_code.  If the caller is
get_signal_to_deliver(), we should not touch it at all.  To do so, change
the nonstop_code parameter to "bool clear_code" and change the callers
accordingly.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN kernel/signal.c~ptrace_stop-fix-racy-nonstop_code-setting kernel/signal.c
--- a/kernel/signal.c~ptrace_stop-fix-racy-nonstop_code-setting
+++ a/kernel/signal.c
@@ -1601,10 +1601,10 @@ static inline int may_ptrace_stop(void)
  * That makes it a way to test a stopped process for
  * being ptrace-stopped vs being job-control-stopped.
  *
- * If we actually decide not to stop at all because the tracer is gone,
- * we leave nostop_code in current->exit_code.
+ * If we actually decide not to stop at all because the tracer
+ * is gone, we keep current->exit_code unless clear_code.
  */
-static void ptrace_stop(int exit_code, int nostop_code, siginfo_t *info)
+static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 {
 	/*
 	 * If there is a group stop in progress,
@@ -1631,7 +1631,8 @@ static void ptrace_stop(int exit_code, i
 		 * Don't drop the lock yet, another tracer may come.
 		 */
 		__set_current_state(TASK_RUNNING);
-		current->exit_code = nostop_code;
+		if (clear_code)
+			current->exit_code = 0;
 		read_unlock(&tasklist_lock);
 	}
 
@@ -1665,7 +1666,7 @@ void ptrace_notify(int exit_code)
 
 	/* Let the debugger run.  */
 	spin_lock_irq(&current->sighand->siglock);
-	ptrace_stop(exit_code, 0, &info);
+	ptrace_stop(exit_code, 1, &info);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -1813,7 +1814,7 @@ relock:
 			ptrace_signal_deliver(regs, cookie);
 
 			/* Let the debugger run.  */
-			ptrace_stop(signr, signr, info);
+			ptrace_stop(signr, 0, info);
 
 			/* We're back.  Did the debugger cancel the sig?  */
 			signr = current->exit_code;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
wait_task_stopped-pass-correct-exit_code-to.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
