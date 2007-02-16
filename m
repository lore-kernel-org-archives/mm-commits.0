From: akpm@linux-foundation.org
Subject: + fix-i386-and-x86_64-fault-information-pollution.patch added to -mm tree
Date: Thu, 15 Feb 2007 17:05:15 -0800
Message-ID: <200702160105.l1G15FKH015004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXBPBF0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, ak@suse.de, jbeulich@novell.com


The patch titled
     Fix i386 and x86_64 fault information pollution
has been added to the -mm tree.  Its filename is
     fix-i386-and-x86_64-fault-information-pollution.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix i386 and x86_64 fault information pollution
From: Jeff Dike <jdike@addtoit.com>

A userspace fault or a kernelspace fault which will result in the immediate
death of the process.  They should not be filled in as a result of a
kernelspace fault which can be fixed up.

Otherwise, if the process is handling SIGSEGV and examining the fault
information, this can result in the kernel space fault trashing the
previously stored fault information if it arrives between the userspace
fault happening and the SIGSEGV being delivered to the process.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Acked-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c   |   24 ++++++++++++++++++------
 arch/x86_64/kernel/traps.c |   30 +++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 13 deletions(-)

diff -puN arch/i386/kernel/traps.c~fix-i386-and-x86_64-fault-information-pollution arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~fix-i386-and-x86_64-fault-information-pollution
+++ a/arch/i386/kernel/traps.c
@@ -477,8 +477,6 @@ static void __kprobes do_trap(int trapnr
 			      siginfo_t *info)
 {
 	struct task_struct *tsk = current;
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
 
 	if (regs->eflags & VM_MASK) {
 		if (vm86)
@@ -490,6 +488,18 @@ static void __kprobes do_trap(int trapnr
 		goto kernel_trap;
 
 	trap_signal: {
+		/*
+		 * We want error_code and trap_no set for userspace faults and
+		 * kernelspace faults which result in die(), but not
+		 * kernelspace faults which are fixed up.  die() gives the
+		 * process no chance to handle the signal and notice the
+		 * kernel fault information, so that won't result in polluting
+		 * the information about previously queued, but not yet
+		 * delivered, faults.  See also do_general_protection below.
+		 */
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (info)
 			force_sig_info(signr, info, tsk);
 		else
@@ -498,8 +508,11 @@ static void __kprobes do_trap(int trapnr
 	}
 
 	kernel_trap: {
-		if (!fixup_exception(regs))
+		if (!fixup_exception(regs)) {
+			tsk->thread.error_code = error_code;
+			tsk->thread.trap_no = trapnr;
 			die(str, regs, error_code);
+		}
 		return;
 	}
 
@@ -604,9 +617,6 @@ fastcall void __kprobes do_general_prote
 	}
 	put_cpu();
 
-	current->thread.error_code = error_code;
-	current->thread.trap_no = 13;
-
 	if (regs->eflags & VM_MASK)
 		goto gp_in_vm86;
 
@@ -625,6 +635,8 @@ gp_in_vm86:
 
 gp_in_kernel:
 	if (!fixup_exception(regs)) {
+		current->thread.error_code = error_code;
+		current->thread.trap_no = 13;
 		if (notify_die(DIE_GPF, "general protection fault", regs,
 				error_code, 13, SIGSEGV) == NOTIFY_STOP)
 			return;
diff -puN arch/x86_64/kernel/traps.c~fix-i386-and-x86_64-fault-information-pollution arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~fix-i386-and-x86_64-fault-information-pollution
+++ a/arch/x86_64/kernel/traps.c
@@ -582,10 +582,20 @@ static void __kprobes do_trap(int trapnr
 {
 	struct task_struct *tsk = current;
 
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
-
 	if (user_mode(regs)) {
+		/*
+		 * We want error_code and trap_no set for userspace
+		 * faults and kernelspace faults which result in
+		 * die(), but not kernelspace faults which are fixed
+		 * up.  die() gives the process no chance to handle
+		 * the signal and notice the kernel fault information,
+		 * so that won't result in polluting the information
+		 * about previously queued, but not yet delivered,
+		 * faults.  See also do_general_protection below.
+		 */
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (exception_trace && unhandled_signal(tsk, signr))
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
@@ -606,8 +616,11 @@ static void __kprobes do_trap(int trapnr
 		fixup = search_exception_tables(regs->rip);
 		if (fixup)
 			regs->rip = fixup->fixup;
-		else	
+		else {
+			tsk->thread.error_code = error_code;
+			tsk->thread.trap_no = trapnr;
 			die(str, regs, error_code);
+		}
 		return;
 	}
 }
@@ -683,10 +696,10 @@ asmlinkage void __kprobes do_general_pro
 
 	conditional_sti(regs);
 
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-
 	if (user_mode(regs)) {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = 13;
+
 		if (exception_trace && unhandled_signal(tsk, SIGSEGV))
 			printk(KERN_INFO
 		       "%s[%d] general protection rip:%lx rsp:%lx error:%lx\n",
@@ -705,6 +718,9 @@ asmlinkage void __kprobes do_general_pro
 			regs->rip = fixup->fixup;
 			return;
 		}
+
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = 13;
 		if (notify_die(DIE_GPF, "general protection fault", regs,
 					error_code, 13, SIGSEGV) == NOTIFY_STOP)
 			return;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
fix-i386-and-x86_64-fault-information-pollution.patch
uml-fix-prototypes.patch
