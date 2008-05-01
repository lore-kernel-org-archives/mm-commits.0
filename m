From: akpm@linux-foundation.org
Subject: - consolidate-checking-for-ignored-legacy-signals.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:50 -0700
Message-ID: <200805010925.m419PohC030242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758199AbYEAJqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: consolidate checking for ignored/legacy signals
has been removed from the -mm tree.  Its filename was
     consolidate-checking-for-ignored-legacy-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: consolidate checking for ignored/legacy signals
From: Pavel Emelyanov <xemul@openvz.org>

Two callers for send_signal() - the specific_send_sig_info and the
__group_send_sig_info - both check for sig to be ignored or already queued.

Move these checks into send_signal() and make it return 1 to indicate that the
signal is dropped, but there's no error in this.

Besides, merge comments and spell-check them.

[oleg@tv-sign.ru: simplifications]
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff -puN kernel/signal.c~consolidate-checking-for-ignored-legacy-signals kernel/signal.c
--- a/kernel/signal.c~consolidate-checking-for-ignored-legacy-signals
+++ a/kernel/signal.c
@@ -668,6 +668,14 @@ static int send_signal(int sig, struct s
 	struct sigqueue * q = NULL;
 
 	/*
+	 * Short-circuit ignored signals and support queuing
+	 * exactly one non-rt signal, so that we can get more
+	 * detailed information about the cause of the signal.
+	 */
+	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
+		return 0;
+
+	/*
 	 * Deliver the signal to listening signalfds. This must be called
 	 * with the sighand lock held.
 	 */
@@ -723,7 +731,7 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&signals->signal, sig);
-	return 0;
+	return 1;
 }
 
 int print_fatal_signals;
@@ -761,26 +769,18 @@ __setup("print-fatal-signals=", setup_pr
 static int
 specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
-	int ret = 0;
+	int ret;
 
 	BUG_ON(!irqs_disabled());
 	assert_spin_locked(&t->sighand->siglock);
 
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(t, sig))
-		goto out;
-
-	/* Support queueing exactly one non-rt signal, so that we
-	   can get more detailed information about the cause of
-	   the signal. */
-	if (legacy_queue(&t->pending, sig))
-		goto out;
-
 	ret = send_signal(sig, info, t, &t->pending);
-	if (!ret && !sigismember(&t->blocked, sig))
+	if (ret <= 0)
+		return ret;
+
+	if (!sigismember(&t->blocked, sig))
 		signal_wake_up(t, sig == SIGKILL);
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -925,26 +925,18 @@ __group_complete_signal(int sig, struct 
 int
 __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret = 0;
+	int ret;
 
 	assert_spin_locked(&p->sighand->siglock);
 	handle_stop_signal(sig, p);
 
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(p, sig))
-		return ret;
-
-	if (legacy_queue(&p->signal->shared_pending, sig))
-		/* This is a non-RT signal and we already have one queued.  */
-		return ret;
