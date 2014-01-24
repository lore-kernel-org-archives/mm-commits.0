From: akpm@linux-foundation.org
Subject: +
 mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch added to -mm tree
Date: Fri, 24 Jan 2014 14:29:22 -0800
Message-ID: <52e2e942.CugY5rrwyqqO7pMV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaAXW3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 17:29:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, riel@redhat.com, mgorman@suse.de, fengguang.wu@intel.com, hannes@cmpxchg.org

Subject: + mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch added to -mm tree
To: hannes@cmpxchg.org,fengguang.wu@intel.com,mgorman@suse.de,riel@redhat.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 14:29:22 -0800


The patch titled
     Subject: mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch

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
Subject: mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory

The dirty_balance_reserve is an approximation of the fraction of free
pages that the page allocator does not make available for page cache
allocations.  As a result, it has to be taken into account when
calculating the amount of "dirtyable memory", the baseline to which
dirty_background_ratio and dirty_ratio are applied.

However, currently the reserve is subtracted from the sum of free and
reclaimable pages, which is non-sensical and leads to erroneous results
when the system is dominated by unreclaimable pages and the
dirty_balance_reserve is bigger than free+reclaimable.  In that case, at
least the already allocated cache should be considered dirtyable.

Fix the calculation by subtracting the reserve from the amount of free
pages, then adding the reclaimable pages on top.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   52 ++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -191,6 +191,25 @@ static unsigned long writeout_period_tim
  * global dirtyable memory first.
  */
 
+/**
+ * zone_dirtyable_memory - number of dirtyable pages in a zone
+ * @zone: the zone
+ *
+ * Returns the zone's number of pages potentially available for dirty
+ * page cache.  This is the base value for the per-zone dirty limits.
+ */
+static unsigned long zone_dirtyable_memory(struct zone *zone)
+{
+	unsigned long nr_pages;
+
+	nr_pages = zone_page_state(zone, NR_FREE_PAGES);
+	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
+
+	nr_pages += zone_reclaimable_pages(zone);
+
+	return nr_pages;
+}
+
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
 #ifdef CONFIG_HIGHMEM
@@ -201,8 +220,7 @@ static unsigned long highmem_dirtyable_m
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
+		x += zone_dirtyable_memory(zone);
 	}
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
@@ -238,9 +256,11 @@ static unsigned long global_dirtyable_me
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x = global_page_state(NR_FREE_PAGES);
 	x -= min(x, dirty_balance_reserve);
 
+	x += global_reclaimable_pages();
+
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
 
@@ -289,32 +309,6 @@ void global_dirty_limits(unsigned long *
 }
 
 /**
- * zone_dirtyable_memory - number of dirtyable pages in a zone
- * @zone: the zone
- *
- * Returns the zone's number of pages potentially available for dirty
- * page cache.  This is the base value for the per-zone dirty limits.
- */
-static unsigned long zone_dirtyable_memory(struct zone *zone)
-{
-	/*
-	 * The effective global number of dirtyable pages may exclude
-	 * highmem as a big-picture measure to keep the ratio between
-	 * dirty memory and lowmem reasonable.
-	 *
-	 * But this function is purely about the individual zone and a
-	 * highmem zone can hold its share of dirty pages, so we don't
-	 * care about vm_highmem_is_dirtyable here.
-	 */
-	unsigned long nr_pages = zone_page_state(zone, NR_FREE_PAGES) +
-		zone_reclaimable_pages(zone);
-
-	/* don't allow this to underflow */
-	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
-	return nr_pages;
-}
