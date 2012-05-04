From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-change-percpu_read_stable-to-this_cpu_read_stable.patch removed from -mm tree
Date: Fri, 04 May 2012 14:29:49 -0700
Message-ID: <20120504212949.8F626A0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:54077 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759890Ab2EDV3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2012 17:29:52 -0400
Received: by laai8 with SMTP id i8so173252laa.1
        for <mm-commits@vger.kernel.org>; Fri, 04 May 2012 14:29:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, cl@gentwo.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: change percpu_read_stable() to this_cpu_read_stable()
has been removed from the -mm tree.  Its filename was
     x86-change-percpu_read_stable-to-this_cpu_read_stable.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: x86: change percpu_read_stable() to this_cpu_read_stable()

It has no function change. It's a preparation for percpu_xxx serial
function change.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/current.h      |    2 +-
 arch/x86/include/asm/fpu-internal.h |    2 +-
 arch/x86/include/asm/percpu.h       |    6 +++---
 arch/x86/include/asm/thread_info.h  |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/current.h~x86-change-percpu_read_stable-to-this_cpu_read_stable arch/x86/include/asm/current.h
--- a/arch/x86/include/asm/current.h~x86-change-percpu_read_stable-to-this_cpu_read_stable
+++ a/arch/x86/include/asm/current.h
@@ -11,7 +11,7 @@ DECLARE_PER_CPU(struct task_struct *, cu
 
 static __always_inline struct task_struct *get_current(void)
 {
-	return percpu_read_stable(current_task);
+	return this_cpu_read_stable(current_task);
 }
 
 #define current get_current()
diff -puN arch/x86/include/asm/fpu-internal.h~x86-change-percpu_read_stable-to-this_cpu_read_stable arch/x86/include/asm/fpu-internal.h
--- a/arch/x86/include/asm/fpu-internal.h~x86-change-percpu_read_stable-to-this_cpu_read_stable
+++ a/arch/x86/include/asm/fpu-internal.h
@@ -344,7 +344,7 @@ typedef struct { int preload; } fpu_swit
  */
 static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
 {
-	return new == percpu_read_stable(fpu_owner_task) &&
+	return new == this_cpu_read_stable(fpu_owner_task) &&
 		cpu == new->thread.fpu.last_cpu;
 }
 
diff -puN arch/x86/include/asm/percpu.h~x86-change-percpu_read_stable-to-this_cpu_read_stable arch/x86/include/asm/percpu.h
--- a/arch/x86/include/asm/percpu.h~x86-change-percpu_read_stable-to-this_cpu_read_stable
+++ a/arch/x86/include/asm/percpu.h
@@ -352,15 +352,15 @@ do {									\
 
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
- * accessed while percpu_read_stable() allows the value to be cached.
- * percpu_read_stable() is more efficient and can be used if its value
+ * accessed while this_cpu_read_stable() allows the value to be cached.
+ * this_cpu_read_stable() is more efficient and can be used if its value
  * is guaranteed to be valid across cpus.  The current users include
  * get_current() and get_thread_info() both of which are actually
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
 #define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
-#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
+#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
 #define percpu_write(var, val)		percpu_to_op("mov", var, val)
 #define percpu_add(var, val)		percpu_add_op(var, val)
 #define percpu_sub(var, val)		percpu_add_op(var, -(val))
diff -puN arch/x86/include/asm/thread_info.h~x86-change-percpu_read_stable-to-this_cpu_read_stable arch/x86/include/asm/thread_info.h
--- a/arch/x86/include/asm/thread_info.h~x86-change-percpu_read_stable-to-this_cpu_read_stable
+++ a/arch/x86/include/asm/thread_info.h
@@ -224,7 +224,7 @@ DECLARE_PER_CPU(unsigned long, kernel_st
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(percpu_read_stable(kernel_stack) +
+	ti = (void *)(this_cpu_read_stable(kernel_stack) +
 		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
_

Patches currently in -mm which might be from alex.shi@intel.com are

net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions.patch
mm-move-is_vma_temporary_stack-declaration-to-huge_mmh.patch

