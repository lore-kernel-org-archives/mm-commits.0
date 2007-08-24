From: akpm@linux-foundation.org
Subject: + uml-style-fixes-in-fp-code.patch added to -mm tree
Date: Thu, 23 Aug 2007 17:10:05 -0700
Message-ID: <200708240010.l7O0A5qi001546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933959AbXHXAKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 20:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: style fixes in FP code
has been added to the -mm tree.  Its filename is
     uml-style-fixes-in-fp-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: style fixes in FP code
From: Jeff Dike <jdike@addtoit.com>

Tidy the code affected by the floating point fixes.

A bunch of unused stuff is gone, including two sigcontext.c files,
which turned out to be entirely unneeded.

There are the usual fixes -
	whitespace and style cleanups
	copyright updates
	emacs formatting comments gone
	include cleanups
	adding severities to printks

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sysdep-i386/sigcontext.h   |   13 --
 arch/um/include/sysdep-x86_64/sigcontext.h |   28 -----
 arch/um/kernel/ptrace.c                    |    2 
 arch/um/os-Linux/sys-i386/registers.c      |   26 +++--
 arch/um/sys-i386/Makefile                  |    6 -
 arch/um/sys-i386/sigcontext.c              |   71 -------------
 arch/um/sys-x86_64/Makefile                |    6 -
 arch/um/sys-x86_64/ptrace.c                |   97 +++++++------------
 arch/um/sys-x86_64/sigcontext.c            |   39 -------
 arch/um/sys-x86_64/signal.c                |   23 ++--
 include/asm-um/elf-x86_64.h                |   12 --
 11 files changed, 76 insertions(+), 247 deletions(-)

diff -puN arch/um/include/sysdep-i386/sigcontext.h~uml-style-fixes-in-fp-code arch/um/include/sysdep-i386/sigcontext.h
--- a/arch/um/include/sysdep-i386/sigcontext.h~uml-style-fixes-in-fp-code
+++ a/arch/um/include/sysdep-i386/sigcontext.h
@@ -6,15 +6,10 @@
 #ifndef __SYS_SIGCONTEXT_I386_H
 #define __SYS_SIGCONTEXT_I386_H
 
-#include "uml-config.h"
-#include "skas.h"
 #include "sysdep/sc.h"
 
 #define IP_RESTART_SYSCALL(ip) ((ip) -= 2)
 
-#define SC_RESTART_SYSCALL(sc) IP_RESTART_SYSCALL(SC_IP(sc))
-#define SC_SET_SYSCALL_RETURN(sc, result) SC_EAX(sc) = (result)
-
 #define GET_FAULTINFO_FROM_SC(fi,sc) \
 	{ \
 		(fi).cr2 = SC_CR2(sc); \
@@ -22,18 +17,10 @@
 		(fi).trap_no = SC_TRAPNO(sc); \
 	}
 
-/* ptrace expects that, at the start of a system call, %eax contains
- * -ENOSYS, so this makes it so.
- */
-#define SC_START_SYSCALL(sc) do SC_EAX(sc) = -ENOSYS; while(0)
-
 /* This is Page Fault */
 #define SEGV_IS_FIXABLE(fi)	((fi)->trap_no == 14)
 
 /* SKAS3 has no trap_no on i386, but get_skas_faultinfo() sets it to 0. */
 #define SEGV_MAYBE_FIXABLE(fi)	((fi)->trap_no == 0 && ptrace_faultinfo)
 
-extern unsigned long *sc_sigmask(void *sc_ptr);
-extern int sc_get_fpregs(unsigned long buf, void *sc_ptr);
-
 #endif
diff -puN arch/um/include/sysdep-x86_64/sigcontext.h~uml-style-fixes-in-fp-code arch/um/include/sysdep-x86_64/sigcontext.h
--- a/arch/um/include/sysdep-x86_64/sigcontext.h~uml-style-fixes-in-fp-code
+++ a/arch/um/include/sysdep-x86_64/sigcontext.h
@@ -11,43 +11,17 @@
 
 #define IP_RESTART_SYSCALL(ip) ((ip) -= 2)
 
-#define SC_RESTART_SYSCALL(sc) IP_RESTART_SYSCALL(SC_IP(sc))
-#define SC_SET_SYSCALL_RETURN(sc, result) SC_RAX(sc) = (result)
-
-#define SC_FAULT_ADDR(sc) SC_CR2(sc)
-#define SC_FAULT_TYPE(sc) SC_ERR(sc)
-
-#define GET_FAULTINFO_FROM_SC(fi,sc) \
+#define GET_FAULTINFO_FROM_SC(fi, sc) \
 	{ \
 		(fi).cr2 = SC_CR2(sc); \
 		(fi).error_code = SC_ERR(sc); \
 		(fi).trap_no = SC_TRAPNO(sc); \
 	}
 
