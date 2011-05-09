From: akpm@linux-foundation.org
Subject: [to-be-updated] signal-sigprocmask-should-do-retarget_shared_pending.patch removed from -mm tree
Date: Mon, 09 May 2011 12:17:11 -0700
Message-ID: <201105091910.p49JABm4011866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061Ab1EITLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 15:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     signal: sigprocmask() should do retarget_shared_pending()
has been removed from the -mm tree.  Its filename was
     signal-sigprocmask-should-do-retarget_shared_pending.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signal: sigprocmask() should do retarget_shared_pending()
From: Oleg Nesterov <oleg@redhat.com>

In short, almost every changing of current->blocked is wrong, or at least
can lead to the unexpected results.

For example.  Two threads T1 and T2, T1 sleeps in sigtimedwait/pause/etc. 
kill(tgid, SIG) can pick T2 for TIF_SIGPENDING.  If T2 calls sigprocmask()
and blocks SIG before it notices the pending signal, nobody else can
handle this pending shared signal.

I am not sure this is bug, but at least this looks strange imho.  T1
should not sleep forever, there is a signal which should wake it up.

This patch moves the code which actually changes ->blocked into the new
helper, set_current_blocked() and changes this code to call
retarget_shared_pending() as exit_signals() does.  We should only care
about the signals we just blocked, we use "newset & ~current->blocked" as
a mask.

We do not check !sigisemptyset(newblocked), retarget_shared_pending() is
cheap unless mask & shared_pending.

Note: for this particular case we could simply change sigprocmask() to
return -EINTR if signal_pending(), but then we should change other callers
and, more importantly, if we need this fix then set_current_blocked() will
have more callers and some of them can't restart.  See the next patch as a
random example.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Reviewed-by: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 +
 kernel/signal.c        |   21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff -puN include/linux/signal.h~signal-sigprocmask-should-do-retarget_shared_pending include/linux/signal.h
--- a/include/linux/signal.h~signal-sigprocmask-should-do-retarget_shared_pending
+++ a/include/linux/signal.h
@@ -243,6 +243,7 @@ extern long do_rt_tgsigqueueinfo(pid_t t
 				 siginfo_t *info);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
+extern void set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
 
 struct pt_regs;
diff -puN kernel/signal.c~signal-sigprocmask-should-do-retarget_shared_pending kernel/signal.c
--- a/kernel/signal.c~signal-sigprocmask-should-do-retarget_shared_pending
+++ a/kernel/signal.c
@@ -2298,6 +2298,21 @@ long do_no_restart_syscall(struct restar
 	return -EINTR;
 }
 
+void set_current_blocked(const sigset_t *newset)
+{
+	struct task_struct *tsk = current;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
+		sigset_t newblocked;
+		signandsets(&newblocked, newset, &current->blocked);
+		retarget_shared_pending(tsk, &newblocked);
+	}
+	tsk->blocked = *newset;
+	recalc_sigpending();
+	spin_unlock_irq(&tsk->sighand->siglock);
+}
+
 /*
  * This is also useful for kernel threads that want to temporarily
  * (or permanently) block certain signals.
@@ -2329,11 +2344,7 @@ int sigprocmask(int how, sigset_t *set, 
 		return -EINVAL;
 	}
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	tsk->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&tsk->sighand->siglock);
