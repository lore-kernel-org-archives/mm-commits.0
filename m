From: akpm@linux-foundation.org
Subject: [merged] page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:36 -0700
Message-ID: <200906171833.n5HIXaGg032108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758108AbZFQS4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, lethal@linux-sh.org, nickpiggin@yahoo


The patch titled
     page allocator: do not check NUMA node ID when the caller knows the node is valid
has been removed from the -mm tree.  Its filename was
     page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: do not check NUMA node ID when the caller knows the node is valid
From: Mel Gorman <mel@csn.ul.ie>

Callers of alloc_pages_node() can optionally specify -1 as a node to mean
"allocate from the current node".  However, a number of the callers in
fast paths know for a fact their node is valid.  To avoid a comparison and
branch, this patch adds alloc_pages_exact_node() that only checks the nid
with VM_BUG_ON().  Callers that know their node is valid are then
converted.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Paul Mundt <lethal@linux-sh.org>	[for the SLOB NUMA bits]
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c   |    2 +-
 arch/ia64/kernel/mca.c            |    3 +--
 arch/ia64/kernel/uncached.c       |    3 ++-
 arch/ia64/sn/pci/pci_dma.c        |    3 ++-
 arch/powerpc/platforms/cell/ras.c |    4 ++--
 arch/x86/kvm/vmx.c                |    2 +-
 drivers/misc/sgi-gru/grufile.c    |    2 +-
 drivers/misc/sgi-xp/xpc_uv.c      |    2 +-
 include/linux/gfp.h               |    9 +++++++++
 include/linux/mm.h                |    1 -
 kernel/profile.c                  |    8 ++++----
 mm/filemap.c                      |    2 +-
 mm/hugetlb.c                      |    4 ++--
 mm/mempolicy.c                    |    2 +-
 mm/migrate.c                      |    2 +-
 mm/slab.c                         |    4 ++--
 mm/slob.c                         |    4 ++--
 17 files changed, 33 insertions(+), 24 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -1131,7 +1131,7 @@ sba_alloc_coherent (struct device *dev, 
 #ifdef CONFIG_NUMA
 	{
 		struct page *page;
-		page = alloc_pages_node(ioc->node == MAX_NUMNODES ?
+		page = alloc_pages_exact_node(ioc->node == MAX_NUMNODES ?
 		                        numa_node_id() : ioc->node, flags,
 		                        get_order(size));
 
diff -puN arch/ia64/kernel/mca.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/arch/ia64/kernel/mca.c
@@ -1829,8 +1829,7 @@ ia64_mca_cpu_init(void *cpu_data)
 			data = mca_bootmem();
 			first_time = 0;
 		} else
-			data = page_address(alloc_pages_node(numa_node_id(),
-					GFP_KERNEL, get_order(sz)));
+			data = __get_free_pages(GFP_KERNEL, get_order(sz));
 		if (!data)
 			panic("Could not allocate MCA memory for cpu %d\n",
 					cpu);
diff -puN arch/ia64/kernel/uncached.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid arch/ia64/kernel/uncached.c
--- a/arch/ia64/kernel/uncached.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/arch/ia64/kernel/uncached.c
@@ -98,7 +98,8 @@ static int uncached_add_chunk(struct unc
 
 	/* attempt to allocate a granule's worth of cached memory pages */
 
-	page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+	page = alloc_pages_exact_node(nid,
+				GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
 				IA64_GRANULE_SHIFT-PAGE_SHIFT);
 	if (!page) {
 		mutex_unlock(&uc_pool->add_chunk_mutex);
diff -puN arch/ia64/sn/pci/pci_dma.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid arch/ia64/sn/pci/pci_dma.c
--- a/arch/ia64/sn/pci/pci_dma.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/arch/ia64/sn/pci/pci_dma.c
@@ -90,7 +90,8 @@ static void *sn_dma_alloc_coherent(struc
 	 */
 	node = pcibus_to_node(pdev->bus);
 	if (likely(node >=0)) {
-		struct page *p = alloc_pages_node(node, flags, get_order(size));
+		struct page *p = alloc_pages_exact_node(node,
+						flags, get_order(size));
 
 		if (likely(p))
 			cpuaddr = page_address(p);
diff -puN arch/powerpc/platforms/cell/ras.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid arch/powerpc/platforms/cell/ras.c
--- a/arch/powerpc/platforms/cell/ras.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/arch/powerpc/platforms/cell/ras.c
@@ -122,8 +122,8 @@ static int __init cbe_ptcal_enable_on_no
 
 	area->nid = nid;
 	area->order = order;
-	area->pages = alloc_pages_node(area->nid, GFP_KERNEL | GFP_THISNODE,
-					area->order);
+	area->pages = alloc_pages_exact_node(area->nid, GFP_KERNEL|GFP_THISNODE,
+						area->order);
 
 	if (!area->pages) {
 		printk(KERN_WARNING "%s: no page on node %d\n",
diff -puN arch/x86/kvm/vmx.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/arch/x86/kvm/vmx.c
@@ -1277,7 +1277,7 @@ static struct vmcs *alloc_vmcs_cpu(int c
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = alloc_pages_node(node, GFP_KERNEL, vmcs_config.order);
+	pages = alloc_pages_exact_node(node, GFP_KERNEL, vmcs_config.order);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
diff -puN drivers/misc/sgi-gru/grufile.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -302,7 +302,7 @@ static int gru_init_tables(unsigned long
 		pnode = uv_node_to_pnode(nid);
 		if (bid < 0 || gru_base[bid])
 			continue;
-		page = alloc_pages_node(nid, GFP_KERNEL, order);
+		page = alloc_pages_exact_node(nid, GFP_KERNEL, order);
 		if (!page)
 			goto fail;
 		gru_base[bid] = page_address(page);
diff -puN drivers/misc/sgi-xp/xpc_uv.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -232,7 +232,7 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+	page = alloc_pages_exact_node(nid, GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
 				pg_order);
 	if (page == NULL) {
 		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to alloc %d "
diff -puN include/linux/gfp.h~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/include/linux/gfp.h
@@ -5,6 +5,7 @@
 #include <linux/stddef.h>
 #include <linux/linkage.h>
 #include <linux/topology.h>
+#include <linux/mmdebug.h>
 
 struct vm_area_struct;
 
@@ -192,6 +193,14 @@ static inline struct page *alloc_pages_n
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
 
+static inline struct page *alloc_pages_exact_node(int nid, gfp_t gfp_mask,
+						unsigned int order)
+{
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+
+	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
+}
+
 #ifdef CONFIG_NUMA
 extern struct page *alloc_pages_current(gfp_t gfp_mask, unsigned order);
 
diff -puN include/linux/mm.h~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid include/linux/mm.h
--- a/include/linux/mm.h~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/include/linux/mm.h
@@ -7,7 +7,6 @@
 
 #include <linux/gfp.h>
 #include <linux/list.h>
-#include <linux/mmdebug.h>
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
 #include <linux/prio_tree.h>
diff -puN kernel/profile.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid kernel/profile.c
--- a/kernel/profile.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/kernel/profile.c
@@ -365,7 +365,7 @@ static int __cpuinit profile_cpu_callbac
 		node = cpu_to_node(cpu);
 		per_cpu(cpu_profile_flip, cpu) = 0;
 		if (!per_cpu(cpu_profile_hits, cpu)[1]) {
-			page = alloc_pages_node(node,
+			page = alloc_pages_exact_node(node,
 					GFP_KERNEL | __GFP_ZERO,
 					0);
 			if (!page)
@@ -373,7 +373,7 @@ static int __cpuinit profile_cpu_callbac
 			per_cpu(cpu_profile_hits, cpu)[1] = page_address(page);
 		}
 		if (!per_cpu(cpu_profile_hits, cpu)[0]) {
-			page = alloc_pages_node(node,
+			page = alloc_pages_exact_node(node,
 					GFP_KERNEL | __GFP_ZERO,
 					0);
 			if (!page)
@@ -564,14 +564,14 @@ static int create_hash_tables(void)
 		int node = cpu_to_node(cpu);
 		struct page *page;
 
-		page = alloc_pages_node(node,
+		page = alloc_pages_exact_node(node,
 				GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
 				0);
 		if (!page)
 			goto out_cleanup;
 		per_cpu(cpu_profile_hits, cpu)[1]
 				= (struct profile_hit *)page_address(page);
-		page = alloc_pages_node(node,
+		page = alloc_pages_exact_node(node,
 				GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
 				0);
 		if (!page)
diff -puN mm/filemap.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid mm/filemap.c
--- a/mm/filemap.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/mm/filemap.c
@@ -521,7 +521,7 @@ struct page *__page_cache_alloc(gfp_t gf
 {
 	if (cpuset_do_page_mem_spread()) {
 		int n = cpuset_mem_spread_node();
-		return alloc_pages_node(n, gfp, 0);
+		return alloc_pages_exact_node(n, gfp, 0);
 	}
 	return alloc_pages(gfp, 0);
 }
diff -puN mm/hugetlb.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid mm/hugetlb.c
--- a/mm/hugetlb.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/mm/hugetlb.c
@@ -630,7 +630,7 @@ static struct page *alloc_fresh_huge_pag
 	if (h->order >= MAX_ORDER)
 		return NULL;
 
-	page = alloc_pages_node(nid,
+	page = alloc_pages_exact_node(nid,
 		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|
 						__GFP_REPEAT|__GFP_NOWARN,
 		huge_page_order(h));
@@ -649,7 +649,7 @@ static struct page *alloc_fresh_huge_pag
  * Use a helper variable to find the next node and then
  * copy it back to hugetlb_next_nid afterwards:
  * otherwise there's a window in which a racer might
- * pass invalid nid MAX_NUMNODES to alloc_pages_node.
+ * pass invalid nid MAX_NUMNODES to alloc_pages_exact_node.
  * But we don't need to use a spin_lock here: it really
  * doesn't matter if occasionally a racer chooses the
  * same nid as we do.  Move nid forward in the mask even
diff -puN mm/mempolicy.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid mm/mempolicy.c
--- a/mm/mempolicy.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/mm/mempolicy.c
@@ -803,7 +803,7 @@ static void migrate_page_add(struct page
 
 static struct page *new_node_page(struct page *page, unsigned long node, int **x)
 {
-	return alloc_pages_node(node, GFP_HIGHUSER_MOVABLE, 0);
+	return alloc_pages_exact_node(node, GFP_HIGHUSER_MOVABLE, 0);
 }
 
 /*
diff -puN mm/migrate.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid mm/migrate.c
--- a/mm/migrate.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/mm/migrate.c
@@ -802,7 +802,7 @@ static struct page *new_page_node(struct
 
 	*result = &pm->status;
 
-	return alloc_pages_node(pm->node,
+	return alloc_pages_exact_node(pm->node,
 				GFP_HIGHUSER_MOVABLE | GFP_THISNODE, 0);
 }
 
diff -puN mm/slab.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid mm/slab.c
--- a/mm/slab.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/mm/slab.c
@@ -1707,7 +1707,7 @@ static void *kmem_getpages(struct kmem_c
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
-	page = alloc_pages_node(nodeid, flags, cachep->gfporder);
+	page = alloc_pages_exact_node(nodeid, flags, cachep->gfporder);
 	if (!page)
 		return NULL;
 
@@ -3261,7 +3261,7 @@ retry:
 		if (local_flags & __GFP_WAIT)
 			local_irq_enable();
 		kmem_flagcheck(cache, flags);
-		obj = kmem_getpages(cache, local_flags, -1);
+		obj = kmem_getpages(cache, local_flags, numa_node_id());
 		if (local_flags & __GFP_WAIT)
 			local_irq_disable();
 		if (obj) {
diff -puN mm/slob.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid mm/slob.c
--- a/mm/slob.c~page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid
+++ a/mm/slob.c
@@ -46,7 +46,7 @@
  * NUMA support in SLOB is fairly simplistic, pushing most of the real
  * logic down to the page allocator, and simply doing the node accounting
  * on the upper levels. In the event that a node id is explicitly
- * provided, alloc_pages_node() with the specified node id is used
+ * provided, alloc_pages_exact_node() with the specified node id is used
  * instead. The common case (or when the node id isn't explicitly provided)
  * will default to the current node, as per numa_node_id().
  *
@@ -244,7 +244,7 @@ static void *slob_new_pages(gfp_t gfp, i
 
 #ifdef CONFIG_NUMA
 	if (node != -1)
-		page = alloc_pages_node(node, gfp, order);
+		page = alloc_pages_exact_node(node, gfp, order);
 	else
 #endif
 		page = alloc_pages(gfp, order);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

