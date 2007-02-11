From: akpm@linux-foundation.org
Subject: - uml-register-handling-formatting-fixes.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:41 -0800
Message-ID: <200702112249.l1BMnfXR015775@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714AbXBKWto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: register handling formatting fixes
has been removed from the -mm tree.  Its filename was
     uml-register-handling-formatting-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: register handling formatting fixes
From: Jeff Dike <jdike@addtoit.com>

Formatting fixes in the register handling code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sys-i386/registers.c   |   14 +++++++-------
 arch/um/os-Linux/sys-x86_64/registers.c |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-register-handling-formatting-fixes arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-register-handling-formatting-fixes
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -34,27 +34,27 @@ void init_thread_registers(union uml_pt_
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
 	if(ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
-		return(-errno);
-	return(0);
+		return -errno;
+	return 0;
 }
 
 int restore_fp_registers(int pid, unsigned long *fp_regs)
 {
 	if(ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
-		return(-errno);
-	return(0);
+		return -errno;
+	return 0;
 }
 
 static int move_registers(int pid, int int_op, union uml_pt_regs *regs,
 			  int fp_op, unsigned long *fp_regs)
 {
 	if(ptrace(int_op, pid, 0, regs->skas.regs) < 0)
-		return(-errno);
+		return -errno;
 
 	if(ptrace(fp_op, pid, 0, fp_regs) < 0)
-		return(-errno);
+		return -errno;
 
-	return(0);
+	return 0;
 }
 
 void save_registers(int pid, union uml_pt_regs *regs)
diff -puN arch/um/os-Linux/sys-x86_64/registers.c~uml-register-handling-formatting-fixes arch/um/os-Linux/sys-x86_64/registers.c
--- a/arch/um/os-Linux/sys-x86_64/registers.c~uml-register-handling-formatting-fixes
+++ a/arch/um/os-Linux/sys-x86_64/registers.c
@@ -27,12 +27,12 @@ static int move_registers(int pid, int i
 			  union uml_pt_regs *regs)
 {
 	if(ptrace(int_op, pid, 0, regs->skas.regs) < 0)
-		return(-errno);
+		return -errno;
 
 	if(ptrace(fp_op, pid, 0, regs->skas.fp) < 0)
-		return(-errno);
+		return -errno;
 
-	return(0);
+	return 0;
 }
 
 void save_registers(int pid, union uml_pt_regs *regs)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
