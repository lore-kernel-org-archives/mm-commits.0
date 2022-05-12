Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1476BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 19:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358170AbiELTou (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 15:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358160AbiELTok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 15:44:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641BF2469EA
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 12:44:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9E17B82AED
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E83C385B8;
        Thu, 12 May 2022 19:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652384675;
        bh=VBB8MC8LHvBU6r9x5KnAipoZs54yKLap/U6LAdibSzA=;
        h=Date:To:From:Subject:From;
        b=sx4SFr2SEaawdUYR7p5A385JZ9CG3mWRXeclo6XNS8RxZK26HkH+0r9zNFJOZbhhV
         GP3xo+j//5L5TyEkX0d2d/lAKglRz2cW1Mk0tQ/27ACX73PnOTJ+LsUvJa5+9ISWqw
         5s8c9XRi8J8nZjRX3J1sOm1+baN8+W2F0qy++OKE=
Date:   Thu, 12 May 2022 12:44:34 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nsaenzju@redhat.com,
        mtosatti@redhat.com, minchan@kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch added to mm-unstable branch
Message-Id: <20220512194435.88E83C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: protect PCP lists with a spinlock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch

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
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: protect PCP lists with a spinlock

Currently the PCP lists are protected by using local_lock_irqsave to
prevent migration and IRQ reentrancy but this is inconvenient.  Remote
draining of the lists is impossible and a workqueue is required and every
task allocation/free must disable then enable interrupts which is
expensive.

As preparation for dealing with both of those problems, protect the lists
with a spinlock.  The IRQ-unsafe version of the lock is used because IRQs
are already disabled by local_lock_irqsave.  spin_trylock is used in
preparation for a time when local_lock could be used instead of
lock_lock_irqsave.

The per_cpu_pages still fits within the same number of cache lines after
this patch relative to before the series.

struct per_cpu_pages {
        spinlock_t                 lock;                 /*     0     4 */
        int                        count;                /*     4     4 */
        int                        high;                 /*     8     4 */
        int                        batch;                /*    12     4 */
        short int                  free_factor;          /*    16     2 */
        short int                  expire;               /*    18     2 */

        /* XXX 4 bytes hole, try to pack */

        struct list_head           lists[13];            /*    24   208 */

        /* size: 256, cachelines: 4, members: 7 */
        /* sum members: 228, holes: 1, sum holes: 4 */
        /* padding: 24 */
} __attribute__((__aligned__(64)));

There is overhead in the fast path due to acquiring the spinlock even
though the spinlock is per-cpu and uncontended in the common case.  Page
Fault Test (PFT) running on a 1-socket reported the following results on a
1 socket machine.

                                     5.18.0-rc1               5.18.0-rc1
                                        vanilla         mm-pcpdrain-v2r1
Hmean     faults/sec-1   886331.5718 (   0.00%)   885462.7479 (  -0.10%)
Hmean     faults/sec-3  2337706.1583 (   0.00%)  2332130.4909 *  -0.24%*
Hmean     faults/sec-5  2851594.2897 (   0.00%)  2844123.9307 (  -0.26%)
Hmean     faults/sec-7  3543251.5507 (   0.00%)  3516889.0442 *  -0.74%*
Hmean     faults/sec-8  3947098.0024 (   0.00%)  3916162.8476 *  -0.78%*
Stddev    faults/sec-1     2302.9105 (   0.00%)     2065.0845 (  10.33%)
Stddev    faults/sec-3     7275.2442 (   0.00%)     6033.2620 (  17.07%)
Stddev    faults/sec-5    24726.0328 (   0.00%)    12525.1026 (  49.34%)
Stddev    faults/sec-7     9974.2542 (   0.00%)     9543.9627 (   4.31%)
Stddev    faults/sec-8     9468.0191 (   0.00%)     7958.2607 (  15.95%)
CoeffVar  faults/sec-1        0.2598 (   0.00%)        0.2332 (  10.24%)
CoeffVar  faults/sec-3        0.3112 (   0.00%)        0.2587 (  16.87%)
CoeffVar  faults/sec-5        0.8670 (   0.00%)        0.4404 (  49.21%)
CoeffVar  faults/sec-7        0.2815 (   0.00%)        0.2714 (   3.60%)
CoeffVar  faults/sec-8        0.2399 (   0.00%)        0.2032 (  15.28%)

There is a small hit in the number of faults per second but given that the
results are more stable, it's borderline noise.

Link: https://lkml.kernel.org/r/20220512085043.5234-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 
 mm/page_alloc.c        |  169 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 149 insertions(+), 21 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-protect-pcp-lists-with-a-spinlock
+++ a/include/linux/mmzone.h
@@ -382,6 +382,7 @@ enum zone_watermarks {
 
 /* Fields and list protected by pagesets local_lock in page_alloc.c */
 struct per_cpu_pages {
+	spinlock_t lock;	/* Protects lists field */
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
 	int batch;		/* chunk size for buddy add/remove */
--- a/mm/page_alloc.c~mm-page_alloc-protect-pcp-lists-with-a-spinlock
+++ a/mm/page_alloc.c
@@ -133,6 +133,20 @@ static DEFINE_PER_CPU(struct pagesets, p
 	.lock = INIT_LOCAL_LOCK(lock),
 };
 
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
+/*
+ * On SMP, spin_trylock is sufficient protection.
+ * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
+ */
+#define pcp_trylock_prepare(flags)	do { } while (0)
+#define pcp_trylock_finish(flag)	do { } while (0)
+#else
+
+/* UP spin_trylock always succeeds so disable IRQs to prevent re-entrancy. */
+#define pcp_trylock_prepare(flags)	local_irq_save(flags)
+#define pcp_trylock_finish(flags)	local_irq_restore(flags)
+#endif
+
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -3072,15 +3086,22 @@ static int rmqueue_bulk(struct zone *zon
  */
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	unsigned long flags;
 	int to_drain, batch;
 
-	local_lock_irqsave(&pagesets.lock, flags);
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
-	if (to_drain > 0)
+	if (to_drain > 0) {
+		unsigned long flags;
+
+		/*
+		 * free_pcppages_bulk expects IRQs disabled for zone->lock
+		 * so even though pcp->lock is not intended to be IRQ-safe,
+		 * it's needed in this context.
+		 */
+		spin_lock_irqsave(&pcp->lock, flags);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-	local_unlock_irqrestore(&pagesets.lock, flags);
+		spin_unlock_irqrestore(&pcp->lock, flags);
+	}
 }
 #endif
 
@@ -3093,16 +3114,17 @@ void drain_zone_pages(struct zone *zone,
  */
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
-	unsigned long flags;
 	struct per_cpu_pages *pcp;
 
-	local_lock_irqsave(&pagesets.lock, flags);
-
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-	if (pcp->count)
-		free_pcppages_bulk(zone, pcp->count, pcp, 0);
+	if (pcp->count) {
+		unsigned long flags;
 
-	local_unlock_irqrestore(&pagesets.lock, flags);
+		/* See drain_zone_pages on why this is disabling IRQs */
+		spin_lock_irqsave(&pcp->lock, flags);
+		free_pcppages_bulk(zone, pcp->count, pcp, 0);
+		spin_unlock_irqrestore(&pcp->lock, flags);
+	}
 }
 
 /*
@@ -3370,18 +3392,30 @@ static int nr_pcp_high(struct per_cpu_pa
 	return min(READ_ONCE(pcp->batch) << 2, high);
 }
 
-static void free_unref_page_commit(struct page *page, int migratetype,
-				   unsigned int order)
+/* Returns true if the page was committed to the per-cpu list. */
+static bool free_unref_page_commit(struct page *page, int migratetype,
+				   unsigned int order, bool locked)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	int high;
 	int pindex;
 	bool free_high;
+	unsigned long __maybe_unused UP_flags;
 
 	__count_vm_event(PGFREE);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pindex = order_to_pindex(migratetype, order);
+
+	if (!locked) {
+		/* Protect against a parallel drain. */
+		pcp_trylock_prepare(UP_flags);
+		if (!spin_trylock(&pcp->lock)) {
+			pcp_trylock_finish(UP_flags);
+			return false;
+		}
+	}
+
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
@@ -3399,6 +3433,13 @@ static void free_unref_page_commit(struc
 
 		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch, free_high), pcp, pindex);
 	}
+
+	if (!locked) {
+		spin_unlock(&pcp->lock);
+		pcp_trylock_finish(UP_flags);
+	}
+
+	return true;
 }
 
 /*
@@ -3409,6 +3450,7 @@ void free_unref_page(struct page *page,
 	unsigned long flags;
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
+	bool freed_pcp = false;
 
 	if (!free_unref_page_prepare(page, pfn, order))
 		return;
@@ -3430,8 +3472,11 @@ void free_unref_page(struct page *page,
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
-	free_unref_page_commit(page, migratetype, order);
+	freed_pcp = free_unref_page_commit(page, migratetype, order, false);
 	local_unlock_irqrestore(&pagesets.lock, flags);
+
+	if (unlikely(!freed_pcp))
+		free_one_page(page_zone(page), page, pfn, order, migratetype, FPI_NONE);
 }
 
 /*
@@ -3440,10 +3485,19 @@ void free_unref_page(struct page *page,
 void free_unref_page_list(struct list_head *list)
 {
 	struct page *page, *next;
+	struct per_cpu_pages *pcp;
+	struct zone *locked_zone;
 	unsigned long flags;
 	int batch_count = 0;
 	int migratetype;
 
+	/*
+	 * An empty list is possible. Check early so that the later
+	 * lru_to_page() does not potentially read garbage.
+	 */
+	if (list_empty(list))
+		return;
+
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
 		unsigned long pfn = page_to_pfn(page);
