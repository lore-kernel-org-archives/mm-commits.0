Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E32FC43460
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CC0B61406
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243368AbhEMAbE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbhEMAae (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C41761396;
        Thu, 13 May 2021 00:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620865765;
        bh=C3gLhHkLJHplViCdnE7W4UMlciqfN50poCbkkUF067A=;
        h=Date:From:To:Subject:From;
        b=ahRr7aUEy5X893Wtio1+qcF62tQCCF89IAnxoHb419GKOKHa39ARjBn84CKMnIBKy
         8JRyxhJE4n7H8k0OMOr2TuerdBWmoPjGGGCkrZe2hkvGPM1ArfmpqeFU3v6+2dVszl
         w1h89ZNaqtJVWheAveD375WF5cmltLZJJ1Q4A+N4=
Date:   Wed, 12 May 2021 17:29:24 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, chuck.lever@oracle.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch added to
 -mm tree
Message-ID: <20210513002924.y0-2ya-tb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: convert per-cpu list protection to local_lock
has been added to the -mm tree.  Its filename is
     mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: convert per-cpu list protection to local_lock

There is a lack of clarity of what exactly
local_irq_save/local_irq_restore protects in page_alloc.c .  It conflates
the protection of per-cpu page allocation structures with per-cpu vmstat
deltas.

This patch protects the PCP structure using local_lock which for most
configurations is identical to IRQ enabling/disabling.  The scope of the
lock is still wider than it should be but this is decreased later.

It is possible for the local_lock to be embedded safely within struct
per_cpu_pages but it adds complexity to free_unref_page_list.

[lkp@intel.com: Make pagesets static]
Link: https://lkml.kernel.org/r/20210512095458.30632-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +
 mm/page_alloc.c        |   50 +++++++++++++++++++++++++++------------
 2 files changed, 37 insertions(+), 15 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-convert-per-cpu-list-protection-to-local_lock
+++ a/include/linux/mmzone.h
@@ -20,6 +20,7 @@
 #include <linux/atomic.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
+#include <linux/local_lock.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -337,6 +338,7 @@ enum zone_watermarks {
 #define high_wmark_pages(z) (z->_watermark[WMARK_HIGH] + z->watermark_boost)
 #define wmark_pages(z, i) (z->_watermark[i] + z->watermark_boost)
 
+/* Fields and list protected by pagesets local_lock in page_alloc.c */
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
--- a/mm/page_alloc.c~mm-page_alloc-convert-per-cpu-list-protection-to-local_lock
+++ a/mm/page_alloc.c
@@ -122,6 +122,13 @@ typedef int __bitwise fpi_t;
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_FRACTION	(8)
 
+struct pagesets {
+	local_lock_t lock;
+};
+static DEFINE_PER_CPU(struct pagesets, pagesets) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -1453,6 +1460,10 @@ static void free_pcppages_bulk(struct zo
 		} while (--count && --batch_free && !list_empty(list));
 	}
 
+	/*
+	 * local_lock_irq held so equivalent to spin_lock_irqsave for
+	 * both PREEMPT_RT and non-PREEMPT_RT configurations.
+	 */
 	spin_lock(&zone->lock);
 	isolated_pageblocks = has_isolate_pageblock(zone);
 
@@ -1573,6 +1584,11 @@ static void __free_pages_ok(struct page
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
+
+	/*
+	 * TODO FIX: Disable IRQs before acquiring IRQ-safe zone->lock
+	 * and protect vmstat updates.
+	 */
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
 	free_one_page(page_zone(page), page, pfn, order, migratetype,
@@ -2955,6 +2971,10 @@ static int rmqueue_bulk(struct zone *zon
 {
 	int i, allocated = 0;
 
+	/*
+	 * local_lock_irq held so equivalent to spin_lock_irqsave for
+	 * both PREEMPT_RT and non-PREEMPT_RT configurations.
+	 */
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype,
@@ -3007,12 +3027,12 @@ void drain_zone_pages(struct zone *zone,
 	unsigned long flags;
 	int to_drain, batch;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0)
 		free_pcppages_bulk(zone, to_drain, pcp);
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 #endif
 
@@ -3028,13 +3048,13 @@ static void drain_pages_zone(unsigned in
 	unsigned long flags;
 	struct per_cpu_pages *pcp;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	if (pcp->count)
 		free_pcppages_bulk(zone, pcp->count, pcp);
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
 /*
@@ -3297,9 +3317,9 @@ void free_unref_page(struct page *page)
 	if (!free_unref_page_prepare(page, pfn))
 		return;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	free_unref_page_commit(page, pfn);
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
 /*
@@ -3319,7 +3339,7 @@ void free_unref_page_list(struct list_he
 		set_page_private(page, pfn);
 	}
 
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	list_for_each_entry_safe(page, next, list, lru) {
 		unsigned long pfn = page_private(page);
 
@@ -3332,12 +3352,12 @@ void free_unref_page_list(struct list_he
 		 * a large list of pages to free.
 		 */
 		if (++batch_count == SWAP_CLUSTER_MAX) {
-			local_irq_restore(flags);
+			local_unlock_irqrestore(&pagesets.lock, flags);
 			batch_count = 0;
-			local_irq_save(flags);
+			local_lock_irqsave(&pagesets.lock, flags);
 		}
 	}
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
 /*
@@ -3494,7 +3514,7 @@ static struct page *rmqueue_pcplist(stru
 	struct page *page;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	list = &pcp->lists[migratetype];
 	page = __rmqueue_pcplist(zone,  migratetype, alloc_flags, pcp, list);
@@ -3502,7 +3522,7 @@ static struct page *rmqueue_pcplist(stru
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
 		zone_statistics(preferred_zone, zone);
 	}
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 	return page;
 }
 
@@ -5096,7 +5116,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		goto failed;
 
 	/* Attempt the batch allocation */
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pcp_list = &pcp->lists[ac.migratetype];
 
@@ -5134,12 +5154,12 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		nr_populated++;
 	}
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 
 	return nr_populated;
 
 failed_irq:
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 
 failed:
 	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch

