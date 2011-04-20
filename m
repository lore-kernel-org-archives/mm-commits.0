From: akpm@linux-foundation.org
Subject: [to-be-updated] signal-sigprocmask-should-do-retarget_shared_pending.patch removed from -mm tree
Date: Wed, 20 Apr 2011 14:13:56 -0700
Message-ID: <201104202113.p3KLDuJX027433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135Ab1DTVOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:14:22 -0400
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
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
x86-signal-handle_signal-should-use-sigprocmask.patch
x86-signal-sys_rt_sigreturn-should-use-sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

