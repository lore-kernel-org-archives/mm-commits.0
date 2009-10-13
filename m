From: akpm@linux-foundation.org
Subject: + hugetlb-add-per-node-hstate-attributes.patch added to -mm tree
Date: Tue, 13 Oct 2009 12:32:55 -0700
Message-ID: <200910131932.n9DJWu5M032317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934215AbZJMTei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 15:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nacc@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com


The patch titled
     hugetlb: add per node hstate attributes
has been added to the -mm tree.  Its filename is
     hugetlb-add-per-node-hstate-attributes.patch

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
Subject: hugetlb: add per node hstate attributes
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Add the per huge page size control/query attributes to the per node
sysdevs:

/sys/devices/system/node/node<ID>/hugepages/hugepages-<size>/
	nr_hugepages       - r/w
	free_huge_pages    - r/o
	surplus_huge_pages - r/o

The patch attempts to re-use/share as much of the existing global hstate
attribute initialization and handling, and the "nodes_allowed" constraint
processing as possible.

Calling set_max_huge_pages() with no node indicates a change to global
hstate parameters.  In this case, any non-default task mempolicy will be
used to generate the nodes_allowed mask.  A valid node id indicates an
update to that node's hstate parameters, and the count argument specifies
the target count for the specified node.  From this info, we compute the
target global count for the hstate and construct a nodes_allowed node mask
contain only the specified node.

Setting the node specific nr_hugepages via the per node attribute
effectively ignores any task mempolicy or cpuset constraints.

With this patch:

(me):ls /sys/devices/system/node/node0/hugepages/hugepages-2048kB
./  ../  free_hugepages  nr_hugepages  surplus_hugepages

Starting from:
Node 0 HugePages_Total:     0
Node 0 HugePages_Free:      0
Node 0 HugePages_Surp:      0
Node 1 HugePages_Total:     0
Node 1 HugePages_Free:      0
Node 1 HugePages_Surp:      0
Node 2 HugePages_Total:     0
Node 2 HugePages_Free:      0
Node 2 HugePages_Surp:      0
Node 3 HugePages_Total:     0
Node 3 HugePages_Free:      0
Node 3 HugePages_Surp:      0
vm.nr_hugepages = 0

Allocate 16 persistent huge pages on node 2:
(me):echo 16 >/sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages

[Note that this is equivalent to:
	numactl -m 2 hugeadmin --pool-pages-min 2M:+16
]

Yields:
Node 0 HugePages_Total:     0
Node 0 HugePages_Free:      0
Node 0 HugePages_Surp:      0
Node 1 HugePages_Total:     0
Node 1 HugePages_Free:      0
Node 1 HugePages_Surp:      0
Node 2 HugePages_Total:    16
Node 2 HugePages_Free:     16
Node 2 HugePages_Surp:      0
Node 3 HugePages_Total:     0
Node 3 HugePages_Free:      0
Node 3 HugePages_Surp:      0
vm.nr_hugepages = 16

Global controls work as expected--reduce pool to 8 persistent huge pages:
(me):echo 8 >/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

Node 0 HugePages_Total:     0
Node 0 HugePages_Free:      0
Node 0 HugePages_Surp:      0
Node 1 HugePages_Total:     0
Node 1 HugePages_Free:      0
Node 1 HugePages_Surp:      0
Node 2 HugePages_Total:     8
Node 2 HugePages_Free:      8
Node 2 HugePages_Surp:      0
Node 3 HugePages_Total:     0
Node 3 HugePages_Free:      0
Node 3 HugePages_Surp:      0

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/base/node.c~hugetlb-add-per-node-hstate-attributes drivers/base/node.c
--- a/drivers/base/node.c~hugetlb-add-per-node-hstate-attributes
+++ a/drivers/base/node.c
@@ -173,6 +173,43 @@ static ssize_t node_read_distance(struct
 }
 static SYSDEV_ATTR(distance, S_IRUGO, node_read_distance, NULL);
 
