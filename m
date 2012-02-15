From: akpm@linux-foundation.org
Subject: + sh-no-need-to-reset-handler-if-sa_oneshot.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:34:22 -0800
Message-ID: <20120215003422.D40BFA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59737 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761416Ab2BOAeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:34:24 -0500
Received: by mail-ey0-f202.google.com with SMTP id f13so15067eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:34:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, lethal@linux-sh.org, oleg@redhat.com


The patch titled
     Subject: sh: no need to reset handler if SA_ONESHOT
has been added to the -mm tree.  Its filename is
     sh-no-need-to-reset-handler-if-sa_oneshot.patch

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
Subject: Subject: sh: no need to reset handler if SA_ONESHOT

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

