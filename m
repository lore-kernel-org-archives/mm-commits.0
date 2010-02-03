From: akpm@linux-foundation.org
Subject: + ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:08:39 -0800
Message-ID: <201002032208.o13M8es5021990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab0BCWJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: move user_enable_single_step & co prototypes to linux/ptrace.h
has been added to the -mm tree.  Its filename is
     ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: move user_enable_single_step & co prototypes to linux/ptrace.h
From: Christoph Hellwig <hch@lst.de>

While in theory user_enable_single_step/user_disable_single_step/
user_enable_blockstep could also be provided as an inline or macro there's
no good reason to do so, and having the prototype in one places keeps code
size and confusion down.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/ptrace.h     |    2 --
 arch/ia64/include/asm/ptrace.h    |    4 ----
 arch/m68k/include/asm/ptrace.h    |    8 --------
 arch/mn10300/include/asm/ptrace.h |    2 --
 arch/parisc/include/asm/ptrace.h  |    5 -----
 arch/powerpc/include/asm/ptrace.h |    7 -------
 arch/s390/include/asm/ptrace.h    |    4 ----
 arch/score/include/asm/ptrace.h   |    3 +--
 arch/sh/include/asm/ptrace.h      |    2 --
 arch/x86/include/asm/ptrace.h     |    7 -------
 include/linux/ptrace.h            |    5 +++++
 11 files changed, 6 insertions(+), 43 deletions(-)

diff -puN arch/frv/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/frv/include/asm/ptrace.h
--- a/arch/frv/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/frv/include/asm/ptrace.h
@@ -84,8 +84,6 @@ extern void show_regs(struct pt_regs *);
 #define task_pt_regs(task) ((task)->thread.frame0)
 
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 
 #endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
diff -puN arch/ia64/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/ia64/include/asm/ptrace.h
--- a/arch/ia64/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/ia64/include/asm/ptrace.h
@@ -319,11 +319,7 @@ static inline unsigned long user_stack_p
 	ptrace_attach_sync_user_rbs(child)
 
   #define arch_has_single_step()  (1)
-  extern void user_enable_single_step(struct task_struct *);
-  extern void user_disable_single_step(struct task_struct *);
-
   #define arch_has_block_step()   (1)
-  extern void user_enable_block_step(struct task_struct *);
 
 #endif /* !__KERNEL__ */
 
diff -puN arch/m68k/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/m68k/include/asm/ptrace.h
--- a/arch/m68k/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/m68k/include/asm/ptrace.h
@@ -85,18 +85,10 @@ struct switch_stack {
 #define profile_pc(regs) instruction_pointer(regs)
 extern void show_regs(struct pt_regs *);
 
-/*
- * These are defined as per linux/ptrace.h.
- */
-struct task_struct;
-
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 
 #ifdef CONFIG_MMU
 #define arch_has_block_step()	(1)
-extern void user_enable_block_step(struct task_struct *);
 #endif
 
 #endif /* __KERNEL__ */
diff -puN arch/mn10300/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/mn10300/include/asm/ptrace.h
--- a/arch/mn10300/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/mn10300/include/asm/ptrace.h
@@ -99,8 +99,6 @@ struct task_struct;
 extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 
 #endif  /*  !__ASSEMBLY  */
 
diff -puN arch/parisc/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/parisc/include/asm/ptrace.h
--- a/arch/parisc/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/parisc/include/asm/ptrace.h
@@ -47,13 +47,8 @@ struct pt_regs {
 
 #define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
 
-struct task_struct;
 #define arch_has_single_step()	1
-void user_disable_single_step(struct task_struct *task);
-void user_enable_single_step(struct task_struct *task);
-
 #define arch_has_block_step()	1
-void user_enable_block_step(struct task_struct *task);
 
 /* XXX should we use iaoq[1] or iaoq[0] ? */
 #define user_mode(regs)			(((regs)->iaoq[0] & 3) ? 1 : 0)
diff -puN arch/powerpc/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/powerpc/include/asm/ptrace.h
--- a/arch/powerpc/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/powerpc/include/asm/ptrace.h
@@ -131,15 +131,8 @@ do {									      \
 } while (0)
 #endif /* __powerpc64__ */
 
-/*
- * These are defined as per linux/ptrace.h, which see.
- */
 #define arch_has_single_step()	(1)
 #define arch_has_block_step()	(!cpu_has_feature(CPU_FTR_601))
-extern void user_enable_single_step(struct task_struct *);
-extern void user_enable_block_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
-
 #define ARCH_HAS_USER_SINGLE_STEP_INFO
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/s390/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/s390/include/asm/ptrace.h
--- a/arch/s390/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/s390/include/asm/ptrace.h
@@ -489,10 +489,6 @@ struct user_regs_struct
  * These are defined as per linux/ptrace.h, which see.
  */
 #define arch_has_single_step()	(1)
-struct task_struct;
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
-
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
 #define user_stack_pointer(regs)((regs)->gprs[15])
diff -puN arch/score/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/score/include/asm/ptrace.h
--- a/arch/score/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/score/include/asm/ptrace.h
@@ -90,8 +90,7 @@ extern int read_tsk_short(struct task_st
 			 unsigned short *);
 
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_SCORE_PTRACE_H */
diff -puN arch/sh/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/sh/include/asm/ptrace.h
--- a/arch/sh/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/sh/include/asm/ptrace.h
@@ -121,8 +121,6 @@ extern void show_regs(struct pt_regs *);
 struct task_struct;
 
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 
 struct perf_event;
 struct perf_sample_data;
diff -puN arch/x86/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh arch/x86/include/asm/ptrace.h
--- a/arch/x86/include/asm/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/arch/x86/include/asm/ptrace.h
@@ -274,14 +274,7 @@ static inline unsigned long regs_get_ker
 		return 0;
 }
 
-/*
- * These are defined as per linux/ptrace.h, which see.
- */
 #define arch_has_single_step()	(1)
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
-
-extern void user_enable_block_step(struct task_struct *);
 #ifdef CONFIG_X86_DEBUGCTLMSR
 #define arch_has_block_step()	(1)
 #else
diff -puN include/linux/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh
+++ a/include/linux/ptrace.h
@@ -244,6 +244,9 @@ static inline void user_enable_single_st
 static inline void user_disable_single_step(struct task_struct *task)
 {
 }
+#else
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
 #endif	/* arch_has_single_step */
 
 #ifndef arch_has_block_step
@@ -271,6 +274,8 @@ static inline void user_enable_block_ste
 {
 	BUG();			/* This can never be called.  */
 }
+#else
+extern void user_enable_block_step(struct task_struct *);
 #endif	/* arch_has_block_step */
 
 #ifdef ARCH_HAS_USER_SINGLE_STEP_INFO
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
add-generic-sys_old_select.patch
add-generic-sys_old_select-fix.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch
ptrace-use-ptrace_request-in-the-remaining-architectures.patch
ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch
alpha-use-generic-ptrace_resume-code.patch
arm-use-generic-ptrace_resume-code.patch
avr32-use-generic-ptrace_resume-code.patch
blackfin-use-generic-ptrace_resume-code.patch
h8300-use-generic-ptrace_resume-code.patch
m68knommu-use-generic-ptrace_resume-code.patch
microblaze-use-generic-ptrace_resume-code.patch
mips-use-generic-ptrace_resume-code.patch
um-use-generic-ptrace_resume-code.patch
xtensa-use-generic-ptrace_resume-code.patch
cris-arch-v10-use-generic-ptrace_resume-code.patch
cris-arch-v32-use-generic-ptrace_resume-code.patch
m32r-use-generic-ptrace_resume-code.patch

