From: akpm@linux-foundation.org
Subject: + mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch added to -mm tree
Date: Tue, 14 Feb 2012 17:09:49 -0800
Message-ID: <20120215010949.B7D70A01AD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-tul01m020-f202.google.com ([209.85.214.202]:64948 "EHLO
	mail-tul01m020-f202.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755651Ab2BOBJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Feb 2012 20:09:51 -0500
Received: by obbup3 with SMTP id up3so219625obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 17:09:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz


The patch titled
     From: Hillf Danton <dhillf@gmail.com>
has been added to the -mm tree.  Its filename is
     mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.cz>
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
Subject: From: Hillf Danton <dhillf@gmail.com>

Patches currently in -mm which might be from dhillf@gmail.com are

mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch

