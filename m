From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fair-zone-allocator-policy.patch added to -mm
 tree
Date: Fri, 26 Jul 2013 15:59:56 -0700
Message-ID: <51f2ff6c.vjsCcmjdP+cLZctm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab3GZW75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 18:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, paul.bollee@gmail.com, mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org

Subject: + mm-page_alloc-fair-zone-allocator-policy.patch added to -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,mgorman@suse.de,paul.bollee@gmail.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 15:59:56 -0700


The patch titled
     Subject: mm: page_alloc: fair zone allocator policy
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fair-zone-allocator-policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fair-zone-allocator-policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fair-zone-allocator-policy.patch

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
Subject: mm: page_alloc: fair zone allocator policy

Each zone that holds userspace pages of one workload must be aged at a
speed proportional to the zone size.  Otherwise, the time an individual
page gets to stay in memory depends on the zone it happened to be
allocated in.  Asymmetry in the zone aging creates rather unpredictable
aging behavior and results in the wrong pages being reclaimed, activated
etc.

But exactly this happens right now because of the way the page allocator
and kswapd interact.  The page allocator uses per-node lists of all zones
in the system, ordered by preference, when allocating a new page.  When
the first iteration does not yield any results, kswapd is woken up and the
allocator retries.  Due to the way kswapd reclaims zones below the high
watermark while a zone can be allocated from when it is above the low
watermark, the allocator may keep kswapd running while kswapd reclaim
ensures that the page allocator can keep allocating from the first zone in
the zonelist for extended periods of time.  Meanwhile the other zones
rarely see new allocations and thus get aged much slower in comparison.

The result is that the occasional page placed in lower zones gets
relatively more time in memory, even get promoted to the active list after
its peers have long been evicted.  Meanwhile, the bulk of the working set
may be thrashing on the preferred zone even though there may be
significant amounts of memory available in the lower zones.

Even the most basic test -- repeatedly reading a file slightly bigger than
memory -- shows how broken the zone aging is.  In this scenario, no single
page should be able stay in memory long enough to get referenced twice and
activated, but activation happens in spades:

  $ grep active_file /proc/zoneinfo
      nr_inactive_file 0
      nr_active_file 0
      nr_inactive_file 0
      nr_active_file 8
      nr_inactive_file 1582
      nr_active_file 11994
  $ cat data data data data >/dev/null
  $ grep active_file /proc/zoneinfo
      nr_inactive_file 0
      nr_active_file 70
      nr_inactive_file 258753
      nr_active_file 443214
      nr_inactive_file 149793
      nr_active_file 12021

Fix this with a very simple round robin allocator.  Each zone is allowed a
batch of allocations that is proportional to the zone's size, after which
it is treated as full.  The batch counters are reset when all zones have
been tried and the allocator enters the slowpath and kicks off kswapd
reclaim:

  $ grep active_file /proc/zoneinfo
      nr_inactive_file 0
      nr_active_file 0
      nr_inactive_file 174
      nr_active_file 4865
      nr_inactive_file 53
      nr_active_file 860
  $ cat data data data data >/dev/null
  $ grep active_file /proc/zoneinfo
      nr_inactive_file 0
      nr_active_file 0
      nr_inactive_file 666622
      nr_active_file 4988
      nr_inactive_file 190969
      nr_active_file 937

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Bolle <paul.bollee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   39 +++++++++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy
+++ a/include/linux/mmzone.h
@@ -352,6 +352,7 @@ struct zone {
 	 * free areas of different sizes
 	 */
 	spinlock_t		lock;
+	atomic_t		alloc_batch;
 	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 	/* Set to true when the PG_migrate_skip bits should be cleared */
diff -puN mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy
+++ a/mm/page_alloc.c
@@ -1901,6 +1901,14 @@ zonelist_scan:
 		if (alloc_flags & ALLOC_NO_WATERMARKS)
 			goto try_this_zone;
 		/*
+		 * Distribute pages in proportion to the individual
+		 * zone size to ensure fair page aging.  The zone a
+		 * page was allocated in should have no effect on the
+		 * time the page has in memory before being reclaimed.
+		 */
+		if (atomic_read(&zone->alloc_batch) <= 0)
+			continue;
+		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a zone that is within its dirty
 		 * limit, such that no single zone holds more than its
@@ -2006,7 +2014,8 @@ this_zone_full:
 		goto zonelist_scan;
 	}
 
-	if (page)
+	if (page) {
+		atomic_sub(1U << order, &zone->alloc_batch);
 		/*
 		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
 		 * necessary to allocate the page. The expectation is
@@ -2015,6 +2024,7 @@ this_zone_full:
 		 * for !PFMEMALLOC purposes.
 		 */
 		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+	}
 
 	return page;
 }
@@ -2346,16 +2356,20 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 	return page;
 }
 
-static inline
-void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
-						enum zone_type high_zoneidx,
-						enum zone_type classzone_idx)
+static void prepare_slowpath(gfp_t gfp_mask, unsigned int order,
+			     struct zonelist *zonelist,
+			     enum zone_type high_zoneidx,
+			     enum zone_type classzone_idx)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
-		wakeup_kswapd(zone, order, classzone_idx);
+	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+		atomic_set(&zone->alloc_batch,
+			   high_wmark_pages(zone) - low_wmark_pages(zone));
+		if (!(gfp_mask & __GFP_NO_KSWAPD))
+			wakeup_kswapd(zone, order, classzone_idx);
+	}
 }
 
 static inline int
@@ -2451,9 +2465,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapd(order, zonelist, high_zoneidx,
-						zone_idx(preferred_zone));
+	prepare_slowpath(gfp_mask, order, zonelist,
+			 high_zoneidx, zone_idx(preferred_zone));
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -4754,6 +4767,9 @@ static void __paginginit free_area_init_
 		zone_seqlock_init(zone);
 		zone->zone_pgdat = pgdat;
 
+		/* For bootup, initialized properly in watermark setup */
+		atomic_set(&zone->alloc_batch, zone->managed_pages);
+
 		zone_pcp_init(zone);
 		lruvec_init(&zone->lruvec);
 		if (!size)
@@ -5525,6 +5541,9 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
+		atomic_set(&zone->alloc_batch,
+			   high_wmark_pages(zone) - low_wmark_pages(zone));
+
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
mm-kill-one-if-loop-in-__free_pages_bootmem.patch
mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch
mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
mm-page_alloc-fair-zone-allocator-policy.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

