From: akpm@linux-foundation.org
Subject: + signal-add-block_sigmask-for-adding-sigmask-to-current-blocked.patch added to -mm tree
Date: Wed, 04 Jan 2012 16:01:01 -0800
Message-ID: <20120105000102.072D720005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49325 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab2AEABF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2012 19:01:05 -0500
Received: by eaak10 with SMTP id k10so340003eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Jan 2012 16:01:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de, tj@kernel.org


The patch titled
     Subject: signal: add block_sigmask() for adding sigmask to current->blocked
has been added to the -mm tree.  Its filename is
     signal-add-block_sigmask-for-adding-sigmask-to-current-blocked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -683,7 +683,6 @@ static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 		struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int ret;
 
 	/* Are we from a system call? */
@@ -734,10 +733,7 @@ handle_signal(unsigned long sig, siginfo
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
@@ -2323,6 +2323,27 @@ relock:
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
Subject: Subject: signal: add block_sigmask() for adding sigmask to current->blocked

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
sparc-make-sa_nomask-a-synonym-of-sa_nodefer.patch
signal-add-block_sigmask-for-adding-sigmask-to-current-blocked.patch

