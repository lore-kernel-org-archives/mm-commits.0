From: akpm@linux-foundation.org
Subject: - signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:47 -0700
Message-ID: <200805010926.m419Qlm8030330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758275AbYEAJqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: fold complete_signal() into send_signal/do_send_sigqueue
has been removed from the -mm tree.  Its filename was
     signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: fold complete_signal() into send_signal/do_send_sigqueue
From: Pavel Emelyanov <xemul@openvz.org>

Factor out complete_signal() callsites.  This change completely unifies the
helpers sending the specific/group signals.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   46 +++++++++++-----------------------------------
 1 file changed, 11 insertions(+), 35 deletions(-)

diff -puN kernel/signal.c~signals-fold-complete_signal-into-send_signal-do_send_sigqueue kernel/signal.c
--- a/kernel/signal.c~signals-fold-complete_signal-into-send_signal-do_send_sigqueue
+++ a/kernel/signal.c
@@ -826,7 +826,8 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&pending->signal, sig);
-	return 1;
+	complete_signal(sig, t, group);
+	return 0;
 }
 
 int print_fatal_signals;
@@ -861,17 +862,16 @@ static int __init setup_print_fatal_sign
 
 __setup("print-fatal-signals=", setup_print_fatal_signals);
 
+int
+__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+{
+	return send_signal(sig, info, p, 1);
+}
+
 static int
 specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
-	int ret;
-
-	ret = send_signal(sig, info, t, 0);
-	if (ret <= 0)
-		return ret;
-
-	complete_signal(sig, t, 0);
-	return 0;
+	return send_signal(sig, info, t, 0);
 }
 
 /*
@@ -914,24 +914,6 @@ force_sig_specific(int sig, struct task_
 	force_sig_info(sig, SEND_SIG_FORCED, t);
 }
 
-int
-__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
-{
-	int ret;
-
-	/*
-	 * Put this signal on the shared-pending queue, or fail with EAGAIN.
-	 * We always use the shared queue for process-wide signals,
-	 * to avoid several races.
-	 */
-	ret = send_signal(sig, info, p, 1);
-	if (ret <= 0)
-		return ret;
-
-	complete_signal(sig, p, 1);
-	return 0;
-}
-
 /*
  * Nuke all other threads in the group.
  */
@@ -1263,6 +1245,7 @@ static int do_send_sigqueue(int sig, str
 {
 	struct sigpending *pending;
 
+	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	handle_stop_signal(sig, t);
 
 	if (unlikely(!list_empty(&q->list))) {
@@ -1283,6 +1266,7 @@ static int do_send_sigqueue(int sig, str
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
+	complete_signal(sig, t, group);
 
 	return 0;
 }
@@ -1292,8 +1276,6 @@ int send_sigqueue(int sig, struct sigque
 	unsigned long flags;
 	int ret = -1;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
-
 	/*
 	 * The rcu based delayed sighand destroy makes it possible to
 	 * run this without tasklist lock held. The task struct itself
@@ -1307,8 +1289,6 @@ int send_sigqueue(int sig, struct sigque
 
 	ret = do_send_sigqueue(sig, q, p, 0);
 
-	complete_signal(sig, p, 0);
-
 	unlock_task_sighand(p, &flags);
 out_err:
 	return ret;
@@ -1320,15 +1300,11 @@ send_group_sigqueue(int sig, struct sigq
 	unsigned long flags;
 	int ret;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
-
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 
 	ret = do_send_sigqueue(sig, q, p, 1);
 
-	complete_signal(sig, p, 1);
