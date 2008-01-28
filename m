From: akpm@linux-foundation.org
Subject: + uml-style-fixes-in-arch-um-sys-x86_64.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:23:22 -0800
Message-ID: <200801280524.m0S5OHii013756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbYA1FYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:24:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: style fixes in arch/um/sys-x86_64
has been added to the -mm tree.  Its filename is
     uml-style-fixes-in-arch-um-sys-x86_64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: style fixes in arch/um/sys-x86_64
From: Jeff Dike <jdike@addtoit.com>

Style fixes in arch/um/sys-x86_64:
	updated copyrights
	CodingStyle fixes
	added severities to printks which needed them

A bunch of functions in sys-*/ptrace_user.c turn out to be unused, so they and
their declarations are gone.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/ptrace_user.h      |   11 +-----
 arch/um/sys-i386/ptrace_user.c     |   14 --------
 arch/um/sys-x86_64/bug.c           |    3 +
 arch/um/sys-x86_64/ptrace.c        |   29 ++++++++---------
 arch/um/sys-x86_64/ptrace_user.c   |   46 ++-------------------------
 arch/um/sys-x86_64/syscall_table.c |   31 +++++++++++-------
 arch/um/sys-x86_64/sysrq.c         |   29 ++++++++---------
 arch/um/sys-x86_64/um_module.c     |    8 ++--
 8 files changed, 65 insertions(+), 106 deletions(-)

diff -puN arch/um/include/ptrace_user.h~uml-style-fixes-in-arch-um-sys-x86_64 arch/um/include/ptrace_user.h
--- a/arch/um/include/ptrace_user.h~uml-style-fixes-in-arch-um-sys-x86_64
+++ a/arch/um/include/ptrace_user.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -10,12 +10,6 @@
 
 extern int ptrace_getregs(long pid, unsigned long *regs_out);
 extern int ptrace_setregs(long pid, unsigned long *regs_in);
-extern int ptrace_getfpregs(long pid, unsigned long *regs_out);
-extern int ptrace_setfpregs(long pid, unsigned long *regs);
-extern void arch_enter_kernel(void *task, int pid);
-extern void arch_leave_kernel(void *task, int pid);
-extern void ptrace_pokeuser(unsigned long addr, unsigned long data);
-
 
 /* syscall emulation path in ptrace */
 
@@ -54,7 +48,8 @@ extern int sysemu_supported;
 	(((int[3][3] ) { \
 		{ PTRACE_SYSCALL, PTRACE_SYSCALL, PTRACE_SINGLESTEP }, \
 		{ PTRACE_SYSEMU, PTRACE_SYSEMU, PTRACE_SINGLESTEP }, \
-		{ PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP, PTRACE_SYSEMU_SINGLESTEP }}) \
+		{ PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP, \
+		  PTRACE_SYSEMU_SINGLESTEP } }) \
 		[sysemu_mode][singlestep_mode])
 
 #endif
diff -puN arch/um/sys-i386/ptrace_user.c~uml-style-fixes-in-arch-um-sys-x86_64 arch/um/sys-i386/ptrace_user.c
--- a/arch/um/sys-i386/ptrace_user.c~uml-style-fixes-in-arch-um-sys-x86_64
+++ a/arch/um/sys-i386/ptrace_user.c
@@ -19,17 +19,3 @@ int ptrace_setregs(long pid, unsigned lo
 		return -errno;
 	return 0;
 }
-
-int ptrace_getfpregs(long pid, unsigned long *regs)
-{
-	if (ptrace(PTRACE_GETFPREGS, pid, 0, regs) < 0)
-		return -errno;
-	return 0;
-}
-
-int ptrace_setfpregs(long pid, unsigned long *regs)
-{
-	if (ptrace(PTRACE_SETFPREGS, pid, 0, regs) < 0)
-		return -errno;
-	return 0;
-}
diff -puN arch/um/sys-x86_64/bug.c~uml-style-fixes-in-arch-um-sys-x86_64 arch/um/sys-x86_64/bug.c
--- a/arch/um/sys-x86_64/bug.c~uml-style-fixes-in-arch-um-sys-x86_64
+++ a/arch/um/sys-x86_64/bug.c
@@ -5,7 +5,8 @@
 
 #include <linux/uaccess.h>
 
