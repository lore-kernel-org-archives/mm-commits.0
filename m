Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6DEC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377870AbiATV1d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37850 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377885AbiATV1a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84E3060018
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F46C340E0;
        Thu, 20 Jan 2022 21:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714050;
        bh=RmG5TQCh00Plsx1DvmLgZeJIAxtsqFb/O79BiqFMzCQ=;
        h=Date:From:To:Subject:From;
        b=N/xRMTJrfW/h0HXSuZx1J7q5gSn61/whgckMHw9sHJ/1J93zjgDyu0v7mA9/br6PA
         +oNI1LZlXrtonDlpF40tBTYaPtn6tj7Q9UVHUCIB1n9aBDWP0arRKc2VtKf2K2w7YT
         y4r9seKbF/g1rLztKujdGIZO0SPd8qFPNkJnbp/I=
Date:   Thu, 20 Jan 2022 13:27:29 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, dave.hansen@linux.intel.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, shy828301@gmail.com,
        xlpang@linux.alibaba.com, ying.huang@intel.com,
        zhongjiang-ali@linux.alibaba.com, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-support-multiple-target-nodes-demotion.patch removed from -mm
 tree
Message-ID: <20220120212729.P57EFdXSQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: support multiple target nodes demotion
has been removed from the -mm tree.  Its filename was
     mm-migrate-support-multiple-target-nodes-demotion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: support multiple target nodes demotion

We have some machines with multiple memory types like below, which have
one fast (DRAM) memory node and two slow (persistent memory) memory nodes.
According to current node demotion policy, if node 0 fills up, its memory
should be migrated to node 1, when node 1 fills up, its memory will be
migrated to node 2: node 0 -> node 1 -> node 2 ->stop.

But this is not efficient and suitbale memory migration route for our
machine with multiple slow memory nodes.  Since the distance between node
0 to node 1 and node 0 to node 2 is equal, and memory migration between
slow memory nodes will increase persistent memory bandwidth greatly, which
will hurt the whole system's performance.

Thus for this case, we can treat the slow memory node 1 and node 2 as a
whole slow memory region, and we should migrate memory from node 0 to node
1 and node 2 if node 0 fills up.

This patch changes the node_demotion data structure to support multiple
target nodes, and establishes the migration path to support multiple
target nodes with validating if the node distance is the best or not.

available: 3 nodes (0-2)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
node 0 size: 62153 MB
node 0 free: 55135 MB
node 1 cpus:
node 1 size: 127007 MB
node 1 free: 126930 MB
node 2 cpus:
node 2 size: 126968 MB
node 2 free: 126878 MB
node distances:
node   0   1   2
  0:  10  20  20
  1:  20  10  20
  2:  20  20  10

Link: https://lkml.kernel.org/r/00728da107789bb4ed9e0d28b1d08fd8056af2ef.1636697263.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  164 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 129 insertions(+), 35 deletions(-)

--- a/mm/migrate.c~mm-migrate-support-multiple-target-nodes-demotion
+++ a/mm/migrate.c
@@ -50,6 +50,7 @@
 #include <linux/ptrace.h>
 #include <linux/oom.h>
 #include <linux/memory.h>
+#include <linux/random.h>
 
 #include <asm/tlbflush.h>
 
@@ -1118,12 +1119,25 @@ out:
  *
  * This is represented in the node_demotion[] like this:
  *
