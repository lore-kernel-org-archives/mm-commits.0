From: akpm@linux-foundation.org
Subject: - fix-group-stop-with-exit-race.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:01 -0800
Message-ID: <200802082013.m18KDgiF010314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758663AbYBHVDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix group stop with exit race
has been removed from the -mm tree.  Its filename was
     fix-group-stop-with-exit-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix group stop with exit race
From: Oleg Nesterov <oleg@tv-sign.ru>

do_signal_stop() counts all sub-thread and sets ->group_stop_count
accordingly.  Every thread should decrement ->group_stop_count and stop,
the last one should notify the parent.

However a sub-thread can exit before it notices the signal_pending(), or it
may be somewhere in do_exit() already.  In that case the group stop never
finishes properly.

Note: this is a minimal fix, we can add some optimizations later.  Say we
can return quickly if thread_group_empty().  Also, we can move some signal
related code from exit_notify() to exit_signals().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 +
 kernel/exit.c          |    2 +-
 kernel/signal.c        |   27 ++++++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 2 deletions(-)

diff -puN include/linux/signal.h~fix-group-stop-with-exit-race include/linux/signal.h
--- a/include/linux/signal.h~fix-group-stop-with-exit-race
+++ a/include/linux/signal.h
@@ -241,6 +241,7 @@ extern int show_unhandled_signals;
 
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern void exit_signals(struct task_struct *tsk);
 
 extern struct kmem_cache *sighand_cachep;
 
diff -puN kernel/exit.c~fix-group-stop-with-exit-race kernel/exit.c
--- a/kernel/exit.c~fix-group-stop-with-exit-race
+++ a/kernel/exit.c
@@ -947,7 +947,7 @@ fastcall NORET_TYPE void do_exit(long co
 		schedule();
 	}
 
-	tsk->flags |= PF_EXITING;
+	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
 	 * an exiting task cleaning up the robust pi futexes.
diff -puN kernel/signal.c~fix-group-stop-with-exit-race kernel/signal.c
--- a/kernel/signal.c~fix-group-stop-with-exit-race
+++ a/kernel/signal.c
@@ -1739,7 +1739,7 @@ static int do_signal_stop(int signr)
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
-			if (!t->exit_state &&
+			if (!(t->flags & PF_EXITING) &&
 			    !task_is_stopped_or_traced(t)) {
 				stop_count++;
 				signal_wake_up(t, 0);
@@ -1900,6 +1900,31 @@ relock:
 	return signr;
 }
 
+void exit_signals(struct task_struct *tsk)
+{
+	int group_stop = 0;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (unlikely(tsk->signal->group_stop_count) &&
+			!--tsk->signal->group_stop_count) {
+		tsk->signal->flags = SIGNAL_STOP_STOPPED;
+		group_stop = 1;
+	}
+
+	/*
+	 * From now this task is not visible for group-wide signals,
+	 * see wants_signal(), do_signal_stop().
+	 */
+	tsk->flags |= PF_EXITING;
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (unlikely(group_stop)) {
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(tsk, CLD_STOPPED);
+		read_unlock(&tasklist_lock);
+	}
+}
+
 EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
