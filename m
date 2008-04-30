From: akpm@linux-foundation.org
Subject: - mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:55 -0700
Message-ID: <200804300549.m3U5ntqE030041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758972AbYD3Fum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: use kbuild.h instead of macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: use kbuild.h instead of macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Use the macros provided in kbuild.h

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/asm-offsets.c |  480 ++++++++++++++-----------------
 1 file changed, 219 insertions(+), 261 deletions(-)

diff -puN arch/mips/kernel/asm-offsets.c~mips-use-kbuildh-instead-of-macros-in-asm-offsetsc arch/mips/kernel/asm-offsets.c
--- a/arch/mips/kernel/asm-offsets.c~mips-use-kbuildh-instead-of-macros-in-asm-offsetsc
+++ a/arch/mips/kernel/asm-offsets.c
@@ -13,327 +13,285 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
-
+#include <linux/kbuild.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 
-#define text(t) __asm__("\n->#" t)
-#define _offset(type, member) (&(((type *)NULL)->member))
-#define offset(string, ptr, member) \
-	__asm__("\n->" string " %0" : : "i" (_offset(ptr, member)))
-#define constant(string, member) \
-	__asm__("\n->" string " %0" : : "ri" (member))
-#define size(string, size) \
-	__asm__("\n->" string " %0" : : "i" (sizeof(size)))
-#define linefeed text("")
-
 void output_ptreg_defines(void)
 {
-	text("MIPS pt_regs offsets.");
-	offset("PT_R0", struct pt_regs, regs[0]);
-	offset("PT_R1", struct pt_regs, regs[1]);
-	offset("PT_R2", struct pt_regs, regs[2]);
-	offset("PT_R3", struct pt_regs, regs[3]);
-	offset("PT_R4", struct pt_regs, regs[4]);
-	offset("PT_R5", struct pt_regs, regs[5]);
-	offset("PT_R6", struct pt_regs, regs[6]);
-	offset("PT_R7", struct pt_regs, regs[7]);
-	offset("PT_R8", struct pt_regs, regs[8]);
-	offset("PT_R9", struct pt_regs, regs[9]);
-	offset("PT_R10", struct pt_regs, regs[10]);
-	offset("PT_R11", struct pt_regs, regs[11]);
-	offset("PT_R12", struct pt_regs, regs[12]);
-	offset("PT_R13", struct pt_regs, regs[13]);
-	offset("PT_R14", struct pt_regs, regs[14]);
-	offset("PT_R15", struct pt_regs, regs[15]);
-	offset("PT_R16", struct pt_regs, regs[16]);
-	offset("PT_R17", struct pt_regs, regs[17]);
-	offset("PT_R18", struct pt_regs, regs[18]);
-	offset("PT_R19", struct pt_regs, regs[19]);
-	offset("PT_R20", struct pt_regs, regs[20]);
-	offset("PT_R21", struct pt_regs, regs[21]);
-	offset("PT_R22", struct pt_regs, regs[22]);
-	offset("PT_R23", struct pt_regs, regs[23]);
-	offset("PT_R24", struct pt_regs, regs[24]);
-	offset("PT_R25", struct pt_regs, regs[25]);
-	offset("PT_R26", struct pt_regs, regs[26]);
-	offset("PT_R27", struct pt_regs, regs[27]);
-	offset("PT_R28", struct pt_regs, regs[28]);
-	offset("PT_R29", struct pt_regs, regs[29]);
-	offset("PT_R30", struct pt_regs, regs[30]);
-	offset("PT_R31", struct pt_regs, regs[31]);
-	offset("PT_LO", struct pt_regs, lo);
-	offset("PT_HI", struct pt_regs, hi);
+	COMMENT("MIPS pt_regs offsets.");
+	OFFSET(PT_R0, pt_regs, regs[0]);
+	OFFSET(PT_R1, pt_regs, regs[1]);
+	OFFSET(PT_R2, pt_regs, regs[2]);
+	OFFSET(PT_R3, pt_regs, regs[3]);
+	OFFSET(PT_R4, pt_regs, regs[4]);
+	OFFSET(PT_R5, pt_regs, regs[5]);
+	OFFSET(PT_R6, pt_regs, regs[6]);
+	OFFSET(PT_R7, pt_regs, regs[7]);
+	OFFSET(PT_R8, pt_regs, regs[8]);
+	OFFSET(PT_R9, pt_regs, regs[9]);
+	OFFSET(PT_R10, pt_regs, regs[10]);
+	OFFSET(PT_R11, pt_regs, regs[11]);
+	OFFSET(PT_R12, pt_regs, regs[12]);
+	OFFSET(PT_R13, pt_regs, regs[13]);
+	OFFSET(PT_R14, pt_regs, regs[14]);
+	OFFSET(PT_R15, pt_regs, regs[15]);
+	OFFSET(PT_R16, pt_regs, regs[16]);
+	OFFSET(PT_R17, pt_regs, regs[17]);
+	OFFSET(PT_R18, pt_regs, regs[18]);
+	OFFSET(PT_R19, pt_regs, regs[19]);
+	OFFSET(PT_R20, pt_regs, regs[20]);
+	OFFSET(PT_R21, pt_regs, regs[21]);
+	OFFSET(PT_R22, pt_regs, regs[22]);
+	OFFSET(PT_R23, pt_regs, regs[23]);
+	OFFSET(PT_R24, pt_regs, regs[24]);
+	OFFSET(PT_R25, pt_regs, regs[25]);
+	OFFSET(PT_R26, pt_regs, regs[26]);
+	OFFSET(PT_R27, pt_regs, regs[27]);
+	OFFSET(PT_R28, pt_regs, regs[28]);
+	OFFSET(PT_R29, pt_regs, regs[29]);
+	OFFSET(PT_R30, pt_regs, regs[30]);
+	OFFSET(PT_R31, pt_regs, regs[31]);
+	OFFSET(PT_LO, pt_regs, lo);
+	OFFSET(PT_HI, pt_regs, hi);
 #ifdef CONFIG_CPU_HAS_SMARTMIPS
-	offset("PT_ACX", struct pt_regs, acx);
+	OFFSET(PT_ACX, pt_regs, acx);
 #endif
-	offset("PT_EPC", struct pt_regs, cp0_epc);
-	offset("PT_BVADDR", struct pt_regs, cp0_badvaddr);
-	offset("PT_STATUS", struct pt_regs, cp0_status);
-	offset("PT_CAUSE", struct pt_regs, cp0_cause);
+	OFFSET(PT_EPC, pt_regs, cp0_epc);
+	OFFSET(PT_BVADDR, pt_regs, cp0_badvaddr);
+	OFFSET(PT_STATUS, pt_regs, cp0_status);
+	OFFSET(PT_CAUSE, pt_regs, cp0_cause);
 #ifdef CONFIG_MIPS_MT_SMTC
-	offset("PT_TCSTATUS", struct pt_regs, cp0_tcstatus);
+	OFFSET(PT_TCSTATUS, pt_regs, cp0_tcstatus);
 #endif /* CONFIG_MIPS_MT_SMTC */
-	size("PT_SIZE", struct pt_regs);
-	linefeed;
+	DEFINE(PT_SIZE, sizeof(struct pt_regs));
+	BLANK();
 }
 
 void output_task_defines(void)
 {
-	text("MIPS task_struct offsets.");
-	offset("TASK_STATE", struct task_struct, state);
-	offset("TASK_THREAD_INFO", struct task_struct, stack);
-	offset("TASK_FLAGS", struct task_struct, flags);
-	offset("TASK_MM", struct task_struct, mm);
-	offset("TASK_PID", struct task_struct, pid);
-	size(  "TASK_STRUCT_SIZE", struct task_struct);
-	linefeed;
+	COMMENT("MIPS task_struct offsets.");
+	OFFSET(TASK_STATE, task_struct, state);
+	OFFSET(TASK_THREAD_INFO, task_struct, stack);
+	OFFSET(TASK_FLAGS, task_struct, flags);
+	OFFSET(TASK_MM, task_struct, mm);
+	OFFSET(TASK_PID, task_struct, pid);
+	DEFINE(TASK_STRUCT_SIZE, sizeof(struct task_struct));
+	BLANK();
 }
 
 void output_thread_info_defines(void)
 {
-	text("MIPS thread_info offsets.");
-	offset("TI_TASK", struct thread_info, task);
-	offset("TI_EXEC_DOMAIN", struct thread_info, exec_domain);
-	offset("TI_FLAGS", struct thread_info, flags);
-	offset("TI_TP_VALUE", struct thread_info, tp_value);
-	offset("TI_CPU", struct thread_info, cpu);
-	offset("TI_PRE_COUNT", struct thread_info, preempt_count);
-	offset("TI_ADDR_LIMIT", struct thread_info, addr_limit);
-	offset("TI_RESTART_BLOCK", struct thread_info, restart_block);
-	offset("TI_REGS", struct thread_info, regs);
-	constant("_THREAD_SIZE", THREAD_SIZE);
-	constant("_THREAD_MASK", THREAD_MASK);
-	linefeed;
+	COMMENT("MIPS thread_info offsets.");
+	OFFSET(TI_TASK, thread_info, task);
+	OFFSET(TI_EXEC_DOMAIN, thread_info, exec_domain);
+	OFFSET(TI_FLAGS, thread_info, flags);
+	OFFSET(TI_TP_VALUE, thread_info, tp_value);
+	OFFSET(TI_CPU, thread_info, cpu);
+	OFFSET(TI_PRE_COUNT, thread_info, preempt_count);
+	OFFSET(TI_ADDR_LIMIT, thread_info, addr_limit);
+	OFFSET(TI_RESTART_BLOCK, thread_info, restart_block);
+	OFFSET(TI_REGS, thread_info, regs);
+	DEFINE(_THREAD_SIZE, THREAD_SIZE);
+	DEFINE(_THREAD_MASK, THREAD_MASK);
+	BLANK();
 }
 
 void output_thread_defines(void)
 {
-	text("MIPS specific thread_struct offsets.");
-	offset("THREAD_REG16", struct task_struct, thread.reg16);
-	offset("THREAD_REG17", struct task_struct, thread.reg17);
-	offset("THREAD_REG18", struct task_struct, thread.reg18);
-	offset("THREAD_REG19", struct task_struct, thread.reg19);
-	offset("THREAD_REG20", struct task_struct, thread.reg20);
-	offset("THREAD_REG21", struct task_struct, thread.reg21);
-	offset("THREAD_REG22", struct task_struct, thread.reg22);
-	offset("THREAD_REG23", struct task_struct, thread.reg23);
-	offset("THREAD_REG29", struct task_struct, thread.reg29);
-	offset("THREAD_REG30", struct task_struct, thread.reg30);
-	offset("THREAD_REG31", struct task_struct, thread.reg31);
-	offset("THREAD_STATUS", struct task_struct,
+	COMMENT("MIPS specific thread_struct offsets.");
+	OFFSET(THREAD_REG16, task_struct, thread.reg16);
+	OFFSET(THREAD_REG17, task_struct, thread.reg17);
+	OFFSET(THREAD_REG18, task_struct, thread.reg18);
+	OFFSET(THREAD_REG19, task_struct, thread.reg19);
+	OFFSET(THREAD_REG20, task_struct, thread.reg20);
+	OFFSET(THREAD_REG21, task_struct, thread.reg21);
+	OFFSET(THREAD_REG22, task_struct, thread.reg22);
+	OFFSET(THREAD_REG23, task_struct, thread.reg23);
+	OFFSET(THREAD_REG29, task_struct, thread.reg29);
+	OFFSET(THREAD_REG30, task_struct, thread.reg30);
+	OFFSET(THREAD_REG31, task_struct, thread.reg31);
+	OFFSET(THREAD_STATUS, task_struct,
 	       thread.cp0_status);
-	offset("THREAD_FPU", struct task_struct, thread.fpu);
+	OFFSET(THREAD_FPU, task_struct, thread.fpu);
 
-	offset("THREAD_BVADDR", struct task_struct, \
+	OFFSET(THREAD_BVADDR, task_struct, \
 	       thread.cp0_badvaddr);
-	offset("THREAD_BUADDR", struct task_struct, \
+	OFFSET(THREAD_BUADDR, task_struct, \
 	       thread.cp0_baduaddr);
-	offset("THREAD_ECODE", struct task_struct, \
+	OFFSET(THREAD_ECODE, task_struct, \
 	       thread.error_code);
-	offset("THREAD_TRAPNO", struct task_struct, thread.trap_no);
-	offset("THREAD_TRAMP", struct task_struct, \
+	OFFSET(THREAD_TRAPNO, task_struct, thread.trap_no);
+	OFFSET(THREAD_TRAMP, task_struct, \
 	       thread.irix_trampoline);
-	offset("THREAD_OLDCTX", struct task_struct, \
+	OFFSET(THREAD_OLDCTX, task_struct, \
 	       thread.irix_oldctx);
-	linefeed;
+	BLANK();
 }
 
 void output_thread_fpu_defines(void)
 {
-	offset("THREAD_FPR0",
-	       struct task_struct, thread.fpu.fpr[0]);
-	offset("THREAD_FPR1",
-	       struct task_struct, thread.fpu.fpr[1]);
-	offset("THREAD_FPR2",
-	       struct task_struct, thread.fpu.fpr[2]);
-	offset("THREAD_FPR3",
-	       struct task_struct, thread.fpu.fpr[3]);
-	offset("THREAD_FPR4",
-	       struct task_struct, thread.fpu.fpr[4]);
-	offset("THREAD_FPR5",
-	       struct task_struct, thread.fpu.fpr[5]);
-	offset("THREAD_FPR6",
-	       struct task_struct, thread.fpu.fpr[6]);
-	offset("THREAD_FPR7",
-	       struct task_struct, thread.fpu.fpr[7]);
-	offset("THREAD_FPR8",
-	       struct task_struct, thread.fpu.fpr[8]);
-	offset("THREAD_FPR9",
-	       struct task_struct, thread.fpu.fpr[9]);
-	offset("THREAD_FPR10",
-	       struct task_struct, thread.fpu.fpr[10]);
-	offset("THREAD_FPR11",
-	       struct task_struct, thread.fpu.fpr[11]);
-	offset("THREAD_FPR12",
-	       struct task_struct, thread.fpu.fpr[12]);
-	offset("THREAD_FPR13",
-	       struct task_struct, thread.fpu.fpr[13]);
-	offset("THREAD_FPR14",
-	       struct task_struct, thread.fpu.fpr[14]);
-	offset("THREAD_FPR15",
-	       struct task_struct, thread.fpu.fpr[15]);
-	offset("THREAD_FPR16",
-	       struct task_struct, thread.fpu.fpr[16]);
-	offset("THREAD_FPR17",
-	       struct task_struct, thread.fpu.fpr[17]);
-	offset("THREAD_FPR18",
-	       struct task_struct, thread.fpu.fpr[18]);
-	offset("THREAD_FPR19",
-	       struct task_struct, thread.fpu.fpr[19]);
-	offset("THREAD_FPR20",
-	       struct task_struct, thread.fpu.fpr[20]);
-	offset("THREAD_FPR21",
-	       struct task_struct, thread.fpu.fpr[21]);
-	offset("THREAD_FPR22",
-	       struct task_struct, thread.fpu.fpr[22]);
-	offset("THREAD_FPR23",
-	       struct task_struct, thread.fpu.fpr[23]);
-	offset("THREAD_FPR24",
-	       struct task_struct, thread.fpu.fpr[24]);
-	offset("THREAD_FPR25",
-	       struct task_struct, thread.fpu.fpr[25]);
-	offset("THREAD_FPR26",
-	       struct task_struct, thread.fpu.fpr[26]);
-	offset("THREAD_FPR27",
-	       struct task_struct, thread.fpu.fpr[27]);
-	offset("THREAD_FPR28",
-	       struct task_struct, thread.fpu.fpr[28]);
-	offset("THREAD_FPR29",
-	       struct task_struct, thread.fpu.fpr[29]);
-	offset("THREAD_FPR30",
-	       struct task_struct, thread.fpu.fpr[30]);
-	offset("THREAD_FPR31",
-	       struct task_struct, thread.fpu.fpr[31]);
-
-	offset("THREAD_FCR31",
-	       struct task_struct, thread.fpu.fcr31);
-	linefeed;
+	OFFSET(THREAD_FPR0, task_struct, thread.fpu.fpr[0]);
+	OFFSET(THREAD_FPR1, task_struct, thread.fpu.fpr[1]);
+	OFFSET(THREAD_FPR2, task_struct, thread.fpu.fpr[2]);
+	OFFSET(THREAD_FPR3, task_struct, thread.fpu.fpr[3]);
+	OFFSET(THREAD_FPR4, task_struct, thread.fpu.fpr[4]);
+	OFFSET(THREAD_FPR5, task_struct, thread.fpu.fpr[5]);
+	OFFSET(THREAD_FPR6, task_struct, thread.fpu.fpr[6]);
+	OFFSET(THREAD_FPR7, task_struct, thread.fpu.fpr[7]);
+	OFFSET(THREAD_FPR8, task_struct, thread.fpu.fpr[8]);
+	OFFSET(THREAD_FPR9, task_struct, thread.fpu.fpr[9]);
+	OFFSET(THREAD_FPR10, task_struct, thread.fpu.fpr[10]);
+	OFFSET(THREAD_FPR11, task_struct, thread.fpu.fpr[11]);
+	OFFSET(THREAD_FPR12, task_struct, thread.fpu.fpr[12]);
+	OFFSET(THREAD_FPR13, task_struct, thread.fpu.fpr[13]);
+	OFFSET(THREAD_FPR14, task_struct, thread.fpu.fpr[14]);
+	OFFSET(THREAD_FPR15, task_struct, thread.fpu.fpr[15]);
+	OFFSET(THREAD_FPR16, task_struct, thread.fpu.fpr[16]);
+	OFFSET(THREAD_FPR17, task_struct, thread.fpu.fpr[17]);
+	OFFSET(THREAD_FPR18, task_struct, thread.fpu.fpr[18]);
+	OFFSET(THREAD_FPR19, task_struct, thread.fpu.fpr[19]);
+	OFFSET(THREAD_FPR20, task_struct, thread.fpu.fpr[20]);
+	OFFSET(THREAD_FPR21, task_struct, thread.fpu.fpr[21]);
+	OFFSET(THREAD_FPR22, task_struct, thread.fpu.fpr[22]);
+	OFFSET(THREAD_FPR23, task_struct, thread.fpu.fpr[23]);
+	OFFSET(THREAD_FPR24, task_struct, thread.fpu.fpr[24]);
+	OFFSET(THREAD_FPR25, task_struct, thread.fpu.fpr[25]);
+	OFFSET(THREAD_FPR26, task_struct, thread.fpu.fpr[26]);
+	OFFSET(THREAD_FPR27, task_struct, thread.fpu.fpr[27]);
+	OFFSET(THREAD_FPR28, task_struct, thread.fpu.fpr[28]);
+	OFFSET(THREAD_FPR29, task_struct, thread.fpu.fpr[29]);
+	OFFSET(THREAD_FPR30, task_struct, thread.fpu.fpr[30]);
+	OFFSET(THREAD_FPR31, task_struct, thread.fpu.fpr[31]);
+
+	OFFSET(THREAD_FCR31, task_struct, thread.fpu.fcr31);
+	BLANK();
 }
 
 void output_mm_defines(void)
 {
-	text("Size of struct page");
-	size("STRUCT_PAGE_SIZE", struct page);
-	linefeed;
-	text("Linux mm_struct offsets.");
-	offset("MM_USERS", struct mm_struct, mm_users);
-	offset("MM_PGD", struct mm_struct, pgd);
-	offset("MM_CONTEXT", struct mm_struct, context);
-	linefeed;
-	constant("_PAGE_SIZE", PAGE_SIZE);
-	constant("_PAGE_SHIFT", PAGE_SHIFT);
-	linefeed;
-	constant("_PGD_T_SIZE", sizeof(pgd_t));
-	constant("_PMD_T_SIZE", sizeof(pmd_t));
-	constant("_PTE_T_SIZE", sizeof(pte_t));
-	linefeed;
-	constant("_PGD_T_LOG2", PGD_T_LOG2);
-	constant("_PMD_T_LOG2", PMD_T_LOG2);
-	constant("_PTE_T_LOG2", PTE_T_LOG2);
-	linefeed;
-	constant("_PGD_ORDER", PGD_ORDER);
-	constant("_PMD_ORDER", PMD_ORDER);
-	constant("_PTE_ORDER", PTE_ORDER);
-	linefeed;
-	constant("_PMD_SHIFT", PMD_SHIFT);
-	constant("_PGDIR_SHIFT", PGDIR_SHIFT);
-	linefeed;
-	constant("_PTRS_PER_PGD", PTRS_PER_PGD);
-	constant("_PTRS_PER_PMD", PTRS_PER_PMD);
-	constant("_PTRS_PER_PTE", PTRS_PER_PTE);
-	linefeed;
+	COMMENT("Size of struct page");
+	DEFINE(STRUCT_PAGE_SIZE, sizeof(struct page));
+	BLANK();
+	COMMENT("Linux mm_struct offsets.");
+	OFFSET(MM_USERS, mm_struct, mm_users);
+	OFFSET(MM_PGD, mm_struct, pgd);
+	OFFSET(MM_CONTEXT, mm_struct, context);
+	BLANK();
+	DEFINE(_PAGE_SIZE, PAGE_SIZE);
+	DEFINE(_PAGE_SHIFT, PAGE_SHIFT);
+	BLANK();
+	DEFINE(_PGD_T_SIZE, sizeof(pgd_t));
+	DEFINE(_PMD_T_SIZE, sizeof(pmd_t));
+	DEFINE(_PTE_T_SIZE, sizeof(pte_t));
+	BLANK();
+	DEFINE(_PGD_T_LOG2, PGD_T_LOG2);
+	DEFINE(_PMD_T_LOG2, PMD_T_LOG2);
+	DEFINE(_PTE_T_LOG2, PTE_T_LOG2);
+	BLANK();
+	DEFINE(_PGD_ORDER, PGD_ORDER);
+	DEFINE(_PMD_ORDER, PMD_ORDER);
+	DEFINE(_PTE_ORDER, PTE_ORDER);
+	BLANK();
+	DEFINE(_PMD_SHIFT, PMD_SHIFT);
+	DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
+	BLANK();
+	DEFINE(_PTRS_PER_PGD, PTRS_PER_PGD);
+	DEFINE(_PTRS_PER_PMD, PTRS_PER_PMD);
+	DEFINE(_PTRS_PER_PTE, PTRS_PER_PTE);
+	BLANK();
 }
 
 #ifdef CONFIG_32BIT
 void output_sc_defines(void)
 {
-	text("Linux sigcontext offsets.");
-	offset("SC_REGS", struct sigcontext, sc_regs);
-	offset("SC_FPREGS", struct sigcontext, sc_fpregs);
-	offset("SC_ACX", struct sigcontext, sc_acx);
-	offset("SC_MDHI", struct sigcontext, sc_mdhi);
-	offset("SC_MDLO", struct sigcontext, sc_mdlo);
-	offset("SC_PC", struct sigcontext, sc_pc);
-	offset("SC_FPC_CSR", struct sigcontext, sc_fpc_csr);
-	offset("SC_FPC_EIR", struct sigcontext, sc_fpc_eir);
-	offset("SC_HI1", struct sigcontext, sc_hi1);
-	offset("SC_LO1", struct sigcontext, sc_lo1);
-	offset("SC_HI2", struct sigcontext, sc_hi2);
-	offset("SC_LO2", struct sigcontext, sc_lo2);
-	offset("SC_HI3", struct sigcontext, sc_hi3);
-	offset("SC_LO3", struct sigcontext, sc_lo3);
-	linefeed;
+	COMMENT("Linux sigcontext offsets.");
+	OFFSET(SC_REGS, sigcontext, sc_regs);
+	OFFSET(SC_FPREGS, sigcontext, sc_fpregs);
+	OFFSET(SC_ACX, sigcontext, sc_acx);
+	OFFSET(SC_MDHI, sigcontext, sc_mdhi);
+	OFFSET(SC_MDLO, sigcontext, sc_mdlo);
+	OFFSET(SC_PC, sigcontext, sc_pc);
+	OFFSET(SC_FPC_CSR, sigcontext, sc_fpc_csr);
+	OFFSET(SC_FPC_EIR, sigcontext, sc_fpc_eir);
+	OFFSET(SC_HI1, sigcontext, sc_hi1);
+	OFFSET(SC_LO1, sigcontext, sc_lo1);
+	OFFSET(SC_HI2, sigcontext, sc_hi2);
+	OFFSET(SC_LO2, sigcontext, sc_lo2);
+	OFFSET(SC_HI3, sigcontext, sc_hi3);
+	OFFSET(SC_LO3, sigcontext, sc_lo3);
+	BLANK();
 }
 #endif
 
 #ifdef CONFIG_64BIT
 void output_sc_defines(void)
 {
-	text("Linux sigcontext offsets.");
-	offset("SC_REGS", struct sigcontext, sc_regs);
-	offset("SC_FPREGS", struct sigcontext, sc_fpregs);
-	offset("SC_MDHI", struct sigcontext, sc_mdhi);
-	offset("SC_MDLO", struct sigcontext, sc_mdlo);
-	offset("SC_PC", struct sigcontext, sc_pc);
-	offset("SC_FPC_CSR", struct sigcontext, sc_fpc_csr);
-	linefeed;
+	COMMENT("Linux sigcontext offsets.");
+	OFFSET(SC_REGS, sigcontext, sc_regs);
+	OFFSET(SC_FPREGS, sigcontext, sc_fpregs);
+	OFFSET(SC_MDHI, sigcontext, sc_mdhi);
+	OFFSET(SC_MDLO, sigcontext, sc_mdlo);
+	OFFSET(SC_PC, sigcontext, sc_pc);
+	OFFSET(SC_FPC_CSR, sigcontext, sc_fpc_csr);
+	BLANK();
 }
 #endif
 
 #ifdef CONFIG_MIPS32_COMPAT
 void output_sc32_defines(void)
 {
-	text("Linux 32-bit sigcontext offsets.");
-	offset("SC32_FPREGS", struct sigcontext32, sc_fpregs);
-	offset("SC32_FPC_CSR", struct sigcontext32, sc_fpc_csr);
-	offset("SC32_FPC_EIR", struct sigcontext32, sc_fpc_eir);
-	linefeed;
+	COMMENT("Linux 32-bit sigcontext offsets.");
+	OFFSET(SC32_FPREGS, sigcontext32, sc_fpregs);
+	OFFSET(SC32_FPC_CSR, sigcontext32, sc_fpc_csr);
+	OFFSET(SC32_FPC_EIR, sigcontext32, sc_fpc_eir);
+	BLANK();
 }
 #endif
 
 void output_signal_defined(void)
 {
-	text("Linux signal numbers.");
-	constant("_SIGHUP", SIGHUP);
-	constant("_SIGINT", SIGINT);
-	constant("_SIGQUIT", SIGQUIT);
-	constant("_SIGILL", SIGILL);
-	constant("_SIGTRAP", SIGTRAP);
-	constant("_SIGIOT", SIGIOT);
-	constant("_SIGABRT", SIGABRT);
-	constant("_SIGEMT", SIGEMT);
-	constant("_SIGFPE", SIGFPE);
-	constant("_SIGKILL", SIGKILL);
-	constant("_SIGBUS", SIGBUS);
-	constant("_SIGSEGV", SIGSEGV);
-	constant("_SIGSYS", SIGSYS);
-	constant("_SIGPIPE", SIGPIPE);
-	constant("_SIGALRM", SIGALRM);
-	constant("_SIGTERM", SIGTERM);
-	constant("_SIGUSR1", SIGUSR1);
-	constant("_SIGUSR2", SIGUSR2);
-	constant("_SIGCHLD", SIGCHLD);
-	constant("_SIGPWR", SIGPWR);
-	constant("_SIGWINCH", SIGWINCH);
-	constant("_SIGURG", SIGURG);
-	constant("_SIGIO", SIGIO);
-	constant("_SIGSTOP", SIGSTOP);
-	constant("_SIGTSTP", SIGTSTP);
-	constant("_SIGCONT", SIGCONT);
-	constant("_SIGTTIN", SIGTTIN);
-	constant("_SIGTTOU", SIGTTOU);
-	constant("_SIGVTALRM", SIGVTALRM);
-	constant("_SIGPROF", SIGPROF);
-	constant("_SIGXCPU", SIGXCPU);
-	constant("_SIGXFSZ", SIGXFSZ);
-	linefeed;
+	COMMENT("Linux signal numbers.");
+	DEFINE(_SIGHUP, SIGHUP);
+	DEFINE(_SIGINT, SIGINT);
+	DEFINE(_SIGQUIT, SIGQUIT);
+	DEFINE(_SIGILL, SIGILL);
+	DEFINE(_SIGTRAP, SIGTRAP);
+	DEFINE(_SIGIOT, SIGIOT);
+	DEFINE(_SIGABRT, SIGABRT);
+	DEFINE(_SIGEMT, SIGEMT);
+	DEFINE(_SIGFPE, SIGFPE);
+	DEFINE(_SIGKILL, SIGKILL);
+	DEFINE(_SIGBUS, SIGBUS);
+	DEFINE(_SIGSEGV, SIGSEGV);
+	DEFINE(_SIGSYS, SIGSYS);
+	DEFINE(_SIGPIPE, SIGPIPE);
+	DEFINE(_SIGALRM, SIGALRM);
+	DEFINE(_SIGTERM, SIGTERM);
+	DEFINE(_SIGUSR1, SIGUSR1);
+	DEFINE(_SIGUSR2, SIGUSR2);
+	DEFINE(_SIGCHLD, SIGCHLD);
+	DEFINE(_SIGPWR, SIGPWR);
+	DEFINE(_SIGWINCH, SIGWINCH);
+	DEFINE(_SIGURG, SIGURG);
+	DEFINE(_SIGIO, SIGIO);
+	DEFINE(_SIGSTOP, SIGSTOP);
+	DEFINE(_SIGTSTP, SIGTSTP);
+	DEFINE(_SIGCONT, SIGCONT);
+	DEFINE(_SIGTTIN, SIGTTIN);
+	DEFINE(_SIGTTOU, SIGTTOU);
+	DEFINE(_SIGVTALRM, SIGVTALRM);
+	DEFINE(_SIGPROF, SIGPROF);
+	DEFINE(_SIGXCPU, SIGXCPU);
+	DEFINE(_SIGXFSZ, SIGXFSZ);
+	BLANK();
 }
 
 void output_irq_cpustat_t_defines(void)
 {
-	text("Linux irq_cpustat_t offsets.");
-	offset("IC_SOFTIRQ_PENDING", irq_cpustat_t, __softirq_pending);
-	size("IC_IRQ_CPUSTAT_T", irq_cpustat_t);
-	linefeed;
+	COMMENT("Linux irq_cpustat_t offsets.");
+	DEFINE(IC_SOFTIRQ_PENDING,
+			offsetof(irq_cpustat_t, __softirq_pending));
+	DEFINE(IC_IRQ_CPUSTAT_T, sizeof(irq_cpustat_t));
+	BLANK();
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

