From: akpm@linux-foundation.org
Subject: + get_signal_to_deliver-use-the-cached-signal-sighand-values.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:36:19 -0800
Message-ID: <200803052336.m25NaJSh027438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754141AbYCEXhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:37:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com


The patch titled
     get_signal_to_deliver: use the cached ->signal/sighand values
has been added to the -mm tree.  Its filename is
     get_signal_to_deliver-use-the-cached-signal-sighand-values.patch

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
@@ -1714,8 +1714,9 @@ static int do_signal_stop(int signr)
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
@@ -1726,13 +1727,13 @@ relock:
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
@@ -1743,12 +1744,11 @@ relock:
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
 
@@ -1784,7 +1784,7 @@ relock:
 			}
 		}
 
-		ka = &current->sighand->action[signr-1];
+		ka = &sighand->action[signr-1];
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {
@@ -1821,14 +1821,14 @@ relock:
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
@@ -1843,7 +1843,7 @@ relock:
 			continue;
 		}
 
-		spin_unlock_irq(&current->sighand->siglock);
+		spin_unlock_irq(&sighand->siglock);
 
 		/*
 		 * Anything else is fatal, maybe with a core dump.
@@ -1869,7 +1869,7 @@ relock:
 		do_group_exit(signr);
 		/* NOTREACHED */
 	}
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irq(&sighand->siglock);
 	return signr;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
ptrace-introduce-task_detached-helper.patch
ptrace-introduce-ptrace_reparented-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

