From: akpm@linux-foundation.org
Subject: + signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:00:01 -0800
Message-ID: <200802272300.m1RN02DC002687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383AbYB0XAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:00:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     signals: clean dequeue_signal from excess checks and assignments
has been added to the -mm tree.  Its filename is
     signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
-	     info->si_sys_private){
+	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*
 		 * Release the siglock to ensure proper locking order
 		 * of timer locks outside of siglocks.  Note, we leave
_

Patches currently in -mm which might be from xemul@openvz.org are

use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
udf-fix-anchor-point-detection.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
