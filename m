From: akpm@linux-foundation.org
Subject: [merged] signal-add-block_sigmask-for-adding-sigmask-to-current-blocked.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:33:08 -0800
Message-ID: <20120111213309.281FE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43465 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960Ab2AKVdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:33:11 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44375eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:33:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: add block_sigmask() for adding sigmask to current->blocked
has been removed from the -mm tree.  Its filename was
     signal-add-block_sigmask-for-adding-sigmask-to-current-blocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: signal: add block_sigmask() for adding sigmask to current->blocked

Abstract the code sequence for adding a signal handler's sa_mask to
current->blocked because the sequence is identical for all architectures. 
Furthermore, in the past some architectures actually got this code wrong,
so introduce a wrapper that all architectures can use.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal.c |    6 +-----
 include/linux/signal.h   |    1 +
 kernel/signal.c          |   21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/signal.c~signal-add-block_sigmask-for-adding-sigmask-to-current-blocked arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~signal-add-block_sigmask-for-adding-sigmask-to-current-blocked
+++ a/arch/x86/kernel/signal.c
@@ -682,7 +682,6 @@ static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 		struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int ret;
 
 	/* Are we from a system call? */
@@ -733,10 +732,7 @@ handle_signal(unsigned long sig, siginfo
 	 */
 	regs->flags &= ~X86_EFLAGS_TF;
 
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	block_sigmask(ka, sig);
 
 	tracehook_signal_handler(sig, info, ka, regs,
 				 test_thread_flag(TIF_SINGLESTEP));
diff -puN include/linux/signal.h~signal-add-block_sigmask-for-adding-sigmask-to-current-blocked include/linux/signal.h
--- a/include/linux/signal.h~signal-add-block_sigmask-for-adding-sigmask-to-current-blocked
+++ a/include/linux/signal.h
@@ -254,6 +254,7 @@ extern void set_current_blocked(const si
 extern int show_unhandled_signals;
 
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern void block_sigmask(struct k_sigaction *ka, int signr);
 extern void exit_signals(struct task_struct *tsk);
 
 extern struct kmem_cache *sighand_cachep;
diff -puN kernel/signal.c~signal-add-block_sigmask-for-adding-sigmask-to-current-blocked kernel/signal.c
--- a/kernel/signal.c~signal-add-block_sigmask-for-adding-sigmask-to-current-blocked
+++ a/kernel/signal.c
@@ -2318,6 +2318,27 @@ relock:
 	return signr;
 }
 
+/**
+ * block_sigmask - add @ka's signal mask to current->blocked
+ * @ka: action for @signr
+ * @signr: signal that has been successfully delivered
+ *
+ * This function should be called when a signal has succesfully been
+ * delivered. It adds the mask of signals for @ka to current->blocked
+ * so that they are blocked during the execution of the signal
+ * handler. In addition, @signr will be blocked unless %SA_NODEFER is
+ * set in @ka->sa.sa_flags.
+ */
+void block_sigmask(struct k_sigaction *ka, int signr)
+{
+	sigset_t blocked;
+
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
+		sigaddset(&blocked, signr);
+	set_current_blocked(&blocked);
+}
+
 /*
  * It could be that complete_signal() picked us to notify about the
  * group-wide signal. Other threads should be notified now to take
_

Patches currently in -mm which might be from matt.fleming@intel.com are

origin.patch
linux-next.patch

