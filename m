From: akpm@linux-foundation.org
Subject: + ptrace-unify-show_regs-prototype.patch added to -mm tree
Date: Mon, 06 Jun 2011 14:24:06 -0700
Message-ID: <201106062124.p56LO6Hn023286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab1FFVYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 17:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, oleg@redhat.com, tj@kernel.org


The patch titled
     ptrace: unify show_regs() prototype
has been added to the -mm tree.  Its filename is
     ptrace-unify-show_regs-prototype.patch

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
Subject: ptrace: unify show_regs() prototype
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/ptrace.h          |    1 -
 arch/avr32/include/asm/ptrace.h          |    2 --
 arch/blackfin/include/asm/ptrace.h       |    1 -
 arch/cris/include/arch-v10/arch/ptrace.h |    1 -
 arch/cris/include/arch-v32/arch/ptrace.h |    1 -
 arch/frv/include/asm/ptrace.h            |    1 -
 arch/h8300/include/asm/ptrace.h          |    1 -
 arch/ia64/include/asm/ptrace.h           |    1 -
 arch/m32r/include/asm/ptrace.h           |    2 --
 arch/m68k/include/asm/ptrace.h           |    1 -
 arch/microblaze/include/asm/ptrace.h     |    2 --
 arch/mn10300/include/asm/ptrace.h        |    1 -
 arch/parisc/include/asm/ptrace.h         |    1 -
 arch/powerpc/include/asm/system.h        |    1 -
 arch/s390/include/asm/ptrace.h           |    1 -
 arch/sh/include/asm/ptrace.h             |    2 --
 arch/sparc/include/asm/ptrace.h          |    2 --
 arch/tile/include/asm/ptrace.h           |    2 --
 arch/um/include/asm/ptrace-generic.h     |    2 --
 arch/x86/include/asm/kdebug.h            |    1 -
 arch/xtensa/include/asm/ptrace.h         |    1 -
 include/linux/ptrace.h                   |    1 +
 22 files changed, 1 insertion(+), 28 deletions(-)

diff -puN arch/alpha/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/alpha/include/asm/ptrace.h
--- a/arch/alpha/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/alpha/include/asm/ptrace.h
@@ -72,7 +72,6 @@ struct switch_stack {
 #define user_mode(regs) (((regs)->ps & 8) != 0)
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs *);
 
 #define task_pt_regs(task) \
   ((struct pt_regs *) (task_stack_page(task) + 2*PAGE_SIZE) - 1)
