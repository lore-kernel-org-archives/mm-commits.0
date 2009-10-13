From: akpm@linux-foundation.org
Subject: + hugetlb-offload-per-node-attribute-registrations.patch added to -mm tree
Date: Tue, 13 Oct 2009 12:33:11 -0700
Message-ID: <200910131933.n9DJXBKP000328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934214AbZJMTei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 15:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nacc@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com


The patch titled
     hugetlb: offload per node attribute registrations
has been added to the -mm tree.  Its filename is
     hugetlb-offload-per-node-attribute-registrations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: offload per node attribute registrations
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Offload the registration and unregistration of per node hstate sysfs
attributes to a worker thread rather than attempt the
allocation/attachment or detachment/freeing of the attributes in the
context of the memory hotplug handler.

I don't know that this is absolutely required, but the registration can
sleep in allocations and other mem hot plug handlers do it this way.  If
it turns out this is NOT required, we can drop this patch.

N.B.,  Only tested build, boot, libhugetlbfs regression.
       i.e., no memory hotplug testing.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/base/node.c~hugetlb-offload-per-node-attribute-registrations drivers/base/node.c
--- a/drivers/base/node.c~hugetlb-offload-per-node-attribute-registrations
+++ a/drivers/base/node.c
@@ -186,11 +186,14 @@ static SYSDEV_ATTR(distance, S_IRUGO, no
 static node_registration_func_t __hugetlb_register_node;
 static node_registration_func_t __hugetlb_unregister_node;
 
-static inline void hugetlb_register_node(struct node *node)
+static inline bool hugetlb_register_node(struct node *node)
 {
 	if (__hugetlb_register_node &&
-			node_state(node->sysdev.id, N_HIGH_MEMORY))
+			node_state(node->sysdev.id, N_HIGH_MEMORY)) {
 		__hugetlb_register_node(node);
+		return true;
+	}
+	return false;
 }
 
 static inline void hugetlb_unregister_node(struct node *node)
@@ -387,10 +390,31 @@ static int link_mem_sections(int nid)
 	return err;
 }
 
+#ifdef CONFIG_HUGETLBFS
 /*
  * Handle per node hstate attribute [un]registration on transistions
  * to/from memoryless state.
  */
+static void node_hugetlb_work(struct work_struct *work)
+{
+	struct node *node = container_of(work, struct node, node_work);
+
+	/*
+	 * We only get here when a node transitions to/from memoryless state.
+	 * We can detect which transition occurred by examining whether the
+	 * node has memory now.  hugetlb_register_node() already check this
+	 * so we try to register the attributes.  If that fails, then the
+	 * node has transitioned to memoryless, try to unregister the
+	 * attributes.
+	 */
+	if (!hugetlb_register_node(node))
+		hugetlb_unregister_node(node);
+}
+
+static void init_node_hugetlb_work(int nid)
+{
+	INIT_WORK(&node_devices[nid].node_work, node_hugetlb_work);
+}
 
 static int node_memory_callback(struct notifier_block *self,
 				unsigned long action, void *arg)
@@ -399,14 +423,16 @@ static int node_memory_callback(struct n
 	int nid = mnb->status_change_nid;
 
 	switch (action) {
-	case MEM_ONLINE:    /* memory successfully brought online */
-		if (nid != NUMA_NO_NODE)
-			hugetlb_register_node(&node_devices[nid]);
-		break;
-	case MEM_OFFLINE:   /* or offline */
+	case MEM_ONLINE:
+	case MEM_OFFLINE:
+		/*
+		 * offload per node hstate [un]registration to a work thread
+		 * when transitioning to/from memoryless state.
+		 */
 		if (nid != NUMA_NO_NODE)
-			hugetlb_unregister_node(&node_devices[nid]);
+			schedule_work(&node_devices[nid].node_work);
 		break;
+
 	case MEM_GOING_ONLINE:
 	case MEM_GOING_OFFLINE:
 	case MEM_CANCEL_ONLINE:
@@ -417,7 +443,8 @@ static int node_memory_callback(struct n
 
 	return NOTIFY_OK;
 }
-#else
+#endif	/* CONFIG_HUGETLBFS */
+#else	/* !CONFIG_MEMORY_HOTPLUG_SPARSE */
 static int link_mem_sections(int nid) { return 0; }
 
 static inline int node_memory_callback(struct notifier_block *self,
@@ -425,6 +452,9 @@ static inline int node_memory_callback(s
 {
 	return NOTIFY_OK;
 }
+
+static void init_node_hugetlb_work(int nid) { }
+
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
 int register_one_node(int nid)
@@ -449,6 +479,9 @@ int register_one_node(int nid)
 
 		/* link memory sections under this node */
 		error = link_mem_sections(nid);
+
+		/* initialize work queue for memory hot plug */
+		init_node_hugetlb_work(nid);
 	}
 
 	return error;
diff -puN include/linux/node.h~hugetlb-offload-per-node-attribute-registrations include/linux/node.h
--- a/include/linux/node.h~hugetlb-offload-per-node-attribute-registrations
+++ a/include/linux/node.h
@@ -21,9 +21,14 @@
 
 #include <linux/sysdev.h>
 #include <linux/cpumask.h>
+#include <linux/workqueue.h>
 
 struct node {
 	struct sys_device	sysdev;
+
+#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
+	struct work_struct	node_work;
+#endif
 };
 
 struct memory_block;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch

