From: akpm@linux-foundation.org
Subject: + aout-suppress-aout-library-support-if-config_arch_supports_aout.patch added to -mm tree
Date: Thu, 29 Nov 2007 17:45:25 -0800
Message-ID: <200711300145.lAU1jPcH017727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763614AbXK3BqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 20:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org


The patch titled
     aout: suppress A.OUT library support if !CONFIG_ARCH_SUPPORTS_AOUT
has been added to the -mm tree.  Its filename is
     aout-suppress-aout-library-support-if-config_arch_supports_aout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aout: suppress A.OUT library support if !CONFIG_ARCH_SUPPORTS_AOUT
From: David Howells <dhowells@redhat.com>

Suppress A.OUT library support if CONFIG_ARCH_SUPPORTS_AOUT is not set.

Not all architectures support the A.OUT binfmt, so the ELF binfmt should not
be permitted to go looking for A.OUT libraries to load in such a case.  Not
only that, but under such conditions A.OUT core dumps are not produced either.

To make this work, this patch also does the following:

 (1) Makes the existence of the contents of linux/a.out.h contingent on
     CONFIG_ARCH_SUPPORTS_AOUT.

 (2) Renames dump_thread() to aout_dump_thread() as it's only called by A.OUT
     core dumping code.

 (3) Moves aout_dump_thread() into asm/a.out-core.h and makes it inline.  This
     is then included only where needed.  This means that this bit of arch
     code will be stored in the appropriate A.OUT binfmt module rather than
     the core kernel.

 (4) Drops A.OUT support for Blackfin (according to Mike Frysinger it's not
     needed) and FRV.

This patch depends on the previous patch to move STACK_TOP[_MAX] out of
asm/a.out.h and into asm/processor.h as they're required whether or not A.OUT
format is available.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/process.c         |   62 -------------------
 arch/arm/kernel/process.c           |   29 ---------
 arch/m68k/kernel/process.c          |   47 ---------------
 arch/sparc/kernel/process.c         |   32 ----------
 arch/sparc/kernel/sparc_ksyms.c     |    2 
 arch/sparc64/kernel/binfmt_aout32.c |    3 
 arch/sparc64/kernel/process.c       |   11 ---
 arch/um/kernel/ksyms.c              |    1 
 arch/um/kernel/process.c            |   42 +++++++++++++
 arch/x86/kernel/process_32.c        |   43 -------------
 fs/Kconfig.binfmt                   |    3 
 fs/binfmt_aout.c                    |    3 
 fs/binfmt_elf.c                     |   34 ++++++++--
 fs/exec.c                           |    2 
 include/asm-alpha/a.out-core.h      |   81 ++++++++++++++++++++++++++
 include/asm-arm/a.out-core.h        |   50 ++++++++++++++++
 include/asm-frv/a.out.h             |    5 -
 include/asm-generic/Kbuild.asm      |    2 
 include/asm-m68k/a.out-core.h       |   69 ++++++++++++++++++++++
 include/asm-sparc/a.out-core.h      |   55 +++++++++++++++++
 include/asm-sparc64/a.out-core.h    |   31 +++++++++
 include/asm-um/a.out-core.h         |   27 ++++++++
 include/asm-x86/a.out-core.h        |   67 +++++++++++++++++++++
 include/linux/a.out.h               |   12 +++
 include/linux/kernel.h              |    2 
 25 files changed, 467 insertions(+), 248 deletions(-)

diff -puN arch/alpha/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/alpha/kernel/process.c
@@ -318,68 +318,6 @@ copy_thread(int nr, unsigned long clone_
 }
 
 /*
- * Fill in the user structure for an ECOFF core dump.
- */
-void
-dump_thread(struct pt_regs * pt, struct user * dump)
-{
-	/* switch stack follows right below pt_regs: */
-	struct switch_stack * sw = ((struct switch_stack *) pt) - 1;
-
-	dump->magic = CMAGIC;
-	dump->start_code  = current->mm->start_code;
-	dump->start_data  = current->mm->start_data;
-	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((current->mm->end_code - dump->start_code)
-			 >> PAGE_SHIFT);
-	dump->u_dsize = ((current->mm->brk + PAGE_SIZE-1 - dump->start_data)
-			 >> PAGE_SHIFT);
-	dump->u_ssize = (current->mm->start_stack - dump->start_stack
-			 + PAGE_SIZE-1) >> PAGE_SHIFT;
-
-	/*
-	 * We store the registers in an order/format that is
-	 * compatible with DEC Unix/OSF/1 as this makes life easier
-	 * for gdb.
-	 */
-	dump->regs[EF_V0]  = pt->r0;
-	dump->regs[EF_T0]  = pt->r1;
-	dump->regs[EF_T1]  = pt->r2;
-	dump->regs[EF_T2]  = pt->r3;
-	dump->regs[EF_T3]  = pt->r4;
-	dump->regs[EF_T4]  = pt->r5;
-	dump->regs[EF_T5]  = pt->r6;
-	dump->regs[EF_T6]  = pt->r7;
-	dump->regs[EF_T7]  = pt->r8;
-	dump->regs[EF_S0]  = sw->r9;
-	dump->regs[EF_S1]  = sw->r10;
-	dump->regs[EF_S2]  = sw->r11;
-	dump->regs[EF_S3]  = sw->r12;
-	dump->regs[EF_S4]  = sw->r13;
-	dump->regs[EF_S5]  = sw->r14;
-	dump->regs[EF_S6]  = sw->r15;
-	dump->regs[EF_A3]  = pt->r19;
-	dump->regs[EF_A4]  = pt->r20;
-	dump->regs[EF_A5]  = pt->r21;
-	dump->regs[EF_T8]  = pt->r22;
-	dump->regs[EF_T9]  = pt->r23;
-	dump->regs[EF_T10] = pt->r24;
-	dump->regs[EF_T11] = pt->r25;
-	dump->regs[EF_RA]  = pt->r26;
-	dump->regs[EF_T12] = pt->r27;
-	dump->regs[EF_AT]  = pt->r28;
-	dump->regs[EF_SP]  = rdusp();
-	dump->regs[EF_PS]  = pt->ps;
-	dump->regs[EF_PC]  = pt->pc;
-	dump->regs[EF_GP]  = pt->gp;
-	dump->regs[EF_A0]  = pt->r16;
-	dump->regs[EF_A1]  = pt->r17;
-	dump->regs[EF_A2]  = pt->r18;
-	memcpy((char *)dump->regs + EF_SIZE, sw->fp, 32 * 8);
-}
-EXPORT_SYMBOL(dump_thread);
-
-/*
  * Fill in the user structure for a ELF core dump.
  */
 void
diff -puN arch/arm/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/arm/kernel/process.c
@@ -368,35 +368,6 @@ int dump_fpu (struct pt_regs *regs, stru
 EXPORT_SYMBOL(dump_fpu);
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	struct task_struct *tsk = current;
-
-	dump->magic = CMAGIC;
-	dump->start_code = tsk->mm->start_code;
-	dump->start_stack = regs->ARM_sp & ~(PAGE_SIZE - 1);
-
-	dump->u_tsize = (tsk->mm->end_code - tsk->mm->start_code) >> PAGE_SHIFT;
-	dump->u_dsize = (tsk->mm->brk - tsk->mm->start_data + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	dump->u_ssize = 0;
-
-	dump->u_debugreg[0] = tsk->thread.debug.bp[0].address;
-	dump->u_debugreg[1] = tsk->thread.debug.bp[1].address;
-	dump->u_debugreg[2] = tsk->thread.debug.bp[0].insn.arm;
-	dump->u_debugreg[3] = tsk->thread.debug.bp[1].insn.arm;
-	dump->u_debugreg[4] = tsk->thread.debug.nsaved;
-
-	if (dump->start_stack < 0x04000000)
-		dump->u_ssize = (0x04000000 - dump->start_stack) >> PAGE_SHIFT;
-
-	dump->regs = *regs;
-	dump->u_fpvalid = dump_fpu (regs, &dump->u_fp);
-}
-EXPORT_SYMBOL(dump_thread);
-
-/*
  * Shuffle the argument into the correct register before calling the
  * thread function.  r1 is the thread argument, r2 is the pointer to
  * the thread function, and r3 points to the exit function.
diff -puN arch/m68k/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/m68k/kernel/process.c
--- a/arch/m68k/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/m68k/kernel/process.c
@@ -316,53 +316,6 @@ int dump_fpu (struct pt_regs *regs, stru
 EXPORT_SYMBOL(dump_fpu);
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	struct switch_stack *sw;
-
-/* changed the size calculations - should hopefully work better. lbt */
-	dump->magic = CMAGIC;
-	dump->start_code = 0;
-	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long) (current->mm->brk +
-					  (PAGE_SIZE-1))) >> PAGE_SHIFT;
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_ssize = 0;
-
-	if (dump->start_stack < TASK_SIZE)
-		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
-
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
-	sw = ((struct switch_stack *)regs) - 1;
-	dump->regs.d1 = regs->d1;
-	dump->regs.d2 = regs->d2;
-	dump->regs.d3 = regs->d3;
-	dump->regs.d4 = regs->d4;
-	dump->regs.d5 = regs->d5;
-	dump->regs.d6 = sw->d6;
-	dump->regs.d7 = sw->d7;
-	dump->regs.a0 = regs->a0;
-	dump->regs.a1 = regs->a1;
-	dump->regs.a2 = regs->a2;
-	dump->regs.a3 = sw->a3;
-	dump->regs.a4 = sw->a4;
-	dump->regs.a5 = sw->a5;
-	dump->regs.a6 = sw->a6;
-	dump->regs.d0 = regs->d0;
-	dump->regs.orig_d0 = regs->orig_d0;
-	dump->regs.stkadj = regs->stkadj;
-	dump->regs.sr = regs->sr;
-	dump->regs.pc = regs->pc;
-	dump->regs.fmtvec = (regs->format << 12) | regs->vector;
-	/* dump floating point stuff */
-	dump->u_fpvalid = dump_fpu (regs, &dump->m68kfp);
-}
-EXPORT_SYMBOL(dump_thread);
-
-/*
  * sys_execve() executes a new program.
  */
 asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __user * __user *envp)
diff -puN arch/sparc/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/sparc/kernel/process.c
--- a/arch/sparc/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/sparc/kernel/process.c
@@ -567,38 +567,6 @@ int copy_thread(int nr, unsigned long cl
 }
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	unsigned long first_stack_page;
-
-	dump->magic = SUNOS_CORE_MAGIC;
-	dump->len = sizeof(struct user);
-	dump->regs.psr = regs->psr;
-	dump->regs.pc = regs->pc;
-	dump->regs.npc = regs->npc;
-	dump->regs.y = regs->y;
-	/* fuck me plenty */
-	memcpy(&dump->regs.regs[0], &regs->u_regs[1], (sizeof(unsigned long) * 15));
-	dump->uexec = current->thread.core_exec;
-	dump->u_tsize = (((unsigned long) current->mm->end_code) -
-		((unsigned long) current->mm->start_code)) & ~(PAGE_SIZE - 1);
-	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1)));
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_dsize &= ~(PAGE_SIZE - 1);
-	first_stack_page = (regs->u_regs[UREG_FP] & ~(PAGE_SIZE - 1));
-	dump->u_ssize = (TASK_SIZE - first_stack_page) & ~(PAGE_SIZE - 1);
-	memcpy(&dump->fpu.fpstatus.fregs.regs[0], &current->thread.float_regs[0], (sizeof(unsigned long) * 32));
-	dump->fpu.fpstatus.fsr = current->thread.fsr;
-	dump->fpu.fpstatus.flags = dump->fpu.fpstatus.extra = 0;
-	dump->fpu.fpstatus.fpq_count = current->thread.fpqdepth;
-	memcpy(&dump->fpu.fpstatus.fpq[0], &current->thread.fpqueue[0],
-	       ((sizeof(unsigned long) * 2) * 16));
-	dump->sigcode = 0;
-}
-
-/*
  * fill in the fpu structure for a core dump.
  */
 int dump_fpu (struct pt_regs * regs, elf_fpregset_t * fpregs)
diff -puN arch/sparc/kernel/sparc_ksyms.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/sparc/kernel/sparc_ksyms.c
--- a/arch/sparc/kernel/sparc_ksyms.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/sparc/kernel/sparc_ksyms.c
@@ -214,8 +214,6 @@ EXPORT_SYMBOL(kunmap_atomic);
 EXPORT_SYMBOL(svr4_setcontext);
 EXPORT_SYMBOL(svr4_getcontext);
 
-EXPORT_SYMBOL(dump_thread);
-
 /* prom symbols */
 EXPORT_SYMBOL(idprom);
 EXPORT_SYMBOL(prom_root_node);
diff -puN arch/sparc64/kernel/binfmt_aout32.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/sparc64/kernel/binfmt_aout32.c
--- a/arch/sparc64/kernel/binfmt_aout32.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/sparc64/kernel/binfmt_aout32.c
@@ -32,6 +32,7 @@
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
+#include <asm/a.out-core.h>
 
 static int load_aout32_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout32_library(struct file*);
@@ -101,7 +102,7 @@ static int aout32_core_dump(long signr, 
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.signal = signr;
-	dump_thread(regs, &dump);
+	aout_dump_thread(regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
diff -puN arch/sparc64/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/sparc64/kernel/process.c
--- a/arch/sparc64/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/sparc64/kernel/process.c
@@ -725,17 +725,6 @@ pid_t kernel_thread(int (*fn)(void *), v
 	return retval;
 }
 
-/*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	/* Only should be used for SunOS and ancient a.out
-	 * SparcLinux binaries...  Not worth implementing.
-	 */
-	memset(dump, 0, sizeof(struct user));
-}
-
 typedef struct {
 	union {
 		unsigned int	pr_regs[32];
diff -puN arch/um/kernel/ksyms.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/um/kernel/ksyms.c
@@ -61,7 +61,6 @@ EXPORT_SYMBOL(os_accept_connection);
 EXPORT_SYMBOL(os_rcv_fd);
 EXPORT_SYMBOL(run_helper);
 EXPORT_SYMBOL(start_thread);
-EXPORT_SYMBOL(dump_thread);
 
 #ifdef CONFIG_SMP
 
diff -puN arch/um/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/um/kernel/process.c
@@ -4,6 +4,7 @@
  * Licensed under the GPL
  */
 
+#include "linux/module.h"
 #include "linux/stddef.h"
 #include "linux/err.h"
 #include "linux/hardirq.h"
@@ -255,8 +256,47 @@ void cpu_idle(void)
 	default_idle();
 }
 
-void dump_thread(struct pt_regs *regs, struct user *u)
+void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
+		      pte_t *pte_out)
 {
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	pte_t ptent;
+
+	if (task->mm == NULL)
+		return ERR_PTR(-EINVAL);
+	pgd = pgd_offset(task->mm, addr);
+	if (!pgd_present(*pgd))
+		return ERR_PTR(-EINVAL);
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		return ERR_PTR(-EINVAL);
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		return ERR_PTR(-EINVAL);
+
+	pte = pte_offset_kernel(pmd, addr);
+	ptent = *pte;
+	if (!pte_present(ptent))
+		return ERR_PTR(-EINVAL);
+
+	if (pte_out != NULL)
+		*pte_out = ptent;
+	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
+}
+
+char *current_cmd(void)
+{
+#if defined(CONFIG_SMP) || defined(CONFIG_HIGHMEM)
+	return "(Unknown)";
+#else
+	void *addr = um_virt_to_phys(current, current->mm->arg_start, NULL);
+	return IS_ERR(addr) ? "(Unknown)": __va((unsigned long) addr);
+#endif
 }
 
 int __cant_sleep(void) {
diff -puN arch/x86/kernel/process_32.c~aout-suppress-aout-library-support-if-config_arch_supports_aout arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/arch/x86/kernel/process_32.c
@@ -497,49 +497,6 @@ int copy_thread(int nr, unsigned long cl
 	return err;
 }
 
-/*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	int i;
-
-/* changed the size calculations - should hopefully work better. lbt */
-	dump->magic = CMAGIC;
-	dump->start_code = 0;
-	dump->start_stack = regs->esp & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_ssize = 0;
-	for (i = 0; i < 8; i++)
-		dump->u_debugreg[i] = current->thread.debugreg[i];  
-
-	if (dump->start_stack < TASK_SIZE)
-		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
-
-	dump->regs.ebx = regs->ebx;
-	dump->regs.ecx = regs->ecx;
-	dump->regs.edx = regs->edx;
-	dump->regs.esi = regs->esi;
-	dump->regs.edi = regs->edi;
-	dump->regs.ebp = regs->ebp;
-	dump->regs.eax = regs->eax;
-	dump->regs.ds = regs->xds;
-	dump->regs.es = regs->xes;
-	dump->regs.fs = regs->xfs;
-	savesegment(gs,dump->regs.gs);
-	dump->regs.orig_eax = regs->orig_eax;
-	dump->regs.eip = regs->eip;
-	dump->regs.cs = regs->xcs;
-	dump->regs.eflags = regs->eflags;
-	dump->regs.esp = regs->esp;
-	dump->regs.ss = regs->xss;
-
-	dump->u_fpvalid = dump_fpu (regs, &dump->i387);
-}
-EXPORT_SYMBOL(dump_thread);
-
 /* 
  * Capture the user space registers if the task is not running (in user space)
  */
diff -puN fs/Kconfig.binfmt~aout-suppress-aout-library-support-if-config_arch_supports_aout fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/fs/Kconfig.binfmt
@@ -57,7 +57,8 @@ config BINFMT_SHARED_FLAT
 
 config BINFMT_AOUT
 	tristate "Kernel support for a.out and ECOFF binaries"
-	depends on X86_32 || ALPHA || ARM || M68K || SPARC32
+	depends on ARCH_SUPPORTS_AOUT && \
+		(X86_32 || ALPHA || ARM || M68K || SPARC32)
 	---help---
 	  A.out (Assembler.OUTput) is a set of formats for libraries and
 	  executables used in the earliest versions of UNIX.  Linux used
diff -puN fs/binfmt_aout.c~aout-suppress-aout-library-support-if-config_arch_supports_aout fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/fs/binfmt_aout.c
@@ -28,6 +28,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
+#include <asm/a.out-core.h>
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
@@ -118,7 +119,7 @@ static int aout_core_dump(long signr, st
 	dump.u_ar0 = offsetof(struct user, regs);
 #endif
 	dump.signal = signr;
-	dump_thread(regs, &dump);
+	aout_dump_thread(regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
diff -puN fs/binfmt_elf.c~aout-suppress-aout-library-support-if-config_arch_supports_aout fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/fs/binfmt_elf.c
@@ -513,6 +513,7 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_AOUT
 static unsigned long load_aout_interp(struct exec *interp_ex,
 		struct file *interpreter)
 {
@@ -558,6 +559,14 @@ static unsigned long load_aout_interp(st
 out:
 	return elf_entry;
 }
+#else
+/* dummy extern - the function should never be called if !CONFIG_AOUT_BINFMT */
+static inline unsigned long load_aout_interp(struct exec *interp_ex,
+					     struct file *interpreter)
+{
+	return -ELIBACC;
+}
+#endif
 
 /*
  * These are the functions used to load ELF style executables and shared
@@ -565,9 +574,15 @@ out:
  */
 
 #define INTERPRETER_NONE 0
-#define INTERPRETER_AOUT 1
 #define INTERPRETER_ELF 2
 
+#ifdef CONFIG_ARCH_SUPPORTS_AOUT
+#define INTERPRETER_AOUT 1
+#define IS_AOUT_INTERP(x) ((x) == INTERPRETER_AOUT)
+#else
+#define IS_AOUT_INTERP(x) (0)
+#endif
+
 #ifndef STACK_RND_MASK
 #define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
@@ -784,6 +799,7 @@ static int load_elf_binary(struct linux_
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		static int warn;
+#ifdef CONFIG_ARCH_SUPPORTS_AOUT
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -791,11 +807,13 @@ static int load_elf_binary(struct linux_
 		    (N_MAGIC(loc->interp_ex) != ZMAGIC) &&
 		    (N_MAGIC(loc->interp_ex) != QMAGIC))
 			interpreter_type = INTERPRETER_ELF;
-
+#else
+		interpreter_type = INTERPRETER_ELF;
+#endif
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			interpreter_type &= ~INTERPRETER_ELF;
 
-		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
+		if (IS_AOUT_INTERP(interpreter_type) && warn < 10) {
 			printk(KERN_WARNING "a.out ELF interpreter %s is "
 				"deprecated and will not be supported "
 				"after Linux 2.6.25\n", elf_interpreter);
@@ -824,7 +842,7 @@ static int load_elf_binary(struct linux_
 
 	/* OK, we are done with that, now set up the arg stuff,
 	   and then start this sucker up */
-	if ((!bprm->sh_bang) && (interpreter_type == INTERPRETER_AOUT)) {
+	if (IS_AOUT_INTERP(interpreter_type) && !bprm->sh_bang) {
 		char *passed_p = passed_fileno;
 		sprintf(passed_fileno, "%d", elf_exec_fileno);
 
@@ -1013,7 +1031,7 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT) {
+		if (IS_AOUT_INTERP(interpreter_type)) {
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
 		} else {
@@ -1054,7 +1072,7 @@ static int load_elf_binary(struct linux_
 
 	kfree(elf_phdata);
 
-	if (interpreter_type != INTERPRETER_AOUT)
+	if (!IS_AOUT_INTERP(interpreter_type))
 		sys_close(elf_exec_fileno);
 
 	set_binfmt(&elf_format);
@@ -1070,14 +1088,14 @@ static int load_elf_binary(struct linux_
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	retval = create_elf_tables(bprm, &loc->elf_ex,
-			  (interpreter_type == INTERPRETER_AOUT),
+			  IS_AOUT_INTERP(interpreter_type),
 			  load_addr, interp_load_addr);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
 	/* N.B. passed_fileno might not be initialized? */
-	if (interpreter_type == INTERPRETER_AOUT)
+	if (IS_AOUT_INTERP(interpreter_type))
 		current->mm->arg_start += strlen(passed_fileno) + 1;
 	current->mm->end_code = end_code;
 	current->mm->start_code = start_code;
diff -puN fs/exec.c~aout-suppress-aout-library-support-if-config_arch_supports_aout fs/exec.c
--- a/fs/exec.c~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/fs/exec.c
@@ -1189,7 +1189,7 @@ int search_binary_handler(struct linux_b
 {
 	int try,retval;
 	struct linux_binfmt *fmt;
-#ifdef __alpha__
+#if defined(__alpha__) && defined(CONFIG_ARCH_SUPPORTS_AOUT)
 	/* handle /sbin/loader.. */
 	{
 	    struct exec * eh = (struct exec *) bprm->buf;
diff -puN /dev/null include/asm-alpha/a.out-core.h
--- /dev/null
+++ a/include/asm-alpha/a.out-core.h
@@ -0,0 +1,81 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+
+/*
+ * Fill in the user structure for an ECOFF core dump.
+ */
+static inline void
+aout_dump_thread(struct pt_regs *pt, struct user *dump)
+{
+	/* switch stack follows right below pt_regs: */
+	struct switch_stack *sw = ((struct switch_stack *) pt) - 1;
+
+	dump->magic = CMAGIC;
+	dump->start_code  = current->mm->start_code;
+	dump->start_data  = current->mm->start_data;
+	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
+	dump->u_tsize = ((current->mm->end_code - dump->start_code)
+			 >> PAGE_SHIFT);
+	dump->u_dsize = ((current->mm->brk + PAGE_SIZE-1 - dump->start_data)
+			 >> PAGE_SHIFT);
+	dump->u_ssize = (current->mm->start_stack - dump->start_stack
+			 + PAGE_SIZE-1) >> PAGE_SHIFT;
+
+	/*
+	 * We store the registers in an order/format that is
+	 * compatible with DEC Unix/OSF/1 as this makes life easier
+	 * for gdb.
+	 */
+	dump->regs[EF_V0]  = pt->r0;
+	dump->regs[EF_T0]  = pt->r1;
+	dump->regs[EF_T1]  = pt->r2;
+	dump->regs[EF_T2]  = pt->r3;
+	dump->regs[EF_T3]  = pt->r4;
+	dump->regs[EF_T4]  = pt->r5;
+	dump->regs[EF_T5]  = pt->r6;
+	dump->regs[EF_T6]  = pt->r7;
+	dump->regs[EF_T7]  = pt->r8;
+	dump->regs[EF_S0]  = sw->r9;
+	dump->regs[EF_S1]  = sw->r10;
+	dump->regs[EF_S2]  = sw->r11;
+	dump->regs[EF_S3]  = sw->r12;
+	dump->regs[EF_S4]  = sw->r13;
+	dump->regs[EF_S5]  = sw->r14;
+	dump->regs[EF_S6]  = sw->r15;
+	dump->regs[EF_A3]  = pt->r19;
+	dump->regs[EF_A4]  = pt->r20;
+	dump->regs[EF_A5]  = pt->r21;
+	dump->regs[EF_T8]  = pt->r22;
+	dump->regs[EF_T9]  = pt->r23;
+	dump->regs[EF_T10] = pt->r24;
+	dump->regs[EF_T11] = pt->r25;
+	dump->regs[EF_RA]  = pt->r26;
+	dump->regs[EF_T12] = pt->r27;
+	dump->regs[EF_AT]  = pt->r28;
+	dump->regs[EF_SP]  = rdusp();
+	dump->regs[EF_PS]  = pt->ps;
+	dump->regs[EF_PC]  = pt->pc;
+	dump->regs[EF_GP]  = pt->gp;
+	dump->regs[EF_A0]  = pt->r16;
+	dump->regs[EF_A1]  = pt->r17;
+	dump->regs[EF_A2]  = pt->r18;
+	memcpy((char *)dump->regs + EF_SIZE, sw->fp, 32 * 8);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff -puN /dev/null include/asm-arm/a.out-core.h
--- /dev/null
+++ a/include/asm-arm/a.out-core.h
@@ -0,0 +1,50 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+#include <linux/elfcore.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	struct task_struct *tsk = current;
+
+	dump->magic = CMAGIC;
+	dump->start_code = tsk->mm->start_code;
+	dump->start_stack = regs->ARM_sp & ~(PAGE_SIZE - 1);
+
+	dump->u_tsize = (tsk->mm->end_code - tsk->mm->start_code) >> PAGE_SHIFT;
+	dump->u_dsize = (tsk->mm->brk - tsk->mm->start_data + PAGE_SIZE - 1) >>
+		PAGE_SHIFT;
+	dump->u_ssize = 0;
+
+	dump->u_debugreg[0] = tsk->thread.debug.bp[0].address;
+	dump->u_debugreg[1] = tsk->thread.debug.bp[1].address;
+	dump->u_debugreg[2] = tsk->thread.debug.bp[0].insn.arm;
+	dump->u_debugreg[3] = tsk->thread.debug.bp[1].insn.arm;
+	dump->u_debugreg[4] = tsk->thread.debug.nsaved;
+
+	if (dump->start_stack < 0x04000000)
+		dump->u_ssize = (0x04000000 - dump->start_stack) >> PAGE_SHIFT;
+
+	dump->regs = *regs;
+	dump->u_fpvalid = dump_fpu(regs, &dump->u_fp);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff -puN include/asm-frv/a.out.h~aout-suppress-aout-library-support-if-config_arch_supports_aout /dev/null
--- a/include/asm-frv/a.out.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/*
- * FRV doesn't do AOUT format. This header file should be removed as
- * soon as fs/exec.c and fs/proc/kcore.c and the archs that require
- * them to include linux/a.out.h are fixed.
- */
diff -puN include/asm-generic/Kbuild.asm~aout-suppress-aout-library-support-if-config_arch_supports_aout include/asm-generic/Kbuild.asm
--- a/include/asm-generic/Kbuild.asm~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/include/asm-generic/Kbuild.asm
@@ -1,4 +1,6 @@
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
 unifdef-y += a.out.h
+endif
 unifdef-y += auxvec.h
 unifdef-y += byteorder.h
 unifdef-y += errno.h
diff -puN /dev/null include/asm-m68k/a.out-core.h
--- /dev/null
+++ a/include/asm-m68k/a.out-core.h
@@ -0,0 +1,69 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+#include <linux/elfcore.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	struct switch_stack *sw;
+
+	/* changed the size calculations - should hopefully work better. lbt */
+	dump->magic = CMAGIC;
+	dump->start_code = 0;
+	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
+	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
+	dump->u_dsize = ((unsigned long) (current->mm->brk +
+					  (PAGE_SIZE-1))) >> PAGE_SHIFT;
+	dump->u_dsize -= dump->u_tsize;
+	dump->u_ssize = 0;
+
+	if (dump->start_stack < TASK_SIZE)
+		dump->u_ssize =
+			((unsigned long) (TASK_SIZE - dump->start_stack)) >>
+			PAGE_SHIFT;
+
+	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
+	sw = ((struct switch_stack *)regs) - 1;
+	dump->regs.d1 = regs->d1;
+	dump->regs.d2 = regs->d2;
+	dump->regs.d3 = regs->d3;
+	dump->regs.d4 = regs->d4;
+	dump->regs.d5 = regs->d5;
+	dump->regs.d6 = sw->d6;
+	dump->regs.d7 = sw->d7;
+	dump->regs.a0 = regs->a0;
+	dump->regs.a1 = regs->a1;
+	dump->regs.a2 = regs->a2;
+	dump->regs.a3 = sw->a3;
+	dump->regs.a4 = sw->a4;
+	dump->regs.a5 = sw->a5;
+	dump->regs.a6 = sw->a6;
+	dump->regs.d0 = regs->d0;
+	dump->regs.orig_d0 = regs->orig_d0;
+	dump->regs.stkadj = regs->stkadj;
+	dump->regs.sr = regs->sr;
+	dump->regs.pc = regs->pc;
+	dump->regs.fmtvec = (regs->format << 12) | regs->vector;
+	/* dump floating point stuff */
+	dump->u_fpvalid = dump_fpu(regs, &dump->m68kfp);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff -puN /dev/null include/asm-sparc/a.out-core.h
--- /dev/null
+++ a/include/asm-sparc/a.out-core.h
@@ -0,0 +1,55 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	unsigned long first_stack_page;
+
+	dump->magic = SUNOS_CORE_MAGIC;
+	dump->len = sizeof(struct user);
+	dump->regs.psr = regs->psr;
+	dump->regs.pc = regs->pc;
+	dump->regs.npc = regs->npc;
+	dump->regs.y = regs->y;
+	/* fuck me plenty */
+	memcpy(&dump->regs.regs[0], &regs->u_regs[1],
+	       (sizeof(unsigned long) * 15));
+	dump->uexec = current->thread.core_exec;
+	dump->u_tsize = (((unsigned long) current->mm->end_code) -
+		((unsigned long) current->mm->start_code)) & ~(PAGE_SIZE - 1);
+	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1)));
+	dump->u_dsize -= dump->u_tsize;
+	dump->u_dsize &= ~(PAGE_SIZE - 1);
+	first_stack_page = (regs->u_regs[UREG_FP] & ~(PAGE_SIZE - 1));
+	dump->u_ssize = (TASK_SIZE - first_stack_page) & ~(PAGE_SIZE - 1);
+	memcpy(&dump->fpu.fpstatus.fregs.regs[0],
+	       &current->thread.float_regs[0],
+	       sizeof(unsigned long) * 32);
+	dump->fpu.fpstatus.fsr = current->thread.fsr;
+	dump->fpu.fpstatus.flags = dump->fpu.fpstatus.extra = 0;
+	dump->fpu.fpstatus.fpq_count = current->thread.fpqdepth;
+	memcpy(&dump->fpu.fpstatus.fpq[0], &current->thread.fpqueue[0],
+	       ((sizeof(unsigned long) * 2) * 16));
+	dump->sigcode = 0;
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff -puN /dev/null include/asm-sparc64/a.out-core.h
--- /dev/null
+++ a/include/asm-sparc64/a.out-core.h
@@ -0,0 +1,31 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	/* Only should be used for SunOS and ancient a.out
+	 * SparcLinux binaries...  Not worth implementing.
+	 */
+	memset(dump, 0, sizeof(struct user));
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff -puN /dev/null include/asm-um/a.out-core.h
--- /dev/null
+++ a/include/asm-um/a.out-core.h
@@ -0,0 +1,27 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef __UM_A_OUT_CORE_H
+#define __UM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *u)
+{
+}
+
+#endif /* __KERNEL__ */
+#endif /* __UM_A_OUT_CORE_H */
diff -puN /dev/null include/asm-x86/a.out-core.h
--- /dev/null
+++ a/include/asm-x86/a.out-core.h
@@ -0,0 +1,67 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+#ifdef CONFIG_X86_32
+
+#include <linux/user.h>
+#include <linux/elfcore.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	int i;
+
+/* changed the size calculations - should hopefully work better. lbt */
+	dump->magic = CMAGIC;
+	dump->start_code = 0;
+	dump->start_stack = regs->esp & ~(PAGE_SIZE - 1);
+	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
+	dump->u_dsize = ((unsigned long)
+			 (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
+	dump->u_dsize -= dump->u_tsize;
+	dump->u_ssize = 0;
+	for (i = 0; i < 8; i++)
+		dump->u_debugreg[i] = current->thread.debugreg[i];
+
+	if (dump->start_stack < TASK_SIZE)
+		dump->u_ssize = ((unsigned long)
+				 (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
+
+	dump->regs.ebx = regs->ebx;
+	dump->regs.ecx = regs->ecx;
+	dump->regs.edx = regs->edx;
+	dump->regs.esi = regs->esi;
+	dump->regs.edi = regs->edi;
+	dump->regs.ebp = regs->ebp;
+	dump->regs.eax = regs->eax;
+	dump->regs.ds = regs->xds;
+	dump->regs.es = regs->xes;
+	dump->regs.fs = regs->xfs;
+	savesegment(gs, dump->regs.gs);
+	dump->regs.orig_eax = regs->orig_eax;
+	dump->regs.eip = regs->eip;
+	dump->regs.cs = regs->xcs;
+	dump->regs.eflags = regs->eflags;
+	dump->regs.esp = regs->esp;
+	dump->regs.ss = regs->xss;
+
+	dump->u_fpvalid = dump_fpu(regs, &dump->i387);
+}
+
+#endif /* CONFIG_X86_32 */
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff -puN include/linux/a.out.h~aout-suppress-aout-library-support-if-config_arch_supports_aout include/linux/a.out.h
--- a/include/linux/a.out.h~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/include/linux/a.out.h
@@ -1,6 +1,8 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
+#ifdef CONFIG_ARCH_SUPPORTS_AOUT
+
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -9,6 +11,8 @@
 
 #endif /* __STRUCT_EXEC_OVERRIDE__ */
 
+#ifndef __ASSEMBLY__
+
 /* these go in the N_MACHTYPE field */
 enum machine_type {
 #if defined (M_OLDSUN2)
@@ -272,5 +276,11 @@ struct relocation_info
 };
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
-
+#endif /*__ASSEMBLY__ */
+#else /* CONFIG_ARCH_SUPPORTS_AOUT */
+#ifndef __ASSEMBLY__
+struct exec {
+};
+#endif
+#endif /* CONFIG_ARCH_SUPPORTS_AOUT */
 #endif /* __A_OUT_GNU_H__ */
diff -puN include/linux/kernel.h~aout-suppress-aout-library-support-if-config_arch_supports_aout include/linux/kernel.h
--- a/include/linux/kernel.h~aout-suppress-aout-library-support-if-config_arch_supports_aout
+++ a/include/linux/kernel.h
@@ -172,8 +172,6 @@ extern int kernel_text_address(unsigned 
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
-extern void dump_thread(struct pt_regs *regs, struct user *dump);
-
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
af_rxrpc-configure-crypto-correctly-for-af_rxrpc.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
mn10300-fix-mtd-jedec-probe-so-that-the-asb2303-bootprom-can-be-detected.patch
mutex-subsystem-synchro-test-module.patch
