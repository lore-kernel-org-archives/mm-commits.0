Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B99413221
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525565; cv=none; b=SHXxqbXYiw/zE2epxs5jLrElk+gDM9uZBrCT48rXFewJUovodEJr7eFpmnXqEKCD6IoUVGdc+TOO8s+PJpMfGDs/7jZ6K1lheCQDNrdWQn2g/BKaVTYXDoRwPVGEejN5Kwpk///Yz5XClFCY6wjdMi8j8f94zRkDcZxJ9XaL8qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525565; c=relaxed/simple;
	bh=LJ8HcKKKKU7anqlIMph7TQ+uRy0pXsQrhjZtBeh0jWM=;
	h=Date:To:From:Subject:Message-Id; b=tnC5wreYC5r4oeWLyTddaqd3+DS6KrHMT8hAskpBMkkXmdcHmcH1McPtZkT9bPWL8P5Ou3G4uWA0Gwr4VpUiFCjMYv5dk1ywqiiW8UPfMqUlTw8pA95eOqDo1FKFWE0ppd+9F0v7H7qB+YcPGmkfnLIJ1Al9533ZHB5EA4E16+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WjnyIa2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WjnyIa2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5941F00893;
	Fri,  9 Oct 2026 05:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525564;
	bh=UlGbScMo+aIitEAgqG0DzT4TaOpkZBaE2vhvnEhyHj8=;
	h=Date:To:From:Subject;
	b=WjnyIa2JxeELcpnt13A2tm5HS1LmrgJE8lnMOxYVcMWoOu3aSuXYy2/+uswA3I3ju
	 qz490RNG8eqF57hOuwvyr5iPljGlNVoqbtDG9U+6y0MTZxMZB7yTT4uY8GpUpQCaWH
	 UNSLO+aBeR0MFRG8BJpGLwZEgFzxPfPzrOJryc88=
Date: Thu, 08 Oct 2026 22:59:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zenghui.yu@linux.dev,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch removed from -mm tree
Message-Id: <20261009055924.6C5941F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
Date: Tue, 22 Sep 2026 22:29:02 -0400

Extract per-node fallback-list construction into build_node_zonelist().
Build each selected node directly into the destination zonelist so no
intermediate node_order array or node count is needed. Print the
fallback order as each node is added.

This lets us build new zonelists from candidate nodemasks instead of
just the default N_MEMORY node state list.

Add a zlidx argument so callers explicitly select the destination
zonelist. The existing caller continues to use ZONELIST_FALLBACK.

No functional change: build_zonelists() builds and prints the same
FALLBACK list over N_MEMORY with node_load updates as before.

Link: https://lore.kernel.org/20260923022902.2433614-3-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---

 mm/page_alloc.c |   63 ++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 40 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists
+++ a/mm/page_alloc.c
@@ -5846,31 +5846,6 @@ int find_next_best_node_in(int node, nod
 
 
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
@@ -5885,20 +5860,24 @@ static void build_thisnode_zonelists(pg_
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
@@ -5908,18 +5887,22 @@ static void build_zonelists(pg_data_t *p
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

proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch
mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

