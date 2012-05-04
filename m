From: akpm@linux-foundation.org
Subject: [to-be-updated] percpu-remove-percpu_xxx-functions.patch removed from -mm tree
Date: Fri, 04 May 2012 14:29:56 -0700
Message-ID: <20120504212956.DC0DBA0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63658 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759916Ab2EDV37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2012 17:29:59 -0400
Received: by werb12 with SMTP id b12so10811wer.1
        for <mm-commits@vger.kernel.org>; Fri, 04 May 2012 14:29:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, cl@gentwo.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: remove percpu_xxx() functions
has been removed from the -mm tree.  Its filename was
     percpu-remove-percpu_xxx-functions.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: percpu: remove percpu_xxx() functions

There are no percpu_xxx callers remaining

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/compat.h       |    2 
 arch/x86/include/asm/fpu-internal.h |    4 -
 arch/x86/include/asm/percpu.h       |   16 ++-----
 include/linux/percpu.h              |   54 --------------------------
 4 files changed, 9 insertions(+), 67 deletions(-)

diff -puN arch/x86/include/asm/compat.h~percpu-remove-percpu_xxx-functions arch/x86/include/asm/compat.h
--- a/arch/x86/include/asm/compat.h~percpu-remove-percpu_xxx-functions
+++ a/arch/x86/include/asm/compat.h
@@ -229,7 +229,7 @@ static inline void __user *arch_compat_a
 		sp = task_pt_regs(current)->sp;
 	} else {
 		/* -128 for the x32 ABI redzone */
-		sp = percpu_read(old_rsp) - 128;
+		sp = __this_cpu_read(old_rsp) - 128;
 	}
 
 	return (void __user *)round_down(sp - len, 16);
diff -puN arch/x86/include/asm/percpu.h~percpu-remove-percpu_xxx-functions arch/x86/include/asm/percpu.h
--- a/arch/x86/include/asm/percpu.h~percpu-remove-percpu_xxx-functions
+++ a/arch/x86/include/asm/percpu.h
@@ -351,7 +351,7 @@ do {									\
 })
 
 /*
- * percpu_read() makes gcc load the percpu variable every time it is
+ * this_cpu_read() makes gcc load the percpu variable every time it is
  * accessed while this_cpu_read_stable() allows the value to be cached.
  * this_cpu_read_stable() is more efficient and can be used if its value
  * is guaranteed to be valid across cpus.  The current users include
@@ -359,15 +359,7 @@ do {									\
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
-#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
 #define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
-#define percpu_write(var, val)		percpu_to_op("mov", var, val)
-#define percpu_add(var, val)		percpu_add_op(var, val)
-#define percpu_sub(var, val)		percpu_add_op(var, -(val))
-#define percpu_and(var, val)		percpu_to_op("and", var, val)
-#define percpu_or(var, val)		percpu_to_op("or", var, val)
-#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
-#define percpu_inc(var)		percpu_unary_op("inc", var)
 
 #define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -512,7 +504,11 @@ static __always_inline int x86_this_cpu_
 {
 	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
 
-	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
+#ifdef CONFIG_X86_64
+	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_8(*a)) != 0;
+#else
+	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_4(*a)) != 0;
+#endif
 }
 
 static inline int x86_this_cpu_variable_test_bit(int nr,
diff -puN include/linux/percpu.h~percpu-remove-percpu_xxx-functions include/linux/percpu.h
--- a/include/linux/percpu.h~percpu-remove-percpu_xxx-functions
+++ a/include/linux/percpu.h
@@ -166,60 +166,6 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
 /*
- * Optional methods for optimized non-lvalue per-cpu variable access.
- *
- * @var can be a percpu variable or a field of it and its size should
- * equal char, int or long.  percpu_read() evaluates to a lvalue and
- * all others to void.
- *
- * These operations are guaranteed to be atomic.
- * The generic versions disable interrupts.  Archs are
- * encouraged to implement single-instruction alternatives which don't
- * require protection.
- */
-#ifndef percpu_read
-# define percpu_read(var)						\
-  ({									\
-	typeof(var) *pr_ptr__ = &(var);					\
-	typeof(var) pr_ret__;						\
-	pr_ret__ = get_cpu_var(*pr_ptr__);				\
-	put_cpu_var(*pr_ptr__);						\
-	pr_ret__;							\
-  })
-#endif
-
-#define __percpu_generic_to_op(var, val, op)				\
-do {									\
-	typeof(var) *pgto_ptr__ = &(var);				\
-	get_cpu_var(*pgto_ptr__) op val;				\
-	put_cpu_var(*pgto_ptr__);					\
-} while (0)
-
-#ifndef percpu_write
-# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
-#endif
-
-#ifndef percpu_add
-# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
-#endif
-
-#ifndef percpu_sub
-# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
-#endif
-
-#ifndef percpu_and
-# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
-#endif
-
-#ifndef percpu_or
-# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
-#endif
-
-#ifndef percpu_xor
-# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
-#endif
-
-/*
  * Branching function to split up a function into a set of functions that
  * are called for different scalar sizes of the objects handled.
  */
diff -puN arch/x86/include/asm/fpu-internal.h~percpu-remove-percpu_xxx-functions arch/x86/include/asm/fpu-internal.h
--- a/arch/x86/include/asm/fpu-internal.h~percpu-remove-percpu_xxx-functions
+++ a/arch/x86/include/asm/fpu-internal.h
@@ -290,14 +290,14 @@ static inline int __thread_has_fpu(struc
 static inline void __thread_clear_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu = 0;
-	percpu_write(fpu_owner_task, NULL);
+	__this_cpu_write(fpu_owner_task, NULL);
 }
 
 /* Must be paired with a 'clts' before! */
 static inline void __thread_set_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu = 1;
-	percpu_write(fpu_owner_task, tsk);
+	__this_cpu_write(fpu_owner_task, tsk);
 }
 
 /*
_

Patches currently in -mm which might be from alex.shi@intel.com are

mm-move-is_vma_temporary_stack-declaration-to-huge_mmh.patch

