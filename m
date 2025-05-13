Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510841EB9FD
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119229; cv=none; b=XG2I7cymivmhLpEABmtMY1r9VMlVnPrQmTcPuuhzCaPmqBtBLT9ReL+2tLP1+AePXm8XCjZo4yqP2S8jMuY+FTpc3u0iSPJKP/zPcDGcteUwdVtWxUUc3vkIZsWYsBE0YDYhN4OCaBFsR0mfwndiJAHzduIujVFfYyWgoBvfxVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119229; c=relaxed/simple;
	bh=tkIvDY7i9LPBhNx7axGYif/XEwlGxhVNMre7m89zaJw=;
	h=Date:To:From:Subject:Message-Id; b=DNZ+bIUMqjdVudMxJMjvBs6dANG10y8CvgTwhwq/EhWR3/D+Sk0SUy85npUTPxViVZsaAfuMXiXJbhxbsUP002b+fOegFmP8e8qTWzu1d3zrflzXT7lL8aVnK8rh7wfk9p6e5cU8KWASTg+K+nwkWU/dDu+gb/5OsWGGJTh+4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RJTYrLHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RJTYrLHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7DBC4CEE4;
	Tue, 13 May 2025 06:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119229;
	bh=tkIvDY7i9LPBhNx7axGYif/XEwlGxhVNMre7m89zaJw=;
	h=Date:To:From:Subject:From;
	b=RJTYrLHS/cgDSVeyo3DORUm6hlUpQhY3AOd+ZSKm8/bDs+xZsKhe7aLRopmCXfxbX
	 g0Ky/LMUOzWJqNrju8k93zi9oTDzWtiYnJJSVE0kSP5y5n9/pY8e7jbxYSrJI/dCl1
	 agtr+MgohYuCBGT8CiBhePm2FT0VlE7KZ7rDp/ZA=
Date: Mon, 12 May 2025 23:53:48 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,luizcap@redhat.com,david@redhat.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch removed from -mm tree
Message-Id: <20250513065349.1A7DBC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: use separate nodemask for bootmem allocations
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: use separate nodemask for bootmem allocations
Date: Wed, 2 Apr 2025 20:56:13 +0000

Hugetlb boot allocation has used online nodes for allocation since commit
de55996d7188 ("mm/hugetlb: use online nodes for bootmem allocation"). 
This was needed to be able to do the allocations earlier in boot, before
N_MEMORY was set.

This might lead to a different distribution of gigantic hugepages across
NUMA nodes if there are memoryless nodes in the system.

What happens is that the memoryless nodes are tried, but then the memblock
allocation fails and falls back, which usually means that the node that
has the highest physical address available will be used (top-down
allocation).  While this will end up getting the same number of hugetlb
pages, they might not be be distributed the same way.  The fallback for
each memoryless node might not end up coming from the same node as the
successful round-robin allocation from N_MEMORY nodes.

While administrators that rely on having a specific number of hugepages
per node should use the hugepages=N:X syntax, it's better not to change
the old behavior for the plain hugepages=N case.

To do this, construct a nodemask for hugetlb bootmem purposes only,
containing nodes that have memory.  Then use that for round-robin bootmem
allocations.

This saves some cycles, and the added advantage here is that hugetlb_cma
can use it too, avoiding the older issue of pointless attempts to create a
CMA area for memoryless nodes (which will also cause the per-node CMA area
size to be too small).

Link: https://lkml.kernel.org/r/20250402205613.3086864-1-fvdl@google.com
Fixes: de55996d7188 ("mm/hugetlb: use online nodes for bootmem allocation")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |   30 ++++++++++++++++++++++++++++--
 mm/hugetlb_cma.c        |   11 +++++++----
 3 files changed, 38 insertions(+), 6 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-use-separate-nodemask-for-bootmem-allocations
+++ a/include/linux/hugetlb.h
@@ -14,6 +14,7 @@
 #include <linux/pgtable.h>
 #include <linux/gfp.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/nodemask.h>
 
 struct ctl_table;
 struct user_struct;
@@ -176,6 +177,8 @@ extern struct list_head huge_boot_pages[
 
 void hugetlb_bootmem_alloc(void);
 bool hugetlb_bootmem_allocated(void);
+extern nodemask_t hugetlb_bootmem_nodes;
+void hugetlb_bootmem_set_nodes(void);
 
 /* arch callbacks */
 
--- a/mm/hugetlb.c~mm-hugetlb-use-separate-nodemask-for-bootmem-allocations
+++ a/mm/hugetlb.c
@@ -58,6 +58,7 @@ int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
+__initdata nodemask_t hugetlb_bootmem_nodes;
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
 static unsigned long hstate_boot_nrinvalid[HUGE_MAX_HSTATE] __initdata;
 
@@ -3219,7 +3220,8 @@ int __alloc_bootmem_huge_page(struct hst
 	}
 
 	/* allocate from next node when distributing huge pages */
-	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_ONLINE]) {
+	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node,
+				    &hugetlb_bootmem_nodes) {
 		m = alloc_bootmem(h, node, false);
 		if (!m)
 			return 0;
@@ -3683,6 +3685,15 @@ static void __init hugetlb_init_hstates(
 	struct hstate *h, *h2;
 
 	for_each_hstate(h) {
+		/*
+		 * Always reset to first_memory_node here, even if
+		 * next_nid_to_alloc was set before - we can't
+		 * reference hugetlb_bootmem_nodes after init, and
+		 * first_memory_node is right for all further allocations.
+		 */
+		h->next_nid_to_alloc = first_memory_node;
+		h->next_nid_to_free = first_memory_node;
+
 		/* oversize hugepages were init'ed in early boot */
 		if (!hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
@@ -4995,6 +5006,20 @@ static int __init default_hugepagesz_set
 }
 hugetlb_early_param("default_hugepagesz", default_hugepagesz_setup);
 
+void __init hugetlb_bootmem_set_nodes(void)
+{
+	int i, nid;
+	unsigned long start_pfn, end_pfn;
+
+	if (!nodes_empty(hugetlb_bootmem_nodes))
+		return;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		if (end_pfn > start_pfn)
+			node_set(nid, hugetlb_bootmem_nodes);
+	}
+}
+
 static bool __hugetlb_bootmem_allocated __initdata;
 
 bool __init hugetlb_bootmem_allocated(void)
@@ -5010,6 +5035,8 @@ void __init hugetlb_bootmem_alloc(void)
 	if (__hugetlb_bootmem_allocated)
 		return;
 
+	hugetlb_bootmem_set_nodes();
+
 	for (i = 0; i < MAX_NUMNODES; i++)
 		INIT_LIST_HEAD(&huge_boot_pages[i]);
 
@@ -5017,7 +5044,6 @@ void __init hugetlb_bootmem_alloc(void)
 
 	for_each_hstate(h) {
 		h->next_nid_to_alloc = first_online_node;
-		h->next_nid_to_free = first_online_node;
 
 		if (hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
--- a/mm/hugetlb_cma.c~mm-hugetlb-use-separate-nodemask-for-bootmem-allocations
+++ a/mm/hugetlb_cma.c
@@ -66,7 +66,7 @@ hugetlb_cma_alloc_bootmem(struct hstate
 		if (node_exact)
 			return NULL;
 
-		for_each_online_node(node) {
+		for_each_node_mask(node, hugetlb_bootmem_nodes) {
 			cma = hugetlb_cma[node];
 			if (!cma || node == *nid)
 				continue;
@@ -153,11 +153,13 @@ void __init hugetlb_cma_reserve(int orde
 	if (!hugetlb_cma_size)
 		return;
 
+	hugetlb_bootmem_set_nodes();
+
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
 		if (hugetlb_cma_size_in_node[nid] == 0)
 			continue;
 
-		if (!node_online(nid)) {
+		if (!node_isset(nid, hugetlb_bootmem_nodes)) {
 			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
 			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
 			hugetlb_cma_size_in_node[nid] = 0;
@@ -190,13 +192,14 @@ void __init hugetlb_cma_reserve(int orde
 		 * If 3 GB area is requested on a machine with 4 numa nodes,
 		 * let's allocate 1 GB on first three nodes and ignore the last one.
 		 */
-		per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+		per_node = DIV_ROUND_UP(hugetlb_cma_size,
+					nodes_weight(hugetlb_bootmem_nodes));
 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}
 
 	reserved = 0;
-	for_each_online_node(nid) {
+	for_each_node_mask(nid, hugetlb_bootmem_nodes) {
 		int res;
 		char name[CMA_MAX_NAME];
 
_

Patches currently in -mm which might be from fvdl@google.com are


