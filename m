From: akpm@linux-foundation.org
Subject: [merged] hugetlb-handle-memory-hot-plug-events.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:51:20 -0800
Message-ID: <200912152151.nBFLpKkN015022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761219AbZLOVw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nacc@us.ib


The patch titled
     hugetlb: handle memory hot-plug events
has been removed from the -mm tree.  Its filename was
     hugetlb-handle-memory-hot-plug-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: handle memory hot-plug events
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Register per node hstate attributes only for nodes with memory.  As
suggested by David Rientjes.

With Memory Hotplug, memory can be added to a memoryless node and a node
with memory can become memoryless.  Therefore, add a memory on/off-line
notifier callback to [un]register a node's attributes on transition
to/from memoryless state.

N.B.,  Only tested build, boot, libhugetlbfs regression.
       i.e., no memory hotplug testing.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |    3 +
 drivers/base/node.c              |   53 ++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 6 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~hugetlb-handle-memory-hot-plug-events Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlb-handle-memory-hot-plug-events
+++ a/Documentation/vm/hugetlbpage.txt
@@ -231,7 +231,8 @@ resulting effect on persistent huge page
 Per Node Hugepages Attributes
 
 A subset of the contents of the root huge page control directory in sysfs,
-described above, has been replicated under each "node" system device in:
+described above, will be replicated under each the system device of each
+NUMA node with memory in:
 
 	/sys/devices/system/node/node[0-9]*/hugepages/
 
diff -puN drivers/base/node.c~hugetlb-handle-memory-hot-plug-events drivers/base/node.c
--- a/drivers/base/node.c~hugetlb-handle-memory-hot-plug-events
+++ a/drivers/base/node.c
@@ -177,8 +177,8 @@ static SYSDEV_ATTR(distance, S_IRUGO, no
 /*
  * hugetlbfs per node attributes registration interface:
  * When/if hugetlb[fs] subsystem initializes [sometime after this module],
- * it will register its per node attributes for all nodes online at that
- * time.  It will also call register_hugetlbfs_with_node(), below, to
+ * it will register its per node attributes for all online nodes with
+ * memory.  It will also call register_hugetlbfs_with_node(), below, to
  * register its attribute registration functions with this node driver.
  * Once these hooks have been initialized, the node driver will call into
  * the hugetlb module to [un]register attributes for hot-plugged nodes.
@@ -188,7 +188,8 @@ static node_registration_func_t __hugetl
 
 static inline void hugetlb_register_node(struct node *node)
 {
-	if (__hugetlb_register_node)
+	if (__hugetlb_register_node &&
+			node_state(node->sysdev.id, N_HIGH_MEMORY))
 		__hugetlb_register_node(node);
 }
 
@@ -233,6 +234,7 @@ int register_node(struct node *node, int
 		sysdev_create_file(&node->sysdev, &attr_distance);
 
 		scan_unevictable_register_node(node);
+
 		hugetlb_register_node(node);
 	}
 	return error;
@@ -254,7 +256,7 @@ void unregister_node(struct node *node)
 	sysdev_remove_file(&node->sysdev, &attr_distance);
 
 	scan_unevictable_unregister_node(node);
-	hugetlb_unregister_node(node);
+	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 
 	sysdev_unregister(&node->sysdev);
 }
@@ -384,8 +386,45 @@ static int link_mem_sections(int nid)
 	}
 	return err;
 }
+
+/*
+ * Handle per node hstate attribute [un]registration on transistions
+ * to/from memoryless state.
+ */
+
+static int node_memory_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	struct memory_notify *mnb = arg;
+	int nid = mnb->status_change_nid;
+
+	switch (action) {
+	case MEM_ONLINE:    /* memory successfully brought online */
+		if (nid != NUMA_NO_NODE)
+			hugetlb_register_node(&node_devices[nid]);
+		break;
+	case MEM_OFFLINE:   /* or offline */
+		if (nid != NUMA_NO_NODE)
+			hugetlb_unregister_node(&node_devices[nid]);
+		break;
+	case MEM_GOING_ONLINE:
+	case MEM_GOING_OFFLINE:
+	case MEM_CANCEL_ONLINE:
+	case MEM_CANCEL_OFFLINE:
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
 #else
 static int link_mem_sections(int nid) { return 0; }
+
+static inline int node_memory_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	return NOTIFY_OK;
+}
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
 int register_one_node(int nid)
@@ -499,13 +538,17 @@ static int node_states_init(void)
 	return err;
 }
 
+#define NODE_CALLBACK_PRI	2	/* lower than SLAB */
 static int __init register_node_type(void)
 {
 	int ret;
 
 	ret = sysdev_class_register(&node_class);
-	if (!ret)
+	if (!ret) {
 		ret = node_states_init();
+		hotplug_memory_notifier(node_memory_callback,
+					NODE_CALLBACK_PRI);
+	}
 
 	/*
 	 * Note:  we're not going to unregister the node class if we fail
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch

