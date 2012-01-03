From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-non-atomic-enqueue-of-huge-page.patch removed from -mm tree
Date: Tue, 03 Jan 2012 13:35:46 -0800
Message-ID: <20120103213547.175F020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:32984 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 16:35:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix non-atomic enqueue of huge page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-non-atomic-enqueue-of-huge-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: fix non-atomic enqueue of huge page

If a huge page is enqueued under the protection of hugetlb_lock, then the
operation is atomic and safe.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>		[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-non-atomic-enqueue-of-huge-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-non-atomic-enqueue-of-huge-page
+++ a/mm/hugetlb.c
@@ -901,7 +901,6 @@ retry:
 	h->resv_huge_pages += delta;
 	ret = 0;
 
-	spin_unlock(&hugetlb_lock);
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
@@ -915,6 +914,7 @@ retry:
 		VM_BUG_ON(page_count(page));
 		enqueue_huge_page(h, page);
 	}
+	spin_unlock(&hugetlb_lock);
 
 	/* Free unnecessary surplus pages to the buddy allocator */
 free:
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch
mm-vmscan-fix-typo-in-isolating-lru-pages.patch

