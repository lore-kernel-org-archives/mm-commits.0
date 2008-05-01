From: akpm@linux-foundation.org
Subject: - signals-fold-sig_ignored-into-handle_stop_signal.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:57 -0700
Message-ID: <200805010926.m419QvLP030349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755567AbYEAJ1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: fold sig_ignored() into handle_stop_signal()
has been removed from the -mm tree.  Its filename was
     signals-fold-sig_ignored-into-handle_stop_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: fold sig_ignored() into handle_stop_signal()
From: Oleg Nesterov <oleg@tv-sign.ru>

Rename handle_stop_signal() to prepare_signal(), make it return a boolean, and
move the callsites of sig_ignored() into it.

No functional changes for now.  But it would be nice to factor out the "should
we drop this signal" checks as much as possible, before we try to fix the bugs
with the sub-namespace init's signals (actually the global /sbin/init has some
problems with signals too).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN kernel/signal.c~signals-fold-sig_ignored-into-handle_stop_signal kernel/signal.c
--- a/kernel/signal.c~signals-fold-sig_ignored-into-handle_stop_signal
+++ a/kernel/signal.c
@@ -558,24 +558,25 @@ static int check_kill_permission(int sig
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
 
 /*
- * Handle magic process-wide effects of stop/continue signals.
- * Unlike the signal actions, these happen immediately at signal-generation
+ * Handle magic process-wide effects of stop/continue signals. Unlike
+ * the signal actions, these happen immediately at signal-generation
  * time regardless of blocking, ignoring, or handling.  This does the
  * actual continuing for SIGCONT, but not the actual stopping for stop
- * signals.  The process stop is done as a signal action for SIG_DFL.
+ * signals. The process stop is done as a signal action for SIG_DFL.
+ *
+ * Returns true if the signal should be actually delivered, otherwise
+ * it should be dropped.
  */
-static void handle_stop_signal(int sig, struct task_struct *p)
+static int prepare_signal(int sig, struct task_struct *p)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (signal->flags & SIGNAL_GROUP_EXIT)
+	if (unlikely(signal->flags & SIGNAL_GROUP_EXIT)) {
 		/*
-		 * The process is in the middle of dying already.
+		 * The process is in the middle of dying, nothing to do.
 		 */
-		return;
-
-	if (sig_kernel_stop(sig)) {
+	} else if (sig_kernel_stop(sig)) {
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
@@ -644,6 +645,8 @@ static void handle_stop_signal(int sig, 
 			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	}
+
+	return !sig_ignored(p, sig);
 }
 
 /*
@@ -753,7 +756,8 @@ static int send_signal(int sig, struct s
 	struct sigqueue *q;
 
 	assert_spin_locked(&t->sighand->siglock);
-	handle_stop_signal(sig, t);
+	if (!prepare_signal(sig, t))
+		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
@@ -761,7 +765,7 @@ static int send_signal(int sig, struct s
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (sig_ignored(t, sig) || legacy_queue(pending, sig))
+	if (legacy_queue(pending, sig))
 		return 0;
 
 	/*
@@ -1247,10 +1251,8 @@ int send_sigqueue(struct sigqueue *q, st
 	if (!likely(lock_task_sighand(t, &flags)))
 		goto ret;
 
-	handle_stop_signal(sig, t);
