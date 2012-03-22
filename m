From: akpm@linux-foundation.org
Subject: [merged] xtensa-dont-reimplement-force_sigsegv.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:13 -0700
Message-ID: <20120322201713.67A92A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41893 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2CVURP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:15 -0400
Received: by eekc41 with SMTP id c41so136539eek.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, chris@zankel.net, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: don't reimplement force_sigsegv()
has been removed from the -mm tree.  Its filename was
     xtensa-dont-reimplement-force_sigsegv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
powerpc-eeh-remove-eeh_event_handler-daemonize.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch

