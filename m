From: akpm@linux-foundation.org
Subject: [merged] sh-convert-to-asm-generic-ptraceh.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:28 -0700
Message-ID: <201105271956.p4RJuXMY017569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757076Ab1E0T5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dongdong.deng@windriver.com, hpa@zytor.com, jason.wessel@windriver.com, lethal@linux-sh.org, mingo@redhat.com, oleg@redhat.com, sshtylyov@mvista.com, tglx@linutronix


The patch titled
     sh: convert to asm-generic ptrace.h
has been removed from the -mm tree.  Its filename was
     sh-convert-to-asm-generic-ptraceh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-add-backlight-type-fix.patch
linux-next.patch

