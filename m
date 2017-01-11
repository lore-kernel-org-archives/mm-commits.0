From: akpm@linux-foundation.org
Subject: [merged] mm-fix-remote-numa-hits-statistics.patch removed from
 -mm tree
Date: Wed, 11 Jan 2017 14:28:00 -0800
Message-ID: <5876b170.g3a+GEa82h0yCqgZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933537AbdAKW2e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:28:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hejianet@gmail.com, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix remote numa hits statistics
has been removed from the -mm tree.  Its filename was
     mm-fix-remote-numa-hits-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: fix remote numa hits statistics

Jia He has noticed that b9f00e147f27 ("mm, page_alloc: reduce branches in
zone_statistics") has an unintentional side effect that remote node
allocation requests are accounted as NUMA_MISS rathat than NUMA_HIT and
NUMA_OTHER if such a request doesn't use __GFP_OTHER_NODE.  There are many
of these potentially because the flag is used very rarely while we have
many users of __alloc_pages_node.

Fix this by simply ignoring __GFP_OTHER_NODE (it can be removed in a
follow up patch) and treat all allocations that were satisfied from the
preferred zone's node as NUMA_HITS because this is the same node we
requested the allocation from in most cases.  If this is not the local
node then we just account it as NUMA_OTHER rather than NUMA_LOCAL.

One downsize would be that an allocation request for a node which is
outside of the mempolicy nodemask would be reported as a hit which is a
bit weird but that was the case before b9f00e147f27 already.

Fixes: b9f00e147f27 ("mm, page_alloc: reduce branches in zone_statistics")
Link: http://lkml.kernel.org/r/20170102153057.9451-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Jia He <hejianet@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz> # with cbmc[1] superpowers
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-remote-numa-hits-statistics mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-remote-numa-hits-statistics
+++ a/mm/page_alloc.c
@@ -2583,30 +2583,23 @@ int __isolate_free_page(struct page *pag
  * Update NUMA hit/miss statistics
  *
  * Must be called with interrupts disabled.
- *
- * When __GFP_OTHER_NODE is set assume the node of the preferred
- * zone is the local node. This is useful for daemons who allocate
- * memory on behalf of other processes.
  */
 static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 								gfp_t flags)
 {
 #ifdef CONFIG_NUMA
-	int local_nid = numa_node_id();
 	enum zone_stat_item local_stat = NUMA_LOCAL;
 
-	if (unlikely(flags & __GFP_OTHER_NODE)) {
+	if (z->node != numa_node_id())
 		local_stat = NUMA_OTHER;
-		local_nid = preferred_zone->node;
-	}
 
-	if (z->node == local_nid) {
+	if (z->node == preferred_zone->node)
 		__inc_zone_state(z, NUMA_HIT);
-		__inc_zone_state(z, local_stat);
-	} else {
+	else {
 		__inc_zone_state(z, NUMA_MISS);
 		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
 	}
+	__inc_zone_state(z, local_stat);
 #endif
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch

