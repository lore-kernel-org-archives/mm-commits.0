From: akpm@linux-foundation.org
Subject: [merged] blackfin-convert-to-asm-generic-ptraceh.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:24 -0700
Message-ID: <201105271956.p4RJuT00017562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756879Ab1E0T5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, hpa@zytor.com, jason.wessel@windriver.com, lethal@linux-sh.org, mingo@redhat.com, oleg@redhat.com, sshtylyov@mvista.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Blackfin: convert to asm-generic ptrace.h
has been removed from the -mm tree.  Its filename was
     blackfin-convert-to-asm-generic-ptraceh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin: convert to asm-generic ptrace.h
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/ptrace.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/blackfin/include/asm/ptrace.h~blackfin-convert-to-asm-generic-ptraceh arch/blackfin/include/asm/ptrace.h
--- a/arch/blackfin/include/asm/ptrace.h~blackfin-convert-to-asm-generic-ptraceh
+++ a/arch/blackfin/include/asm/ptrace.h
@@ -102,9 +102,6 @@ struct pt_regs {
 /* user_mode returns true if only one bit is set in IPEND, other than the
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
-#define instruction_pointer(regs) ((regs)->pc)
-#define user_stack_pointer(regs)  ((regs)->usp)
-#define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
@@ -128,6 +125,8 @@ extern int is_user_addr_valid(struct tas
 	    ((unsigned long)task_stack_page(task) + \
 	     (THREAD_SIZE - sizeof(struct pt_regs)))
 
+#include <asm-generic/ptrace.h>
+
 #endif  /*  __KERNEL__  */
 
 #endif				/* __ASSEMBLY__ */
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-add-backlight-type-fix.patch
linux-next.patch

