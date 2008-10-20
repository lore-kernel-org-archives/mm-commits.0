From: akpm@linux-foundation.org
Subject: + kexec-fix-hang-on-i386-when-panic-occurs-while-console_sem-is-held.patch added to -mm tree
Date: Mon, 20 Oct 2008 16:25:46 -0700
Message-ID: <200810202325.m9KNPkNs009825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbYJTX0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 19:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, mingo@elte.hu, tglx@linutronix.de, vgoyal@redhat.com


The patch titled
     kexec: fix hang on i386 when panic occurs while console_sem is held
has been added to the -mm tree.  Its filename is
     kexec-fix-hang-on-i386-when-panic-occurs-while-console_sem-is-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: fix hang on i386 when panic occurs while console_sem is held
From: Neil Horman <nhorman@tuxdriver.com>

There is a corner case in 32 bit x86 kdump at the moment.  When the box
panics via nmi, we call bust_spinlocks(1) to disable sensitivity to the
console_sem (allowing us to print to the console in all cases), but we don't
call crash_kexec, until after we call bust_spinlocks(0), which re-enables
console_sem sensitivity.

The result is that, if we get an nmi while the console_sem is held and
kdump is configured, and we try to print something to the console during
kdump shutdown (which we often do) we deadlock the box.  The fix is to
simply do what 64 bit die_nmi does which is to not call bust_spinlocks(0)
until after we call crash_kexec.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/dumpstack_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/dumpstack_32.c~kexec-fix-hang-on-i386-when-panic-occurs-while-console_sem-is-held arch/x86/kernel/dumpstack_32.c
--- a/arch/x86/kernel/dumpstack_32.c~kexec-fix-hang-on-i386-when-panic-occurs-while-console_sem-is-held
+++ a/arch/x86/kernel/dumpstack_32.c
@@ -405,7 +405,6 @@ die_nmi(char *str, struct pt_regs *regs,
 		panic("Non maskable interrupt");
 	console_silent();
 	spin_unlock(&nmi_print_lock);
-	bust_spinlocks(0);
 
 	/*
 	 * If we are in kernel we are probably nested up pretty bad
@@ -416,6 +415,7 @@ die_nmi(char *str, struct pt_regs *regs,
 		crash_kexec(regs);
 	}
 
+	bust_spinlocks(0);
 	do_exit(SIGSEGV);
 }
 
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
linux-next.patch
kexec-fix-hang-on-i386-when-panic-occurs-while-console_sem-is-held.patch

