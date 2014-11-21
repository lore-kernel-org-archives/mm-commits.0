From: akpm@linux-foundation.org
Subject: + mm-dont-split-thp-page-when-syscall-is-called.patch added to
 -mm tree
Date: Fri, 21 Nov 2014 15:50:24 -0800
Message-ID: <546fcfc0./zxmDA09Oukrz1CL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaKUXuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Nov 2014 18:50:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't split THP page when syscall is called
has been added to the -mm tree.  Its filename is
     mm-dont-split-thp-page-when-syscall-is-called.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-split-thp-page-when-syscall-is-called.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-split-thp-page-when-syscall-is-called.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: don't split THP page when syscall is called

We don't need to split THP page when MADV_FREE syscall is called.  It
could be done when VM decide really frees it so we could avoid unnecessary
THP split.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++++
 mm/huge_memory.c        |   35 +++++++++++++++++++++++++++++++++++
 mm/madvise.c            |   21 ++++++++++++++++++++-
 mm/rmap.c               |    8 ++++++--
 mm/vmscan.c             |   28 ++++++++++++++++++----------
 5 files changed, 83 insertions(+), 13 deletions(-)

diff -puN include/linux/huge_mm.h~mm-dont-split-thp-page-when-syscall-is-called include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-dont-split-thp-page-when-syscall-is-called
+++ a/include/linux/huge_mm.h
@@ -19,6 +19,9 @@ extern struct page *follow_trans_huge_pm
 					  unsigned long addr,
 					  pmd_t *pmd,
 					  unsigned int flags);
+extern int madvise_free_huge_pmd(struct mmu_gather *tlb,
+			struct vm_area_struct *vma,
+			pmd_t *pmd, unsigned long addr);
 extern int zap_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pmd_t *pmd, unsigned long addr);
@@ -56,6 +59,7 @@ extern pmd_t *page_check_address_pmd(str
 				     unsigned long address,
 				     enum page_check_address_pmd_flag flag,
 				     spinlock_t **ptl);
+extern int pmd_freeable(pmd_t pmd);
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
diff -puN mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called
+++ a/mm/huge_memory.c
@@ -1383,6 +1383,36 @@ out:
 	return 0;
 }
 
+int madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		 pmd_t *pmd, unsigned long addr)
+
+{
+	spinlock_t *ptl;
+	struct mm_struct *mm = tlb->mm;
+	int ret = 1;
+
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+		struct page *page;
+		pmd_t orig_pmd;
+
+		orig_pmd = pmdp_get_and_clear(mm, addr, pmd);
+
+		/* No hugepage in swapcache */
+		page = pmd_page(orig_pmd);
+		VM_BUG_ON_PAGE(PageSwapCache(page), page);
+
+		orig_pmd = pmd_mkold(orig_pmd);
+		orig_pmd = pmd_mkclean(orig_pmd);
+
+		set_pmd_at(mm, addr, pmd, orig_pmd);
+		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+		spin_unlock(ptl);
+		ret = 0;
+	}
+
+	return ret;
+}
+
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
@@ -1619,6 +1649,11 @@ unlock:
 	return NULL;
 }
 
+int pmd_freeable(pmd_t pmd)
+{
+	return !pmd_dirty(pmd);
+}
+
 static int __split_huge_page_splitting(struct page *page,
 				       struct vm_area_struct *vma,
 				       unsigned long address)
diff -puN mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called mm/madvise.c
--- a/mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called
+++ a/mm/madvise.c
@@ -271,8 +271,26 @@ static int madvise_free_pte_range(pmd_t
 	spinlock_t *ptl;
 	pte_t *pte, ptent;
 	struct page *page;
+	unsigned long next;
+
+	next = pmd_addr_end(addr, end);
+	if (pmd_trans_huge(*pmd)) {
+		if (next - addr != HPAGE_PMD_SIZE) {
+#ifdef CONFIG_DEBUG_VM
+			if (!rwsem_is_locked(&mm->mmap_sem)) {
+				pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
+					__func__, addr, end,
+					vma->vm_start,
+					vma->vm_end);
+				BUG();
+			}
+#endif
+			split_huge_page_pmd(vma, addr, pmd);
+		} else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
+			goto next;
+		/* fall through */
+	}
 
-	split_huge_page_pmd(vma, addr, pmd);
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
@@ -316,6 +334,7 @@ static int madvise_free_pte_range(pmd_t
 	}
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
+next:
 	cond_resched();
 	return 0;
 }
diff -puN mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called mm/rmap.c
--- a/mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called
+++ a/mm/rmap.c
@@ -704,9 +704,13 @@ static int page_referenced_one(struct pa
 			referenced++;
 
 		/*
-		 * In this implmentation, MADV_FREE doesn't support THP free
+		 * Use pmd_freeable instead of raw pmd_dirty because in some
+		 * of architecture, pmd_dirty is not defined unless
+		 * CONFIG_TRANSPARNTE_HUGE is enabled
 		 */
-		dirty++;
+		if (!pmd_freeable(*pmd))
+			dirty++;
+
 		spin_unlock(ptl);
 	} else {
 		pte_t *pte;
diff -puN mm/vmscan.c~mm-dont-split-thp-page-when-syscall-is-called mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-split-thp-page-when-syscall-is-called
+++ a/mm/vmscan.c
@@ -976,17 +976,25 @@ static unsigned long shrink_page_list(st
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
 		 */
-		if (PageAnon(page) && !PageSwapCache(page) && !freeable) {
-			if (!(sc->gfp_mask & __GFP_IO))
-				goto keep_locked;
-			if (!add_to_swap(page, page_list))
-				goto activate_locked;
-			may_enter_fs = 1;
-
-			/* Adding to swap updated mapping */
-			mapping = page_mapping(page);
+		if (PageAnon(page) && !PageSwapCache(page)) {
+			if (!freeable) {
+				if (!(sc->gfp_mask & __GFP_IO))
+					goto keep_locked;
+				if (!add_to_swap(page, page_list))
+					goto activate_locked;
+				may_enter_fs = 1;
+				/* Adding to swap updated mapping */
+				mapping = page_mapping(page);
+			} else {
+				if (likely(!PageTransHuge(page)))
+					goto unmap;
+				/* try_to_unmap isn't aware of THP page */
+				if (unlikely(split_huge_page_to_list(page,
+								page_list)))
+					goto keep_locked;
+			}
 		}
-
+unmap:
 		/*
 		 * The page is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
mm-support-madvisemadv_free.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch
zram-implement-rw_page-operation-of-zram-fix.patch
zram-implement-rw_page-operation-of-zram-fix-2.patch
zram-implement-rw_page-operation-of-zram-fix-2-cleanup.patch
zram-implement-rw_page-operation-of-zram-fix-3.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
zsmalloc-correct-fragile-_atomic-use.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

