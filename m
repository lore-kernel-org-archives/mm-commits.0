From: akpm@linux-foundation.org
Subject: [merged]
 signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:34:12 -0700
Message-ID: <53960c34.Ffq4Y9K+qXKzTwKP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: [merged] signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch removed from -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:12 -0700


The patch titled
     Subject: signals: kill the obsolete sigdelset() and recalc_sigpending() in allow_signal()
has been removed from the -mm tree.  Its filename was
     signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3072,16 +3072,13 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo
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

origin.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

