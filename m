From: akpm@linux-foundation.org
Subject: [alternative-merged] avr32-use-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:47:08 -0700
Message-ID: <20120523194709.0786DA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36481 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760655Ab2EWTrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:47:10 -0400
Received: by vcbfl13 with SMTP id fl13so224821vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:47:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: use block_sigmask()
has been removed from the -mm tree.  Its filename was
     avr32-use-block_sigmask.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: avr32: use block_sigmask()

Use the new helper function introduced in commit 5e6292c0f28f ("signal:
add block_sigmask() for adding sigmask to current->blocked") which
centralises the code for updating current->blocked after successfully
delivering a signal and reduces the amount of duplicate code across
architectures.

In the past some architectures got this code wrong, so using this helper
function should stop that from happening again.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Havard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/signal.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/avr32/kernel/signal.c~avr32-use-block_sigmask arch/avr32/kernel/signal.c
--- a/arch/avr32/kernel/signal.c~avr32-use-block_sigmask
+++ a/arch/avr32/kernel/signal.c
@@ -223,7 +223,6 @@ static inline void
 handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs, int syscall)
 {
-	sigset_t blocked;
 	int ret;
 
 	/*
@@ -244,10 +243,7 @@ handle_signal(unsigned long sig, struct 
 	/*
 	 * Block the signal if we were successful.
 	 */
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	block_sigmask(ka, sig);
 }
 
 /*
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
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

