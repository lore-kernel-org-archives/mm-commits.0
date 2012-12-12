From: akpm@linux-foundation.org
Subject: [merged] numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:45 -0800
Message-ID: <20121212195745.DDC7082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40820 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2LLT5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:57:47 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so116564vbi.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: numa: convert static memory to dynamically allocated memory for per node device
has been removed from the -mm tree.  Its filename was
     numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: numa: convert static memory to dynamically allocated memory for per node device

We use a static array to store struct node.  In many cases, we don't have
too many nodes, and some memory will be unused.  Convert it to per-device
dynamically allocated memory.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/sysfs.c |    4 +--
 drivers/base/node.c         |   38 +++++++++++++++++++---------------
 include/linux/node.h        |    2 -
 mm/hugetlb.c                |    4 +--
 4 files changed, 27 insertions(+), 21 deletions(-)

diff -puN arch/powerpc/kernel/sysfs.c~numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device arch/powerpc/kernel/sysfs.c
--- a/arch/powerpc/kernel/sysfs.c~numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device
+++ a/arch/powerpc/kernel/sysfs.c
@@ -607,7 +607,7 @@ static void register_nodes(void)
 
 int sysfs_add_device_to_node(struct device *dev, int nid)
 {
-	struct node *node = &node_devices[nid];
+	struct node *node = node_devices[nid];
 	return sysfs_create_link(&node->dev.kobj, &dev->kobj,
 			kobject_name(&dev->kobj));
 }
@@ -615,7 +615,7 @@ EXPORT_SYMBOL_GPL(sysfs_add_device_to_no
 
 void sysfs_remove_device_from_node(struct device *dev, int nid)
 {
-	struct node *node = &node_devices[nid];
+	struct node *node = node_devices[nid];
 	sysfs_remove_link(&node->dev.kobj, kobject_name(&dev->kobj));
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_device_from_node);
diff -puN drivers/base/node.c~numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device drivers/base/node.c
--- a/drivers/base/node.c~numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device
+++ a/drivers/base/node.c
@@ -306,7 +306,7 @@ void unregister_node(struct node *node)
 	device_unregister(&node->dev);
 }
 
-struct node node_devices[MAX_NUMNODES];
+struct node *node_devices[MAX_NUMNODES];
 
 /*
  * register cpu under node
@@ -323,15 +323,15 @@ int register_cpu_under_node(unsigned int
 	if (!obj)
 		return 0;
 
-	ret = sysfs_create_link(&node_devices[nid].dev.kobj,
+	ret = sysfs_create_link(&node_devices[nid]->dev.kobj,
 				&obj->kobj,
 				kobject_name(&obj->kobj));
 	if (ret)
 		return ret;
 
 	return sysfs_create_link(&obj->kobj,
-				 &node_devices[nid].dev.kobj,
-				 kobject_name(&node_devices[nid].dev.kobj));
+				 &node_devices[nid]->dev.kobj,
+				 kobject_name(&node_devices[nid]->dev.kobj));
 }
 
 int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
@@ -345,10 +345,10 @@ int unregister_cpu_under_node(unsigned i
 	if (!obj)
 		return 0;
 
-	sysfs_remove_link(&node_devices[nid].dev.kobj,
+	sysfs_remove_link(&node_devices[nid]->dev.kobj,
 			  kobject_name(&obj->kobj));
 	sysfs_remove_link(&obj->kobj,
-			  kobject_name(&node_devices[nid].dev.kobj));
+			  kobject_name(&node_devices[nid]->dev.kobj));
 
 	return 0;
 }
@@ -390,15 +390,15 @@ int register_mem_sect_under_node(struct 
 			continue;
 		if (page_nid != nid)
 			continue;
-		ret = sysfs_create_link_nowarn(&node_devices[nid].dev.kobj,
+		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 					&mem_blk->dev.kobj,
 					kobject_name(&mem_blk->dev.kobj));
 		if (ret)
 			return ret;
 
 		return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
-				&node_devices[nid].dev.kobj,
-				kobject_name(&node_devices[nid].dev.kobj));
+				&node_devices[nid]->dev.kobj,
+				kobject_name(&node_devices[nid]->dev.kobj));
 	}
 	/* mem section does not span the specified node */
 	return 0;
@@ -431,10 +431,10 @@ int unregister_mem_sect_under_nodes(stru
 			continue;
 		if (node_test_and_set(nid, *unlinked_nodes))
 			continue;
-		sysfs_remove_link(&node_devices[nid].dev.kobj,
+		sysfs_remove_link(&node_devices[nid]->dev.kobj,
 			 kobject_name(&mem_blk->dev.kobj));
 		sysfs_remove_link(&mem_blk->dev.kobj,
-			 kobject_name(&node_devices[nid].dev.kobj));
+			 kobject_name(&node_devices[nid]->dev.kobj));
 	}
 	NODEMASK_FREE(unlinked_nodes);
 	return 0;
@@ -500,7 +500,7 @@ static void node_hugetlb_work(struct wor
 
 static void init_node_hugetlb_work(int nid)
 {
-	INIT_WORK(&node_devices[nid].node_work, node_hugetlb_work);
+	INIT_WORK(&node_devices[nid]->node_work, node_hugetlb_work);
 }
 
 static int node_memory_callback(struct notifier_block *self,
@@ -517,7 +517,7 @@ static int node_memory_callback(struct n
 		 * when transitioning to/from memoryless state.
 		 */
 		if (nid != NUMA_NO_NODE)
-			schedule_work(&node_devices[nid].node_work);
+			schedule_work(&node_devices[nid]->node_work);
 		break;
 
 	case MEM_GOING_ONLINE:
@@ -558,9 +558,13 @@ int register_one_node(int nid)
 		struct node *parent = NULL;
 
 		if (p_node != nid)
-			parent = &node_devices[p_node];
+			parent = node_devices[p_node];
 
-		error = register_node(&node_devices[nid], nid, parent);
+		node_devices[nid] = kzalloc(sizeof(struct node), GFP_KERNEL);
+		if (!node_devices[nid])
+			return -ENOMEM;
+
+		error = register_node(node_devices[nid], nid, parent);
 
 		/* link cpu under this node */
 		for_each_present_cpu(cpu) {
@@ -581,7 +585,9 @@ int register_one_node(int nid)
 
 void unregister_one_node(int nid)
 {
-	unregister_node(&node_devices[nid]);
+	unregister_node(node_devices[nid]);
+	kfree(node_devices[nid]);
+	node_devices[nid] = NULL;
 }
 
 /*
diff -puN include/linux/node.h~numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device include/linux/node.h
--- a/include/linux/node.h~numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device
+++ a/include/linux/node.h
@@ -27,7 +27,7 @@ struct node {
 };
 
 struct memory_block;
-extern struct node node_devices[];
+extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
 extern int register_node(struct node *, int, struct node *);
diff -puN mm/hugetlb.c~numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device mm/hugetlb.c
--- a/mm/hugetlb.c~numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device
+++ a/mm/hugetlb.c
@@ -1800,7 +1800,7 @@ static void hugetlb_unregister_all_nodes
 	 * remove hstate attributes from any nodes that have them.
 	 */
 	for (nid = 0; nid < nr_node_ids; nid++)
-		hugetlb_unregister_node(&node_devices[nid]);
+		hugetlb_unregister_node(node_devices[nid]);
 }
 
 /*
@@ -1845,7 +1845,7 @@ static void hugetlb_register_all_nodes(v
 	int nid;
 
 	for_each_node_state(nid, N_HIGH_MEMORY) {
-		struct node *node = &node_devices[nid];
+		struct node *node = node_devices[nid];
 		if (node->dev.id == nid)
 			hugetlb_register_node(node);
 	}
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
hotplug-update-nodemasks-management-fix.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
linux-next.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

