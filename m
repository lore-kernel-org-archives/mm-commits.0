From: akpm@linux-foundation.org
Subject: [folded-merged] thp-reintroduce-split_huge_page-fix-3.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:41:19 -0800
Message-ID: <5698240f.LoH4WY6zzbpMgbW3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbcANWlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:41:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix split vs. unmap race
has been removed from the -mm tree.  Its filename was
     thp-reintroduce-split_huge_page-fix-3.patch

This patch was dropped because it was folded into thp-reintroduce-split_huge_page.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix split vs. unmap race

To stabilize compound page during split we use migration entries.  The
code to implement this is buggy: I wrongly assumed that kernel would wait
migration to finish, before zapping ptes.

But turn out that's not true.

As result if zap_pte_range() races with split_huge_page(), we can end up
with page which is not mapped anymore but has _count and _mapcount
elevated. The page is on LRU too. So it's still reachable by vmscan and by
pfn scanners.  It's likely that page->mapping in this case would point to
freed anon_vma.

BOOM!

The patch modify freeze/unfreeze_page() code to match normal migration
entries logic: on setup we remove page from rmap and drop pin, on removing
we get pin back and put page on rmap. This way even if migration entry
will be removed under us we don't corrupt page's state.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 ++++++++++++++++++----
 mm/rmap.c        |   19 +++++--------------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff -puN mm/huge_memory.c~thp-reintroduce-split_huge_page-fix-3 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reintroduce-split_huge_page-fix-3
+++ a/mm/huge_memory.c
@@ -2855,6 +2855,13 @@ static void __split_huge_pmd_locked(stru
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
+
+	if (freeze) {
+		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
+			page_remove_rmap(page + i, false);
+			put_page(page + i);
+		}
+	}
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
@@ -2986,6 +2993,8 @@ static void freeze_page_vma(struct vm_ar
 		if (pte_soft_dirty(entry))
 			swp_pte = pte_swp_mksoft_dirty(swp_pte);
 		set_pte_at(vma->vm_mm, address, pte + i, swp_pte);
+		page_remove_rmap(page, false);
+		put_page(page);
 	}
 	pte_unmap_unlock(pte, ptl);
 }
@@ -3024,8 +3033,6 @@ static void unfreeze_page_vma(struct vm_
 		return;
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, address, &ptl);
 	for (i = 0; i < HPAGE_PMD_NR; i++, address += PAGE_SIZE, page++) {
-		if (!page_mapped(page))
-			continue;
 		if (!is_swap_pte(pte[i]))
 			continue;
 
@@ -3035,6 +3042,9 @@ static void unfreeze_page_vma(struct vm_
 		if (migration_entry_to_page(swp_entry) != page)
 			continue;
 
+		get_page(page);
+		page_add_anon_rmap(page, vma, address, false);
+
 		entry = pte_mkold(mk_pte(page, vma->vm_page_prot));
 		entry = pte_mkdirty(entry);
 		if (is_write_migration_entry(swp_entry))
@@ -3102,8 +3112,6 @@ static int __split_huge_page_tail(struct
 	 */
 	atomic_add(mapcount + 1, &page_tail->_count);
 
-	/* after clearing PageTail the gup refcount can be released */
-	smp_mb__after_atomic();
 
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
@@ -3116,6 +3124,12 @@ static int __split_huge_page_tail(struct
 			 (1L << PG_unevictable)));
 	page_tail->flags |= (1L << PG_dirty);
 
+	/*
+	 * After clearing PageTail the gup refcount can be released.
+	 * Page flags also must be visible before we make the page non-compound.
+	 */
+	smp_wmb();
+
 	clear_compound_head(page_tail);
 
 	if (page_is_young(head))
diff -puN mm/rmap.c~thp-reintroduce-split_huge_page-fix-3 mm/rmap.c
--- a/mm/rmap.c~thp-reintroduce-split_huge_page-fix-3
+++ a/mm/rmap.c
@@ -1134,20 +1134,12 @@ void do_page_add_anon_rmap(struct page *
 	bool compound = flags & RMAP_COMPOUND;
 	bool first;
 
-	if (PageTransCompound(page)) {
+	if (compound) {
+		atomic_t *mapcount;
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		if (compound) {
-			atomic_t *mapcount;
-
-			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-			mapcount = compound_mapcount_ptr(page);
-			first = atomic_inc_and_test(mapcount);
-		} else {
-			/* Anon THP always mapped first with PMD */
-			first = 0;
-			VM_BUG_ON_PAGE(!page_mapcount(page), page);
-			atomic_inc(&page->_mapcount);
-		}
+		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+		mapcount = compound_mapcount_ptr(page);
+		first = atomic_inc_and_test(mapcount);
 	} else {
 		first = atomic_inc_and_test(&page->_mapcount);
 	}
@@ -1161,7 +1153,6 @@ void do_page_add_anon_rmap(struct page *
 		 * disabled.
 		 */
 		if (compound) {
-			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
 		}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-sure-isolate_lru_page-is-never-called-for-tail-page.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
page-flags-drop-__testclearpage-helpers.patch
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
thp-reintroduce-split_huge_page-fix-4.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
migrate_pages-try-to-split-pages-on-queuing-fix.patch
thp-introduce-deferred_split_huge_page.patch
thp-introduce-deferred_split_huge_page-fix.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
thp-allow-mlocked-thp-again-fix.patch
thp-allow-mlocked-thp-again-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix-fix.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch

