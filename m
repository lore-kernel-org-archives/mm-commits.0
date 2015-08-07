From: akpm@linux-foundation.org
Subject: [merged]
 mm-check-__pg_hwpoison-separately-from-page_flags_check_at_.patch removed
 from -mm tree
Date: Fri, 07 Aug 2015 12:03:33 -0700
Message-ID: <55c50105.TVxCj3ig/+r6Vi4y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946135AbbHGTDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, dnelson@redhat.com, hughd@google.com, kirill@shutemov.name, rientjes@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check __PG_HWPOISON separately from PAGE_FLAGS_CHECK_AT_*
has been removed from the -mm tree.  Its filename was
     mm-check-__pg_hwpoison-separately-from-page_flags_check_at_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: check __PG_HWPOISON separately from PAGE_FLAGS_CHECK_AT_*

The race condition addressed in commit add05cecef80 ("mm: soft-offline:
don't free target page in successful page migration") was not closed
completely, because that can happen not only for soft-offline, but also
for hard-offline.  Consider that a slab page is about to be freed into
buddy pool, and then an uncorrected memory error hits the page just after
entering __free_one_page(), then VM_BUG_ON_PAGE(page->flags &
PAGE_FLAGS_CHECK_AT_PREP) is triggered, despite the fact that it's not
necessary because the data on the affected page is not consumed.

To solve it, this patch drops __PG_HWPOISON from page flag checks at
allocation/free time.  I think it's justified because __PG_HWPOISON flags
is defined to prevent the page from being reused, and setting it outside
the page's alloc-free cycle is a designed behavior (not a bug.)

For recent months, I was annoyed about BUG_ON when soft-offlined page
remains on lru cache list for a while, which is avoided by calling
put_page() instead of putback_lru_page() in page migration's success path.
This means that this patch reverts a major change from commit
add05cecef80 about the new refcounting rule of soft-offlined pages, so
"reuse window" revives.  This will be closed by a subsequent patch.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dean Nelson <dnelson@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 +++++++---
 mm/huge_memory.c           |    7 +------
 mm/migrate.c               |    5 ++++-
 mm/page_alloc.c            |    4 ++++
 4 files changed, 16 insertions(+), 10 deletions(-)

diff -puN include/linux/page-flags.h~mm-check-__pg_hwpoison-separately-from-page_flags_check_at_ include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-check-__pg_hwpoison-separately-from-page_flags_check_at_
+++ a/include/linux/page-flags.h
@@ -631,15 +631,19 @@ static inline void ClearPageSlabPfmemall
 	 1 << PG_private | 1 << PG_private_2 | \
 	 1 << PG_writeback | 1 << PG_reserved | \
 	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
-	 1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON | \
+	 1 << PG_unevictable | __PG_MLOCKED | \
 	 __PG_COMPOUND_LOCK)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
- * Pages being prepped should not have any flags set.  It they are set,
+ * Pages being prepped should not have these flags set.  It they are set,
  * there has been a kernel bug or struct page corruption.
+ *
+ * __PG_HWPOISON is exceptional because it needs to be kept beyond page's
+ * alloc-free cycle to prevent from reusing the page.
  */
-#define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)
+#define PAGE_FLAGS_CHECK_AT_PREP	\
+	(((1 << NR_PAGEFLAGS) - 1) & ~__PG_HWPOISON)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1 << PG_private | 1 << PG_private_2)
diff -puN mm/huge_memory.c~mm-check-__pg_hwpoison-separately-from-page_flags_check_at_ mm/huge_memory.c
--- a/mm/huge_memory.c~mm-check-__pg_hwpoison-separately-from-page_flags_check_at_
+++ a/mm/huge_memory.c
@@ -1676,12 +1676,7 @@ static void __split_huge_page_refcount(s
 		/* after clearing PageTail the gup refcount can be released */
 		smp_mb__after_atomic();
 
-		/*
-		 * retain hwpoison flag of the poisoned tail page:
-		 *   fix for the unsuitable process killed on Guest Machine(KVM)
-		 *   by the memory-failure.
-		 */
-		page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP | __PG_HWPOISON;
+		page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		page_tail->flags |= (page->flags &
 				     ((1L << PG_referenced) |
 				      (1L << PG_swapbacked) |
diff -puN mm/migrate.c~mm-check-__pg_hwpoison-separately-from-page_flags_check_at_ mm/migrate.c
--- a/mm/migrate.c~mm-check-__pg_hwpoison-separately-from-page_flags_check_at_
+++ a/mm/migrate.c
@@ -950,7 +950,10 @@ out:
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		if (reason != MR_MEMORY_FAILURE)
+		/* Soft-offlined page shouldn't go through lru cache list */
+		if (reason == MR_MEMORY_FAILURE)
+			put_page(page);
+		else
 			putback_lru_page(page);
 	}
 
diff -puN mm/page_alloc.c~mm-check-__pg_hwpoison-separately-from-page_flags_check_at_ mm/page_alloc.c
--- a/mm/page_alloc.c~mm-check-__pg_hwpoison-separately-from-page_flags_check_at_
+++ a/mm/page_alloc.c
@@ -1296,6 +1296,10 @@ static inline int check_new_page(struct
 		bad_reason = "non-NULL mapping";
 	if (unlikely(atomic_read(&page->_count) != 0))
 		bad_reason = "nonzero _count";
+	if (unlikely(page->flags & __PG_HWPOISON)) {
+		bad_reason = "HWPoisoned (hardware-corrupted)";
+		bad_flags = __PG_HWPOISON;
+	}
 	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_PREP)) {
 		bad_reason = "PAGE_FLAGS_CHECK_AT_PREP flag set";
 		bad_flags = PAGE_FLAGS_CHECK_AT_PREP;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
hugetlb-make-the-function-vma_shareable-bool.patch
pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-update-documentation.patch
pagemap-update-documentation-fix.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
hugetlbfs-add-hugetlbfs_fallocate-fix.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch
mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch
mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
reverted-selftests-add-hugetlbfstest.patch
selftests-vm-point-to-libhugetlbfs-for-regression-testing.patch
documentation-update-libhugetlbfs-location-and-use-for-testing.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
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
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

