From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:53:27 -0800
Message-ID: <200702220253.l1M2rRmB002469@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34578 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXBVCxc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:53:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>


akpm:
> Can we lose __HAVE_ARCH_MM_LIFETIME?  Just define these (preferably in C,
> not in cpp) in the appropriate include/asm-foo/ files?

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: linux-arch@vger.kernel.org

---

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/mmu_context.h     |    9 +++++++++
 include/asm-arm/mmu_context.h       |    9 +++++++++
 include/asm-arm26/mmu_context.h     |    9 +++++++++
 include/asm-avr32/mmu_context.h     |    9 +++++++++
 include/asm-cris/mmu_context.h      |    8 ++++++++
 include/asm-frv/mmu_context.h       |    8 ++++++++
 include/asm-h8300/mmu_context.h     |    8 ++++++++
 include/asm-i386/mmu_context.h      |    2 +-
 include/asm-i386/paravirt.h         |   18 +++++++++++++++---
 include/asm-ia64/mmu_context.h      |    8 ++++++++
 include/asm-m32r/mmu_context.h      |    8 ++++++++
 include/asm-m68k/mmu_context.h      |    8 ++++++++
 include/asm-m68knommu/mmu_context.h |    8 ++++++++
 include/asm-mips/mmu_context.h      |    8 ++++++++
 include/asm-parisc/mmu_context.h    |    9 +++++++++
 include/asm-powerpc/mmu_context.h   |   10 ++++++++++
 include/asm-ppc/mmu_context.h       |    9 +++++++++
 include/asm-s390/mmu_context.h      |    8 ++++++++
 include/asm-sh/mmu_context.h        |    8 ++++++++
 include/asm-sh64/mmu_context.h      |    8 ++++++++
 include/asm-sparc/mmu_context.h     |    8 ++++++++
 include/asm-sparc64/mmu_context.h   |    8 ++++++++
 include/asm-um/mmu_context.h        |    8 ++++++++
 include/asm-v850/mmu_context.h      |    8 ++++++++
 include/asm-x86_64/mmu_context.h    |    8 ++++++++
 include/asm-xtensa/mmu_context.h    |    9 +++++++++
 include/linux/sched.h               |    6 ------
 mm/mmap.c                           |    1 +
 28 files changed, 218 insertions(+), 10 deletions(-)

diff -puN include/asm-alpha/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-alpha/mmu_context.h
--- a/include/asm-alpha/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-alpha/mmu_context.h
@@ -256,4 +256,13 @@ enter_lazy_tlb(struct mm_struct *mm, str
 #undef __MMU_EXTERN_INLINE
 #endif
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
 #endif /* __ALPHA_MMU_CONTEXT_H */
diff -puN include/asm-arm/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-arm/mmu_context.h
--- a/include/asm-arm/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-arm/mmu_context.h
@@ -108,4 +108,13 @@ switch_mm(struct mm_struct *prev, struct
 #define deactivate_mm(tsk,mm)	do { } while (0)
 #define activate_mm(prev,next)	switch_mm(prev, next, NULL)
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
 #endif
diff -puN include/asm-arm26/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-arm26/mmu_context.h
--- a/include/asm-arm26/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-arm26/mmu_context.h
@@ -48,4 +48,13 @@ static inline void activate_mm(struct mm
 	cpu_switch_mm(next->pgd, next);
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
 #endif
diff -puN include/asm-avr32/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-avr32/mmu_context.h
--- a/include/asm-avr32/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-avr32/mmu_context.h
@@ -145,4 +145,13 @@ static inline void disable_mmu(void)
 	sysreg_write(MMUCR, SYSREG_BIT(MMUCR_S));
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
 #endif /* __ASM_AVR32_MMU_CONTEXT_H */
diff -puN include/asm-cris/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-cris/mmu_context.h
--- a/include/asm-cris/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-cris/mmu_context.h
@@ -21,4 +21,12 @@ static inline void enter_lazy_tlb(struct
 {
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif
diff -puN include/asm-frv/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-frv/mmu_context.h
--- a/include/asm-frv/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-frv/mmu_context.h
@@ -46,4 +46,12 @@ do {									\
 do {						\
 } while(0)
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif
diff -puN include/asm-h8300/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-h8300/mmu_context.h
--- a/include/asm-h8300/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-h8300/mmu_context.h
@@ -28,4 +28,12 @@ static inline void activate_mm(struct mm
 {
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif
diff -puN include/asm-i386/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-i386/mmu_context.h
--- a/include/asm-i386/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-i386/mmu_context.h
@@ -68,7 +68,7 @@ static inline void switch_mm(struct mm_s
 
 #define activate_mm(prev, next)				\
 	do {						\
-		arch_activate_mm(prev, next);		\
+		paravirt_activate_mm(prev, next);	\
 		switch_mm((prev),(next),NULL);		\
 	} while(0);
 
diff -puN include/asm-i386/paravirt.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-i386/paravirt.h
@@ -432,9 +432,8 @@ static inline void startup_ipi_hook(int 
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
@@ -695,5 +694,18 @@ static inline void paravirt_pagetable_se
 #endif
 }
 
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif /* CONFIG_PARAVIRT */
 #endif	/* __ASM_PARAVIRT_H */
diff -puN include/asm-ia64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-ia64/mmu_context.h
--- a/include/asm-ia64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-ia64/mmu_context.h
@@ -197,5 +197,13 @@ activate_mm (struct mm_struct *prev, str
 
 #define switch_mm(prev_mm,next_mm,next_task)	activate_mm(prev_mm, next_mm)
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 # endif /* ! __ASSEMBLY__ */
 #endif /* _ASM_IA64_MMU_CONTEXT_H */
diff -puN include/asm-m32r/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-m32r/mmu_context.h
--- a/include/asm-m32r/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-m32r/mmu_context.h
@@ -157,6 +157,14 @@ static inline void switch_mm(struct mm_s
 #define enter_lazy_tlb(mm,tsk)          do { } while (0)
 #endif /* not CONFIG_MMU */
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif /* not __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff -puN include/asm-m68k/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-m68k/mmu_context.h
--- a/include/asm-m68k/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-m68k/mmu_context.h
@@ -149,5 +149,13 @@ static inline void activate_mm(struct mm
 	activate_context(next_mm);
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif
 #endif
diff -puN include/asm-m68knommu/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-m68knommu/mmu_context.h
--- a/include/asm-m68knommu/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-m68knommu/mmu_context.h
@@ -29,4 +29,12 @@ static inline void activate_mm(struct mm
 {
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif
diff -puN include/asm-mips/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-mips/mmu_context.h
--- a/include/asm-mips/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-mips/mmu_context.h
@@ -293,4 +293,12 @@ drop_mmu_context(struct mm_struct *mm, u
 	local_irq_restore(flags);
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif /* _ASM_MMU_CONTEXT_H */
diff -puN include/asm-parisc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-parisc/mmu_context.h
--- a/include/asm-parisc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-parisc/mmu_context.h
@@ -70,4 +70,13 @@ static inline void activate_mm(struct mm
 
 	switch_mm(prev,next,current);
 }
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif
diff -puN include/asm-powerpc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-powerpc/mmu_context.h
--- a/include/asm-powerpc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-powerpc/mmu_context.h
@@ -80,5 +80,15 @@ static inline void activate_mm(struct mm
 }
 
 #endif /* CONFIG_PPC64 */
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
 #endif /* __KERNEL__ */
 #endif /* __ASM_POWERPC_MMU_CONTEXT_H */
diff -puN include/asm-ppc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-ppc/mmu_context.h
--- a/include/asm-ppc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-ppc/mmu_context.h
@@ -197,5 +197,14 @@ static inline void switch_mm(struct mm_s
 
 extern void mmu_context_init(void);
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
 #endif /* __PPC_MMU_CONTEXT_H */
 #endif /* __KERNEL__ */
diff -puN include/asm-s390/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-s390/mmu_context.h
--- a/include/asm-s390/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-s390/mmu_context.h
@@ -67,4 +67,12 @@ static inline void activate_mm(struct mm
 	set_fs(current->thread.mm_segment);
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif /* __S390_MMU_CONTEXT_H */
diff -puN include/asm-sh/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-sh/mmu_context.h
--- a/include/asm-sh/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-sh/mmu_context.h
@@ -214,5 +214,13 @@ static inline void disable_mmu(void)
 #define disable_mmu()	do { BUG(); } while (0)
 #endif
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif /* __KERNEL__ */
 #endif /* __ASM_SH_MMU_CONTEXT_H */
diff -puN include/asm-sh64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-sh64/mmu_context.h
--- a/include/asm-sh64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-sh64/mmu_context.h
@@ -203,6 +203,14 @@ enter_lazy_tlb(struct mm_struct *mm, str
 {
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif	/* __ASSEMBLY__ */
 
 #endif /* __ASM_SH64_MMU_CONTEXT_H */
diff -puN include/asm-sparc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-sparc/mmu_context.h
--- a/include/asm-sparc/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-sparc/mmu_context.h
@@ -35,6 +35,14 @@ BTFIXUPDEF_CALL(void, switch_mm, struct 
 /* Activate a new MM instance for the current task. */
 #define activate_mm(active_mm, mm) switch_mm((active_mm), (mm), NULL)
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif /* !(__ASSEMBLY__) */
 
 #endif /* !(__SPARC_MMU_CONTEXT_H) */
diff -puN include/asm-sparc64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-sparc64/mmu_context.h
--- a/include/asm-sparc64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-sparc64/mmu_context.h
@@ -147,6 +147,14 @@ static inline void activate_mm(struct mm
 	spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif /* !(__ASSEMBLY__) */
 
 #endif /* !(__SPARC64_MMU_CONTEXT_H) */
diff -puN include/asm-um/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-um/mmu_context.h
@@ -74,6 +74,14 @@ static inline void destroy_context(struc
 	CHOOSE_MODE((void) 0, destroy_context_skas(mm));
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif
 
 /*
diff -puN include/asm-v850/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-v850/mmu_context.h
--- a/include/asm-v850/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-v850/mmu_context.h
@@ -8,4 +8,12 @@
 #define activate_mm(prev,next)		((void)0)
 #define enter_lazy_tlb(mm,tsk)		((void)0)
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 #endif /* __V850_MMU_CONTEXT_H__ */
diff -puN include/asm-x86_64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-x86_64/mmu_context.h
--- a/include/asm-x86_64/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-x86_64/mmu_context.h
@@ -69,5 +69,13 @@ static inline void switch_mm(struct mm_s
 #define activate_mm(prev, next) \
 	switch_mm((prev),(next),NULL)
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
 
 #endif
diff -puN include/asm-xtensa/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations include/asm-xtensa/mmu_context.h
--- a/include/asm-xtensa/mmu_context.h~xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations
+++ a/include/asm-xtensa/mmu_context.h
@@ -131,4 +131,13 @@ static inline void enter_lazy_tlb(struct
 
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
 #endif /* _XTENSA_MMU_CONTEXT_H */
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

xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-clean-up-elf-note-generation.patch
xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
