From: akpm@linux-foundation.org
Subject: - git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:25:37 -0700
Message-ID: <200804130225.m3D2PbO5031906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787AbYDMC0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@linux.intel.com, joe@perches.com, mingo@elte.hu, suresh.b.siddha@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     git-x86: revert "x86, fpu: split FPU state from task struct - v5"
has been removed from the -mm tree.  Its filename was
     git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86: revert "x86, fpu: split FPU state from task struct - v5"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit ef15a86ca390024ad5cfefba16182928744c7191
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Mon Mar 10 15:28:04 2008 -0700

    x86, fpu: split FPU state from task struct - v5
    
    Split the FPU save area from the task struct. This allows easy migration
    of FPU context, and it's generally cleaner. It also allows the following
    two optimizations:
    
    1) only allocate when the application actually uses FPU, so in the first
    lazy FPU trap. This could save memory for non-fpu using apps. Next patch
    does this lazy allocation.
    
    2) allocate the right size for the actual cpu rather than 512 bytes always.
    Patches enabling xsave/xrstor support (coming shortly) will take advantage
    of this.
    
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Because it makes my Vaio block-sceeen on boot.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile         |    1 
 arch/x86/kernel/i387.c           |   80 ++++++++++++-----------------
 arch/x86/kernel/process.c        |   35 ------------
 arch/x86/kernel/process_32.c     |    2 
 arch/x86/kernel/process_64.c     |    2 
 arch/x86/kernel/traps_32.c       |    6 +-
 arch/x86/kernel/traps_64.c       |    6 --
 arch/x86/math-emu/fpu_entry.c    |    4 -
 arch/x86/math-emu/fpu_system.h   |   26 ++++-----
 arch/x86/math-emu/reg_ld_str.c   |    4 -
 include/asm-x86/i387.h           |   35 ++++++------
 include/asm-x86/processor.h      |    7 +-
 include/asm-x86/thread_info.h    |    7 --
 include/asm-x86/thread_info_32.h |    2 
 include/asm-x86/thread_info_64.h |    2 
 kernel/fork.c                    |   31 ++---------
 16 files changed, 90 insertions(+), 160 deletions(-)

diff -puN arch/x86/kernel/Makefile~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/kernel/Makefile
@@ -29,7 +29,6 @@ obj-y			+= alternative.o i8253.o
 obj-$(CONFIG_X86_64)	+= pci-nommu_64.o bugs_64.o
 obj-y			+= tsc_$(BITS).o io_delay.o rtc.o
 
-obj-y				+= process.o
 obj-y				+= i387.o
 obj-y				+= ptrace.o
 obj-y				+= ds.o
diff -puN arch/x86/kernel/i387.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/kernel/i387.c
--- a/arch/x86/kernel/i387.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/kernel/i387.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/regset.h>
 #include <linux/sched.h>
-#include <linux/bootmem.h>
 
 #include <asm/sigcontext.h>
 #include <asm/processor.h>
@@ -36,18 +35,17 @@
 #endif
 
 static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
-unsigned int xstate_size;
-static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
-void __cpuinit mxcsr_feature_mask_init(void)
+void mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
 
 	clts();
 	if (cpu_has_fxsr) {
-		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (fx_scratch));
-		mask = fx_scratch.mxcsr_mask;
+		memset(&current->thread.i387.fxsave, 0,
+		       sizeof(struct i387_fxsave_struct));
+		asm volatile("fxsave %0" : : "m" (current->thread.i387.fxsave));
+		mask = current->thread.i387.fxsave.mxcsr_mask;
 		if (mask == 0)
 			mask = 0x0000ffbf;
 	}
@@ -55,17 +53,6 @@ void __cpuinit mxcsr_feature_mask_init(v
 	stts();
 }
 
-void __init init_thread_xstate(void)
-{
-	if (cpu_has_fxsr)
-		xstate_size = sizeof(struct i387_fxsave_struct);
-#ifdef CONFIG_X86_32
-	else
-		xstate_size = sizeof(struct i387_fsave_struct);
-#endif
-	init_task.thread.xstate = alloc_bootmem(xstate_size);
-}
-
 #ifdef CONFIG_X86_64
 /*
  * Called at bootup to set up the initial FPU state that is later cloned
@@ -74,6 +61,10 @@ void __init init_thread_xstate(void)
 void __cpuinit fpu_init(void)
 {
 	unsigned long oldcr0 = read_cr0();
+	extern void __bad_fxsave_alignment(void);
+
+	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
+		__bad_fxsave_alignment();
 
 	set_in_cr4(X86_CR4_OSFXSR);
 	set_in_cr4(X86_CR4_OSXMMEXCPT);
@@ -102,19 +93,18 @@ void init_fpu(struct task_struct *tsk)
 	}
 
 	if (cpu_has_fxsr) {
-		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
-
-		memset(fx, 0, xstate_size);
-		fx->cwd = 0x37f;
+		memset(&tsk->thread.i387.fxsave, 0,
+		       sizeof(struct i387_fxsave_struct));
+		tsk->thread.i387.fxsave.cwd = 0x37f;
 		if (cpu_has_xmm)
-			fx->mxcsr = MXCSR_DEFAULT;
+			tsk->thread.i387.fxsave.mxcsr = MXCSR_DEFAULT;
 	} else {
-		struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
-		memset(fp, 0, xstate_size);
-		fp->cwd = 0xffff037fu;
-		fp->swd = 0xffff0000u;
-		fp->twd = 0xffffffffu;
-		fp->fos = 0xffff0000u;
+		memset(&tsk->thread.i387.fsave, 0,
+		       sizeof(struct i387_fsave_struct));
+		tsk->thread.i387.fsave.cwd = 0xffff037fu;
+		tsk->thread.i387.fsave.swd = 0xffff0000u;
+		tsk->thread.i387.fsave.twd = 0xffffffffu;
+		tsk->thread.i387.fsave.fos = 0xffff0000u;
 	}
 	/*
 	 * Only the device not available exception or ptrace can call init_fpu.
@@ -142,7 +132,7 @@ int xfpregs_get(struct task_struct *targ
 	init_fpu(target);
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &target->thread.xstate->fxsave, 0, -1);
+				   &target->thread.i387.fxsave, 0, -1);
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -158,12 +148,12 @@ int xfpregs_set(struct task_struct *targ
 	set_stopped_child_used_math(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->fxsave, 0, -1);
+				 &target->thread.i387.fxsave, 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	target->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
 
 	return ret;
 }
@@ -243,7 +233,7 @@ static inline u32 twd_fxsr_to_i387(struc
 static void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fxsave = &tsk->thread.i387.fxsave;
 	struct _fpreg *to = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *from = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -283,7 +273,7 @@ static void convert_to_fxsr(struct task_
 			    const struct user_i387_ia32_struct *env)
 
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fxsave = &tsk->thread.i387.fxsave;
 	struct _fpreg *from = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *to = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -320,8 +310,7 @@ int fpregs_get(struct task_struct *targe
 
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-					   &target->thread.xstate->fsave, 0,
-					   -1);
+					   &target->thread.i387.fsave, 0, -1);
 	}
 
 	if (kbuf && pos == 0 && count == sizeof(env)) {
@@ -349,7 +338,7 @@ int fpregs_set(struct task_struct *targe
 
 	if (!cpu_has_fxsr) {
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &target->thread.xstate->fsave, 0, -1);
+					  &target->thread.i387.fsave, 0, -1);
 	}
 
 	if (pos > 0 || count < sizeof(env))
@@ -369,11 +358,11 @@ int fpregs_set(struct task_struct *targe
 static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
-	struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
 
 	unlazy_fpu(tsk);
-	fp->status = fp->swd;
-	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
+	tsk->thread.i387.fsave.status = tsk->thread.i387.fsave.swd;
+	if (__copy_to_user(buf, &tsk->thread.i387.fsave,
+			   sizeof(struct i387_fsave_struct)))
 		return -1;
 	return 1;
 }
@@ -381,7 +370,6 @@ static inline int save_i387_fsave(struct
 static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
-	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
 	struct user_i387_ia32_struct env;
 	int err = 0;
 
@@ -391,12 +379,12 @@ static int save_i387_fxsave(struct _fpst
 	if (__copy_to_user(buf, &env, sizeof(env)))
 		return -1;
 
-	err |= __put_user(fx->swd, &buf->status);
+	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
 	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
 	if (err)
 		return -1;
 
-	if (__copy_to_user(&buf->_fxsr_env[0], fx,
+	if (__copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
 			   sizeof(struct i387_fxsave_struct)))
 		return -1;
 	return 1;
@@ -429,7 +417,7 @@ static inline int restore_i387_fsave(str
 	struct task_struct *tsk = current;
 
 	clear_fpu(tsk);
-	return __copy_from_user(&tsk->thread.xstate->fsave, buf,
+	return __copy_from_user(&tsk->thread.i387.fsave, buf,
 				sizeof(struct i387_fsave_struct));
 }
 
@@ -440,10 +428,10 @@ static int restore_i387_fxsave(struct _f
 	int err;
 
 	clear_fpu(tsk);
-	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
+	err = __copy_from_user(&tsk->thread.i387.fxsave, &buf->_fxsr_env[0],
 			       sizeof(struct i387_fxsave_struct));
 	/* mxcsr reserved bits must be masked to zero for security reasons */
-	tsk->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
 	if (err || __copy_from_user(&env, buf, sizeof(env)))
 		return 1;
 	convert_to_fxsr(tsk, &env);
diff -puN arch/x86/kernel/process.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 /dev/null
--- a/arch/x86/kernel/process.c
+++ /dev/null
@@ -1,35 +0,0 @@
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/slab.h>
-#include <linux/sched.h>
-
-static struct kmem_cache *task_xstate_cachep;
-
-int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
-{
-	*dst = *src;
-	dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
-	if (!dst->thread.xstate)
-		return -ENOMEM;
-	WARN_ON((unsigned long)dst->thread.xstate & 15);
-	memcpy(dst->thread.xstate, src->thread.xstate, xstate_size);
-	return 0;
-}
-
-void free_thread_info(struct thread_info *ti)
-{
-	kmem_cache_free(task_xstate_cachep, ti->task->thread.xstate);
-	ti->task->thread.xstate = NULL;
-
-	free_pages((unsigned long)(ti), get_order(THREAD_SIZE));
-}
-
-void arch_task_cache_init(void)
-{
-        task_xstate_cachep =
-        	kmem_cache_create("task_xstate", xstate_size,
-				  __alignof__(union thread_xstate),
-				  SLAB_PANIC, NULL);
-}
diff -puN arch/x86/kernel/process_32.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/kernel/process_32.c
@@ -669,7 +669,7 @@ struct task_struct * __switch_to(struct 
 
 	/* we're going to use this soon, after a few expensive things */
 	if (next_p->fpu_counter > 5)
-		prefetch(next->xstate);
+		prefetch(&next->i387.fxsave);
 
 	/*
 	 * Reload esp0.
diff -puN arch/x86/kernel/process_64.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/kernel/process_64.c
@@ -626,7 +626,7 @@ __switch_to(struct task_struct *prev_p, 
 
 	/* we're going to use this soon, after a few expensive things */
 	if (next_p->fpu_counter>5)
-		prefetch(next->xstate);
+		prefetch(&next->i387.fxsave);
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
diff -puN arch/x86/kernel/traps_32.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/kernel/traps_32.c
--- a/arch/x86/kernel/traps_32.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/kernel/traps_32.c
@@ -1206,6 +1206,11 @@ void __init trap_init(void)
 #endif
 	set_trap_gate(19, &simd_coprocessor_error);
 
+	/*
+	 * Verify that the FXSAVE/FXRSTOR data will be 16-byte aligned.
+	 * Generate a build-time error if the alignment is wrong.
+	 */
+	BUILD_BUG_ON(offsetof(struct task_struct, thread.i387.fxsave) & 15);
 	if (cpu_has_fxsr) {
 		printk(KERN_INFO "Enabling fast FPU save and restore... ");
 		set_in_cr4(X86_CR4_OSFXSR);
@@ -1226,7 +1231,6 @@ void __init trap_init(void)
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
 
-	init_thread_xstate();
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff -puN arch/x86/kernel/traps_64.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/kernel/traps_64.c
--- a/arch/x86/kernel/traps_64.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/kernel/traps_64.c
@@ -1120,7 +1120,7 @@ asmlinkage void math_state_restore(void)
 
 	if (!used_math())
 		init_fpu(me);
-	restore_fpu_checking(&me->thread.xstate->fxsave);
+	restore_fpu_checking(&me->thread.i387.fxsave);
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
@@ -1156,10 +1156,6 @@ void __init trap_init(void)
 #endif
        
 	/*
-	 * initialize the per thread extended state:
-	 */
-        init_thread_xstate();
-	/*
 	 * Should be a barrier for any external CPU state.
 	 */
 	cpu_init();
diff -puN arch/x86/math-emu/fpu_entry.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/math-emu/fpu_entry.c
--- a/arch/x86/math-emu/fpu_entry.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/math-emu/fpu_entry.c
@@ -678,7 +678,7 @@ int fpregs_soft_set(struct task_struct *
 		    unsigned int pos, unsigned int count,
 		    const void *kbuf, const void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.xstate->soft;
+	struct i387_soft_struct *s387 = &target->thread.i387.soft;
 	void *space = s387->st_space;
 	int ret;
 	int offset, other, i, tags, regnr, tag, newtop;
@@ -730,7 +730,7 @@ int fpregs_soft_get(struct task_struct *
 		    unsigned int pos, unsigned int count,
 		    void *kbuf, void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.xstate->soft;
+	struct i387_soft_struct *s387 = &target->thread.i387.soft;
 	const void *space = s387->st_space;
 	int ret;
 	int offset = (S387->ftop & 7) * 10, other = 80 - offset;
diff -puN arch/x86/math-emu/fpu_system.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/math-emu/fpu_system.h
--- a/arch/x86/math-emu/fpu_system.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/math-emu/fpu_system.h
@@ -35,8 +35,8 @@
 #define SEG_EXPAND_DOWN(s)	(((s).b & ((1 << 11) | (1 << 10))) \
 				 == (1 << 10))
 
-#define I387			(current->thread.xstate)
-#define FPU_info		(I387->soft.info)
+#define I387			(current->thread.i387)
+#define FPU_info		(I387.soft.info)
 
 #define FPU_CS			(*(unsigned short *) &(FPU_info->___cs))
 #define FPU_SS			(*(unsigned short *) &(FPU_info->___ss))
@@ -46,25 +46,25 @@
 #define FPU_EIP			(FPU_info->___eip)
 #define FPU_ORIG_EIP		(FPU_info->___orig_eip)
 
-#define FPU_lookahead           (I387->soft.lookahead)
+#define FPU_lookahead           (I387.soft.lookahead)
 
 /* nz if ip_offset and cs_selector are not to be set for the current
    instruction. */
-#define no_ip_update		(*(u_char *)&(I387->soft.no_update))
-#define FPU_rm			(*(u_char *)&(I387->soft.rm))
+#define no_ip_update		(*(u_char *)&(I387.soft.no_update))
+#define FPU_rm			(*(u_char *)&(I387.soft.rm))
 
 /* Number of bytes of data which can be legally accessed by the current
    instruction. This only needs to hold a number <= 108, so a byte will do. */
-#define access_limit		(*(u_char *)&(I387->soft.alimit))
+#define access_limit		(*(u_char *)&(I387.soft.alimit))
 
-#define partial_status		(I387->soft.swd)
-#define control_word		(I387->soft.cwd)
-#define fpu_tag_word		(I387->soft.twd)
-#define registers		(I387->soft.st_space)
-#define top			(I387->soft.ftop)
+#define partial_status		(I387.soft.swd)
+#define control_word		(I387.soft.cwd)
+#define fpu_tag_word		(I387.soft.twd)
+#define registers		(I387.soft.st_space)
+#define top			(I387.soft.ftop)
 
-#define instruction_address	(*(struct address *)&I387->soft.fip)
-#define operand_address		(*(struct address *)&I387->soft.foo)
+#define instruction_address	(*(struct address *)&I387.soft.fip)
+#define operand_address		(*(struct address *)&I387.soft.foo)
 
 #define FPU_access_ok(x,y,z)	if ( !access_ok(x,y,z) ) \
 				math_abort(FPU_info,SIGSEGV)
diff -puN arch/x86/math-emu/reg_ld_str.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 arch/x86/math-emu/reg_ld_str.c
--- a/arch/x86/math-emu/reg_ld_str.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/arch/x86/math-emu/reg_ld_str.c
@@ -1180,8 +1180,8 @@ u_char __user *fstenv(fpu_addr_modes add
 		control_word |= 0xffff0040;
 		partial_status = status_word() | 0xffff0000;
 		fpu_tag_word |= 0xffff0000;
-		I387->soft.fcs &= ~0xf8000000;
-		I387->soft.fos |= 0xffff0000;
+		I387.soft.fcs &= ~0xf8000000;
+		I387.soft.fos |= 0xffff0000;
 #endif /* PECULIAR_486 */
 		if (__copy_to_user(d, &control_word, 7 * 4))
 			FPU_abort;
diff -puN include/asm-x86/i387.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 include/asm-x86/i387.h
--- a/include/asm-x86/i387.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/include/asm-x86/i387.h
@@ -23,7 +23,6 @@ extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern void init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
-extern void init_thread_xstate(void);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
@@ -117,22 +116,24 @@ static inline void __save_init_fpu(struc
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
 	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+			     : "=m" (tsk->thread.i387.fxsave));
 #elif 0
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
 	   needed for addressing (fix submitted to mainline 2005-11-21). */
 	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+			     : "=m" (tsk->thread.i387.fxsave));
 #else
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__("rex64/fxsave (%1)"
-			     : "=m" (tsk->thread.xstate->fxsave)
-			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
+	__asm__ __volatile__("rex64/fxsave %P2(%1)"
+			     : "=m" (tsk->thread.i387.fxsave)
+			     : "cdaSDb" (tsk),
+				"i" (offsetof(__typeof__(*tsk),
+					      thread.i387.fxsave)));
 #endif
-	clear_fpu_state(&tsk->thread.xstate->fxsave);
+	clear_fpu_state(&tsk->thread.i387.fxsave);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
@@ -146,7 +147,7 @@ static inline int save_i387(struct _fpst
 	int err = 0;
 
 	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
+			sizeof(tsk->thread.i387.fxsave));
 
 	if ((unsigned long)buf % 16)
 		printk("save_i387: bad fpstate %p\n", buf);
@@ -160,7 +161,7 @@ static inline int save_i387(struct _fpst
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+		if (__copy_to_user(buf, &tsk->thread.i387.fxsave,
 				   sizeof(struct i387_fxsave_struct)))
 			return -1;
 	}
@@ -197,7 +198,7 @@ static inline void restore_fpu(struct ta
 		"nop ; frstor %1",
 		"fxrstor %1",
 		X86_FEATURE_FXSR,
-		"m" (tsk->thread.xstate->fxsave));
+		"m" ((tsk)->thread.i387.fxsave));
 }
 
 /* We need a safe address that is cheap to find and that is already
@@ -221,8 +222,8 @@ static inline void __save_init_fpu(struc
 		"fxsave %[fx]\n"
 		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
 		X86_FEATURE_FXSR,
-		[fx] "m" (tsk->thread.xstate->fxsave),
-		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+		[fx] "m" (tsk->thread.i387.fxsave),
+		[fsw] "m" (tsk->thread.i387.fxsave.swd) : "memory");
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
@@ -323,25 +324,25 @@ static inline void clear_fpu(struct task
 static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.xstate->fxsave.cwd;
+		return tsk->thread.i387.fxsave.cwd;
 	} else {
-		return (unsigned short) tsk->thread.xstate->fsave.cwd;
+		return (unsigned short)tsk->thread.i387.fsave.cwd;
 	}
 }
 
 static inline unsigned short get_fpu_swd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.xstate->fxsave.swd;
+		return tsk->thread.i387.fxsave.swd;
 	} else {
-		return (unsigned short) tsk->thread.xstate->fsave.swd;
+		return (unsigned short)tsk->thread.i387.fsave.swd;
 	}
 }
 
 static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 {
 	if (cpu_has_xmm) {
-		return tsk->thread.xstate->fxsave.mxcsr;
+		return tsk->thread.i387.fxsave.mxcsr;
 	} else {
 		return MXCSR_DEFAULT;
 	}
diff -puN include/asm-x86/processor.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 include/asm-x86/processor.h
--- a/include/asm-x86/processor.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/include/asm-x86/processor.h
@@ -354,7 +354,7 @@ struct i387_soft_struct {
 	u32			entry_eip;
 };
 
-union thread_xstate {
+union i387_union {
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
 	struct i387_soft_struct		soft;
@@ -365,7 +365,6 @@ DECLARE_PER_CPU(struct orig_ist, orig_is
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
-extern unsigned int xstate_size;
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
@@ -398,8 +397,8 @@ struct thread_struct {
 	unsigned long		cr2;
 	unsigned long		trap_no;
 	unsigned long		error_code;
-	/* floating point and extended processor state */
-	union thread_xstate	*xstate;
+	/* Floating point info: */
+	union i387_union	i387 __attribute__((aligned(16)));;
 #ifdef CONFIG_X86_32
 	/* Virtual 86 mode info */
 	struct vm86_struct __user *vm86_info;
diff -puN include/asm-x86/thread_info.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 include/asm-x86/thread_info.h
--- a/include/asm-x86/thread_info.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/include/asm-x86/thread_info.h
@@ -4,11 +4,4 @@
 #else
 # include "thread_info_64.h"
 #endif
-
-#ifndef __ASSEMBLY__
-extern void arch_task_cache_init(void);
-extern void free_thread_info(struct thread_info *ti);
-extern int arch_dup_task_struct(struct task_struct *dst,
-				struct task_struct *src);
-#endif
 #endif /* _ASM_X86_THREAD_INFO_H */
diff -puN include/asm-x86/thread_info_32.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 include/asm-x86/thread_info_32.h
--- a/include/asm-x86/thread_info_32.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/include/asm-x86/thread_info_32.h
@@ -102,6 +102,8 @@ static inline struct thread_info *curren
 	__get_free_pages(GFP_KERNEL, get_order(THREAD_SIZE)))
 #endif
 
+#define free_thread_info(info)	free_pages((unsigned long)(info), get_order(THREAD_SIZE))
+
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
diff -puN include/asm-x86/thread_info_64.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 include/asm-x86/thread_info_64.h
--- a/include/asm-x86/thread_info_64.h~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/include/asm-x86/thread_info_64.h
@@ -85,6 +85,8 @@ static inline struct thread_info *stack_
 #define alloc_thread_info(tsk)						\
 	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
 
+#define free_thread_info(ti) free_pages((unsigned long) (ti), THREAD_ORDER)
+
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
diff -puN kernel/fork.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5 kernel/fork.c
--- a/kernel/fork.c~git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5
+++ a/kernel/fork.c
@@ -132,10 +132,6 @@ void __put_task_struct(struct task_struc
 		free_task(tsk);
 }
 
-void __attribute__((weak)) arch_task_cache_init(void)
-{
-}
-
 void __init fork_init(unsigned long mempages)
 {
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
@@ -148,9 +144,6 @@ void __init fork_init(unsigned long memp
 			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
 #endif
 
-	/* do the arch specific task caches init */
-	arch_task_cache_init();
-
 	/*
 	 * The default maximum number of threads is set to a safe
 	 * value: the thread structures can take up at most half
@@ -170,13 +163,6 @@ void __init fork_init(unsigned long memp
 		init_task.signal->rlim[RLIMIT_NPROC];
 }
 
-int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
-					       struct task_struct *src)
-{
-	*dst = *src;
-	return 0;
-}
-
 static struct task_struct *dup_task_struct(struct task_struct *orig)
 {
 	struct task_struct *tsk;
@@ -195,15 +181,15 @@ static struct task_struct *dup_task_stru
 		return NULL;
 	}
 
- 	err = arch_dup_task_struct(tsk, orig);
-	if (err)
-		goto out;
-
+	*tsk = *orig;
 	tsk->stack = ti;
 
 	err = prop_local_init_single(&tsk->dirties);
-	if (err)
-		goto out;
+	if (err) {
+		free_thread_info(ti);
+		free_task_struct(tsk);
+		return NULL;
+	}
 
 	setup_thread_stack(tsk, orig);
 
@@ -219,11 +205,6 @@ static struct task_struct *dup_task_stru
 #endif
 	tsk->splice_pipe = NULL;
 	return tsk;
-
-out:
-	free_thread_info(ti);
-	free_task_struct(tsk);
-	return NULL;
 }
 
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
git-acpi-revert-suspend-wakeup-code-in-c.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5.patch
arch-x86-mm-ioremapc-fix-printk-warnings.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
git-kgdb-light.patch
git-x86-hack-around-to-make-git-kgdb-build.patch
git-x86-vs-git-kgdb-lite.patch
git-alsa-tiwai.patch
es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
pm-remove-destroy_suspended_device.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3-fix.patch
git-drm.patch
revert-git-drm.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hid.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
git-ia64.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-kvm.patch
git-leds.patch
git-libata-all.patch
git-libata-all-unbork-drivers-ata-sata_sx4c.patch
pata_atiixp-simplex-clear-fix.patch
git-async-tx.patch
git-mips.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-s390.patch
git-sched.patch
git-sh.patch
sh-arch-sh-kernel-traps_32c-needs-asm-fpuh.patch
sh-export-empty_zero_page.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
aacraid-fix-unchecked-down_interruptible.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-vs-git-x86.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

