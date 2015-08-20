From: akpm@linux-foundation.org
Subject: + mm-rename-alloc_pages_exact_node-to-__alloc_pages_node.patch
 added to -mm tree
Date: Thu, 20 Aug 2015 15:30:47 -0700
Message-ID: <55d65517.l8zeTmjzdahbM7Qd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbbHTWau (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Aug 2015 18:30:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, arnd@arndb.de, benh@kernel.crashing.org, cl@linux.com, cpw@sgi.com, fenghua.yu@intel.com, gleb@kernel.org, gthelen@google.com, hannes@cmpxchg.org, hpa@zytor.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, paulus@samba.org, pbonzini@redhat.com, penberg@kernel.org, rientjes@google.com, robinmholt@gmail.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename alloc_pages_exact_node() to __alloc_pages_node()
has been added to the -mm tree.  Its filename is
     mm-rename-alloc_pages_exact_node-to-__alloc_pages_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-alloc_pages_exact_node-to-__alloc_pages_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-alloc_pages_exact_node-to-__alloc_pages_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: rename alloc_pages_exact_node() to __alloc_pages_node()

alloc_pages_exact_node() was introduced in 6484eb3e2a81 ("page allocator:
do not check NUMA node ID when the caller knows the node is valid") as an
optimized variant of alloc_pages_node(), that doesn't fallback to current
node for nid == NUMA_NO_NODE.  Unfortunately the name of the function can
easily suggest that the allocation is restricted to the given node and
fails otherwise.  In truth, the node is only preferred, unless
__GFP_THISNODE is passed among the gfp flags.

The misleading name has lead to mistakes in the past, see 5265047ac301
("mm, thp: really limit transparent hugepage allocation to local node")
and b360edb43f8e ("mm, mempolicy: migrate_to_node should only migrate to
node").

Another issue with the name is that there's a family of
alloc_pages_exact*() functions where 'exact' means exact size (instead of
page order), which leads to more confusion.

To prevent further mistakes, this patch effectively renames
alloc_pages_exact_node() to __alloc_pages_node() to better convey that
it's an optimized variant of alloc_pages_node() not intended for general
usage.  Both functions get described in comments.

It has been also considered to really provide a convenience function for
allocations restricted to a node, but the major opinion seems to be that
__GFP_THISNODE already provides that functionality and we shouldn't
duplicate the API needlessly.  The number of users would be small anyway.

Existing callers of alloc_pages_exact_node() are simply converted to call
__alloc_pages_node(), with the exception of sba_alloc_coherent() which
open-codes the check for NUMA_NO_NODE, so it is converted to use
alloc_pages_node() instead.  This means it no longer performs some
VM_BUG_ON checks, and since the current check for nid in
alloc_pages_node() uses a 'nid < 0' comparison (which includes
NUMA_NO_NODE), it may hide wrong values which would be previously exposed.
 Both differences will be rectified by the next patch.

To sum up, this patch makes no functional changes, except temporarily
hiding potentially buggy callers.  Restricting the checks in
alloc_pages_node() is left for the next patch which can in turn expose
more existing buggy callers.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Robin Holt <robinmholt@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cliff Whickman <cpw@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c   |    6 +-----
 arch/ia64/kernel/uncached.c       |    2 +-
 arch/ia64/sn/pci/pci_dma.c        |    2 +-
 arch/powerpc/platforms/cell/ras.c |    2 +-
 arch/x86/kvm/vmx.c                |    2 +-
 drivers/misc/sgi-xp/xpc_uv.c      |    2 +-
 include/linux/gfp.h               |   23 +++++++++++++++--------
 kernel/profile.c                  |    8 ++++----
 mm/filemap.c                      |    2 +-
 mm/huge_memory.c                  |    2 +-
 mm/hugetlb.c                      |    4 ++--
 mm/memory-failure.c               |    2 +-
 mm/mempolicy.c                    |    4 ++--
 mm/migrate.c                      |    4 ++--
 mm/page_alloc.c                   |    2 --
 mm/slab.c                         |    2 +-
 mm/slob.c                         |    4 ++--
 mm/slub.c                         |    2 +-
 18 files changed, 38 insertions(+), 37 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -1140,13 +1140,9 @@ sba_alloc_coherent(struct device *dev, s
 
 #ifdef CONFIG_NUMA
 	{
-		int node = ioc->node;
 		struct page *page;
 
-		if (node == NUMA_NO_NODE)
-			node = numa_node_id();
-
-		page = alloc_pages_exact_node(node, flags, get_order(size));
+		page = alloc_pages_node(ioc->node, flags, get_order(size));
 		if (unlikely(!page))
 			return NULL;
 
diff -puN arch/ia64/kernel/uncached.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node arch/ia64/kernel/uncached.c
--- a/arch/ia64/kernel/uncached.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/arch/ia64/kernel/uncached.c
@@ -97,7 +97,7 @@ static int uncached_add_chunk(struct unc
 
 	/* attempt to allocate a granule's worth of cached memory pages */
 
-	page = alloc_pages_exact_node(nid,
+	page = __alloc_pages_node(nid,
 				GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				IA64_GRANULE_SHIFT-PAGE_SHIFT);
 	if (!page) {
diff -puN arch/ia64/sn/pci/pci_dma.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node arch/ia64/sn/pci/pci_dma.c
--- a/arch/ia64/sn/pci/pci_dma.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/arch/ia64/sn/pci/pci_dma.c
@@ -92,7 +92,7 @@ static void *sn_dma_alloc_coherent(struc
 	 */
 	node = pcibus_to_node(pdev->bus);
 	if (likely(node >=0)) {
-		struct page *p = alloc_pages_exact_node(node,
+		struct page *p = __alloc_pages_node(node,
 						flags, get_order(size));
 
 		if (likely(p))
diff -puN arch/powerpc/platforms/cell/ras.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node arch/powerpc/platforms/cell/ras.c
--- a/arch/powerpc/platforms/cell/ras.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/arch/powerpc/platforms/cell/ras.c
@@ -123,7 +123,7 @@ static int __init cbe_ptcal_enable_on_no
 
 	area->nid = nid;
 	area->order = order;
-	area->pages = alloc_pages_exact_node(area->nid,
+	area->pages = __alloc_pages_node(area->nid,
 						GFP_KERNEL|__GFP_THISNODE,
 						area->order);
 
diff -puN arch/x86/kvm/vmx.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/arch/x86/kvm/vmx.c
@@ -3150,7 +3150,7 @@ static struct vmcs *alloc_vmcs_cpu(int c
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = alloc_pages_exact_node(node, GFP_KERNEL, vmcs_config.order);
+	pages = __alloc_pages_node(node, GFP_KERNEL, vmcs_config.order);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
diff -puN drivers/misc/sgi-xp/xpc_uv.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -239,7 +239,7 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = alloc_pages_exact_node(nid,
+	page = __alloc_pages_node(nid,
 				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				      pg_order);
 	if (page == NULL) {
diff -puN include/linux/gfp.h~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/include/linux/gfp.h
@@ -303,20 +303,28 @@ __alloc_pages(gfp_t gfp_mask, unsigned i
 	return __alloc_pages_nodemask(gfp_mask, order, zonelist, NULL);
 }
 
-static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
-						unsigned int order)
+/*
+ * Allocate pages, preferring the node given as nid. The node must be valid and
+ * online. For more general interface, see alloc_pages_node().
+ */
+static inline struct page *
+__alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
 {
-	/* Unknown node is current node */
-	if (nid < 0)
-		nid = numa_node_id();
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES || !node_online(nid));
 
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
 
-static inline struct page *alloc_pages_exact_node(int nid, gfp_t gfp_mask,
+/*
+ * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
+ * prefer the current CPU's node.
+ */
+static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES || !node_online(nid));
+	/* Unknown node is current node */
+	if (nid < 0)
+		nid = numa_node_id();
 
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
@@ -357,7 +365,6 @@ extern unsigned long get_zeroed_page(gfp
 
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
 void free_pages_exact(void *virt, size_t size);
-/* This is different from alloc_pages_exact_node !!! */
 void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 #define __get_free_page(gfp_mask) \
diff -puN kernel/profile.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node kernel/profile.c
--- a/kernel/profile.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/kernel/profile.c
@@ -339,7 +339,7 @@ static int profile_cpu_callback(struct n
 		node = cpu_to_mem(cpu);
 		per_cpu(cpu_profile_flip, cpu) = 0;
 		if (!per_cpu(cpu_profile_hits, cpu)[1]) {
-			page = alloc_pages_exact_node(node,
+			page = __alloc_pages_node(node,
 					GFP_KERNEL | __GFP_ZERO,
 					0);
 			if (!page)
@@ -347,7 +347,7 @@ static int profile_cpu_callback(struct n
 			per_cpu(cpu_profile_hits, cpu)[1] = page_address(page);
 		}
 		if (!per_cpu(cpu_profile_hits, cpu)[0]) {
-			page = alloc_pages_exact_node(node,
+			page = __alloc_pages_node(node,
 					GFP_KERNEL | __GFP_ZERO,
 					0);
 			if (!page)
@@ -543,14 +543,14 @@ static int create_hash_tables(void)
 		int node = cpu_to_mem(cpu);
 		struct page *page;
 
-		page = alloc_pages_exact_node(node,
+		page = __alloc_pages_node(node,
 				GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				0);
 		if (!page)
 			goto out_cleanup;
 		per_cpu(cpu_profile_hits, cpu)[1]
 				= (struct profile_hit *)page_address(page);
-		page = alloc_pages_exact_node(node,
+		page = __alloc_pages_node(node,
 				GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				0);
 		if (!page)
diff -puN mm/filemap.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/filemap.c
--- a/mm/filemap.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/filemap.c
@@ -674,7 +674,7 @@ struct page *__page_cache_alloc(gfp_t gf
 		do {
 			cpuset_mems_cookie = read_mems_allowed_begin();
 			n = cpuset_mem_spread_node();
-			page = alloc_pages_exact_node(n, gfp, 0);
+			page = __alloc_pages_node(n, gfp, 0);
 		} while (!page && read_mems_allowed_retry(cpuset_mems_cookie));
 
 		return page;
diff -puN mm/huge_memory.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/huge_memory.c
@@ -2414,7 +2414,7 @@ khugepaged_alloc_page(struct page **hpag
 	 */
 	up_read(&mm->mmap_sem);
 
-	*hpage = alloc_pages_exact_node(node, gfp, HPAGE_PMD_ORDER);
+	*hpage = __alloc_pages_node(node, gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
diff -puN mm/hugetlb.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/hugetlb.c
--- a/mm/hugetlb.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/hugetlb.c
@@ -1331,7 +1331,7 @@ static struct page *alloc_fresh_huge_pag
 {
 	struct page *page;
 
-	page = alloc_pages_exact_node(nid,
+	page = __alloc_pages_node(nid,
 		htlb_alloc_mask(h)|__GFP_COMP|__GFP_THISNODE|
 						__GFP_REPEAT|__GFP_NOWARN,
 		huge_page_order(h));
@@ -1483,7 +1483,7 @@ static struct page *alloc_buddy_huge_pag
 				   __GFP_REPEAT|__GFP_NOWARN,
 				   huge_page_order(h));
 	else
-		page = alloc_pages_exact_node(nid,
+		page = __alloc_pages_node(nid,
 			htlb_alloc_mask(h)|__GFP_COMP|__GFP_THISNODE|
 			__GFP_REPEAT|__GFP_NOWARN, huge_page_order(h));
 
diff -puN mm/memory-failure.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/memory-failure.c
--- a/mm/memory-failure.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/memory-failure.c
@@ -1521,7 +1521,7 @@ static struct page *new_page(struct page
 		return alloc_huge_page_node(page_hstate(compound_head(p)),
 						   nid);
 	else
-		return alloc_pages_exact_node(nid, GFP_HIGHUSER_MOVABLE, 0);
+		return __alloc_pages_node(nid, GFP_HIGHUSER_MOVABLE, 0);
 }
 
 /*
diff -puN mm/mempolicy.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/mempolicy.c
--- a/mm/mempolicy.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/mempolicy.c
@@ -942,7 +942,7 @@ static struct page *new_node_page(struct
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					node);
 	else
-		return alloc_pages_exact_node(node, GFP_HIGHUSER_MOVABLE |
+		return __alloc_pages_node(node, GFP_HIGHUSER_MOVABLE |
 						    __GFP_THISNODE, 0);
 }
 
@@ -1998,7 +1998,7 @@ retry_cpuset:
 		nmask = policy_nodemask(gfp, pol);
 		if (!nmask || node_isset(hpage_node, *nmask)) {
 			mpol_cond_put(pol);
-			page = alloc_pages_exact_node(hpage_node,
+			page = __alloc_pages_node(hpage_node,
 						gfp | __GFP_THISNODE, order);
 			goto out;
 		}
diff -puN mm/migrate.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/migrate.c
--- a/mm/migrate.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/migrate.c
@@ -1195,7 +1195,7 @@ static struct page *new_page_node(struct
 		return alloc_huge_page_node(page_hstate(compound_head(p)),
 					pm->node);
 	else
-		return alloc_pages_exact_node(pm->node,
+		return __alloc_pages_node(pm->node,
 				GFP_HIGHUSER_MOVABLE | __GFP_THISNODE, 0);
 }
 
@@ -1555,7 +1555,7 @@ static struct page *alloc_misplaced_dst_
 	int nid = (int) data;
 	struct page *newpage;
 
-	newpage = alloc_pages_exact_node(nid,
+	newpage = __alloc_pages_node(nid,
 					 (GFP_HIGHUSER_MOVABLE |
 					  __GFP_THISNODE | __GFP_NOMEMALLOC |
 					  __GFP_NORETRY | __GFP_NOWARN) &
diff -puN mm/page_alloc.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/page_alloc.c
@@ -3511,8 +3511,6 @@ EXPORT_SYMBOL(alloc_pages_exact);
  *
  * Like alloc_pages_exact(), but try to allocate on node nid first before falling
  * back.
- * Note this is not alloc_pages_exact_node() which allocates on a specific node,
- * but is not exact.
  */
 void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
 {
diff -puN mm/slab.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/slab.c
--- a/mm/slab.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/slab.c
@@ -1595,7 +1595,7 @@ static struct page *kmem_getpages(struct
 	if (memcg_charge_slab(cachep, flags, cachep->gfporder))
 		return NULL;
 
-	page = alloc_pages_exact_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
+	page = __alloc_pages_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
 	if (!page) {
 		memcg_uncharge_slab(cachep, cachep->gfporder);
 		slab_out_of_memory(cachep, flags, nodeid);
diff -puN mm/slob.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/slob.c
--- a/mm/slob.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/slob.c
@@ -45,7 +45,7 @@
  * NUMA support in SLOB is fairly simplistic, pushing most of the real
  * logic down to the page allocator, and simply doing the node accounting
  * on the upper levels. In the event that a node id is explicitly
- * provided, alloc_pages_exact_node() with the specified node id is used
+ * provided, __alloc_pages_node() with the specified node id is used
  * instead. The common case (or when the node id isn't explicitly provided)
  * will default to the current node, as per numa_node_id().
  *
@@ -193,7 +193,7 @@ static void *slob_new_pages(gfp_t gfp, i
 
 #ifdef CONFIG_NUMA
 	if (node != NUMA_NO_NODE)
-		page = alloc_pages_exact_node(node, gfp, order);
+		page = __alloc_pages_node(node, gfp, order);
 	else
 #endif
 		page = alloc_pages(gfp, order);
diff -puN mm/slub.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node mm/slub.c
--- a/mm/slub.c~mm-rename-alloc_pages_exact_node-to-__alloc_pages_node
+++ a/mm/slub.c
@@ -1334,7 +1334,7 @@ static inline struct page *alloc_slab_pa
 	if (node == NUMA_NO_NODE)
 		page = alloc_pages(flags, order);
 	else
-		page = alloc_pages_exact_node(node, flags, order);
+		page = __alloc_pages_node(node, flags, order);
 
 	if (!page)
 		memcg_uncharge_slab(s, order);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-rename-and-move-get-set_freepage_migratetype-v2.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
mm-rename-alloc_pages_exact_node-to-__alloc_pages_node.patch
mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch
mm-use-numa_mem_id-in-alloc_pages_node.patch

