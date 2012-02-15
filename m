From: akpm@linux-foundation.org
Subject: + um-dont-restore-current-blocked-on-error.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:34:30 -0800
Message-ID: <20120215003430.E5DA3A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61428 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761422Ab2BOAec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:34:32 -0500
Received: by mail-ee0-f74.google.com with SMTP id b15so18497eek.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:34:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, oleg@redhat.com, richard@nod.at


The patch titled
     Subject: um: don't restore current->blocked on error
has been added to the -mm tree.  Its filename is
     um-dont-restore-current-blocked-on-error.patch

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
Subject: Subject: um: don't restore current->blocked on error

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
arm-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
openrisc-dont-reimplement-force_sigsegv.patch
openrisc-no-need-to-reset-handler-if-sa_oneshot.patch
openrisc-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
openrisc-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
powerpc-use-set_current_blocked-and-block_sigmask.patch
use-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
sparc-use-block_sigmask.patch
tile-use-set_current_blocked-and-block_sigmask.patch
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
xtensa-dont-reimplement-force_sigsegv.patch
xtensa-no-need-to-reset-handler-if-sa_oneshot.patch
xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
xtensa-use-set_current_blocked-and-block_sigmask.patch

