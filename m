From: akpm@linux-foundation.org
Subject: + uml-kernel-segfaults-should-dump-proper-registers.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:44:21 -0700
Message-ID: <200704070044.l370iL8v024019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793AbXDGAog (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: kernel segfaults should dump proper registers
has been added to the -mm tree.  Its filename is
     uml-kernel-segfaults-should-dump-proper-registers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: kernel segfaults should dump proper registers
From: Jeff Dike <jdike@addtoit.com>

If there's a segfault inside the kernel, we want a dump of the registers at
the point of the segfault, not the registers at the point of calling panic or
the last userspace registers.

sig_handler_common_skas now uses a static register set in the case of a
SIGSEGV to avoid messing up the process registers if the segfault turns out to
be non-fatal.

The architecture sigcontext-to-pt_regs copying code was repurposed to copy
data out of the SEGV stack frame.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/common-offsets.h |    2 +
 arch/um/include/kern_util.h      |    2 +
 arch/um/kernel/trap.c            |   10 ++++---
 arch/um/os-Linux/skas/trap.c     |   15 +++++++++-
 arch/um/sys-i386/signal.c        |   41 ++++++++++++++++-------------
 arch/um/sys-x86_64/signal.c      |   30 +++++++++++++++++++++
 6 files changed, 78 insertions(+), 22 deletions(-)

diff -puN arch/um/include/common-offsets.h~uml-kernel-segfaults-should-dump-proper-registers arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-kernel-segfaults-should-dump-proper-registers
+++ a/arch/um/include/common-offsets.h
@@ -24,5 +24,7 @@ DEFINE(UM_ELF_CLASS, ELF_CLASS);
 DEFINE(UM_ELFCLASS32, ELFCLASS32);
 DEFINE(UM_ELFCLASS64, ELFCLASS64);
 
+DEFINE(UM_NR_CPUS, NR_CPUS);
+
 /* For crypto assembler code. */
 DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
diff -puN arch/um/include/kern_util.h~uml-kernel-segfaults-should-dump-proper-registers arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-kernel-segfaults-should-dump-proper-registers
+++ a/arch/um/include/kern_util.h
@@ -114,4 +114,6 @@ extern void time_init_kern(void);
 extern int __cant_sleep(void);
 extern void sigio_handler(int sig, union uml_pt_regs *regs);
 
+extern void copy_sc(union uml_pt_regs *regs, void *from);
+
 #endif
diff -puN arch/um/kernel/trap.c~uml-kernel-segfaults-should-dump-proper-registers arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-kernel-segfaults-should-dump-proper-registers
+++ a/arch/um/kernel/trap.c
@@ -170,8 +170,10 @@ unsigned long segv(struct faultinfo fi, 
 		flush_tlb_kernel_vm();
 		return 0;
 	}
-	else if(current->mm == NULL)
-		panic("Segfault with no mm");
+	else if(current->mm == NULL) {
+		show_regs(container_of(regs, struct pt_regs, regs));
+  		panic("Segfault with no mm");
+	}
 
 	if (SEGV_IS_FIXABLE(&fi) || SEGV_MAYBE_FIXABLE(&fi))
 		err = handle_page_fault(address, ip, is_write, is_user, &si.si_code);
@@ -194,9 +196,11 @@ unsigned long segv(struct faultinfo fi, 
 	else if(!is_user && arch_fixup(ip, regs))
 		return 0;
 
-	if(!is_user)
+	if(!is_user) {
+		show_regs(container_of(regs, struct pt_regs, regs));
 		panic("Kernel mode fault at addr 0x%lx, ip 0x%lx",
 		      address, ip);
+	}
 
 	if (err == -EACCES) {
 		si.si_signo = SIGBUS;
diff -puN arch/um/os-Linux/skas/trap.c~uml-kernel-segfaults-should-dump-proper-registers arch/um/os-Linux/skas/trap.c
--- a/arch/um/os-Linux/skas/trap.c~uml-kernel-segfaults-should-dump-proper-registers
+++ a/arch/um/os-Linux/skas/trap.c
@@ -15,6 +15,8 @@
 #include "sysdep/ptrace_user.h"
 #include "os.h"
 
+static union uml_pt_regs ksig_regs[UM_NR_CPUS];
+
 void sig_handler_common_skas(int sig, void *sc_ptr)
 {
 	struct sigcontext *sc = sc_ptr;
@@ -27,10 +29,19 @@ void sig_handler_common_skas(int sig, vo
 	 * the process will die.
 	 * XXX Figure out why this is better than SA_NODEFER
 	 */
-	if(sig == SIGSEGV)
+	if(sig == SIGSEGV) {
 		change_sig(SIGSEGV, 1);
+		/* For segfaults, we want the data from the
+		 * sigcontext.  In this case, we don't want to mangle
+		 * the process registers, so use a static set of
+		 * registers.  For other signals, the process
+		 * registers are OK.
+		 */
+		r = &ksig_regs[cpu()];
+		copy_sc(r, sc_ptr);
+	}
+	else r = TASK_REGS(get_current());
 
-	r = TASK_REGS(get_current());
 	save_user = r->skas.is_user;
 	r->skas.is_user = 0;
 	if ( sig == SIGFPE || sig == SIGSEGV ||
diff -puN arch/um/sys-i386/signal.c~uml-kernel-segfaults-should-dump-proper-registers arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-kernel-segfaults-should-dump-proper-registers
+++ a/arch/um/sys-i386/signal.c
@@ -18,6 +18,28 @@
 
 #include "skas.h"
 
+void copy_sc(union uml_pt_regs *regs, void *from)
+{
+	struct sigcontext *sc = from;
+
+	REGS_GS(regs->skas.regs) = sc->gs;
+	REGS_FS(regs->skas.regs) = sc->fs;
+	REGS_ES(regs->skas.regs) = sc->es;
+	REGS_DS(regs->skas.regs) = sc->ds;
+	REGS_EDI(regs->skas.regs) = sc->edi;
+	REGS_ESI(regs->skas.regs) = sc->esi;
+	REGS_EBP(regs->skas.regs) = sc->ebp;
+	REGS_SP(regs->skas.regs) = sc->esp;
+	REGS_EBX(regs->skas.regs) = sc->ebx;
+	REGS_EDX(regs->skas.regs) = sc->edx;
+	REGS_ECX(regs->skas.regs) = sc->ecx;
+	REGS_EAX(regs->skas.regs) = sc->eax;
+	REGS_IP(regs->skas.regs) = sc->eip;
+	REGS_CS(regs->skas.regs) = sc->cs;
+	REGS_EFLAGS(regs->skas.regs) = sc->eflags;
+	REGS_SS(regs->skas.regs) = sc->ss;
+}
+
 static int copy_sc_from_user_skas(struct pt_regs *regs,
 				  struct sigcontext __user *from)
 {
@@ -30,25 +52,10 @@ static int copy_sc_from_user_skas(struct
 	if(err)
 		return err;
 
-	REGS_GS(regs->regs.skas.regs) = sc.gs;
-	REGS_FS(regs->regs.skas.regs) = sc.fs;
-	REGS_ES(regs->regs.skas.regs) = sc.es;
-	REGS_DS(regs->regs.skas.regs) = sc.ds;
-	REGS_EDI(regs->regs.skas.regs) = sc.edi;
-	REGS_ESI(regs->regs.skas.regs) = sc.esi;
-	REGS_EBP(regs->regs.skas.regs) = sc.ebp;
-	REGS_SP(regs->regs.skas.regs) = sc.esp;
-	REGS_EBX(regs->regs.skas.regs) = sc.ebx;
-	REGS_EDX(regs->regs.skas.regs) = sc.edx;
-	REGS_ECX(regs->regs.skas.regs) = sc.ecx;
-	REGS_EAX(regs->regs.skas.regs) = sc.eax;
-	REGS_IP(regs->regs.skas.regs) = sc.eip;
-	REGS_CS(regs->regs.skas.regs) = sc.cs;
-	REGS_EFLAGS(regs->regs.skas.regs) = sc.eflags;
-	REGS_SS(regs->regs.skas.regs) = sc.ss;
+	copy_sc(&regs->regs, &sc);
 
 	err = restore_fp_registers(userspace_pid[0], fpregs);
-	if(err < 0){
+	if(err < 0) {
 	  	printk("copy_sc_from_user_skas - PTRACE_SETFPREGS failed, "
 		       "errno = %d\n", -err);
 		return err;
diff -puN arch/um/sys-x86_64/signal.c~uml-kernel-segfaults-should-dump-proper-registers arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-kernel-segfaults-should-dump-proper-registers
+++ a/arch/um/sys-x86_64/signal.c
@@ -20,6 +20,36 @@
 
 #include "skas.h"
 
+void copy_sc(union uml_pt_regs *regs, void *from)
+{
+	struct sigcontext *sc = from;
+
+#define GETREG(regs, regno, sc, regname) \
+       (regs)->skas.regs[(regno) / sizeof(unsigned long)] = (sc)->regname
+
+       GETREG(regs, R8, sc, r8);
+       GETREG(regs, R9, sc, r9);
+       GETREG(regs, R10, sc, r10);
+       GETREG(regs, R11, sc, r11);
+       GETREG(regs, R12, sc, r12);
+       GETREG(regs, R13, sc, r13);
+       GETREG(regs, R14, sc, r14);
+       GETREG(regs, R15, sc, r15);
+       GETREG(regs, RDI, sc, rdi);
+       GETREG(regs, RSI, sc, rsi);
+       GETREG(regs, RBP, sc, rbp);
+       GETREG(regs, RBX, sc, rbx);
+       GETREG(regs, RDX, sc, rdx);
+       GETREG(regs, RAX, sc, rax);
+       GETREG(regs, RCX, sc, rcx);
+       GETREG(regs, RSP, sc, rsp);
+       GETREG(regs, RIP, sc, rip);
+       GETREG(regs, EFLAGS, sc, eflags);
+       GETREG(regs, CS, sc, cs);
+
+#undef GETREG
+}
+
 static int copy_sc_from_user_skas(struct pt_regs *regs,
                                  struct sigcontext __user *from)
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
