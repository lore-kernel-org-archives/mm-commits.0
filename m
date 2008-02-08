From: akpm@linux-foundation.org
Subject: - ptrace_stop-fix-racy-nonstop_code-setting.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:36 -0800
Message-ID: <200802082013.m18KDHbA010280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543AbYBHUvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace_stop: fix racy nonstop_code setting
has been removed from the -mm tree.  Its filename was
     ptrace_stop-fix-racy-nonstop_code-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN kernel/signal.c~ptrace_stop-fix-racy-nonstop_code-setting kernel/signal.c
--- a/kernel/signal.c~ptrace_stop-fix-racy-nonstop_code-setting
+++ a/kernel/signal.c
@@ -1591,10 +1591,10 @@ static int sigkill_pending(struct task_s
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
 	int killed = 0;
 
@@ -1641,7 +1641,8 @@ static void ptrace_stop(int exit_code, i
 		 * Don't drop the lock yet, another tracer may come.
 		 */
 		__set_current_state(TASK_RUNNING);
-		current->exit_code = nostop_code;
+		if (clear_code)
+			current->exit_code = 0;
 		read_unlock(&tasklist_lock);
 	}
 
@@ -1675,7 +1676,7 @@ void ptrace_notify(int exit_code)
 
 	/* Let the debugger run.  */
 	spin_lock_irq(&current->sighand->siglock);
-	ptrace_stop(exit_code, 0, &info);
+	ptrace_stop(exit_code, 1, &info);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -1782,7 +1783,7 @@ relock:
 			ptrace_signal_deliver(regs, cookie);
 
 			/* Let the debugger run.  */
-			ptrace_stop(signr, signr, info);
+			ptrace_stop(signr, 0, info);
 
 			/* We're back.  Did the debugger cancel the sig?  */
 			signr = current->exit_code;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
