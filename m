From: akpm@linux-foundation.org
Subject: [merged] hotplug-update-nodemasks-management.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:52 -0800
Message-ID: <20121214232853.381B2200083@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:64202 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2LNX24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:56 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so208162eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, lliubbo@gmail.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hotplug: update nodemasks management
has been removed from the -mm tree.  Its filename was
     hotplug-update-nodemasks-management.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: hotplug: update nodemasks management

Update nodemasks management for N_MEMORY.

[lliubbo@gmail.com: fix build]
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |    5 +
 include/linux/memory.h           |    1 
 mm/memory_hotplug.c              |   87 ++++++++++++++++++++++++-----
 3 files changed, 77 insertions(+), 16 deletions(-)

diff -puN Documentation/memory-hotplug.txt~hotplug-update-nodemasks-management Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~hotplug-update-nodemasks-management
+++ a/Documentation/memory-hotplug.txt
@@ -390,6 +390,7 @@ struct memory_notify {
        unsigned long start_pfn;
        unsigned long nr_pages;
        int status_change_nid_normal;
+       int status_change_nid_high;
        int status_change_nid;
 }
 
@@ -397,7 +398,9 @@ start_pfn is start_pfn of online/offline
 nr_pages is # of pages of online/offline memory.
 status_change_nid_normal is set node id when N_NORMAL_MEMORY of nodemask
 is (will be) set/clear, if this is -1, then nodemask status is not changed.
-status_change_nid is set node id when N_HIGH_MEMORY of nodemask is (will be)
+status_change_nid_high is set node id when N_HIGH_MEMORY of nodemask
+is (will be) set/clear, if this is -1, then nodemask status is not changed.
+status_change_nid is set node id when N_MEMORY of nodemask is (will be)
 set/clear. It means a new(memoryless) node gets new memory by online and a
 node loses all memory. If this is -1, then nodemask status is not changed.
 If status_changed_nid* >= 0, callback should create/discard structures for the
diff -puN include/linux/memory.h~hotplug-update-nodemasks-management include/linux/memory.h
--- a/include/linux/memory.h~hotplug-update-nodemasks-management
+++ a/include/linux/memory.h
@@ -54,6 +54,7 @@ struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
 	int status_change_nid_normal;
+	int status_change_nid_high;
 	int status_change_nid;
 };
 
diff -puN mm/memory_hotplug.c~hotplug-update-nodemasks-management mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~hotplug-update-nodemasks-management
+++ a/mm/memory_hotplug.c
@@ -595,13 +595,15 @@ static void node_states_check_changes_on
 	enum zone_type zone_last = ZONE_NORMAL;
 
 	/*
-	 * If we have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
-	 * which have 0...ZONE_NORMAL, set zone_last to ZONE_NORMAL.
+	 * If we have HIGHMEM or movable node, node_states[N_NORMAL_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_NORMAL,
+	 * set zone_last to ZONE_NORMAL.
 	 *
-	 * If we don't have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
-	 * which have 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
+	 * If we don't have HIGHMEM nor movable node,
+	 * node_states[N_NORMAL_MEMORY] contains nodes which have zones of
+	 * 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
 	 */
-	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
+	if (N_MEMORY == N_NORMAL_MEMORY)
 		zone_last = ZONE_MOVABLE;
 
 	/*
@@ -615,12 +617,34 @@ static void node_states_check_changes_on
 	else
 		arg->status_change_nid_normal = -1;
 
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * If we have movable node, node_states[N_HIGH_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_HIGHMEM,
+	 * set zone_last to ZONE_HIGHMEM.
+	 *
+	 * If we don't have movable node, node_states[N_NORMAL_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_MOVABLE,
+	 * set zone_last to ZONE_MOVABLE.
+	 */
+	zone_last = ZONE_HIGHMEM;
+	if (N_MEMORY == N_HIGH_MEMORY)
+		zone_last = ZONE_MOVABLE;
+
+	if (zone_idx(zone) <= zone_last && !node_state(nid, N_HIGH_MEMORY))
+		arg->status_change_nid_high = nid;
+	else
+		arg->status_change_nid_high = -1;
+#else
+	arg->status_change_nid_high = arg->status_change_nid_normal;
+#endif
+
 	/*
 	 * if the node don't have memory befor online, we will need to
-	 * set the node to node_states[N_HIGH_MEMORY] after the memory
+	 * set the node to node_states[N_MEMORY] after the memory
 	 * is online.
 	 */
-	if (!node_state(nid, N_HIGH_MEMORY))
+	if (!node_state(nid, N_MEMORY))
 		arg->status_change_nid = nid;
 	else
 		arg->status_change_nid = -1;
@@ -631,7 +655,10 @@ static void node_states_set_node(int nod
 	if (arg->status_change_nid_normal >= 0)
 		node_set_state(node, N_NORMAL_MEMORY);
 
-	node_set_state(node, N_HIGH_MEMORY);
+	if (arg->status_change_nid_high >= 0)
+		node_set_state(node, N_HIGH_MEMORY);
+
+	node_set_state(node, N_MEMORY);
 }
 
 
@@ -1099,13 +1126,15 @@ static void node_states_check_changes_of
 	enum zone_type zt, zone_last = ZONE_NORMAL;
 
 	/*
-	 * If we have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
-	 * which have 0...ZONE_NORMAL, set zone_last to ZONE_NORMAL.
+	 * If we have HIGHMEM or movable node, node_states[N_NORMAL_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_NORMAL,
+	 * set zone_last to ZONE_NORMAL.
 	 *
-	 * If we don't have HIGHMEM, node_states[N_NORMAL_MEMORY] contains nodes
-	 * which have 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
+	 * If we don't have HIGHMEM nor movable node,
+	 * node_states[N_NORMAL_MEMORY] contains nodes which have zones of
+	 * 0...ZONE_MOVABLE, set zone_last to ZONE_MOVABLE.
 	 */
-	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
+	if (N_MEMORY == N_NORMAL_MEMORY)
 		zone_last = ZONE_MOVABLE;
 
 	/*
@@ -1122,6 +1151,30 @@ static void node_states_check_changes_of
 	else
 		arg->status_change_nid_normal = -1;
 
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * If we have movable node, node_states[N_HIGH_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_HIGHMEM,
+	 * set zone_last to ZONE_HIGHMEM.
+	 *
+	 * If we don't have movable node, node_states[N_NORMAL_MEMORY]
+	 * contains nodes which have zones of 0...ZONE_MOVABLE,
+	 * set zone_last to ZONE_MOVABLE.
+	 */
+	zone_last = ZONE_HIGHMEM;
+	if (N_MEMORY == N_HIGH_MEMORY)
+		zone_last = ZONE_MOVABLE;
+
+	for (; zt <= zone_last; zt++)
+		present_pages += pgdat->node_zones[zt].present_pages;
+	if (zone_idx(zone) <= zone_last && nr_pages >= present_pages)
+		arg->status_change_nid_high = zone_to_nid(zone);
+	else
+		arg->status_change_nid_high = -1;
+#else
+	arg->status_change_nid_high = arg->status_change_nid_normal;
+#endif
+
 	/*
 	 * node_states[N_HIGH_MEMORY] contains nodes which have 0...ZONE_MOVABLE
 	 */
@@ -1146,9 +1199,13 @@ static void node_states_clear_node(int n
 	if (arg->status_change_nid_normal >= 0)
 		node_clear_state(node, N_NORMAL_MEMORY);
 
-	if ((N_HIGH_MEMORY != N_NORMAL_MEMORY) &&
-	    (arg->status_change_nid >= 0))
+	if ((N_MEMORY != N_NORMAL_MEMORY) &&
+	    (arg->status_change_nid_high >= 0))
 		node_clear_state(node, N_HIGH_MEMORY);
+
+	if ((N_MEMORY != N_HIGH_MEMORY) &&
+	    (arg->status_change_nid >= 0))
+		node_clear_state(node, N_MEMORY);
 }
 
 static int __ref __offline_pages(unsigned long start_pfn,
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

