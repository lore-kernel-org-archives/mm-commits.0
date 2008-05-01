From: akpm@linux-foundation.org
Subject: - turn-legacy_queue-macro-into-static-inline-function.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:48 -0700
Message-ID: <200805010925.m419PmMx030239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758213AbYEAJqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: turn LEGACY_QUEUE macro into static inline function
has been removed from the -mm tree.  Its filename was
     turn-legacy_queue-macro-into-static-inline-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: turn LEGACY_QUEUE macro into static inline function
From: Pavel Emelyanov <xemul@openvz.org>

This makes the code more readable, due to less brackets and small letters in
name.

I also move it above the send_signal() as a preparation for the 3rd patch.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~turn-legacy_queue-macro-into-static-inline-function kernel/signal.c
--- a/kernel/signal.c~turn-legacy_queue-macro-into-static-inline-function
+++ a/kernel/signal.c
@@ -657,6 +657,11 @@ static void handle_stop_signal(int sig, 
 	}
 }
 
+static inline int legacy_queue(struct sigpending *signals, int sig)
+{
+	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
+}
+
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			struct sigpending *signals)
 {
@@ -721,9 +726,6 @@ out_set:
 	return 0;
 }
 
-#define LEGACY_QUEUE(sigptr, sig) \
-	(((sig) < SIGRTMIN) && sigismember(&(sigptr)->signal, (sig)))
-
 int print_fatal_signals;
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
@@ -771,7 +773,7 @@ specific_send_sig_info(int sig, struct s
 	/* Support queueing exactly one non-rt signal, so that we
 	   can get more detailed information about the cause of
 	   the signal. */
-	if (LEGACY_QUEUE(&t->pending, sig))
+	if (legacy_queue(&t->pending, sig))
 		goto out;
 
 	ret = send_signal(sig, info, t, &t->pending);
@@ -932,7 +934,7 @@ __group_send_sig_info(int sig, struct si
 	if (sig_ignored(p, sig))
 		return ret;
 
-	if (LEGACY_QUEUE(&p->signal->shared_pending, sig))
+	if (legacy_queue(&p->signal->shared_pending, sig))
 		/* This is a non-RT signal and we already have one queued.  */
 		return ret;
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

