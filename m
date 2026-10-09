Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28042046E
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525564; cv=none; b=OSqzP1bTVQHYWiO2NCOwjz8/sxjE+64Kewb7P2+8cWSyE0XkhBy+m+T85oA8py+h/mMbu9lJjTAUUpnnnZhpzMPFWHFC6847h4RAn35jmz6uYb6mUA+6ZVrA+CdVyV95RguxGpdV+bjbC9gsSuTpnqe5PjI145y1F/0lF+MBrVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525564; c=relaxed/simple;
	bh=RSQAnIQ3i6vWQJ3IXkOfjwtnUCUIEPKDioODvu3p6cc=;
	h=Date:To:From:Subject:Message-Id; b=hGIV/13p45ffQc0gX5gpCxUXhpeYYtyIc278g1ejY8EZNE0R8yklNt93WwRRS7oDTbO6YmUYNtQ9gnV7qswAVMYGVqE242B5FxWVyDaLLnXVza8Ttgd4izY2Ygrg8TornKX0MFzJqdbLTJ+ihtxTJBEMdOjkIUrraejIX55DYHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OrjpEZM+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OrjpEZM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7B41F000FF;
	Fri,  9 Oct 2026 05:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525563;
	bh=PprlYhkPpf9ryztyAbylsH9gn7IkG2mxdUcXJCDAjQk=;
	h=Date:To:From:Subject;
	b=OrjpEZM+fxGUW2i2jym0Zv9wXn92bOjTcrLjO1tVFHBxa+fDmU8nZRQjmFFchCewO
	 Ofr4MoXxeCTaVH0jE0UWiMkxXNpytWEoYo0zpLaEGo9lMoSRlYoizjWG/qiAQO2MJV
	 EFeuZMeQg9kgcBCJtvoK1lVJH3/pekZX96PhYaR0=
Date: Thu, 08 Oct 2026 22:59:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zenghui.yu@linux.dev,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,balbirs@nvidia.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-find_next_best_node-to-find_next_best_node_in.patch removed from -mm tree
Message-Id: <20261009055922.DF7B41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: refactor find_next_best_node to find_next_best_node_in
has been removed from the -mm tree.  Its filename was
     mm-refactor-find_next_best_node-to-find_next_best_node_in.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm: refactor find_next_best_node to find_next_best_node_in
Date: Tue, 22 Sep 2026 22:29:01 -0400

Patch series "mm: refactor zonelist constructors and iterators", v3.

find_next_best_node() picks the next-closest node when building a fallback
list, and hardcodes N_MEMORY as the set it picks from.

Refactor it into find_next_best_node_in(), which takes the candidate set
explicitly.

This makes the existing behaviour explicit at both mm/memory-tiers.c call
sites - they select demotion targets in fallback order from N_MEMORY - and
lets callers narrow that set.

Then extract the per-node construction loop out of build_zonelists() into
build_node_zonelist(), parameterised on the candidate nodemask and
destination zonelist index.

Together these allow a zonelist to be built over a candidate set other
than N_MEMORY, into a zonelist other than FALLBACK, and iterated in
fallback order over a caller-defined subset.

These are prerequisites for generating a private node zonelist (nodes
unreachable by default), but are otherwise general improvements to the
existing interfaces so I'm proposing them separately.

No functional change intended - purely refactor commits.


This patch (of 2):

find_next_best_node() picks the next-closest node for a fallback list
from the full N_MEMORY set. Refactor it into find_next_best_node_in(),
which takes an explicit candidates nodemask.

This enables building fallback lists with non-N_MEMORY candidates.

No functional change: every caller still selects from N_MEMORY.

Link: https://lore.kernel.org/20260923022902.2433614-1-gourry@gourry.net
Link: https://lore.kernel.org/20260923022902.2433614-2-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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

 mm/internal.h     |    6 ++++--
 mm/memory-tiers.c |    7 ++++---
 mm/page_alloc.c   |   13 ++++++++-----
 3 files changed, 16 insertions(+), 10 deletions(-)

--- a/mm/internal.h~mm-refactor-find_next_best_node-to-find_next_best_node_in
+++ a/mm/internal.h
@@ -1124,7 +1124,8 @@ extern int node_reclaim_mode;
 
 extern unsigned long node_reclaim(struct pglist_data *pgdat,
 				  gfp_t gfp_mask, unsigned int order);
-extern int find_next_best_node(int node, nodemask_t *used_node_mask);
+int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+		const nodemask_t *candidates);
 #else
 #define node_reclaim_mode 0
 
@@ -1133,7 +1134,8 @@ static inline unsigned long node_reclaim
 {
 	return 0;
 }
-static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
+static inline int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+		const nodemask_t *candidates)
 {
 	return NUMA_NO_NODE;
 }
--- a/mm/memory-tiers.c~mm-refactor-find_next_best_node-to-find_next_best_node_in
+++ a/mm/memory-tiers.c
@@ -370,7 +370,7 @@ int next_demotion_node(int node, const n
 	 * closest demotion target.
 	 */
 	nodes_complement(mask, *allowed_mask);
-	return find_next_best_node(node, &mask);
+	return find_next_best_node_in(node, &mask, &node_states[N_MEMORY]);
 }
 
 static void disable_all_demotion_targets(void)
@@ -450,7 +450,7 @@ static void establish_demotion_targets(v
 		memtier = list_next_entry(memtier, list);
 		tier_nodes = get_memtier_nodemask(memtier);
 		/*
-		 * find_next_best_node, use 'used' nodemask as a skip list.
+		 * find_next_best_node_in, use 'used' nodemask as a skip list.
 		 * Add all memory nodes except the selected memory tier
 		 * nodelist to skip list so that we find the best node from the
 		 * memtier nodelist.
@@ -463,7 +463,8 @@ static void establish_demotion_targets(v
 		 * in the preferred mask when allocating pages during demotion.
 		 */
 		do {
-			target = find_next_best_node(node, &tier_nodes);
+			target = find_next_best_node_in(node, &tier_nodes,
+							&node_states[N_MEMORY]);
 			if (target == NUMA_NO_NODE)
 				break;
 
--- a/mm/page_alloc.c~mm-refactor-find_next_best_node-to-find_next_best_node_in
+++ a/mm/page_alloc.c
@@ -5781,9 +5781,10 @@ static int numa_zonelist_order_handler(c
 static int node_load[MAX_NUMNODES];
 
 /**
- * find_next_best_node - find the next node that should appear in a given node's fallback list
+ * find_next_best_node_in - find the next node that should appear in a given node's fallback list
  * @node: node whose fallback list we're appending
  * @used_node_mask: nodemask_t of already used nodes
+ * @candidates: nodemask_t of nodes eligible for selection
  *
  * We use a number of factors to determine which is the next node that should
  * appear on a given node's fallback list.  The node should not have appeared
@@ -5795,7 +5796,8 @@ static int node_load[MAX_NUMNODES];
  *
  * Return: node id of the found node or %NUMA_NO_NODE if no node is found.
  */
-int find_next_best_node(int node, nodemask_t *used_node_mask)
+int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+			   const nodemask_t *candidates)
 {
 	int n, val;
 	int min_val = INT_MAX;
@@ -5805,12 +5807,12 @@ int find_next_best_node(int node, nodema
 	 * Use the local node if we haven't already, but for memoryless local
 	 * node, we should skip it and fall back to other nodes.
 	 */
-	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
+	if (!node_isset(node, *used_node_mask) && node_isset(node, *candidates)) {
 		node_set(node, *used_node_mask);
 		return node;
 	}
 
-	for_each_node_state(n, N_MEMORY) {
+	for_each_node_mask(n, *candidates) {
 
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
@@ -5895,7 +5897,8 @@ static void build_zonelists(pg_data_t *p
 	prev_node = local_node;
 
 	memset(node_order, 0, sizeof(node_order));
-	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
+	while ((node = find_next_best_node_in(local_node, &used_mask,
+					      &node_states[N_MEMORY])) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
_

Patches currently in -mm which might be from gourry@gourry.net are

proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch
mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