+#ifdef CONFIG_HUGETLBFS
+/*
+ * hugetlbfs per node attributes registration interface:
+ * When/if hugetlb[fs] subsystem initializes [sometime after this module],
+ * it will register its per node attributes for all nodes online at that
+ * time.  It will also call register_hugetlbfs_with_node(), below, to
+ * register its attribute registration functions with this node driver.
+ * Once these hooks have been initialized, the node driver will call into
+ * the hugetlb module to [un]register attributes for hot-plugged nodes.
+ */
+static node_registration_func_t __hugetlb_register_node;
+static node_registration_func_t __hugetlb_unregister_node;
+
+static inline void hugetlb_register_node(struct node *node)
+{
+	if (__hugetlb_register_node)
+		__hugetlb_register_node(node);
+}
+
+static inline void hugetlb_unregister_node(struct node *node)
+{
+	if (__hugetlb_unregister_node)
+		__hugetlb_unregister_node(node);
+}
+
+void register_hugetlbfs_with_node(node_registration_func_t doregister,
+				  node_registration_func_t unregister)
+{
+	__hugetlb_register_node   = doregister;
+	__hugetlb_unregister_node = unregister;
+}
+#else
+static inline void hugetlb_register_node(struct node *node) {}
+
+static inline void hugetlb_unregister_node(struct node *node) {}
+#endif
+
 
 /*
  * register_node - Setup a sysfs device for a node.
@@ -196,6 +233,7 @@ int register_node(struct node *node, int
 		sysdev_create_file(&node->sysdev, &attr_distance);
 
 		scan_unevictable_register_node(node);
+		hugetlb_register_node(node);
 	}
 	return error;
 }
@@ -216,6 +254,7 @@ void unregister_node(struct node *node)
 	sysdev_remove_file(&node->sysdev, &attr_distance);
 
 	scan_unevictable_unregister_node(node);
+	hugetlb_unregister_node(node);
 
 	sysdev_unregister(&node->sysdev);
 }
diff -puN include/linux/node.h~hugetlb-add-per-node-hstate-attributes include/linux/node.h
--- a/include/linux/node.h~hugetlb-add-per-node-hstate-attributes
+++ a/include/linux/node.h
@@ -28,6 +28,7 @@ struct node {
 
 struct memory_block;
 extern struct node node_devices[];
+typedef  void (*node_registration_func_t)(struct node *);
 
 extern int register_node(struct node *, int, struct node *);
 extern void unregister_node(struct node *node);
@@ -39,6 +40,11 @@ extern int unregister_cpu_under_node(uns
 extern int register_mem_sect_under_node(struct memory_block *mem_blk,
 						int nid);
 extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk);
+
+#ifdef CONFIG_HUGETLBFS
+extern void register_hugetlbfs_with_node(node_registration_func_t doregister,
+					 node_registration_func_t unregister);
+#endif
 #else
 static inline int register_one_node(int nid)
 {
@@ -65,6 +71,11 @@ static inline int unregister_mem_sect_un
 {
 	return 0;
 }
+
+static inline void register_hugetlbfs_with_node(node_registration_func_t reg,
+						node_registration_func_t unreg)
+{
+}
 #endif
 
 #define to_node(sys_device) container_of(sys_device, struct node, sysdev)
diff -puN mm/hugetlb.c~hugetlb-add-per-node-hstate-attributes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-per-node-hstate-attributes
+++ a/mm/hugetlb.c
@@ -24,6 +24,7 @@
 #include <asm/io.h>
 
 #include <linux/hugetlb.h>
+#include <linux/node.h>
 #include "internal.h"
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
@@ -1320,39 +1321,71 @@ out:
 static struct kobject *hugepages_kobj;
 static struct kobject *hstate_kobjs[HUGE_MAX_HSTATE];
 
-static struct hstate *kobj_to_hstate(struct kobject *kobj)
+static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp);
+
+static struct hstate *kobj_to_hstate(struct kobject *kobj, int *nidp)
 {
 	int i;
+
 	for (i = 0; i < HUGE_MAX_HSTATE; i++)
-		if (hstate_kobjs[i] == kobj)
+		if (hstate_kobjs[i] == kobj) {
+			if (nidp)
+				*nidp = NUMA_NO_NODE;
 			return &hstates[i];
-	BUG();
-	return NULL;
+		}
+
+	return kobj_to_node_hstate(kobj, nidp);
 }
 
 static ssize_t nr_hugepages_show_common(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
-	struct hstate *h = kobj_to_hstate(kobj);
-	return sprintf(buf, "%lu\n", h->nr_huge_pages);
+	struct hstate *h;
+	unsigned long nr_huge_pages;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE)
+		nr_huge_pages = h->nr_huge_pages;
+	else
+		nr_huge_pages = h->nr_huge_pages_node[nid];
+
+	return sprintf(buf, "%lu\n", nr_huge_pages);
 }
 static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 			struct kobject *kobj, struct kobj_attribute *attr,
 			const char *buf, size_t len)
 {
 	int err;
+	int nid;
 	unsigned long count;
-	struct hstate *h = kobj_to_hstate(kobj);
+	struct hstate *h;
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed);
 
 	err = strict_strtoul(buf, 10, &count);
 	if (err)
 		return 0;
 
-	if (!(obey_mempolicy && init_nodemask_of_mempolicy(nodes_allowed))) {
-		NODEMASK_FREE(nodes_allowed);
-		nodes_allowed = &node_online_map;
-	}
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE) {
+		/*
+		 * global hstate attribute
+		 */
+		if (!(obey_mempolicy &&
+				init_nodemask_of_mempolicy(nodes_allowed))) {
+			NODEMASK_FREE(nodes_allowed);
+			nodes_allowed = &node_states[N_HIGH_MEMORY];
+		}
+	} else if (nodes_allowed) {
+		/*
+		 * per node hstate attribute: adjust count to global,
+		 * but restrict alloc/free to the specified node.
+		 */
+		count += h->nr_huge_pages - h->nr_huge_pages_node[nid];
+		init_nodemask_of_node(nodes_allowed, nid);
+	} else
+		nodes_allowed = &node_states[N_HIGH_MEMORY];
+
 	h->max_huge_pages = set_max_huge_pages(h, count, nodes_allowed);
 
 	if (nodes_allowed != &node_online_map)
@@ -1398,7 +1431,7 @@ HSTATE_ATTR(nr_hugepages_mempolicy);
 static ssize_t nr_overcommit_hugepages_show(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
-	struct hstate *h = kobj_to_hstate(kobj);
+	struct hstate *h = kobj_to_hstate(kobj, NULL);
 	return sprintf(buf, "%lu\n", h->nr_overcommit_huge_pages);
 }
 static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
@@ -1406,7 +1439,7 @@ static ssize_t nr_overcommit_hugepages_s
 {
 	int err;
 	unsigned long input;
-	struct hstate *h = kobj_to_hstate(kobj);
+	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
 	err = strict_strtoul(buf, 10, &input);
 	if (err)
@@ -1423,15 +1456,24 @@ HSTATE_ATTR(nr_overcommit_hugepages);
 static ssize_t free_hugepages_show(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
-	struct hstate *h = kobj_to_hstate(kobj);
-	return sprintf(buf, "%lu\n", h->free_huge_pages);
+	struct hstate *h;
+	unsigned long free_huge_pages;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE)
+		free_huge_pages = h->free_huge_pages;
+	else
+		free_huge_pages = h->free_huge_pages_node[nid];
+
+	return sprintf(buf, "%lu\n", free_huge_pages);
 }
 HSTATE_ATTR_RO(free_hugepages);
 
 static ssize_t resv_hugepages_show(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
-	struct hstate *h = kobj_to_hstate(kobj);
+	struct hstate *h = kobj_to_hstate(kobj, NULL);
 	return sprintf(buf, "%lu\n", h->resv_huge_pages);
 }
 HSTATE_ATTR_RO(resv_hugepages);
