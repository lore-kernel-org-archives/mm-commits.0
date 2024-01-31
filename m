Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AE922318
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 06:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706682904; cv=none; b=SP97B76CclXcf1ZsLJhRRS/6pp2Sa14+9OMuCnFgJ6B320URYYCBKFLdPzwftB3U4SQPyyoc4hogXWbeJA/yI2IvPZtSFXqhKOHSonJgyFmaC4LKR3hsh52soYVQHUJbbvhkMhzIewnWQteUXRE3KlMvnXt0IIhR7AshX78kt/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706682904; c=relaxed/simple;
	bh=eR4uJBIG+PZjPRFihAD5DqNGX6IKVSfqVr9SAUB8sfk=;
	h=Date:To:From:Subject:Message-Id; b=H6Uu6zwzEGrilvg2oWH8KxuG7GqAg/E/Z0j7/eXoQT4ajxb1STihfsbcvfh2e1qCsqUH9oZvzA8FdDTyhXX3ydTQ9lAg7aw+ThMcNkzl95FWefn7uR/ZPUumezeIzRX8BBXZmV3Yw1fXaXH7/AjIuQ2A/qrq7EKj/yGg9S95l2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gXKSu7N3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gXKSu7N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F449C43390;
	Wed, 31 Jan 2024 06:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706682904;
	bh=eR4uJBIG+PZjPRFihAD5DqNGX6IKVSfqVr9SAUB8sfk=;
	h=Date:To:From:Subject:From;
	b=gXKSu7N3R7LKgsrjZ3mvbGTM2C3tJxqFjqkLr4wlktQW/mONNH4JAqQ6yS+fDKZ08
	 +Y9MD9sZjl6nACQ+APKUpvuOOyJJTX14R8SI+qG5eiV06of1maCqhhZcGUyf3n87KO
	 /PMB6ZQDYSvRwQPyIoCn1tm043NzqBzrkTeOIu48=
Date: Tue, 30 Jan 2024 22:34:50 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@suse.com,mhocko@kernel.org,Jonathan.Cameron@huawei.com,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,fvdl@google.com,dan.j.williams@intel.com,corbet@lwn.net,ak@linux.intel.com,gourry.memverge@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-change-cur_il_weight-to-atomic-and-carry-the-node-with-it.patch removed from -mm tree
Message-Id: <20240131063502.6F449C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: change cur_il_weight to atomic and carry the node with it
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-change-cur_il_weight-to-atomic-and-carry-the-node-with-it.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gregory Price <gourry.memverge@gmail.com>
Subject: mm/mempolicy: change cur_il_weight to atomic and carry the node with it
Date: Thu, 25 Jan 2024 13:43:45 -0500

In the prior patch, we carry only the current weight for a weighted
interleave round with us across calls through the allocator path.

node = next_node_in(current->il_prev, pol->nodemask)
pol->cur_il_weight <--- this weight applies to the above node

This separation of data can cause a race condition.

If a cgroup-initiated task migration or mems_allowed change occurs
from outside the context of the task, this can cause the weight to
become stale, meaning we may end using that weight to allocate
memory on the wrong node.

Example:
  1) task A sets (cur_il_weight = 8) and (current->il_prev) to
     node0. node1 is the next set bit in pol->nodemask
  2) rebind event occurs, removing node1 from the nodemask.
     node2 is now the next set bit in pol->nodemask
     cur_il_weight is now stale.
  3) allocation occurs, next_node_in(il_prev, nodes) returns
     node2. cur_il_weight is now applied to the wrong node.

The upper level allocator logic must still enforce mems_allowed,
so this isn't dangerous, but it is innaccurate.

Just clearing the weight is insufficient, as it creates two more
race conditions.  The root of the issue is the separation of weight
and node data between nodemask and cur_il_weight.

To solve this, update cur_il_weight to be an atomic_t, and place the
node that the weight applies to in the upper bits of the field:

atomic_t cur_il_weight
	node bits 32:8
	weight bits 7:0

Now retrieving or clearing the active interleave node and weight
is a single atomic operation, and we are not dependent on the
potentially changing state of (pol->nodemask) to determine what
node the weight applies to.

Two special observations:
- if the weight is non-zero, cur_il_weight must *always* have a
  valid node number, e.g. it cannot be NUMA_NO_NODE (-1).
  This is because we steal the top byte for the weight.

- MAX_NUMNODES is presently limited to 1024 or less on every
  architecture. This would permanently limit MAX_NUMNODES to
  an absolute maximum of (1 << 24) to avoid overflows.

Per some reading and discussion, it appears that max nodes is
limited to 1024 so that zone type still fits in page flags, so
this method seemed preferable compared to the alternatives of
trying to make all or part of mempolicy RCU protected (which
may not be possible, since it is often referenced during code
chunks which call operations that may sleep).

Link: https://lkml.kernel.org/r/20240125184345.47074-5-gregory.price@memverge.com
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hasan Al Maruf <Hasan.Maruf@amd.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 
 mm/mempolicy.c            |   95 +++++++++++++++++++++++-------------
 2 files changed, 62 insertions(+), 35 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-change-cur_il_weight-to-atomic-and-carry-the-node-with-it
+++ a/include/linux/mempolicy.h
@@ -56,7 +56,7 @@ struct mempolicy {
 	} w;
 
 	/* Weighted interleave settings */
-	u8 cur_il_weight;
+	atomic_t cur_il_weight;
 };
 
 /*
--- a/mm/mempolicy.c~mm-mempolicy-change-cur_il_weight-to-atomic-and-carry-the-node-with-it
+++ a/mm/mempolicy.c
@@ -321,7 +321,7 @@ static struct mempolicy *mpol_new(unsign
 	policy->mode = mode;
 	policy->flags = flags;
 	policy->home_node = NUMA_NO_NODE;
-	policy->cur_il_weight = 0;
+	atomic_set(&policy->cur_il_weight, 0);
 
 	return policy;
 }
@@ -356,6 +356,7 @@ static void mpol_rebind_nodemask(struct
 		tmp = *nodes;
 
 	pol->nodes = tmp;
+	atomic_set(&pol->cur_il_weight, 0);
 }
 
 static void mpol_rebind_preferred(struct mempolicy *pol,
@@ -969,8 +970,10 @@ static long do_get_mempolicy(int *policy
 			*policy = next_node_in(current->il_prev, pol->nodes);
 		} else if (pol == current->mempolicy &&
 				(pol->mode == MPOL_WEIGHTED_INTERLEAVE)) {
-			if (pol->cur_il_weight)
-				*policy = current->il_prev;
+			int cweight = atomic_read(&pol->cur_il_weight);
+
+			if (cweight & 0xFF)
+				*policy = cweight >> 8;
 			else
 				*policy = next_node_in(current->il_prev,
 						       pol->nodes);
@@ -1860,36 +1863,48 @@ static unsigned int weighted_interleave_
 	unsigned int node, next;
 	struct task_struct *me = current;
 	u8 __rcu *table;
+	int cur_weight;
 	u8 weight;
 
-	node = next_node_in(me->il_prev, policy->nodes);
-	if (node == MAX_NUMNODES)
-		return node;
-
-	/* on first alloc after setting mempolicy, acquire first weight */
-	if (unlikely(!policy->cur_il_weight)) {
+	cur_weight = atomic_read(&policy->cur_il_weight);
+	node = cur_weight >> 8;
+	weight = cur_weight & 0xff;
+
+	/* If nodemask was rebound, just fetch the next node */
+	if (!weight || !node_isset(node, policy->nodes)) {
+		node = next_node_in(me->il_prev, policy->nodes);
+		/* can only happen if nodemask has become invalid */
+		if (node == MAX_NUMNODES)
+			return node;
 		rcu_read_lock();
 		table = rcu_dereference(iw_table);
 		/* detect system-default values */
 		weight = table ? table[node] : 1;
-		policy->cur_il_weight = weight ? weight : 1;
+		weight = weight ? weight : 1;
 		rcu_read_unlock();
 	}
 
 	/* account for this allocation call */
-	policy->cur_il_weight--;
+	weight--;
 
 	/* if now at 0, move to next node and set up that node's weight */
-	if (unlikely(!policy->cur_il_weight)) {
+	if (unlikely(!weight)) {
 		me->il_prev = node;
 		next = next_node_in(node, policy->nodes);
-		rcu_read_lock();
-		table = rcu_dereference(iw_table);
-		/* detect system-default values */
-		weight = table ? table[next] : 1;
-		policy->cur_il_weight = weight ? weight : 1;
-		rcu_read_unlock();
-	}
+		if (next != MAX_NUMNODES) {
+			rcu_read_lock();
+			table = rcu_dereference(iw_table);
+			/* detect system-default values */
+			weight = table ? table[next] : 1;
+			weight = weight ? weight : 1;
+			rcu_read_unlock();
+			cur_weight = (next << 8) | weight;
+		} else /* policy->nodes became invalid */
+			cur_weight = 0;
+	} else
+		cur_weight = (node << 8) | weight;
+
+	atomic_set(&policy->cur_il_weight, cur_weight);
 	return node;
 }
 
@@ -2381,6 +2396,7 @@ static unsigned long alloc_pages_bulk_ar
 	nodemask_t nodes;
 	int nnodes, node, resume_node, next_node;
 	int prev_node = me->il_prev;
+	int cur_node_and_weight = atomic_read(&pol->cur_il_weight);
 	int i;
 
 	if (!nr_pages)
@@ -2390,10 +2406,11 @@ static unsigned long alloc_pages_bulk_ar
 	if (!nnodes)
 		return 0;
 
+	node = cur_node_and_weight >> 8;
+	weight = cur_node_and_weight & 0xff;
 	/* Continue allocating from most recent node and adjust the nr_pages */
-	if (pol->cur_il_weight) {
-		node = next_node_in(prev_node, nodes);
-		node_pages = pol->cur_il_weight;
+	if (weight && node_isset(node, nodes)) {
+		node_pages = weight;
 		if (node_pages > rem_pages)
 			node_pages = rem_pages;
 		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
@@ -2404,27 +2421,36 @@ static unsigned long alloc_pages_bulk_ar
 		 * if that's all the pages, no need to interleave, otherwise
 		 * we need to set up the next interleave node/weight correctly.
 		 */
-		if (rem_pages < pol->cur_il_weight) {
+		if (rem_pages < weight) {
 			/* stay on current node, adjust cur_il_weight */
-			pol->cur_il_weight -= rem_pages;
+			weight -= rem_pages;
+			atomic_set(&pol->cur_il_weight, ((node << 8) | weight));
 			return total_allocated;
-		} else if (rem_pages == pol->cur_il_weight) {
+		} else if (rem_pages == weight) {
 			/* move to next node / weight */
 			me->il_prev = node;
 			next_node = next_node_in(node, nodes);
-			rcu_read_lock();
-			table = rcu_dereference(iw_table);
-			weight = table ? table[next_node] : 1;
-			/* detect system-default usage */
-			pol->cur_il_weight = weight ? weight : 1;
-			rcu_read_unlock();
+			if (next_node == MAX_NUMNODES) {
+				next_node = 0;
+				weight = 0;
+			} else {
+				rcu_read_lock();
+				table = rcu_dereference(iw_table);
+				weight = table ? table[next_node] : 1;
+				/* detect system-default usage */
+				weight = weight ? weight : 1;
+				rcu_read_unlock();
+			}
+			atomic_set(&pol->cur_il_weight,
+				   ((next_node << 8) | weight));
 			return total_allocated;
 		}
 		/* Otherwise we adjust nr_pages down, and continue from there */
-		rem_pages -= pol->cur_il_weight;
-		pol->cur_il_weight = 0;
+		rem_pages -= weight;
 		prev_node = node;
 	}
+	/* clear cur_il_weight in case of an allocation failure */
+	atomic_set(&pol->cur_il_weight, 0);
 
 	/* create a local copy of node weights to operate on outside rcu */
 	weights = kmalloc(nr_node_ids, GFP_KERNEL);
@@ -2509,7 +2535,8 @@ static unsigned long alloc_pages_bulk_ar
 	}
 	/* resume allocating from the calculated node and weight */
 	me->il_prev = resume_node;
-	pol->cur_il_weight = resume_weight;
+	resume_node = next_node_in(resume_node, nodes);
+	atomic_set(&pol->cur_il_weight, ((resume_node << 8) | resume_weight));
 	kfree(weights);
 	return total_allocated;
 }
_

Patches currently in -mm which might be from gourry.memverge@gmail.com are


