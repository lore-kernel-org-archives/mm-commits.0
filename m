From: akpm@linux-foundation.org
Subject: + uml-improve-ptrace_sysemu-checking.patch added to -mm tree
Date: Wed, 23 May 2007 11:43:45 -0700
Message-ID: <200705231843.l4NIhiAR029434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756000AbXEWSnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: improve PTRACE_SYSEMU checking
has been added to the -mm tree.  Its filename is
     uml-improve-ptrace_sysemu-checking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: improve PTRACE_SYSEMU checking
From: Jeff Dike <jdike@addtoit.com>

Make the PTRACE_SYSEMU checking more robust.  It will make sure that system
call numbers are reported correctly.  If there is a problem, it will disable
PTRACE_SYSEMU use and use PTRACE_SYSCALL instead.

Thanks to Balaji G for helping reproduce this problem.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/start_up.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~uml-improve-ptrace_sysemu-checking arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-improve-ptrace_sysemu-checking
+++ a/arch/um/os-Linux/start_up.c
@@ -144,9 +144,7 @@ static int stop_ptraced_child(int pid, v
 		int exit_with = WEXITSTATUS(status);
 		if (exit_with == 2)
 			non_fatal("check_ptrace : child exited with status 2. "
-				  "Serious trouble happening! Try updating "
-				  "your host skas patch!\nDisabling SYSEMU "
-				  "support.");
+				  "\nDisabling SYSEMU support.\n");
 		non_fatal("check_ptrace : child exited with exitcode %d, while "
 			  "expecting %d; status 0x%x\n", exit_with,
 			  exitcode, status);
@@ -209,6 +207,7 @@ __uml_setup("nosysemu", nosysemu_cmd_par
 static void __init check_sysemu(void)
 {
 	void *stack;
+	unsigned long regs[MAX_REG_NR];
 	int pid, n, status, count=0;
 
 	non_fatal("Checking syscall emulation patch for ptrace...");
@@ -225,11 +224,20 @@ static void __init check_sysemu(void)
 		fatal("check_sysemu : expected SIGTRAP, got status = %d",
 		      status);
 
-	n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
-		   os_getpid());
-	if(n < 0)
-		fatal_perror("check_sysemu : failed to modify system call "
-			     "return");
+	if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+		fatal_perror("check_sysemu : PTRACE_GETREGS failed");
+	if(PT_SYSCALL_NR(regs) != __NR_getpid){
+		non_fatal("check_sysemu got system call number %d, "
+			  "expected %d...", PT_SYSCALL_NR(regs), __NR_getpid);
+		goto fail;
+	}
+
+	n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET, os_getpid());
+	if(n < 0){
+		non_fatal("check_sysemu : failed to modify system call "
+			  "return");
+		goto fail;
+	}
 
 	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
 		goto fail_stopped;
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-improve-ptrace_sysemu-checking.patch
uml-fix-ubd_add-error-reporting.patch
