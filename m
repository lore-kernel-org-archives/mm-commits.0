From: akpm@linux-foundation.org
Subject: + pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips.patch added to -mm tree
Date: Mon, 14 Apr 2008 13:32:26 -0700
Message-ID: <200804142032.m3EKWQak025539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbYDNUcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 16:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ralf@linux-mips.org, sam@ravnborg.org


The patch titled
     pageflags: standardize comment inclusion in asm-offsets.h and fix MIPS
has been added to the -mm tree.  Its filename is
     pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips.patch

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
Subject: pageflags: standardize comment inclusion in asm-offsets.h and fix MIPS
From: Christoph Lameter <clameter@sgi.com>

Add the ability to pass comments into asm-offsets.h by generating asm
output like

-># comment line

Mips needs this feature to preserve the comments that are in
asm-mips/asm-offsets.h right now.

Then remove the special handling for mips from Kbuild and convert mips to use
the new string to include the comments.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Kbuild                         |    6 
 arch/mips/kernel/asm-offsets.c |  416 +++++++++++++++----------------
 2 files changed, 211 insertions(+), 211 deletions(-)

diff -puN Kbuild~pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips Kbuild
--- a/Kbuild~pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips
+++ a/Kbuild
@@ -52,10 +52,10 @@ targets += arch/$(SRCARCH)/kernel/asm-of
 
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
-	"/^->/{s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}"
+	"/^->/{s:->#\(.*\):/* \1 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:->::; p;}"
 endef
-# Override default regexp for specific architectures
-sed-$(CONFIG_MIPS) := "/^@@@/{s/^@@@//; s/ \#.*\$$//; p;}"
 
 quiet_cmd_offsets = GEN     $@
 define cmd_offsets
diff -puN arch/mips/kernel/asm-offsets.c~pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips arch/mips/kernel/asm-offsets.c
--- a/arch/mips/kernel/asm-offsets.c~pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips
+++ a/arch/mips/kernel/asm-offsets.c
@@ -17,252 +17,252 @@
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 
-#define text(t) __asm__("\n@@@" t)
+#define text(t) __asm__("\n->#" t)
 #define _offset(type, member) (&(((type *)NULL)->member))
 #define offset(string, ptr, member) \
-	__asm__("\n@@@" string "%0" : : "i" (_offset(ptr, member)))
+	__asm__("\n->" string " %0" : : "i" (_offset(ptr, member)))
 #define constant(string, member) \
-	__asm__("\n@@@" string "%X0" : : "ri" (member))
+	__asm__("\n->" string " %0" : : "ri" (member))
 #define size(string, size) \
-	__asm__("\n@@@" string "%0" : : "i" (sizeof(size)))
+	__asm__("\n->" string " %0" : : "i" (sizeof(size)))
 #define linefeed text("")
 
 void output_ptreg_defines(void)
 {
-	text("/* MIPS pt_regs offsets. */");
-	offset("#define PT_R0     ", struct pt_regs, regs[0]);
-	offset("#define PT_R1     ", struct pt_regs, regs[1]);
-	offset("#define PT_R2     ", struct pt_regs, regs[2]);
-	offset("#define PT_R3     ", struct pt_regs, regs[3]);
-	offset("#define PT_R4     ", struct pt_regs, regs[4]);
-	offset("#define PT_R5     ", struct pt_regs, regs[5]);
-	offset("#define PT_R6     ", struct pt_regs, regs[6]);
-	offset("#define PT_R7     ", struct pt_regs, regs[7]);
-	offset("#define PT_R8     ", struct pt_regs, regs[8]);
-	offset("#define PT_R9     ", struct pt_regs, regs[9]);
-	offset("#define PT_R10    ", struct pt_regs, regs[10]);
-	offset("#define PT_R11    ", struct pt_regs, regs[11]);
-	offset("#define PT_R12    ", struct pt_regs, regs[12]);
-	offset("#define PT_R13    ", struct pt_regs, regs[13]);
-	offset("#define PT_R14    ", struct pt_regs, regs[14]);
-	offset("#define PT_R15    ", struct pt_regs, regs[15]);
-	offset("#define PT_R16    ", struct pt_regs, regs[16]);
-	offset("#define PT_R17    ", struct pt_regs, regs[17]);
-	offset("#define PT_R18    ", struct pt_regs, regs[18]);
-	offset("#define PT_R19    ", struct pt_regs, regs[19]);
-	offset("#define PT_R20    ", struct pt_regs, regs[20]);
-	offset("#define PT_R21    ", struct pt_regs, regs[21]);
-	offset("#define PT_R22    ", struct pt_regs, regs[22]);
-	offset("#define PT_R23    ", struct pt_regs, regs[23]);
-	offset("#define PT_R24    ", struct pt_regs, regs[24]);
-	offset("#define PT_R25    ", struct pt_regs, regs[25]);
-	offset("#define PT_R26    ", struct pt_regs, regs[26]);
-	offset("#define PT_R27    ", struct pt_regs, regs[27]);
-	offset("#define PT_R28    ", struct pt_regs, regs[28]);
-	offset("#define PT_R29    ", struct pt_regs, regs[29]);
-	offset("#define PT_R30    ", struct pt_regs, regs[30]);
-	offset("#define PT_R31    ", struct pt_regs, regs[31]);
-	offset("#define PT_LO     ", struct pt_regs, lo);
-	offset("#define PT_HI     ", struct pt_regs, hi);
+	text("MIPS pt_regs offsets.");
+	offset("PT_R0", struct pt_regs, regs[0]);
+	offset("PT_R1", struct pt_regs, regs[1]);
+	offset("PT_R2", struct pt_regs, regs[2]);
+	offset("PT_R3", struct pt_regs, regs[3]);
+	offset("PT_R4", struct pt_regs, regs[4]);
+	offset("PT_R5", struct pt_regs, regs[5]);
+	offset("PT_R6", struct pt_regs, regs[6]);
+	offset("PT_R7", struct pt_regs, regs[7]);
+	offset("PT_R8", struct pt_regs, regs[8]);
+	offset("PT_R9", struct pt_regs, regs[9]);
+	offset("PT_R10", struct pt_regs, regs[10]);
+	offset("PT_R11", struct pt_regs, regs[11]);
+	offset("PT_R12", struct pt_regs, regs[12]);
+	offset("PT_R13", struct pt_regs, regs[13]);
+	offset("PT_R14", struct pt_regs, regs[14]);
+	offset("PT_R15", struct pt_regs, regs[15]);
+	offset("PT_R16", struct pt_regs, regs[16]);
+	offset("PT_R17", struct pt_regs, regs[17]);
+	offset("PT_R18", struct pt_regs, regs[18]);
+	offset("PT_R19", struct pt_regs, regs[19]);
+	offset("PT_R20", struct pt_regs, regs[20]);
+	offset("PT_R21", struct pt_regs, regs[21]);
+	offset("PT_R22", struct pt_regs, regs[22]);
+	offset("PT_R23", struct pt_regs, regs[23]);
+	offset("PT_R24", struct pt_regs, regs[24]);
+	offset("PT_R25", struct pt_regs, regs[25]);
+	offset("PT_R26", struct pt_regs, regs[26]);
+	offset("PT_R27", struct pt_regs, regs[27]);
+	offset("PT_R28", struct pt_regs, regs[28]);
+	offset("PT_R29", struct pt_regs, regs[29]);
+	offset("PT_R30", struct pt_regs, regs[30]);
+	offset("PT_R31", struct pt_regs, regs[31]);
+	offset("PT_LO", struct pt_regs, lo);
+	offset("PT_HI", struct pt_regs, hi);
 #ifdef CONFIG_CPU_HAS_SMARTMIPS
-	offset("#define PT_ACX    ", struct pt_regs, acx);
+	offset("PT_ACX", struct pt_regs, acx);
 #endif
-	offset("#define PT_EPC    ", struct pt_regs, cp0_epc);
-	offset("#define PT_BVADDR ", struct pt_regs, cp0_badvaddr);
-	offset("#define PT_STATUS ", struct pt_regs, cp0_status);
-	offset("#define PT_CAUSE  ", struct pt_regs, cp0_cause);
+	offset("PT_EPC", struct pt_regs, cp0_epc);
+	offset("PT_BVADDR", struct pt_regs, cp0_badvaddr);
+	offset("PT_STATUS", struct pt_regs, cp0_status);
+	offset("PT_CAUSE", struct pt_regs, cp0_cause);
 #ifdef CONFIG_MIPS_MT_SMTC
-	offset("#define PT_TCSTATUS  ", struct pt_regs, cp0_tcstatus);
+	offset("PT_TCSTATUS", struct pt_regs, cp0_tcstatus);
 #endif /* CONFIG_MIPS_MT_SMTC */
-	size("#define PT_SIZE   ", struct pt_regs);
+	size("PT_SIZE", struct pt_regs);
 	linefeed;
 }
 
 void output_task_defines(void)
 {
-	text("/* MIPS task_struct offsets. */");
-	offset("#define TASK_STATE         ", struct task_struct, state);
-	offset("#define TASK_THREAD_INFO   ", struct task_struct, stack);
-	offset("#define TASK_FLAGS         ", struct task_struct, flags);
-	offset("#define TASK_MM            ", struct task_struct, mm);
-	offset("#define TASK_PID           ", struct task_struct, pid);
-	size(  "#define TASK_STRUCT_SIZE   ", struct task_struct);
+	text("MIPS task_struct offsets.");
+	offset("TASK_STATE", struct task_struct, state);
+	offset("TASK_THREAD_INFO", struct task_struct, stack);
+	offset("TASK_FLAGS", struct task_struct, flags);
+	offset("TASK_MM", struct task_struct, mm);
+	offset("TASK_PID", struct task_struct, pid);
+	size(  "TASK_STRUCT_SIZE", struct task_struct);
 	linefeed;
 }
 
 void output_thread_info_defines(void)
 {
-	text("/* MIPS thread_info offsets. */");
-	offset("#define TI_TASK            ", struct thread_info, task);
-	offset("#define TI_EXEC_DOMAIN     ", struct thread_info, exec_domain);
-	offset("#define TI_FLAGS           ", struct thread_info, flags);
-	offset("#define TI_TP_VALUE	   ", struct thread_info, tp_value);
-	offset("#define TI_CPU             ", struct thread_info, cpu);
-	offset("#define TI_PRE_COUNT       ", struct thread_info, preempt_count);
-	offset("#define TI_ADDR_LIMIT      ", struct thread_info, addr_limit);
-	offset("#define TI_RESTART_BLOCK   ", struct thread_info, restart_block);
-	offset("#define TI_REGS            ", struct thread_info, regs);
-	constant("#define _THREAD_SIZE       ", THREAD_SIZE);
-	constant("#define _THREAD_MASK       ", THREAD_MASK);
+	text("MIPS thread_info offsets.");
+	offset("TI_TASK", struct thread_info, task);
+	offset("TI_EXEC_DOMAIN", struct thread_info, exec_domain);
+	offset("TI_FLAGS", struct thread_info, flags);
+	offset("TI_TP_VALUE", struct thread_info, tp_value);
+	offset("TI_CPU", struct thread_info, cpu);
+	offset("TI_PRE_COUNT", struct thread_info, preempt_count);
+	offset("TI_ADDR_LIMIT", struct thread_info, addr_limit);
+	offset("TI_RESTART_BLOCK", struct thread_info, restart_block);
+	offset("TI_REGS", struct thread_info, regs);
+	constant("_THREAD_SIZE", THREAD_SIZE);
+	constant("_THREAD_MASK", THREAD_MASK);
 	linefeed;
 }
 
 void output_thread_defines(void)
 {
-	text("/* MIPS specific thread_struct offsets. */");
-	offset("#define THREAD_REG16   ", struct task_struct, thread.reg16);
-	offset("#define THREAD_REG17   ", struct task_struct, thread.reg17);
-	offset("#define THREAD_REG18   ", struct task_struct, thread.reg18);
-	offset("#define THREAD_REG19   ", struct task_struct, thread.reg19);
-	offset("#define THREAD_REG20   ", struct task_struct, thread.reg20);
-	offset("#define THREAD_REG21   ", struct task_struct, thread.reg21);
-	offset("#define THREAD_REG22   ", struct task_struct, thread.reg22);
-	offset("#define THREAD_REG23   ", struct task_struct, thread.reg23);
-	offset("#define THREAD_REG29   ", struct task_struct, thread.reg29);
-	offset("#define THREAD_REG30   ", struct task_struct, thread.reg30);
-	offset("#define THREAD_REG31   ", struct task_struct, thread.reg31);
-	offset("#define THREAD_STATUS  ", struct task_struct,
+	text("MIPS specific thread_struct offsets.");
+	offset("THREAD_REG16", struct task_struct, thread.reg16);
+	offset("THREAD_REG17", struct task_struct, thread.reg17);
+	offset("THREAD_REG18", struct task_struct, thread.reg18);
+	offset("THREAD_REG19", struct task_struct, thread.reg19);
+	offset("THREAD_REG20", struct task_struct, thread.reg20);
+	offset("THREAD_REG21", struct task_struct, thread.reg21);
+	offset("THREAD_REG22", struct task_struct, thread.reg22);
+	offset("THREAD_REG23", struct task_struct, thread.reg23);
+	offset("THREAD_REG29", struct task_struct, thread.reg29);
+	offset("THREAD_REG30", struct task_struct, thread.reg30);
+	offset("THREAD_REG31", struct task_struct, thread.reg31);
+	offset("THREAD_STATUS", struct task_struct,
 	       thread.cp0_status);
-	offset("#define THREAD_FPU     ", struct task_struct, thread.fpu);
+	offset("THREAD_FPU", struct task_struct, thread.fpu);
 
-	offset("#define THREAD_BVADDR  ", struct task_struct, \
+	offset("THREAD_BVADDR", struct task_struct, \
 	       thread.cp0_badvaddr);
-	offset("#define THREAD_BUADDR  ", struct task_struct, \
+	offset("THREAD_BUADDR", struct task_struct, \
 	       thread.cp0_baduaddr);
-	offset("#define THREAD_ECODE   ", struct task_struct, \
+	offset("THREAD_ECODE", struct task_struct, \
 	       thread.error_code);
-	offset("#define THREAD_TRAPNO  ", struct task_struct, thread.trap_no);
-	offset("#define THREAD_TRAMP   ", struct task_struct, \
+	offset("THREAD_TRAPNO", struct task_struct, thread.trap_no);
+	offset("THREAD_TRAMP", struct task_struct, \
 	       thread.irix_trampoline);
-	offset("#define THREAD_OLDCTX  ", struct task_struct, \
+	offset("THREAD_OLDCTX", struct task_struct, \
 	       thread.irix_oldctx);
 	linefeed;
 }
 
 void output_thread_fpu_defines(void)
 {
-	offset("#define THREAD_FPR0    ",
+	offset("THREAD_FPR0",
 	       struct task_struct, thread.fpu.fpr[0]);
-	offset("#define THREAD_FPR1    ",
+	offset("THREAD_FPR1",
 	       struct task_struct, thread.fpu.fpr[1]);
-	offset("#define THREAD_FPR2    ",
+	offset("THREAD_FPR2",
 	       struct task_struct, thread.fpu.fpr[2]);
-	offset("#define THREAD_FPR3    ",
+	offset("THREAD_FPR3",
 	       struct task_struct, thread.fpu.fpr[3]);
-	offset("#define THREAD_FPR4    ",
+	offset("THREAD_FPR4",
 	       struct task_struct, thread.fpu.fpr[4]);
-	offset("#define THREAD_FPR5    ",
+	offset("THREAD_FPR5",
 	       struct task_struct, thread.fpu.fpr[5]);
-	offset("#define THREAD_FPR6    ",
+	offset("THREAD_FPR6",
 	       struct task_struct, thread.fpu.fpr[6]);
-	offset("#define THREAD_FPR7    ",
+	offset("THREAD_FPR7",
 	       struct task_struct, thread.fpu.fpr[7]);
-	offset("#define THREAD_FPR8    ",
+	offset("THREAD_FPR8",
 	       struct task_struct, thread.fpu.fpr[8]);
-	offset("#define THREAD_FPR9    ",
+	offset("THREAD_FPR9",
 	       struct task_struct, thread.fpu.fpr[9]);
-	offset("#define THREAD_FPR10   ",
+	offset("THREAD_FPR10",
 	       struct task_struct, thread.fpu.fpr[10]);
-	offset("#define THREAD_FPR11   ",
+	offset("THREAD_FPR11",
 	       struct task_struct, thread.fpu.fpr[11]);
-	offset("#define THREAD_FPR12   ",
+	offset("THREAD_FPR12",
 	       struct task_struct, thread.fpu.fpr[12]);
-	offset("#define THREAD_FPR13   ",
+	offset("THREAD_FPR13",
 	       struct task_struct, thread.fpu.fpr[13]);
-	offset("#define THREAD_FPR14   ",
+	offset("THREAD_FPR14",
 	       struct task_struct, thread.fpu.fpr[14]);
-	offset("#define THREAD_FPR15   ",
+	offset("THREAD_FPR15",
 	       struct task_struct, thread.fpu.fpr[15]);
-	offset("#define THREAD_FPR16   ",
+	offset("THREAD_FPR16",
 	       struct task_struct, thread.fpu.fpr[16]);
-	offset("#define THREAD_FPR17   ",
+	offset("THREAD_FPR17",
 	       struct task_struct, thread.fpu.fpr[17]);
-	offset("#define THREAD_FPR18   ",
+	offset("THREAD_FPR18",
 	       struct task_struct, thread.fpu.fpr[18]);
-	offset("#define THREAD_FPR19   ",
+	offset("THREAD_FPR19",
 	       struct task_struct, thread.fpu.fpr[19]);
-	offset("#define THREAD_FPR20   ",
+	offset("THREAD_FPR20",
 	       struct task_struct, thread.fpu.fpr[20]);
-	offset("#define THREAD_FPR21   ",
+	offset("THREAD_FPR21",
 	       struct task_struct, thread.fpu.fpr[21]);
-	offset("#define THREAD_FPR22   ",
+	offset("THREAD_FPR22",
 	       struct task_struct, thread.fpu.fpr[22]);
-	offset("#define THREAD_FPR23   ",
+	offset("THREAD_FPR23",
 	       struct task_struct, thread.fpu.fpr[23]);
-	offset("#define THREAD_FPR24   ",
+	offset("THREAD_FPR24",
 	       struct task_struct, thread.fpu.fpr[24]);
-	offset("#define THREAD_FPR25   ",
+	offset("THREAD_FPR25",
 	       struct task_struct, thread.fpu.fpr[25]);
-	offset("#define THREAD_FPR26   ",
+	offset("THREAD_FPR26",
 	       struct task_struct, thread.fpu.fpr[26]);
-	offset("#define THREAD_FPR27   ",
+	offset("THREAD_FPR27",
 	       struct task_struct, thread.fpu.fpr[27]);
-	offset("#define THREAD_FPR28   ",
+	offset("THREAD_FPR28",
 	       struct task_struct, thread.fpu.fpr[28]);
-	offset("#define THREAD_FPR29   ",
+	offset("THREAD_FPR29",
 	       struct task_struct, thread.fpu.fpr[29]);
-	offset("#define THREAD_FPR30   ",
+	offset("THREAD_FPR30",
 	       struct task_struct, thread.fpu.fpr[30]);
-	offset("#define THREAD_FPR31   ",
+	offset("THREAD_FPR31",
 	       struct task_struct, thread.fpu.fpr[31]);
 
-	offset("#define THREAD_FCR31   ",
+	offset("THREAD_FCR31",
 	       struct task_struct, thread.fpu.fcr31);
 	linefeed;
 }
 
 void output_mm_defines(void)
 {
-	text("/* Size of struct page  */");
-	size("#define STRUCT_PAGE_SIZE   ", struct page);
+	text("Size of struct page");
+	size("STRUCT_PAGE_SIZE", struct page);
 	linefeed;
-	text("/* Linux mm_struct offsets. */");
-	offset("#define MM_USERS      ", struct mm_struct, mm_users);
-	offset("#define MM_PGD        ", struct mm_struct, pgd);
-	offset("#define MM_CONTEXT    ", struct mm_struct, context);
-	linefeed;
-	constant("#define _PAGE_SIZE     ", PAGE_SIZE);
-	constant("#define _PAGE_SHIFT    ", PAGE_SHIFT);
-	linefeed;
-	constant("#define _PGD_T_SIZE    ", sizeof(pgd_t));
-	constant("#define _PMD_T_SIZE    ", sizeof(pmd_t));
-	constant("#define _PTE_T_SIZE    ", sizeof(pte_t));
-	linefeed;
-	constant("#define _PGD_T_LOG2    ", PGD_T_LOG2);
-	constant("#define _PMD_T_LOG2    ", PMD_T_LOG2);
-	constant("#define _PTE_T_LOG2    ", PTE_T_LOG2);
-	linefeed;
-	constant("#define _PGD_ORDER     ", PGD_ORDER);
-	constant("#define _PMD_ORDER     ", PMD_ORDER);
-	constant("#define _PTE_ORDER     ", PTE_ORDER);
-	linefeed;
-	constant("#define _PMD_SHIFT     ", PMD_SHIFT);
-	constant("#define _PGDIR_SHIFT   ", PGDIR_SHIFT);
-	linefeed;
-	constant("#define _PTRS_PER_PGD  ", PTRS_PER_PGD);
-	constant("#define _PTRS_PER_PMD  ", PTRS_PER_PMD);
-	constant("#define _PTRS_PER_PTE  ", PTRS_PER_PTE);
+	text("Linux mm_struct offsets.");
+	offset("MM_USERS", struct mm_struct, mm_users);
+	offset("MM_PGD", struct mm_struct, pgd);
+	offset("MM_CONTEXT", struct mm_struct, context);
+	linefeed;
+	constant("_PAGE_SIZE", PAGE_SIZE);
+	constant("_PAGE_SHIFT", PAGE_SHIFT);
+	linefeed;
+	constant("_PGD_T_SIZE", sizeof(pgd_t));
+	constant("_PMD_T_SIZE", sizeof(pmd_t));
+	constant("_PTE_T_SIZE", sizeof(pte_t));
+	linefeed;
+	constant("_PGD_T_LOG2", PGD_T_LOG2);
+	constant("_PMD_T_LOG2", PMD_T_LOG2);
+	constant("_PTE_T_LOG2", PTE_T_LOG2);
+	linefeed;
+	constant("_PGD_ORDER", PGD_ORDER);
+	constant("_PMD_ORDER", PMD_ORDER);
+	constant("_PTE_ORDER", PTE_ORDER);
+	linefeed;
+	constant("_PMD_SHIFT", PMD_SHIFT);
+	constant("_PGDIR_SHIFT", PGDIR_SHIFT);
+	linefeed;
+	constant("_PTRS_PER_PGD", PTRS_PER_PGD);
+	constant("_PTRS_PER_PMD", PTRS_PER_PMD);
+	constant("_PTRS_PER_PTE", PTRS_PER_PTE);
 	linefeed;
 }
 
 #ifdef CONFIG_32BIT
 void output_sc_defines(void)
 {
-	text("/* Linux sigcontext offsets. */");
-	offset("#define SC_REGS       ", struct sigcontext, sc_regs);
-	offset("#define SC_FPREGS     ", struct sigcontext, sc_fpregs);
-	offset("#define SC_ACX        ", struct sigcontext, sc_acx);
-	offset("#define SC_MDHI       ", struct sigcontext, sc_mdhi);
-	offset("#define SC_MDLO       ", struct sigcontext, sc_mdlo);
-	offset("#define SC_PC         ", struct sigcontext, sc_pc);
-	offset("#define SC_FPC_CSR    ", struct sigcontext, sc_fpc_csr);
-	offset("#define SC_FPC_EIR    ", struct sigcontext, sc_fpc_eir);
-	offset("#define SC_HI1        ", struct sigcontext, sc_hi1);
-	offset("#define SC_LO1        ", struct sigcontext, sc_lo1);
-	offset("#define SC_HI2        ", struct sigcontext, sc_hi2);
-	offset("#define SC_LO2        ", struct sigcontext, sc_lo2);
-	offset("#define SC_HI3        ", struct sigcontext, sc_hi3);
-	offset("#define SC_LO3        ", struct sigcontext, sc_lo3);
+	text("Linux sigcontext offsets.");
+	offset("SC_REGS", struct sigcontext, sc_regs);
+	offset("SC_FPREGS", struct sigcontext, sc_fpregs);
+	offset("SC_ACX", struct sigcontext, sc_acx);
+	offset("SC_MDHI", struct sigcontext, sc_mdhi);
+	offset("SC_MDLO", struct sigcontext, sc_mdlo);
+	offset("SC_PC", struct sigcontext, sc_pc);
+	offset("SC_FPC_CSR", struct sigcontext, sc_fpc_csr);
+	offset("SC_FPC_EIR", struct sigcontext, sc_fpc_eir);
+	offset("SC_HI1", struct sigcontext, sc_hi1);
+	offset("SC_LO1", struct sigcontext, sc_lo1);
+	offset("SC_HI2", struct sigcontext, sc_hi2);
+	offset("SC_LO2", struct sigcontext, sc_lo2);
+	offset("SC_HI3", struct sigcontext, sc_hi3);
+	offset("SC_LO3", struct sigcontext, sc_lo3);
 	linefeed;
 }
 #endif
@@ -270,13 +270,13 @@ void output_sc_defines(void)
 #ifdef CONFIG_64BIT
 void output_sc_defines(void)
 {
-	text("/* Linux sigcontext offsets. */");
-	offset("#define SC_REGS       ", struct sigcontext, sc_regs);
-	offset("#define SC_FPREGS     ", struct sigcontext, sc_fpregs);
-	offset("#define SC_MDHI       ", struct sigcontext, sc_mdhi);
-	offset("#define SC_MDLO       ", struct sigcontext, sc_mdlo);
-	offset("#define SC_PC         ", struct sigcontext, sc_pc);
-	offset("#define SC_FPC_CSR    ", struct sigcontext, sc_fpc_csr);
+	text("Linux sigcontext offsets.");
+	offset("SC_REGS", struct sigcontext, sc_regs);
+	offset("SC_FPREGS", struct sigcontext, sc_fpregs);
+	offset("SC_MDHI", struct sigcontext, sc_mdhi);
+	offset("SC_MDLO", struct sigcontext, sc_mdlo);
+	offset("SC_PC", struct sigcontext, sc_pc);
+	offset("SC_FPC_CSR", struct sigcontext, sc_fpc_csr);
 	linefeed;
 }
 #endif
@@ -284,56 +284,56 @@ void output_sc_defines(void)
 #ifdef CONFIG_MIPS32_COMPAT
 void output_sc32_defines(void)
 {
-	text("/* Linux 32-bit sigcontext offsets. */");
-	offset("#define SC32_FPREGS     ", struct sigcontext32, sc_fpregs);
-	offset("#define SC32_FPC_CSR    ", struct sigcontext32, sc_fpc_csr);
-	offset("#define SC32_FPC_EIR    ", struct sigcontext32, sc_fpc_eir);
+	text("Linux 32-bit sigcontext offsets.");
+	offset("SC32_FPREGS", struct sigcontext32, sc_fpregs);
+	offset("SC32_FPC_CSR", struct sigcontext32, sc_fpc_csr);
+	offset("SC32_FPC_EIR", struct sigcontext32, sc_fpc_eir);
 	linefeed;
 }
 #endif
 
 void output_signal_defined(void)
 {
-	text("/* Linux signal numbers. */");
-	constant("#define _SIGHUP     ", SIGHUP);
-	constant("#define _SIGINT     ", SIGINT);
-	constant("#define _SIGQUIT    ", SIGQUIT);
-	constant("#define _SIGILL     ", SIGILL);
-	constant("#define _SIGTRAP    ", SIGTRAP);
-	constant("#define _SIGIOT     ", SIGIOT);
-	constant("#define _SIGABRT    ", SIGABRT);
-	constant("#define _SIGEMT     ", SIGEMT);
-	constant("#define _SIGFPE     ", SIGFPE);
-	constant("#define _SIGKILL    ", SIGKILL);
-	constant("#define _SIGBUS     ", SIGBUS);
-	constant("#define _SIGSEGV    ", SIGSEGV);
-	constant("#define _SIGSYS     ", SIGSYS);
-	constant("#define _SIGPIPE    ", SIGPIPE);
-	constant("#define _SIGALRM    ", SIGALRM);
-	constant("#define _SIGTERM    ", SIGTERM);
-	constant("#define _SIGUSR1    ", SIGUSR1);
-	constant("#define _SIGUSR2    ", SIGUSR2);
-	constant("#define _SIGCHLD    ", SIGCHLD);
-	constant("#define _SIGPWR     ", SIGPWR);
-	constant("#define _SIGWINCH   ", SIGWINCH);
-	constant("#define _SIGURG     ", SIGURG);
-	constant("#define _SIGIO      ", SIGIO);
-	constant("#define _SIGSTOP    ", SIGSTOP);
-	constant("#define _SIGTSTP    ", SIGTSTP);
-	constant("#define _SIGCONT    ", SIGCONT);
-	constant("#define _SIGTTIN    ", SIGTTIN);
-	constant("#define _SIGTTOU    ", SIGTTOU);
-	constant("#define _SIGVTALRM  ", SIGVTALRM);
-	constant("#define _SIGPROF    ", SIGPROF);
-	constant("#define _SIGXCPU    ", SIGXCPU);
-	constant("#define _SIGXFSZ    ", SIGXFSZ);
+	text("Linux signal numbers.");
+	constant("_SIGHUP", SIGHUP);
+	constant("_SIGINT", SIGINT);
+	constant("_SIGQUIT", SIGQUIT);
+	constant("_SIGILL", SIGILL);
+	constant("_SIGTRAP", SIGTRAP);
+	constant("_SIGIOT", SIGIOT);
+	constant("_SIGABRT", SIGABRT);
+	constant("_SIGEMT", SIGEMT);
+	constant("_SIGFPE", SIGFPE);
+	constant("_SIGKILL", SIGKILL);
+	constant("_SIGBUS", SIGBUS);
+	constant("_SIGSEGV", SIGSEGV);
+	constant("_SIGSYS", SIGSYS);
+	constant("_SIGPIPE", SIGPIPE);
+	constant("_SIGALRM", SIGALRM);
+	constant("_SIGTERM", SIGTERM);
+	constant("_SIGUSR1", SIGUSR1);
+	constant("_SIGUSR2", SIGUSR2);
+	constant("_SIGCHLD", SIGCHLD);
+	constant("_SIGPWR", SIGPWR);
+	constant("_SIGWINCH", SIGWINCH);
+	constant("_SIGURG", SIGURG);
+	constant("_SIGIO", SIGIO);
+	constant("_SIGSTOP", SIGSTOP);
+	constant("_SIGTSTP", SIGTSTP);
+	constant("_SIGCONT", SIGCONT);
+	constant("_SIGTTIN", SIGTTIN);
+	constant("_SIGTTOU", SIGTTOU);
+	constant("_SIGVTALRM", SIGVTALRM);
+	constant("_SIGPROF", SIGPROF);
+	constant("_SIGXCPU", SIGXCPU);
+	constant("_SIGXFSZ", SIGXFSZ);
 	linefeed;
 }
 
 void output_irq_cpustat_t_defines(void)
 {
-	text("/* Linux irq_cpustat_t offsets. */");
-	offset("#define IC_SOFTIRQ_PENDING ", irq_cpustat_t, __softirq_pending);
-	size("#define IC_IRQ_CPUSTAT_T   ", irq_cpustat_t);
+	text("Linux irq_cpustat_t offsets.");
+	offset("IC_SOFTIRQ_PENDING", irq_cpustat_t, __softirq_pending);
+	size("IC_IRQ_CPUSTAT_T", irq_cpustat_t);
 	linefeed;
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

git-x86.patch
git-ia64.patch
git-unionfs.patch
git-pekka.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mm-make-mem_map-allocation-continuous-v2.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-get-rid-of-flags_reserved-sparc64-fix.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
page-flags-handle-pg_uncached-like-all-other-flags.patch
page-flags-add-pageflags_false-for-flags-that-are-always-false.patch
mm-get-rid-of-__zone_count.patch
pageflags_extended-and-separate-page-flags-for-head-and-tail.patch
mm-remove-unused-max_nodes_shift.patch
vmcoreinfo-add-page-flags-values.patch
mempolicy-rename-mpol_free-to-mpol_put.patch
mempolicy-rename-mpol_copy-to-mpol_dup.patch
mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
mempolicy-fixup-fallback-for-default-shmem-policy.patch
mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
mempolicy-mark-shared-policies-for-unref.patch
mempolicy-document-setget_policy-vm_ops-apis.patch
mempolicy-rework-mempolicy-reference-counting.patch
mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
mempolicy-rework-shmem-mpol-parsing-and-display.patch
mempolicy-support-mpol=local-tmpfs-mount-option.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

