From: akpm@linux-foundation.org
Subject: - move-the-related-code-from-exit_notify-to-exit_signals.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:06 -0800
Message-ID: <200802082013.m18KDlHW010320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758670AbYBHVDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     move the related code from exit_notify() to exit_signals()
has been removed from the -mm tree.  Its filename was
     move-the-related-code-from-exit_notify-to-exit_signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: move the related code from exit_notify() to exit_signals()
From: Oleg Nesterov <oleg@tv-sign.ru>

The previous bugfix was not optimal, we shouldn't care about group stop
when we are the only thread or the group stop is in progress.  In that case
nothing special is needed, just set PF_EXITING and return.

Also, take the related "TIF_SIGPENDING re-targeting" code from exit_notify().

So, from the performance POV the only difference is that we don't trust
!signal_pending() until we take ->siglock.  But this in fact fixes another
___pure___ theoretical minor race.  __group_complete_signal() finds the
task without PF_EXITING and chooses it as the target for signal_wake_up(). 
But nothing prevents this task from exiting in between without noticing the
pending signal and thus unpredictably delaying the actual delivery.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c   |   18 ------------------
 kernel/signal.c |   27 ++++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 23 deletions(-)

diff -puN kernel/exit.c~move-the-related-code-from-exit_notify-to-exit_signals kernel/exit.c
--- a/kernel/exit.c~move-the-related-code-from-exit_notify-to-exit_signals
+++ a/kernel/exit.c
@@ -745,24 +745,6 @@ static void exit_notify(struct task_stru
 	struct task_struct *t;
 	struct pid *pgrp;
 
-	if (signal_pending(tsk) && !(tsk->signal->flags & SIGNAL_GROUP_EXIT)
-	    && !thread_group_empty(tsk)) {
-		/*
-		 * This occurs when there was a race between our exit
-		 * syscall and a group signal choosing us as the one to
-		 * wake up.  It could be that we are the only thread
-		 * alerted to check for pending signals, but another thread
-		 * should be woken now to take the signal since we will not.
-		 * Now we'll wake all the threads in the group just to make
-		 * sure someone gets all the pending signals.
-		 */
-		spin_lock_irq(&tsk->sighand->siglock);
-		for (t = next_thread(tsk); t != tsk; t = next_thread(t))
-			if (!signal_pending(t) && !(t->flags & PF_EXITING))
-				recalc_sigpending_and_wake(t);
-		spin_unlock_irq(&tsk->sighand->siglock);
-	}
-
 	/*
 	 * This does two things:
 	 *
diff -puN kernel/signal.c~move-the-related-code-from-exit_notify-to-exit_signals kernel/signal.c
--- a/kernel/signal.c~move-the-related-code-from-exit_notify-to-exit_signals
+++ a/kernel/signal.c
@@ -1903,19 +1903,36 @@ relock:
 void exit_signals(struct task_struct *tsk)
 {
 	int group_stop = 0;
+	struct task_struct *t;
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (unlikely(tsk->signal->group_stop_count) &&
-			!--tsk->signal->group_stop_count) {
-		tsk->signal->flags = SIGNAL_STOP_STOPPED;
-		group_stop = 1;
+	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
+		tsk->flags |= PF_EXITING;
+		return;
 	}
 
+	spin_lock_irq(&tsk->sighand->siglock);
 	/*
 	 * From now this task is not visible for group-wide signals,
 	 * see wants_signal(), do_signal_stop().
 	 */
 	tsk->flags |= PF_EXITING;
+	if (!signal_pending(tsk))
+		goto out;
+
+	/* It could be that __group_complete_signal() choose us to
+	 * notify about group-wide signal. Another thread should be
+	 * woken now to take the signal since we will not.
+	 */
+	for (t = tsk; (t = next_thread(t)) != tsk; )
+		if (!signal_pending(t) && !(t->flags & PF_EXITING))
+			recalc_sigpending_and_wake(t);
+
+	if (unlikely(tsk->signal->group_stop_count) &&
+			!--tsk->signal->group_stop_count) {
+		tsk->signal->flags = SIGNAL_STOP_STOPPED;
+		group_stop = 1;
+	}
+out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
 	if (unlikely(group_stop)) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
