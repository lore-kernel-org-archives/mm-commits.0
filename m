From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:14 -0700
Message-ID: <20120322201814.8CD2AA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35102 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2CVUSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:16 -0400
Received: by eekc41 with SMTP id c41so136580eek.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: defer freeing pages when gathering surplus pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: defer freeing pages when gathering surplus pages

When gathering surplus pages, the number of needed pages is recomputed
after reacquiring hugetlb lock to catch changes in resv_huge_pages and
free_huge_pages.  Plus it is recomputed with the number of newly allocated
pages involved.

Thus freeing pages can be deferred a bit to see if the final page request
is satisfied, though pages could be allocated less than needed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages
+++ a/mm/hugetlb.c
@@ -852,6 +852,7 @@ static int gather_surplus_pages(struct h
 	struct page *page, *tmp;
 	int ret, i;
 	int needed, allocated;
+	bool alloc_ok = true;
 
 	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
 	if (needed <= 0) {
@@ -867,17 +868,13 @@ retry:
 	spin_unlock(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
-		if (!page)
-			/*
-			 * We were not able to allocate enough pages to
-			 * satisfy the entire reservation so we free what
-			 * we've allocated so far.
-			 */
-			goto free;
-
+		if (!page) {
+			alloc_ok = false;
+			break;
+		}
 		list_add(&page->lru, &surplus_list);
 	}
-	allocated += needed;
+	allocated += i;
 
 	/*
 	 * After retaking hugetlb_lock, we need to recalculate 'needed'
@@ -886,9 +883,16 @@ retry:
 	spin_lock(&hugetlb_lock);
 	needed = (h->resv_huge_pages + delta) -
 			(h->free_huge_pages + allocated);
-	if (needed > 0)
-		goto retry;
-
+	if (needed > 0) {
+		if (alloc_ok)
+			goto retry;
+		/*
+		 * We were not able to allocate enough pages to
+		 * satisfy the entire reservation so we free what
+		 * we've allocated so far.
+		 */
+		goto free;
+	}
 	/*
 	 * The surplus_list now contains _at_least_ the number of extra pages
 	 * needed to accommodate the reservation.  Add the appropriate number
@@ -914,10 +918,10 @@ retry:
 		VM_BUG_ON(page_count(page));
 		enqueue_huge_page(h, page);
 	}
+free:
 	spin_unlock(&hugetlb_lock);
 
 	/* Free unnecessary surplus pages to the buddy allocator */
-free:
 	if (!list_empty(&surplus_list)) {
 		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 			list_del(&page->lru);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch

