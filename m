From: akpm@linux-foundation.org
Subject: [merged] ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:29 -0400
Message-ID: <201003150701.o2F713c7016675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, dhowells@redhat.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: move user_enable_single_step & co prototypes to linux/ptrace.h
has been removed from the -mm tree.  Its filename was
     ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: move user_enable_single_step & co prototypes to linux/ptrace.h
From: Christoph Hellwig <hch@lst.de>

While in theory user_enable_single_step/user_disable_single_step/
user_enable_blockstep could also be provided as an inline or macro there's
no good reason to do so, and having the prototype in one places keeps code
size and confusion down.

Roland said:

  The original thought there was that user_enable_single_step() et al
  might well be only an instruction or three on a sane machine (as if we
  have any of those!), and since there is only one call site inlining
  would be beneficial.  But I agree that there is no strong reason to care
  about inlining it.

  As to the arch changes, there is only one thought I'd add to the
  record.  It was always my thinking that for an arch where
  PTRACE_SINGLESTEP does text-modifying breakpoint insertion,
  user_enable_single_step() should not be provided.  That is,
  arch_has_single_step()=>true means that there is an arch facility with
  "pure" semantics that does not have any unexpected side effects. 
  Inserting a breakpoint might do very unexpected strange things in
  multi-threaded situations.  Aside from that, it is a peculiar side
  effect that user_{enable,disable}_single_step() should cause COW
  de-sharing of text pages and so forth.  For PTRACE_SINGLESTEP, all these
  peculiarities are the status quo ante for that arch, so having
  arch_ptrace() itself do those is one thing.  But for building other
  things in the future, it is nicer to have a uniform "pure" semantics
  that arch-independent code can expect.

  OTOH, all such arch issues are really up to the arch maintainer.  As
  of today, there is nothing but ptrace using user_enable_single_step() et
  al so it's a distinction without a practical difference.  If/when there
  are other facilities that use user_enable_single_step() and might care,
  the affected arch's can revisit the question when someone cares about
  the quality of the arch support for said new facility.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/ptrace.h     |    2 --
 arch/ia64/include/asm/ptrace.h    |    4 ----
 arch/m68k/include/asm/ptrace.h    |    8 --------
 arch/mn10300/include/asm/ptrace.h |    2 --
 arch/parisc/include/asm/ptrace.h  |    5 -----
 arch/powerpc/include/asm/ptrace.h |    7 -------
 arch/s390/include/asm/ptrace.h    |    3 ---
 arch/score/include/asm/ptrace.h   |    3 +--
 arch/sh/include/asm/ptrace.h      |    2 --
 arch/x86/include/asm/ptrace.h     |    7 -------
 include/linux/ptrace.h            |    5 +++++
 11 files changed, 6 insertions(+), 42 deletions(-)

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
@@ -87,18 +87,10 @@ struct switch_stack {
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
@@ -137,15 +137,8 @@ do {									      \
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
@@ -489,9 +489,6 @@ struct user_regs_struct
  * These are defined as per linux/ptrace.h, which see.
  */
 #define arch_has_single_step()	(1)
-struct task_struct;
-extern void user_enable_single_step(struct task_struct *);
-extern void user_disable_single_step(struct task_struct *);
 extern void show_regs(struct pt_regs * regs);
 
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
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
@@ -123,8 +123,6 @@ extern void show_regs(struct pt_regs *);
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
@@ -264,6 +264,9 @@ static inline void user_enable_single_st
 static inline void user_disable_single_step(struct task_struct *task)
 {
 }
+#else
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
 #endif	/* arch_has_single_step */
 
 #ifndef arch_has_block_step
@@ -291,6 +294,8 @@ static inline void user_enable_block_ste
 {
 	BUG();			/* This can never be called.  */
 }
+#else
+extern void user_enable_block_step(struct task_struct *);
 #endif	/* arch_has_block_step */
 
 #ifdef ARCH_HAS_USER_SINGLE_STEP_INFO
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch

