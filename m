Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB409ECAAD3
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 22:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiINW2s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiINW2f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 18:28:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0A23BC51
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 15:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C89C4B81B5B
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 22:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB84C433D6;
        Wed, 14 Sep 2022 22:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663194511;
        bh=CfiES0NpnU8tdE90lKmrsAIcothH+LRS0VdsbuCD9qQ=;
        h=Date:To:From:Subject:From;
        b=nnAQluZxrUuLrZ38rS/cH4ASUWkidDrDgYD6/XMTO3DzIpeQnRP1MeMkxqYEean0y
         J5N72fbEPkbvTMARGC+wWcb9gRQiW/6IvfzByhpYnd/Q3Ym+JYykL+yC5vMVN21N7G
         Nb1B3sS2wGODzIPnYmHzVLaDIPfO3agDoy9J0Ss8=
Date:   Wed, 14 Sep 2022 15:28:30 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, gregkh@linuxfoundation.org,
        david@redhat.com, andi@firstfloor.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-simplify-per-node-sysfs-creation-and-removal.patch added to mm-unstable branch
Message-Id: <20220914222831.6BB84C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: simplify per-node sysfs creation and removal
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-simplify-per-node-sysfs-creation-and-removal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-simplify-per-node-sysfs-creation-and-removal.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: simplify per-node sysfs creation and removal
Date: Wed, 14 Sep 2022 15:26:02 +0800

Patch series "simplify handling of per-node sysfs creation and removal",
v4.


This patch (of 2):

The following commit offload per-node sysfs creation and removal to a
kworker and did not say why it is needed.  And it also said "I don't know
that this is absolutely required".  It seems like the author was not sure
as well.  Since it only complicates the code, this patch will revert the
changes to simplify the code.

  39da08cb074c ("hugetlb: offload per node attribute registrations")

We could use memory hotplug notifier to do per-node sysfs creation and
removal instead of inserting those operations to node registration and
unregistration.  Then, it can reduce the code coupling between node.c and
hugetlb.c.  Also, it can simplify the code.

Link: https://lkml.kernel.org/r/20220914072603.60293-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220914072603.60293-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |  139 -----------------------------------------
 include/linux/node.h |   24 +------
 mm/hugetlb.c         |   35 ++++++----
 3 files changed, 30 insertions(+), 168 deletions(-)

--- a/drivers/base/node.c~mm-hugetlb-simplify-per-node-sysfs-creation-and-removal
+++ a/drivers/base/node.c
@@ -587,64 +587,9 @@ static const struct attribute_group *nod
 	NULL
 };
 
