From: akpm@linux-foundation.org
Subject: - signals-unify-send_sigqueue-send_group_sigqueue-completely.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:49 -0700
Message-ID: <200805010926.m419QnoO030333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812AbYEAJ1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     signals: unify send_sigqueue/send_group_sigqueue completely
has been removed from the -mm tree.  Its filename was
     signals-unify-send_sigqueue-send_group_sigqueue-completely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: unify send_sigqueue/send_group_sigqueue completely
From: Oleg Nesterov <oleg@tv-sign.ru>

Suggested by Pavel Emelyanov.

send_sigqueue/send_group_sigqueue are only differ in how they lock ->siglock. 
Unify them.  send_group_sigqueue() uses spin_lock() because it knows the task
can't exit, but in that case lock_task_sighand() can't fail and doesn't hurt.

Note that the "sig" argument is ignored, it is always equal to ->si_signo.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   58 ++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 37 deletions(-)

diff -puN kernel/signal.c~signals-unify-send_sigqueue-send_group_sigqueue-completely kernel/signal.c
--- a/kernel/signal.c~signals-unify-send_sigqueue-send_group_sigqueue-completely
+++ a/kernel/signal.c
@@ -1240,14 +1240,27 @@ void sigqueue_free(struct sigqueue *q)
 	__sigqueue_free(q);
 }
 
-static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
+static int do_send_sigqueue(struct sigqueue *q, struct task_struct *t,
 				int group)
 {
+	int sig = q->info.si_signo;
 	struct sigpending *pending;
+	unsigned long flags;
+	int ret;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+
+	ret = -1;
+	if (!likely(lock_task_sighand(t, &flags)))
+		goto ret;
+
 	handle_stop_signal(sig, t);
 
+	ret = 1;
+	if (sig_ignored(t, sig))
+		goto out;
+
+	ret = 0;
 	if (unlikely(!list_empty(&q->list))) {
 		/*
 		 * If an SI_TIMER entry is already queue just increment
@@ -1256,58 +1269,29 @@ static int do_send_sigqueue(int sig, str
 
 		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
-		return 0;
+		goto out;
 	}
 
-	if (sig_ignored(t, sig))
-		return 1;
-
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
-
-	return 0;
+out:
+	unlock_task_sighand(t, &flags);
+ret:
+	return ret;
 }
 
 int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret = -1;
-
-	/*
-	 * The rcu based delayed sighand destroy makes it possible to
-	 * run this without tasklist lock held. The task struct itself
-	 * cannot go away as create_timer did get_task_struct().
-	 *
-	 * We return -1, when the task is marked exiting, so
-	 * posix_timer_event can redirect it to the group leader
-	 */
-	if (!likely(lock_task_sighand(p, &flags)))
-		goto out_err;
-
-	ret = do_send_sigqueue(sig, q, p, 0);
-
-	unlock_task_sighand(p, &flags);
-out_err:
-	return ret;
+	return do_send_sigqueue(q, p, 0);
 }
 
 int
 send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret;
-
-	/* Since it_lock is held, p->sighand cannot be NULL. */
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-
-	ret = do_send_sigqueue(sig, q, p, 1);
-
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
