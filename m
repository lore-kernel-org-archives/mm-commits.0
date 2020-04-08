From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_reporting-rotate-reported-pages-to-the-tail-of-the-list.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:57:24 -0700
Message-ID: <20200408015724.mltvp5_8R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgDHB50 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com, lcapitulino@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, nitesh@redhat.com, osalvador@suse.de, pagupta@redhat.com, pbonzini@redhat.com, riel@surriel.com, vbabka@suse.cz, wei.w.wang@intel.com, weiqi4@huawei.com, willy@infradead.org, yang.zhang.wz@gmail.com


The patch titled
     Subject: mm/page_reporting: rotate reported pages to the tail of the list
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-rotate-reported-pages-to-the-tail-of-the-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: mm/page_reporting: rotate reported pages to the tail of the list

Rather than walking over the same pages again and again to get to the
pages that have yet to be reported we can save ourselves a significant
amount of time by simply rotating the list so that when we have a full
list of reported pages the head of the list is pointing to the next
non-reported page.  Doing this should save us some significant time when
processing each free list.

This doesn't gain us much in the standard case as all of the non-reported
pages should be near the top of the list already.  However in the case of
page shuffling this results in a noticeable improvement.  Below are the
will-it-scale page_fault1 w/ THP numbers for 16 tasks with and without
this patch.

Without:
tasks   processes       processes_idle  threads         threads_idle
16      8093776.25      0.17            5393242.00      38.20

With:
tasks   processes       processes_idle  threads         threads_idle
16      8283274.75      0.17            5594261.00      38.15

Link: http://lkml.kernel.org/r/20200211224708.29318.16862.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Yang Zhang <yang.zhang.wz@gmail.com>
Cc: wei qi <weiqi4@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/mm/page_reporting.c~mm-page_reporting-rotate-reported-pages-to-the-tail-of-the-list
+++ a/mm/page_reporting.c
@@ -131,17 +131,27 @@ page_reporting_cycle(struct page_reporti
 		if (PageReported(page))
 			continue;
 
-		/* Attempt to pull page from list */
-		if (!__isolate_free_page(page, order))
-			break;
-
-		/* Add page to scatter list */
-		--(*offset);
-		sg_set_page(&sgl[*offset], page, page_len, 0);
+		/* Attempt to pull page from list and place in scatterlist */
+		if (*offset) {
+			if (!__isolate_free_page(page, order)) {
+				next = page;
+				break;
+			}
+
+			/* Add page to scatter list */
+			--(*offset);
+			sg_set_page(&sgl[*offset], page, page_len, 0);
 
-		/* If scatterlist isn't full grab more pages */
-		if (*offset)
 			continue;
+		}
+
+		/*
+		 * Make the first non-processed page in the free list
+		 * the new head of the free list before we release the
+		 * zone lock.
+		 */
+		if (&page->lru != list && !list_is_first(&page->lru, list))
+			list_rotate_to_front(&page->lru, list);
 
 		/* release lock before waiting on report processing */
 		spin_unlock_irq(&zone->lock);
@@ -169,6 +179,10 @@ page_reporting_cycle(struct page_reporti
 			break;
 	}
 
+	/* Rotate any leftover pages to the head of the freelist */
+	if (&next->lru != list && !list_is_first(&next->lru, list))
+		list_rotate_to_front(&next->lru, list);
+
 	spin_unlock_irq(&zone->lock);
 
 	return err;
_

Patches currently in -mm which might be from alexander.h.duyck@linux.intel.com are