@@ -3464,8 +3518,33 @@ void free_unref_page_list(struct list_he
 		}
 	}
 
+	/*
+	 * Preparation could have drained the list due to failing to prepare
+	 * or all pages are being isolated.
+	 */
+	if (list_empty(list))
+		return;
+
+	VM_BUG_ON(in_hardirq());
+
 	local_lock_irqsave(&pagesets.lock, flags);
+
+	page = lru_to_page(list);
+	locked_zone = page_zone(page);
+	pcp = this_cpu_ptr(locked_zone->per_cpu_pageset);
+	spin_lock(&pcp->lock);
+
 	list_for_each_entry_safe(page, next, list, lru) {
+		struct zone *zone = page_zone(page);
+
+		/* Different zone, different pcp lock. */
+		if (zone != locked_zone) {
+			spin_unlock(&pcp->lock);
+			locked_zone = zone;
+			pcp = this_cpu_ptr(zone->per_cpu_pageset);
+			spin_lock(&pcp->lock);
+		}
+
 		/*
 		 * Non-isolated types over MIGRATE_PCPTYPES get added
 		 * to the MIGRATE_MOVABLE pcp list.
@@ -3475,18 +3554,33 @@ void free_unref_page_list(struct list_he
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(page);
-		free_unref_page_commit(page, migratetype, 0);
+
+		/*
+		 * If there is a parallel drain in progress, free to the buddy
+		 * allocator directly. This is expensive as the zone lock will
+		 * be acquired multiple times but if a drain is in progress
+		 * then an expensive operation is already taking place.
+		 *
+		 * TODO: Always false at the moment due to local_lock_irqsave
+		 *       and is preparation for converting to local_lock.
+		 */
+		if (unlikely(!free_unref_page_commit(page, migratetype, 0, true)))
+			free_one_page(page_zone(page), page, page_to_pfn(page), 0, migratetype, FPI_NONE);
 
 		/*
 		 * Guard against excessive IRQ disabled times when we get
 		 * a large list of pages to free.
 		 */
 		if (++batch_count == SWAP_CLUSTER_MAX) {
+			spin_unlock(&pcp->lock);
 			local_unlock_irqrestore(&pagesets.lock, flags);
 			batch_count = 0;
 			local_lock_irqsave(&pagesets.lock, flags);
+			pcp = this_cpu_ptr(locked_zone->per_cpu_pageset);
+			spin_lock(&pcp->lock);
 		}
 	}
