From: akpm@linux-foundation.org
Subject: + thp-allow-mlocked-thp-again.patch added to -mm tree
Date: Wed, 14 Oct 2015 14:14:13 -0700
Message-ID: <561ec5a5.TBOCEz8JJjpm4xyV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbbJNVOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:14:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: allow mlocked THP again
has been added to the -mm tree.  Its filename is
     thp-allow-mlocked-thp-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-allow-mlocked-thp-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-allow-mlocked-thp-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: allow mlocked THP again

Before THP refcounting rework, THP was not allowed to cross VMA boundary.
So, if we have THP and we split it, PG_mlocked can be safely transfered to
small pages.

With new THP refcounting and naive approach to mlocking we can end up with
this scenario:
 1. we have a mlocked THP, which belong to one VM_LOCKED VMA.
 2. the process does munlock() on the *part* of the THP:
      - the VMA is split into two, one of them VM_LOCKED;
      - huge PMD split into PTE table;
      - THP is still mlocked;
 3. split_huge_page():
      - it transfers PG_mlocked to *all* small pages regrardless if it
	blong to any VM_LOCKED VMA.

We probably could munlock() all small pages on split_huge_page(), but I
think we have accounting issue already on step two.

Instead of forbidding mlocked pages altogether, we just avoid mlocking
PTE-mapped THPs and munlock THPs on split_huge_pmd().

This means PTE-mapped THPs will be on normal lru lists and will be
split under memory pressure by vmscan. After the split vmscan will
detect unevictable small pages and mlock them.

With this approach we shouldn't hit situation like described above.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c         |    6 ++--
 mm/huge_memory.c |   37 ++++++++++++++++++++++-----
 mm/memory.c      |    6 ++--
 mm/mlock.c       |   61 +++++++++++++++++++++++++++++----------------
 mm/swap.c        |    1 
 5 files changed, 78 insertions(+), 33 deletions(-)

diff -puN mm/gup.c~thp-allow-mlocked-thp-again mm/gup.c
--- a/mm/gup.c~thp-allow-mlocked-thp-again
+++ a/mm/gup.c
@@ -143,6 +143,10 @@ retry:
 		mark_page_accessed(page);
 	}
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
+		/* Do not mlock pte-mapped THP */
+		if (PageTransCompound(page))
+			goto out;
+
 		/*
 		 * The preliminary mapping check is mainly to avoid the
 		 * pointless overhead of lock_page on the ZERO_PAGE
@@ -920,8 +924,6 @@ long populate_vma_page_range(struct vm_a
 	gup_flags = FOLL_TOUCH | FOLL_POPULATE | FOLL_MLOCK;
 	if (vma->vm_flags & VM_LOCKONFAULT)
 		gup_flags &= ~FOLL_POPULATE;
-	if (vma->vm_flags & VM_LOCKED)
-		gup_flags |= FOLL_SPLIT;
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
diff -puN mm/huge_memory.c~thp-allow-mlocked-thp-again mm/huge_memory.c
--- a/mm/huge_memory.c~thp-allow-mlocked-thp-again
+++ a/mm/huge_memory.c
@@ -904,8 +904,6 @@ int do_huge_pmd_anonymous_page(struct mm
 
 	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
 		return VM_FAULT_FALLBACK;
-	if (vma->vm_flags & VM_LOCKED)
-		return VM_FAULT_FALLBACK;
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
 	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
@@ -1374,7 +1372,20 @@ struct page *follow_trans_huge_pmd(struc
 			update_mmu_cache_pmd(vma, addr, pmd);
 	}
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
-		if (page->mapping && trylock_page(page)) {
+		/*
+		 * We don't mlock() pte-mapped THPs. This way we can avoid
+		 * leaking mlocked pages into non-VM_LOCKED VMAs.
+		 *
+		 * In most cases the pmd is the only mapping of the page as we
+		 * break COW for the mlock() -- see gup_flags |= FOLL_WRITE for
+		 * writable private mappings in populate_vma_page_range().
+		 *
+		 * The only scenario when we have the page shared here is if we
+		 * mlocking read-only mapping shared over fork(). We skip
+		 * mlocking such pages.
+		 */
+		if (compound_mapcount(page) == 1 && !PageDoubleMap(page) &&
+				page->mapping && trylock_page(page)) {
 			lru_add_drain();
 			if (page->mapping)
 				mlock_vma_page(page);
@@ -2239,8 +2250,6 @@ static bool hugepage_vma_check(struct vm
 	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
 	    (vma->vm_flags & VM_NOHUGEPAGE))
 		return false;
-	if (vma->vm_flags & VM_LOCKED)
-		return false;
 	if (!vma->anon_vma || vma->vm_ops)
 		return false;
 	if (is_vma_temporary_stack(vma))
@@ -2900,14 +2909,28 @@ void __split_huge_pmd(struct vm_area_str
 {
 	spinlock_t *ptl;
 	struct mm_struct *mm = vma->vm_mm;
+	struct page *page = NULL;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 
 	mmu_notifier_invalidate_range_start(mm, haddr, haddr + HPAGE_PMD_SIZE);
 	ptl = pmd_lock(mm, pmd);
-	if (likely(pmd_trans_huge(*pmd)))
-		__split_huge_pmd_locked(vma, pmd, haddr, false);
+	if (unlikely(!pmd_trans_huge(*pmd)))
+		goto out;
+	page = pmd_page(*pmd);
+	__split_huge_pmd_locked(vma, pmd, haddr, false);
+	if (PageMlocked(page))
+		get_page(page);
+	else
+		page = NULL;
+out:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, haddr, haddr + HPAGE_PMD_SIZE);
+	if (page) {
+		lock_page(page);
+		munlock_vma_page(page);
+		unlock_page(page);
+		put_page(page);
+	}
 }
 
 static void split_huge_pmd_address(struct vm_area_struct *vma,
diff -puN mm/memory.c~thp-allow-mlocked-thp-again mm/memory.c
--- a/mm/memory.c~thp-allow-mlocked-thp-again
+++ a/mm/memory.c
@@ -2155,15 +2155,15 @@ static int wp_page_copy(struct mm_struct
 
 	pte_unmap_unlock(page_table, ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-	/* THP pages are never mlocked */
-	if (old_page && !PageTransCompound(old_page)) {
+	if (old_page) {
 		/*
 		 * Don't let another task, with possibly unlocked vma,
 		 * keep the mlocked page.
 		 */
 		if (page_copied && (vma->vm_flags & VM_LOCKED)) {
 			lock_page(old_page);	/* LRU manipulation */
-			munlock_vma_page(old_page);
+			if (PageMlocked(old_page))
+				munlock_vma_page(old_page);
 			unlock_page(old_page);
 		}
 		page_cache_release(old_page);
diff -puN mm/mlock.c~thp-allow-mlocked-thp-again mm/mlock.c
--- a/mm/mlock.c~thp-allow-mlocked-thp-again
+++ a/mm/mlock.c
@@ -82,6 +82,9 @@ void mlock_vma_page(struct page *page)
 	/* Serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(PageCompound(page) && PageDoubleMap(page), page);
+
 	if (!TestSetPageMlocked(page)) {
 		mod_zone_page_state(page_zone(page), NR_MLOCK,
 				    hpage_nr_pages(page));
@@ -178,6 +181,8 @@ unsigned int munlock_vma_page(struct pag
 	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
 	/*
 	 * Serialize with any parallel __split_huge_page_refcount() which
 	 * might otherwise copy PageMlocked to part of the tail pages before
@@ -443,29 +448,43 @@ void munlock_vma_pages_range(struct vm_a
 		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
 				&page_mask);
 
-		if (page && !IS_ERR(page) && !PageTransCompound(page)) {
-			/*
-			 * Non-huge pages are handled in batches via
-			 * pagevec. The pin from follow_page_mask()
-			 * prevents them from collapsing by THP.
-			 */
-			pagevec_add(&pvec, page);
-			zone = page_zone(page);
-			zoneid = page_zone_id(page);
+		if (page && !IS_ERR(page)) {
+			if (PageTransTail(page)) {
+				VM_BUG_ON_PAGE(PageMlocked(page), page);
+				put_page(page); /* follow_page_mask() */
+			} else if (PageTransHuge(page)) {
+				lock_page(page);
+				/*
+				 * Any THP page found by follow_page_mask() may
+				 * have gotten split before reaching
+				 * munlock_vma_page(), so we need to recompute
+				 * the page_mask here.
+				 */
+				page_mask = munlock_vma_page(page);
+				unlock_page(page);
+				put_page(page); /* follow_page_mask() */
+			} else {
+				/*
+				 * Non-huge pages are handled in batches via
+				 * pagevec. The pin from follow_page_mask()
+				 * prevents them from collapsing by THP.
+				 */
+				pagevec_add(&pvec, page);
+				zone = page_zone(page);
+				zoneid = page_zone_id(page);
 
-			/*
-			 * Try to fill the rest of pagevec using fast
-			 * pte walk. This will also update start to
-			 * the next page to process. Then munlock the
-			 * pagevec.
-			 */
-			start = __munlock_pagevec_fill(&pvec, vma,
-					zoneid, start, end);
-			__munlock_pagevec(&pvec, zone);
-			goto next;
+				/*
+				 * Try to fill the rest of pagevec using fast
+				 * pte walk. This will also update start to
+				 * the next page to process. Then munlock the
+				 * pagevec.
+				 */
+				start = __munlock_pagevec_fill(&pvec, vma,
+						zoneid, start, end);
+				__munlock_pagevec(&pvec, zone);
+				goto next;
+			}
 		}
-		/* It's a bug to munlock in the middle of a THP page */
-		VM_BUG_ON((start >> PAGE_SHIFT) & page_mask);
 		page_increm = 1 + page_mask;
 		start += page_increm * PAGE_SIZE;
 next:
diff -puN mm/swap.c~thp-allow-mlocked-thp-again mm/swap.c
--- a/mm/swap.c~thp-allow-mlocked-thp-again
+++ a/mm/swap.c
@@ -358,6 +358,7 @@ static void __lru_cache_activate_page(st
  */
 void mark_page_accessed(struct page *page)
 {
+	page = compound_head(page);
 	if (!PageActive(page) && !PageUnevictable(page) &&
 			PageReferenced(page)) {
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-support-madvisemadv_free-fix-3.patch

