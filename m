Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3530C00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 17:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239889AbiHXRTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 13:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbiHXRTF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 13:19:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAE57C309
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 10:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D41F2B82389
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61626C433D7;
        Wed, 24 Aug 2022 17:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661361541;
        bh=ztmfqt9yeLiEkRQl1BmffbG1y1M6aa/3C8749lSJ0M0=;
        h=Date:To:From:Subject:From;
        b=D65URcB0s50XL+0Z1lfVWA6qLUQHVOAKS56Dd0INyz6C/SbNaU5qSwOF7rXMaSgeL
         vMtLR/gUj/zWl53BLdQnxpND7Mo6K33GXs1dXkQRl1qpRr0+hvBAkmxEJJ4qzsiQuI
         zWeodzDgATzf9D7/Vu9ljiX1BcASvAg3T0P1+2UM=
Date:   Wed, 24 Aug 2022 10:19:00 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        nsaenzju@redhat.com, mtosatti@redhat.com, m.szyprowski@samsung.com,
        mhocko@kernel.org, hughd@google.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch added to mm-unstable branch
Message-Id: <20220824171901.61626C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: leave IRQs enabled for per-cpu page allocations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch

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
Subject: mm/page_alloc: leave IRQs enabled for per-cpu page allocations
Date: Wed, 24 Aug 2022 15:18:02 +0100

The pcp_spin_lock_irqsave protecting the PCP lists is IRQ-safe as a task
allocating from the PCP must not re-enter the allocator from IRQ context. 
In each instance where IRQ-reentrancy is possible, the lock is acquired
using pcp_spin_trylock_irqsave() even though IRQs are disabled and
re-entrancy is impossible.

Demoting the lock to pcp_spin_lock avoids an IRQ disable/enable in the
common case at the cost of some IRQ allocations taking a slower path.  If
the PCP lists need to be refilled, the zone lock still needs to disable
IRQs but that will only happen on PCP refill and drain.  If an IRQ is
raised when a PCP allocation is in progress, the trylock will fail and
fallback to using the buddy lists directly.  Note that this may not be a
universal win if an interrupt-intensive workload also allocates heavily
from interrupt context and contends heavily on the zone->lock as a result.

Link: https://lkml.kernel.org/r/20220824141802.23395-1-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   93 +++++++++++++---------------------------------
 1 file changed, 28 insertions(+), 65 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations
+++ a/mm/page_alloc.c
@@ -169,21 +169,12 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 	_ret;								\
 })
 
