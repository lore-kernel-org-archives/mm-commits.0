From: akpm@linux-foundation.org
Subject: +
 signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch added to -mm tree
Date: Tue, 15 Apr 2014 12:28:54 -0700
Message-ID: <534d8876.UqgYir84A3cx0TGj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaDOT2z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 15:28:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: + signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch added to -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 12:28:54 -0700


The patch titled
     Subject: signals: kill the obsolete sigdelset() and recalc_sigpending() in allow_signal()
has been added to the -mm tree.  Its filename is
     signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch

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
Subject: signals: kill the obsolete sigdelset() and recalc_sigpending() in allow_signal()

allow_signal() does sigdelset(current->blocked) due to historic reason,
previously it could be called by a daemonize()'ed kthread, and daemonize()
played with current->blocked.

Now that daemonize() has gone away we can remove sigdelset() and
recalc_sigpending().  If a user really wants to unblock a signal, it must
use sigprocmask() or set_current_block() explicitely.

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

 kernel/signal.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/signal.c~signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal kernel/signal.c
--- a/kernel/signal.c~signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal
+++ a/kernel/signal.c
@@ -3071,16 +3071,13 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo
  */
 void allow_signal(int sig)
 {
-	spin_lock_irq(&current->sighand->siglock);
-	/* This is only needed for daemonize()'ed kthreads */
-	sigdelset(&current->blocked, sig);
 	/*
 	 * Kernel threads handle their own signals. Let the signal code
 	 * know it'll be handled, so that they don't get converted to
 	 * SIGKILL or just silently dropped.
 	 */
+	spin_lock_irq(&current->sighand->siglock);
 	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 }
 EXPORT_SYMBOL(allow_signal);
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

