From: akpm@linux-foundation.org
Subject: + hugetlb-use-only-nodes-with-memory-for-huge-pages.patch added to -mm tree
Date: Tue, 13 Oct 2009 12:33:02 -0700
Message-ID: <200910131933.n9DJX2D5032515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761142AbZJMTkL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 15:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nacc@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com


The patch titled
     hugetlb: use only nodes with memory for huge pages
has been added to the -mm tree.  Its filename is
     hugetlb-use-only-nodes-with-memory-for-huge-pages.patch

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
Subject: hugetlb: use only nodes with memory for huge pages
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Register per node hstate sysfs attributes only for nodes with memory. 
Global replacement of 'all online nodes" with "all nodes with memory" in
mm/hugetlb.c.  Suggested by David Rientjes.

A subsequent patch will handle adding/removing of per node hstate sysfs
attributes when nodes transition to/from memoryless state via memory
hotplug.

NOTE: this patch has not been tested with memoryless nodes.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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


diff -puN Documentation/vm/hugetlbpage.txt~hugetlb-use-only-nodes-with-memory-for-huge-pages Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlb-use-only-nodes-with-memory-for-huge-pages
+++ a/Documentation/vm/hugetlbpage.txt
@@ -90,11 +90,11 @@ huge page pool to 20, allocating or free
 On a NUMA platform, the kernel will attempt to distribute the huge page pool
 over all the set of allowed nodes specified by the NUMA memory policy of the
 task that modifies nr_hugepages.  The default for the allowed nodes--when the
-task has default memory policy--is all on-line nodes.  Allowed nodes with
-insufficient available, contiguous memory for a huge page will be silently
-skipped when allocating persistent huge pages.  See the discussion below of
-the interaction of task memory policy, cpusets and per node attributes with
-the allocation and freeing of persistent huge pages.
+task has default memory policy--is all on-line nodes with memory.  Allowed
+nodes with insufficient available, contiguous memory for a huge page will be
+silently skipped when allocating persistent huge pages.  See the discussion
+below of the interaction of task memory policy, cpusets and per node attributes
+with the allocation and freeing of persistent huge pages.
 
 The success or failure of huge page allocation depends on the amount of
 physically contiguous memory that is present in system at the time of the
@@ -226,7 +226,7 @@ resulting effect on persistent huge page
    without first moving to a cpuset that contains all of the desired nodes.
 
 5) Boot-time huge page allocation attempts to distribute the requested number
-   of huge pages over all on-lines nodes.
+   of huge pages over all on-lines nodes with memory.
 
 Per Node Hugepages Attributes
 
diff -puN mm/hugetlb.c~hugetlb-use-only-nodes-with-memory-for-huge-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-use-only-nodes-with-memory-for-huge-pages
+++ a/mm/hugetlb.c
@@ -942,14 +942,14 @@ static void return_unused_surplus_pages(
 
 	/*
 	 * We want to release as many surplus pages as possible, spread
-	 * evenly across all nodes. Iterate across all nodes until we
-	 * can no longer free unreserved surplus pages. This occurs when
-	 * the nodes with surplus pages have no free pages.
-	 * free_pool_huge_page() will balance the the frees across the
-	 * on-line nodes for us and will handle the hstate accounting.
+	 * evenly across all nodes with memory. Iterate across these nodes
+	 * until we can no longer free unreserved surplus pages. This occurs
+	 * when the nodes with surplus pages have no free pages.
+	 * free_pool_huge_page() will balance the the freed pages across the
+	 * on-line nodes with memory and will handle the hstate accounting.
 	 */
 	while (nr_pages--) {
-		if (!free_pool_huge_page(h, &node_online_map, 1))
+		if (!free_pool_huge_page(h, &node_states[N_HIGH_MEMORY], 1))
 			break;
 	}
 }
@@ -1053,14 +1053,14 @@ static struct page *alloc_huge_page(stru
 int __weak alloc_bootmem_huge_page(struct hstate *h)
 {
 	struct huge_bootmem_page *m;
-	int nr_nodes = nodes_weight(node_online_map);
+	int nr_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
 
 	while (nr_nodes) {
 		void *addr;
 
 		addr = __alloc_bootmem_node_nopanic(
 				NODE_DATA(hstate_next_node_to_alloc(h,
-							&node_online_map)),
+						&node_states[N_HIGH_MEMORY])),
 				huge_page_size(h), huge_page_size(h), 0);
 
 		if (addr) {
@@ -1115,7 +1115,8 @@ static void __init hugetlb_hstate_alloc_
 		if (h->order >= MAX_ORDER) {
 			if (!alloc_bootmem_huge_page(h))
 				break;
-		} else if (!alloc_fresh_huge_page(h, &node_online_map))
+		} else if (!alloc_fresh_huge_page(h,
+					 &node_states[N_HIGH_MEMORY]))
 			break;
 	}
 	h->max_huge_pages = i;
@@ -1388,7 +1389,7 @@ static ssize_t nr_hugepages_store_common
 
 	h->max_huge_pages = set_max_huge_pages(h, count, nodes_allowed);
 
-	if (nodes_allowed != &node_online_map)
+	if (nodes_allowed != &node_states[N_HIGH_MEMORY])
 		NODEMASK_FREE(nodes_allowed);
 
 	return len;
@@ -1610,7 +1611,7 @@ void hugetlb_unregister_node(struct node
 	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
 
 	if (!nhs->hugepages_kobj)
-		return;
+		return;		/* no hstate attributes */
 
 	for_each_hstate(h)
 		if (nhs->hstate_kobjs[h - hstates]) {
@@ -1675,15 +1676,15 @@ void hugetlb_register_node(struct node *
 }
 
 /*
- * hugetlb init time:  register hstate attributes for all registered
- * node sysdevs.  All on-line nodes should have registered their
- * associated sysdev by the time the hugetlb module initializes.
+ * hugetlb init time:  register hstate attributes for all registered node
+ * sysdevs of nodes that have memory.  All on-line nodes should have
+ * registered their associated sysdev by this time.
  */
 static void hugetlb_register_all_nodes(void)
 {
 	int nid;
 
-	for (nid = 0; nid < nr_node_ids; nid++) {
+	for_each_node_state(nid, N_HIGH_MEMORY) {
 		struct node *node = &node_devices[nid];
 		if (node->sysdev.id == nid)
 			hugetlb_register_node(node);
@@ -1777,8 +1778,8 @@ void __init hugetlb_add_hstate(unsigned 
 	h->free_huge_pages = 0;
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
-	h->next_nid_to_alloc = first_node(node_online_map);
-	h->next_nid_to_free = first_node(node_online_map);
+	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
+	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
 
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