-#ifdef CONFIG_HUGETLBFS
-/*
- * hugetlbfs per node attributes registration interface:
- * When/if hugetlb[fs] subsystem initializes [sometime after this module],
- * it will register its per node attributes for all online nodes with
- * memory.  It will also call register_hugetlbfs_with_node(), below, to
- * register its attribute registration functions with this node driver.
- * Once these hooks have been initialized, the node driver will call into
- * the hugetlb module to [un]register attributes for hot-plugged nodes.
- */
-static node_registration_func_t __hugetlb_register_node;
-static node_registration_func_t __hugetlb_unregister_node;
-
-static inline bool hugetlb_register_node(struct node *node)
-{
-	if (__hugetlb_register_node &&
-			node_state(node->dev.id, N_MEMORY)) {
-		__hugetlb_register_node(node);
-		return true;
-	}
-	return false;
-}
-
-static inline void hugetlb_unregister_node(struct node *node)
-{
-	if (__hugetlb_unregister_node)
-		__hugetlb_unregister_node(node);
-}
-
-void register_hugetlbfs_with_node(node_registration_func_t doregister,
-				  node_registration_func_t unregister)
-{
-	__hugetlb_register_node   = doregister;
-	__hugetlb_unregister_node = unregister;
-}
-#else
-static inline void hugetlb_register_node(struct node *node) {}
-
-static inline void hugetlb_unregister_node(struct node *node) {}
-#endif
-
 static void node_device_release(struct device *dev)
 {
-	struct node *node = to_node(dev);
-
-#if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_HUGETLBFS)
-	/*
-	 * We schedule the work only when a memory section is
-	 * onlined/offlined on this node. When we come here,
-	 * all the memory on this node has been offlined,
-	 * so we won't enqueue new work to this work.
-	 *
-	 * The work is using node->node_work, so we should
-	 * flush work before freeing the memory.
-	 */
-	flush_work(&node->node_work);
-#endif
-	kfree(node);
+	kfree(to_node(dev));
 }
 
 /*
@@ -665,11 +610,9 @@ static int register_node(struct node *no
 
 	if (error)
 		put_device(&node->dev);
-	else {
-		hugetlb_register_node(node);
-
+	else
 		compaction_register_node(node);
-	}
+
 	return error;
 }
 
@@ -683,7 +626,6 @@ static int register_node(struct node *no
 void unregister_node(struct node *node)
 {
 	compaction_unregister_node(node);
-	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 	node_remove_accesses(node);
 	node_remove_caches(node);
 	device_unregister(&node->dev);
@@ -905,74 +847,8 @@ void register_memory_blocks_under_node(i
 			   (void *)&nid, func);
 	return;
 }
-
-#ifdef CONFIG_HUGETLBFS
-/*
- * Handle per node hstate attribute [un]registration on transistions
- * to/from memoryless state.
- */
-static void node_hugetlb_work(struct work_struct *work)
-{
-	struct node *node = container_of(work, struct node, node_work);
-
-	/*
-	 * We only get here when a node transitions to/from memoryless state.
-	 * We can detect which transition occurred by examining whether the
-	 * node has memory now.  hugetlb_register_node() already check this
-	 * so we try to register the attributes.  If that fails, then the
-	 * node has transitioned to memoryless, try to unregister the
-	 * attributes.
-	 */
-	if (!hugetlb_register_node(node))
-		hugetlb_unregister_node(node);
-}
-
-static void init_node_hugetlb_work(int nid)
-{
-	INIT_WORK(&node_devices[nid]->node_work, node_hugetlb_work);
-}
-
-static int node_memory_callback(struct notifier_block *self,
-				unsigned long action, void *arg)
-{
-	struct memory_notify *mnb = arg;
-	int nid = mnb->status_change_nid;
-
-	switch (action) {
-	case MEM_ONLINE:
-	case MEM_OFFLINE:
-		/*
-		 * offload per node hstate [un]registration to a work thread
-		 * when transitioning to/from memoryless state.
-		 */
-		if (nid != NUMA_NO_NODE)
-			schedule_work(&node_devices[nid]->node_work);
-		break;
-
-	case MEM_GOING_ONLINE:
-	case MEM_GOING_OFFLINE:
-	case MEM_CANCEL_ONLINE:
-	case MEM_CANCEL_OFFLINE:
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-#endif	/* CONFIG_HUGETLBFS */
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-#if !defined(CONFIG_MEMORY_HOTPLUG) || !defined(CONFIG_HUGETLBFS)
-static inline int node_memory_callback(struct notifier_block *self,
-				unsigned long action, void *arg)
-{
-	return NOTIFY_OK;
-}
-
-static void init_node_hugetlb_work(int nid) { }
-
-#endif
-
 int __register_one_node(int nid)
 {
 	int error;
@@ -991,8 +867,6 @@ int __register_one_node(int nid)
 	}
 
 	INIT_LIST_HEAD(&node_devices[nid]->access_list);
-	/* initialize work queue for memory hot plug */
-	init_node_hugetlb_work(nid);
 	node_init_caches(nid);
 
 	return error;
@@ -1063,13 +937,8 @@ static const struct attribute_group *cpu
 	NULL,
 };
 
-#define NODE_CALLBACK_PRI	2	/* lower than SLAB */
 void __init node_dev_init(void)
 {
-	static struct notifier_block node_memory_callback_nb = {
-		.notifier_call = node_memory_callback,
-		.priority = NODE_CALLBACK_PRI,
-	};
 	int ret, i;
 
  	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != NR_NODE_STATES);
@@ -1079,8 +948,6 @@ void __init node_dev_init(void)
 	if (ret)
 		panic("%s() failed to register subsystem: %d\n", __func__, ret);
 
-	register_hotmemory_notifier(&node_memory_callback_nb);
-
 	/*
 	 * Create all node devices, which will properly link the node
 	 * to applicable memory block devices and already created cpu devices.
--- a/include/linux/node.h~mm-hugetlb-simplify-per-node-sysfs-creation-and-removal
+++ a/include/linux/node.h
@@ -2,15 +2,15 @@
 /*
  * include/linux/node.h - generic node definition
  *
- * This is mainly for topological representation. We define the 
- * basic 'struct node' here, which can be embedded in per-arch 
+ * This is mainly for topological representation. We define the
+ * basic 'struct node' here, which can be embedded in per-arch
  * definitions of processors.
  *
  * Basic handling of the devices is done in drivers/base/node.c
- * and system devices are handled in drivers/base/sys.c. 
+ * and system devices are handled in drivers/base/sys.c.
  *
  * Nodes are exported via driverfs in the class/node/devices/
- * directory. 
+ * directory.
  */
 #ifndef _LINUX_NODE_H_
 #define _LINUX_NODE_H_
@@ -18,7 +18,6 @@
 #include <linux/device.h>
 #include <linux/cpumask.h>
 #include <linux/list.h>
-#include <linux/workqueue.h>
 
 /**
  * struct node_hmem_attrs - heterogeneous memory performance attributes
@@ -84,10 +83,6 @@ static inline void node_set_perf_attrs(u
 struct node {
 	struct device	dev;
 	struct list_head access_list;
-
-#if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_HUGETLBFS)
-	struct work_struct	node_work;
-#endif
 #ifdef CONFIG_HMEM_REPORTING
 	struct list_head cache_attrs;
 	struct device *cache_dev;
@@ -96,7 +91,6 @@ struct node {
 
 struct memory_block;
 extern struct node *node_devices[];
-typedef  void (*node_registration_func_t)(struct node *);
 
 #if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
 void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
@@ -144,11 +138,6 @@ extern void unregister_memory_block_unde
 extern int register_memory_node_under_compute_node(unsigned int mem_nid,
 						   unsigned int cpu_nid,
 						   unsigned access);
-
-#ifdef CONFIG_HUGETLBFS
-extern void register_hugetlbfs_with_node(node_registration_func_t doregister,
-					 node_registration_func_t unregister);
-#endif
 #else
 static inline void node_dev_init(void)
 {
@@ -176,11 +165,6 @@ static inline int unregister_cpu_under_n
 static inline void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 {
 }
-
-static inline void register_hugetlbfs_with_node(node_registration_func_t reg,
-						node_registration_func_t unreg)
-{
-}
 #endif
 
 #define to_node(device) container_of(device, struct node, dev)
--- a/mm/hugetlb.c~mm-hugetlb-simplify-per-node-sysfs-creation-and-removal
+++ a/mm/hugetlb.c
@@ -33,6 +33,7 @@
 #include <linux/migrate.h>
 #include <linux/nospec.h>
 #include <linux/delayacct.h>
+#include <linux/memory.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -4000,6 +4001,23 @@ static void hugetlb_register_node(struct
 	}
 }
 
+static int __meminit hugetlb_memory_callback(struct notifier_block *self,
+					     unsigned long action, void *arg)
+{
+	struct memory_notify *mnb = arg;
+	int nid = mnb->status_change_nid;
+
+	if (nid == NUMA_NO_NODE)
+		return NOTIFY_DONE;
+
+	if (action == MEM_GOING_ONLINE)
+		hugetlb_register_node(node_devices[nid]);
+	else if (action == MEM_CANCEL_ONLINE || action == MEM_OFFLINE)
+		hugetlb_unregister_node(node_devices[nid]);
+
+	return NOTIFY_OK;
+}
+
 /*
  * hugetlb init time:  register hstate attributes for all registered node
  * devices of nodes that have memory.  All on-line nodes should have
@@ -4009,18 +4027,11 @@ static void __init hugetlb_register_all_
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY) {
-		struct node *node = node_devices[nid];
-		if (node->dev.id == nid)
-			hugetlb_register_node(node);
-	}
-
-	/*
-	 * Let the node device driver know we're here so it can
-	 * [un]register hstate attributes on node hotplug.
-	 */
-	register_hugetlbfs_with_node(hugetlb_register_node,
-				     hugetlb_unregister_node);
+	get_online_mems();
+	hotplug_memory_notifier(hugetlb_memory_callback, 0);
+	for_each_node_state(nid, N_MEMORY)
+		hugetlb_register_node(node_devices[nid]);
+	put_online_mems();
 }
 #else	/* !CONFIG_NUMA */
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-simplify-per-node-sysfs-creation-and-removal.patch
mm-hugetlb-eliminate-memory-less-nodes-handling.patch

