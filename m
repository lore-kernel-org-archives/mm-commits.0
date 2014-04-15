From: akpm@linux-foundation.org
Subject: +
 signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
 added to -mm tree
Date: Tue, 15 Apr 2014 12:28:55 -0700
Message-ID: <534d8877.sUlmihhMxAtPCo5P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbaDOT24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 15:28:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: + signals-disallow_signal-should-flush-the-potentially-pending-signal.patch added to -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 12:28:55 -0700


The patch titled
     Subject: signals: disallow_signal() should flush the potentially pending signal
has been added to the -mm tree.  Its filename is
     signals-disallow_signal-should-flush-the-potentially-pending-signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-disallow_signal-should-flush-the-potentially-pending-signal.patch

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
Subject: signals: disallow_signal() should flush the potentially pending signal

disallow_signal() simply sets SIG_IGN, this is not enough and
recalc_sigpending() is simply pointless because in can never change the
state of TIF_SIGPENDING.

If we ignore a signal, we also need to do flush_sigqueue_mask() for the
case when this signal is pending, this way recalc_sigpending() can
actually clear TIF_SIGPENDING and we do not "leak" the allocated
siginfo's.

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

 kernel/signal.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/signal.c~signals-disallow_signal-should-flush-the-potentially-pending-signal kernel/signal.c
--- a/kernel/signal.c~signals-disallow_signal-should-flush-the-potentially-pending-signal
+++ a/kernel/signal.c
@@ -3084,8 +3084,15 @@ EXPORT_SYMBOL(allow_signal);
 
 void disallow_signal(int sig)
 {
+	sigset_t mask;
+
+	sigemptyset(&mask);
+	sigaddset(&mask, sig);
+
 	spin_lock_irq(&current->sighand->siglock);
 	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
+	flush_sigqueue_mask(&mask, &current->signal->shared_pending);
+	flush_sigqueue_mask(&mask, &current->pending);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
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

