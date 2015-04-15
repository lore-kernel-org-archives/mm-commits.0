From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-introduce-pagehugeactive-flag-fix.patch removed from -mm tree
Date: Wed, 15 Apr 2015 15:39:54 -0700
Message-ID: <552ee8ba.o4mljob3UfpqHnZn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbbDOWjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:39:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-pagehugeactive-flag-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-pagehugeactive-flag-fix.patch

This patch was dropped because it was folded into mm-hugetlb-introduce-pagehugeactive-flag.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-introduce-pagehugeactive-flag-fix

s/PageHugeActive/page_huge_active/, make it return bool

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag-fix
+++ a/mm/hugetlb.c
@@ -925,25 +925,25 @@ struct hstate *size_to_hstate(unsigned l
 }
 
 /*
- * Page flag to show that the hugepage is "active/in-use" (i.e. being linked to
- * hstate->hugepage_activelist.)
+ * Test to determine whether the hugepage is "active/in-use" (i.e. being linked
+ * to hstate->hugepage_activelist.)
  *
  * This function can be called for tail pages, but never returns true for them.
  */
-int PageHugeActive(struct page *page)
+bool page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHuge(page), page);
 	return PageHead(page) && PagePrivate(&page[1]);
 }
 
 /* never called for tail page */
-void SetPageHugeActive(struct page *page)
+void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);
 }
 
-void ClearPageHugeActive(struct page *page)
+void clear_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	ClearPagePrivate(&page[1]);
@@ -977,7 +977,7 @@ void free_huge_page(struct page *page)
 		restore_reserve = true;
 
 	spin_lock(&hugetlb_lock);
-	ClearPageHugeActive(page);
+	clear_page_huge_active(page);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
 	if (restore_reserve)
@@ -2998,7 +2998,7 @@ retry_avoidcopy:
 	copy_user_huge_page(new_page, old_page, address, vma,
 			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
-	SetPageHugeActive(new_page);
+	set_page_huge_active(new_page);
 
 	mmun_start = address & huge_page_mask(h);
 	mmun_end = mmun_start + huge_page_size(h);
@@ -3111,7 +3111,7 @@ retry:
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
-		SetPageHugeActive(page);
+		set_page_huge_active(page);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err;
@@ -3945,11 +3945,11 @@ bool isolate_huge_page(struct page *page
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
-	if (!PageHugeActive(page) || !get_page_unless_zero(page)) {
+	if (!page_huge_active(page) || !get_page_unless_zero(page)) {
 		ret = false;
 		goto unlock;
 	}
-	ClearPageHugeActive(page);
+	clear_page_huge_active(page);
 	list_move_tail(&page->lru, list);
 unlock:
 	spin_unlock(&hugetlb_lock);
@@ -3960,7 +3960,7 @@ void putback_active_hugepage(struct page
 {
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
-	SetPageHugeActive(page);
+	set_page_huge_active(page);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
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

