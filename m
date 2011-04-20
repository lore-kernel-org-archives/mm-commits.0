From: akpm@linux-foundation.org
Subject: + x86-convert-to-asm-generic-ptraceh.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:07:26 -0700
Message-ID: <201104202107.p3KL7QKk027023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658Ab1DTVHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dongdong.deng@windriver.com, hpa@zytor.com, jason.wessel@windriver.com, lethal@linux-sh.org, mingo@redhat.com, oleg@redhat.com, sshtylyov@mvista.com, tglx@linutronix.de


The patch titled
     x86: convert to asm-generic ptrace.h
has been added to the -mm tree.  Its filename is
     x86-convert-to-asm-generic-ptraceh.patch

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
Subject: x86: convert to asm-generic ptrace.h
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

 arch/x86/include/asm/ptrace.h |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN arch/x86/include/asm/ptrace.h~x86-convert-to-asm-generic-ptraceh arch/x86/include/asm/ptrace.h
--- a/arch/x86/include/asm/ptrace.h~x86-convert-to-asm-generic-ptraceh
+++ a/arch/x86/include/asm/ptrace.h
@@ -136,6 +136,7 @@ struct cpuinfo_x86;
 struct task_struct;
 
 extern unsigned long profile_pc(struct pt_regs *regs);
+#define profile_pc profile_pc
 
 extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
@@ -202,20 +203,11 @@ static inline unsigned long kernel_stack
 #endif
 }
 
-static inline unsigned long instruction_pointer(struct pt_regs *regs)
-{
-	return regs->ip;
-}
-
-static inline unsigned long frame_pointer(struct pt_regs *regs)
-{
-	return regs->bp;
-}
+#define GET_IP(regs) ((regs)->ip)
+#define GET_FP(regs) ((regs)->bp)
+#define GET_USP(regs) ((regs)->sp)
 
-static inline unsigned long user_stack_pointer(struct pt_regs *regs)
-{
-	return regs->sp;
-}
+#include <asm-generic/ptrace.h>
 
 /* Query offset/name of register from its name/offset */
 extern int regs_query_register_offset(const char *name);
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

