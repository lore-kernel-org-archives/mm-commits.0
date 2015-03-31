From: akpm@linux-foundation.org
Subject: + mm-hugetlb-introduce-pagehugeactive-flag.patch added to -mm
 tree
Date: Tue, 31 Mar 2015 14:08:31 -0700
Message-ID: <551b0ccf.4jxH8YxSIUPEQWY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbbCaVId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 17:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: introduce page_huge_active
has been added to the -mm tree.  Its filename is
     mm-hugetlb-introduce-pagehugeactive-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-introduce-pagehugeactive-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-introduce-pagehugeactive-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: introduce page_huge_active

We are not safe from calling isolate_huge_page() on a hugepage
concurrently, which can make the victim hugepage in invalid state and
results in BUG_ON().

The root problem of this is that we don't have any information on struct
page (so easily accessible) about hugepages' activeness.  Note that
hugepages' activeness means just being linked to
hstate->hugepage_activelist, which is not the same as normal pages'
activeness represented by PageActive flag.

Normal pages are isolated by isolate_lru_page() which prechecks PageLRU
before isolation, so let's do similarly for hugetlb with a new
paeg_huge_active().

set/clear_page_huge_active() should be called within hugetlb_lock.  But
hugetlb_cow() and hugetlb_no_page() don't do this, being justified because
in these functions set_page_huge_active() is called right after the
hugepage is allocated and no other thread tries to isolate it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |   41 ++++++++++++++++++++++++++++++++++++++---
 mm/memory-failure.c |   14 ++++++++++++--
 2 files changed, 50 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag
+++ a/mm/hugetlb.c
@@ -924,6 +924,31 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
+/*
+ * Page flag to show that the hugepage is "active/in-use" (i.e. being linked to
+ * hstate->hugepage_activelist.)
+ *
+ * This function can be called for tail pages, but never returns true for them.
+ */
+int PageHugeActive(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	return PageHead(page) && PagePrivate(&page[1]);
+}
+
+/* never called for tail page */
+void SetPageHugeActive(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
+	SetPagePrivate(&page[1]);
+}
+
+void ClearPageHugeActive(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
+	ClearPagePrivate(&page[1]);
+}
+
 void free_huge_page(struct page *page)
 {
 	/*
@@ -952,6 +977,7 @@ void free_huge_page(struct page *page)
 		restore_reserve = true;
 
 	spin_lock(&hugetlb_lock);
+	ClearPageHugeActive(page);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
 	if (restore_reserve)
@@ -2972,6 +2998,7 @@ retry_avoidcopy:
 	copy_user_huge_page(new_page, old_page, address, vma,
 			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
+	SetPageHugeActive(new_page);
 
 	mmun_start = address & huge_page_mask(h);
 	mmun_end = mmun_start + huge_page_size(h);
@@ -3084,6 +3111,7 @@ retry:
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
+		SetPageHugeActive(page);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err;
@@ -3914,19 +3942,26 @@ int dequeue_hwpoisoned_huge_page(struct
 
 bool isolate_huge_page(struct page *page, struct list_head *list)
 {
+	bool ret = true;
+
 	VM_BUG_ON_PAGE(!PageHead(page), page);
-	if (!get_page_unless_zero(page))
-		return false;
 	spin_lock(&hugetlb_lock);
+	if (!PageHugeActive(page) || !get_page_unless_zero(page)) {
+		ret = false;
+		goto unlock;
+	}
+	ClearPageHugeActive(page);
 	list_move_tail(&page->lru, list);
+unlock:
 	spin_unlock(&hugetlb_lock);
-	return true;
+	return ret;
 }
 
 void putback_active_hugepage(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
+	SetPageHugeActive(page);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
diff -puN mm/memory-failure.c~mm-hugetlb-introduce-pagehugeactive-flag mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hugetlb-introduce-pagehugeactive-flag
+++ a/mm/memory-failure.c
@@ -1586,8 +1586,18 @@ static int soft_offline_huge_page(struct
 	}
 	unlock_page(hpage);
 
-	/* Keep page count to indicate a given hugepage is isolated. */
-	list_move(&hpage->lru, &pagelist);
+	ret = isolate_huge_page(hpage, &pagelist);
+	if (ret) {
+		/*
+		 * get_any_page() and isolate_huge_page() takes a refcount each,
+		 * so need to drop one here.
+		 */
+		put_page(hpage);
+	} else {
+		pr_info("soft offline: %#lx hugepage failed to isolate\n", pfn);
+		return -EBUSY;
+	}
+
 	ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
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
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

