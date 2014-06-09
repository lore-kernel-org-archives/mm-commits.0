From: akpm@linux-foundation.org
Subject: [merged]
 signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:33:52 -0700
Message-ID: <53960c20.aOtclekErO8oRcvj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFITdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: [merged] signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch removed from -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:33:52 -0700


The patch titled
     Subject: signals: rename rm_from_queue_full() to flush_sigqueue_mask()
has been removed from the -mm tree.  Its filename was
     signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: rename rm_from_queue_full() to flush_sigqueue_mask()

"rm_from_queue_full" looks ugly and misleading, especially now that
rm_from_queue() has gone away.  Rename it to flush_sigqueue_mask(), this
matches flush_sigqueue() we already have.

Also remove the obsolete comment which explains the difference with
rm_from_queue() we already killed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN kernel/signal.c~signals-rename-rm_from_queue_full-to-flush_sigqueue_mask kernel/signal.c
--- a/kernel/signal.c~signals-rename-rm_from_queue_full-to-flush_sigqueue_mask
+++ a/kernel/signal.c
@@ -706,11 +706,8 @@ void signal_wake_up_state(struct task_st
  * Returns 1 if any signals were found.
  *
  * All callers must be holding the siglock.
- *
- * This version takes a sigset mask and looks at all signals,
- * not just those in the first mask word.
  */
-static int rm_from_queue_full(sigset_t *mask, struct sigpending *s)
+static int flush_sigqueue_mask(sigset_t *mask, struct sigpending *s)
 {
 	struct sigqueue *q, *n;
 	sigset_t m;
@@ -852,18 +849,18 @@ static bool prepare_signal(int sig, stru
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
 		siginitset(&flush, sigmask(SIGCONT));
-		rm_from_queue_full(&flush, &signal->shared_pending);
+		flush_sigqueue_mask(&flush, &signal->shared_pending);
 		for_each_thread(p, t)
-			rm_from_queue_full(&flush, &t->pending);
+			flush_sigqueue_mask(&flush, &t->pending);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues, wake all threads.
 		 */
 		siginitset(&flush, SIG_KERNEL_STOP_MASK);
-		rm_from_queue_full(&flush, &signal->shared_pending);
+		flush_sigqueue_mask(&flush, &signal->shared_pending);
 		for_each_thread(p, t) {
-			rm_from_queue_full(&flush, &t->pending);
+			flush_sigqueue_mask(&flush, &t->pending);
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 			if (likely(!(t->ptrace & PT_SEIZED)))
 				wake_up_state(t, __TASK_STOPPED);
@@ -3102,9 +3099,9 @@ int do_sigaction(int sig, struct k_sigac
 		if (sig_handler_ignored(sig_handler(t, sig), sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
-			rm_from_queue_full(&mask, &t->signal->shared_pending);
+			flush_sigqueue_mask(&mask, &t->signal->shared_pending);
 			do {
-				rm_from_queue_full(&mask, &t->pending);
+				flush_sigqueue_mask(&mask, &t->pending);
 			} while_each_thread(current, t);
 		}
 	}
@@ -3113,7 +3110,7 @@ int do_sigaction(int sig, struct k_sigac
 	return 0;
 }
 
-static int 
+static int
 do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
 {
 	stack_t oss;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

