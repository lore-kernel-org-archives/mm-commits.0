From: akpm@linux-foundation.org
Subject: + signal-sigprocmask-should-do-retarget_shared_pending.patch added to -mm tree
Date: Mon, 11 Apr 2011 13:38:15 -0700
Message-ID: <201104112038.p3BKcGxY032220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482Ab1DKUjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 16:39:14 -0400
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

This patch changes sigprocmask() to call retarget_shared_pending() as
exit_signals() does.  To calculate the "blocked" argument we add the new
helper, signorsets(), although we could do ~(newset & ~current->blocked)
instead.  According to grep, nobody in arch/ defines
__HAVE_ARCH_SIG_SETOPS, we only need to change linux/signal.h.

Note: for this particular case we could simply change sigprocmask() to
return -EINTR if signal_pending(), but then we should change other callers
and, more importantly, if we need this fix then sigprocmask() will have
more callers and some of them can't restart.  See the next patch as a
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

 include/linux/signal.h |    4 ++++
 kernel/signal.c        |    5 +++++
 2 files changed, 9 insertions(+)

diff -puN include/linux/signal.h~signal-sigprocmask-should-do-retarget_shared_pending include/linux/signal.h
--- a/include/linux/signal.h~signal-sigprocmask-should-do-retarget_shared_pending
+++ a/include/linux/signal.h
@@ -126,10 +126,14 @@ _SIG_SET_BINOP(sigandsets, _sig_and)
 #define _sig_nand(x,y)	((x) & ~(y))
 _SIG_SET_BINOP(signandsets, _sig_nand)
 
+#define _sig_nor(x,y)	((x) | ~(y))
+_SIG_SET_BINOP(signorsets, _sig_nor)
+
 #undef _SIG_SET_BINOP
 #undef _sig_or
 #undef _sig_and
 #undef _sig_nand
+#undef _sig_nor
 
 #define _SIG_SET_OP(name, op)						\
 static inline void name(sigset_t *set)					\
diff -puN kernel/signal.c~signal-sigprocmask-should-do-retarget_shared_pending kernel/signal.c
--- a/kernel/signal.c~signal-sigprocmask-should-do-retarget_shared_pending
+++ a/kernel/signal.c
@@ -2314,6 +2314,11 @@ int sigprocmask(int how, sigset_t *set, 
 	}
 
 	spin_lock_irq(&tsk->sighand->siglock);
+	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
+		sigset_t not_newblocked;
+		signorsets(&not_newblocked, &current->blocked, &newset);
+		retarget_shared_pending(tsk, &not_newblocked);
+	}
 	tsk->blocked = newset;
 	recalc_sigpending();
 	spin_unlock_irq(&tsk->sighand->siglock);
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
signal-introduce-retarget_shared_pending.patch
signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch
signal-sigprocmask-narrow-the-scope-of-sigloc.patch
signal-sigprocmask-should-do-retarget_shared_pending.patch
x86-signal-handle_signal-should-use-sigprocmask.patch
x86-signal-sys_rt_sigreturn-should-use-sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

