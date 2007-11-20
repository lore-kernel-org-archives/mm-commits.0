From: akpm@linux-foundation.org
Subject: + uml-use-ptrace-directly-in-libc-code.patch added to -mm tree
Date: Tue, 20 Nov 2007 13:25:20 -0800
Message-ID: <200711202125.lAKLPK6L024216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbXKTVZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 16:25:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: use ptrace directly in libc code
has been added to the -mm tree.  Its filename is
     uml-use-ptrace-directly-in-libc-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -298,7 +298,9 @@ void userspace(struct uml_pt_regs *regs)
 	nsecs += os_nsecs();
 
 	while (1) {
-		restore_registers(pid, regs);
+		if (ptrace(PTRACE_SETREGS, pid, 0, regs->gp))
+			panic("userspace - PTRACE_SETREGS failed, "
+			      "errno = %d\n", errno);
 
 		/* Now we set local_using_sysemu to be used for one loop */
 		local_using_sysemu = get_using_sysemu();
@@ -318,7 +320,10 @@ void userspace(struct uml_pt_regs *regs)
 			      errno);
 
 		regs->is_user = 1;
-		save_registers(pid, regs);
+		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp))
+			panic("userspace - saving registers failed, "
+			      "errno = %d\n", errno);
+
 		UPT_SYSCALL_NR(regs) = -1; /* Assume: It's not a syscall */
 
 		if (WIFSTOPPED(status)) {
@@ -341,7 +346,7 @@ void userspace(struct uml_pt_regs *regs)
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

git-kvm.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
