From: akpm@linux-foundation.org
Subject: - signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:43 -0700
Message-ID: <200805010926.m419QhuI030324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486AbYEAJ1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: change send_signal/do_send_sigqueue to take "boolean group" parameter
has been removed from the -mm tree.  Its filename was
     signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: change send_signal/do_send_sigqueue to take "boolean group" parameter
From: Oleg Nesterov <oleg@tv-sign.ru>

send_signal() is used either with ->pending or with ->signal->shared_pending. 
Change it to take "int group" instead, this argument will be re-used later.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter kernel/signal.c
--- a/kernel/signal.c~signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter
+++ a/kernel/signal.c
@@ -754,18 +754,21 @@ static inline int legacy_queue(struct si
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
-			struct sigpending *signals)
+			int group)
 {
+	struct sigpending *pending;
 	struct sigqueue *q;
 
 	assert_spin_locked(&t->sighand->siglock);
 	handle_stop_signal(sig, t);
+
+	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
+	if (sig_ignored(t, sig) || legacy_queue(pending, sig))
 		return 0;
 
 	/*
@@ -793,7 +796,7 @@ static int send_signal(int sig, struct s
 					     (is_si_special(info) ||
 					      info->si_code >= 0)));
 	if (q) {
-		list_add_tail(&q->list, &signals->list);
+		list_add_tail(&q->list, &pending->list);
 		switch ((unsigned long) info) {
 		case (unsigned long) SEND_SIG_NOINFO:
 			q->info.si_signo = sig;
@@ -823,7 +826,7 @@ static int send_signal(int sig, struct s
 	}
 
 out_set:
-	sigaddset(&signals->signal, sig);
+	sigaddset(&pending->signal, sig);
 	return 1;
 }
 
@@ -864,7 +867,7 @@ specific_send_sig_info(int sig, struct s
 {
 	int ret;
 
-	ret = send_signal(sig, info, t, &t->pending);
+	ret = send_signal(sig, info, t, 0);
 	if (ret <= 0)
 		return ret;
 
@@ -923,7 +926,7 @@ __group_send_sig_info(int sig, struct si
 	 * We always use the shared queue for process-wide signals,
 	 * to avoid several races.
 	 */
-	ret = send_signal(sig, info, p, &p->signal->shared_pending);
+	ret = send_signal(sig, info, p, 1);
 	if (ret <= 0)
 		return ret;
 
@@ -1258,8 +1261,10 @@ void sigqueue_free(struct sigqueue *q)
 }
 
 static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
-				struct sigpending *pending)
+				int group)
 {
+	struct sigpending *pending;
+
 	handle_stop_signal(sig, t);
 
 	if (unlikely(!list_empty(&q->list))) {
@@ -1277,8 +1282,10 @@ static int do_send_sigqueue(int sig, str
 		return 1;
 
 	signalfd_notify(t, sig);
+	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
+
 	return 0;
 }
 
@@ -1300,7 +1307,7 @@ int send_sigqueue(int sig, struct sigque
 	if (!likely(lock_task_sighand(p, &flags)))
 		goto out_err;
 
-	ret = do_send_sigqueue(sig, q, p, &p->pending);
+	ret = do_send_sigqueue(sig, q, p, 0);
 
 	if (!sigismember(&p->blocked, sig))
 		signal_wake_up(p, sig == SIGKILL);
@@ -1321,7 +1328,7 @@ send_group_sigqueue(int sig, struct sigq
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 
-	ret = do_send_sigqueue(sig, q, p, &p->signal->shared_pending);
+	ret = do_send_sigqueue(sig, q, p, 1);
 
 	__group_complete_signal(sig, p);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

