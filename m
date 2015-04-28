From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook.patch added to -mm tree
Date: Tue, 28 Apr 2015 13:25:14 -0700
Message-ID: <553fecaa.KCA8hwr/GYYnFE31%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030891AbbD1UZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 16:25:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: reduce arch dependent code about hugetlb_prefault_arch_hook
has been added to the -mm tree.  Its filename is
     mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-reduce-arch-dependent-code-about-hugetlb_prefault_arch_hook.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: mm/hugetlb: reduce arch dependent code about hugetlb_prefault_arch_hook

Currently we have many duplicates in definitions of
hugetlb_prefault_arch_hook.  In all architectures this function is empty.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
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
