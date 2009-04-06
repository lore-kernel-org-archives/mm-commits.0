From: akpm@linux-foundation.org
Subject: [merged] simplify-copy_thread.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:21 -0700
Message-ID: <200904061933.n36JXLHb011071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbZDFTfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Simplify copy_thread()
has been removed from the -mm tree.  Its filename was
     simplify-copy_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Simplify copy_thread()
From: Alexey Dobriyan <adobriyan@gmail.com>

First argument unused since 2.3.11.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/process.c         |    2 +-
 arch/arm/kernel/process.c           |    2 +-
 arch/avr32/kernel/process.c         |    2 +-
 arch/blackfin/kernel/process.c      |    2 +-
 arch/cris/arch-v10/kernel/process.c |    2 +-
 arch/cris/arch-v32/kernel/process.c |    2 +-
 arch/frv/kernel/process.c           |    2 +-
 arch/h8300/kernel/process.c         |    2 +-
 arch/ia64/kernel/process.c          |    2 +-
 arch/m32r/kernel/process.c          |    2 +-
 arch/m68k/kernel/process.c          |    2 +-
 arch/m68knommu/kernel/process.c     |    2 +-
 arch/mips/kernel/process.c          |    2 +-
 arch/mn10300/kernel/process.c       |    2 +-
 arch/parisc/kernel/process.c        |    2 +-
 arch/powerpc/kernel/process.c       |    2 +-
 arch/s390/kernel/process.c          |    2 +-
 arch/sh/kernel/process_32.c         |    2 +-
 arch/sh/kernel/process_64.c         |    2 +-
 arch/sparc/kernel/process_32.c      |    2 +-
 arch/sparc/kernel/process_64.c      |    2 +-
 arch/um/kernel/process.c            |    2 +-
 arch/x86/kernel/process_32.c        |    2 +-
 arch/x86/kernel/process_64.c        |    2 +-
 arch/xtensa/kernel/process.c        |    2 +-
 include/linux/sched.h               |    3 ++-
 kernel/fork.c                       |    2 +-
 27 files changed, 28 insertions(+), 27 deletions(-)

diff -puN arch/alpha/kernel/process.c~simplify-copy_thread arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~simplify-copy_thread
+++ a/arch/alpha/kernel/process.c
@@ -272,7 +272,7 @@ alpha_vfork(struct pt_regs *regs)
  */
 
 int
-copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+copy_thread(unsigned long clone_flags, unsigned long usp,
 	    unsigned long unused,
 	    struct task_struct * p, struct pt_regs * regs)
 {
diff -puN arch/arm/kernel/process.c~simplify-copy_thread arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~simplify-copy_thread
+++ a/arch/arm/kernel/process.c
@@ -301,7 +301,7 @@ void release_thread(struct task_struct *
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
 int
-copy_thread(int nr, unsigned long clone_flags, unsigned long stack_start,
+copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	    unsigned long stk_sz, struct task_struct *p, struct pt_regs *regs)
 {
 	struct thread_info *thread = task_thread_info(p);
diff -puN arch/avr32/kernel/process.c~simplify-copy_thread arch/avr32/kernel/process.c
--- a/arch/avr32/kernel/process.c~simplify-copy_thread
+++ a/arch/avr32/kernel/process.c
@@ -332,7 +332,7 @@ int dump_fpu(struct pt_regs *regs, elf_f
 
 asmlinkage void ret_from_fork(void);
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/blackfin/kernel/process.c~simplify-copy_thread arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c~simplify-copy_thread
+++ a/arch/blackfin/kernel/process.c
@@ -193,7 +193,7 @@ asmlinkage int bfin_clone(struct pt_regs
 }
 
 int
-copy_thread(int nr, unsigned long clone_flags,
+copy_thread(unsigned long clone_flags,
 	    unsigned long usp, unsigned long topstk,
 	    struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/cris/arch-v10/kernel/process.c~simplify-copy_thread arch/cris/arch-v10/kernel/process.c
--- a/arch/cris/arch-v10/kernel/process.c~simplify-copy_thread
+++ a/arch/cris/arch-v10/kernel/process.c
@@ -115,7 +115,7 @@ int kernel_thread(int (*fn)(void *), voi
  */
 asmlinkage void ret_from_fork(void);
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/cris/arch-v32/kernel/process.c~simplify-copy_thread arch/cris/arch-v32/kernel/process.c
--- a/arch/cris/arch-v32/kernel/process.c~simplify-copy_thread
+++ a/arch/cris/arch-v32/kernel/process.c
@@ -131,7 +131,7 @@ kernel_thread(int (*fn)(void *), void * 
 extern asmlinkage void ret_from_fork(void);
 
 int
-copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+copy_thread(unsigned long clone_flags, unsigned long usp,
 	unsigned long unused,
 	struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/frv/kernel/process.c~simplify-copy_thread arch/frv/kernel/process.c
--- a/arch/frv/kernel/process.c~simplify-copy_thread
+++ a/arch/frv/kernel/process.c
@@ -204,7 +204,7 @@ void prepare_to_copy(struct task_struct 
 /*
  * set up the kernel stack and exception frames for a new process
  */
-int copy_thread(int nr, unsigned long clone_flags,
+int copy_thread(unsigned long clone_flags,
 		unsigned long usp, unsigned long topstk,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/h8300/kernel/process.c~simplify-copy_thread arch/h8300/kernel/process.c
--- a/arch/h8300/kernel/process.c~simplify-copy_thread
+++ a/arch/h8300/kernel/process.c
@@ -191,7 +191,7 @@ asmlinkage int h8300_clone(struct pt_reg
 
 }
 
-int copy_thread(int nr, unsigned long clone_flags,
+int copy_thread(unsigned long clone_flags,
                 unsigned long usp, unsigned long topstk,
 		 struct task_struct * p, struct pt_regs * regs)
 {
diff -puN arch/ia64/kernel/process.c~simplify-copy_thread arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~simplify-copy_thread
+++ a/arch/ia64/kernel/process.c
@@ -413,7 +413,7 @@ ia64_load_extra (struct task_struct *tas
  * so there is nothing to worry about.
  */
 int
-copy_thread (int nr, unsigned long clone_flags,
+copy_thread(unsigned long clone_flags,
 	     unsigned long user_stack_base, unsigned long user_stack_size,
 	     struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/m32r/kernel/process.c~simplify-copy_thread arch/m32r/kernel/process.c
--- a/arch/m32r/kernel/process.c~simplify-copy_thread
+++ a/arch/m32r/kernel/process.c
@@ -225,7 +225,7 @@ int dump_fpu(struct pt_regs *regs, elf_f
 	return 0; /* Task didn't use the fpu at all. */
 }
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long spu,
+int copy_thread(unsigned long clone_flags, unsigned long spu,
 	unsigned long unused, struct task_struct *tsk, struct pt_regs *regs)
 {
 	struct pt_regs *childregs = task_pt_regs(tsk);
diff -puN arch/m68k/kernel/process.c~simplify-copy_thread arch/m68k/kernel/process.c
--- a/arch/m68k/kernel/process.c~simplify-copy_thread
+++ a/arch/m68k/kernel/process.c
@@ -233,7 +233,7 @@ asmlinkage int m68k_clone(struct pt_regs
 		       parent_tidptr, child_tidptr);
 }
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 		 unsigned long unused,
 		 struct task_struct * p, struct pt_regs * regs)
 {
diff -puN arch/m68knommu/kernel/process.c~simplify-copy_thread arch/m68knommu/kernel/process.c
--- a/arch/m68knommu/kernel/process.c~simplify-copy_thread
+++ a/arch/m68knommu/kernel/process.c
@@ -199,7 +199,7 @@ asmlinkage int m68k_clone(struct pt_regs
         return do_fork(clone_flags, newsp, regs, 0, NULL, NULL);
 }
 
-int copy_thread(int nr, unsigned long clone_flags,
+int copy_thread(unsigned long clone_flags,
 		unsigned long usp, unsigned long topstk,
 		struct task_struct * p, struct pt_regs * regs)
 {
diff -puN arch/mips/kernel/process.c~simplify-copy_thread arch/mips/kernel/process.c
--- a/arch/mips/kernel/process.c~simplify-copy_thread
+++ a/arch/mips/kernel/process.c
@@ -99,7 +99,7 @@ void flush_thread(void)
 {
 }
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 	unsigned long unused, struct task_struct *p, struct pt_regs *regs)
 {
 	struct thread_info *ti = task_thread_info(p);
diff -puN arch/mn10300/kernel/process.c~simplify-copy_thread arch/mn10300/kernel/process.c
--- a/arch/mn10300/kernel/process.c~simplify-copy_thread
+++ a/arch/mn10300/kernel/process.c
@@ -193,7 +193,7 @@ void prepare_to_copy(struct task_struct 
  * set up the kernel stack for a new thread and copy arch-specific thread
  * control information
  */
-int copy_thread(int nr, unsigned long clone_flags,
+int copy_thread(unsigned long clone_flags,
 		unsigned long c_usp, unsigned long ustk_size,
 		struct task_struct *p, struct pt_regs *kregs)
 {
diff -puN arch/parisc/kernel/process.c~simplify-copy_thread arch/parisc/kernel/process.c
--- a/arch/parisc/kernel/process.c~simplify-copy_thread
+++ a/arch/parisc/kernel/process.c
@@ -263,7 +263,7 @@ sys_vfork(struct pt_regs *regs)
 }
 
 int
-copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+copy_thread(unsigned long clone_flags, unsigned long usp,
 	    unsigned long unused,	/* in ia64 this is "user_stack_size" */
 	    struct task_struct * p, struct pt_regs * pregs)
 {
diff -puN arch/powerpc/kernel/process.c~simplify-copy_thread arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~simplify-copy_thread
+++ a/arch/powerpc/kernel/process.c
@@ -598,7 +598,7 @@ void prepare_to_copy(struct task_struct 
 /*
  * Copy a thread..
  */
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long unused, struct task_struct *p,
 		struct pt_regs *regs)
 {
diff -puN arch/s390/kernel/process.c~simplify-copy_thread arch/s390/kernel/process.c
--- a/arch/s390/kernel/process.c~simplify-copy_thread
+++ a/arch/s390/kernel/process.c
@@ -160,7 +160,7 @@ void release_thread(struct task_struct *
 {
 }
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long new_stackp,
+int copy_thread(unsigned long clone_flags, unsigned long new_stackp,
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/sh/kernel/process_32.c~simplify-copy_thread arch/sh/kernel/process_32.c
--- a/arch/sh/kernel/process_32.c~simplify-copy_thread
+++ a/arch/sh/kernel/process_32.c
@@ -170,7 +170,7 @@ int dump_fpu(struct pt_regs *regs, elf_f
 
 asmlinkage void ret_from_fork(void);
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/sh/kernel/process_64.c~simplify-copy_thread arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~simplify-copy_thread
+++ a/arch/sh/kernel/process_64.c
@@ -425,7 +425,7 @@ int dump_fpu(struct pt_regs *regs, elf_f
 
 asmlinkage void ret_from_fork(void);
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/sparc/kernel/process_32.c~simplify-copy_thread arch/sparc/kernel/process_32.c
--- a/arch/sparc/kernel/process_32.c~simplify-copy_thread
+++ a/arch/sparc/kernel/process_32.c
@@ -455,7 +455,7 @@ asmlinkage int sparc_do_fork(unsigned lo
  */
 extern void ret_from_fork(void);
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
+int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/sparc/kernel/process_64.c~simplify-copy_thread arch/sparc/kernel/process_64.c
--- a/arch/sparc/kernel/process_64.c~simplify-copy_thread
+++ a/arch/sparc/kernel/process_64.c
@@ -561,7 +561,7 @@ asmlinkage long sparc_do_fork(unsigned l
  * Parent -->  %o0 == childs  pid, %o1 == 0
  * Child  -->  %o0 == parents pid, %o1 == 1
  */
-int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
+int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/um/kernel/process.c~simplify-copy_thread arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~simplify-copy_thread
+++ a/arch/um/kernel/process.c
@@ -179,7 +179,7 @@ void fork_handler(void)
 	userspace(&current->thread.regs.regs);
 }
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
+int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long stack_top, struct task_struct * p,
 		struct pt_regs *regs)
 {
diff -puN arch/x86/kernel/process_32.c~simplify-copy_thread arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~simplify-copy_thread
+++ a/arch/x86/kernel/process_32.c
@@ -245,7 +245,7 @@ void prepare_to_copy(struct task_struct 
 	unlazy_fpu(tsk);
 }
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
+int copy_thread(unsigned long clone_flags, unsigned long sp,
 	unsigned long unused,
 	struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/x86/kernel/process_64.c~simplify-copy_thread arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~simplify-copy_thread
+++ a/arch/x86/kernel/process_64.c
@@ -278,7 +278,7 @@ void prepare_to_copy(struct task_struct 
 	unlazy_fpu(tsk);
 }
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
+int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long unused,
 	struct task_struct *p, struct pt_regs *regs)
 {
diff -puN arch/xtensa/kernel/process.c~simplify-copy_thread arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~simplify-copy_thread
+++ a/arch/xtensa/kernel/process.c
@@ -172,7 +172,7 @@ void prepare_to_copy(struct task_struct 
  *       childregs.
  */
 
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long unused,
                 struct task_struct * p, struct pt_regs * regs)
 {
diff -puN include/linux/sched.h~simplify-copy_thread include/linux/sched.h
--- a/include/linux/sched.h~simplify-copy_thread
+++ a/include/linux/sched.h
@@ -1975,7 +1975,8 @@ extern void mm_release(struct task_struc
 /* Allocate a new mm structure and copy contents from tsk->mm */
 extern struct mm_struct *dup_mm(struct task_struct *tsk);
 
-extern int  copy_thread(int, unsigned long, unsigned long, unsigned long, struct task_struct *, struct pt_regs *);
+extern int copy_thread(unsigned long, unsigned long, unsigned long,
+			struct task_struct *, struct pt_regs *);
 extern void flush_thread(void);
 extern void exit_thread(void);
 
diff -puN kernel/fork.c~simplify-copy_thread kernel/fork.c
--- a/kernel/fork.c~simplify-copy_thread
+++ a/kernel/fork.c
@@ -1125,7 +1125,7 @@ static struct task_struct *copy_process(
 		goto bad_fork_cleanup_mm;
 	if ((retval = copy_io(clone_flags, p)))
 		goto bad_fork_cleanup_namespaces;
-	retval = copy_thread(0, clone_flags, stack_start, stack_size, p, regs);
+	retval = copy_thread(clone_flags, stack_start, stack_size, p, regs);
 	if (retval)
 		goto bad_fork_cleanup_io;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

