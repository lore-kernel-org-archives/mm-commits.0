Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E11C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377878AbiATV1j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58590 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377879AbiATV1i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69263B81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94760C340E0;
        Thu, 20 Jan 2022 21:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714056;
        bh=pyq/imQtV32xu0qgeDos2WlhZp37MTMTi94r1j3fvfs=;
        h=Date:From:To:Subject:From;
        b=QXr3krczx+UTW6EuiU5XH/A1RIVe9C6XkXUQHHz9YsNUi72fkw4+u+/ofXcdCKfRn
         kRC474lrrR4EUYNLAzSjG/crrTDRfhhGAWSFBfYRcWPfY9uGosDyoEDfW1PFtzUG6f
         +eocJGlqfe6ZGe3o2sQTuyQ3vqAcayGOEJgLQxcE=
Date:   Thu, 20 Jan 2022 13:27:35 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com, gthelen@google.com,
        kbusch@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, rientjes@google.com, shy828301@gmail.com,
        weixugc@google.com, yang.shi@linux.alibaba.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-move-node-demotion-code-to-near-its-user.patch removed from -mm
 tree
Message-ID: <20220120212735.zNs00dsRe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: move node demotion code to near its user
has been removed from the -mm tree.  Its filename was
     mm-migrate-move-node-demotion-code-to-near-its-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm/migrate: move node demotion code to near its user

Now, node_demotion and next_demotion_node() are placed between
__unmap_and_move() and unmap_and_move().  This hurts code readability.  So
move them near their users in the file.  There's no functionality change
in this patch.

Link: https://lkml.kernel.org/r/20211206031227.3323097-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Wei Xu <weixugc@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  265 ++++++++++++++++++++++++-------------------------
 1 file changed, 132 insertions(+), 133 deletions(-)

--- a/mm/migrate.c~mm-migrate-move-node-demotion-code-to-near-its-user
+++ a/mm/migrate.c
@@ -1093,139 +1093,6 @@ out:
 	return rc;
 }
 
-
-/*
- * node_demotion[] example:
- *
- * Consider a system with two sockets.  Each socket has
- * three classes of memory attached: fast, medium and slow.
- * Each memory class is placed in its own NUMA node.  The
- * CPUs are placed in the node with the "fast" memory.  The
- * 6 NUMA nodes (0-5) might be split among the sockets like
- * this:
- *
- *	Socket A: 0, 1, 2
- *	Socket B: 3, 4, 5
- *
- * When Node 0 fills up, its memory should be migrated to
- * Node 1.  When Node 1 fills up, it should be migrated to
- * Node 2.  The migration path start on the nodes with the
- * processors (since allocations default to this node) and
- * fast memory, progress through medium and end with the
- * slow memory:
- *
- *	0 -> 1 -> 2 -> stop
- *	3 -> 4 -> 5 -> stop
- *
- * This is represented in the node_demotion[] like this:
- *
- *	{  nr=1, nodes[0]=1 }, // Node 0 migrates to 1
- *	{  nr=1, nodes[0]=2 }, // Node 1 migrates to 2
- *	{  nr=0, nodes[0]=-1 }, // Node 2 does not migrate
- *	{  nr=1, nodes[0]=4 }, // Node 3 migrates to 4
- *	{  nr=1, nodes[0]=5 }, // Node 4 migrates to 5
- *	{  nr=0, nodes[0]=-1 }, // Node 5 does not migrate
- *
- * Moreover some systems may have multiple slow memory nodes.
- * Suppose a system has one socket with 3 memory nodes, node 0
- * is fast memory type, and node 1/2 both are slow memory
- * type, and the distance between fast memory node and slow
- * memory node is same. So the migration path should be:
- *
- *	0 -> 1/2 -> stop
- *
- * This is represented in the node_demotion[] like this:
- *	{ nr=2, {nodes[0]=1, nodes[1]=2} }, // Node 0 migrates to node 1 and node 2
- *	{ nr=0, nodes[0]=-1, }, // Node 1 dose not migrate
- *	{ nr=0, nodes[0]=-1, }, // Node 2 does not migrate
- */
-
-/*
- * Writes to this array occur without locking.  Cycles are
- * not allowed: Node X demotes to Y which demotes to X...
- *
- * If multiple reads are performed, a single rcu_read_lock()
- * must be held over all reads to ensure that no cycles are
- * observed.
- */
-#define DEFAULT_DEMOTION_TARGET_NODES 15
-
-#if MAX_NUMNODES < DEFAULT_DEMOTION_TARGET_NODES
-#define DEMOTION_TARGET_NODES	(MAX_NUMNODES - 1)
-#else
-#define DEMOTION_TARGET_NODES	DEFAULT_DEMOTION_TARGET_NODES
-#endif
-
-struct demotion_nodes {
-	unsigned short nr;
-	short nodes[DEMOTION_TARGET_NODES];
-};
-
-static struct demotion_nodes *node_demotion __read_mostly;
-
-/**
- * next_demotion_node() - Get the next node in the demotion path
- * @node: The starting node to lookup the next node
- *
- * Return: node id for next memory node in the demotion path hierarchy
- * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
- * @node online or guarantee that it *continues* to be the next demotion
- * target.
- */
-int next_demotion_node(int node)
-{
-	struct demotion_nodes *nd;
-	unsigned short target_nr, index;
-	int target;
-
-	if (!node_demotion)
-		return NUMA_NO_NODE;
-
-	nd = &node_demotion[node];
-
-	/*
-	 * node_demotion[] is updated without excluding this
-	 * function from running.  RCU doesn't provide any
-	 * compiler barriers, so the READ_ONCE() is required
-	 * to avoid compiler reordering or read merging.
-	 *
-	 * Make sure to use RCU over entire code blocks if
-	 * node_demotion[] reads need to be consistent.
-	 */
-	rcu_read_lock();
-	target_nr = READ_ONCE(nd->nr);
-
-	switch (target_nr) {
-	case 0:
-		target = NUMA_NO_NODE;
-		goto out;
-	case 1:
-		index = 0;
-		break;
-	default:
-		/*
-		 * If there are multiple target nodes, just select one
-		 * target node randomly.
-		 *
-		 * In addition, we can also use round-robin to select
-		 * target node, but we should introduce another variable
-		 * for node_demotion[] to record last selected target node,
-		 * that may cause cache ping-pong due to the changing of
-		 * last target node. Or introducing per-cpu data to avoid
-		 * caching issue, which seems more complicated. So selecting
-		 * target node randomly seems better until now.
-		 */
-		index = get_random_int() % target_nr;
-		break;
-	}
-
-	target = READ_ONCE(nd->nodes[index]);
-
-out:
-	rcu_read_unlock();
-	return target;
-}
-
 /*
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
@@ -3059,6 +2926,138 @@ void migrate_vma_finalize(struct migrate
 EXPORT_SYMBOL(migrate_vma_finalize);
 #endif /* CONFIG_DEVICE_PRIVATE */
 
+/*
+ * node_demotion[] example:
+ *
+ * Consider a system with two sockets.  Each socket has
+ * three classes of memory attached: fast, medium and slow.
+ * Each memory class is placed in its own NUMA node.  The
+ * CPUs are placed in the node with the "fast" memory.  The
+ * 6 NUMA nodes (0-5) might be split among the sockets like
+ * this:
+ *
+ *	Socket A: 0, 1, 2
+ *	Socket B: 3, 4, 5
+ *
+ * When Node 0 fills up, its memory should be migrated to
+ * Node 1.  When Node 1 fills up, it should be migrated to
+ * Node 2.  The migration path start on the nodes with the
+ * processors (since allocations default to this node) and
+ * fast memory, progress through medium and end with the
+ * slow memory:
+ *
+ *	0 -> 1 -> 2 -> stop
+ *	3 -> 4 -> 5 -> stop
+ *
+ * This is represented in the node_demotion[] like this:
+ *
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
+ */
+
+/*
+ * Writes to this array occur without locking.  Cycles are
+ * not allowed: Node X demotes to Y which demotes to X...
+ *
+ * If multiple reads are performed, a single rcu_read_lock()
+ * must be held over all reads to ensure that no cycles are
+ * observed.
+ */
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
+
+/**
+ * next_demotion_node() - Get the next node in the demotion path
+ * @node: The starting node to lookup the next node
+ *
+ * Return: node id for next memory node in the demotion path hierarchy
+ * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
+ * @node online or guarantee that it *continues* to be the next demotion
+ * target.
+ */
+int next_demotion_node(int node)
+{
+	struct demotion_nodes *nd;
+	unsigned short target_nr, index;
+	int target;
+
+	if (!node_demotion)
+		return NUMA_NO_NODE;
+
+	nd = &node_demotion[node];
+
+	/*
+	 * node_demotion[] is updated without excluding this
+	 * function from running.  RCU doesn't provide any
+	 * compiler barriers, so the READ_ONCE() is required
+	 * to avoid compiler reordering or read merging.
+	 *
+	 * Make sure to use RCU over entire code blocks if
+	 * node_demotion[] reads need to be consistent.
+	 */
+	rcu_read_lock();
+	target_nr = READ_ONCE(nd->nr);
+
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
+		 *
+		 * In addition, we can also use round-robin to select
+		 * target node, but we should introduce another variable
+		 * for node_demotion[] to record last selected target node,
+		 * that may cause cache ping-pong due to the changing of
+		 * last target node. Or introducing per-cpu data to avoid
+		 * caching issue, which seems more complicated. So selecting
+		 * target node randomly seems better until now.
+		 */
+		index = get_random_int() % target_nr;
+		break;
+	}
+
+	target = READ_ONCE(nd->nodes[index]);
+
+out:
+	rcu_read_unlock();
+	return target;
+}
+
 #if defined(CONFIG_HOTPLUG_CPU)
 /* Disable reclaim-based migration. */
 static void __disable_all_migrate_targets(void)
_

Patches currently in -mm which might be from ying.huang@intel.com are


