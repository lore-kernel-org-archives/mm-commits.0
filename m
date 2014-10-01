From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch removed
 from -mm tree
Date: Wed, 01 Oct 2014 13:36:12 -0700
Message-ID: <542c65bc.w3auwuDUSSoDBsr1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJAUgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hughd@google.com, james.hogan@imgtec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: reduce arch dependent code around follow_huge_*
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: reduce arch dependent code around follow_huge_*

Currently we have many duplicates in definitions around
follow_huge_addr(), follow_huge_pmd(), and follow_huge_pud(), so this
patch tries to remove them.  The basic idea is to put the default
implementation for these functions in mm/hugetlb.c as weak symbols
(regardless of CONFIG_ARCH_WANT_GENERAL_HUGETLB), and to implement
arch-specific code only when the arch needs it.

For follow_huge_addr(), only powerpc and ia64 have their own
implementation, and in all other architectures this function just returns
ERR_PTR(-EINVAL).  So this patch sets returning ERR_PTR(-EINVAL) as
default.

As for follow_huge_(pmd|pud)(), if (pmd|pud)_huge() is implemented to
always return 0 in your architecture (like in ia64 or sparc,) it's never
called (the callsite is optimized away) no matter how implemented it is. 
So in such architectures, we don't need arch-specific implementation.

In some architecture (like mips, s390 and tile,) their current
arch-specific follow_huge_(pmd|pud)() are effectively identical with the
common code, so this patch lets these architecture use the common code.

One exception is metag, where pmd_huge() could return non-zero but it
expects follow_huge_pmd() to always return NULL.  This means that we need
arch-specific implementation which returns NULL.  This behavior looks
strange to me (because non-zero pmd_huge() implies that the architecture
supports PMD-based hugepage, so follow_huge_pmd() can/should return some
relevant value,) but that's beyond this cleanup patch, so let's keep it.

Justification of non-trivial changes:
- in s390, follow_huge_pmd() checks !MACHINE_HAS_HPAGE at first, and this
  patch removes the check. This is OK because we can assume MACHINE_HAS_HPAGE
  is true when follow_huge_pmd() can be called (note that pmd_huge() has
  the same check and always returns 0 for !MACHINE_HAS_HPAGE.)
- in s390 and mips, we use HPAGE_MASK instead of PMD_MASK as done in common
  code. This patch forces these archs use PMD_MASK, but it's OK because
  they are identical in both archs.
  In s390, both of HPAGE_SHIFT and PMD_SHIFT are 20.
  In mips, HPAGE_SHIFT is defined as (PAGE_SHIFT + PAGE_SHIFT - 3) and
  PMD_SHIFT is define as (PAGE_SHIFT + PAGE_SHIFT + PTE_ORDER - 3), but
  PTE_ORDER is always 0, so these are identical.

[akpm@linux-foundation.org: fix build in arch/powerpc/mm/hugetlbpage.c]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/hugetlbpage.c     |    6 ------
 arch/arm64/mm/hugetlbpage.c   |    6 ------
 arch/ia64/mm/hugetlbpage.c    |    6 ------
 arch/metag/mm/hugetlbpage.c   |    6 ------
 arch/mips/mm/hugetlbpage.c    |   18 ------------------
 arch/powerpc/mm/hugetlbpage.c |    8 ++++++++
 arch/s390/mm/hugetlbpage.c    |   20 --------------------
 arch/sh/mm/hugetlbpage.c      |   12 ------------
 arch/sparc/mm/hugetlbpage.c   |   12 ------------
 arch/tile/mm/hugetlbpage.c    |   28 ----------------------------
 arch/x86/mm/hugetlbpage.c     |   12 ------------
 mm/hugetlb.c                  |   30 +++++++++++++++---------------
 12 files changed, 23 insertions(+), 141 deletions(-)

diff -puN arch/arm/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/arm/mm/hugetlbpage.c
--- a/arch/arm/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/arm/mm/hugetlbpage.c
@@ -36,12 +36,6 @@
  * of type casting from pmd_t * to pte_t *.
  */
 
-struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
-			      int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pud_huge(pud_t pud)
 {
 	return 0;
diff -puN arch/arm64/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -38,12 +38,6 @@ int huge_pmd_unshare(struct mm_struct *m
 }
 #endif
 
-struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
-			      int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return !(pmd_val(pmd) & PMD_TABLE_BIT);
diff -puN arch/ia64/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -114,12 +114,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-struct page *
-follow_huge_pmd(struct mm_struct *mm, unsigned long address, pmd_t *pmd, int write)
-{
-	return NULL;
-}
-
 void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 			unsigned long addr, unsigned long end,
 			unsigned long floor, unsigned long ceiling)
diff -puN arch/metag/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/metag/mm/hugetlbpage.c
--- a/arch/metag/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/metag/mm/hugetlbpage.c
@@ -94,12 +94,6 @@ int huge_pmd_unshare(struct mm_struct *m
 	return 0;
 }
 
-struct page *follow_huge_addr(struct mm_struct *mm,
-			      unsigned long address, int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return pmd_page_shift(pmd) > PAGE_SHIFT;
diff -puN arch/mips/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/mips/mm/hugetlbpage.c
--- a/arch/mips/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/mips/mm/hugetlbpage.c
@@ -68,12 +68,6 @@ int is_aligned_hugepage_range(unsigned l
 	return 0;
 }
 
-struct page *
-follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _PAGE_HUGE) != 0;
@@ -83,15 +77,3 @@ int pud_huge(pud_t pud)
 {
 	return (pud_val(pud) & _PAGE_HUGE) != 0;
 }
-
-struct page *
-follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
-{
-	struct page *page;
-
-	page = pte_page(*(pte_t *)pmd);
-	if (page)
-		page += ((address & ~HPAGE_MASK) >> PAGE_SHIFT);
-	return page;
-}
diff -puN arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -706,6 +706,14 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return NULL;
 }
 
+struct page *
+follow_huge_pud(struct mm_struct *mm, unsigned long address,
+		pud_t *pud, int write)
+{
+	BUG();
+	return NULL;
+}
+
 static unsigned long hugepte_addr_end(unsigned long addr, unsigned long end,
 				      unsigned long sz)
 {
diff -puN arch/s390/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/s390/mm/hugetlbpage.c
@@ -192,12 +192,6 @@ int huge_pmd_unshare(struct mm_struct *m
 	return 0;
 }
 
-struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
-			      int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	if (!MACHINE_HAS_HPAGE)
@@ -210,17 +204,3 @@ int pud_huge(pud_t pud)
 {
 	return 0;
 }
-
-struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmdp, int write)
-{
-	struct page *page;
-
-	if (!MACHINE_HAS_HPAGE)
-		return NULL;
-
-	page = pmd_page(*pmdp);
-	if (page)
-		page += ((address & ~HPAGE_MASK) >> PAGE_SHIFT);
-	return page;
-}
diff -puN arch/sh/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/sh/mm/hugetlbpage.c
@@ -67,12 +67,6 @@ int huge_pmd_unshare(struct mm_struct *m
 	return 0;
 }
 
-struct page *follow_huge_addr(struct mm_struct *mm,
-			      unsigned long address, int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return 0;
@@ -82,9 +76,3 @@ int pud_huge(pud_t pud)
 {
 	return 0;
 }
-
-struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmd, int write)
-{
-	return NULL;
-}
diff -puN arch/sparc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -215,12 +215,6 @@ pte_t huge_ptep_get_and_clear(struct mm_
 	return entry;
 }
 
-struct page *follow_huge_addr(struct mm_struct *mm,
-			      unsigned long address, int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return 0;
@@ -230,9 +224,3 @@ int pud_huge(pud_t pud)
 {
 	return 0;
 }
-
-struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmd, int write)
-{
-	return NULL;
-}
diff -puN arch/tile/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/tile/mm/hugetlbpage.c
--- a/arch/tile/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/tile/mm/hugetlbpage.c
@@ -150,12 +150,6 @@ pte_t *huge_pte_offset(struct mm_struct
 	return NULL;
 }
 
-struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
-			      int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_HUGE_PAGE);
@@ -166,28 +160,6 @@ int pud_huge(pud_t pud)
 	return !!(pud_val(pud) & _PAGE_HUGE_PAGE);
 }
 
-struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmd, int write)
-{
-	struct page *page;
-
-	page = pte_page(*(pte_t *)pmd);
-	if (page)
-		page += ((address & ~PMD_MASK) >> PAGE_SHIFT);
-	return page;
-}
-
-struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
-			     pud_t *pud, int write)
-{
-	struct page *page;
-
-	page = pte_page(*(pte_t *)pud);
-	if (page)
-		page += ((address & ~PUD_MASK) >> PAGE_SHIFT);
-	return page;
-}
-
 int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
 {
 	return 0;
diff -puN arch/x86/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/arch/x86/mm/hugetlbpage.c
@@ -52,20 +52,8 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-struct page *
-follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
-{
-	return NULL;
-}
 #else
 
-struct page *
-follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_PSE);
diff -puN mm/hugetlb.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_ mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_
+++ a/mm/hugetlb.c
@@ -3653,7 +3653,20 @@ pte_t *huge_pte_offset(struct mm_struct
 	return (pte_t *) pmd;
 }
 
-struct page *
+#endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
+
+/*
+ * These functions are overwritable if your architecture needs its own
+ * behavior.
+ */
+struct page * __weak
+follow_huge_addr(struct mm_struct *mm, unsigned long address,
+			      int write)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+struct page * __weak
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		pmd_t *pmd, int write)
 {
@@ -3665,7 +3678,7 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return page;
 }
 
-struct page *
+struct page * __weak
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
 		pud_t *pud, int write)
 {
@@ -3677,19 +3690,6 @@ follow_huge_pud(struct mm_struct *mm, un
 	return page;
 }
 
-#else /* !CONFIG_ARCH_WANT_GENERAL_HUGETLB */
-
-/* Can be overriden by architectures */
-struct page * __weak
-follow_huge_pud(struct mm_struct *mm, unsigned long address,
-	       pud_t *pud, int write)
-{
-	BUG();
-	return NULL;
-}
-
-#endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
-
 #ifdef CONFIG_MEMORY_FAILURE
 
 /* Should be called in hugetlb_lock */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

