From: akpm@linux-foundation.org
Subject: [merged] um-dont-restore-current-blocked-on-error.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:07 -0700
Message-ID: <20120326192807.8C17DA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:65300 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956Ab2CZT2K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2012 15:28:10 -0400
Received: by laai8 with SMTP id i8so288221laa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, oleg@redhat.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: don't restore current->blocked on error
has been removed from the -mm tree.  Its filename was
     um-dont-restore-current-blocked-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: um: don't restore current->blocked on error

If we fail to setup the signal stack frame then we don't need to restore
current->blocked because it is not modified by setup_signal_stack_*.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/signal.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/um/kernel/signal.c~um-dont-restore-current-blocked-on-error arch/um/kernel/signal.c
--- a/arch/um/kernel/signal.c~um-dont-restore-current-blocked-on-error
+++ a/arch/um/kernel/signal.c
@@ -65,13 +65,9 @@ static int handle_signal(struct pt_regs 
 #endif
 		err = setup_signal_stack_si(sp, signr, ka, regs, info, oldset);
 
-	if (err) {
-		spin_lock_irq(&current->sighand->siglock);
-		current->blocked = *oldset;
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+	if (err)
 		force_sigsegv(signr, current);
-	} else {
+	else {
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked, &current->blocked,
 			  &ka->sa.sa_mask);
_

Patches currently in -mm which might be from matt.fleming@intel.com are

origin.patch
linux-next.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
powerpc-eeh-remove-eeh_event_handler-daemonize.patch

