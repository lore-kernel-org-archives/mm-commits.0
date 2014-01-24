From: akpm@linux-foundation.org
Subject: +
 mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch added
 to -mm tree
Date: Fri, 24 Jan 2014 14:29:23 -0800
Message-ID: <52e2e943.HeWYR4W5Z6wHUprG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaAXW3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 17:29:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, riel@redhat.com, mgorman@suse.de, fengguang.wu@intel.com, hannes@cmpxchg.org

Subject: + mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch added to -mm tree
To: hannes@cmpxchg.org,fengguang.wu@intel.com,mgorman@suse.de,riel@redhat.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 14:29:23 -0800


The patch titled
     Subject: mm/page-writeback.c: do not count anon pages as dirtyable memory
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/page-writeback.c: do not count anon pages as dirtyable memory

The VM is currently heavily tuned to avoid swapping.  Whether that is good
or bad is a separate discussion, but as long as the VM won't swap to make
room for dirty cache, we can not consider anonymous pages when calculating
the amount of dirtyable memory, the baseline to which
dirty_background_ratio and dirty_ratio are applied.

A simple workload that occupies a significant size (40+%, depending on
memory layout, storage speeds etc.) of memory with anon/tmpfs pages and
uses the remainder for a streaming writer demonstrates this problem.  In
that case, the actual cache pages are a small fraction of what is
considered dirtyable overall, which results in an relatively large portion
of the cache pages to be dirtied.  As kswapd starts rotating these, random
tasks enter direct reclaim and stall on IO.

Only consider free pages and file pages dirtyable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 --
 mm/internal.h          |    1 -
 mm/page-writeback.c    |    6 ++++--
 mm/vmscan.c            |   23 +----------------------
 4 files changed, 5 insertions(+), 27 deletions(-)

diff -puN include/linux/vmstat.h~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory
+++ a/include/linux/vmstat.h
@@ -150,8 +150,6 @@ static inline unsigned long zone_page_st
 	return x;
 }
 
-extern unsigned long global_reclaimable_pages(void);
-
 #ifdef CONFIG_NUMA
 /*
  * Determine the per node value of a stat item. This function
diff -puN mm/internal.h~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory mm/internal.h
--- a/mm/internal.h~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory
+++ a/mm/internal.h
@@ -83,7 +83,6 @@ extern unsigned long highest_memmap_pfn;
  */
 extern int isolate_lru_page(struct page *page);
 extern void putback_lru_page(struct page *page);
-extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern bool zone_reclaimable(struct zone *zone);
 
 /*
diff -puN mm/page-writeback.c~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -205,7 +205,8 @@ static unsigned long zone_dirtyable_memo
 	nr_pages = zone_page_state(zone, NR_FREE_PAGES);
 	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
 
-	nr_pages += zone_reclaimable_pages(zone);
+	nr_pages += zone_page_state(zone, NR_INACTIVE_FILE);
+	nr_pages += zone_page_state(zone, NR_ACTIVE_FILE);
 
 	return nr_pages;
 }
@@ -259,7 +260,8 @@ static unsigned long global_dirtyable_me
 	x = global_page_state(NR_FREE_PAGES);
 	x -= min(x, dirty_balance_reserve);
 
-	x += global_reclaimable_pages();
+	x += global_page_state(NR_INACTIVE_FILE);
+	x += global_page_state(NR_ACTIVE_FILE);
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff -puN mm/vmscan.c~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory mm/vmscan.c
--- a/mm/vmscan.c~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory
+++ a/mm/vmscan.c
@@ -147,7 +147,7 @@ static bool global_reclaim(struct scan_c
 }
 #endif
 
-unsigned long zone_reclaimable_pages(struct zone *zone)
+static unsigned long zone_reclaimable_pages(struct zone *zone)
 {
 	int nr;
 
@@ -3304,27 +3304,6 @@ void wakeup_kswapd(struct zone *zone, in
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
-/*
- * The reclaimable count would be mostly accurate.
- * The less reclaimable pages may be
- * - mlocked pages, which will be moved to unevictable list when encountered
- * - mapped pages, which may require several travels to be reclaimed
- * - dirty pages, which is not "instantly" reclaimable
- */
-unsigned long global_reclaimable_pages(void)
-{
-	int nr;
-
-	nr = global_page_state(NR_ACTIVE_FILE) +
-	     global_page_state(NR_INACTIVE_FILE);
-
-	if (get_nr_swap_pages() > 0)
-		nr += global_page_state(NR_ACTIVE_ANON) +
-		      global_page_state(NR_INACTIVE_ANON);
-
-	return nr;
-}
