From: akpm@linux-foundation.org
Subject: + signal-sigprocmask-should-do-retarget_shared_pending.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:19:01 -0700
Message-ID: <201104202119.p3KLJ2LC027677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755861Ab1DTVTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org


The patch titled
     signal: sigprocmask() should do retarget_shared_pending()
has been added to the -mm tree.  Its filename is
     signal-sigprocmask-should-do-retarget_shared_pending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
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
-
+	set_current_blocked(&newset);
 	return 0;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
signal-introduce-retarget_shared_pending.patch
signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch
signal-retarget_shared_pending-optimize-while_each_thread-loop.patch
signal-sigprocmask-narrow-the-scope-of-siglock.patch
signal-sigprocmask-should-do-retarget_shared_pending.patch
x86-signal-handle_signal-should-use-set_current_blocked.patch
x86-signal-sys_rt_sigreturn-should-use-set_current_blocked.patch
signal-cleanup-sys_rt_sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

