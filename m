From: akpm@linux-foundation.org
Subject: + uml-fix-x86_64-core-dump-crash.patch added to -mm tree
Date: Wed, 22 Aug 2007 14:49:30 -0700
Message-ID: <200708222149.l7MLnUxo006407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763226AbXHVVtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 17:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix x86_64 core dump crash
has been added to the -mm tree.  Its filename is
     uml-fix-x86_64-core-dump-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix x86_64 core dump crash
From: Jeff Dike <jdike@addtoit.com>

Stop UML crashing when trying to dump a process core on x86_64.  This is the
minimal fix to stop the crash - more things are broken here, and patches are
forthcoming.

The immediate thing to do is define ELF_CORE_COPY_REGS and
ELF_CORE_COPY_FPREGS.  Defining ELF_CORE_COPY_FPREGS allows dump_fpu to go
away.  It is defined in terms of save_fp_registers, so that needs to be added.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sys-x86_64/registers.c |   15 ++++++++
 arch/um/sys-x86_64/ptrace.c             |    6 ---
 include/asm-um/elf-x86_64.h             |   40 ++++++++++++++++++++++
 3 files changed, 55 insertions(+), 6 deletions(-)

diff -puN arch/um/os-Linux/sys-x86_64/registers.c~uml-fix-x86_64-core-dump-crash arch/um/os-Linux/sys-x86_64/registers.c
--- a/arch/um/os-Linux/sys-x86_64/registers.c~uml-fix-x86_64-core-dump-crash
+++ a/arch/um/os-Linux/sys-x86_64/registers.c
@@ -4,6 +4,7 @@
  */
 
 #include <errno.h>
+#include <sys/ptrace.h>
 #include <string.h>
 #include "ptrace_user.h"
 #include "uml-config.h"
@@ -17,6 +18,20 @@
 static unsigned long exec_regs[MAX_REG_NR];
 static unsigned long exec_fp_regs[HOST_FP_SIZE];
 
+int save_fp_registers(int pid, unsigned long *fp_regs)
+{
+	if(ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
+		return -errno;
+	return 0;
+}
+
+int restore_fp_registers(int pid, unsigned long *fp_regs)
+{
+	if(ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
+		return -errno;
+	return 0;
+}
+
 void init_thread_registers(union uml_pt_regs *to)
 {
 	memcpy(to->skas.regs, exec_regs, sizeof(to->skas.regs));
diff -puN arch/um/sys-x86_64/ptrace.c~uml-fix-x86_64-core-dump-crash arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~uml-fix-x86_64-core-dump-crash
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -156,12 +156,6 @@ int is_syscall(unsigned long addr)
 	return(instr == 0x050f);
 }
 
-int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu )
-{
-	panic("dump_fpu");
-	return(1);
-}
-
 int get_fpregs(unsigned long buf, struct task_struct *child)
 {
 	panic("get_fpregs");
diff -puN include/asm-um/elf-x86_64.h~uml-fix-x86_64-core-dump-crash include/asm-um/elf-x86_64.h
--- a/include/asm-um/elf-x86_64.h~uml-fix-x86_64-core-dump-crash
+++ a/include/asm-um/elf-x86_64.h
@@ -6,7 +6,9 @@
 #ifndef __UM_ELF_X86_64_H
 #define __UM_ELF_X86_64_H
 
+#include <linux/sched.h>
 #include <asm/user.h>
+#include "skas.h"
 
 /* x86-64 relocation types, taken from asm-x86_64/elf.h */
 #define R_X86_64_NONE		0	/* No reloc */
@@ -64,6 +66,44 @@ typedef struct { } elf_fpregset_t;
 	PT_REGS_R15(regs) = 0; \
 } while (0)
 
+#define ELF_CORE_COPY_REGS(pr_reg, regs)		\
+	(pr_reg)[0] = (regs)->regs.gp[0];			\
+	(pr_reg)[1] = (regs)->regs.gp[1];			\
+	(pr_reg)[2] = (regs)->regs.gp[2];			\
+	(pr_reg)[3] = (regs)->regs.gp[3];			\
+	(pr_reg)[4] = (regs)->regs.gp[4];			\
+	(pr_reg)[5] = (regs)->regs.gp[5];			\
+	(pr_reg)[6] = (regs)->regs.gp[6];			\
+	(pr_reg)[7] = (regs)->regs.gp[7];			\
+	(pr_reg)[8] = (regs)->regs.gp[8];			\
+	(pr_reg)[9] = (regs)->regs.gp[9];			\
+	(pr_reg)[10] = (regs)->regs.gp[10];			\
+	(pr_reg)[11] = (regs)->regs.gp[11];			\
+	(pr_reg)[12] = (regs)->regs.gp[12];			\
+	(pr_reg)[13] = (regs)->regs.gp[13];			\
+	(pr_reg)[14] = (regs)->regs.gp[14];			\
+	(pr_reg)[15] = (regs)->regs.gp[15];			\
+	(pr_reg)[16] = (regs)->regs.gp[16];			\
+	(pr_reg)[17] = (regs)->regs.gp[17];			\
+	(pr_reg)[18] = (regs)->regs.gp[18];			\
+	(pr_reg)[19] = (regs)->regs.gp[19];			\
+	(pr_reg)[20] = (regs)->regs.gp[20];			\
+	(pr_reg)[21] = current->thread.arch.fs;			\
+	(pr_reg)[22] = 0;					\
+	(pr_reg)[23] = 0;					\
+	(pr_reg)[24] = 0;					\
+	(pr_reg)[25] = 0;					\
+	(pr_reg)[26] = 0;
+
+static inline int elf_core_copy_fpregs(struct task_struct *t,
+				       elf_fpregset_t *fpu)
+{
+	int cpu = current_thread->cpu;
+	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
+}
+
+#define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
+
 #ifdef TIF_IA32 /* XXX */
 #error XXX, indeed
         clear_thread_flag(TIF_IA32);
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
