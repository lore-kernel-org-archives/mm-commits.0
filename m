From: akpm@linux-foundation.org
Subject: [merged] mm-use-numa_no_node.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:57 -0800
Message-ID: <20130225205457.ABD3931C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:64893 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab3BYUy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:58 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347608ghb.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     mm-use-numa_no_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: use NUMA_NO_NODE

Make a sweep through mm/ and convert code that uses -1 directly to using
the more appropriate NUMA_NO_NODE.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/mempolicy.c   |   10 +++++-----
 mm/page_alloc.c  |    2 +-
 mm/vmalloc.c     |   33 ++++++++++++++++++---------------
 4 files changed, 26 insertions(+), 23 deletions(-)

diff -puN mm/huge_memory.c~mm-use-numa_no_node mm/huge_memory.c
--- a/mm/huge_memory.c~mm-use-numa_no_node
+++ a/mm/huge_memory.c
@@ -2376,7 +2376,7 @@ static int khugepaged_scan_pmd(struct mm
 	struct page *page;
 	unsigned long _address;
 	spinlock_t *ptl;
-	int node = -1;
+	int node = NUMA_NO_NODE;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -2406,7 +2406,7 @@ static int khugepaged_scan_pmd(struct mm
 		 * be more sophisticated and look at more pages,
 		 * but isn't for now.
 		 */
-		if (node == -1)
+		if (node == NUMA_NO_NODE)
 			node = page_to_nid(page);
 		VM_BUG_ON(PageCompound(page));
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
diff -puN mm/mempolicy.c~mm-use-numa_no_node mm/mempolicy.c
--- a/mm/mempolicy.c~mm-use-numa_no_node
+++ a/mm/mempolicy.c
@@ -26,7 +26,7 @@
  *                the allocation to memory nodes instead
  *
  * preferred       Try a specific node first before normal fallback.
- *                As a special case node -1 here means do the allocation
+ *                As a special case NUMA_NO_NODE here means do the allocation
  *                on the local CPU. This is normally identical to default,
  *                but useful to set in a VMA when you have a non default
  *                process policy.
@@ -127,7 +127,7 @@ static struct mempolicy *get_task_policy
 
 	if (!pol) {
 		node = numa_node_id();
-		if (node != -1)
+		if (node != NUMA_NO_NODE)
 			pol = &preferred_node_policy[node];
 
 		/* preferred_node_policy is not initialised early in boot */
@@ -258,7 +258,7 @@ static struct mempolicy *mpol_new(unsign
 	struct mempolicy *policy;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
-		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
+		 mode, flags, nodes ? nodes_addr(*nodes)[0] : NUMA_NO_NODE);
 
 	if (mode == MPOL_DEFAULT) {
 		if (nodes && !nodes_empty(*nodes))
@@ -1221,7 +1221,7 @@ static long do_mbind(unsigned long start
 
 	pr_debug("mbind %lx-%lx mode:%d flags:%d nodes:%lx\n",
 		 start, start + len, mode, mode_flags,
-		 nmask ? nodes_addr(*nmask)[0] : -1);
+		 nmask ? nodes_addr(*nmask)[0] : NUMA_NO_NODE);
 
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 
@@ -2488,7 +2488,7 @@ int mpol_set_shared_policy(struct shared
 		 vma->vm_pgoff,
 		 sz, npol ? npol->mode : -1,
 		 npol ? npol->flags : -1,
-		 npol ? nodes_addr(npol->v.nodes)[0] : -1);
+		 npol ? nodes_addr(npol->v.nodes)[0] : NUMA_NO_NODE);
 
 	if (npol) {
 		new = sp_alloc(vma->vm_pgoff, vma->vm_pgoff + sz, npol);
diff -puN mm/page_alloc.c~mm-use-numa_no_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-numa_no_node
+++ a/mm/page_alloc.c
@@ -3261,7 +3261,7 @@ static int find_next_best_node(int node,
 {
 	int n, val;
 	int min_val = INT_MAX;
-	int best_node = -1;
+	int best_node = NUMA_NO_NODE;
 	const struct cpumask *tmp = cpumask_of_node(0);
 
 	/* Use the local node if we haven't already */
diff -puN mm/vmalloc.c~mm-use-numa_no_node mm/vmalloc.c
--- a/mm/vmalloc.c~mm-use-numa_no_node
+++ a/mm/vmalloc.c
@@ -1376,8 +1376,8 @@ static struct vm_struct *__get_vm_area_n
 struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 				unsigned long start, unsigned long end)
 {
-	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
-						__builtin_return_address(0));
+	return __get_vm_area_node(size, 1, flags, start, end, NUMA_NO_NODE,
+				  GFP_KERNEL, __builtin_return_address(0));
 }
 EXPORT_SYMBOL_GPL(__get_vm_area);
 
@@ -1385,8 +1385,8 @@ struct vm_struct *__get_vm_area_caller(u
 				       unsigned long start, unsigned long end,
 				       const void *caller)
 {
-	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
-				  caller);
+	return __get_vm_area_node(size, 1, flags, start, end, NUMA_NO_NODE,
+				  GFP_KERNEL, caller);
 }
 
 /**
@@ -1401,14 +1401,15 @@ struct vm_struct *__get_vm_area_caller(u
 struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
 {
 	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
-				-1, GFP_KERNEL, __builtin_return_address(0));
+				  NUMA_NO_NODE, GFP_KERNEL,
+				  __builtin_return_address(0));
 }
 
 struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				const void *caller)
 {
 	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
-						-1, GFP_KERNEL, caller);
+				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
 /**
@@ -1650,7 +1651,7 @@ fail:
  *	@end:		vm area range end
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
- *	@node:		node to use for allocation or -1
+ *	@node:		node to use for allocation or NUMA_NO_NODE
  *	@caller:	caller's return address
  *
  *	Allocate enough pages to cover @size from the page level
@@ -1706,7 +1707,7 @@ fail:
  *	@align:		desired alignment
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
- *	@node:		node to use for allocation or -1
+ *	@node:		node to use for allocation or NUMA_NO_NODE
  *	@caller:	caller's return address
  *
  *	Allocate enough pages to cover @size from the page level
@@ -1723,7 +1724,7 @@ static void *__vmalloc_node(unsigned lon
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_node(size, 1, gfp_mask, prot, -1,
+	return __vmalloc_node(size, 1, gfp_mask, prot, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__vmalloc);
@@ -1746,7 +1747,8 @@ static inline void *__vmalloc_node_flags
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc_node_flags(size, -1, GFP_KERNEL | __GFP_HIGHMEM);
+	return __vmalloc_node_flags(size, NUMA_NO_NODE,
+				    GFP_KERNEL | __GFP_HIGHMEM);
 }
 EXPORT_SYMBOL(vmalloc);
 
@@ -1762,7 +1764,7 @@ EXPORT_SYMBOL(vmalloc);
  */
 void *vzalloc(unsigned long size)
 {
-	return __vmalloc_node_flags(size, -1,
+	return __vmalloc_node_flags(size, NUMA_NO_NODE,
 				GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
 }
 EXPORT_SYMBOL(vzalloc);
@@ -1781,7 +1783,8 @@ void *vmalloc_user(unsigned long size)
 
 	ret = __vmalloc_node(size, SHMLBA,
 			     GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
-			     PAGE_KERNEL, -1, __builtin_return_address(0));
+			     PAGE_KERNEL, NUMA_NO_NODE,
+			     __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
 		area->flags |= VM_USERMAP;
@@ -1846,7 +1849,7 @@ EXPORT_SYMBOL(vzalloc_node);
 void *vmalloc_exec(unsigned long size)
 {
 	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
-			      -1, __builtin_return_address(0));
+			      NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
@@ -1867,7 +1870,7 @@ void *vmalloc_exec(unsigned long size)
 void *vmalloc_32(unsigned long size)
 {
 	return __vmalloc_node(size, 1, GFP_VMALLOC32, PAGE_KERNEL,
-			      -1, __builtin_return_address(0));
+			      NUMA_NO_NODE, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_32);
 
@@ -1884,7 +1887,7 @@ void *vmalloc_32_user(unsigned long size
 	void *ret;
 
 	ret = __vmalloc_node(size, 1, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
-			     -1, __builtin_return_address(0));
+			     NUMA_NO_NODE, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
 		area->flags |= VM_USERMAP;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

