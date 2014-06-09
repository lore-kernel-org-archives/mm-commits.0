From: akpm@linux-foundation.org
Subject: [merged]
 signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:34:17 -0700
Message-ID: <53960c39.HnxeT+kGbv+hC8/a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaFITeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: [merged] signals-disallow_signal-should-flush-the-potentially-pending-signal.patch removed from -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:17 -0700


The patch titled
     Subject: signals: disallow_signal() should flush the potentially pending signal
has been removed from the -mm tree.  Its filename was
     signals-disallow_signal-should-flush-the-potentially-pending-signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3085,8 +3085,15 @@ EXPORT_SYMBOL(allow_signal);
 
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

origin.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