diff -puN arch/avr32/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/avr32/include/asm/ptrace.h
--- a/arch/avr32/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/avr32/include/asm/ptrace.h
@@ -132,8 +132,6 @@ struct pt_regs {
 #define instruction_pointer(regs)       ((regs)->pc)
 #define profile_pc(regs)                instruction_pointer(regs)
 
-extern void show_regs (struct pt_regs *);
-
 static __inline__ int valid_user_regs(struct pt_regs *regs)
 {
 	/*
diff -puN arch/blackfin/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/blackfin/include/asm/ptrace.h
--- a/arch/blackfin/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/blackfin/include/asm/ptrace.h
@@ -102,7 +102,6 @@ struct pt_regs {
 /* user_mode returns true if only one bit is set in IPEND, other than the
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
-extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
 /* common code demands this function */
diff -puN arch/cris/include/arch-v10/arch/ptrace.h~ptrace-unify-show_regs-prototype arch/cris/include/arch-v10/arch/ptrace.h
--- a/arch/cris/include/arch-v10/arch/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/cris/include/arch-v10/arch/ptrace.h
@@ -112,7 +112,6 @@ struct switch_stack {
 #define user_mode(regs) (((regs)->dccr & 0x100) != 0)
 #define instruction_pointer(regs) ((regs)->irp)
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs *);
 
 #endif  /*  __KERNEL__  */
 
diff -puN arch/cris/include/arch-v32/arch/ptrace.h~ptrace-unify-show_regs-prototype arch/cris/include/arch-v32/arch/ptrace.h
--- a/arch/cris/include/arch-v32/arch/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/cris/include/arch-v32/arch/ptrace.h
@@ -111,7 +111,6 @@ struct switch_stack {
 #define arch_has_single_step() (1)
 #define user_mode(regs) (((regs)->ccs & (1 << (U_CCS_BITNR + CCS_SHIFT))) != 0)
 #define instruction_pointer(regs) ((regs)->erp)
-extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) instruction_pointer(regs)
 
 #endif  /*  __KERNEL__  */
diff -puN arch/frv/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/frv/include/asm/ptrace.h
--- a/arch/frv/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/frv/include/asm/ptrace.h
@@ -78,7 +78,6 @@ register struct pt_regs *__frame asm("gr
 #define user_stack_pointer(regs)	((regs)->sp)
 
 extern unsigned long user_stack(const struct pt_regs *);
-extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) ((regs)->pc)
 
 #define task_pt_regs(task) ((task)->thread.frame0)
diff -puN arch/h8300/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/h8300/include/asm/ptrace.h
--- a/arch/h8300/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/h8300/include/asm/ptrace.h
@@ -60,7 +60,6 @@ struct pt_regs {
 #define user_mode(regs) (!((regs)->ccr & PS_S))
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs *);
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 #endif /* _H8300_PTRACE_H */
diff -puN arch/ia64/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/ia64/include/asm/ptrace.h
--- a/arch/ia64/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/ia64/include/asm/ptrace.h
@@ -286,7 +286,6 @@ static inline unsigned long user_stack_p
   struct task_struct;			/* forward decl */
   struct unw_frame_info;		/* forward decl */
 
-  extern void show_regs (struct pt_regs *);
   extern void ia64_do_show_stack (struct unw_frame_info *, void *);
   extern unsigned long ia64_get_user_rbs_end (struct task_struct *, struct pt_regs *,
 					      unsigned long *);
diff -puN arch/m32r/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/m32r/include/asm/ptrace.h
--- a/arch/m32r/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/m32r/include/asm/ptrace.h
@@ -138,8 +138,6 @@ extern void init_debug_traps(struct task
 #define instruction_pointer(regs) ((regs)->bpc)
 #define profile_pc(regs) instruction_pointer(regs)
 
-extern void show_regs(struct pt_regs *);
-
 extern void withdraw_debug_trap(struct pt_regs *regs);
 
 #define task_pt_regs(task) \
diff -puN arch/m68k/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/m68k/include/asm/ptrace.h
--- a/arch/m68k/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/m68k/include/asm/ptrace.h
@@ -85,7 +85,6 @@ struct switch_stack {
 #define user_mode(regs) (!((regs)->sr & PS_S))
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
-extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
 
diff -puN arch/microblaze/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/microblaze/include/asm/ptrace.h
--- a/arch/microblaze/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/microblaze/include/asm/ptrace.h
@@ -61,8 +61,6 @@ struct pt_regs {
 #define instruction_pointer(regs)	((regs)->pc)
 #define profile_pc(regs)		instruction_pointer(regs)
 
-void show_regs(struct pt_regs *);
-
 #else /* __KERNEL__ */
 
 /* pt_regs offsets used by gdbserver etc in ptrace syscalls */
diff -puN arch/mn10300/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/mn10300/include/asm/ptrace.h
--- a/arch/mn10300/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/mn10300/include/asm/ptrace.h
@@ -89,7 +89,6 @@ struct pt_regs {
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
 #define user_stack_pointer(regs)	((regs)->sp)
-extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
 
diff -puN arch/parisc/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/parisc/include/asm/ptrace.h
--- a/arch/parisc/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/parisc/include/asm/ptrace.h
@@ -56,7 +56,6 @@ struct pt_regs {
 #define instruction_pointer(regs)	((regs)->iaoq[0] & ~3)
 #define user_stack_pointer(regs)	((regs)->gr[30])
 unsigned long profile_pc(struct pt_regs *);
-extern void show_regs(struct pt_regs *);
 
 
 #endif /* __KERNEL__ */
diff -puN arch/powerpc/include/asm/system.h~ptrace-unify-show_regs-prototype arch/powerpc/include/asm/system.h
--- a/arch/powerpc/include/asm/system.h~ptrace-unify-show_regs-prototype
+++ a/arch/powerpc/include/asm/system.h
@@ -120,7 +120,6 @@ extern void do_dabr(struct pt_regs *regs
 		    unsigned long error_code);
 #endif
 extern void print_backtrace(unsigned long *);
-extern void show_regs(struct pt_regs * regs);
 extern void flush_instruction_cache(void);
 extern void hard_reset_now(void);
 extern void poweroff_now(void);
diff -puN arch/s390/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/s390/include/asm/ptrace.h
--- a/arch/s390/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/s390/include/asm/ptrace.h
@@ -539,7 +539,6 @@ struct user_regs_struct
  * These are defined as per linux/ptrace.h, which see.
  */
 #define arch_has_single_step()	(1)
-extern void show_regs(struct pt_regs * regs);
 
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
diff -puN arch/sh/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/sh/include/asm/ptrace.h
--- a/arch/sh/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/sh/include/asm/ptrace.h
@@ -45,8 +45,6 @@
 #define GET_FP(regs)	((regs)->regs[14])
 #define GET_USP(regs)	((regs)->regs[15])
 
-extern void show_regs(struct pt_regs *);
-
 #define arch_has_single_step()	(1)
 
 /*
diff -puN arch/sparc/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/sparc/include/asm/ptrace.h
--- a/arch/sparc/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/sparc/include/asm/ptrace.h
@@ -212,7 +212,6 @@ extern unsigned long profile_pc(struct p
 #else
 #define profile_pc(regs) instruction_pointer(regs)
 #endif
-extern void show_regs(struct pt_regs *);
 #endif /* (__KERNEL__) */
 
 #else /* __ASSEMBLY__ */
@@ -256,7 +255,6 @@ static inline bool pt_regs_clear_syscall
 #define instruction_pointer(regs) ((regs)->pc)
 #define user_stack_pointer(regs) ((regs)->u_regs[UREG_FP])
 unsigned long profile_pc(struct pt_regs *);
-extern void show_regs(struct pt_regs *);
 #endif /* (__KERNEL__) */
 
 #else /* (!__ASSEMBLY__) */
diff -puN arch/tile/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/tile/include/asm/ptrace.h
--- a/arch/tile/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/tile/include/asm/ptrace.h
@@ -112,8 +112,6 @@ struct pt_regs *get_pt_regs(struct pt_re
 /* Trace the current syscall. */
 extern void do_syscall_trace(void);
 
-extern void show_regs(struct pt_regs *);
-
 #define arch_has_single_step()	(1)
 
 /*
diff -puN arch/um/include/asm/ptrace-generic.h~ptrace-unify-show_regs-prototype arch/um/include/asm/ptrace-generic.h
--- a/arch/um/include/asm/ptrace-generic.h~ptrace-unify-show_regs-prototype
+++ a/arch/um/include/asm/ptrace-generic.h
@@ -47,8 +47,6 @@ extern int get_fpregs(struct user_i387_s
 extern int set_fpregs(struct user_i387_struct __user *buf,
 		      struct task_struct *child);
 
-extern void show_regs(struct pt_regs *regs);
-
 extern int arch_copy_tls(struct task_struct *new);
 extern void clear_flushed_tls(struct task_struct *task);
 
diff -puN arch/x86/include/asm/kdebug.h~ptrace-unify-show_regs-prototype arch/x86/include/asm/kdebug.h
--- a/arch/x86/include/asm/kdebug.h~ptrace-unify-show_regs-prototype
+++ a/arch/x86/include/asm/kdebug.h
@@ -28,7 +28,6 @@ extern void show_registers(struct pt_reg
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs, int all);
-extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
 #ifdef CONFIG_KEXEC
diff -puN arch/xtensa/include/asm/ptrace.h~ptrace-unify-show_regs-prototype arch/xtensa/include/asm/ptrace.h
--- a/arch/xtensa/include/asm/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/arch/xtensa/include/asm/ptrace.h
@@ -120,7 +120,6 @@ struct pt_regs {
   (task_stack_page(tsk) + KERNEL_STACK_SIZE - (XCHAL_NUM_AREGS-16)*4) - 1)
 # define user_mode(regs) (((regs)->ps & 0x00000020)!=0)
 # define instruction_pointer(regs) ((regs)->pc)
-extern void show_regs(struct pt_regs *);
 
 # ifndef CONFIG_SMP
 #  define profile_pc(regs) instruction_pointer(regs)
diff -puN include/linux/ptrace.h~ptrace-unify-show_regs-prototype include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-unify-show_regs-prototype
+++ a/include/linux/ptrace.h
@@ -100,6 +100,7 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
+extern void show_regs(struct pt_regs *);
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
_

Patches currently in -mm which might be from vapier@gentoo.org are

backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-new-driver-for-the-adp8870-backlight-devices-v2.patch
backlight-add-backlight-type-fix.patch
mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
asm-generic-systemh-drop-useless-__kernel__.patch
ptrace-unify-show_regs-prototype.patch

