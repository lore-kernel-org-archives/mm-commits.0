From: akpm@linux-foundation.org
Subject: + signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
 added to -mm tree
Date: Tue, 15 Apr 2014 12:28:51 -0700
Message-ID: <534d8873.may0YsDwhr0ygaYP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaDOT2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 15:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: + signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch added to -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 12:28:51 -0700


The patch titled
     Subject: signals: mv {dis,}allow_signal() from sched.h/exit.c to signal.[ch]
has been added to the -mm tree.  Its filename is
     signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch

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
Subject: signals: mv {dis,}allow_signal() from sched.h/exit.c to signal.[ch]

Move the declaration/definition of allow_signal/disallow_signal to
signal.h/signal.c.  The new place is more logical and allows to use the
static helpers in signal.c (see the next changes).

While at it, make them return void and remove the valid_signal() check. 
Nobody checks the returned value, and in-kernel users must not pass the
wrong signal number.

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

 include/linux/sched.h  |    3 ---
 include/linux/signal.h |    2 ++
 kernel/exit.c          |   39 ---------------------------------------
 kernel/signal.c        |   29 +++++++++++++++++++++++++++++
 4 files changed, 31 insertions(+), 42 deletions(-)

diff -puN include/linux/sched.h~signals-mv-disallow_signal-from-schedh-exitc-to-signal include/linux/sched.h
--- a/include/linux/sched.h~signals-mv-disallow_signal-from-schedh-exitc-to-signal
+++ a/include/linux/sched.h
@@ -2366,9 +2366,6 @@ extern void flush_itimer_signals(void);
 
 extern void do_group_exit(int);
 
-extern int allow_signal(int);
-extern int disallow_signal(int);
-
 extern int do_execve(struct filename *,
 		     const char __user * const __user *,
 		     const char __user * const __user *);
diff -puN include/linux/signal.h~signals-mv-disallow_signal-from-schedh-exitc-to-signal include/linux/signal.h
--- a/include/linux/signal.h~signals-mv-disallow_signal-from-schedh-exitc-to-signal
+++ a/include/linux/signal.h
@@ -284,6 +284,8 @@ extern int get_signal_to_deliver(siginfo
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
+extern void allow_signal(int);
+extern void disallow_signal(int);
 
 /*
  * Eventually that'll replace get_signal_to_deliver(); macro for now,
diff -puN kernel/exit.c~signals-mv-disallow_signal-from-schedh-exitc-to-signal kernel/exit.c
--- a/kernel/exit.c~signals-mv-disallow_signal-from-schedh-exitc-to-signal
+++ a/kernel/exit.c
@@ -313,45 +313,6 @@ kill_orphaned_pgrp(struct task_struct *t
 	}
 }
 
-/*
- * Let kernel threads use this to say that they allow a certain signal.
- * Must not be used if kthread was cloned with CLONE_SIGHAND.
- */
-int allow_signal(int sig)
-{
-	if (!valid_signal(sig) || sig < 1)
-		return -EINVAL;
-
-	spin_lock_irq(&current->sighand->siglock);
-	/* This is only needed for daemonize()'ed kthreads */
-	sigdelset(&current->blocked, sig);
-	/*
-	 * Kernel threads handle their own signals. Let the signal code
-	 * know it'll be handled, so that they don't get converted to
-	 * SIGKILL or just silently dropped.
-	 */
-	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-	return 0;
-}
-
-EXPORT_SYMBOL(allow_signal);
-
-int disallow_signal(int sig)
-{
-	if (!valid_signal(sig) || sig < 1)
-		return -EINVAL;
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-	return 0;
-}
-
-EXPORT_SYMBOL(disallow_signal);
-
 #ifdef CONFIG_MM_OWNER
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
diff -puN kernel/signal.c~signals-mv-disallow_signal-from-schedh-exitc-to-signal kernel/signal.c
--- a/kernel/signal.c~signals-mv-disallow_signal-from-schedh-exitc-to-signal
+++ a/kernel/signal.c
@@ -3065,6 +3065,35 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo
 }
 #endif
 
+/*
+ * Let kernel threads use this to say that they allow a certain signal.
+ * Must not be used if kthread was cloned with CLONE_SIGHAND.
+ */
+void allow_signal(int sig)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	/* This is only needed for daemonize()'ed kthreads */
+	sigdelset(&current->blocked, sig);
+	/*
+	 * Kernel threads handle their own signals. Let the signal code
+	 * know it'll be handled, so that they don't get converted to
+	 * SIGKILL or just silently dropped.
+	 */
+	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+}
+EXPORT_SYMBOL(allow_signal);
+
+void disallow_signal(int sig)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+}
+EXPORT_SYMBOL(disallow_signal);
+
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
 	struct task_struct *p = current, *t;
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

