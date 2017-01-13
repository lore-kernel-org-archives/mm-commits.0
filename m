From: akpm@linux-foundation.org
Subject: + mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch added
 to -mm tree
Date: Fri, 13 Jan 2017 15:20:02 -0800
Message-ID: <587960a2.UiXOU7cOFt0dHPlH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbdAMXUD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 18:20:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: do not count freed pages as PGDEACTIVATE
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: do not count freed pages as PGDEACTIVATE

PGDEACTIVATE represents the number of pages moved from the active list to
the inactive list.  At least this sounds like the original motivation of
the counter.  move_active_pages_to_lru, however, counts pages which got
freed in the mean time as deactivated as well.  This is a very rare event
and counting them as deactivation in itself is not harmful but it makes
the code more convoluted than necessary - we have to count both all pages
and those which are freed which is a bit confusing.

After this patch the PGDEACTIVATE should have a slightly more clear
semantic and only count those pages which are moved from the active to the
inactive list which is a plus.

Link: http://lkml.kernel.org/r/20170112211221.17636-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-count-freed-pages-as-pgdeactivate mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-count-freed-pages-as-pgdeactivate
+++ a/mm/vmscan.c
@@ -1878,7 +1878,6 @@ static unsigned move_active_pages_to_lru
 				     enum lru_list lru)
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-	unsigned long pgmoved = 0;
 	struct page *page;
 	int nr_pages;
 	int nr_moved = 0;
@@ -1893,7 +1892,6 @@ static unsigned move_active_pages_to_lru
 		nr_pages = hpage_nr_pages(page);
 		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
 		list_move(&page->lru, &lruvec->lists[lru]);
-		pgmoved += nr_pages;
 
 		if (put_page_testzero(page)) {
 			__ClearPageLRU(page);
@@ -1913,7 +1911,7 @@ static unsigned move_active_pages_to_lru
 	}
 
 	if (!is_active_lru(lru))
-		__count_vm_events(PGDEACTIVATE, pgmoved);
+		__count_vm_events(PGDEACTIVATE, nr_moved);
 
 	return nr_moved;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch

