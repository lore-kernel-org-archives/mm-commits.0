From: akpm@linux-foundation.org
Subject: [merged] sh-no-need-to-reset-handler-if-sa_oneshot.patch removed from -mm tree
Date: Tue, 03 Apr 2012 13:10:42 -0700
Message-ID: <20120403201042.73C87A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35417 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2DCUKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 16:10:43 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so4116wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 13:10:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, lethal@linux-sh.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: no need to reset handler if SA_ONESHOT
has been removed from the -mm tree.  Its filename was
     sh-no-need-to-reset-handler-if-sa_oneshot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: sh: no need to reset handler if SA_ONESHOT

get_signal_to_deliver() already resets the signal handler if SA_ONESHOT is
set in ka->sa.sa_flags, there's no need to do it again in handle_signal().
 Furthermore, because we were modifying ka->sa.sa_handler (which is a copy
of sighand->action[]) instead of sighand->action[] the original code had
no effect on signal delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/signal_32.c |    3 ---
 arch/sh/kernel/signal_64.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN arch/sh/kernel/signal_32.c~sh-no-need-to-reset-handler-if-sa_oneshot arch/sh/kernel/signal_32.c
--- a/arch/sh/kernel/signal_32.c~sh-no-need-to-reset-handler-if-sa_oneshot
+++ a/arch/sh/kernel/signal_32.c
@@ -548,9 +548,6 @@ handle_signal(unsigned long sig, struct 
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
-
 	if (ret == 0) {
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
diff -puN arch/sh/kernel/signal_64.c~sh-no-need-to-reset-handler-if-sa_oneshot arch/sh/kernel/signal_64.c
--- a/arch/sh/kernel/signal_64.c~sh-no-need-to-reset-handler-if-sa_oneshot
+++ a/arch/sh/kernel/signal_64.c
@@ -734,9 +734,6 @@ handle_signal(unsigned long sig, siginfo
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
-
 	if (ret == 0) {
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
_

Patches currently in -mm which might be from matt.fleming@intel.com are

origin.patch
linux-next.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
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
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch

