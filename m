From: akpm@linux-foundation.org
Subject: - handle_stop_signal-unify-partial-full-stop-handling.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:19 -0700
Message-ID: <200805010926.m419QJsM030288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757338AbYEAJ1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     handle_stop_signal: unify partial/full stop handling
has been removed from the -mm tree.  Its filename was
     handle_stop_signal-unify-partial-full-stop-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: handle_stop_signal: unify partial/full stop handling
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that handle_stop_signal() doesn't drop ->siglock, we can't see both
->group_stop_count && SIGNAL_STOP_STOPPED.  Merge two "if" branches.

As Roland pointed out, we never actually needed 2 do_notify_parent_cldstop()
calls.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff -puN kernel/signal.c~handle_stop_signal-unify-partial-full-stop-handling kernel/signal.c
--- a/kernel/signal.c~handle_stop_signal-unify-partial-full-stop-handling
+++ a/kernel/signal.c
@@ -585,33 +585,16 @@ static void handle_stop_signal(int sig, 
 			t = next_thread(t);
 		} while (t != p);
 	} else if (sig == SIGCONT) {
+		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues,
 		 * and wake all threads.
 		 */
-		if (unlikely(p->signal->group_stop_count > 0)) {
-			/*
-			 * There was a group stop in progress.  We'll
-			 * pretend it finished before we got here.  We are
-			 * obliged to report it to the parent: if the
-			 * SIGSTOP happened "after" this SIGCONT, then it
-			 * would have cleared this pending SIGCONT.  If it
-			 * happened "before" this SIGCONT, then the parent
-			 * got the SIGCHLD about the stop finishing before
-			 * the continue happened.  We do the notification
-			 * now, and it's as if the stop had finished and
-			 * the SIGCHLD was pending on entry to this kill.
-			 */
-			p->signal->group_stop_count = 0;
-			p->signal->flags = SIGNAL_STOP_CONTINUED |
-						SIGNAL_CLD_STOPPED;
-		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			
 			/*
 			 * If there is a handler for SIGCONT, we must make
 			 * sure that no thread returns to user mode before
@@ -621,7 +604,7 @@ static void handle_stop_signal(int sig, 
 			 * running the handler.  With the TIF_SIGPENDING
 			 * flag set, the thread will pause and acquire the
 			 * siglock that we hold now and until we've queued
-			 * the pending signal. 
+			 * the pending signal.
 			 *
 			 * Wake up the stopped thread _after_ setting
 			 * TIF_SIGPENDING
@@ -636,13 +619,23 @@ static void handle_stop_signal(int sig, 
 			t = next_thread(t);
 		} while (t != p);
 
-		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
-			/*
-			 * We were in fact stopped, and are now continued.
-			 * Notify the parent with CLD_CONTINUED.
-			 */
-			p->signal->flags = SIGNAL_STOP_CONTINUED |
-						SIGNAL_CLD_CONTINUED;
+		/*
+		 * Notify the parent with CLD_CONTINUED if we were stopped.
+		 *
+		 * If we were in the middle of a group stop, we pretend it
+		 * was already finished, and then continued. Since SIGCHLD
+		 * doesn't queue we report only CLD_STOPPED, as if the next
+		 * CLD_CONTINUED was dropped.
+		 */
+		why = 0;
+		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+			why |= SIGNAL_CLD_CONTINUED;
+		else if (p->signal->group_stop_count)
+			why |= SIGNAL_CLD_STOPPED;
+
+		if (why) {
+			p->signal->flags = why | SIGNAL_STOP_CONTINUED;
+			p->signal->group_stop_count = 0;
 			p->signal->group_exit_code = 0;
 		} else {
 			/*
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

