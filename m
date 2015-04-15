From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 15:41:02 -0700
Message-ID: <552ee8fe.3ndT+PYhs9KZLzUv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbbDOWlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch

This patch was dropped because it was folded into mm-hugetlb-cleanup-using-pagehugeactive-flag.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-cleanup-using-pagehugeactive-flag-fix

s/PageHugeActive/page_huge_active/

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    7 -------
 include/linux/page-flags.h |    7 +++++++
 mm/hugetlb.c               |    4 ++--
 mm/memory_hotplug.c        |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
+++ a/include/linux/hugetlb.h
@@ -44,8 +44,6 @@ extern int hugetlb_max_hstate __read_mos
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
-int PageHugeActive(struct page *page);
-
 struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
 						long min_hpages);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
@@ -115,11 +113,6 @@ unsigned long hugetlb_change_protection(
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
-static inline int PageHugeActive(struct page *page)
-{
-	return 0;
-}
-
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 }
diff -puN include/linux/page-flags.h~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
+++ a/include/linux/page-flags.h
@@ -549,11 +549,18 @@ static inline void ClearPageCompound(str
 #ifdef CONFIG_HUGETLB_PAGE
 int PageHuge(struct page *page);
 int PageHeadHuge(struct page *page);
+bool page_huge_active(struct page *page);
 #else
 TESTPAGEFLAG_FALSE(Huge)
 TESTPAGEFLAG_FALSE(HeadHuge)
+
+static inline bool page_huge_active(struct page *page)
+{
+	return 0;
+}
 #endif
 
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * PageHuge() only returns true for hugetlbfs pages, but not for
diff -puN mm/hugetlb.c~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
+++ a/mm/hugetlb.c
@@ -3908,10 +3908,10 @@ int dequeue_hwpoisoned_huge_page(struct
 
 	spin_lock(&hugetlb_lock);
 	/*
-	 * Just checking !PageHugeActive is not enough, because that could be
+	 * Just checking !page_huge_active is not enough, because that could be
 	 * an isolated/hwpoisoned hugepage (which have >0 refcount).
 	 */
-	if (!PageHugeActive(hpage) && !page_count(hpage)) {
+	if (!page_huge_active(hpage) && !page_count(hpage)) {
 		/*
 		 * Hwpoisoned hugepage isn't linked to activelist or freelist,
 		 * but dangling hpage->lru can trigger list-debug warnings
diff -puN mm/memory_hotplug.c~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
+++ a/mm/memory_hotplug.c
@@ -1373,7 +1373,7 @@ static unsigned long scan_movable_pages(
 			if (PageLRU(page))
 				return pfn;
 			if (PageHuge(page)) {
-				if (PageHugeActive(page))
+				if (page_huge_active(page))
 					return pfn;
 				else
 					pfn = round_up(pfn + 1,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction-fix.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

