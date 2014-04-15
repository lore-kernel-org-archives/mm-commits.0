From: akpm@linux-foundation.org
Subject: +
 signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch added to -mm tree
Date: Tue, 15 Apr 2014 12:28:46 -0700
Message-ID: <534d886e.NYcy/vaK3Nu9+5fO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaDOT2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 15:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: + signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch added to -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 12:28:46 -0700


The patch titled
     Subject: signals: kill rm_from_queue(), change prepare_signal() to use for_each_thread()
has been added to the -mm tree.  Its filename is
     signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: kill rm_from_queue(), change prepare_signal() to use for_each_thread()

rm_from_queue() doesn't make sense.  The only caller, prepare_signal(),
can use rm_from_queue_full() with the same effect.

While at it, change prepare_signal() to use for_each_thread() instead of
do/while_each_thread.

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

 kernel/signal.c |   43 ++++++++++---------------------------------
 1 file changed, 10 insertions(+), 33 deletions(-)

diff -puN kernel/signal.c~signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread kernel/signal.c
--- a/kernel/signal.c~signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread
+++ a/kernel/signal.c
@@ -727,29 +727,6 @@ static int rm_from_queue_full(sigset_t *
 	}
 	return 1;
 }
-/*
- * Remove signals in mask from the pending set and queue.
- * Returns 1 if any signals were found.
- *
- * All callers must be holding the siglock.
- */
-static int rm_from_queue(unsigned long mask, struct sigpending *s)
-{
-	struct sigqueue *q, *n;
-
-	if (!sigtestsetmask(&s->signal, mask))
-		return 0;
-
-	sigdelsetmask(&s->signal, mask);
-	list_for_each_entry_safe(q, n, &s->list, list) {
-		if (q->info.si_signo < SIGRTMIN &&
-		    (mask & sigmask(q->info.si_signo))) {
-			list_del_init(&q->list);
-			__sigqueue_free(q);
-		}
-	}
-	return 1;
-}
 
 static inline int is_si_special(const struct siginfo *info)
 {
@@ -861,6 +838,7 @@ static bool prepare_signal(int sig, stru
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
+	sigset_t flush;
 
 	if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
 		if (signal->flags & SIGNAL_GROUP_COREDUMP)
@@ -872,26 +850,25 @@ static bool prepare_signal(int sig, stru
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
-		rm_from_queue(sigmask(SIGCONT), &signal->shared_pending);
-		t = p;
-		do {
-			rm_from_queue(sigmask(SIGCONT), &t->pending);
-		} while_each_thread(p, t);
+		siginitset(&flush, sigmask(SIGCONT));
+		rm_from_queue_full(&flush, &signal->shared_pending);
+		for_each_thread(p, t)
+			rm_from_queue_full(&flush, &t->pending);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues, wake all threads.
 		 */
-		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
-		t = p;
-		do {
+		siginitset(&flush, SIG_KERNEL_STOP_MASK);
+		rm_from_queue_full(&flush, &signal->shared_pending);
+		for_each_thread(p, t) {
+			rm_from_queue_full(&flush, &t->pending);
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
-			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			if (likely(!(t->ptrace & PT_SEIZED)))
 				wake_up_state(t, __TASK_STOPPED);
 			else
 				ptrace_trap_notify(t);
-		} while_each_thread(p, t);
+		}
 
 		/*
 		 * Notify the parent with CLD_CONTINUED if we were stopped.
_

Patches currently in -mm which might be from oleg@redhat.com are

signals-kill-sigfindinword.patch
signals-s-siginitset-sigemptyset-in-do_sigtimedwait.patch
signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch
signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
signals-introduce-kernel_sigaction.patch
signals-change-wait_for_helper-to-use-kernel_sigaction.patch