-#define pcpu_spin_lock_irqsave(type, member, ptr, flags)		\
+#define pcpu_spin_trylock(type, member, ptr)				\
 ({									\
 	type *_ret;							\
 	pcpu_task_pin();						\
 	_ret = this_cpu_ptr(ptr);					\
-	spin_lock_irqsave(&_ret->member, flags);			\
-	_ret;								\
-})
-
-#define pcpu_spin_trylock_irqsave(type, member, ptr, flags)		\
-({									\
-	type *_ret;							\
-	pcpu_task_pin();						\
-	_ret = this_cpu_ptr(ptr);					\
-	if (!spin_trylock_irqsave(&_ret->member, flags)) {		\
+	if (!spin_trylock(&_ret->member)) {				\
 		pcpu_task_unpin();					\
 		_ret = NULL;						\
 	}								\
@@ -196,27 +187,16 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 	pcpu_task_unpin();						\
 })
 
-#define pcpu_spin_unlock_irqrestore(member, ptr, flags)			\
-({									\
-	spin_unlock_irqrestore(&ptr->member, flags);			\
-	pcpu_task_unpin();						\
-})
-
 /* struct per_cpu_pages specific helpers. */
 #define pcp_spin_lock(ptr)						\
 	pcpu_spin_lock(struct per_cpu_pages, lock, ptr)
 
-#define pcp_spin_lock_irqsave(ptr, flags)				\
-	pcpu_spin_lock_irqsave(struct per_cpu_pages, lock, ptr, flags)
-
-#define pcp_spin_trylock_irqsave(ptr, flags)				\
-	pcpu_spin_trylock_irqsave(struct per_cpu_pages, lock, ptr, flags)
+#define pcp_spin_trylock(ptr)						\
+	pcpu_spin_trylock(struct per_cpu_pages, lock, ptr)
 
 #define pcp_spin_unlock(ptr)						\
 	pcpu_spin_unlock(lock, ptr)
 
-#define pcp_spin_unlock_irqrestore(ptr, flags)				\
-	pcpu_spin_unlock_irqrestore(lock, ptr, flags)
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -1536,6 +1516,7 @@ static void free_pcppages_bulk(struct zo
 					struct per_cpu_pages *pcp,
 					int pindex)
 {
+	unsigned long flags;
 	int min_pindex = 0;
 	int max_pindex = NR_PCP_LISTS - 1;
 	unsigned int order;
@@ -1551,8 +1532,7 @@ static void free_pcppages_bulk(struct zo
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	/* Caller must hold IRQ-safe pcp->lock so IRQs are disabled. */
-	spin_lock(&zone->lock);
+	spin_lock_irqsave(&zone->lock, flags);
 	isolated_pageblocks = has_isolate_pageblock(zone);
 
 	while (count > 0) {
@@ -1601,7 +1581,7 @@ static void free_pcppages_bulk(struct zo
 		} while (count > 0 && !list_empty(list));
 	}
 
-	spin_unlock(&zone->lock);
+	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static void free_one_page(struct zone *zone,
@@ -3118,10 +3098,10 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, unsigned int alloc_flags)
 {
+	unsigned long flags;
 	int i, allocated = 0;
 
-	/* Caller must hold IRQ-safe pcp->lock so IRQs are disabled. */
-	spin_lock(&zone->lock);
+	spin_lock_irqsave(&zone->lock, flags);
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype,
 								alloc_flags);
@@ -3155,7 +3135,7 @@ static int rmqueue_bulk(struct zone *zon
 	 * pages added to the pcp list.
 	 */
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
-	spin_unlock(&zone->lock);
+	spin_unlock_irqrestore(&zone->lock, flags);
 	return allocated;
 }
 
@@ -3172,16 +3152,9 @@ void drain_zone_pages(struct zone *zone,
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
-		unsigned long flags;
-
-		/*
-		 * free_pcppages_bulk expects IRQs disabled for zone->lock
-		 * so even though pcp->lock is not intended to be IRQ-safe,
-		 * it's needed in this context.
-		 */
-		spin_lock_irqsave(&pcp->lock, flags);
+		spin_lock(&pcp->lock);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		spin_unlock_irqrestore(&pcp->lock, flags);
+		spin_unlock(&pcp->lock);
 	}
 }
 #endif
@@ -3195,12 +3168,9 @@ static void drain_pages_zone(unsigned in
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	if (pcp->count) {
-		unsigned long flags;
-
-		/* See drain_zone_pages on why this is disabling IRQs */
-		spin_lock_irqsave(&pcp->lock, flags);
+		spin_lock(&pcp->lock);
 		free_pcppages_bulk(zone, pcp->count, pcp, 0);
-		spin_unlock_irqrestore(&pcp->lock, flags);
+		spin_unlock(&pcp->lock);
 	}
 }
 
@@ -3466,7 +3436,6 @@ static void free_unref_page_commit(struc
  */
 void free_unref_page(struct page *page, unsigned int order)
 {
-	unsigned long flags;
 	unsigned long __maybe_unused UP_flags;
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
@@ -3494,10 +3463,10 @@ void free_unref_page(struct page *page,
 
 	zone = page_zone(page);
 	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock_irqsave(zone->per_cpu_pageset, flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
 		free_unref_page_commit(zone, pcp, page, migratetype, order);
-		pcp_spin_unlock_irqrestore(pcp, flags);
+		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, migratetype, FPI_NONE);
 	}
@@ -3512,7 +3481,6 @@ void free_unref_page_list(struct list_he
 	struct page *page, *next;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
-	unsigned long flags;
 	int batch_count = 0;
 	int migratetype;
 
@@ -3542,10 +3510,10 @@ void free_unref_page_list(struct list_he
 		/* Different zone, different pcp lock. */
 		if (zone != locked_zone) {
 			if (pcp)
-				pcp_spin_unlock_irqrestore(pcp, flags);
+				pcp_spin_unlock(pcp);
 
 			locked_zone = zone;
-			pcp = pcp_spin_lock_irqsave(locked_zone->per_cpu_pageset, flags);
+			pcp = pcp_spin_lock(locked_zone->per_cpu_pageset);
 		}
 
 		/*
@@ -3564,14 +3532,14 @@ void free_unref_page_list(struct list_he
 		 * a large list of pages to free.
 		 */
 		if (++batch_count == SWAP_CLUSTER_MAX) {
-			pcp_spin_unlock_irqrestore(pcp, flags);
+			pcp_spin_unlock(pcp);
 			batch_count = 0;
-			pcp = pcp_spin_lock_irqsave(locked_zone->per_cpu_pageset, flags);
+			pcp = pcp_spin_lock(locked_zone->per_cpu_pageset);
 		}
 	}
 
 	if (pcp)
-		pcp_spin_unlock_irqrestore(pcp, flags);
+		pcp_spin_unlock(pcp);
 }
 
 /*
@@ -3783,15 +3751,11 @@ static struct page *rmqueue_pcplist(stru
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
 	struct page *page;
-	unsigned long flags;
 	unsigned long __maybe_unused UP_flags;
 
-	/*
-	 * spin_trylock may fail due to a parallel drain. In the future, the
-	 * trylock will also protect against IRQ reentrancy.
-	 */
+	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
 	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock_irqsave(zone->per_cpu_pageset, flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp) {
 		pcp_trylock_finish(UP_flags);
 		return NULL;
@@ -3805,7 +3769,7 @@ static struct page *rmqueue_pcplist(stru
 	pcp->free_factor >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
-	pcp_spin_unlock_irqrestore(pcp, flags);
+	pcp_spin_unlock(pcp);
 	pcp_trylock_finish(UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
@@ -5321,7 +5285,6 @@ unsigned long __alloc_pages_bulk(gfp_t g
 			struct page **page_array)
 {
 	struct page *page;
-	unsigned long flags;
 	unsigned long __maybe_unused UP_flags;
 	struct zone *zone;
 	struct zoneref *z;
@@ -5403,9 +5366,9 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	if (unlikely(!zone))
 		goto failed;
 
-	/* Is a parallel drain in progress? */
+	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
 	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock_irqsave(zone->per_cpu_pageset, flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
 		goto failed_irq;
 
@@ -5424,7 +5387,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
-				pcp_spin_unlock_irqrestore(pcp, flags);
+				pcp_spin_unlock(pcp);
 				goto failed_irq;
 			}
 			break;
@@ -5439,7 +5402,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		nr_populated++;
 	}
 
-	pcp_spin_unlock_irqrestore(pcp, flags);
+	pcp_spin_unlock(pcp);
 	pcp_trylock_finish(UP_flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch

