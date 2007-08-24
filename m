From: akpm@linux-foundation.org
Subject: + uml-coredumping-floating-point-fixes.patch added to -mm tree
Date: Thu, 23 Aug 2007 17:10:01 -0700
Message-ID: <200708240010.l7O0A2gf001540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933910AbXHXAKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 20:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: coredumping floating point fixes
has been added to the -mm tree.  Its filename is
     uml-coredumping-floating-point-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: coredumping floating point fixes
From: Jeff Dike <jdike@addtoit.com>

Fix core dumping of floating point state.  ELF_CORE_COPY_FPREGS gets a
definitions, and as a result, dump_fpu no longer needs to exist.  Also,
elf_fpregset_t needed a real definition.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/ptrace.c   |   22 ----------------------
 include/asm-um/elf-i386.h   |   12 +++++++++++-
 include/asm-um/elf-x86_64.h |    2 +-
 3 files changed, 12 insertions(+), 24 deletions(-)

diff -puN arch/um/sys-i386/ptrace.c~uml-coredumping-floating-point-fixes arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-coredumping-floating-point-fixes
+++ a/arch/um/sys-i386/ptrace.c
@@ -205,28 +205,6 @@ int set_fpxregs(struct user_fxsr_struct 
 	return restore_fpx_registers(userspace_pid[cpu], fpregs);
 }
 
-#ifdef notdef
-int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
-{
-	fpu->cwd = (((SC_FP_CW(PT_REGS_SC(regs)) & 0xffff) << 16) |
-		    (SC_FP_SW(PT_REGS_SC(regs)) & 0xffff));
-	fpu->swd = SC_FP_CSSEL(PT_REGS_SC(regs)) & 0xffff;
-	fpu->twd = SC_FP_IPOFF(PT_REGS_SC(regs));
-	fpu->fip = SC_FP_CSSEL(PT_REGS_SC(regs)) & 0xffff;
-	fpu->fcs = SC_FP_DATAOFF(PT_REGS_SC(regs));
-	fpu->foo = SC_FP_DATASEL(PT_REGS_SC(regs));
-	fpu->fos = 0;
-	memcpy(fpu->st_space, (void *) SC_FP_ST(PT_REGS_SC(regs)),
-	       sizeof(fpu->st_space));
-	return 1;
-}
-#endif
-
-int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu )
-{
-	return 1;
-}
-
 long subarch_ptrace(struct task_struct *child, long request, long addr,
 		    long data)
 {
diff -puN include/asm-um/elf-i386.h~uml-coredumping-floating-point-fixes include/asm-um/elf-i386.h
--- a/include/asm-um/elf-i386.h~uml-coredumping-floating-point-fixes
+++ a/include/asm-um/elf-i386.h
@@ -5,7 +5,8 @@
 #ifndef __UM_ELF_I386_H
 #define __UM_ELF_I386_H
 
-#include <asm/user.h>
+#include <linux/sched.h>
+#include "skas.h"
 
 #define R_386_NONE	0
 #define R_386_32	1
@@ -75,6 +76,15 @@ typedef struct user_i387_struct elf_fpre
 	pr_reg[16] = PT_REGS_SS(regs);		\
 } while(0);
 
+static inline int elf_core_copy_fpregs(struct task_struct *t,
+				       elf_fpregset_t *fpu)
+{
+	int cpu = ((struct thread_info *) t->stack)->cpu;
+	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
+}
+
+#define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
+
 extern long elf_aux_hwcap;
 #define ELF_HWCAP (elf_aux_hwcap)
 
diff -puN include/asm-um/elf-x86_64.h~uml-coredumping-floating-point-fixes include/asm-um/elf-x86_64.h
--- a/include/asm-um/elf-x86_64.h~uml-coredumping-floating-point-fixes
+++ a/include/asm-um/elf-x86_64.h
@@ -36,7 +36,7 @@ typedef unsigned long elf_greg_t;
 #define ELF_NGREG (sizeof (struct user_regs_struct) / sizeof(elf_greg_t))
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 
-typedef struct { } elf_fpregset_t;
+typedef struct user_i387_struct elf_fpregset_t;
 
 /*
  * This is used to ensure we don't load something for the wrong architecture.
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
