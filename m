From: akpm@linux-foundation.org
Subject: + hugetlb-use-n_memory-instead-n_high_memory.patch added to -mm tree
Date: Thu, 15 Nov 2012 16:34:59 -0800
Message-ID: <20121116003500.2CBC8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34118 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2KPAfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 19:35:01 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so248809yen.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 16:35:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: hugetlb: use N_MEMORY instead N_HIGH_MEMORY
has been added to the -mm tree.  Its filename is
     hugetlb-use-n_memory-instead-n_high_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: hugetlb: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 mm/hugetlb.c        |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/base/node.c~hugetlb-use-n_memory-instead-n_high_memory drivers/base/node.c
--- a/drivers/base/node.c~hugetlb-use-n_memory-instead-n_high_memory
+++ a/drivers/base/node.c
@@ -227,7 +227,7 @@ static node_registration_func_t __hugetl
 static inline bool hugetlb_register_node(struct node *node)
 {
 	if (__hugetlb_register_node &&
-			node_state(node->dev.id, N_HIGH_MEMORY)) {
+			node_state(node->dev.id, N_MEMORY)) {
 		__hugetlb_register_node(node);
 		return true;
 	}
diff -puN mm/hugetlb.c~hugetlb-use-n_memory-instead-n_high_memory mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-use-n_memory-instead-n_high_memory
+++ a/mm/hugetlb.c
@@ -1057,7 +1057,7 @@ static void return_unused_surplus_pages(
 	 * on-line nodes with memory and will handle the hstate accounting.
 	 */
 	while (nr_pages--) {
-		if (!free_pool_huge_page(h, &node_states[N_HIGH_MEMORY], 1))
+		if (!free_pool_huge_page(h, &node_states[N_MEMORY], 1))
 			break;
 	}
 }
@@ -1180,14 +1180,14 @@ static struct page *alloc_huge_page(stru
 int __weak alloc_bootmem_huge_page(struct hstate *h)
 {
 	struct huge_bootmem_page *m;
-	int nr_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
+	int nr_nodes = nodes_weight(node_states[N_MEMORY]);
 
 	while (nr_nodes) {
 		void *addr;
 
 		addr = __alloc_bootmem_node_nopanic(
 				NODE_DATA(hstate_next_node_to_alloc(h,
-						&node_states[N_HIGH_MEMORY])),
+						&node_states[N_MEMORY])),
 				huge_page_size(h), huge_page_size(h), 0);
 
 		if (addr) {
@@ -1259,7 +1259,7 @@ static void __init hugetlb_hstate_alloc_
 			if (!alloc_bootmem_huge_page(h))
 				break;
 		} else if (!alloc_fresh_huge_page(h,
-					 &node_states[N_HIGH_MEMORY]))
+					 &node_states[N_MEMORY]))
 			break;
 	}
 	h->max_huge_pages = i;
@@ -1527,7 +1527,7 @@ static ssize_t nr_hugepages_store_common
 		if (!(obey_mempolicy &&
 				init_nodemask_of_mempolicy(nodes_allowed))) {
 			NODEMASK_FREE(nodes_allowed);
-			nodes_allowed = &node_states[N_HIGH_MEMORY];
+			nodes_allowed = &node_states[N_MEMORY];
 		}
 	} else if (nodes_allowed) {
 		/*
@@ -1537,11 +1537,11 @@ static ssize_t nr_hugepages_store_common
 		count += h->nr_huge_pages - h->nr_huge_pages_node[nid];
 		init_nodemask_of_node(nodes_allowed, nid);
 	} else
-		nodes_allowed = &node_states[N_HIGH_MEMORY];
+		nodes_allowed = &node_states[N_MEMORY];
 
 	h->max_huge_pages = set_max_huge_pages(h, count, nodes_allowed);
 
-	if (nodes_allowed != &node_states[N_HIGH_MEMORY])
+	if (nodes_allowed != &node_states[N_MEMORY])
 		NODEMASK_FREE(nodes_allowed);
 
 	return len;
@@ -1844,7 +1844,7 @@ static void hugetlb_register_all_nodes(v
 {
 	int nid;
 
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		struct node *node = node_devices[nid];
 		if (node->dev.id == nid)
 			hugetlb_register_node(node);
@@ -1939,8 +1939,8 @@ void __init hugetlb_add_hstate(unsigned 
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
-	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
-	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
+	h->next_nid_to_alloc = first_node(node_states[N_MEMORY]);
+	h->next_nid_to_free = first_node(node_states[N_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
 	/*
@@ -2035,11 +2035,11 @@ static int hugetlb_sysctl_handler_common
 		if (!(obey_mempolicy &&
 			       init_nodemask_of_mempolicy(nodes_allowed))) {
 			NODEMASK_FREE(nodes_allowed);
-			nodes_allowed = &node_states[N_HIGH_MEMORY];
+			nodes_allowed = &node_states[N_MEMORY];
 		}
 		h->max_huge_pages = set_max_huge_pages(h, tmp, nodes_allowed);
 
-		if (nodes_allowed != &node_states[N_HIGH_MEMORY])
+		if (nodes_allowed != &node_states[N_MEMORY])
 			NODEMASK_FREE(nodes_allowed);
 	}
 out:
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
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

