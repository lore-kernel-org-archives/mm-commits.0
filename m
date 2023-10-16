Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56025CDB474
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbjJPWuC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjJPWtx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:49:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8851D83
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:49:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E249C433C7;
        Mon, 16 Oct 2023 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697496590;
        bh=7kUlBRTtsHuUEH6DzUQqAkFSzn1hmKOrqIOtRl5oodQ=;
        h=Date:To:From:Subject:From;
        b=AadIl/KVeUK+yymVsYNJgzJCUYQoNHke1LEs2R7lI8yFej+FvkHgnaRFnWen0fRBb
         MeW9Jy0PZU1PTid4GnRGpGp1qv7nADbppGqeVdCexVzKflOrF1aIODWD3axYrQ1rFp
         XwaUr477KnPG3/g+jBIBX/TcKR5juUN5Oylfyj6k=
Date:   Mon, 16 Oct 2023 15:49:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-tune-pcp-high-automatically.patch added to mm-unstable branch
Message-Id: <20231016224950.1E249C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: tune PCP high automatically
has been added to the -mm mm-unstable branch.  Its filename is
     mm-tune-pcp-high-automatically.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-tune-pcp-high-automatically.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm: tune PCP high automatically
Date: Mon, 16 Oct 2023 13:30:00 +0800

The target to tune PCP high automatically is as follows,

- Minimize allocation/freeing from/to shared zone

- Minimize idle pages in PCP

- Minimize pages in PCP if the system free pages is too few

To reach these target, a tuning algorithm as follows is designed,

- When we refill PCP via allocating from the zone, increase PCP high.
  Because if we had larger PCP, we could avoid to allocate from the
  zone.

- In periodic vmstat updating kworker (via refresh_cpu_vm_stats()),
  decrease PCP high to try to free possible idle PCP pages.

- When page reclaiming is active for the zone, stop increasing PCP
  high in allocating path, decrease PCP high and free some pages in
  freeing path.

So, the PCP high can be tuned to the page allocating/freeing depth of
workloads eventually.

One issue of the algorithm is that if the number of pages allocated is
much more than that of pages freed on a CPU, the PCP high may become the
maximal value even if the allocating/freeing depth is small.  But this
isn't a severe issue, because there are no idle pages in this case.

One alternative choice is to increase PCP high when we drain PCP via
trying to free pages to the zone, but don't increase PCP high during PCP
refilling.  This can avoid the issue above.  But if the number of pages
allocated is much less than that of pages freed on a CPU, there will be
many idle pages in PCP and it is hard to free these idle pages.

1/8 (>> 3) of PCP high will be decreased periodically.  The value 1/8 is
kind of arbitrary.  Just to make sure that the idle PCP pages will be
freed eventually.

On a 2-socket Intel server with 224 logical CPU, we run 8 kbuild instances
in parallel (each with `make -j 28`) in 8 cgroup.  This simulates the
kbuild server that is used by 0-Day kbuild service.  With the patch, the
build time decreases 3.5%.  The cycles% of the spinlock contention (mostly
for zone lock) decreases from 11.0% to 0.5%.  The number of PCP draining
for high order pages freeing (free_high) decreases 65.6%.  The number of
pages allocated from zone (instead of from PCP) decreases 83.9%.

Link: https://lkml.kernel.org/r/20231016053002.756205-8-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 
 mm/page_alloc.c     |  119 +++++++++++++++++++++++++++++++++---------
 mm/vmstat.c         |    8 +-
 3 files changed, 99 insertions(+), 29 deletions(-)

--- a/include/linux/gfp.h~mm-tune-pcp-high-automatically
+++ a/include/linux/gfp.h
@@ -328,6 +328,7 @@ extern void page_frag_free(void *addr);
 #define free_page(addr) free_pages((addr), 0)
 
 void page_alloc_init_cpuhp(void);
+int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
--- a/mm/page_alloc.c~mm-tune-pcp-high-automatically
+++ a/mm/page_alloc.c
@@ -2193,6 +2193,40 @@ static int rmqueue_bulk(struct zone *zon
 	return i;
 }
 
