Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F37C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6594961D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhF2CoS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231847AbhF2CoR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B73B611AE;
        Tue, 29 Jun 2021 02:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934511;
        bh=Fo7gudiLc3tP8Rt0EUd/k4qb42Pht7RbF7T0GMlpJVk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eN7nD6RwvKoXNQs0HyLER+cD5MsmG4oF/HWp7wE8lajYdzHY/Ogf/GCi3LR7mBROU
         dHJNcF7OADbG5ABII07zaY7qHb0f/OjtnQ6U9WwXs2I/7X2n8wP65uHq4WmzxPUmO9
         skeSOxADKTkrOzDHvAwgdmUhiXeD+YoUagX4drDA=
Date:   Mon, 28 Jun 2021 19:41:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, chuck.lever@oracle.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 164/192] mm/page_alloc: batch the accounting
 updates in the bulk allocator
Message-ID: <20210629024150.XacPIiG4E%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: batch the accounting updates in the bulk allocator

Now that the zone_statistics are simple counters that do not require
special protection, the bulk allocator accounting updates can be batch
updated without adding too much complexity with protected RMW updates or
using xchg.

Link: https://lkml.kernel.org/r/20210512095458.30632-6-mgorman@techsingularity.net
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

 include/linux/vmstat.h |    8 ++++++++
 mm/page_alloc.c        |   30 +++++++++++++-----------------
 2 files changed, 21 insertions(+), 17 deletions(-)

--- a/include/linux/vmstat.h~mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator
+++ a/include/linux/vmstat.h
@@ -247,6 +247,14 @@ __count_numa_event(struct zone *zone, en
 	raw_cpu_inc(pzstats->vm_numa_event[item]);
 }
 
+static inline void
+__count_numa_events(struct zone *zone, enum numa_stat_item item, long delta)
+{
+	struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
+
+	raw_cpu_add(pzstats->vm_numa_event[item], delta);
+}
+
 extern unsigned long sum_zone_node_page_state(int node,
 					      enum zone_stat_item item);
 extern unsigned long sum_zone_numa_event_state(int node, enum numa_stat_item item);
--- a/mm/page_alloc.c~mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator
+++ a/mm/page_alloc.c
@@ -3467,7 +3467,8 @@ void __putback_isolated_page(struct page
  *
  * Must be called with interrupts disabled.
  */
-static inline void zone_statistics(struct zone *preferred_zone, struct zone *z)
+static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
+				   long nr_account)
 {
 #ifdef CONFIG_NUMA
 	enum numa_stat_item local_stat = NUMA_LOCAL;
@@ -3480,12 +3481,12 @@ static inline void zone_statistics(struc
 		local_stat = NUMA_OTHER;
 
 	if (zone_to_nid(z) == zone_to_nid(preferred_zone))
-		__count_numa_event(z, NUMA_HIT);
+		__count_numa_events(z, NUMA_HIT, nr_account);
 	else {
-		__count_numa_event(z, NUMA_MISS);
-		__count_numa_event(preferred_zone, NUMA_FOREIGN);
+		__count_numa_events(z, NUMA_MISS, nr_account);
+		__count_numa_events(preferred_zone, NUMA_FOREIGN, nr_account);
 	}
-	__count_numa_event(z, local_stat);
+	__count_numa_events(z, local_stat, nr_account);
 #endif
 }
 
@@ -3531,7 +3532,7 @@ static struct page *rmqueue_pcplist(stru
 	page = __rmqueue_pcplist(zone,  migratetype, alloc_flags, pcp, list);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
-		zone_statistics(preferred_zone, zone);
+		zone_statistics(preferred_zone, zone, 1);
 	}
 	local_unlock_irqrestore(&pagesets.lock, flags);
 	return page;
@@ -3592,7 +3593,7 @@ struct page *rmqueue(struct zone *prefer
 				  get_pcppage_migratetype(page));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
-	zone_statistics(preferred_zone, zone);
+	zone_statistics(preferred_zone, zone, 1);
 	local_irq_restore(flags);
 
 out:
@@ -5077,7 +5078,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	int nr_populated = 0;
+	int nr_populated = 0, nr_account = 0;
 
 	if (unlikely(nr_pages <= 0))
 		return 0;
@@ -5154,15 +5155,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 				goto failed_irq;
 			break;
 		}
-
-		/*
-		 * Ideally this would be batched but the best way to do
-		 * that cheaply is to first convert zone_statistics to
-		 * be inaccurate per-cpu counter like vm_events to avoid
-		 * a RMW cycle then do the accounting with IRQs enabled.
-		 */
-		__count_zid_vm_events(PGALLOC, zone_idx(zone), 1);
-		zone_statistics(ac.preferred_zoneref->zone, zone);
+		nr_account++;
 
 		prep_new_page(page, 0, gfp, 0);
 		if (page_list)
@@ -5172,6 +5165,9 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		nr_populated++;
 	}
 
+	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
+	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
+
 	local_unlock_irqrestore(&pagesets.lock, flags);
 
 	return nr_populated;
_