-/* Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
+/*
+ * Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
  * that's not relevant in skas mode.
  */
 
diff -puN arch/um/sys-x86_64/ptrace.c~uml-style-fixes-in-arch-um-sys-x86_64 arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~uml-style-fixes-in-arch-um-sys-x86_64
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -5,13 +5,12 @@
  * Licensed under the GPL
  */
 
-#define __FRAME_OFFSETS
-#include <asm/ptrace.h>
+#include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
-#include <linux/mm.h>
+#define __FRAME_OFFSETS
+#include <asm/ptrace.h>
 #include <asm/uaccess.h>
-#include <asm/elf.h>
 
 /*
  * determines which flags the user has access to.
@@ -24,12 +23,14 @@ int putreg(struct task_struct *child, in
 	unsigned long tmp;
 
 #ifdef TIF_IA32
-	/* Some code in the 64bit emulation may not be 64bit clean.
-	   Don't take any chances. */
+	/*
+	 * Some code in the 64bit emulation may not be 64bit clean.
+	 * Don't take any chances.
+	 */
 	if (test_tsk_thread_flag(child, TIF_IA32))
 		value &= 0xffffffff;
 #endif
-	switch (regno){
+	switch (regno) {
 	case FS:
 	case GS:
 	case DS:
@@ -66,7 +67,7 @@ int poke_user(struct task_struct *child,
 	if (addr < MAX_REG_OFFSET)
 		return putreg(child, addr, data);
 	else if ((addr >= offsetof(struct user, u_debugreg[0])) &&
-		(addr <= offsetof(struct user, u_debugreg[7]))){
+		(addr <= offsetof(struct user, u_debugreg[7]))) {
 		addr -= offsetof(struct user, u_debugreg[0]);
 		addr = addr >> 2;
 		if ((addr == 4) || (addr == 5))
@@ -108,11 +109,10 @@ int peek_user(struct task_struct *child,
 		return -EIO;
 
 	tmp = 0;  /* Default return condition */
-	if (addr < MAX_REG_OFFSET){
+	if (addr < MAX_REG_OFFSET)
 		tmp = getreg(child, addr);
-	}
 	else if ((addr >= offsetof(struct user, u_debugreg[0])) &&
-		(addr <= offsetof(struct user, u_debugreg[7]))){
+		(addr <= offsetof(struct user, u_debugreg[7]))) {
 		addr -= offsetof(struct user, u_debugreg[0]);
 		addr = addr >> 2;
 		tmp = child->thread.arch.debugregs[addr];
@@ -127,8 +127,9 @@ int is_syscall(unsigned long addr)
 	int n;
 
 	n = copy_from_user(&instr, (void __user *) addr, sizeof(instr));
-	if (n){
-		/* access_process_vm() grants access to vsyscall and stub,
+	if (n) {
+		/*
+		 * access_process_vm() grants access to vsyscall and stub,
 		 * while copy_from_user doesn't. Maybe access_process_vm is
 		 * slow, but that doesn't matter, since it will be called only
 		 * in case of singlestepping, if copy_from_user failed.
@@ -155,7 +156,7 @@ int get_fpregs(struct user_i387_struct _
 		return err;
 
 	n = copy_to_user(buf, fpregs, sizeof(fpregs));
-	if(n > 0)
+	if (n > 0)
 		return -EFAULT;
 
 	return n;
diff -puN arch/um/sys-x86_64/ptrace_user.c~uml-style-fixes-in-arch-um-sys-x86_64 arch/um/sys-x86_64/ptrace_user.c
--- a/arch/um/sys-x86_64/ptrace_user.c~uml-style-fixes-in-arch-um-sys-x86_64
+++ a/arch/um/sys-x86_64/ptrace_user.c
@@ -4,55 +4,19 @@
  * Licensed under the GPL
  */
 
-#include <stddef.h>
 #include <errno.h>
 #include "ptrace_user.h"
-#include "user.h"
-#include "kern_constants.h"
 
 int ptrace_getregs(long pid, unsigned long *regs_out)
 {
-	if(ptrace(PTRACE_GETREGS, pid, 0, regs_out) < 0)
-		return(-errno);
-	return(0);
-}
-
-int ptrace_setregs(long pid, unsigned long *regs)
-{
-	if(ptrace(PTRACE_SETREGS, pid, 0, regs) < 0)
-		return(-errno);
+	if (ptrace(PTRACE_GETREGS, pid, 0, regs_out) < 0)
+		return -errno;
 	return(0);
 }
 
-int ptrace_setfpregs(long pid, unsigned long *regs)
+int ptrace_setregs(long pid, unsigned long *regs_out)
 {
-	if (ptrace(PTRACE_SETFPREGS, pid, 0, regs) < 0)
+	if (ptrace(PTRACE_SETREGS, pid, 0, regs_out) < 0)
 		return -errno;
-	return 0;
-}
-
-void ptrace_pokeuser(unsigned long addr, unsigned long data)
-{
-	panic("ptrace_pokeuser");
-}
-
-#define DS 184
-#define ES 192
-#define __USER_DS     0x2b
-
-void arch_enter_kernel(void *task, int pid)
-{
-}
-
-void arch_leave_kernel(void *task, int pid)
-{
-#ifdef UM_USER_CS
-        if(ptrace(PTRACE_POKEUSR, pid, CS, UM_USER_CS) < 0)
-                printk("POKEUSR CS failed");
-#endif
-
-        if(ptrace(PTRACE_POKEUSR, pid, DS, __USER_DS) < 0)
-                printk("POKEUSR DS failed");
-        if(ptrace(PTRACE_POKEUSR, pid, ES, __USER_DS) < 0)
-                printk("POKEUSR ES failed");
+	return(0);
 }
diff -puN arch/um/sys-x86_64/syscall_table.c~uml-style-fixes-in-arch-um-sys-x86_64 arch/um/sys-x86_64/syscall_table.c
--- a/arch/um/sys-x86_64/syscall_table.c~uml-style-fixes-in-arch-um-sys-x86_64
+++ a/arch/um/sys-x86_64/syscall_table.c
@@ -1,5 +1,7 @@
-/* System call table for UML/x86-64, copied from arch/x86_64/kernel/syscall.c
- * with some changes for UML. */
+/*
+ * System call table for UML/x86-64, copied from arch/x86_64/kernel/syscall.c
+ * with some changes for UML.
+ */
 
 #include <linux/linkage.h>
 #include <linux/sys.h>
@@ -8,22 +10,26 @@
 
 #define __NO_STUBS
 
-/* Below you can see, in terms of #define's, the differences between the x86-64
- * and the UML syscall table. */
+/*
+ * Below you can see, in terms of #define's, the differences between the x86-64
+ * and the UML syscall table.
+ */
 
 /* Not going to be implemented by UML, since we have no hardware. */
 #define stub_iopl sys_ni_syscall
 #define sys_ioperm sys_ni_syscall
 
-/* The UML TLS problem. Note that x86_64 does not implement this, so the below
- * is needed only for the ia32 compatibility. */
-/*#define sys_set_thread_area sys_ni_syscall
-#define sys_get_thread_area sys_ni_syscall*/
+/*
+ * The UML TLS problem. Note that x86_64 does not implement this, so the below
+ * is needed only for the ia32 compatibility.
+ */
 
 /* On UML we call it this way ("old" means it's not mmap2) */
 #define sys_mmap old_mmap
-/* On x86-64 sys_uname is actually sys_newuname plus a compatibility trick.
- * See arch/x86_64/kernel/sys_x86_64.c */
+/*
+ * On x86-64 sys_uname is actually sys_newuname plus a compatibility trick.
+ * See arch/x86_64/kernel/sys_x86_64.c
+ */
 #define sys_uname sys_uname64
 
 #define stub_clone sys_clone
@@ -47,7 +53,10 @@ typedef void (*sys_call_ptr_t)(void);
 extern void sys_ni_syscall(void);
 
 sys_call_ptr_t sys_call_table[UM_NR_syscall_max+1] __cacheline_aligned = {
-	/* Smells like a like a compiler bug -- it doesn't work when the & below is removed. */
+	/*
+	 * Smells like a like a compiler bug -- it doesn't work when the &
+	 * below is removed.
+	 */
 	[0 ... UM_NR_syscall_max] = &sys_ni_syscall,
 #include <asm-x86/unistd_64.h>
 };
diff -puN arch/um/sys-x86_64/sysrq.c~uml-style-fixes-in-arch-um-sys-x86_64 arch/um/sys-x86_64/sysrq.c
--- a/arch/um/sys-x86_64/sysrq.c~uml-style-fixes-in-arch-um-sys-x86_64
+++ a/arch/um/sys-x86_64/sysrq.c
@@ -4,32 +4,33 @@
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "linux/utsname.h"
-#include "linux/module.h"
-#include "asm/current.h"
-#include "asm/ptrace.h"
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/utsname.h>
+#include <asm/current.h>
+#include <asm/ptrace.h>
 #include "sysrq.h"
 
-void __show_regs(struct pt_regs * regs)
+void __show_regs(struct pt_regs *regs)
 {
 	printk("\n");
 	print_modules();
-	printk("Pid: %d, comm: %.20s %s %s\n", task_pid_nr(current),
+	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s\n", task_pid_nr(current),
 		current->comm, print_tainted(), init_utsname()->release);
-	printk("RIP: %04lx:[<%016lx>] ", PT_REGS_CS(regs) & 0xffff,
+	printk(KERN_INFO "RIP: %04lx:[<%016lx>]\n", PT_REGS_CS(regs) & 0xffff,
 	       PT_REGS_RIP(regs));
-	printk("\nRSP: %016lx  EFLAGS: %08lx\n", PT_REGS_RSP(regs),
+	printk(KERN_INFO "RSP: %016lx  EFLAGS: %08lx\n", PT_REGS_RSP(regs),
 	       PT_REGS_EFLAGS(regs));
-	printk("RAX: %016lx RBX: %016lx RCX: %016lx\n",
+	printk(KERN_INFO "RAX: %016lx RBX: %016lx RCX: %016lx\n",
 	       PT_REGS_RAX(regs), PT_REGS_RBX(regs), PT_REGS_RCX(regs));
-	printk("RDX: %016lx RSI: %016lx RDI: %016lx\n",
+	printk(KERN_INFO "RDX: %016lx RSI: %016lx RDI: %016lx\n",
 	       PT_REGS_RDX(regs), PT_REGS_RSI(regs), PT_REGS_RDI(regs));
-	printk("RBP: %016lx R08: %016lx R09: %016lx\n",
+	printk(KERN_INFO "RBP: %016lx R08: %016lx R09: %016lx\n",
 	       PT_REGS_RBP(regs), PT_REGS_R8(regs), PT_REGS_R9(regs));
-	printk("R10: %016lx R11: %016lx R12: %016lx\n",
+	printk(KERN_INFO "R10: %016lx R11: %016lx R12: %016lx\n",
 	       PT_REGS_R10(regs), PT_REGS_R11(regs), PT_REGS_R12(regs));
-	printk("R13: %016lx R14: %016lx R15: %016lx\n",
+	printk(KERN_INFO "R13: %016lx R14: %016lx R15: %016lx\n",
 	       PT_REGS_R13(regs), PT_REGS_R14(regs), PT_REGS_R15(regs));
 }
 
diff -puN arch/um/sys-x86_64/um_module.c~uml-style-fixes-in-arch-um-sys-x86_64 arch/um/sys-x86_64/um_module.c
--- a/arch/um/sys-x86_64/um_module.c~uml-style-fixes-in-arch-um-sys-x86_64
+++ a/arch/um/sys-x86_64/um_module.c
@@ -1,7 +1,7 @@
 #include <linux/vmalloc.h>
 #include <linux/moduleloader.h>
 
-/*Copied from i386 arch/i386/kernel/module.c */
+/* Copied from i386 arch/i386/kernel/module.c */
 void *module_alloc(unsigned long size)
 {
 	if (size == 0)
@@ -13,7 +13,9 @@ void *module_alloc(unsigned long size)
 void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
-	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
+	/*
+	 * FIXME: If module_region == mod->init_region, trim exception
+	 * table entries.
+	 */
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
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
uml-header-untangling-fix.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
uml-smp-locking-commentary.patch
uml-implement-o_append.patch
uml-remove-fakehd.patch
uml-debug_shirq-fixes.patch
uml-add-back-config_hz.patch
uml-style-fixes-in-arch-um-sys-x86_64.patch
uml-add-newlines-to-printks.patch
uml-move-register-initialization.patch
uml-remove-unused-fields-from-mm_context.patch
uml-remove-map_cb.patch
uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
uml-defconfig-tweaks.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
