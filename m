From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch added
 to -mm tree
Date: Mon, 11 May 2020 13:50:44 -0700
Message-ID: <20200511205044.VbIRewXsB%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgEKUur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 16:50:47 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, fenghua.yu@intel.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm/hugetlb: define a generic fallback for is_hugepage_only_range()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/hugetlb: define a generic fallback for is_hugepage_only_range()

There are multiple similar definitions for is_hugepage_only_range() on
various platforms.  Lets just add it's generic fallback definition for
platforms that do not override.  This help reduce code duplication.

Link: http://lkml.kernel.org/r/1588907271-11920-3-git-send-email-anshuman.khandual@arm.com
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

 arch/arm/include/asm/hugetlb.h     |    6 ------
 arch/arm64/include/asm/hugetlb.h   |    6 ------
 arch/ia64/include/asm/hugetlb.h    |    1 +
 arch/mips/include/asm/hugetlb.h    |    7 -------
 arch/parisc/include/asm/hugetlb.h  |    6 ------
 arch/powerpc/include/asm/hugetlb.h |    1 +
 arch/riscv/include/asm/hugetlb.h   |    6 ------
 arch/s390/include/asm/hugetlb.h    |    7 -------
 arch/sh/include/asm/hugetlb.h      |    6 ------
 arch/sparc/include/asm/hugetlb.h   |    6 ------
 arch/x86/include/asm/hugetlb.h     |    6 ------
 include/linux/hugetlb.h            |    9 +++++++++
 12 files changed, 11 insertions(+), 56 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -17,12 +17,6 @@
 extern bool arch_hugetlb_migration_supported(struct hstate *h);
 #endif
 
-static inline int is_hugepage_only_range(struct mm_struct *mm,
-					 unsigned long addr, unsigned long len)
-{
-	return 0;
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 	clear_bit(PG_dcache_clean, &page->flags);
--- a/arch/arm/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/arm/include/asm/hugetlb.h
@@ -14,12 +14,6 @@
 #include <asm/hugetlb-3level.h>
 #include <asm-generic/hugetlb.h>
 
-static inline int is_hugepage_only_range(struct mm_struct *mm,
-					 unsigned long addr, unsigned long len)
-{
-	return 0;
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 	clear_bit(PG_dcache_clean, &page->flags);
--- a/arch/ia64/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/ia64/include/asm/hugetlb.h
@@ -20,6 +20,7 @@ static inline int is_hugepage_only_range
 	return (REGION_NUMBER(addr) == RGN_HPAGE ||
 		REGION_NUMBER((addr)+(len)-1) == RGN_HPAGE);
 }
+#define is_hugepage_only_range is_hugepage_only_range
 
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
 static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
--- a/arch/mips/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/mips/include/asm/hugetlb.h
@@ -11,13 +11,6 @@
 
 #include <asm/page.h>
 
-static inline int is_hugepage_only_range(struct mm_struct *mm,
-					 unsigned long addr,
-					 unsigned long len)
-{
-	return 0;
-}
-
 #define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
 static inline int prepare_hugepage_range(struct file *file,
 					 unsigned long addr,
--- a/arch/parisc/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/parisc/include/asm/hugetlb.h
@@ -12,12 +12,6 @@ void set_huge_pte_at(struct mm_struct *m
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep);
 
-static inline int is_hugepage_only_range(struct mm_struct *mm,
-					 unsigned long addr,
-					 unsigned long len) {
-	return 0;
-}
-
 /*
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
--- a/arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -30,6 +30,7 @@ static inline int is_hugepage_only_range
 		return slice_is_hugepage_only_range(mm, addr, len);
 	return 0;
 }
+#define is_hugepage_only_range is_hugepage_only_range
 
 #define __HAVE_ARCH_HUGETLB_FREE_PGD_RANGE
 void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
--- a/arch/riscv/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/riscv/include/asm/hugetlb.h
@@ -5,12 +5,6 @@
 #include <asm-generic/hugetlb.h>
 #include <asm/page.h>
 
-static inline int is_hugepage_only_range(struct mm_struct *mm,
-					 unsigned long addr,
-					 unsigned long len) {
-	return 0;
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 }
--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/s390/include/asm/hugetlb.h
@@ -21,13 +21,6 @@ pte_t huge_ptep_get(pte_t *ptep);
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 			      unsigned long addr, pte_t *ptep);
 
-static inline bool is_hugepage_only_range(struct mm_struct *mm,
-					  unsigned long addr,
-					  unsigned long len)
-{
-	return false;
-}
-
 /*
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
--- a/arch/sh/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/sh/include/asm/hugetlb.h
@@ -5,12 +5,6 @@
 #include <asm/cacheflush.h>
 #include <asm/page.h>
 
-static inline int is_hugepage_only_range(struct mm_struct *mm,
-					 unsigned long addr,
-					 unsigned long len) {
-	return 0;
-}
-
 /*
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
--- a/arch/sparc/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -20,12 +20,6 @@ void set_huge_pte_at(struct mm_struct *m
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep);
 
-static inline int is_hugepage_only_range(struct mm_struct *mm,
-					 unsigned long addr,
-					 unsigned long len) {
-	return 0;
-}
-
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
 static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
--- a/arch/x86/include/asm/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/arch/x86/include/asm/hugetlb.h
@@ -7,12 +7,6 @@
 
 #define hugepages_supported() boot_cpu_has(X86_FEATURE_PSE)
 
-static inline int is_hugepage_only_range(struct mm_struct *mm,
-					 unsigned long addr,
-					 unsigned long len) {
-	return 0;
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 }
--- a/include/linux/hugetlb.h~mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range
+++ a/include/linux/hugetlb.h
@@ -591,6 +591,15 @@ static inline unsigned int blocks_per_hu
 
 #include <asm/hugetlb.h>
 
+#ifndef is_hugepage_only_range
+static inline int is_hugepage_only_range(struct mm_struct *mm,
+					unsigned long addr, unsigned long len)
+{
+	return 0;
+}
+#define is_hugepage_only_range is_hugepage_only_range
+#endif
+
 #ifndef arch_make_huge_pte
 static inline pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
 				       struct page *page, int writable)
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

arm64-mm-drop-__have_arch_huge_ptep_get.patch
mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch
mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags.patch
powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
