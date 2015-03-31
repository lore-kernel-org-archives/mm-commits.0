From: akpm@linux-foundation.org
Subject: + mm-hugetlb-cleanup-using-pagehugeactive-flag.patch added to -mm tree
Date: Tue, 31 Mar 2015 14:08:35 -0700
Message-ID: <551b0cd3.i4dr7ebgGTL1t30O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbbCaVIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 17:08:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: cleanup using paeg_huge_active()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-cleanup-using-pagehugeactive-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-cleanup-using-pagehugeactive-flag.patch

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
Subject: mm: hugetlb: cleanup using paeg_huge_active()

Now we have an easy access to hugepages' activeness, so existing helpers to
get the information can be cleaned up.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    9 ++++++--
 mm/hugetlb.c            |   42 ++++----------------------------------
 mm/memory_hotplug.c     |    2 -
 3 files changed, 13 insertions(+), 40 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-cleanup-using-pagehugeactive-flag include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-cleanup-using-pagehugeactive-flag
+++ a/include/linux/hugetlb.h
@@ -44,6 +44,8 @@ extern int hugetlb_max_hstate __read_mos
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
+int PageHugeActive(struct page *page);
+
 struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
 						long min_hpages);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
@@ -84,7 +86,6 @@ void hugetlb_unreserve_pages(struct inod
 int dequeue_hwpoisoned_huge_page(struct page *page);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
-bool is_hugepage_active(struct page *page);
 void free_huge_page(struct page *page);
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
@@ -114,6 +115,11 @@ unsigned long hugetlb_change_protection(
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
+static inline int PageHugeActive(struct page *page)
+{
+	return 0;
+}
+
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 }
@@ -152,7 +158,6 @@ static inline bool isolate_huge_page(str
 	return false;
 }
 #define putback_active_hugepage(p)	do {} while (0)
-#define is_hugepage_active(x)	false
 
 static inline unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
diff -puN mm/hugetlb.c~mm-hugetlb-cleanup-using-pagehugeactive-flag mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-cleanup-using-pagehugeactive-flag
+++ a/mm/hugetlb.c
@@ -3897,20 +3897,6 @@ follow_huge_pud(struct mm_struct *mm, un
 
 #ifdef CONFIG_MEMORY_FAILURE
 
-/* Should be called in hugetlb_lock */
-static int is_hugepage_on_freelist(struct page *hpage)
-{
-	struct page *page;
-	struct page *tmp;
-	struct hstate *h = page_hstate(hpage);
-	int nid = page_to_nid(hpage);
-
-	list_for_each_entry_safe(page, tmp, &h->hugepage_freelists[nid], lru)
-		if (page == hpage)
-			return 1;
-	return 0;
-}
-
 /*
  * This function is called from memory failure code.
  * Assume the caller holds page lock of the head page.
@@ -3922,7 +3908,11 @@ int dequeue_hwpoisoned_huge_page(struct
 	int ret = -EBUSY;
 
 	spin_lock(&hugetlb_lock);
-	if (is_hugepage_on_freelist(hpage)) {
+	/*
+	 * Just checking !PageHugeActive is not enough, because that could be
+	 * an isolated/hwpoisoned hugepage (which have >0 refcount).
+	 */
+	if (!PageHugeActive(hpage) && !page_count(hpage)) {
 		/*
 		 * Hwpoisoned hugepage isn't linked to activelist or freelist,
 		 * but dangling hpage->lru can trigger list-debug warnings
@@ -3966,25 +3956,3 @@ void putback_active_hugepage(struct page
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
 }
-
-bool is_hugepage_active(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
-	/*
-	 * This function can be called for a tail page because the caller,
-	 * scan_movable_pages, scans through a given pfn-range which typically
-	 * covers one memory block. In systems using gigantic hugepage (1GB
-	 * for x86_64,) a hugepage is larger than a memory block, and we don't
-	 * support migrating such large hugepages for now, so return false
-	 * when called for tail pages.
-	 */
-	if (PageTail(page))
-		return false;
-	/*
-	 * Refcount of a hwpoisoned hugepages is 1, but they are not active,
-	 * so we should return false for them.
-	 */
-	if (unlikely(PageHWPoison(page)))
-		return false;
-	return page_count(page) > 0;
-}
diff -puN mm/memory_hotplug.c~mm-hugetlb-cleanup-using-pagehugeactive-flag mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hugetlb-cleanup-using-pagehugeactive-flag
+++ a/mm/memory_hotplug.c
@@ -1373,7 +1373,7 @@ static unsigned long scan_movable_pages(
 			if (PageLRU(page))
 				return pfn;
 			if (PageHuge(page)) {
-				if (is_hugepage_active(page))
+				if (PageHugeActive(page))
 					return pfn;
 				else
 					pfn = round_up(pfn + 1,
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

