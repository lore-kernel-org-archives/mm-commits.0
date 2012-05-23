From: akpm@linux-foundation.org
Subject: [alternative-merged] m68k-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:47:28 -0700
Message-ID: <20120523194728.F2572A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51013 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2EWTra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:47:30 -0400
Received: by qcsp5 with SMTP id p5so922486qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:47:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, geert@linux-m68k.org, gerg@uclinux.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     m68k-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: m68k: use set_current_blocked() and block_sigmask()

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block is
pending in the shared queue.

Also, use the new helper function introduced in commit 5e6292c0f28f
("signal: add block_sigmask() for adding sigmask to current->blocked")
which centralises the code for updating current->blocked after
successfully delivering a signal and reduces the amount of duplicate code
across architectures.  In the past some architectures got this code wrong,
so using this helper function should stop that from happening again.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/signal.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN arch/m68k/kernel/signal.c~m68k-use-set_current_blocked-and-block_sigmask arch/m68k/kernel/signal.c
--- a/arch/m68k/kernel/signal.c~m68k-use-set_current_blocked-and-block_sigmask
+++ a/arch/m68k/kernel/signal.c
@@ -230,12 +230,13 @@ static inline void push_cache(unsigned l
 asmlinkage int
 sys_sigsuspend(int unused0, int unused1, old_sigset_t mask)
 {
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -804,8 +805,7 @@ asmlinkage int do_sigreturn(unsigned lon
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	current->blocked = set;
-	recalc_sigpending();
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, frame + 1))
 		goto badframe;
@@ -830,8 +830,7 @@ asmlinkage int do_rt_sigreturn(unsigned 
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	current->blocked = set;
-	recalc_sigpending();
+	set_current_blocked(&set);
 
 	if (rt_restore_ucontext(regs, sw, &frame->uc))
 		goto badframe;
@@ -1150,10 +1149,7 @@ handle_signal(int sig, struct k_sigactio
 	if (err)
 		return;
 
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
+	block_sigmask(ka, sig);
 
 	if (test_thread_flag(TIF_DELAYED_TRACE)) {
 		regs->sr &= ~0x8000;
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch

