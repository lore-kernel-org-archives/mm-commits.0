Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849A7C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A47561057
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhGFTRL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231866AbhGFTRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FDF160FDB;
        Tue,  6 Jul 2021 19:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598871;
        bh=ssqQeWIW/UTjxtvbJdW1mTHCDLSPI1z066U7+JQqjW4=;
        h=Date:From:To:Subject:From;
        b=mW3nON2Q0QCNx5fcsLEpe8UZwRvRz+k4QDrrz2mKK7TWOqtHt7fjYPpJxXuwN2Ox7
         nDUNfc7yWKlobshJB7E6QXIzsbslxDb3Xh8mOw9GJySYnmNqCQzCMDmcYijvJfE2GU
         YlIwjp2RjSjQ+HI/qtJtaf0yqkfvuxmriUjoMjio=
Date:   Tue, 06 Jul 2021 12:14:31 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, chuck.lever@oracle.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch removed
 from -mm tree
Message-ID: <20210706191431.TEskyEiRx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: convert per-cpu list protection to local_lock
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding style fixes]
[mgorman@techsingularity.net: work around a pahole limitation with zero-sized struct pagesets]
  Link: https://lkml.kernel.org/r/20210526080741.GW30378@techsingularity.net
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
 lib/Kconfig.debug      |    3 +
 mm/page_alloc.c        |   61 +++++++++++++++++++++++++++++----------
 3 files changed, 51 insertions(+), 15 deletions(-)

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
--- a/lib/Kconfig.debug~mm-page_alloc-convert-per-cpu-list-protection-to-local_lock
+++ a/lib/Kconfig.debug
@@ -313,6 +313,9 @@ config DEBUG_INFO_BTF
 config PAHOLE_HAS_SPLIT_BTF
 	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
 
+config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
+	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "122")
+
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
 	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
--- a/mm/page_alloc.c~mm-page_alloc-convert-per-cpu-list-protection-to-local_lock
+++ a/mm/page_alloc.c
@@ -122,6 +122,24 @@ typedef int __bitwise fpi_t;
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_FRACTION	(8)
 
+struct pagesets {
+	local_lock_t lock;
+#if defined(CONFIG_DEBUG_INFO_BTF) &&				\
+	!defined(CONFIG_DEBUG_LOCK_ALLOC) &&			\
+	!defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
+	/*
+	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
+	 * variables and produces invalid BTF. Ensure that
+	 * sizeof(struct pagesets) != 0 for older versions of pahole.
+	 */
+	char __pahole_hack;
+	#warning "pahole too old to support zero-sized struct pagesets"
+#endif
+};
+static DEFINE_PER_CPU(struct pagesets, pagesets) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -1453,6 +1471,10 @@ static void free_pcppages_bulk(struct zo
 		} while (--count && --batch_free && !list_empty(list));
 	}
 
+	/*
+	 * local_lock_irq held so equivalent to spin_lock_irqsave for
+	 * both PREEMPT_RT and non-PREEMPT_RT configurations.
+	 */
 	spin_lock(&zone->lock);
 	isolated_pageblocks = has_isolate_pageblock(zone);
 
@@ -1573,6 +1595,11 @@ static void __free_pages_ok(struct page
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
@@ -2955,6 +2982,10 @@ static int rmqueue_bulk(struct zone *zon
 {
 	int i, allocated = 0;
 
+	/*
+	 * local_lock_irq held so equivalent to spin_lock_irqsave for
+	 * both PREEMPT_RT and non-PREEMPT_RT configurations.
+	 */
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype,
@@ -3007,12 +3038,12 @@ void drain_zone_pages(struct zone *zone,
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
 
@@ -3028,13 +3059,13 @@ static void drain_pages_zone(unsigned in
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
@@ -3297,9 +3328,9 @@ void free_unref_page(struct page *page)
 	if (!free_unref_page_prepare(page, pfn))
 		return;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	free_unref_page_commit(page, pfn);
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
 /*
@@ -3319,7 +3350,7 @@ void free_unref_page_list(struct list_he
 		set_page_private(page, pfn);
 	}
 
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	list_for_each_entry_safe(page, next, list, lru) {
 		unsigned long pfn = page_private(page);
 
@@ -3332,12 +3363,12 @@ void free_unref_page_list(struct list_he
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
@@ -3494,7 +3525,7 @@ static struct page *rmqueue_pcplist(stru
 	struct page *page;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	list = &pcp->lists[migratetype];
 	page = __rmqueue_pcplist(zone,  migratetype, alloc_flags, pcp, list);
@@ -3502,7 +3533,7 @@ static struct page *rmqueue_pcplist(stru
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
 		zone_statistics(preferred_zone, zone);
 	}
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 	return page;
 }
 
@@ -5103,7 +5134,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		goto failed;
 
 	/* Attempt the batch allocation */
-	local_irq_save(flags);
+	local_lock_irqsave(&pagesets.lock, flags);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pcp_list = &pcp->lists[ac.migratetype];
 
@@ -5141,12 +5172,12 @@ unsigned long __alloc_pages_bulk(gfp_t g
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