- *	{  1, // Node 0 migrates to 1
- *	   2, // Node 1 migrates to 2
- *	  -1, // Node 2 does not migrate
- *	   4, // Node 3 migrates to 4
- *	   5, // Node 4 migrates to 5
- *	  -1} // Node 5 does not migrate
+ *	{  nr=1, nodes[0]=1 }, // Node 0 migrates to 1
+ *	{  nr=1, nodes[0]=2 }, // Node 1 migrates to 2
+ *	{  nr=0, nodes[0]=-1 }, // Node 2 does not migrate
+ *	{  nr=1, nodes[0]=4 }, // Node 3 migrates to 4
+ *	{  nr=1, nodes[0]=5 }, // Node 4 migrates to 5
+ *	{  nr=0, nodes[0]=-1 }, // Node 5 does not migrate
+ *
+ * Moreover some systems may have multiple slow memory nodes.
+ * Suppose a system has one socket with 3 memory nodes, node 0
+ * is fast memory type, and node 1/2 both are slow memory
+ * type, and the distance between fast memory node and slow
+ * memory node is same. So the migration path should be:
+ *
+ *	0 -> 1/2 -> stop
+ *
+ * This is represented in the node_demotion[] like this:
+ *	{ nr=2, {nodes[0]=1, nodes[1]=2} }, // Node 0 migrates to node 1 and node 2
+ *	{ nr=0, nodes[0]=-1, }, // Node 1 dose not migrate
+ *	{ nr=0, nodes[0]=-1, }, // Node 2 does not migrate
  */
 
 /*
@@ -1134,8 +1148,20 @@ out:
  * must be held over all reads to ensure that no cycles are
  * observed.
  */
-static int node_demotion[MAX_NUMNODES] __read_mostly =
-	{[0 ...  MAX_NUMNODES - 1] = NUMA_NO_NODE};
+#define DEFAULT_DEMOTION_TARGET_NODES 15
+
+#if MAX_NUMNODES < DEFAULT_DEMOTION_TARGET_NODES
+#define DEMOTION_TARGET_NODES	(MAX_NUMNODES - 1)
+#else
+#define DEMOTION_TARGET_NODES	DEFAULT_DEMOTION_TARGET_NODES
+#endif
+
+struct demotion_nodes {
+	unsigned short nr;
+	short nodes[DEMOTION_TARGET_NODES];
+};
+
+static struct demotion_nodes *node_demotion __read_mostly;
 
 /**
  * next_demotion_node() - Get the next node in the demotion path
@@ -1148,8 +1174,15 @@ static int node_demotion[MAX_NUMNODES] _
  */
 int next_demotion_node(int node)
 {
+	struct demotion_nodes *nd;
+	unsigned short target_nr, index;
 	int target;
 
+	if (!node_demotion)
+		return NUMA_NO_NODE;
+
+	nd = &node_demotion[node];
+
 	/*
 	 * node_demotion[] is updated without excluding this
 	 * function from running.  RCU doesn't provide any
@@ -1160,9 +1193,28 @@ int next_demotion_node(int node)
 	 * node_demotion[] reads need to be consistent.
 	 */
 	rcu_read_lock();
-	target = READ_ONCE(node_demotion[node]);
-	rcu_read_unlock();
+	target_nr = READ_ONCE(nd->nr);
 
+	switch (target_nr) {
+	case 0:
+		target = NUMA_NO_NODE;
+		goto out;
+	case 1:
+		index = 0;
+		break;
+	default:
+		/*
+		 * If there are multiple target nodes, just select one
+		 * target node randomly.
+		 */
+		index = get_random_int() % target_nr;
+		break;
+	}
+
+	target = READ_ONCE(nd->nodes[index]);
+
+out:
+	rcu_read_unlock();
 	return target;
 }
 
@@ -3003,10 +3055,16 @@ EXPORT_SYMBOL(migrate_vma_finalize);
 /* Disable reclaim-based migration. */
 static void __disable_all_migrate_targets(void)
 {
-	int node;
+	int node, i;
 
-	for_each_online_node(node)
-		node_demotion[node] = NUMA_NO_NODE;
+	if (!node_demotion)
+		return;
+
+	for_each_online_node(node) {
+		node_demotion[node].nr = 0;
+		for (i = 0; i < DEMOTION_TARGET_NODES; i++)
+			node_demotion[node].nodes[i] = NUMA_NO_NODE;
+	}
 }
 
 static void disable_all_migrate_targets(void)
@@ -3033,26 +3091,40 @@ static void disable_all_migrate_targets(
  * Failing here is OK.  It might just indicate
  * being at the end of a chain.
  */
-static int establish_migrate_target(int node, nodemask_t *used)
+static int establish_migrate_target(int node, nodemask_t *used,
+				    int best_distance)
 {
-	int migration_target;
+	int migration_target, index, val;
+	struct demotion_nodes *nd;
 
-	/*
-	 * Can not set a migration target on a
-	 * node with it already set.
-	 *
-	 * No need for READ_ONCE() here since this
-	 * in the write path for node_demotion[].
-	 * This should be the only thread writing.
-	 */
-	if (node_demotion[node] != NUMA_NO_NODE)
+	if (!node_demotion)
 		return NUMA_NO_NODE;
 
+	nd = &node_demotion[node];
+
 	migration_target = find_next_best_node(node, used);
 	if (migration_target == NUMA_NO_NODE)
 		return NUMA_NO_NODE;
 
-	node_demotion[node] = migration_target;
+	/*
+	 * If the node has been set a migration target node before,
+	 * which means it's the best distance between them. Still
+	 * check if this node can be demoted to other target nodes
+	 * if they have a same best distance.
+	 */
+	if (best_distance != -1) {
+		val = node_distance(node, migration_target);
+		if (val > best_distance)
+			return NUMA_NO_NODE;
+	}
+
+	index = nd->nr;
+	if (WARN_ONCE(index >= DEMOTION_TARGET_NODES,
+		      "Exceeds maximum demotion target nodes\n"))
+		return NUMA_NO_NODE;
+
+	nd->nodes[index] = migration_target;
+	nd->nr++;
 
 	return migration_target;
 }
@@ -3068,7 +3140,9 @@ static int establish_migrate_target(int
  *
  * The difference here is that cycles must be avoided.  If
  * node0 migrates to node1, then neither node1, nor anything
- * node1 migrates to can migrate to node0.
+ * node1 migrates to can migrate to node0. Also one node can
+ * be migrated to multiple nodes if the target nodes all have
+ * a same best-distance against the source node.
  *
  * This function can run simultaneously with readers of
  * node_demotion[].  However, it can not run simultaneously
@@ -3080,7 +3154,7 @@ static void __set_migration_target_nodes
 	nodemask_t next_pass	= NODE_MASK_NONE;
 	nodemask_t this_pass	= NODE_MASK_NONE;
 	nodemask_t used_targets = NODE_MASK_NONE;
-	int node;
+	int node, best_distance;
 
 	/*
 	 * Avoid any oddities like cycles that could occur
@@ -3109,18 +3183,33 @@ again:
 	 * multiple source nodes to share a destination.
 	 */
 	nodes_or(used_targets, used_targets, this_pass);
-	for_each_node_mask(node, this_pass) {
-		int target_node = establish_migrate_target(node, &used_targets);
 
-		if (target_node == NUMA_NO_NODE)
-			continue;
+	for_each_node_mask(node, this_pass) {
+		best_distance = -1;
 
 		/*
-		 * Visit targets from this pass in the next pass.
-		 * Eventually, every node will have been part of
-		 * a pass, and will become set in 'used_targets'.
+		 * Try to set up the migration path for the node, and the target
+		 * migration nodes can be multiple, so doing a loop to find all
+		 * the target nodes if they all have a best node distance.
 		 */
-		node_set(target_node, next_pass);
+		do {
+			int target_node =
+				establish_migrate_target(node, &used_targets,
+							 best_distance);
+
+			if (target_node == NUMA_NO_NODE)
+				break;
+
+			if (best_distance == -1)
+				best_distance = node_distance(node, target_node);
+
+			/*
+			 * Visit targets from this pass in the next pass.
+			 * Eventually, every node will have been part of
+			 * a pass, and will become set in 'used_targets'.
+			 */
+			node_set(target_node, next_pass);
+		} while (1);
 	}
 	/*
 	 * 'next_pass' contains nodes which became migration
@@ -3221,6 +3310,11 @@ static int __init migrate_on_reclaim_ini
 {
 	int ret;
 
+	node_demotion = kmalloc_array(nr_node_ids,
+				      sizeof(struct demotion_nodes),
+				      GFP_KERNEL);
+	WARN_ON(!node_demotion);
+
 	ret = cpuhp_setup_state_nocalls(CPUHP_MM_DEMOTION_DEAD, "mm/demotion:offline",
 					NULL, migration_offline_cpu);
 	/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


