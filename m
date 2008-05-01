From: akpm@linux-foundation.org
Subject: - signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:05 -0700
Message-ID: <200805010926.m419Q59K030273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757341AbYEAJ1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     signals: clean dequeue_signal from excess checks and assignments
has been removed from the -mm tree.  Its filename was
     signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: clean dequeue_signal from excess checks and assignments
From: Pavel Emelyanov <xemul@openvz.org>

The signr variable may be declared without initialization - it is set ro the
return value from __dequeue_signal() right at the function beginning.

Besides, after recalc_sigpending() two checks for signr to be not 0 may be
merged into one.  Both if-s become easier to read.

Thanks to Oleg for pointing out mistakes in the first version of this patch.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~signals-clean-dequeue_signal-from-excess-checks-and-assignments kernel/signal.c
--- a/kernel/signal.c~signals-clean-dequeue_signal-from-excess-checks-and-assignments
+++ a/kernel/signal.c
@@ -377,7 +377,7 @@ static int __dequeue_signal(struct sigpe
  */
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
-	int signr = 0;
+	int signr;
 
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
@@ -410,8 +410,12 @@ int dequeue_signal(struct task_struct *t
 			}
 		}
 	}
+
 	recalc_sigpending();
-	if (signr && unlikely(sig_kernel_stop(signr))) {
+	if (!signr)
+		return 0;
+
+	if (unlikely(sig_kernel_stop(signr))) {
 		/*
 		 * Set a marker that we have dequeued a stop signal.  Our
 		 * caller might release the siglock and then the pending
@@ -427,9 +431,7 @@ int dequeue_signal(struct task_struct *t
 		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
 			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
-	if (signr &&
-	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
-	     info->si_sys_private) {
+	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*
 		 * Release the siglock to ensure proper locking order
 		 * of timer locks outside of siglocks.  Note, we leave
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

