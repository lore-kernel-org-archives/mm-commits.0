From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:57:01 -0800
Message-ID: <200703020457.l224v1Fp000493@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41909 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422905AbXCBE5H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:57:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, James.Bottomley@SteelEye.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: remove HAVE_ARCH_MM_LIFETIME, define no-op architecture implementations
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch

This patch was dropped because Zach's patches destroyed it all

------------------------------------------------------
Subject: xen-paravirt_ops: remove HAVE_ARCH_MM_LIFETIME, define no-op architecture implementations
From: Jeremy Fitzhardinge <jeremy@goop.org>

akpm:
> Can we lose __HAVE_ARCH_MM_LIFETIME?  Just define these (preferably in C,
> not in cpp) in the appropriate include/asm-foo/ files?

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: linux-arch@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/mmu_context.h     |    1 +
 include/asm-arm/mmu_context.h       |    1 +
 include/asm-arm26/mmu_context.h     |    2 ++
 include/asm-avr32/mmu_context.h     |    1 +
 include/asm-cris/mmu_context.h      |    2 ++
 include/asm-frv/mmu_context.h       |    1 +
 include/asm-generic/mm_hooks.h      |   18 ++++++++++++++++++
 include/asm-h8300/mmu_context.h     |    1 +
 include/asm-i386/mmu_context.h      |   11 ++++++++++-
 include/asm-i386/paravirt.h         |    5 ++---
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
 include/linux/sched.h               |    6 ------
 mm/mmap.c                           |    1 +
 29 files changed, 61 insertions(+), 11 deletions(-)

diff -puN include/asm-alpha/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-alpha/mmu_context.h
--- a/include/asm-alpha/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-alpha/mmu_context.h
@@ -10,6 +10,7 @@
 #include <asm/system.h>
 #include <asm/machvec.h>
 #include <asm/compiler.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Force a context reload. This is needed when we change the page
diff -puN include/asm-arm/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-arm/mmu_context.h
--- a/include/asm-arm/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-arm/mmu_context.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h>
 #include <asm/cacheflush.h>
 #include <asm/proc-fns.h>
+#include <asm-generic/mm_hooks.h>
 
 void __check_kvm_seq(struct mm_struct *mm);
 
diff -puN include/asm-arm26/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-arm26/mmu_context.h
--- a/include/asm-arm26/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-arm26/mmu_context.h
@@ -13,6 +13,8 @@
 #ifndef __ASM_ARM_MMU_CONTEXT_H
 #define __ASM_ARM_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 #define init_new_context(tsk,mm)	0
 #define destroy_context(mm)		do { } while(0)
 
diff -puN include/asm-avr32/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-avr32/mmu_context.h
--- a/include/asm-avr32/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-avr32/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/sysreg.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * The MMU "context" consists of two things:
diff -puN include/asm-cris/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-cris/mmu_context.h
--- a/include/asm-cris/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-cris/mmu_context.h
@@ -1,6 +1,8 @@
 #ifndef __CRIS_MMU_CONTEXT_H
 #define __CRIS_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 extern int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
 extern void get_mmu_context(struct mm_struct *mm);
 extern void destroy_context(struct mm_struct *mm);
diff -puN include/asm-frv/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-frv/mmu_context.h
--- a/include/asm-frv/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
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
diff -puN include/asm-h8300/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-h8300/mmu_context.h
--- a/include/asm-h8300/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-h8300/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-i386/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-i386/mmu_context.h
--- a/include/asm-i386/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-i386/mmu_context.h
@@ -6,6 +6,15 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
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
@@ -68,7 +77,7 @@ static inline void switch_mm(struct mm_s
 
 #define activate_mm(prev, next)				\
 	do {						\
-		arch_activate_mm(prev, next);		\
+		paravirt_activate_mm(prev, next);	\
 		switch_mm((prev),(next),NULL);		\
 	} while(0);
 
diff -puN include/asm-i386/paravirt.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-i386/paravirt.h
@@ -394,9 +394,8 @@ static inline void startup_ipi_hook(int 
 }
 #endif
 
-#define __HAVE_ARCH_MM_LIFETIME
-static inline void arch_activate_mm(struct mm_struct *prev,
-				    struct mm_struct *next)
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
 {
 	paravirt_ops.activate_mm(prev, next);
 }
diff -puN include/asm-ia64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-ia64/mmu_context.h
--- a/include/asm-ia64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-ia64/mmu_context.h
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/processor.h>
+#include <asm-generic/mm_hooks.h>
 
 struct ia64_ctx {
 	spinlock_t lock;
diff -puN include/asm-m32r/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-m32r/mmu_context.h
--- a/include/asm-m32r/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-m32r/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/pgalloc.h>
 #include <asm/mmu.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Cache of MMU context last used.
diff -puN include/asm-m68k/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-m68k/mmu_context.h
--- a/include/asm-m68k/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-m68k/mmu_context.h
@@ -1,6 +1,7 @@
 #ifndef __M68K_MMU_CONTEXT_H
 #define __M68K_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-m68knommu/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-m68knommu/mmu_context.h
--- a/include/asm-m68knommu/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-m68knommu/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-mips/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-mips/mmu_context.h
--- a/include/asm-mips/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-mips/mmu_context.h
@@ -20,6 +20,7 @@
 #include <asm/mipsmtregs.h>
 #include <asm/smtc.h>
 #endif /* SMTC */
+#include <asm-generic/mm_hooks.h>
 
 /*
  * For the fast tlb miss handlers, we keep a per cpu array of pointers
diff -puN include/asm-parisc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-parisc/mmu_context.h
--- a/include/asm-parisc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-parisc/mmu_context.h
@@ -5,6 +5,7 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-powerpc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-powerpc/mmu_context.h
--- a/include/asm-powerpc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-powerpc/mmu_context.h
@@ -10,6 +10,7 @@
 #include <linux/mm.h>	
 #include <asm/mmu.h>	
 #include <asm/cputable.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Copyright (C) 2001 PPC 64 Team, IBM Corp
diff -puN include/asm-ppc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-ppc/mmu_context.h
--- a/include/asm-ppc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-ppc/mmu_context.h
@@ -6,6 +6,7 @@
 #include <asm/bitops.h>
 #include <asm/mmu.h>
 #include <asm/cputable.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * On 32-bit PowerPC 6xx/7xx/7xxx CPUs, we use a set of 16 VSIDs
diff -puN include/asm-s390/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-s390/mmu_context.h
--- a/include/asm-s390/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-s390/mmu_context.h
@@ -10,6 +10,8 @@
 #define __S390_MMU_CONTEXT_H
 
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
+
 /*
  * get a new mmu context.. S390 don't know about contexts.
  */
diff -puN include/asm-sh/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-sh/mmu_context.h
--- a/include/asm-sh/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-sh/mmu_context.h
@@ -12,6 +12,7 @@
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * The MMU "context" consists of two things:
diff -puN include/asm-sh64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-sh64/mmu_context.h
--- a/include/asm-sh64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-sh64/mmu_context.h
@@ -27,7 +27,7 @@
 extern unsigned long mmu_context_cache;
 
 #include <asm/page.h>
-
+#include <asm-generic/mm_hooks.h>
 
 /* Current mm's pgd */
 extern pgd_t *mmu_pdtp_cache;
diff -puN include/asm-sparc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-sparc/mmu_context.h
--- a/include/asm-sparc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-sparc/mmu_context.h
@@ -5,6 +5,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm-generic/mm_hooks.h>
+
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 }
diff -puN include/asm-sparc64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-sparc64/mmu_context.h
--- a/include/asm-sparc64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-sparc64/mmu_context.h
@@ -9,6 +9,7 @@
 #include <linux/spinlock.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
diff -puN include/asm-um/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-um/mmu_context.h
@@ -6,6 +6,8 @@
 #ifndef __UM_MMU_CONTEXT_H
 #define __UM_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 #include "linux/sched.h"
 #include "choose-mode.h"
 #include "um_mmu.h"
diff -puN include/asm-v850/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-v850/mmu_context.h
--- a/include/asm-v850/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-v850/mmu_context.h
@@ -1,6 +1,8 @@
 #ifndef __V850_MMU_CONTEXT_H__
 #define __V850_MMU_CONTEXT_H__
 
+#include <asm-generic/mm_hooks.h>
+
 #define destroy_context(mm)		((void)0)
 #define init_new_context(tsk,mm)	0
 #define switch_mm(prev,next,tsk)	((void)0)
diff -puN include/asm-x86_64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-x86_64/mmu_context.h
--- a/include/asm-x86_64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-x86_64/mmu_context.h
@@ -7,6 +7,7 @@
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * possibly do the LDT unload here?
diff -puN include/asm-xtensa/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-xtensa/mmu_context.h
--- a/include/asm-xtensa/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-xtensa/mmu_context.h
@@ -18,6 +18,7 @@
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 #define XCHAL_MMU_ASID_BITS	8
 
diff -puN include/linux/sched.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/linux/sched.h
--- a/include/linux/sched.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/linux/sched.h
@@ -375,12 +375,6 @@ struct mm_struct {
 	struct kioctx		*ioctx_list;
 };
 
-#ifndef __HAVE_ARCH_MM_LIFETIME
-#define arch_activate_mm(prev, next)	do {} while(0)
-#define arch_dup_mmap(oldmm, mm)	do {} while(0)
-#define arch_exit_mmap(mm)		do {} while(0)
-#endif
-
 struct sighand_struct {
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
diff -puN mm/mmap.c~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations mm/mmap.c
--- a/mm/mmap.c~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/mm/mmap.c
@@ -29,6 +29,7 @@
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
+#include <asm/mmu_context.h>
 
 #ifndef arch_mmap_check
 #define arch_mmap_check(addr, len, flags)	(0)
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
