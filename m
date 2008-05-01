From: akpm@linux-foundation.org
Subject: - signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:27 -0700
Message-ID: <200805010926.m419QRaZ030300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688AbYEAJ11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: send_sigqueue: don't forget about handle_stop_signal()
has been removed from the -mm tree.  Its filename was
     signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: send_sigqueue: don't forget about handle_stop_signal()
From: Oleg Nesterov <oleg@tv-sign.ru>

send_group_sigqueue() calls handle_stop_signal(), send_sigqueue() doesn't. 
This is not consistent and in fact I'd say this is (minor) bug.

Move handle_stop_signal() from send_group_sigqueue() to do_send_sigqueue(),
the latter is called by send_sigqueue() too.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-send_sigqueue-dont-forget-about-handle_stop_signal kernel/signal.c
--- a/kernel/signal.c~signals-send_sigqueue-dont-forget-about-handle_stop_signal
+++ a/kernel/signal.c
@@ -1274,8 +1274,10 @@ void sigqueue_free(struct sigqueue *q)
 }
 
 static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
-		struct sigpending *pending)
+				struct sigpending *pending)
 {
+	handle_stop_signal(sig, t);
+
 	if (unlikely(!list_empty(&q->list))) {
 		/*
 		 * If an SI_TIMER entry is already queue just increment
@@ -1335,7 +1337,6 @@ send_group_sigqueue(int sig, struct sigq
 	read_lock(&tasklist_lock);
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
-	handle_stop_signal(sig, p);
 
 	ret = do_send_sigqueue(sig, q, p, &p->signal->shared_pending);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

