From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:37:39 -0700
Message-ID: <5591ac93.3zJa9j0YpyZSet9S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbbF2Uhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: reduce arch dependent code about hugetlb_prefault_arch_hook
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: mm/hugetlb: reduce arch dependent code about hugetlb_prefault_arch_hook

Currently we have many duplicates in definitions of
hugetlb_prefault_arch_hook.  In all architectures this function is empty.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/hugetlb.h     |    4 ----
 arch/arm64/include/asm/hugetlb.h   |    4 ----
 arch/ia64/include/asm/hugetlb.h    |    4 ----
 arch/metag/include/asm/hugetlb.h   |    4 ----
 arch/mips/include/asm/hugetlb.h    |    4 ----
 arch/powerpc/include/asm/hugetlb.h |    5 -----
 arch/s390/include/asm/hugetlb.h    |    1 -
 arch/sh/include/asm/hugetlb.h      |    3 ---
 arch/sparc/include/asm/hugetlb.h   |    4 ----
 arch/tile/include/asm/hugetlb.h    |    4 ----
 arch/x86/include/asm/hugetlb.h     |    3 ---
 fs/hugetlbfs/inode.c               |    1 -
 12 files changed, 41 deletions(-)

diff -puN arch/arm/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/arm/include/asm/hugetlb.h
--- a/arch/arm/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/arm/include/asm/hugetlb.h
@@ -53,10 +53,6 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
-{
-}
-
 static inline int huge_pte_none(pte_t pte)
 {
 	return pte_none(pte);
diff -puN arch/arm64/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/arm64/include/asm/hugetlb.h
--- a/arch/arm64/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -86,10 +86,6 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
-{
-}
-
 static inline int huge_pte_none(pte_t pte)
 {
 	return pte_none(pte);
diff -puN arch/ia64/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/ia64/include/asm/hugetlb.h
--- a/arch/ia64/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/ia64/include/asm/hugetlb.h
@@ -20,10 +20,6 @@ static inline int is_hugepage_only_range
 		REGION_NUMBER((addr)+(len)-1) == RGN_HPAGE);
 }
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
-{
-}
-
 static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 				   pte_t *ptep, pte_t pte)
 {
diff -puN arch/metag/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/metag/include/asm/hugetlb.h
--- a/arch/metag/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/metag/include/asm/hugetlb.h
@@ -14,10 +14,6 @@ static inline int is_hugepage_only_range
 int prepare_hugepage_range(struct file *file, unsigned long addr,
 						unsigned long len);
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
-{
-}
-
 static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
diff -puN arch/mips/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/mips/include/asm/hugetlb.h
--- a/arch/mips/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/mips/include/asm/hugetlb.h
@@ -38,10 +38,6 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
-{
-}
-
 static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr,
 					  unsigned long end,
diff -puN arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/powerpc/include/asm/hugetlb.h
--- a/arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -112,11 +112,6 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
-{
-}
-
-
 static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 				   pte_t *ptep, pte_t pte)
 {
diff -puN arch/s390/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/s390/include/asm/hugetlb.h
--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/s390/include/asm/hugetlb.h
@@ -35,7 +35,6 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-#define hugetlb_prefault_arch_hook(mm)		do { } while (0)
 #define arch_clear_hugepage_flags(page)		do { } while (0)
 
 int arch_prepare_hugepage(struct page *page);
diff -puN arch/sh/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/sh/include/asm/hugetlb.h
--- a/arch/sh/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/sh/include/asm/hugetlb.h
@@ -26,9 +26,6 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm) {
-}
-
 static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
diff -puN arch/sparc/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/sparc/include/asm/hugetlb.h
--- a/arch/sparc/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -11,10 +11,6 @@ void set_huge_pte_at(struct mm_struct *m
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep);
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
-{
-}
-
 static inline int is_hugepage_only_range(struct mm_struct *mm,
 					 unsigned long addr,
 					 unsigned long len) {
diff -puN arch/tile/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/tile/include/asm/hugetlb.h
--- a/arch/tile/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/tile/include/asm/hugetlb.h
@@ -40,10 +40,6 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
-{
-}
-
 static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
diff -puN arch/x86/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook arch/x86/include/asm/hugetlb.h
--- a/arch/x86/include/asm/hugetlb.h~mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook
+++ a/arch/x86/include/asm/hugetlb.h
@@ -26,9 +26,6 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm) {
-}
