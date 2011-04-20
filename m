From: akpm@linux-foundation.org
Subject: + sh-convert-to-asm-generic-ptraceh.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:07:29 -0700
Message-ID: <201104202107.p3KL7TwT027096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658Ab1DTVHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dongdong.deng@windriver.com, hpa@zytor.com, jason.wessel@windriver.com, lethal@linux-sh.org, mingo@redhat.com, oleg@redhat.com, sshtylyov@mvista.com, tglx@linutronix.de


The patch titled
     sh: convert to asm-generic ptrace.h
has been added to the -mm tree.  Its filename is
     sh-convert-to-asm-generic-ptraceh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: convert to asm-generic ptrace.h
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/ptrace.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/sh/include/asm/ptrace.h~sh-convert-to-asm-generic-ptraceh arch/sh/include/asm/ptrace.h
--- a/arch/sh/include/asm/ptrace.h~sh-convert-to-asm-generic-ptraceh
+++ a/arch/sh/include/asm/ptrace.h
@@ -40,9 +40,8 @@
 #include <asm/system.h>
 
 #define user_mode(regs)			(((regs)->sr & 0x40000000)==0)
-#define user_stack_pointer(_regs)	((unsigned long)(_regs)->regs[15])
 #define kernel_stack_pointer(_regs)	((unsigned long)(_regs)->regs[15])
-#define instruction_pointer(regs)	((unsigned long)(regs)->pc)
+#define GET_USP(regs) ((regs)->regs[15])
 
 extern void show_regs(struct pt_regs *);
 
@@ -139,6 +138,9 @@ static inline unsigned long profile_pc(s
 
 	return pc;
 }
+#define profile_pc profile_pc
+
+#include <asm-generic/ptrace.h>
 #endif /* __KERNEL__ */
 
 #endif /* __ASM_SH_PTRACE_H */
_

Patches currently in -mm which might be from vapier@gentoo.org are

backlight-new-driver-for-the-adp8870-backlight-devices.patch
linux-next.patch
net-irda-convert-bfin_sir-to-common-blackfin-uart-header.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
proc-constify-status-array.patch

