Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD04202990
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 21:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750972656; cv=none; b=eU6xH+JiM2an4zhmXo0hbrwW7ySan8f3R98/iuhDZk45eCfGYQbHPgYrA7nDmQtbqKVoiSnpLExWyVuDRI07ua0DAqJ6B22PJxGoCteOfql/LZ3vtXL+Zso0zYJ4Ub4mSz4xWtoUIVmEcFSlKxn+8XyTcYPGYSkBfIxdWhdc0+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750972656; c=relaxed/simple;
	bh=yFCWWIjJF7UffzOXTdZo87g6hbAhQwyh8g+TZFADshI=;
	h=Date:To:From:Subject:Message-Id; b=ahiLa1Zpm1AlxT0WhPsyWddd9BA+HNTOMBshfmqeZcMDGU/MfTS/XtnPDL2nsSzPvYQgwLQdKebgpqreuy39AoCIzTuVxWLPKzB1dK+m2oDmM/Fnn8rsCHW9IewIEhqmA1I/TQ0UlaVxaeYLEeWRNCjPkFm3lVGaofhRrVubJ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xZM77GAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xZM77GAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D1EC4CEEB;
	Thu, 26 Jun 2025 21:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750972655;
	bh=yFCWWIjJF7UffzOXTdZo87g6hbAhQwyh8g+TZFADshI=;
	h=Date:To:From:Subject:From;
	b=xZM77GAAOUu6tnE4s7r3G85dHRrtnB5bM58Adkkc0jj5eQ56DJ22RpRtwzgd4/tNF
	 tTtHbsX95sLz6HFVWcwZtgJDdSw99jRaXsHxicfz/7iMzAAOTf7ijfWuGODDQ8sNx7
	 EeAcO5vrmGLI72DnPm8fbepnJHgpRMC+b/+QO5KM=
Date: Thu, 26 Jun 2025 14:17:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave.patch added to mm-new branch
Message-Id: <20250626211735.50D1EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: skip extra call to __alloc_pages_bulk in weighted interleave
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-mempolicy-simplify-weighted-interleave-bulk-alloc-calculations.patch
mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave.patch

