From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:40 -0700
Message-ID: <552fe8d8.TSG3QjSo05D0dgRQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbbDPQrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: cleanup using paeg_huge_active()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-cleanup-using-pagehugeactive-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: cleanup using paeg_huge_active()

Now we have an easy access to hugepages' activeness, so existing helpers to
get the information can be cleaned up.

[akpm@linux-foundation.org: s/PageHugeActive/page_huge_active/]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    2 -
 include/linux/page-flags.h |    7 +++++
 mm/hugetlb.c               |   42 ++++-------------------------------
 mm/memory_hotplug.c        |    2 -
 4 files changed, 13 insertions(+), 40 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-cleanup-using-pagehugeactive-flag include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-cleanup-using-pagehugeactive-flag
+++ a/include/linux/hugetlb.h
@@ -84,7 +84,6 @@ void hugetlb_unreserve_pages(struct inod
 int dequeue_hwpoisoned_huge_page(struct page *page);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
-bool is_hugepage_active(struct page *page);
 void free_huge_page(struct page *page);
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
@@ -152,7 +151,6 @@ static inline bool isolate_huge_page(str
 	return false;
 }
 #define putback_active_hugepage(p)	do {} while (0)
-#define is_hugepage_active(x)	false
 
 static inline unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
diff -puN include/linux/page-flags.h~mm-hugetlb-cleanup-using-pagehugeactive-flag include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-hugetlb-cleanup-using-pagehugeactive-flag
+++ a/include/linux/page-flags.h
@@ -470,11 +470,18 @@ static inline void ClearPageCompound(str
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
diff -puN mm/hugetlb.c~mm-hugetlb-cleanup-using-pagehugeactive-flag mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-cleanup-using-pagehugeactive-flag
+++ a/mm/hugetlb.c
@@ -3896,20 +3896,6 @@ follow_huge_pud(struct mm_struct *mm, un
 
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
@@ -3921,7 +3907,11 @@ int dequeue_hwpoisoned_huge_page(struct
 	int ret = -EBUSY;
 
 	spin_lock(&hugetlb_lock);
-	if (is_hugepage_on_freelist(hpage)) {
+	/*
+	 * Just checking !page_huge_active is not enough, because that could be
+	 * an isolated/hwpoisoned hugepage (which have >0 refcount).
+	 */
+	if (!page_huge_active(hpage) && !page_count(hpage)) {
 		/*
 		 * Hwpoisoned hugepage isn't linked to activelist or freelist,
 		 * but dangling hpage->lru can trigger list-debug warnings
@@ -3965,25 +3955,3 @@ void putback_active_hugepage(struct page
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
+				if (page_huge_active(page))
 					return pfn;
 				else
 					pfn = round_up(pfn + 1,
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
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

