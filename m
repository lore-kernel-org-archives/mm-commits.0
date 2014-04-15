From: akpm@linux-foundation.org
Subject: + signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
 added to -mm tree
Date: Tue, 15 Apr 2014 12:28:49 -0700
Message-ID: <534d8871.UUjScsVY5S/ryK53%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaDOT2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 15:28:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: + signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch added to -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 12:28:49 -0700


The patch titled
     Subject: signals: cleanup the usage of t/current in do_sigaction()
has been added to the -mm tree.  Its filename is
     signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch

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
Subject: signals: cleanup the usage of t/current in do_sigaction()

The usage of "task_struct *t" and "current" in do_sigaction() looks really
annoying and chaotic.  Initially "t" is used as a cached value of current
but not consistently, then it is reused as a loop variable and we have to
use "current" again.

Clean up this mess and also convert the code to use for_each_thread().

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

 kernel/signal.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN kernel/signal.c~signals-cleanup-the-usage-of-t-current-in-do_sigaction kernel/signal.c
--- a/kernel/signal.c~signals-cleanup-the-usage-of-t-current-in-do_sigaction
+++ a/kernel/signal.c
@@ -3067,16 +3067,16 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo
 
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
-	struct task_struct *t = current;
+	struct task_struct *p = current, *t;
 	struct k_sigaction *k;
 	sigset_t mask;
 
 	if (!valid_signal(sig) || sig < 1 || (act && sig_kernel_only(sig)))
 		return -EINVAL;
 
-	k = &t->sighand->action[sig-1];
+	k = &p->sighand->action[sig-1];
 
-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock_irq(&p->sighand->siglock);
 	if (oact)
 		*oact = *k;
 
@@ -3095,17 +3095,16 @@ int do_sigaction(int sig, struct k_sigac
 		 *   (for example, SIGCHLD), shall cause the pending signal to
 		 *   be discarded, whether or not it is blocked"
 		 */
-		if (sig_handler_ignored(sig_handler(t, sig), sig)) {
+		if (sig_handler_ignored(sig_handler(p, sig), sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
-			flush_sigqueue_mask(&mask, &t->signal->shared_pending);
-			do {
+			flush_sigqueue_mask(&mask, &p->signal->shared_pending);
+			for_each_thread(p, t)
 				flush_sigqueue_mask(&mask, &t->pending);
-			} while_each_thread(current, t);
 		}
 	}
 
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irq(&p->sighand->siglock);
 	return 0;
 }
 
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

