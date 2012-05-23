From: akpm@linux-foundation.org
Subject: [alternative-merged] avr32-dont-mask-signals-in-the-error-path.patch removed from -mm tree
Date: Wed, 23 May 2012 12:46:41 -0700
Message-ID: <20120523194645.8927FA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64466 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2EWTqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:46:48 -0400
Received: by ggeh3 with SMTP id h3so922101gge.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:46:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: don't mask signals in the error path
has been removed from the -mm tree.  Its filename was
     avr32-dont-mask-signals-in-the-error-path.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: avr32: don't mask signals in the error path

The current handle_signal() implementation is broken - it will mask
signals if we fail to setup the signal stack frame, which isn't the
desired behaviour, we should only be masking signals if we succeed in
setting up the stack frame.  It looks like this code was copied from the
old (broken) arm implementation but wasn't updated when the arm code was
fixed in commit a6c61e9dfdd0 ("[ARM] 3168/1: Update ARM signal delivery
and masking").

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/signal.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN arch/avr32/kernel/signal.c~avr32-dont-mask-signals-in-the-error-path arch/avr32/kernel/signal.c
--- a/arch/avr32/kernel/signal.c~avr32-dont-mask-signals-in-the-error-path
+++ a/arch/avr32/kernel/signal.c
@@ -238,22 +238,21 @@ handle_signal(unsigned long sig, struct 
 	 */
 	ret |= !valid_user_regs(regs);
 
+	if (ret != 0) {
+		force_sigsegv(sig, current);
+		return;
+	}
+
 	/*
-	 * Block the signal if we were unsuccessful.
+	 * Block the signal if we were successful.
 	 */
-	if (ret != 0 || !(ka->sa.sa_flags & SA_NODEFER)) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka->sa.sa_mask);
+	spin_lock_irq(&current->sighand->siglock);
+	sigorsets(&current->blocked, &current->blocked,
+		  &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
 		sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
-
-	if (ret == 0)
-		return;
-
-	force_sigsegv(sig, current);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
 }
 
 /*
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
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

