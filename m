From: akpm@linux-foundation.org
Subject: - signals-__group_complete_signal-cache-the-value-of-p-signal.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:29 -0700
Message-ID: <200805010926.m419QTSF030303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618AbYEAJ11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: __group_complete_signal: cache the value of p->signal
has been removed from the -mm tree.  Its filename was
     signals-__group_complete_signal-cache-the-value-of-p-signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: __group_complete_signal: cache the value of p->signal
From: Oleg Nesterov <oleg@tv-sign.ru>

Cosmetic, cache p->signal to make the code a bit more readable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN kernel/signal.c~signals-__group_complete_signal-cache-the-value-of-p-signal kernel/signal.c
--- a/kernel/signal.c~signals-__group_complete_signal-cache-the-value-of-p-signal
+++ a/kernel/signal.c
@@ -842,6 +842,7 @@ static inline int wants_signal(int sig, 
 static void
 __group_complete_signal(int sig, struct task_struct *p)
 {
+	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
 	/*
@@ -862,14 +863,14 @@ __group_complete_signal(int sig, struct 
 		/*
 		 * Otherwise try to find a suitable thread.
 		 */
-		t = p->signal->curr_target;
+		t = signal->curr_target;
 		if (t == NULL)
 			/* restart balancing at this thread */
-			t = p->signal->curr_target = p;
+			t = signal->curr_target = p;
 
 		while (!wants_signal(sig, t)) {
 			t = next_thread(t);
-			if (t == p->signal->curr_target)
+			if (t == signal->curr_target)
 				/*
 				 * No thread needs to be woken.
 				 * Any eligible threads will see
@@ -877,14 +878,14 @@ __group_complete_signal(int sig, struct 
 				 */
 				return;
 		}
-		p->signal->curr_target = t;
+		signal->curr_target = t;
 	}
 
 	/*
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	if (sig_fatal(p, sig) && !(p->signal->flags & SIGNAL_GROUP_EXIT) &&
+	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
 		/*
@@ -897,9 +898,9 @@ __group_complete_signal(int sig, struct 
 			 * running and doing things after a slower
 			 * thread has the fatal signal pending.
 			 */
-			p->signal->flags = SIGNAL_GROUP_EXIT;
-			p->signal->group_exit_code = sig;
-			p->signal->group_stop_count = 0;
+			signal->flags = SIGNAL_GROUP_EXIT;
+			signal->group_exit_code = sig;
+			signal->group_stop_count = 0;
 			t = p;
 			do {
 				sigaddset(&t->pending.signal, SIGKILL);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