+	spin_unlock(&pcp->lock);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
@@ -3658,9 +3752,28 @@ struct page *__rmqueue_pcplist(struct zo
 			int migratetype,
 			unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
-			struct list_head *list)
+			struct list_head *list,
+			bool locked)
 {
 	struct page *page;
+	unsigned long __maybe_unused UP_flags;
+
+	/*
+	 * spin_trylock is not necessary right now due to due to
+	 * local_lock_irqsave and is a preparation step for
+	 * a conversion to local_lock using the trylock to prevent
+	 * IRQ re-entrancy. If pcp->lock cannot be acquired, the caller
+	 * uses rmqueue_buddy.
+	 *
+	 * TODO: Convert local_lock_irqsave to local_lock.
+	 */
+	if (unlikely(!locked)) {
+		pcp_trylock_prepare(UP_flags);
+		if (!spin_trylock(&pcp->lock)) {
+			pcp_trylock_finish(UP_flags);
+			return NULL;
+		}
+	}
 
 	do {
 		if (list_empty(list)) {
@@ -3681,8 +3794,10 @@ struct page *__rmqueue_pcplist(struct zo
 					migratetype, alloc_flags);
 
 			pcp->count += alloced << order;
-			if (unlikely(list_empty(list)))
-				return NULL;
+			if (unlikely(list_empty(list))) {
+				page = NULL;
+				goto out;
+			}
 		}
 
 		page = list_first_entry(list, struct page, pcp_list);
@@ -3690,6 +3805,12 @@ struct page *__rmqueue_pcplist(struct zo
 		pcp->count -= 1 << order;
 	} while (check_new_pcp(page, order));
 
+out:
+	if (!locked) {
+		spin_unlock(&pcp->lock);
+		pcp_trylock_finish(UP_flags);
+	}
+
 	return page;
 }
 
@@ -3714,7 +3835,7 @@ static struct page *rmqueue_pcplist(stru
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pcp->free_factor >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list, false);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
@@ -3749,7 +3870,8 @@ struct page *rmqueue(struct zone *prefer
 				migratetype != MIGRATE_MOVABLE) {
 			page = rmqueue_pcplist(preferred_zone, zone, order,
 					gfp_flags, migratetype, alloc_flags);
-			goto out;
+			if (likely(page))
+				goto out;
 		}
 	}
 
@@ -5316,6 +5438,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	local_lock_irqsave(&pagesets.lock, flags);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
+	spin_lock(&pcp->lock);
 
 	while (nr_populated < nr_pages) {
 
@@ -5326,11 +5449,13 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+							pcp, pcp_list, true);
 		if (unlikely(!page)) {
 			/* Try and get at least one page */
-			if (!nr_populated)
+			if (!nr_populated) {
+				spin_unlock(&pcp->lock);
 				goto failed_irq;
+			}
 			break;
 		}
 		nr_account++;
@@ -5343,6 +5468,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		nr_populated++;
 	}
 
+	spin_unlock(&pcp->lock);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
@@ -6992,6 +7118,7 @@ static void per_cpu_pages_init(struct pe
 	memset(pcp, 0, sizeof(*pcp));
 	memset(pzstats, 0, sizeof(*pzstats));
 
+	spin_lock_init(&pcp->lock);
 	for (pindex = 0; pindex < NR_PCP_LISTS; pindex++)
 		INIT_LIST_HEAD(&pcp->lists[pindex]);
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch

