From: akpm@linux-foundation.org
Subject: + fix-x86_64-compilation-with-debug_sig-on.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:49:37 -0800
Message-ID: <200703250749.l2P7nb8h023144@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35353 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbXCYHty (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:49:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, ak@suse.de


The patch titled
     Fix x86_64 compilation with DEBUG_SIG on
has been added to the -mm tree.  Its filename is
     fix-x86_64-compilation-with-debug_sig-on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix x86_64 compilation with DEBUG_SIG on
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Setting the DEBUG_SIG flag breaks compilation due to a wrong struct access.
Additionally, it raises two warnings.  This is one patch to fix them all.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/signal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/signal.c~fix-x86_64-compilation-with-debug_sig-on arch/x86_64/kernel/signal.c
--- a/arch/x86_64/kernel/signal.c~fix-x86_64-compilation-with-debug_sig-on
+++ a/arch/x86_64/kernel/signal.c
@@ -141,7 +141,7 @@ asmlinkage long sys_rt_sigreturn(struct 
 		goto badframe;
 
 #ifdef DEBUG_SIG
-	printk("%d sigreturn rip:%lx rsp:%lx frame:%p rax:%lx\n",current->pid,regs.rip,regs.rsp,frame,eax);
+	printk("%d sigreturn rip:%lx rsp:%lx frame:%p rax:%lx\n",current->pid,regs->rip,regs->rsp,frame,eax);
 #endif
 
 	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->rsp) == -EFAULT)
@@ -298,7 +298,7 @@ static int setup_rt_frame(int sig, struc
 	set_fs(USER_DS);
 
 #ifdef DEBUG_SIG
-	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
+	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%p\n",
 		current->comm, current->pid, frame, regs->rip, frame->pretcode);
 #endif
 
@@ -465,7 +465,7 @@ void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
 #ifdef DEBUG_SIG
-	printk("do_notify_resume flags:%x rip:%lx rsp:%lx caller:%lx pending:%lx\n",
+	printk("do_notify_resume flags:%x rip:%lx rsp:%lx caller:%p pending:%x\n",
 	       thread_info_flags, regs->rip, regs->rsp, __builtin_return_address(0),signal_pending(current)); 
 #endif
 	       
_

Patches currently in -mm which might be from gcosta@redhat.com are

x86_64-remove-duplicated-code-for-reading-control-registers.patch
yet-another-function-to-load-cr3-register.patch
fix-x86_64-compilation-with-debug_sig-on.patch
