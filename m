Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A998738E5DC
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 21:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789767993; cv=none; b=bkAU3GVaBPrZgxfxXKpMOGIPykevRwVayrxTPDWjw/HlAOr0BD2Dc2FpSh3xYgl53Sy3LPdXgYalviqh1bVW0/sW6jtwm05noRHPnJTuNBE9o85jqwlswBTPRb1RRmfrWILM+9f8WELf9Kbi8GUM+5V5uXebvsb/2UjVwMhOArw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789767993; c=relaxed/simple;
	bh=+f/lZR6tPhrojWAepN8jMe6aLvlKLF1KtcLKpl/19qs=;
	h=Date:To:From:Subject:Message-Id; b=UhV3jXySCnPz4PIu5QGwF6cZsqKSb3zcXJc7H0KOeIssH3BSwM3YrWstMnFrTPXmAE5hm4bmksj+8J4pLObXauiCKxfLbmt/fdnUMkf81UY5ErCu6x+7jkUDQhxjZAZbhxpvRYalVADBDjy9p+7PkCQeRefPVtwoYiZJv7ycKAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wefYJAU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wefYJAU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B73E1F00898;
	Fri, 18 Sep 2026 21:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789767991;
	bh=MuNczSzM4ZJZZGNXeGVDrdZNswjpYrllIgHO0Jie91w=;
	h=Date:To:From:Subject;
	b=wefYJAU7Ylq6AeFG3wBuknigqf0Z6yxYcF/lxSeVrJN/3f+RfyevZOrjf6VCRYzXo
	 3R4JTHDPO+ooxl/haQoxCKwY+179IExJK0fIANH8UDPTYyK8aGl7EKNyO/w04Wd22o
	 Ua0r/5mzc9eZHFf3ZKGnj6+/fnQEJ/o1pgFoWdSk=
Date: Fri, 18 Sep 2026 14:46:30 -0700
To: mm-commits@vger.kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch removed from -mm tree
Message-Id: <20260918214631.2B73E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: stop copying the nodemask in the interleave paths
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/mempolicy: stop copying the nodemask in the interleave paths
Date: Fri, 28 Aug 2026 21:59:43 -0400

The interleave node selectors copy pol->nodes onto the stack so the mask
cannot change while they walk it.  nodemask_t is 128 bytes at
MAX_NUMNODES=1024, and two of the three run per folio fault.

The copy only buys consistency between the node count and the walk.  Drop
the consistency and just bounds check the walk instead.

If an empty nodelist or weight is perceived, fall back to numa_node_id(),
which is what the functions already did when the copy came back empty.

weighted_interleave_nid() counts the nodes as we sum the weights.  We use
that node count to limit the maximum skew a single node can host.

interleave_nid() walks with next_node_in() rather than next_node(), so a
mask that shrank mid-walk wraps to a node still in the policy.

alloc_pages_bulk_weighted_interleave() derives per-node counts from a
weight total summed over the mask, so a changing mask can make them exceed
the request.  Clamp each chunk to the space left in page_array.

A cpuset cookie will not work here: two of these take VMA policies, which
mpol_rebind_mm() rebinds under mmap_write_lock(), not mems_allowed_seq.

Cost is distribution accuracy during a rebind - but the copy never
corrected this anyway, it was just a safety mechanism to prevent div/0 and
overrunning the alloc request buffer.

Remove read_once_policy_nodemask(), now unused.

-fstack-usage at MAX_NUMNODES=1024:

  weighted_interleave_nid            184 -> 56
  interleave_nid                     168 -> 32
  alloc_pages_bulk_mempolicy_noprof  360 -> 136

Link: https://lore.kernel.org/20260829015943.1258774-3-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Rakie Kim <rakie.kim@sk.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chenwandun <chenwandun@huawei.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/mempolicy.c |   86 ++++++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 37 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths
+++ a/mm/mempolicy.c
@@ -2197,34 +2197,15 @@ unsigned int mempolicy_slab_node(void)
 	}
 }
 
-static unsigned int read_once_policy_nodemask(struct mempolicy *pol,
-					      nodemask_t *mask)
-{
-	/*
-	 * barrier stabilizes the nodemask locally so that it can be iterated
-	 * over safely without concern for changes. Allocators validate node
-	 * selection does not violate mems_allowed, so this is safe.
-	 */
-	barrier();
-	memcpy(mask, &pol->nodes, sizeof(nodemask_t));
-	barrier();
-	return nodes_weight(*mask);
-}
-
 static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 {
 	struct weighted_interleave_state *state;
-	nodemask_t nodemask;
-	unsigned int target, nr_nodes;
+	unsigned int target, nnodes = 0;
 	u8 *table = NULL;
 	unsigned int weight_total = 0;
 	u8 weight;
 	int nid = 0;
 
-	nr_nodes = read_once_policy_nodemask(pol, &nodemask);
-	if (!nr_nodes)
-		return numa_node_id();
-
 	rcu_read_lock();
 
 	state = rcu_dereference(wi_state);
@@ -2232,22 +2213,40 @@ static unsigned int weighted_interleave_
 	if (state)
 		table = state->iw_table;
 
-	/* calculate the total weight */
-	for_each_node_mask(nid, nodemask)
+	/* calculate the total weight and the node count */
+	for_each_node_mask(nid, pol->nodes) {
 		weight_total += table ? table[nid] : 1;
+		nnodes++;
+	}
+
+	/* the mask is empty */
+	if (!weight_total) {
+		rcu_read_unlock();
+		return numa_node_id();
+	}
 
 	/* Calculate the node offset based on totals */
 	target = ilx % weight_total;
-	nid = first_node(nodemask);
-	while (target) {
+	nid = first_node(pol->nodes);
+
+	/*
+	 * The target was calculated in a separate loop, and a concurrent
+	 * rebind can change the total number of nodes.  Clamp this loop to
+	 * a single pass (nnodes) to keep the walk bounded by node count.
+	 */
+	while (target && nnodes-- && nid < MAX_NUMNODES) {
 		/* detect system default usage */
 		weight = table ? table[nid] : 1;
 		if (target < weight)
 			break;
 		target -= weight;
-		nid = next_node_in(nid, nodemask);
+		nid = next_node_in(nid, pol->nodes);
 	}
 	rcu_read_unlock();
+
+	/* the mask emptied under the walk */
+	if (nid >= MAX_NUMNODES)
+		return numa_node_id();
 	return nid;
 }
 
@@ -2258,18 +2257,21 @@ static unsigned int weighted_interleave_
  */
 static unsigned int interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 {
-	nodemask_t nodemask;
 	unsigned int target, nnodes;
 	int i;
 	int nid;
 
-	nnodes = read_once_policy_nodemask(pol, &nodemask);
+	nnodes = nodes_weight(pol->nodes);
 	if (!nnodes)
 		return numa_node_id();
 	target = ilx % nnodes;
-	nid = first_node(nodemask);
-	for (i = 0; i < target; i++)
-		nid = next_node(nid, nodemask);
+	nid = first_node(pol->nodes);
+	for (i = 0; i < target && nid < MAX_NUMNODES; i++)
+		nid = next_node_in(nid, pol->nodes);
+
+	/* the mask emptied under the walk */
+	if (nid >= MAX_NUMNODES)
+		return numa_node_id();
 	return nid;
 }
 
@@ -2665,7 +2667,6 @@ static unsigned long alloc_pages_bulk_we
 	u8 *table, weight;
 	unsigned int weight_total = 0;
 	unsigned long rem_pages = nr_pages;
-	nodemask_t nodes;
 	int nnodes, node;
 	int resume_node = MAX_NUMNODES - 1;
 	u8 resume_weight = 0;
@@ -2675,10 +2676,10 @@ static unsigned long alloc_pages_bulk_we
 	if (!nr_pages)
 		return 0;
 
-	/* read the nodes onto the stack, retry if done during rebind */
+	/* count the nodes, retry if a rebind happened during the read */
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
-		nnodes = read_once_policy_nodemask(pol, &nodes);
+		nnodes = nodes_weight(pol->nodes);
 	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 
 	/* if the nodemask has become invalid, we cannot do anything */
@@ -2688,7 +2689,7 @@ static unsigned long alloc_pages_bulk_we
 	/* Continue allocating from most recent node and adjust the nr_pages */
 	node = me->il_prev;
 	weight = me->il_weight;
-	if (weight && node_isset(node, nodes)) {
+	if (weight && node_isset(node, pol->nodes)) {
 		node_pages = min(rem_pages, weight);
 		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
 						  page_array);
@@ -2712,9 +2713,13 @@ static unsigned long alloc_pages_bulk_we
 	table = state ? state->iw_table : NULL;
 
 	/* calculate total, detect system default usage */
-	for_each_node_mask(node, nodes)
+	for_each_node_mask(node, pol->nodes)
 		weight_total += table ? table[node] : 1;
 
+	/* the mask emptied since it was counted */
+	if (!weight_total)
+		goto out;
+
 	/*
 	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.
 	 * Track which node weighted interleave should resume from.
@@ -2724,10 +2729,14 @@ static unsigned long alloc_pages_bulk_we
 	 */
 	rounds = rem_pages / weight_total;
 	delta = rem_pages % weight_total;
-	resume_node = next_node_in(prev_node, nodes);
+	resume_node = next_node_in(prev_node, pol->nodes);
+	if (resume_node >= MAX_NUMNODES)
+		goto out;
 	resume_weight = table ? table[resume_node] : 1;
 	for (i = 0; i < nnodes; i++) {
-		node = next_node_in(prev_node, nodes);
+		node = next_node_in(prev_node, pol->nodes);
+		if (node >= MAX_NUMNODES)
+			break;
 		weight = table ? table[node] : 1;
 		node_pages = weight * rounds;
 		/* If a delta exists, add this node's portion of the delta */
@@ -2744,6 +2753,8 @@ static unsigned long alloc_pages_bulk_we
 		/* node_pages can be 0 if an allocation fails and rounds == 0 */
 		if (!node_pages)
 			break;
+		/* a rebind can invalidate the counts: never overrun page_array */
+		node_pages = min(node_pages, nr_pages - total_allocated);
 		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
 						  page_array);
 		page_array += nr_allocated;
@@ -2754,6 +2765,7 @@ static unsigned long alloc_pages_bulk_we
 	}
 	me->il_prev = resume_node;
 	me->il_weight = resume_weight;
+out:
 	srcu_read_unlock_fast(&wi_srcu, scp);
 	return total_allocated;
 }
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch
mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

