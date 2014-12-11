From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-more-focused-lru-and-pcplists-draining.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:46 -0800
Message-ID: <5489e8ee.rBfCW6TOz4Yxxw+x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbaLKS4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: more focused lru and pcplists draining
has been removed from the -mm tree.  Its filename was
     mm-compaction-more-focused-lru-and-pcplists-draining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: more focused lru and pcplists draining

The goal of memory compaction is to create high-order freepages through
page migration.  Page migration however puts pages on the per-cpu lru_add
cache, which is later flushed to per-cpu pcplists, and only after pcplists
are drained the pages can actually merge.  This can happen due to the
per-cpu caches becoming full through further freeing, or explicitly.

During direct compaction, it is useful to do the draining explicitly so
that pages merge as soon as possible and compaction can detect success
immediately and keep the latency impact at minimum.  However the current
implementation is far from ideal.  Draining is done only in
__alloc_pages_direct_compact(), after all zones were already compacted,
and the decisions to continue or stop compaction in individual zones was
done without the last batch of migrations being merged.  It is also
missing the draining of lru_add cache before the pcplists.

This patch moves the draining for direct compaction into compact_zone(). 
It adds the missing lru_cache draining and uses the newly introduced
single zone pcplists draining to reduce overhead and avoid impact on
unrelated zones.  Draining is only performed when it can actually lead to
merging of a page of desired order (passed by cc->order).  This means it
is only done when migration occurred in the previously scanned cc->order
aligned block(s) and the migration scanner is now pointing to the next
cc->order aligned block.

The patch has been tested with stress-highalloc benchmark from mmtests. 
Although overal allocation success rates of the benchmark were not
affected, the number of detected compaction successes has doubled.  This
suggests that allocations were previously successful due to implicit
merging caused by background activity, making a later allocation attempt
succeed immediately, but not attributing the success to compaction.  Since
stress-highalloc always tries to allocate almost the whole memory, it
cannot show the improvement in its reported success rate metric.  However
after this patch, compaction should detect success and terminate earlier,
reducing the direct compaction latencies in a real scenario.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 mm/page_alloc.c |    4 ----
 2 files changed, 42 insertions(+), 5 deletions(-)

diff -puN mm/compaction.c~mm-compaction-more-focused-lru-and-pcplists-draining mm/compaction.c
--- a/mm/compaction.c~mm-compaction-more-focused-lru-and-pcplists-draining
+++ a/mm/compaction.c
@@ -1158,6 +1158,7 @@ static int compact_zone(struct zone *zon
 	unsigned long end_pfn = zone_end_pfn(zone);
 	const int migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	const bool sync = cc->mode != MIGRATE_ASYNC;
+	unsigned long last_migrated_pfn = 0;
 
 	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
@@ -1203,6 +1204,7 @@ static int compact_zone(struct zone *zon
 	while ((ret = compact_finished(zone, cc, migratetype)) ==
 						COMPACT_CONTINUE) {
 		int err;
+		unsigned long isolate_start_pfn = cc->migrate_pfn;
 
 		switch (isolate_migratepages(zone, cc)) {
 		case ISOLATE_ABORT:
@@ -1211,7 +1213,12 @@ static int compact_zone(struct zone *zon
 			cc->nr_migratepages = 0;
 			goto out;
 		case ISOLATE_NONE:
-			continue;
+			/*
+			 * We haven't isolated and migrated anything, but
+			 * there might still be unflushed migrations from
+			 * previous cc->order aligned block.
+			 */
+			goto check_drain;
 		case ISOLATE_SUCCESS:
 			;
 		}
@@ -1236,6 +1243,40 @@ static int compact_zone(struct zone *zon
 				goto out;
 			}
 		}
+
+		/*
+		 * Record where we could have freed pages by migration and not
+		 * yet flushed them to buddy allocator. We use the pfn that
+		 * isolate_migratepages() started from in this loop iteration
+		 * - this is the lowest page that could have been isolated and
+		 * then freed by migration.
+		 */
+		if (!last_migrated_pfn)
+			last_migrated_pfn = isolate_start_pfn;
+
+check_drain:
+		/*
+		 * Has the migration scanner moved away from the previous
+		 * cc->order aligned block where we migrated from? If yes,
+		 * flush the pages that were freed, so that they can merge and
+		 * compact_finished() can detect immediately if allocation
+		 * would succeed.
+		 */
+		if (cc->order > 0 && last_migrated_pfn) {
+			int cpu;
+			unsigned long current_block_start =
+				cc->migrate_pfn & ~((1UL << cc->order) - 1);
+
+			if (last_migrated_pfn < current_block_start) {
+				cpu = get_cpu();
+				lru_add_drain_cpu(cpu);
+				drain_local_pages(zone);
+				put_cpu();
+				/* No more flushing until we migrate again */
+				last_migrated_pfn = 0;
+			}
+		}
+
 	}
 
 out:
diff -puN mm/page_alloc.c~mm-compaction-more-focused-lru-and-pcplists-draining mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-more-focused-lru-and-pcplists-draining
+++ a/mm/page_alloc.c
@@ -2359,10 +2359,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	 */
 	count_vm_event(COMPACTSTALL);
 
-	/* Page migration frees to the PCP lists but we want merging */
-	drain_pages(get_cpu());
-	put_cpu();