-/* ptrace expects that, at the start of a system call, %eax contains
- * -ENOSYS, so this makes it so.
- */
-
-#define SC_START_SYSCALL(sc) do SC_RAX(sc) = -ENOSYS; while(0)
-
 /* This is Page Fault */
 #define SEGV_IS_FIXABLE(fi)	((fi)->trap_no == 14)
 
 /* No broken SKAS API, which doesn't pass trap_no, here. */
 #define SEGV_MAYBE_FIXABLE(fi)	0
 
-extern unsigned long *sc_sigmask(void *sc_ptr);
-
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
-
diff -puN arch/um/kernel/ptrace.c~uml-style-fixes-in-fp-code arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~uml-style-fixes-in-fp-code
+++ a/arch/um/kernel/ptrace.c
@@ -171,8 +171,6 @@ long arch_ptrace(struct task_struct *chi
 		 */
 		ret = copy_to_user(p, &child->thread.arch.faultinfo,
 				   sizeof(struct ptrace_faultinfo));
-		if (ret)
-			break;
 		break;
 	}
 
diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-style-fixes-in-fp-code arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-style-fixes-in-fp-code
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -1,49 +1,55 @@
 /*
  * Copyright (C) 2004 PathScale, Inc
+ * Copyright (C) 2004 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <errno.h>
-#include <sysdep/ptrace_user.h>
+#include "kern_constants.h"
 #include "longjmp.h"
 #include "user.h"
+#include "sysdep/ptrace_user.h"
 
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
-	if(ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
+	if (ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
 		return -errno;
 	return 0;
 }
 
 int restore_fp_registers(int pid, unsigned long *fp_regs)
 {
-	if(ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
+	if (ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
 		return -errno;
 	return 0;
 }
 
 int save_fpx_registers(int pid, unsigned long *fp_regs)
 {
-	if(ptrace(PTRACE_GETFPXREGS, pid, 0, fp_regs) < 0)
+	if (ptrace(PTRACE_GETFPXREGS, pid, 0, fp_regs) < 0)
 		return -errno;
 	return 0;
 }
 
 int restore_fpx_registers(int pid, unsigned long *fp_regs)
 {
-	if(ptrace(PTRACE_SETFPXREGS, pid, 0, fp_regs) < 0)
+	if (ptrace(PTRACE_SETFPXREGS, pid, 0, fp_regs) < 0)
 		return -errno;
 	return 0;
 }
 
 unsigned long get_thread_reg(int reg, jmp_buf *buf)
 {
-	switch(reg){
-	case EIP: return buf[0]->__eip;
-	case UESP: return buf[0]->__esp;
-	case EBP: return buf[0]->__ebp;
+	switch (reg) {
+	case EIP:
+		return buf[0]->__eip;
+	case UESP:
+		return buf[0]->__esp;
+	case EBP:
+		return buf[0]->__ebp;
 	default:
-		printk("get_thread_regs - unknown register %d\n", reg);
+		printk(UM_KERN_ERR "get_thread_regs - unknown register %d\n",
+		       reg);
 		return 0;
 	}
 }
diff -puN arch/um/sys-i386/Makefile~uml-style-fixes-in-fp-code arch/um/sys-i386/Makefile
--- a/arch/um/sys-i386/Makefile~uml-style-fixes-in-fp-code
+++ a/arch/um/sys-i386/Makefile
@@ -3,14 +3,14 @@
 #
 
 obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
-	ptrace_user.o setjmp.o signal.o sigcontext.o stub.o stub_segv.o \
-	syscalls.o sysrq.o sys_call_table.o tls.o
+	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
+	sys_call_table.o tls.o
 
 subarch-obj-y = lib/bitops.o lib/semaphore.o lib/string.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
-USER_OBJS := bugs.o ptrace_user.o sigcontext.o fault.o
+USER_OBJS := bugs.o ptrace_user.o fault.o
 
 USER_OBJS += user-offsets.s
 extra-y += user-offsets.s
diff -puN arch/um/sys-i386/sigcontext.c~uml-style-fixes-in-fp-code /dev/null
--- a/arch/um/sys-i386/sigcontext.c
+++ /dev/null
@@ -1,71 +0,0 @@
-/* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <stddef.h>
-#include <string.h>
-#include <asm/ptrace.h>
-#include <asm/sigcontext.h>
-#include "sysdep/ptrace.h"
-#include "kern_util.h"
-
-void sc_to_sc(void *to_ptr, void *from_ptr)
-{
-	struct sigcontext *to = to_ptr, *from = from_ptr;
-
-	memcpy(to, from, sizeof(*to) + sizeof(struct _fpstate));
-	if(from->fpstate != NULL)
-		to->fpstate = (struct _fpstate *) (to + 1);
-}
-
-unsigned long *sc_sigmask(void *sc_ptr)
-{
-	struct sigcontext *sc = sc_ptr;
-	return &sc->oldmask;
-}
-
-int sc_get_fpregs(unsigned long buf, void *sc_ptr)
-{
-	struct sigcontext *sc = sc_ptr;
-	struct _fpstate *from = sc->fpstate, *to = (struct _fpstate *) buf;
-	int err = 0;
-
-	if(from == NULL){
-		err |= clear_user_proc(&to->cw, sizeof(to->cw));
-		err |= clear_user_proc(&to->sw, sizeof(to->sw));
-		err |= clear_user_proc(&to->tag, sizeof(to->tag));
-		err |= clear_user_proc(&to->ipoff, sizeof(to->ipoff));
-		err |= clear_user_proc(&to->cssel, sizeof(to->cssel));
-		err |= clear_user_proc(&to->dataoff, sizeof(to->dataoff));
-		err |= clear_user_proc(&to->datasel, sizeof(to->datasel));
-		err |= clear_user_proc(&to->_st, sizeof(to->_st));
-	}
-	else {
-		err |= copy_to_user_proc(&to->cw, &from->cw, sizeof(to->cw));
-		err |= copy_to_user_proc(&to->sw, &from->sw, sizeof(to->sw));
-		err |= copy_to_user_proc(&to->tag, &from->tag, 
-					 sizeof(to->tag));
-		err |= copy_to_user_proc(&to->ipoff, &from->ipoff, 
-					 sizeof(to->ipoff));
-		err |= copy_to_user_proc(&to->cssel,& from->cssel, 
-					 sizeof(to->cssel));
-		err |= copy_to_user_proc(&to->dataoff, &from->dataoff, 
-				    sizeof(to->dataoff));
-		err |= copy_to_user_proc(&to->datasel, &from->datasel, 
-				    sizeof(to->datasel));
-		err |= copy_to_user_proc(to->_st, from->_st, sizeof(to->_st));
-	}
-	return(err);
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-x86_64/Makefile~uml-style-fixes-in-fp-code arch/um/sys-x86_64/Makefile
--- a/arch/um/sys-x86_64/Makefile~uml-style-fixes-in-fp-code
+++ a/arch/um/sys-x86_64/Makefile
@@ -5,8 +5,8 @@
 #
 
 obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
-	setjmp.o sigcontext.o signal.o stub.o stub_segv.o syscalls.o \
-	syscall_table.o sysrq.o ksyms.o tls.o
+	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
+	sysrq.o ksyms.o tls.o
 
 obj-$(CONFIG_MODULES) += um_module.o
 
@@ -15,7 +15,7 @@ subarch-obj-$(CONFIG_MODULES) += kernel/
 
 ldt-y = ../sys-i386/ldt.o
 
-USER_OBJS := ptrace_user.o sigcontext.o
+USER_OBJS := ptrace_user.o
 
 USER_OBJS += user-offsets.s
 extra-y += user-offsets.s
diff -puN arch/um/sys-x86_64/ptrace.c~uml-style-fixes-in-fp-code arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~uml-style-fixes-in-fp-code
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2003 PathScale, Inc.
+ * Copyright (C) 2003 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  *
  * Licensed under the GPL
  */
@@ -12,17 +13,10 @@
 #include <asm/uaccess.h>
 #include <asm/elf.h>
 
-/* XXX x86_64 */
-unsigned long not_ss;
-unsigned long not_ds;
-unsigned long not_es;
-
-#define SC_SS(r) (not_ss)
-#define SC_DS(r) (not_ds)
-#define SC_ES(r) (not_es)
-
-/* determines which flags the user has access to. */
-/* 1 = access 0 = no access */
+/*
+ * determines which flags the user has access to.
+ * 1 = access 0 = no access
+ */
 #define FLAG_MASK 0x44dd5UL
 
 int putreg(struct task_struct *child, int regno, unsigned long value)
@@ -66,20 +60,21 @@ int putreg(struct task_struct *child, in
 
 int poke_user(struct task_struct *child, long addr, long data)
 {
-        if ((addr & 3) || addr < 0)
-                return -EIO;
+	if ((addr & 3) || addr < 0)
+		return -EIO;
 
-        if (addr < MAX_REG_OFFSET)
-                return putreg(child, addr, data);
-        else if((addr >= offsetof(struct user, u_debugreg[0])) &&
-                (addr <= offsetof(struct user, u_debugreg[7]))){
-                addr -= offsetof(struct user, u_debugreg[0]);
-                addr = addr >> 2;
-                if((addr == 4) || (addr == 5)) return -EIO;
-                child->thread.arch.debugregs[addr] = data;
-                return 0;
-        }
-        return -EIO;
+	if (addr < MAX_REG_OFFSET)
+		return putreg(child, addr, data);
+	else if ((addr >= offsetof(struct user, u_debugreg[0])) &&
+		(addr <= offsetof(struct user, u_debugreg[7]))){
+		addr -= offsetof(struct user, u_debugreg[0]);
+		addr = addr >> 2;
+		if ((addr == 4) || (addr == 5))
+			return -EIO;
+		child->thread.arch.debugregs[addr] = data;
+		return 0;
+	}
+	return -EIO;
 }
 
 unsigned long getreg(struct task_struct *child, int regno)
@@ -107,29 +102,22 @@ unsigned long getreg(struct task_struct 
 int peek_user(struct task_struct *child, long addr, long data)
 {
 	/* read the word at location addr in the USER area. */
-        unsigned long tmp;
+	unsigned long tmp;
 
-        if ((addr & 3) || addr < 0)
-                return -EIO;
+	if ((addr & 3) || addr < 0)
+		return -EIO;
 
-        tmp = 0;  /* Default return condition */
-        if(addr < MAX_REG_OFFSET){
-                tmp = getreg(child, addr);
-        }
-        else if((addr >= offsetof(struct user, u_debugreg[0])) &&
-                (addr <= offsetof(struct user, u_debugreg[7]))){
-                addr -= offsetof(struct user, u_debugreg[0]);
-                addr = addr >> 2;
-                tmp = child->thread.arch.debugregs[addr];
-        }
-        return put_user(tmp, (unsigned long *) data);
-}
-
-void arch_switch(void)
-{
-/* XXX
-	printk("arch_switch\n");
-*/
+	tmp = 0;  /* Default return condition */
+	if (addr < MAX_REG_OFFSET){
+		tmp = getreg(child, addr);
+	}
+	else if ((addr >= offsetof(struct user, u_debugreg[0])) &&
+		(addr <= offsetof(struct user, u_debugreg[7]))){
+		addr -= offsetof(struct user, u_debugreg[0]);
+		addr = addr >> 2;
+		tmp = child->thread.arch.debugregs[addr];
+	}
+	return put_user(tmp, (unsigned long *) data);
 }
 
 /* XXX Mostly copied from sys-i386 */
@@ -139,21 +127,21 @@ int is_syscall(unsigned long addr)
 	int n;
 
 	n = copy_from_user(&instr, (void __user *) addr, sizeof(instr));
-	if(n){
+	if (n){
 		/* access_process_vm() grants access to vsyscall and stub,
 		 * while copy_from_user doesn't. Maybe access_process_vm is
 		 * slow, but that doesn't matter, since it will be called only
 		 * in case of singlestepping, if copy_from_user failed.
 		 */
 		n = access_process_vm(current, addr, &instr, sizeof(instr), 0);
-		if(n != sizeof(instr)) {
+		if (n != sizeof(instr)) {
 			printk("is_syscall : failed to read instruction from "
 			       "0x%lx\n", addr);
-			return(1);
+			return 1;
 		}
 	}
 	/* sysenter */
-	return(instr == 0x050f);
+	return instr == 0x050f;
 }
 
 int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
@@ -204,14 +192,3 @@ long subarch_ptrace(struct task_struct *
 
 	return ret;
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-x86_64/sigcontext.c~uml-style-fixes-in-fp-code /dev/null
--- a/arch/um/sys-x86_64/sigcontext.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#include <stdio.h>
-#include <string.h>
-#include <signal.h>
-#include "user.h"
-
-void sc_to_sc(void *to_ptr, void *from_ptr)
-{
-        struct sigcontext *to = to_ptr, *from = from_ptr;
-        int size = sizeof(*to); /* + sizeof(struct _fpstate); */
-
-        memcpy(to, from, size);
-        if(from->fpstate != NULL)
-		to->fpstate = (struct _fpstate *) (to + 1);
-
-	to->fpstate = NULL;
-}
-
-unsigned long *sc_sigmask(void *sc_ptr)
-{
-	struct sigcontext *sc = sc_ptr;
-
-	return(&sc->oldmask);
-}
-
-/* Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-x86_64/signal.c~uml-style-fixes-in-fp-code arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-style-fixes-in-fp-code
+++ a/arch/um/sys-x86_64/signal.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2003 PathScale, Inc.
+ * Copyright (C) 2003 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -110,7 +111,8 @@ static int copy_sc_to_user(struct sigcon
 	err |= PUTREG(regs, RDI, to, rdi);
 	err |= PUTREG(regs, RSI, to, rsi);
 	err |= PUTREG(regs, RBP, to, rbp);
-	/* Must use orignal RSP, which is passed in, rather than what's in
+	/*
+	 * Must use orignal RSP, which is passed in, rather than what's in
 	 * the pt_regs, because that's already been updated to point at the
 	 * signal frame.
 	 */
@@ -152,7 +154,7 @@ static int copy_sc_to_user(struct sigcon
 	if (copy_to_user(to_fp, &fp, sizeof(struct user_i387_struct)))
 		return 1;
 
-	return(err);
+	return err;
 }
 
 struct rt_sigframe
@@ -188,7 +190,8 @@ int setup_signal_stack_si(unsigned long 
 			goto out;
 	}
 
-	/* Update SP now because the page fault handler refuses to extend
+	/*
+	 * Update SP now because the page fault handler refuses to extend
 	 * the stack if the faulting address is too far below the current
 	 * SP, which frame now certainly is.  If there's an error, the original
 	 * value is restored on the way out.
@@ -216,8 +219,10 @@ int setup_signal_stack_si(unsigned long 
 		err |= __copy_to_user(&frame->uc.uc_sigmask, set,
 				      sizeof(*set));
 
-	/* Set up to return from userspace.  If provided, use a stub
-	   already in userspace.  */
+	/*
+	 * Set up to return from userspace.  If provided, use a stub
+	 * already in userspace.
+	 */
 	/* x86-64 should always use SA_RESTORER. */
 	if (ka->sa.sa_flags & SA_RESTORER)
 		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
@@ -239,8 +244,10 @@ int setup_signal_stack_si(unsigned long 
 	/* In case the signal handler was declared without prototypes */
 	PT_REGS_RAX(regs) = 0;
 
-	/* This also works for non SA_SIGINFO handlers because they expect the
-	   next argument after the signal number on the stack. */
+	/*
+	 * This also works for non SA_SIGINFO handlers because they expect the
+	 * next argument after the signal number on the stack.
+	 */
 	PT_REGS_RSI(regs) = (unsigned long) &frame->info;
 	PT_REGS_RDX(regs) = (unsigned long) &frame->uc;
 	PT_REGS_RIP(regs) = (unsigned long) ka->sa.sa_handler;
@@ -276,7 +283,7 @@ long sys_rt_sigreturn(struct pt_regs *re
 
 	/* Avoid ERESTART handling */
 	PT_REGS_SYSCALL_NR(&current->thread.regs) = -1;
-	return(PT_REGS_SYSCALL_RET(&current->thread.regs));
+	return PT_REGS_SYSCALL_RET(&current->thread.regs);
 
  segfault:
 	force_sig(SIGSEGV, current);
diff -puN include/asm-um/elf-x86_64.h~uml-style-fixes-in-fp-code include/asm-um/elf-x86_64.h
--- a/include/asm-um/elf-x86_64.h~uml-style-fixes-in-fp-code
+++ a/include/asm-um/elf-x86_64.h
@@ -1,5 +1,6 @@
 /*
  * Copyright 2003 PathScale, Inc.
+ * Copyright (C) 2003 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  *
  * Licensed under the GPL
  */
@@ -122,14 +123,3 @@ extern long elf_aux_hwcap;
 #define SET_PERSONALITY(ex, ibcs2) do ; while(0)
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
uml-fix-previous-request-size-limit-fix.patch
uml-fix-linker-script-alignment-bugs.patch
uml-fix-x86_64-core-dump-crash.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-use-64-bits-for-block-size-on-x86_64.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
