From: akpm@linux-foundation.org
Subject: + xtensa-dont-reimplement-force_sigsegv.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:34:36 -0800
Message-ID: <20120215003436.E6DC5A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m020-f202.google.com ([209.85.217.202]:56663 "EHLO
	mail-lpp01m020-f202.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761422Ab2BOAej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Feb 2012 19:34:39 -0500
Received: by lban1 with SMTP id n1so7622lba.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:34:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, chris@zankel.net, oleg@redhat.com


The patch titled
     Subject: xtensa: don't reimplement force_sigsegv()
has been added to the -mm tree.  Its filename is
     xtensa-dont-reimplement-force_sigsegv.patch

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
Subject: xtensa: don't reimplement force_sigsegv()

Instead of open coding the sequence from force_sigsegv() just call it. 
This also fixes a bug because we were modifying ka->sa.sa_handler (which
is a copy of sighand->action[]), whereas the intention of the code was to
modify sighand->action[] directly.

As the original code was working with a copy it had no effect on signal
delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/signal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/xtensa/kernel/signal.c~xtensa-dont-reimplement-force_sigsegv arch/xtensa/kernel/signal.c
--- a/arch/xtensa/kernel/signal.c~xtensa-dont-reimplement-force_sigsegv
+++ a/arch/xtensa/kernel/signal.c
@@ -425,9 +425,7 @@ static void setup_frame(int sig, struct 
 	return;
 
 give_sigsegv:
-	if (sig == SIGSEGV)
-		ka->sa.sa_handler = SIG_DFL;
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 }
 
 /*
_
Subject: Subject: xtensa: don't reimplement force_sigsegv()

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

