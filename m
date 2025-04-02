Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA0C1EBFF0
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 21:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630841; cv=none; b=pKlxhWiKQKwsh4NOYUZ4BaVcm5qqqofgS8tC08DPy4nnLiJNstdWN7IpgtWOjqRHXycxJTBRFT+EeZDrrljNfP6Lj0waPvcBC/vBbzUqVQrlSWjhy6yfFL4PS2So+3cNm/jtYud+bOg5rEK5v/h9/6MhLMg9d7m+HamqQk5foGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630841; c=relaxed/simple;
	bh=KI1f3h2aNAXFwXb2n6N8vF0bx3vDdW3Qnzdhzio4l0Q=;
	h=Date:To:From:Subject:Message-Id; b=jCPidcJWCGN8br+OlKEq9VmLa3mEXipW1ayfzmy+ZszTeYa32WZYn+EGa91ez+LLdaR+LlPEQarvvF3JMoTPm52xDXrVRs7p/h7MHfp7ylTP3UvU7XOcGYkuwzLm7ad5TrlkDMiWgEo5NXAVNlA6BbnzoDIdtP8BuCT/Se76Tjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wqmdbKg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wqmdbKg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C493C4CEDD;
	Wed,  2 Apr 2025 21:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743630841;
	bh=KI1f3h2aNAXFwXb2n6N8vF0bx3vDdW3Qnzdhzio4l0Q=;
	h=Date:To:From:Subject:From;
	b=wqmdbKg8U301VvB6PUA4HcbFO1yuTlkvxGHC+KSS4+WjtxM68t7xsivP8yVRR0QQV
	 5D0C66tYDOiAp+mGcQAZVVEd2cqK3q5C77Z6aQEH6NbwUOs6Jfn2ID1khU295aZR0e
	 xiTV7Tijx73vPY4fLcF3kmY4b4kQ7AKyhC/0w7t8=
Date: Wed, 02 Apr 2025 14:54:00 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,luizcap@redhat.com,david@redhat.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch added to mm-new branch
Message-Id: <20250402215401.5C493C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use separate nodemask for bootmem allocations
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

This patch will later appear in the mm-new branch at
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
Cc: David Hildenbrand <david@redhat.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
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
 
@@ -3237,7 +3238,8 @@ int __alloc_bootmem_huge_page(struct hst
 	}
 
 	/* allocate from next node when distributing huge pages */
-	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_ONLINE]) {
+	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node,
+				    &hugetlb_bootmem_nodes) {
 		m = alloc_bootmem(h, node, false);
 		if (!m)
 			return 0;
@@ -3701,6 +3703,15 @@ static void __init hugetlb_init_hstates(
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
@@ -4990,6 +5001,20 @@ static int __init default_hugepagesz_set
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
@@ -5005,6 +5030,8 @@ void __init hugetlb_bootmem_alloc(void)
 	if (__hugetlb_bootmem_allocated)
 		return;
 
+	hugetlb_bootmem_set_nodes();
+
 	for (i = 0; i < MAX_NUMNODES; i++)
 		INIT_LIST_HEAD(&huge_boot_pages[i]);
 
@@ -5012,7 +5039,6 @@ void __init hugetlb_bootmem_alloc(void)
 
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

mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

