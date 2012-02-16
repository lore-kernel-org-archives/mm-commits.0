From: akpm@linux-foundation.org
Subject: [merged] openrisc-dont-reimplement-force_sigsegv.patch removed from -mm tree
Date: Thu, 16 Feb 2012 11:47:06 -0800
Message-ID: <20120216194707.0F8D7A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57206 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2BPTrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2012 14:47:08 -0500
Received: by mail-ey0-f202.google.com with SMTP id f13so84607eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2012 11:47:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, arnd@arndb.de, jonas@southpole.se, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: OpenRISC: don't reimplement force_sigsegv()
has been removed from the -mm tree.  Its filename was
     openrisc-dont-reimplement-force_sigsegv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: OpenRISC: don't reimplement force_sigsegv()

Instead of open coding the sequence from force_sigsegv() just call it. 
This also fixes a bug because we were modifying ka->sa.sa_handler (which
is a copy of sighand->action[]), whereas the intention of the code was to
modify sighand->action[] directly.

As the original code was working with a copy it had no effect on signal
delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/signal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/openrisc/kernel/signal.c~openrisc-dont-reimplement-force_sigsegv arch/openrisc/kernel/signal.c
--- a/arch/openrisc/kernel/signal.c~openrisc-dont-reimplement-force_sigsegv
+++ a/arch/openrisc/kernel/signal.c
@@ -250,9 +250,7 @@ static void setup_rt_frame(int sig, stru
 	return;
 
 give_sigsegv:
-	if (sig == SIGSEGV)
-		ka->sa.sa_handler = SIG_DFL;
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 }
 
 static inline void
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
arm-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
powerpc-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
tile-use-set_current_blocked-and-block_sigmask.patch
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
s390-use-block_sigmask.patch
xtensa-dont-reimplement-force_sigsegv.patch
xtensa-no-need-to-reset-handler-if-sa_oneshot.patch
xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
xtensa-use-set_current_blocked-and-block_sigmask.patch
sparc-use-block_sigmask.patch
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

