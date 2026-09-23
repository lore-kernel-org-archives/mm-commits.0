Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202EF3815CF
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 02:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790131238; cv=none; b=W9yXoOwtdnfYC8mDEzx599ij4y16d/Lm9v3zjjtDL6XKjcoZo5ZRzAbT5UGW6xiIaEkJxIRZCjWpjhwKAHrM8PfyJn+LdSGR65I8goU2hIeGbayVPn61IFoGMBYBLuPNO8Q0i1afiBJkBTwQ2Tgxj91b8bkkDJ9Dm5O9sKpDxHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790131238; c=relaxed/simple;
	bh=d/lxLdD97A2sJymzIA5GFMfATZdigGqKRqTYrF3jwcY=;
	h=Date:To:From:Subject:Message-Id; b=UwQn9D/+FX36drfaVCe5FeE2CFFFeLfj8S8vj3K7S49xX98KS/kkX8TOSdna0h13oo4l3O5Udtj/dW+OpaeNmC7CdF9ib9lcX2Qon3Vs1BtGplDqF75SsIBwPfcKjBLgq3OiCndbFilaMt51MC8oVVutn/KumApMVqgaGynewss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XJ+z0eyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XJ+z0eyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6651F00893;
	Wed, 23 Sep 2026 02:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790131232;
	bh=yS0exF2A9W2aPa4hKjWvQKApDd5u8jOhT6n0KyEY3XM=;
	h=Date:To:From:Subject;
	b=XJ+z0eyMfkjUDgdBcXfQPImUYYzzdx8HXbusGJcJbHgc5wobGkdQRWJHd7DRt/g51
	 YDVwklGUUGGt/mlEAig8Ag7MVVCqtm4PJbQG+tTpKyR0VgM+i76/MepBJ8CTfboGne
	 U8BdBbdQkC8qUQIgEizKz/Q/dhILcFtq8e2hbEuY=
Date: Tue, 22 Sep 2026 19:40:32 -0700
To: mm-commits@vger.kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch removed from -mm tree
Message-Id: <20260923024032.BC6651F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
Date: Fri, 11 Sep 2026 23:04:24 -0400

Extract per-node fallback-list construction into build_node_zonelist(). 
Build each selected node directly into the destination zonelist so no
intermediate node_order array or node count is needed.  Print the fallback
order as each node is added.

This lets us build new zonelists from candidate nodemasks instead of just
the default N_MEMORY node state list.

No functional change: build_zonelists() builds and prints the same
FALLBACK list over N_MEMORY with node_load updates as before.

Link: https://lore.kernel.org/20260912030424.2889731-3-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 mm/page_alloc.c |   63 ++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 40 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists
+++ a/mm/page_alloc.c
@@ -5858,31 +5858,6 @@ int find_next_best_node_in(int node, nod
 
 
 /*
- * Build zonelists ordered by node and zones within node.
- * This results in maximum locality--normal zone overflows into local
- * DMA zone, if any--but risks exhausting DMA zone.
- */
-static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
-		unsigned nr_nodes)
-{
-	struct zoneref *zonerefs;
-	int i;
-
-	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
-
-	for (i = 0; i < nr_nodes; i++) {
-		int nr_zones;
-
-		pg_data_t *node = NODE_DATA(node_order[i]);
-
-		nr_zones = build_zonerefs_node(node, zonerefs);
-		zonerefs += nr_zones;
-	}
-	zonerefs->zone = NULL;
-	zonerefs->zone_idx = 0;
-}
-
-/*
  * Build __GFP_THISNODE zonelists
  */
 static void build_thisnode_zonelists(pg_data_t *pgdat)
@@ -5897,20 +5872,24 @@ static void build_thisnode_zonelists(pg_
 	zonerefs->zone_idx = 0;
 }
 
-static void build_zonelists(pg_data_t *pgdat)
+/*
+ * Build one zonelist ordered by node and zones within node. This results in
+ * maximum locality--normal zone overflows into local DMA zone, if any--but
+ * risks exhausting DMA zone.
+ */
+static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
+				int zlidx)
 {
-	static int node_order[MAX_NUMNODES];
-	int node, nr_nodes = 0;
+	struct zoneref *zonerefs = pgdat->node_zonelists[zlidx]._zonerefs;
 	nodemask_t used_mask = NODE_MASK_NONE;
-	int local_node, prev_node;
+	int local_node = pgdat->node_id;
+	int prev_node = local_node;
+	int node;
 
-	/* NUMA-aware ordering of nodes */
-	local_node = pgdat->node_id;
-	prev_node = local_node;
+	pr_info("Fallback order for Node %d: ", local_node);
 
-	memset(node_order, 0, sizeof(node_order));
 	while ((node = find_next_best_node_in(local_node, &used_mask,
-					      &node_states[N_MEMORY])) >= 0) {
+					      candidates)) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
@@ -5920,18 +5899,22 @@ static void build_zonelists(pg_data_t *p
 		    node_distance(local_node, prev_node))
 			node_load[node] += 1;
 
-		node_order[nr_nodes++] = node;
+		zonerefs += build_zonerefs_node(NODE_DATA(node), zonerefs);
+		pr_cont("%d ", node);
 		prev_node = node;
 	}
 
-	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
-	build_thisnode_zonelists(pgdat);
-	pr_info("Fallback order for Node %d: ", local_node);
-	for (node = 0; node < nr_nodes; node++)
-		pr_cont("%d ", node_order[node]);
+	zonerefs->zone = NULL;
+	zonerefs->zone_idx = 0;
 	pr_cont("\n");
 }
 
+static void build_zonelists(pg_data_t *pgdat)
+{
+	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
+	build_thisnode_zonelists(pgdat);
+}
+
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 /*
  * Return node id of node used for "local" allocations.
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch
mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch
mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

