Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D311A76BB
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939813; cv=none; b=KDEML7gcpi2+ciaNpKBFy2tU87O+0BST20KKVt+vvABapOCLMszxf12MhXjzY9TWbv9TH96ZEgZhB4Z4YKKLS0eHEzgW1ou5UIq/KxK8qqprqEyIcPEIERypCJrbkKCXC4eNZSu14F7QV6NwBcoH3Mx1kknD5iZqmJK272nlM5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939813; c=relaxed/simple;
	bh=Xf69kfOV0DI7TY/DClfGD1rXlfseKBvNXxPcsWABu5U=;
	h=Date:To:From:Subject:Message-Id; b=O1Izzjf+v6uq8YgJr+UmPRz/gZ3bydXNU9VlArUskZVOoffmI/T7cJB2qJ4t5YWhIqr+6iL86go+pOleigkAt9Xy96oMU0TITFEAXtOs+DhukzfiDL7D4hC8pjZT/LFbLT8AlFbqk64U5/1I0A8arLMwTDG1ESL0lS46u9I/w4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CTPqnajg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CTPqnajg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A024C4CEF7;
	Thu, 12 Feb 2026 23:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939813;
	bh=Xf69kfOV0DI7TY/DClfGD1rXlfseKBvNXxPcsWABu5U=;
	h=Date:To:From:Subject:From;
	b=CTPqnajg74JhcCC15S3zYOIR1VRrj8PKbSSQZEiLWnL/dgstDNERXrOuNuG3IDxgC
	 azQHQbqED7CG3on4X2G26C11Y6f4JP8T/eaAxVqTdtovUMOLTwrUMRiCy6hfwXFc3B
	 Fn3GeMp0BWeZtDhf+Zu9jFrMoQNSwJAhi2ubDU2I=
Date: Thu, 12 Feb 2026 15:43:32 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,longman@redhat.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,axelrasmussen@google.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list.patch removed from -mm tree
Message-Id: <20260212234333.0A024C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: select the closest preferred node in demote_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bing Jiao <bingjiao@google.com>
Subject: mm/vmscan: select the closest preferred node in demote_folio_list()
Date: Wed, 14 Jan 2026 20:53:03 +0000

The preferred demotion node (migration_target_control.nid) should be the
one closest to the source node to minimize migration latency.  Currently,
a discrepancy exists where demote_folio_list() randomly selects an allowed
node if the preferred node from next_demotion_node() is not set in
mems_effective.

To address it, update next_demotion_node() to select a preferred target
against allowed nodes; and to return the closest demotion target if all
preferred nodes are not in mems_effective via next_demotion_node().

It ensures that the preferred demotion target is consistently the closest
available node to the source node.

[akpm@linux-foundation.org: fix comment typo, per Shakeel]
Link: https://lkml.kernel.org/r/20260114205305.2869796-3-bingjiao@google.com
Signed-off-by: Bing Jiao <bingjiao@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    6 +++---
 mm/memory-tiers.c            |   21 ++++++++++++++++-----
 mm/vmscan.c                  |    5 ++---
 3 files changed, 21 insertions(+), 11 deletions(-)

--- a/include/linux/memory-tiers.h~mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list
+++ a/include/linux/memory-tiers.h
@@ -53,11 +53,11 @@ struct memory_dev_type *mt_find_alloc_me
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
-int next_demotion_node(int node);
+int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
 #else
-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
 	return NUMA_NO_NODE;
 }
@@ -101,7 +101,7 @@ static inline void clear_node_memory_typ
 
 }
 
-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
 	return NUMA_NO_NODE;
 }
--- a/mm/memory-tiers.c~mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list
+++ a/mm/memory-tiers.c
@@ -320,16 +320,17 @@ void node_get_allowed_targets(pg_data_t
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
+ * @allowed_mask: The pointer to allowed node mask
  *
  * Return: node id for next memory node in the demotion path hierarchy
  * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
  * @node online or guarantee that it *continues* to be the next demotion
  * target.
  */
-int next_demotion_node(int node)
+int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
 	struct demotion_nodes *nd;
-	int target;
+	nodemask_t mask;
 
 	if (!node_demotion)
 		return NUMA_NO_NODE;
@@ -344,6 +345,10 @@ int next_demotion_node(int node)
 	 * node_demotion[] reads need to be consistent.
 	 */
 	rcu_read_lock();
+	/* Filter out nodes that are not in allowed_mask. */
+	nodes_and(mask, nd->preferred, *allowed_mask);
+	rcu_read_unlock();
+
 	/*
 	 * If there are multiple target nodes, just select one
 	 * target node randomly.
@@ -356,10 +361,16 @@ int next_demotion_node(int node)
 	 * caching issue, which seems more complicated. So selecting
 	 * target node randomly seems better until now.
 	 */
-	target = node_random(&nd->preferred);
-	rcu_read_unlock();
+	if (!nodes_empty(mask))
+		return node_random(&mask);
 
-	return target;
+	/*
+	 * Preferred nodes are not in allowed_mask. Flip bits in
+	 * allowed_mask as used node mask. Then, use it to get the
+	 * closest demotion target.
+	 */
+	nodes_complement(mask, *allowed_mask);
+	return find_next_best_node(node, &mask);
 }
 
 static void disable_all_demotion_targets(void)
--- a/mm/vmscan.c~mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list
+++ a/mm/vmscan.c
@@ -1046,12 +1046,11 @@ static unsigned int demote_folio_list(st
 	if (nodes_empty(allowed_mask))
 		return 0;
 
-	target_nid = next_demotion_node(pgdat->node_id);
+	target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
 	if (target_nid == NUMA_NO_NODE)
 		/* No lower-tier nodes or nodes were hot-unplugged. */
 		return 0;
-	if (!node_isset(target_nid, allowed_mask))
-		target_nid = node_random(&allowed_mask);
+
 	mtc.nid = target_nid;
 
 	/* Demotion ignores all cpuset and mempolicy settings */
_

Patches currently in -mm which might be from bingjiao@google.com are


