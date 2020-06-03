From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 077/131] mm/hugetlb: define a generic fallback for
 arch_clear_hugepage_flags()
Date: Wed, 03 Jun 2020 16:01:05 -0700
Message-ID: <20200603230105.jGhTFwJ4V%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXBH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:01:07 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, fenghua.yu@intel.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, James.Bottomley@HansenPartnership.com, linux-mm@kvack.org, linux@armlinux.org.uk, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, will@kernel.org, ysato@users.sourceforge.jp

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/hugetlb: define a generic fallback for arch_clear_hugepage_flags()

There are multiple similar definitions for arch_clear_hugepage_flags() on
various platforms.  Lets just add it's generic fallback definition for
platforms that do not override.  This help reduce code duplication.

Link: http://lkml.kernel.org/r/1588907271-11920-4-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/hugetlb.h     |    1 +
 arch/arm64/include/asm/hugetlb.h   |    1 +
 arch/ia64/include/asm/hugetlb.h    |    4 ----
 arch/mips/include/asm/hugetlb.h    |    4 ----
 arch/parisc/include/asm/hugetlb.h  |    4 ----
 arch/powerpc/include/asm/hugetlb.h |    4 ----
 arch/riscv/include/asm/hugetlb.h   |    4 ----
 arch/s390/include/asm/hugetlb.h    |    1 +
 arch/sh/include/asm/hugetlb.h      |    1 +
 arch/sparc/include/asm/hugetlb.h   |    4 ----
 arch/x86/include/asm/hugetlb.h     |    4 ----
 include/linux/hugetlb.h            |    5 +++++
 12 files changed, 9 insertions(+), 28 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -21,6 +21,7 @@ static inline void arch_clear_hugepage_f
 {
 	clear_bit(PG_dcache_clean, &page->flags);
 }
+#define arch_clear_hugepage_flags arch_clear_hugepage_flags
 
 extern pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
 				struct page *page, int writable);
--- a/arch/arm/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/arm/include/asm/hugetlb.h
@@ -18,5 +18,6 @@ static inline void arch_clear_hugepage_f
 {
 	clear_bit(PG_dcache_clean, &page->flags);
 }
+#define arch_clear_hugepage_flags arch_clear_hugepage_flags
 
 #endif /* _ASM_ARM_HUGETLB_H */
--- a/arch/ia64/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/ia64/include/asm/hugetlb.h
@@ -28,10 +28,6 @@ static inline void huge_ptep_clear_flush
 {
 }
 
-static inline void arch_clear_hugepage_flags(struct page *page)
-{
-}
-
 #include <asm-generic/hugetlb.h>
 
 #endif /* _ASM_IA64_HUGETLB_H */
--- a/arch/mips/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/mips/include/asm/hugetlb.h
@@ -75,10 +75,6 @@ static inline int huge_ptep_set_access_f
 	return changed;
 }
 
-static inline void arch_clear_hugepage_flags(struct page *page)
-{
-}
-
 #include <asm-generic/hugetlb.h>
 
 #endif /* __ASM_HUGETLB_H */
--- a/arch/parisc/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/parisc/include/asm/hugetlb.h
@@ -42,10 +42,6 @@ int huge_ptep_set_access_flags(struct vm
 					     unsigned long addr, pte_t *ptep,
 					     pte_t pte, int dirty);
 
-static inline void arch_clear_hugepage_flags(struct page *page)
-{
-}
-
 #include <asm-generic/hugetlb.h>
 
 #endif /* _ASM_PARISC64_HUGETLB_H */
--- a/arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -61,10 +61,6 @@ int huge_ptep_set_access_flags(struct vm
 			       unsigned long addr, pte_t *ptep,
 			       pte_t pte, int dirty);
 
-static inline void arch_clear_hugepage_flags(struct page *page)
-{
-}
-
 #include <asm-generic/hugetlb.h>
 
 #else /* ! CONFIG_HUGETLB_PAGE */
--- a/arch/riscv/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/riscv/include/asm/hugetlb.h
@@ -5,8 +5,4 @@
 #include <asm-generic/hugetlb.h>
 #include <asm/page.h>
 
-static inline void arch_clear_hugepage_flags(struct page *page)
-{
-}
-
 #endif /* _ASM_RISCV_HUGETLB_H */
--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/s390/include/asm/hugetlb.h
@@ -39,6 +39,7 @@ static inline void arch_clear_hugepage_f
 {
 	clear_bit(PG_arch_1, &page->flags);
 }
+#define arch_clear_hugepage_flags arch_clear_hugepage_flags
 
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 				  pte_t *ptep, unsigned long sz)
--- a/arch/sh/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/sh/include/asm/hugetlb.h
@@ -30,6 +30,7 @@ static inline void arch_clear_hugepage_f
 {
 	clear_bit(PG_dcache_clean, &page->flags);
 }
+#define arch_clear_hugepage_flags arch_clear_hugepage_flags
 
 #include <asm-generic/hugetlb.h>
 
--- a/arch/sparc/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -47,10 +47,6 @@ static inline int huge_ptep_set_access_f
 	return changed;
 }
 
-static inline void arch_clear_hugepage_flags(struct page *page)
-{
-}
-
 #define __HAVE_ARCH_HUGETLB_FREE_PGD_RANGE
 void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 			    unsigned long end, unsigned long floor,
--- a/arch/x86/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags
+++ a/arch/x86/include/asm/hugetlb.h
@@ -7,8 +7,4 @@
 
 #define hugepages_supported() boot_cpu_has(X86_FEATURE_PSE)
 
-static inline void arch_clear_hugepage_flags(struct page *page)
-{
-}
