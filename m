From: akpm@linux-foundation.org
Subject: - signals-move-handle_stop_signal-into-send_signal.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:33 -0700
Message-ID: <200805010926.m419QX4B030309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757500AbYEAJ1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: move handle_stop_signal() into send_signal()
has been removed from the -mm tree.  Its filename was
     signals-move-handle_stop_signal-into-send_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: move handle_stop_signal() into send_signal()
From: Oleg Nesterov <oleg@tv-sign.ru>

Move handle_stop_signal() into send_signal().  This factors out a couple of
callsites and allows us to do further unifications.

Also, with this change specific_send_sig_info() does handle_stop_signal(). 
Not that this is really important, we never send STOP/CONT via send_sig() and
friends, but still this looks more consistent.

The only (afaics) special case is get_signal_to_deliver().  If the traced task
dequeues SIGCONT, it can re-send it to itself after ptrace_stop() if the
signal was blocked by debugger.  In that case handle_stop_signal() is
unnecessary, but hopefully not a problem.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN kernel/signal.c~signals-move-handle_stop_signal-into-send_signal kernel/signal.c
--- a/kernel/signal.c~signals-move-handle_stop_signal-into-send_signal
+++ a/kernel/signal.c
@@ -660,8 +660,10 @@ static inline int legacy_queue(struct si
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			struct sigpending *signals)
 {
-	struct sigqueue * q = NULL;
+	struct sigqueue *q;
 
+	assert_spin_locked(&t->sighand->siglock);
+	handle_stop_signal(sig, t);
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
@@ -766,9 +768,6 @@ specific_send_sig_info(int sig, struct s
 {
 	int ret;
 
-	BUG_ON(!irqs_disabled());
-	assert_spin_locked(&t->sighand->siglock);
-
 	ret = send_signal(sig, info, t, &t->pending);
 	if (ret <= 0)
 		return ret;
@@ -923,9 +922,6 @@ __group_send_sig_info(int sig, struct si
 {
 	int ret;
 
-	assert_spin_locked(&p->sighand->siglock);
-	handle_stop_signal(sig, p);