@@ -1439,8 +1481,17 @@ HSTATE_ATTR_RO(resv_hugepages);
 static ssize_t surplus_hugepages_show(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
-	struct hstate *h = kobj_to_hstate(kobj);
-	return sprintf(buf, "%lu\n", h->surplus_huge_pages);
+	struct hstate *h;
+	unsigned long surplus_huge_pages;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE)
+		surplus_huge_pages = h->surplus_huge_pages;
+	else
+		surplus_huge_pages = h->surplus_huge_pages_node[nid];
+
+	return sprintf(buf, "%lu\n", surplus_huge_pages);
 }
 HSTATE_ATTR_RO(surplus_hugepages);
 
@@ -1460,19 +1511,21 @@ static struct attribute_group hstate_att
 	.attrs = hstate_attrs,
 };
 
-static int __init hugetlb_sysfs_add_hstate(struct hstate *h)
+static int __init hugetlb_sysfs_add_hstate(struct hstate *h,
+				struct kobject *parent,
+				struct kobject **hstate_kobjs,
+				struct attribute_group *hstate_attr_group)
 {
 	int retval;
+	int hi = h - hstates;
 
-	hstate_kobjs[h - hstates] = kobject_create_and_add(h->name,
-							hugepages_kobj);
-	if (!hstate_kobjs[h - hstates])
+	hstate_kobjs[hi] = kobject_create_and_add(h->name, parent);
+	if (!hstate_kobjs[hi])
 		return -ENOMEM;
 
-	retval = sysfs_create_group(hstate_kobjs[h - hstates],
-							&hstate_attr_group);
+	retval = sysfs_create_group(hstate_kobjs[hi], hstate_attr_group);
 	if (retval)
-		kobject_put(hstate_kobjs[h - hstates]);
+		kobject_put(hstate_kobjs[hi]);
 
 	return retval;
 }
@@ -1487,17 +1540,184 @@ static void __init hugetlb_sysfs_init(vo
 		return;
 
 	for_each_hstate(h) {
-		err = hugetlb_sysfs_add_hstate(h);
+		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
+					 hstate_kobjs, &hstate_attr_group);
 		if (err)
 			printk(KERN_ERR "Hugetlb: Unable to add hstate %s",
 								h->name);
 	}
 }
 
