From: akpm@linux-foundation.org
Subject: [merged] signals-introduce-kernel_sigaction.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:34:22 -0700
Message-ID: <53960c3e.hmUTH3/jttCssLkT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: [merged] signals-introduce-kernel_sigaction.patch removed from -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:22 -0700


The patch titled
     Subject: signals: introduce kernel_sigaction()
has been removed from the -mm tree.  Its filename was
     signals-introduce-kernel_sigaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: introduce kernel_sigaction()

Now that allow_signal() is really trivial we can unify it with
disallow_signal().  Add the new helper, kernel_sigaction(), and
reimplement allow_signal/disallow_signal as a trivial wrappers.

This saves one EXPORT_SYMBOL() and the new helper can have more users.

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

 include/linux/signal.h |   18 ++++++++++++++++--
 kernel/signal.c        |   36 ++++++++++++------------------------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff -puN include/linux/signal.h~signals-introduce-kernel_sigaction include/linux/signal.h
--- a/include/linux/signal.h~signals-introduce-kernel_sigaction
+++ a/include/linux/signal.h
@@ -284,8 +284,22 @@ extern int get_signal_to_deliver(siginfo
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
-extern void allow_signal(int);
-extern void disallow_signal(int);
+extern void kernel_sigaction(int, __sighandler_t);
+
+static inline void allow_signal(int sig)
+{
+	/*
+	 * Kernel threads handle their own signals. Let the signal code
+	 * know it'll be handled, so that they don't get converted to
+	 * SIGKILL or just silently dropped.
+	 */
+	kernel_sigaction(sig, (__force __sighandler_t)2);
+}
+
+static inline void disallow_signal(int sig)
+{
+	kernel_sigaction(sig, SIG_IGN);
+}
 
 /*
  * Eventually that'll replace get_signal_to_deliver(); macro for now,
diff -puN kernel/signal.c~signals-introduce-kernel_sigaction kernel/signal.c
--- a/kernel/signal.c~signals-introduce-kernel_sigaction
+++ a/kernel/signal.c
@@ -3067,37 +3067,25 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo
 #endif
 
 /*
- * Let kernel threads use this to say that they allow a certain signal.
- * Must not be used if kthread was cloned with CLONE_SIGHAND.
+ * For kthreads only, must not be used if cloned with CLONE_SIGHAND
  */
-void allow_signal(int sig)
+void kernel_sigaction(int sig, __sighandler_t action)
 {
-	/*
-	 * Kernel threads handle their own signals. Let the signal code
-	 * know it'll be handled, so that they don't get converted to
-	 * SIGKILL or just silently dropped.
-	 */
 	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	spin_unlock_irq(&current->sighand->siglock);
-}
-EXPORT_SYMBOL(allow_signal);
+	current->sighand->action[sig - 1].sa.sa_handler = action;
+	if (action == SIG_IGN) {
+		sigset_t mask;
 
-void disallow_signal(int sig)
-{
-	sigset_t mask;
+		sigemptyset(&mask);
+		sigaddset(&mask, sig);
 
-	sigemptyset(&mask);
-	sigaddset(&mask, sig);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
-	flush_sigqueue_mask(&mask, &current->signal->shared_pending);
-	flush_sigqueue_mask(&mask, &current->pending);
-	recalc_sigpending();
+		flush_sigqueue_mask(&mask, &current->signal->shared_pending);
+		flush_sigqueue_mask(&mask, &current->pending);
+		recalc_sigpending();
+	}
 	spin_unlock_irq(&current->sighand->siglock);
 }
-EXPORT_SYMBOL(disallow_signal);
+EXPORT_SYMBOL(kernel_sigaction);
 
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

