From: akpm@linux-foundation.org
Subject: - uml-use-ptrace-directly-in-libc-code.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:48 -0800
Message-ID: <200802052236.m15MaTa4012715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760767AbYBEWln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: use ptrace directly in libc code
has been removed from the -mm tree.  Its filename was
     uml-use-ptrace-directly-in-libc-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: use ptrace directly in libc code
From: Jeff Dike <jdike@addtoit.com>

Some register accessor cleanups -
	userspace() was calling restore_registers and save_registers for no
reason, since userspace() is on the libc side of the house, and these
add no value over calling ptrace directly
	init_thread_registers and get_safe_registers were the same thing,
so init_thread_registers is gone

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/registers.h     |    1 -
 arch/um/kernel/process.c        |    2 +-
 arch/um/os-Linux/registers.c    |   13 ++++---------
 arch/um/os-Linux/skas/process.c |   11 ++++++++---
 4 files changed, 13 insertions(+), 14 deletions(-)

diff -puN arch/um/include/registers.h~uml-use-ptrace-directly-in-libc-code arch/um/include/registers.h
--- a/arch/um/include/registers.h~uml-use-ptrace-directly-in-libc-code
+++ a/arch/um/include/registers.h
@@ -9,7 +9,6 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/archsetjmp.h"
 
-extern void init_thread_registers(struct uml_pt_regs *to);
 extern int save_fp_registers(int pid, unsigned long *fp_regs);
 extern int restore_fp_registers(int pid, unsigned long *fp_regs);
 extern int save_fpx_registers(int pid, unsigned long *fp_regs);
diff -puN arch/um/kernel/process.c~uml-use-ptrace-directly-in-libc-code arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-use-ptrace-directly-in-libc-code
+++ a/arch/um/kernel/process.c
@@ -199,7 +199,7 @@ int copy_thread(int nr, unsigned long cl
 		arch_copy_thread(&current->thread.arch, &p->thread.arch);
 	}
 	else {
-		init_thread_registers(&p->thread.regs.regs);
+		get_safe_registers(p->thread.regs.regs.gp);
 		p->thread.request.u.thread = current->thread.request.u.thread;
 		handler = new_thread_handler;
 	}
diff -puN arch/um/os-Linux/registers.c~uml-use-ptrace-directly-in-libc-code arch/um/os-Linux/registers.c
--- a/arch/um/os-Linux/registers.c~uml-use-ptrace-directly-in-libc-code
+++ a/arch/um/os-Linux/registers.c
@@ -10,15 +10,6 @@
 #include "sysdep/ptrace.h"
 #include "user.h"
 
-/* This is set once at boot time and not changed thereafter */
-
-static unsigned long exec_regs[MAX_REG_NR];
-
-void init_thread_registers(struct uml_pt_regs *to)
-{
-	memcpy(to->gp, exec_regs, sizeof(to->gp));
-}
-
 void save_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
@@ -39,6 +30,10 @@ void restore_registers(int pid, struct u
 		      "errno = %d\n", errno);
 }
 
+/* This is set once at boot time and not changed thereafter */
+
+static unsigned long exec_regs[MAX_REG_NR];
+
 void init_registers(int pid)
 {
 	int err;
diff -puN arch/um/os-Linux/skas/process.c~uml-use-ptrace-directly-in-libc-code arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-use-ptrace-directly-in-libc-code
+++ a/arch/um/os-Linux/skas/process.c
@@ -300,7 +300,9 @@ void userspace(struct uml_pt_regs *regs)
 	nsecs += os_nsecs();
 
 	while (1) {
-		restore_registers(pid, regs);
+		if (ptrace(PTRACE_SETREGS, pid, 0, regs->gp))
+			panic("userspace - PTRACE_SETREGS failed, "
+			      "errno = %d\n", errno);
 
 		/* Now we set local_using_sysemu to be used for one loop */
 		local_using_sysemu = get_using_sysemu();
@@ -320,7 +322,10 @@ void userspace(struct uml_pt_regs *regs)
 			      errno);
 
 		regs->is_user = 1;
-		save_registers(pid, regs);
+		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp))
+			panic("userspace - saving registers failed, "
+			      "errno = %d\n", errno);
+
 		UPT_SYSCALL_NR(regs) = -1; /* Assume: It's not a syscall */
 
 		if (WIFSTOPPED(status)) {
@@ -343,7 +348,7 @@ void userspace(struct uml_pt_regs *regs)
 				break;
 			case SIGVTALRM:
 				now = os_nsecs();
-				if(now < nsecs)
+				if (now < nsecs)
 					break;
 				block_signals();
 				(*sig_info[sig])(sig, regs);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
