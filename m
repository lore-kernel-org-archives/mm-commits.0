From: akpm@linux-foundation.org
Subject: - signals-use-__group_complete_signal-for-the-specific-signals-too.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:45 -0700
Message-ID: <200805010926.m419Qj6c030327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757495AbYEAJ1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     signals: use __group_complete_signal() for the specific signals too
has been removed from the -mm tree.  Its filename was
     signals-use-__group_complete_signal-for-the-specific-signals-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: use __group_complete_signal() for the specific signals too
From: Oleg Nesterov <oleg@tv-sign.ru>

Based on Pavel Emelyanov's suggestion.

Rename __group_complete_signal() to complete_signal() and use it to process
the specific signals too.  To do this we simply add the "int group" argument.

This allows us to greatly simply the signal-sending code and adds a useful
behaviour change.  We can avoid the unneeded wakeups for the private signals
because wants_signal() is more clever than sigismember(blocked), but more
importantly we now take into account the fatal specific signals too.

The latter allows us to kill some subtle checks in handle_stop_signal() and
makes the specific/group signal's behaviour more consistent.  For example,
currently sigtimedwait(FATAL_SIGNAL) behaves differently depending on was the
signal sent by kill() or tkill() if the signal was not blocked.

And.  This allows us to tweak/fix the behaviour when the specific signal is
sent to the dying/dead ->group_leader.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signals-use-__group_complete_signal-for-the-specific-signals-too kernel/signal.c
--- a/kernel/signal.c~signals-use-__group_complete_signal-for-the-specific-signals-too
+++ a/kernel/signal.c
@@ -673,8 +673,7 @@ static inline int wants_signal(int sig, 
 	return task_curr(p) || !signal_pending(p);
 }
 
-static void
-__group_complete_signal(int sig, struct task_struct *p)
+static void complete_signal(int sig, struct task_struct *p, int group)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
@@ -687,7 +686,7 @@ __group_complete_signal(int sig, struct 
 	 */
 	if (wants_signal(sig, p))
 		t = p;
-	else if (thread_group_empty(p))
+	else if (!group || thread_group_empty(p))
 		/*
 		 * There is just one thread and it does not need to be woken.
 		 * It will dequeue unblocked signals before it runs again.
@@ -871,8 +870,7 @@ specific_send_sig_info(int sig, struct s
 	if (ret <= 0)
 		return ret;
 
-	if (!sigismember(&t->blocked, sig))
-		signal_wake_up(t, sig == SIGKILL);
+	complete_signal(sig, t, 0);
 	return 0;
 }
 
@@ -930,7 +928,7 @@ __group_send_sig_info(int sig, struct si
 	if (ret <= 0)
 		return ret;
 
-	__group_complete_signal(sig, p);
+	complete_signal(sig, p, 1);
 	return 0;
 }
 
@@ -1309,8 +1307,7 @@ int send_sigqueue(int sig, struct sigque
 
 	ret = do_send_sigqueue(sig, q, p, 0);
 
-	if (!sigismember(&p->blocked, sig))
-		signal_wake_up(p, sig == SIGKILL);
+	complete_signal(sig, p, 0);
 
 	unlock_task_sighand(p, &flags);
 out_err:
@@ -1330,7 +1327,7 @@ send_group_sigqueue(int sig, struct sigq
 
 	ret = do_send_sigqueue(sig, q, p, 1);
 
-	__group_complete_signal(sig, p);
+	complete_signal(sig, p, 1);
 
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

