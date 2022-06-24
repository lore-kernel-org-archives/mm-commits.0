Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7B8C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiFXTI2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiFXTIV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:08:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A3A36E2E
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56935B82B92
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C705C34114;
        Fri, 24 Jun 2022 19:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656097697;
        bh=KFs2kKbBD0SI8aqh4LPf6gS4uW6hkHk5xZzZDh3jofY=;
        h=Date:To:From:Subject:From;
        b=C1RB1cV3k6j6OXWuDfkd7HfJB9EbJzu5xVGKC/2QRe4+s5HMBLDT4+ooM8caHFIIT
         0dDW9eKdqt9DdxOCbrRoM9rhNKTSTpvB6mtY9AchmUtyq30InzQ2NAG4DV3/zYEFIt
         hwWYa6hDC2YSsgS+Jx4obrb1ZHgq45njpBdrOh2o=
Date:   Fri, 24 Jun 2022 12:08:16 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        nsaenzju@redhat.com, mtosatti@redhat.com, m.szyprowski@samsung.com,
        minchan@kernel.org, mhocko@kernel.org, hughd@google.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch added to mm-unstable branch
Message-Id: <20220624190817.0C705C34114@smtp.kernel.org>
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
Date: Fri, 24 Jun 2022 13:54:21 +0100

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

                                     5.19.0-rc3               5.19.0-rc3
                                        vanilla      mm-pcpspinirq-v5r16
Hmean     faults/sec-1   869275.7381 (   0.00%)   874597.5167 *   0.61%*
Hmean     faults/sec-3  2370266.6681 (   0.00%)  2379802.0362 *   0.40%*
Hmean     faults/sec-5  2701099.7019 (   0.00%)  2664889.7003 *  -1.34%*
Hmean     faults/sec-7  3517170.9157 (   0.00%)  3491122.8242 *  -0.74%*
Hmean     faults/sec-8  3965729.6187 (   0.00%)  3939727.0243 *  -0.66%*

There is a small hit in the number of faults per second but given that the
results are more stable, it's borderline noise.

Link: https://lkml.kernel.org/r/20220624125423.6126-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 
 mm/page_alloc.c        |  118 ++++++++++++++++++++++++++++++++-------
 2 files changed, 98 insertions(+), 21 deletions(-)

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
@@ -3101,15 +3115,22 @@ static int rmqueue_bulk(struct zone *zon
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
 
@@ -3122,16 +3143,17 @@ void drain_zone_pages(struct zone *zone,
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
@@ -3399,17 +3421,15 @@ static int nr_pcp_high(struct per_cpu_pa
 	return min(READ_ONCE(pcp->batch) << 2, high);
 }
 
-static void free_unref_page_commit(struct page *page, int migratetype,
+static void free_unref_page_commit(struct zone *zone, struct per_cpu_pages *pcp,
+				   struct page *page, int migratetype,
 				   unsigned int order)
 {
-	struct zone *zone = page_zone(page);
-	struct per_cpu_pages *pcp;
 	int high;
 	int pindex;
 	bool free_high;
 
 	__count_vm_event(PGFREE);
-	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pindex = order_to_pindex(migratetype, order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
@@ -3436,6 +3456,9 @@ static void free_unref_page_commit(struc
 void free_unref_page(struct page *page, unsigned int order)
 {
 	unsigned long flags;
+	unsigned long __maybe_unused UP_flags;
+	struct per_cpu_pages *pcp;
+	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
@@ -3459,7 +3482,16 @@ void free_unref_page(struct page *page,
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
-	free_unref_page_commit(page, migratetype, order);
+	zone = page_zone(page);
+	pcp_trylock_prepare(UP_flags);
+	pcp = this_cpu_ptr(zone->per_cpu_pageset);
+	if (spin_trylock(&pcp->lock)) {
+		free_unref_page_commit(zone, pcp, page, migratetype, order);
+		spin_unlock(&pcp->lock);
+	} else {
+		free_one_page(zone, page, pfn, order, migratetype, FPI_NONE);
+	}
+	pcp_trylock_finish(UP_flags);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
@@ -3469,6 +3501,8 @@ void free_unref_page(struct page *page,
 void free_unref_page_list(struct list_head *list)
 {
 	struct page *page, *next;
+	struct per_cpu_pages *pcp = NULL;
+	struct zone *locked_zone = NULL;
 	unsigned long flags;
 	int batch_count = 0;
 	int migratetype;
@@ -3495,6 +3529,17 @@ void free_unref_page_list(struct list_he
 
 	local_lock_irqsave(&pagesets.lock, flags);
 	list_for_each_entry_safe(page, next, list, lru) {
+		struct zone *zone = page_zone(page);
+
+		/* Different zone, different pcp lock. */
+		if (zone != locked_zone) {
+			if (pcp)
+				spin_unlock(&pcp->lock);
+			locked_zone = zone;
+			pcp = this_cpu_ptr(zone->per_cpu_pageset);
+			spin_lock(&pcp->lock);
+		}
+
 		/*
 		 * Non-isolated types over MIGRATE_PCPTYPES get added
 		 * to the MIGRATE_MOVABLE pcp list.
@@ -3504,18 +3549,24 @@ void free_unref_page_list(struct list_he
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(page);
-		free_unref_page_commit(page, migratetype, 0);
+		free_unref_page_commit(zone, pcp, page, migratetype, 0);
 
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
+
+	if (pcp)
+		spin_unlock(&pcp->lock);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
@@ -3729,18 +3780,31 @@ static struct page *rmqueue_pcplist(stru
 	struct list_head *list;
 	struct page *page;
 	unsigned long flags;
+	unsigned long __maybe_unused UP_flags;
 
 	local_lock_irqsave(&pagesets.lock, flags);
 
 	/*
+	 * spin_trylock may fail due to a parallel drain. In the future, the
+	 * trylock will also protect against IRQ reentrancy.
+	 */
+	pcp = this_cpu_ptr(zone->per_cpu_pageset);
+	pcp_trylock_prepare(UP_flags);
+	if (!spin_trylock(&pcp->lock)) {
+		pcp_trylock_finish(UP_flags);
+		return NULL;
+	}
+
+	/*
 	 * On allocation, reduce the number of pages that are batch freed.
 	 * See nr_pcp_free() where free_factor is increased for subsequent
 	 * frees.
 	 */
-	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pcp->free_factor >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	spin_unlock(&pcp->lock);
+	pcp_trylock_finish(UP_flags);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
@@ -3775,7 +3839,8 @@ struct page *rmqueue(struct zone *prefer
 				migratetype != MIGRATE_MOVABLE) {
 			page = rmqueue_pcplist(preferred_zone, zone, order,
 					gfp_flags, migratetype, alloc_flags);
-			goto out;
+			if (likely(page))
+				goto out;
 		}
 	}
 
@@ -5252,6 +5317,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 {
 	struct page *page;
 	unsigned long flags;
+	unsigned long __maybe_unused UP_flags;
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
@@ -5332,11 +5398,15 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	if (unlikely(!zone))
 		goto failed;
 
-	/* Attempt the batch allocation */
+	/* Is a parallel drain in progress? */
 	local_lock_irqsave(&pagesets.lock, flags);
+	pcp_trylock_prepare(UP_flags);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
-	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
+	if (!spin_trylock(&pcp->lock))
+		goto failed_irq;
 
+	/* Attempt the batch allocation */
+	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */
@@ -5349,8 +5419,10 @@ unsigned long __alloc_pages_bulk(gfp_t g
 								pcp, pcp_list);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
-			if (!nr_account)
+			if (!nr_account) {
+				spin_unlock(&pcp->lock);
 				goto failed_irq;
+			}
 			break;
 		}
 		nr_account++;
@@ -5363,6 +5435,8 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		nr_populated++;
 	}
 
+	spin_unlock(&pcp->lock);
+	pcp_trylock_finish(UP_flags);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
@@ -5372,6 +5446,7 @@ out:
 	return nr_populated;
 
 failed_irq:
+	pcp_trylock_finish(UP_flags);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 
 failed:
@@ -7017,6 +7092,7 @@ static void per_cpu_pages_init(struct pe
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
mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

