From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:02 -0800
Message-ID: <52eab06e.Hiax6Nlg7a8mtuib%akpm__20829.0214570754$1391112315$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaA3UFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, fengguang.wu@intel.com, hannes@cmpxchg.org

Subject: [merged] mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch removed from -mm tree
To: hannes@cmpxchg.org,fengguang.wu@intel.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,stable@vger.kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:02 -0800


The patch titled
     Subject: mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory
has been removed from the -mm tree.  Its filename was
     mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory

Tejun reported stuttering and latency spikes on a system where random
tasks would enter direct reclaim and get stuck on dirty pages.  Around
50% of memory was occupied by tmpfs backed by an SSD, and another disk
(rotating) was reading and writing at max speed to shrink a partition.

: The problem was pretty ridiculous.  It's a 8gig machine w/ one ssd and 10k
: rpm harddrive and I could reliably reproduce constant stuttering every
: several seconds for as long as buffered IO was going on on the hard drive
: either with tmpfs occupying somewhere above 4gig or a test program which
: allocates about the same amount of anon memory.  Although swap usage was
: zero, turning off swap also made the problem go away too.
: 
: The trigger conditions seem quite plausible - high anon memory usage w/
: heavy buffered IO and swap configured - and it's highly likely that this
: is happening in the wild too.  (this can happen with copying large files
: to usb sticks too, right?)


This patch (of 2):

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

[akpm@linux-foundation.org: fix CONFIG_HIGHMEM build]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Tested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   55 ++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

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
@@ -198,11 +217,9 @@ static unsigned long highmem_dirtyable_m
 	unsigned long x = 0;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
-		struct zone *z =
-			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+		struct zone *z = &NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
+		x += zone_dirtyable_memory(z);
 	}
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
@@ -238,9 +255,11 @@ static unsigned long global_dirtyable_me
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x = global_page_state(NR_FREE_PAGES);
 	x -= min(x, dirty_balance_reserve);
 
+	x += global_reclaimable_pages();
+
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
 
@@ -289,32 +308,6 @@ void global_dirty_limits(unsigned long *
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