+#ifdef CONFIG_NUMA
+
+/*
+ * node_hstate/s - associate per node hstate attributes, via their kobjects,
+ * with node sysdevs in node_devices[] using a parallel array.  The array
+ * index of a node sysdev or _hstate == node id.
+ * This is here to avoid any static dependency of the node sysdev driver, in
+ * the base kernel, on the hugetlb module.
+ */
+struct node_hstate {
+	struct kobject		*hugepages_kobj;
+	struct kobject		*hstate_kobjs[HUGE_MAX_HSTATE];
+};
+struct node_hstate node_hstates[MAX_NUMNODES];
+
+/*
+ * A subset of global hstate attributes for node sysdevs
+ */
+static struct attribute *per_node_hstate_attrs[] = {
+	&nr_hugepages_attr.attr,
+	&free_hugepages_attr.attr,
+	&surplus_hugepages_attr.attr,
+	NULL,
+};
+
+static struct attribute_group per_node_hstate_attr_group = {
+	.attrs = per_node_hstate_attrs,
+};
+
+/*
+ * kobj_to_node_hstate - lookup global hstate for node sysdev hstate attr kobj.
+ * Returns node id via non-NULL nidp.
+ */
+static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
+{
+	int nid;
+
+	for (nid = 0; nid < nr_node_ids; nid++) {
+		struct node_hstate *nhs = &node_hstates[nid];
+		int i;
+		for (i = 0; i < HUGE_MAX_HSTATE; i++)
+			if (nhs->hstate_kobjs[i] == kobj) {
+				if (nidp)
+					*nidp = nid;
+				return &hstates[i];
+			}
+	}
+
+	BUG();
+	return NULL;
+}
+
+/*
+ * Unregister hstate attributes from a single node sysdev.
+ * No-op if no hstate attributes attached.
+ */
+void hugetlb_unregister_node(struct node *node)
+{
+	struct hstate *h;
+	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
+
+	if (!nhs->hugepages_kobj)
+		return;
+
+	for_each_hstate(h)
+		if (nhs->hstate_kobjs[h - hstates]) {
+			kobject_put(nhs->hstate_kobjs[h - hstates]);
+			nhs->hstate_kobjs[h - hstates] = NULL;
+		}
+
+	kobject_put(nhs->hugepages_kobj);
+	nhs->hugepages_kobj = NULL;
+}
+
+/*
+ * hugetlb module exit:  unregister hstate attributes from node sysdevs
+ * that have them.
+ */
+static void hugetlb_unregister_all_nodes(void)
+{
+	int nid;
+
+	/*
+	 * disable node sysdev registrations.
+	 */
+	register_hugetlbfs_with_node(NULL, NULL);
+
+	/*
+	 * remove hstate attributes from any nodes that have them.
+	 */
+	for (nid = 0; nid < nr_node_ids; nid++)
+		hugetlb_unregister_node(&node_devices[nid]);
+}
+
+/*
+ * Register hstate attributes for a single node sysdev.
+ * No-op if attributes already registered.
+ */
+void hugetlb_register_node(struct node *node)
+{
+	struct hstate *h;
+	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
+	int err;
+
+	if (nhs->hugepages_kobj)
+		return;		/* already allocated */
+
+	nhs->hugepages_kobj = kobject_create_and_add("hugepages",
+							&node->sysdev.kobj);
+	if (!nhs->hugepages_kobj)
+		return;
+
+	for_each_hstate(h) {
+		err = hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
+						nhs->hstate_kobjs,
+						&per_node_hstate_attr_group);
+		if (err) {
+			printk(KERN_ERR "Hugetlb: Unable to add hstate %s"
+					" for node %d\n",
+						h->name, node->sysdev.id);
+			hugetlb_unregister_node(node);
+			break;
+		}
+	}
+}
+
+/*
+ * hugetlb init time:  register hstate attributes for all registered
+ * node sysdevs.  All on-line nodes should have registered their
+ * associated sysdev by the time the hugetlb module initializes.
+ */
+static void hugetlb_register_all_nodes(void)
+{
+	int nid;
+
+	for (nid = 0; nid < nr_node_ids; nid++) {
+		struct node *node = &node_devices[nid];
+		if (node->sysdev.id == nid)
+			hugetlb_register_node(node);
+	}
+
+	/*
+	 * Let the node sysdev driver know we're here so it can
+	 * [un]register hstate attributes on node hotplug.
+	 */
+	register_hugetlbfs_with_node(hugetlb_register_node,
+				     hugetlb_unregister_node);
+}
+#else	/* !CONFIG_NUMA */
+
+static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
+{
+	BUG();
+	if (nidp)
+		*nidp = -1;
+	return NULL;
+}
+
+static void hugetlb_unregister_all_nodes(void) { }
+
+static void hugetlb_register_all_nodes(void) { }
+
+#endif
+
 static void __exit hugetlb_exit(void)
 {
 	struct hstate *h;
 
+	hugetlb_unregister_all_nodes();
+
 	for_each_hstate(h) {
 		kobject_put(hstate_kobjs[h - hstates]);
 	}
@@ -1532,6 +1752,8 @@ static int __init hugetlb_init(void)
 
 	hugetlb_sysfs_init();
 
+	hugetlb_register_all_nodes();
+
 	return 0;
 }
 module_init(hugetlb_init);
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

