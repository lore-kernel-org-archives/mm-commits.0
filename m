From: akpm@linux-foundation.org
Subject: + thp-reintroduce-split_huge_page-fix-3.patch added to -mm tree
Date: Tue, 03 Nov 2015 14:47:45 -0800
Message-ID: <56393991.2nhYyptO2+f/28T8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbbKCWrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2015 17:47:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix split vs. unmap race
has been added to the -mm tree.  Its filename is
     thp-reintroduce-split_huge_page-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-reintroduce-split_huge_page-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-reintroduce-split_huge_page-fix-3.patch

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
@@ -2857,6 +2857,13 @@ static void __split_huge_pmd_locked(stru
 
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
@@ -2988,6 +2995,8 @@ static void freeze_page_vma(struct vm_ar
 		if (pte_soft_dirty(entry))
 			swp_pte = pte_swp_mksoft_dirty(swp_pte);
 		set_pte_at(vma->vm_mm, address, pte + i, swp_pte);
+		page_remove_rmap(page, false);
+		put_page(page);
 	}
 	pte_unmap_unlock(pte, ptl);
 }
@@ -3026,8 +3035,6 @@ static void unfreeze_page_vma(struct vm_
 		return;
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, address, &ptl);
 	for (i = 0; i < HPAGE_PMD_NR; i++, address += PAGE_SIZE, page++) {
-		if (!page_mapped(page))
-			continue;
 		if (!is_swap_pte(pte[i]))
 			continue;
 
@@ -3037,6 +3044,9 @@ static void unfreeze_page_vma(struct vm_
 		if (migration_entry_to_page(swp_entry) != page)
 			continue;
 
+		get_page(page);
+		page_add_anon_rmap(page, vma, address, false);
+
 		entry = pte_mkold(mk_pte(page, vma->vm_page_prot));
 		entry = pte_mkdirty(entry);
 		if (is_write_migration_entry(swp_entry))
@@ -3104,8 +3114,6 @@ static int __split_huge_page_tail(struct
 	 */
 	atomic_add(mapcount + 1, &page_tail->_count);
 
-	/* after clearing PageTail the gup refcount can be released */
-	smp_mb__after_atomic();
 
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
@@ -3118,6 +3126,12 @@ static int __split_huge_page_tail(struct
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
@@ -1132,20 +1132,12 @@ void do_page_add_anon_rmap(struct page *
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
 		VM_BUG_ON_PAGE(compound, page);
 		first = atomic_inc_and_test(&page->_mapcount);
@@ -1160,7 +1152,6 @@ void do_page_add_anon_rmap(struct page *
 		 * disabled.
 		 */
 		if (compound) {
-			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
 		}
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
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch

