From: akpm@linux-foundation.org
Subject: + paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch added to -mm tree
Date: Fri, 06 Apr 2007 16:26:31 -0700
Message-ID: <200704062326.l36NQVjF022514@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38353 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbXDFX0o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 19:26:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, James.Bottomley@SteelEye.com, jeremy@xensource.com, mingo@elte.hu


The patch titled
     paravirt_ops: add hooks to intercept mm creation and destruction
has been added to the -mm tree.  Its filename is
     paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paravirt_ops: add hooks to intercept mm creation and destruction
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add hooks to allow a paravirt implementation to track the lifetime of an mm. 
Paravirtualization requires three hooks, but only two are needed in common
code.  They are:

arch_dup_mmap, which is called when a new mmap is created at fork

arch_exit_mmap, which is called when the last process reference to an mm is
dropped, which typically happens on exit and exec.

The third hook is activate_mm, which is called from the arch-specific
activate_mm() macro/function, and so doesn't need stub versions for other
architectures.  It's called when an mm is first used.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: linux-arch@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c         |    4 ++++
 include/asm-alpha/mmu_context.h     |    1 +
 include/asm-arm/mmu_context.h       |    1 +
 include/asm-arm26/mmu_context.h     |    2 ++
 include/asm-avr32/mmu_context.h     |    1 +
 include/asm-cris/mmu_context.h      |    2 ++
 include/asm-frv/mmu_context.h       |    1 +
 include/asm-generic/mm_hooks.h      |   18 ++++++++++++++++++
 include/asm-h8300/mmu_context.h     |    1 +
 include/asm-i386/mmu_context.h      |   17 +++++++++++++++--
 include/asm-i386/paravirt.h         |   23 +++++++++++++++++++++++
 include/asm-ia64/mmu_context.h      |    1 +
 include/asm-m32r/mmu_context.h      |    1 +
 include/asm-m68k/mmu_context.h      |    1 +
 include/asm-m68knommu/mmu_context.h |    1 +
 include/asm-mips/mmu_context.h      |    1 +
 include/asm-parisc/mmu_context.h    |    1 +
 include/asm-powerpc/mmu_context.h   |    1 +
 include/asm-ppc/mmu_context.h       |    1 +
 include/asm-s390/mmu_context.h      |    2 ++
 include/asm-sh/mmu_context.h        |    1 +
 include/asm-sh64/mmu_context.h      |    2 +-
 include/asm-sparc/mmu_context.h     |    2 ++
 include/asm-sparc64/mmu_context.h   |    1 +
 include/asm-um/mmu_context.h        |    2 ++
 include/asm-v850/mmu_context.h      |    2 ++
 include/asm-x86_64/mmu_context.h    |    1 +
 include/asm-xtensa/mmu_context.h    |    1 +
 kernel/fork.c                       |    2 ++
 mm/mmap.c                           |    4 ++++
 30 files changed, 96 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/arch/i386/kernel/paravirt.c
@@ -237,6 +237,10 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
+	.dup_mmap = paravirt_nop,
+	.exit_mmap = paravirt_nop,
+	.activate_mm = paravirt_nop,
+
 	.startup_ipi_hook = paravirt_nop,
 };
 
diff -puN include/asm-alpha/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-alpha/mmu_context.h
--- a/include/asm-alpha/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-alpha/mmu_context.h
@@ -10,6 +10,7 @@
 #include <asm/system.h>
 #include <asm/machvec.h>
 #include <asm/compiler.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Force a context reload. This is needed when we change the page
diff -puN include/asm-arm/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-arm/mmu_context.h
--- a/include/asm-arm/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-arm/mmu_context.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h>
 #include <asm/cacheflush.h>
 #include <asm/proc-fns.h>
+#include <asm-generic/mm_hooks.h>
 
 void __check_kvm_seq(struct mm_struct *mm);
 
diff -puN include/asm-arm26/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-arm26/mmu_context.h
--- a/include/asm-arm26/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-arm26/mmu_context.h
@@ -13,6 +13,8 @@
 #ifndef __ASM_ARM_MMU_CONTEXT_H
 #define __ASM_ARM_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 #define init_new_context(tsk,mm)	0
 #define destroy_context(mm)		do { } while(0)
 
diff -puN include/asm-avr32/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-avr32/mmu_context.h
--- a/include/asm-avr32/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-avr32/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/sysreg.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * The MMU "context" consists of two things:
diff -puN include/asm-cris/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-cris/mmu_context.h
--- a/include/asm-cris/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-cris/mmu_context.h
@@ -1,6 +1,8 @@
 #ifndef __CRIS_MMU_CONTEXT_H
 #define __CRIS_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 extern int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
 extern void get_mmu_context(struct mm_struct *mm);
 extern void destroy_context(struct mm_struct *mm);
diff -puN include/asm-frv/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-frv/mmu_context.h
--- a/include/asm-frv/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-frv/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN /dev/null include/asm-generic/mm_hooks.h
--- /dev/null
+++ a/include/asm-generic/mm_hooks.h
@@ -0,0 +1,18 @@
+/*
+ * Define generic no-op hooks for arch_dup_mmap and arch_exit_mmap, to
+ * be included in asm-FOO/mmu_context.h for any arch FOO which doesn't
+ * need to hook these.
+ */
+#ifndef _ASM_GENERIC_MM_HOOKS_H
+#define _ASM_GENERIC_MM_HOOKS_H
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
+#endif	/* _ASM_GENERIC_MM_HOOKS_H */
diff -puN include/asm-h8300/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-h8300/mmu_context.h
--- a/include/asm-h8300/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-h8300/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-i386/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-i386/mmu_context.h
--- a/include/asm-i386/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-i386/mmu_context.h
@@ -5,6 +5,16 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
+#include <asm/paravirt.h>
+#ifndef CONFIG_PARAVIRT
+#include <asm-generic/mm_hooks.h>
+
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+#endif	/* !CONFIG_PARAVIRT */
+
 
 /*
  * Used for LDT copy/destruction.
@@ -65,7 +75,10 @@ static inline void switch_mm(struct mm_s
 #define deactivate_mm(tsk, mm)			\
 	asm("movl %0,%%gs": :"r" (0));
 
-#define activate_mm(prev, next) \
-	switch_mm((prev),(next),NULL)
+#define activate_mm(prev, next)				\
+	do {						\
+		paravirt_activate_mm(prev, next);	\
+		switch_mm((prev),(next),NULL);		\
+	} while(0);
 
 #endif
diff -puN include/asm-i386/paravirt.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-i386/paravirt.h
@@ -119,6 +119,12 @@ struct paravirt_ops
 
 	void (*io_delay)(void);
 
+	void (*activate_mm)(struct mm_struct *prev,
+			    struct mm_struct *next);
+	void (*dup_mmap)(struct mm_struct *oldmm,
+			 struct mm_struct *mm);
+	void (*exit_mmap)(struct mm_struct *mm);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	void (*apic_write)(unsigned long reg, unsigned long v);
 	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
@@ -395,6 +401,23 @@ static inline void startup_ipi_hook(int 
 }
 #endif
 
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+	paravirt_ops.activate_mm(prev, next);
+}
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+	paravirt_ops.dup_mmap(oldmm, mm);
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+	paravirt_ops.exit_mmap(mm);
+}
+
 #define __flush_tlb() paravirt_ops.flush_tlb_user()
 #define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
 #define __flush_tlb_single(addr) paravirt_ops.flush_tlb_single(addr)
diff -puN include/asm-ia64/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-ia64/mmu_context.h
--- a/include/asm-ia64/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-ia64/mmu_context.h
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/processor.h>
+#include <asm-generic/mm_hooks.h>
 
 struct ia64_ctx {
 	spinlock_t lock;
diff -puN include/asm-m32r/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-m32r/mmu_context.h
--- a/include/asm-m32r/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-m32r/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/pgalloc.h>
 #include <asm/mmu.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Cache of MMU context last used.
diff -puN include/asm-m68k/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-m68k/mmu_context.h
--- a/include/asm-m68k/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-m68k/mmu_context.h
@@ -1,6 +1,7 @@
 #ifndef __M68K_MMU_CONTEXT_H
 #define __M68K_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-m68knommu/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-m68knommu/mmu_context.h
--- a/include/asm-m68knommu/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-m68knommu/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-mips/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-mips/mmu_context.h
--- a/include/asm-mips/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-mips/mmu_context.h
@@ -20,6 +20,7 @@
 #include <asm/mipsmtregs.h>
 #include <asm/smtc.h>
 #endif /* SMTC */
+#include <asm-generic/mm_hooks.h>
 
 /*
  * For the fast tlb miss handlers, we keep a per cpu array of pointers
diff -puN include/asm-parisc/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-parisc/mmu_context.h
--- a/include/asm-parisc/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-parisc/mmu_context.h
@@ -5,6 +5,7 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-powerpc/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-powerpc/mmu_context.h
--- a/include/asm-powerpc/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-powerpc/mmu_context.h
@@ -10,6 +10,7 @@
 #include <linux/mm.h>	
 #include <asm/mmu.h>	
 #include <asm/cputable.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Copyright (C) 2001 PPC 64 Team, IBM Corp
diff -puN include/asm-ppc/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-ppc/mmu_context.h
--- a/include/asm-ppc/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-ppc/mmu_context.h
@@ -6,6 +6,7 @@
 #include <asm/bitops.h>
 #include <asm/mmu.h>
 #include <asm/cputable.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * On 32-bit PowerPC 6xx/7xx/7xxx CPUs, we use a set of 16 VSIDs
diff -puN include/asm-s390/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-s390/mmu_context.h
--- a/include/asm-s390/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-s390/mmu_context.h
@@ -10,6 +10,8 @@
 #define __S390_MMU_CONTEXT_H
 
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
+
 /*
  * get a new mmu context.. S390 don't know about contexts.
  */
diff -puN include/asm-sh/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-sh/mmu_context.h
--- a/include/asm-sh/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-sh/mmu_context.h
@@ -12,6 +12,7 @@
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * The MMU "context" consists of two things:
diff -puN include/asm-sh64/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-sh64/mmu_context.h
--- a/include/asm-sh64/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-sh64/mmu_context.h
@@ -27,7 +27,7 @@
 extern unsigned long mmu_context_cache;
 
 #include <asm/page.h>
-
+#include <asm-generic/mm_hooks.h>
 
 /* Current mm's pgd */
 extern pgd_t *mmu_pdtp_cache;
diff -puN include/asm-sparc/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-sparc/mmu_context.h
--- a/include/asm-sparc/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-sparc/mmu_context.h
@@ -5,6 +5,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm-generic/mm_hooks.h>
+
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 }
diff -puN include/asm-sparc64/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-sparc64/mmu_context.h
--- a/include/asm-sparc64/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-sparc64/mmu_context.h
@@ -9,6 +9,7 @@
 #include <linux/spinlock.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-um/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-um/mmu_context.h
@@ -6,6 +6,8 @@
 #ifndef __UM_MMU_CONTEXT_H
 #define __UM_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 #include "linux/sched.h"
 #include "choose-mode.h"
 #include "um_mmu.h"
diff -puN include/asm-v850/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-v850/mmu_context.h
--- a/include/asm-v850/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-v850/mmu_context.h
@@ -1,6 +1,8 @@
 #ifndef __V850_MMU_CONTEXT_H__
 #define __V850_MMU_CONTEXT_H__
 
+#include <asm-generic/mm_hooks.h>
+
 #define destroy_context(mm)		((void)0)
 #define init_new_context(tsk,mm)	0
 #define switch_mm(prev,next,tsk)	((void)0)
diff -puN include/asm-x86_64/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-x86_64/mmu_context.h
--- a/include/asm-x86_64/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-x86_64/mmu_context.h
@@ -7,6 +7,7 @@
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * possibly do the LDT unload here?
diff -puN include/asm-xtensa/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction include/asm-xtensa/mmu_context.h
--- a/include/asm-xtensa/mmu_context.h~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/include/asm-xtensa/mmu_context.h
@@ -18,6 +18,7 @@
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 #define XCHAL_MMU_ASID_BITS	8
 
diff -puN kernel/fork.c~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction kernel/fork.c
--- a/kernel/fork.c~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/kernel/fork.c
@@ -287,6 +287,8 @@ static inline int dup_mmap(struct mm_str
 		if (retval)
 			goto out;
 	}
+	/* a new mm has just been created */
+	arch_dup_mmap(oldmm, mm);
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
diff -puN mm/mmap.c~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction mm/mmap.c
--- a/mm/mmap.c~paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction
+++ a/mm/mmap.c
@@ -29,6 +29,7 @@
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
+#include <asm/mmu_context.h>
 
 #ifndef arch_mmap_check
 #define arch_mmap_check(addr, len, flags)	(0)
@@ -1979,6 +1980,9 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long nr_accounted = 0;
 	unsigned long end;
 
+	/* mm's last user has gone, and its about to be pulled down */
+	arch_exit_mmap(mm);
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
_

Patches currently in -mm which might be from jeremy@goop.org are

paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
