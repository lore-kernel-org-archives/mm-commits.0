From: akpm@linux-foundation.org
Subject: - get_signal_to_deliver-use-the-cached-signal-sighand-values.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:23 -0700
Message-ID: <200805010926.m419QNpL030294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758268AbYEAJqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     get_signal_to_deliver: use the cached ->signal/sighand values
has been removed from the -mm tree.  Its filename was
     get_signal_to_deliver-use-the-cached-signal-sighand-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_signal_to_deliver: use the cached ->signal/sighand values
From: Oleg Nesterov <oleg@tv-sign.ru>

Cache the values of current->signal/sighand.  Shrinks .text a bit and makes
the code more readable.  Also, remove "sigset_t *mask", it is pointless
because in fact we save the constant offset.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN kernel/signal.c~get_signal_to_deliver-use-the-cached-signal-sighand-values kernel/signal.c
--- a/kernel/signal.c~get_signal_to_deliver-use-the-cached-signal-sighand-values
+++ a/kernel/signal.c
@@ -1753,8 +1753,9 @@ static int ptrace_signal(int signr, sigi
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
-	sigset_t *mask = &current->blocked;
-	int signr = 0;
+	struct sighand_struct *sighand = current->sighand;
+	struct signal_struct *signal = current->signal;
+	int signr;
 
 relock:
 	/*
@@ -1765,13 +1766,13 @@ relock:
 	 */
 	try_to_freeze();
 
-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock_irq(&sighand->siglock);
 
-	if (unlikely(current->signal->flags & SIGNAL_CLD_MASK)) {
-		int why = (current->signal->flags & SIGNAL_STOP_CONTINUED)
+	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
+		int why = (signal->flags & SIGNAL_STOP_CONTINUED)
 				? CLD_CONTINUED : CLD_STOPPED;
-		current->signal->flags &= ~SIGNAL_CLD_MASK;
-		spin_unlock_irq(&current->sighand->siglock);
+		signal->flags &= ~SIGNAL_CLD_MASK;
+		spin_unlock_irq(&sighand->siglock);
 
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current->group_leader, why);
@@ -1782,12 +1783,11 @@ relock:
 	for (;;) {
 		struct k_sigaction *ka;
 
-		if (unlikely(current->signal->group_stop_count > 0) &&
+		if (unlikely(signal->group_stop_count > 0) &&
 		    do_signal_stop(0))
 			goto relock;
 
-		signr = dequeue_signal(current, mask, info);
-
+		signr = dequeue_signal(current, &current->blocked, info);
 		if (!signr)
 			break; /* will return 0 */
 
@@ -1797,7 +1797,7 @@ relock:
 				continue;
 		}
 
-		ka = &current->sighand->action[signr-1];
+		ka = &sighand->action[signr-1];
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {
@@ -1834,14 +1834,14 @@ relock:
 			 * We need to check for that and bail out if necessary.
 			 */
 			if (signr != SIGSTOP) {
-				spin_unlock_irq(&current->sighand->siglock);
+				spin_unlock_irq(&sighand->siglock);
 
 				/* signals can be posted during this window */
 
 				if (is_current_pgrp_orphaned())
 					goto relock;
 
-				spin_lock_irq(&current->sighand->siglock);
+				spin_lock_irq(&sighand->siglock);
 			}
 
 			if (likely(do_signal_stop(signr))) {
@@ -1856,7 +1856,7 @@ relock:
 			continue;
 		}
 
-		spin_unlock_irq(&current->sighand->siglock);
+		spin_unlock_irq(&sighand->siglock);
 
 		/*
 		 * Anything else is fatal, maybe with a core dump.
@@ -1882,7 +1882,7 @@ relock:
 		do_group_exit(signr);
 		/* NOTREACHED */
 	}
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irq(&sighand->siglock);
 	return signr;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

