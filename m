From: akpm@linux-foundation.org
Subject: [patch 068/123] mm: workingset: update shadow limit to reflect
 bigger active list
Date: Mon, 12 Dec 2016 16:43:58 -0800
Message-ID: <584f444e.W00xQ4umidc486Q0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbcLMAn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, riel@redhat.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: update shadow limit to reflect bigger active list

Since 59dc76b0d4df ("mm: vmscan: reduce size of inactive file list") the
size of the active file list is no longer limited to half of memory. 
Increase the shadow node limit accordingly to avoid throwing out shadow
entries that might still result in eligible refaults.

The exact size of the active list now depends on the overall size of the
page cache, but converges toward taking up most of the space:

In mm/vmscan.c::inactive_list_is_low(),

 * total     target    max
 * memory    ratio     inactive
 * -------------------------------------
 *   10MB       1         5MB
 *  100MB       1        50MB
 *    1GB       3       250MB
 *   10GB      10       0.9GB
 *  100GB      31         3GB
 *    1TB     101        10GB
 *   10TB     320        32GB

It would be possible to apply the same precise ratios when determining the
limit for radix tree nodes containing shadow entries, but since it is
merely an approximation of the oldest refault distances in the wild and
the code also makes assumptions about the node population density, keep it
simple and always target the full cache size.

While at it, clarify the comment and the formula for memory footprint.

Link: http://lkml.kernel.org/r/20161117214701.29000-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN mm/workingset.c~mm-workingset-update-shadow-limit-to-reflect-bigger-active-list mm/workingset.c
--- a/mm/workingset.c~mm-workingset-update-shadow-limit-to-reflect-bigger-active-list
+++ a/mm/workingset.c
@@ -369,40 +369,46 @@ static unsigned long count_shadow_nodes(
 {
 	unsigned long max_nodes;
 	unsigned long nodes;
-	unsigned long pages;
+	unsigned long cache;
 
 	/* list_lru lock nests inside IRQ-safe mapping->tree_lock */
 	local_irq_disable();
 	nodes = list_lru_shrink_count(&shadow_nodes, sc);
 	local_irq_enable();
 
-	if (sc->memcg) {
-		pages = mem_cgroup_node_nr_lru_pages(sc->memcg, sc->nid,
-						     LRU_ALL_FILE);
-	} else {
-		pages = node_page_state(NODE_DATA(sc->nid), NR_ACTIVE_FILE) +
-			node_page_state(NODE_DATA(sc->nid), NR_INACTIVE_FILE);
-	}
-
 	/*
-	 * Active cache pages are limited to 50% of memory, and shadow
-	 * entries that represent a refault distance bigger than that
-	 * do not have any effect.  Limit the number of shadow nodes
-	 * such that shadow entries do not exceed the number of active
-	 * cache pages, assuming a worst-case node population density
-	 * of 1/8th on average.
+	 * Approximate a reasonable limit for the radix tree nodes
+	 * containing shadow entries. We don't need to keep more
+	 * shadow entries than possible pages on the active list,
+	 * since refault distances bigger than that are dismissed.
+	 *
+	 * The size of the active list converges toward 100% of
+	 * overall page cache as memory grows, with only a tiny
+	 * inactive list. Assume the total cache size for that.
+	 *
+	 * Nodes might be sparsely populated, with only one shadow
+	 * entry in the extreme case. Obviously, we cannot keep one
+	 * node for every eligible shadow entry, so compromise on a
+	 * worst-case density of 1/8th. Below that, not all eligible
+	 * refaults can be detected anymore.
 	 *
 	 * On 64-bit with 7 radix_tree_nodes per page and 64 slots
 	 * each, this will reclaim shadow entries when they consume
-	 * ~2% of available memory:
+	 * ~1.8% of available memory:
 	 *
-	 * PAGE_SIZE / radix_tree_nodes / node_entries / PAGE_SIZE
+	 * PAGE_SIZE / radix_tree_nodes / node_entries * 8 / PAGE_SIZE
 	 */
-	max_nodes = pages >> (1 + RADIX_TREE_MAP_SHIFT - 3);
+	if (sc->memcg) {
+		cache = mem_cgroup_node_nr_lru_pages(sc->memcg, sc->nid,
+						     LRU_ALL_FILE);
+	} else {
+		cache = node_page_state(NODE_DATA(sc->nid), NR_ACTIVE_FILE) +
+			node_page_state(NODE_DATA(sc->nid), NR_INACTIVE_FILE);
+	}
+	max_nodes = cache >> (RADIX_TREE_MAP_SHIFT - 3);
 
 	if (nodes <= max_nodes)
 		return 0;
