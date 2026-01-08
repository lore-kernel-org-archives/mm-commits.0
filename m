Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB49330333
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767905405; cv=none; b=uPoU8Y4MUFf/cqDQTTg0YE7aiJ5K9xPEWkgufYaGWaNZPuJDgtwHT0lu0R4gg6UVpscI+ATILMpBMAanF+T0F6BVAsa92KmtJ22KHcw49ehEvXgXvfgbLVODs+TeVdjVJAKjgLnhNJ/3ceIrKtAG1HeuS+CAcNVoC0FKHbw06Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767905405; c=relaxed/simple;
	bh=qeB+okGTJVlOQeTlRcUwkVp5D4GphRzZFOe/o4K8yDk=;
	h=Date:To:From:Subject:Message-Id; b=NX2Pm8vFtCkFgnko+PF5jLMXF3isKufA4OvJLl+Ko369DZ2JRouGRJW0qXtXtpDjXXgaQizHlHs32cXqKvxIRLBX0KHDuzPp70jdnyxL4ZdP31I2R5obl0wCq1YZK4wiem+OjLFkvVFMENidaiJairxG9FfI0OCZE9HF8Z3RySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q3jlcdnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q3jlcdnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EA3C116C6;
	Thu,  8 Jan 2026 20:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767905404;
	bh=qeB+okGTJVlOQeTlRcUwkVp5D4GphRzZFOe/o4K8yDk=;
	h=Date:To:From:Subject:From;
	b=Q3jlcdnx23Lr8q0tdwpuP7wyWx61uvby7WCa0PtK6XtZEVJY7H4LdZ89uou2JZCP5
	 fFDRllVMFw5uYkQXtlValeNjMlfFJjd1SbK83wl1BVz4WwK/R/CgQRDwmkhBC/cEb4
	 3hGDKOC0tLKv5co2ShTzILxCLHBtU78Uk80QjDsY=
Date: Thu, 08 Jan 2026 12:50:04 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,longman@redhat.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,axelrasmussen@google.com,akinobu.mita@gmail.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list.patch added to mm-new branch
Message-Id: <20260108205004.D9EA3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: select the closest preferred node in demote_folio_list()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bing Jiao <bingjiao@google.com>
Subject: mm/vmscan: select the closest preferred node in demote_folio_list()
Date: Thu, 8 Jan 2026 03:32:47 +0000

The preferred demotion node (migration_target_control.nid) should be the
one closest to the source node to minimize migration latency.  Currently,
a discrepancy exists where demote_folio_list() randomly selects an allowed
node if the preferred node from next_demotion_node() is not set in
mems_allowed.

To address it, update next_demotion_node() to return preferred nodes,
allowing the caller to select the preferred one.  Also update
demote_folio_list() to traverse the demotion targets hierarchically until
a preferred node within mems_allowed is found.  It ensures that the
selected demotion target is consistently the closest available node.

Link: https://lkml.kernel.org/r/20260108033248.2791579-3-bingjiao@google.com
Signed-off-by: Bing Jiao <bingjiao@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    6 +++---
 mm/memory-tiers.c            |   11 +++++++----
 mm/vmscan.c                  |   25 ++++++++++++++++++++++---
 3 files changed, 32 insertions(+), 10 deletions(-)

--- a/include/linux/memory-tiers.h~mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list
+++ a/include/linux/memory-tiers.h
@@ -53,11 +53,11 @@ struct memory_dev_type *mt_find_alloc_me
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
-int next_demotion_node(int node);
+int next_demotion_node(int node, nodemask_t *preferred_nodes);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
 #else
-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, nodemask_t *preferred_nodes)
 {
 	return NUMA_NO_NODE;
 }
@@ -101,7 +101,7 @@ static inline void clear_node_memory_typ
 
 }
 
-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, nodemask_t *preferred_nodes)
 {
 	return NUMA_NO_NODE;
 }
--- a/mm/memory-tiers.c~mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list
+++ a/mm/memory-tiers.c
@@ -320,13 +320,14 @@ void node_get_allowed_targets(pg_data_t
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
+ * @preferred_nodes: The pointer to nodemask of all preferred nodes to return
  *
  * Return: node id for next memory node in the demotion path hierarchy
- * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
- * @node online or guarantee that it *continues* to be the next demotion
- * target.
+ * from @node; NUMA_NO_NODE if @node is terminal. Also returns all preferred
+ * nodes in @preferred_nodes. This does not keep @node online or guarantee
+ * that it *continues* to be the next demotion target.
  */
-int next_demotion_node(int node)
+int next_demotion_node(int node, nodemask_t *preferred_nodes)
 {
 	struct demotion_nodes *nd;
 	int target;
@@ -357,6 +358,8 @@ int next_demotion_node(int node)
 	 * target node randomly seems better until now.
 	 */
 	target = node_random(&nd->preferred);
+	if (preferred_nodes)
+		nodes_copy(*preferred_nodes, nd->preferred);
 	rcu_read_unlock();
 
 	return target;
--- a/mm/vmscan.c~mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list
+++ a/mm/vmscan.c
@@ -1023,9 +1023,10 @@ static unsigned int demote_folio_list(st
 				      struct pglist_data *pgdat,
 				      struct mem_cgroup *memcg)
 {
-	int target_nid = next_demotion_node(pgdat->node_id);
+	int target_nid;
 	unsigned int nr_succeeded;
 	nodemask_t allowed_mask;
+	nodemask_t preferred;
 
 	struct migration_target_control mtc = {
 		/*
@@ -1051,8 +1052,26 @@ static unsigned int demote_folio_list(st
 	if (nodes_empty(allowed_mask))
 		return 0;
 
-	if (!node_isset(target_nid, allowed_mask))
-		target_nid = node_random(&allowed_mask);
+	target_nid = next_demotion_node(pgdat->node_id, &preferred);
+	while (target_nid != NUMA_NO_NODE &&
+	       !node_isset(target_nid, allowed_mask)) {
+		/* Filter out preferred nodes that are not in allowed. */
+		nodes_and(preferred, preferred, allowed_mask);
+		if (!nodes_empty(preferred)) {
+			/* Randomly select one node from preferred. */
+			target_nid = node_random(&preferred);
+			break;
+		}
+		/*
+		 * Preferred nodes in the lower tier are not set in allowed.
+		 * Recursively get preferred from the next lower tier.
+		 */
+		target_nid = next_demotion_node(target_nid, &preferred);
+	}
+
+	if (target_nid == NUMA_NO_NODE)
+		/* Nodes are gone (e.g., hot-unplugged). */
+		return 0;
 	mtc.nid = target_nid;
 
 	/* Demotion ignores all cpuset and mempolicy settings */
_

Patches currently in -mm which might be from bingjiao@google.com are

mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion.patch
mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list.patch

