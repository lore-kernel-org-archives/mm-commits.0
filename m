Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B02236F4
	for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2025 22:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322928; cv=none; b=O2aMqpl18iPdxQw15GrAay3nZWdy7L3R93ak+J6zGig+4Gha3xzzKmXSb653KZVJoC6Mr1KjXxqLT1kOKw+x4IEfilTLSIIqR9v+Rx65Yc+mc+GlOQa9jzjSQG2OfyZv6nPOwpJW22cAboFnlFMteKw5rAM2Z9bUvSGHAdMUxj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322928; c=relaxed/simple;
	bh=/iPK0YL0r+KiIYGwCr3zR2EjQlXBIBmjiaNVDhvHe0A=;
	h=Date:To:From:Subject:Message-Id; b=I6rD7adP50Dk1Rdd3DB2vGDPjbR7oHn0/zULiXvSNFzwtv/gnnYtINEqB3sQayQqDFhbWLvbLGUdKW5cx3VzbjZG2KruPP2o9kBmBrFYvYGGmwfz3DacMhqWA8Az5DltuL22V5kI4Q0VggnQ2Ok783TW0zTJ7kQfsz8CRnQO+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwcTULJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwcTULJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC202C4CEE3;
	Mon, 30 Jun 2025 22:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751322928;
	bh=/iPK0YL0r+KiIYGwCr3zR2EjQlXBIBmjiaNVDhvHe0A=;
	h=Date:To:From:Subject:From;
	b=YwcTULJf1XE0VL8LU1gQplup9swU/ZSdJJNM8fii/8+WffjxSJtV3RQbahY5DdR1m
	 CjCz/4EKaXRw3ER5h/Q2KmAmabyXnDBLH2rSkqD67vkbS4UIuI67wm5kJvhxKhAWU9
	 dlo6Rr1IXFJ+VFfhBUTjuMVfhZh+C7+KIV6e28jE=
Date: Mon, 30 Jun 2025 15:35:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,osalvador@suse.de,matthew.brost@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave.patch removed from -mm tree
Message-Id: <20250630223527.EC202C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: skip extra call to __alloc_pages_bulk in weighted interleave
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/mempolicy: skip extra call to __alloc_pages_bulk in weighted interleave
Date: Thu, 26 Jun 2025 13:09:34 -0700

Currently, alloc_pages_bulk_weighted_interleave can make up to
nr_node_ids+1 calls to __alloc_pages_bulk.  The additional allocation can
happen if the previous call to this function finished the weighted round
robin allocation partially on a node.  To make up for this, the next time
this function is called, an extra allocation is made to finish cleanly on
the node boundaries before performing the weighted round-robin cycles
again.

Instead of making an additional call, we can calculate how many additional
pages should be allocated from the first node (aka carryover) and add that
value to the number of pages that should be allocated as part of the
current round-robin cycle.

Running a quick benchmark by compiling the kernel shows a small increase
in performance.  These experiments were run on a machine with 2 nodes,
each with 125GB memory and 40 CPUs.

time numactl -w 0,1 make -j$(nproc)

+----------+---------+------------+---------+
| Time (s) |  6.16   | With patch | % Delta |
+----------+---------+------------+---------+
| Real     |  88.374 |    88.3356 | -0.2019 |
| User     |  3631.7 |   3636.263 |  0.0631 |
| Sys      | 366.029 |    363.792 | -0.7534 |
+----------+---------+------------+---------+

Link: https://lkml.kernel.org/r/20250626200936.3974420-3-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave
+++ a/mm/mempolicy.c
@@ -2569,7 +2569,7 @@ static unsigned long alloc_pages_bulk_we
 	unsigned long node_pages, delta;
 	u8 *weights, weight;
 	unsigned int weight_total = 0;
-	unsigned long rem_pages = nr_pages;
+	unsigned long rem_pages = nr_pages, carryover = 0;
 	nodemask_t nodes;
 	int nnodes, node;
 	int resume_node = MAX_NUMNODES - 1;
@@ -2594,18 +2594,12 @@ static unsigned long alloc_pages_bulk_we
 	node = me->il_prev;
 	weight = me->il_weight;
 	if (weight && node_isset(node, nodes)) {
-		node_pages = min(rem_pages, weight);
-		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
-						  page_array);
-		page_array += nr_allocated;
-		total_allocated += nr_allocated;
-		/* if that's all the pages, no need to interleave */
 		if (rem_pages <= weight) {
-			me->il_weight -= rem_pages;
-			return total_allocated;
+			node_pages = rem_pages;
+			me->il_weight -= node_pages;
+			goto allocate;
 		}
-		/* Otherwise we adjust remaining pages, continue from there */
-		rem_pages -= weight;
+		carryover = weight;
 	}
 	/* clear active weight in case of an allocation failure */
 	me->il_weight = 0;
@@ -2614,7 +2608,7 @@ static unsigned long alloc_pages_bulk_we
 	/* create a local copy of node weights to operate on outside rcu */
 	weights = kzalloc(nr_node_ids, GFP_KERNEL);
 	if (!weights)
-		return total_allocated;
+		return 0;
 
 	rcu_read_lock();
 	state = rcu_dereference(wi_state);
@@ -2634,16 +2628,17 @@ static unsigned long alloc_pages_bulk_we
 	/*
 	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.
 	 * Track which node weighted interleave should resume from.
+	 * Account for carryover. It is always allocated from the first node.
 	 *
 	 * if (rounds > 0) and (delta == 0), resume_node will always be
 	 * the node following prev_node and its weight.
 	 */
-	rounds = rem_pages / weight_total;
-	delta = rem_pages % weight_total;
+	rounds = (rem_pages - carryover) / weight_total;
+	delta = (rem_pages - carryover) % weight_total;
 	resume_node = next_node_in(prev_node, nodes);
 	resume_weight = weights[resume_node];
+	node = carryover ? prev_node : next_node_in(prev_node, nodes);
 	for (i = 0; i < nnodes; i++) {
-		node = next_node_in(prev_node, nodes);
 		weight = weights[node];
 		/* when delta is depleted, resume from that node */
 		if (delta && delta < weight) {
@@ -2651,12 +2646,14 @@ static unsigned long alloc_pages_bulk_we
 			resume_weight = weight - delta;
 		}
 		/* Add the node's portion of the delta, if there is one */
-		node_pages = weight * rounds + min(delta, weight);
+		node_pages = weight * rounds + min(delta, weight) + carryover;
 		delta -= min(delta, weight);
+		carryover = 0;
 
 		/* node_pages can be 0 if an allocation fails and rounds == 0 */
 		if (!node_pages)
 			break;
+allocate:
 		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
 						  page_array);
 		page_array += nr_allocated;
@@ -2664,10 +2661,14 @@ static unsigned long alloc_pages_bulk_we
 		if (total_allocated == nr_pages)
 			break;
 		prev_node = node;
+		node = next_node_in(prev_node, nodes);
+	}
+
+	if (weights) {
+		me->il_prev = resume_node;
+		me->il_weight = resume_weight;
+		kfree(weights);
 	}
-	me->il_prev = resume_node;
-	me->il_weight = resume_weight;
-	kfree(weights);
 	return total_allocated;
 }
 
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-mempolicy-skip-unnecessary-synchronize_rcu.patch

