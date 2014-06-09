From: akpm@linux-foundation.org
Subject: [merged]
 signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:33:57 -0700
Message-ID: <53960c25.EITROVK1aQG2aVdZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaFITd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: [merged] signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch removed from -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:33:57 -0700


The patch titled
     Subject: signals: cleanup the usage of t/current in do_sigaction()
has been removed from the -mm tree.  Its filename was
     signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3068,16 +3068,16 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo
 
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
 
@@ -3096,17 +3096,16 @@ int do_sigaction(int sig, struct k_sigac
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

origin.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