+/*
+ * Called from the vmstat counter updater to decay the PCP high.
+ * Return whether there are addition works to do.
+ */
+int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
+{
+	int high_min, to_drain, batch;
+	int todo = 0;
+
+	high_min = READ_ONCE(pcp->high_min);
+	batch = READ_ONCE(pcp->batch);
+	/*
+	 * Decrease pcp->high periodically to try to free possible
+	 * idle PCP pages.  And, avoid to free too many pages to
+	 * control latency.  This caps pcp->high decrement too.
+	 */
+	if (pcp->high > high_min) {
+		pcp->high = max3(pcp->count - (batch << CONFIG_PCP_BATCH_SCALE_MAX),
+				 pcp->high - (pcp->high >> 3), high_min);
+		if (pcp->high > high_min)
+			todo++;
+	}
+
+	to_drain = pcp->count - pcp->high;
+	if (to_drain > 0) {
+		spin_lock(&pcp->lock);
+		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		spin_unlock(&pcp->lock);
+		todo++;
+	}
+
+	return todo;
+}
+
 #ifdef CONFIG_NUMA
 /*
  * Called from the vmstat counter updater to drain pagesets of this
@@ -2354,14 +2388,13 @@ static bool free_unref_page_prepare(stru
 	return true;
 }
 
-static int nr_pcp_free(struct per_cpu_pages *pcp, int high, bool free_high)
+static int nr_pcp_free(struct per_cpu_pages *pcp, int batch, int high, bool free_high)
 {
 	int min_nr_free, max_nr_free;
-	int batch = READ_ONCE(pcp->batch);
 
-	/* Free everything if batch freeing high-order pages. */
+	/* Free as much as possible if batch freeing high-order pages. */
 	if (unlikely(free_high))
-		return pcp->count;
+		return min(pcp->count, batch << CONFIG_PCP_BATCH_SCALE_MAX);
 
 	/* Check for PCP disabled or boot pageset */
 	if (unlikely(high < batch))
@@ -2376,7 +2409,7 @@ static int nr_pcp_free(struct per_cpu_pa
 	 * freeing of pages without any allocation.
 	 */
 	batch <<= pcp->free_factor;
-	if (batch < max_nr_free && pcp->free_factor < CONFIG_PCP_BATCH_SCALE_MAX)
+	if (batch <= max_nr_free && pcp->free_factor < CONFIG_PCP_BATCH_SCALE_MAX)
 		pcp->free_factor++;
 	batch = clamp(batch, min_nr_free, max_nr_free);
 
@@ -2384,28 +2417,48 @@ static int nr_pcp_free(struct per_cpu_pa
 }
 
 static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
-		       bool free_high)
+		       int batch, bool free_high)
 {
-	int high = READ_ONCE(pcp->high_min);
+	int high, high_min, high_max;
 
-	if (unlikely(!high || free_high))
+	high_min = READ_ONCE(pcp->high_min);
+	high_max = READ_ONCE(pcp->high_max);
+	high = pcp->high = clamp(pcp->high, high_min, high_max);
+
+	if (unlikely(!high))
 		return 0;
 
-	if (!test_bit(ZONE_RECLAIM_ACTIVE, &zone->flags))
-		return high;
+	if (unlikely(free_high)) {
+		pcp->high = max(high - (batch << CONFIG_PCP_BATCH_SCALE_MAX),
+				high_min);
+		return 0;
+	}
 
 	/*
 	 * If reclaim is active, limit the number of pages that can be
 	 * stored on pcp lists
 	 */
-	return min(READ_ONCE(pcp->batch) << 2, high);
+	if (test_bit(ZONE_RECLAIM_ACTIVE, &zone->flags)) {
+		pcp->high = max(high - (batch << pcp->free_factor), high_min);
+		return min(batch << 2, pcp->high);
+	}
+
+	if (pcp->count >= high && high_min != high_max) {
+		int need_high = (batch << pcp->free_factor) + batch;
+
+		/* pcp->high should be large enough to hold batch freed pages */
+		if (pcp->high < need_high)
+			pcp->high = clamp(need_high, high_min, high_max);
+	}
+
+	return high;
 }
 
 static void free_unref_page_commit(struct zone *zone, struct per_cpu_pages *pcp,
 				   struct page *page, int migratetype,
 				   unsigned int order)
 {
-	int high;
+	int high, batch;
 	int pindex;
 	bool free_high = false;
 
@@ -2420,6 +2473,7 @@ static void free_unref_page_commit(struc
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
+	batch = READ_ONCE(pcp->batch);
 	/*
 	 * As high-order pages other than THP's stored on PCP can contribute
 	 * to fragmentation, limit the number stored when PCP is heavily
@@ -2430,14 +2484,15 @@ static void free_unref_page_commit(struc
 		free_high = (pcp->free_factor &&
 			     (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) &&
 			     (!(pcp->flags & PCPF_FREE_HIGH_BATCH) ||
-			      pcp->count >= READ_ONCE(pcp->batch)));
+			      pcp->count >= READ_ONCE(batch)));
 		pcp->flags |= PCPF_PREV_FREE_HIGH_ORDER;
 	} else if (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) {
 		pcp->flags &= ~PCPF_PREV_FREE_HIGH_ORDER;
 	}
-	high = nr_pcp_high(pcp, zone, free_high);
+	high = nr_pcp_high(pcp, zone, batch, free_high);
 	if (pcp->count >= high) {
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, free_high), pcp, pindex);
+		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
+				   pcp, pindex);
 	}
 }
 
@@ -2721,24 +2776,38 @@ struct page *rmqueue_buddy(struct zone *
 	return page;
 }
 
-static int nr_pcp_alloc(struct per_cpu_pages *pcp, int order)
+static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
 {
-	int high, batch, max_nr_alloc;
+	int high, base_batch, batch, max_nr_alloc;
+	int high_max, high_min;
 
-	high = READ_ONCE(pcp->high_min);
-	batch = READ_ONCE(pcp->batch);
+	base_batch = READ_ONCE(pcp->batch);
+	high_min = READ_ONCE(pcp->high_min);
+	high_max = READ_ONCE(pcp->high_max);
+	high = pcp->high = clamp(pcp->high, high_min, high_max);
 
 	/* Check for PCP disabled or boot pageset */
-	if (unlikely(high < batch))
+	if (unlikely(high < base_batch))
 		return 1;
 
+	if (order)
+		batch = base_batch;
+	else
+		batch = (base_batch << pcp->alloc_factor);
+
 	/*
-	 * Double the number of pages allocated each time there is subsequent
-	 * allocation of order-0 pages without any freeing.
+	 * If we had larger pcp->high, we could avoid to allocate from
+	 * zone.
 	 */
+	if (high_min != high_max && !test_bit(ZONE_RECLAIM_ACTIVE, &zone->flags))
+		high = pcp->high = min(high + batch, high_max);
+
 	if (!order) {
-		max_nr_alloc = max(high - pcp->count - batch, batch);
-		batch <<= pcp->alloc_factor;
+		max_nr_alloc = max(high - pcp->count - base_batch, base_batch);
+		/*
+		 * Double the number of pages allocated each time there is
+		 * subsequent allocation of order-0 pages without any freeing.
+		 */
 		if (batch <= max_nr_alloc &&
 		    pcp->alloc_factor < CONFIG_PCP_BATCH_SCALE_MAX)
 			pcp->alloc_factor++;
@@ -2769,7 +2838,7 @@ struct page *__rmqueue_pcplist(struct zo
 
 	do {
 		if (list_empty(list)) {
-			int batch = nr_pcp_alloc(pcp, order);
+			int batch = nr_pcp_alloc(pcp, zone, order);
 			int alloced;
 
 			alloced = rmqueue_bulk(zone, order,
--- a/mm/vmstat.c~mm-tune-pcp-high-automatically
+++ a/mm/vmstat.c
@@ -816,9 +816,7 @@ static int refresh_cpu_vm_stats(bool do_
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
-#ifdef CONFIG_NUMA
 		struct per_cpu_pages __percpu *pcp = zone->per_cpu_pageset;
-#endif
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 			int v;
@@ -834,10 +832,12 @@ static int refresh_cpu_vm_stats(bool do_
 #endif
 			}
 		}
-#ifdef CONFIG_NUMA
 
 		if (do_pagesets) {
 			cond_resched();
+
+			changes += decay_pcp_high(zone, this_cpu_ptr(pcp));
+#ifdef CONFIG_NUMA
 			/*
 			 * Deal with draining the remote pageset of this
 			 * processor
@@ -866,8 +866,8 @@ static int refresh_cpu_vm_stats(bool do_
 				drain_zone_pages(zone, this_cpu_ptr(pcp));
 				changes++;
 			}
-		}
 #endif
+		}
 	}
 
 	for_each_online_pgdat(pgdat) {
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch
mm-pcp-avoid-to-drain-pcp-when-process-exit.patch
cacheinfo-calculate-size-of-per-cpu-data-cache-slice.patch
mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch
mm-restrict-the-pcp-batch-scale-factor-to-avoid-too-long-latency.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch
mm-add-framework-for-pcp-high-auto-tuning.patch
mm-tune-pcp-high-automatically.patch
mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch
mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch

