From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-allocate-transparent-hugepages-on-local-node.patch removed from -mm
 tree
Date: Thu, 12 Feb 2015 11:37:49 -0800
Message-ID: <54dd010d.Yw94SWFpF3RNMPTq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbbBLThu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: allocate transparent hugepages on local node
has been removed from the -mm tree.  Its filename was
     mm-thp-allocate-transparent-hugepages-on-local-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/thp: allocate transparent hugepages on local node

This make sure that we try to allocate hugepages from local node if
allowed by mempolicy.  If we can't, we fallback to small page allocation
based on mempolicy.  This is based on the observation that allocating
pages on local node is more beneficial than allocating hugepages on remote
node.

With this patch applied we may find transparent huge page allocation
failures if the current node doesn't have enough freee hugepages.  Before
this patch such failures result in us retrying the allocation on other
nodes in the numa node mask.

[akpm@linux-foundation.org: fix comment, add CONFIG_TRANSPARENT_HUGEPAGE dependency]
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++
 mm/huge_memory.c    |   24 +++++---------
 mm/mempolicy.c      |   72 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 15 deletions(-)

diff -puN include/linux/gfp.h~mm-thp-allocate-transparent-hugepages-on-local-node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-thp-allocate-transparent-hugepages-on-local-node
+++ a/include/linux/gfp.h
@@ -335,11 +335,15 @@ alloc_pages(gfp_t gfp_mask, unsigned int
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr,
 			int node);
+extern struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
+				       unsigned long addr, int order);
 #else
 #define alloc_pages(gfp_mask, order) \
 		alloc_pages_node(numa_node_id(), gfp_mask, order)
 #define alloc_pages_vma(gfp_mask, order, vma, addr, node)	\
 	alloc_pages(gfp_mask, order)
+#define alloc_hugepage_vma(gfp_mask, vma, addr, order)	\
+	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
diff -puN mm/huge_memory.c~mm-thp-allocate-transparent-hugepages-on-local-node mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-allocate-transparent-hugepages-on-local-node
+++ a/mm/huge_memory.c
@@ -761,15 +761,6 @@ static inline gfp_t alloc_hugepage_gfpma
 	return (GFP_TRANSHUGE & ~(defrag ? 0 : __GFP_WAIT)) | extra_gfp;
 }
 
-static inline struct page *alloc_hugepage_vma(int defrag,
-					      struct vm_area_struct *vma,
-					      unsigned long haddr, int nd,
-					      gfp_t extra_gfp)
-{
-	return alloc_pages_vma(alloc_hugepage_gfpmask(defrag, extra_gfp),
-			       HPAGE_PMD_ORDER, vma, haddr, nd);
-}
-
 /* Caller must hold page table lock. */
 static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
@@ -790,6 +781,7 @@ int do_huge_pmd_anonymous_page(struct mm
 			       unsigned long address, pmd_t *pmd,
 			       unsigned int flags)
 {
+	gfp_t gfp;
 	struct page *page;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 
@@ -824,8 +816,8 @@ int do_huge_pmd_anonymous_page(struct mm
 		}
 		return 0;
 	}
-	page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-			vma, haddr, numa_node_id(), 0);
+	gfp = alloc_hugepage_gfpmask(transparent_hugepage_defrag(vma), 0);
+	page = alloc_hugepage_vma(gfp, vma, haddr, HPAGE_PMD_ORDER);
 	if (unlikely(!page)) {
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
@@ -1113,10 +1105,12 @@ int do_huge_pmd_wp_page(struct mm_struct
 	spin_unlock(ptl);
 alloc:
 	if (transparent_hugepage_enabled(vma) &&
-	    !transparent_hugepage_debug_cow())
-		new_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					      vma, haddr, numa_node_id(), 0);
-	else
+	    !transparent_hugepage_debug_cow()) {
+		gfp_t gfp;
+
+		gfp = alloc_hugepage_gfpmask(transparent_hugepage_defrag(vma), 0);
+		new_page = alloc_hugepage_vma(gfp, vma, haddr, HPAGE_PMD_ORDER);
+	} else
 		new_page = NULL;
 
 	if (unlikely(!new_page)) {
diff -puN mm/mempolicy.c~mm-thp-allocate-transparent-hugepages-on-local-node mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-allocate-transparent-hugepages-on-local-node
+++ a/mm/mempolicy.c
@@ -2030,6 +2030,78 @@ retry_cpuset:
 	return page;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/**
+ * alloc_hugepage_vma: Allocate a hugepage for a VMA
+ * @gfp:
+ *   %GFP_USER	  user allocation.
+ *   %GFP_KERNEL  kernel allocations,
+ *   %GFP_HIGHMEM highmem/user allocations,
+ *   %GFP_FS	  allocation should not call back into a file system.
+ *   %GFP_ATOMIC  don't sleep.
+ *
+ * @vma:   Pointer to VMA or NULL if not available.
+ * @addr:  Virtual Address of the allocation. Must be inside the VMA.
+ * @order: Order of the hugepage for gfp allocation.
+ *
+ * This functions allocate a huge page from the kernel page pool and applies
+ * a NUMA policy associated with the VMA or the current process.
+ * For policy other than %MPOL_INTERLEAVE, we make sure we allocate hugepage
+ * only from the current node if the current node is part of the node mask.
+ * If we can't allocate a hugepage we fail the allocation and don' try to fallback
+ * to other nodes in the node mask. If the current node is not part of node mask
+ * or if the NUMA policy is MPOL_INTERLEAVE we use the allocator that can
+ * fallback to nodes in the policy node mask.
+ *
+ * When VMA is not NULL caller must hold down_read on the mmap_sem of the
+ * mm_struct of the VMA to prevent it from going away. Should be used for
+ * all allocations for pages that will be mapped into
+ * user space. Returns NULL when no page can be allocated.
+ *
+ * Should be called with vma->vm_mm->mmap_sem held.
+ *
+ */
+struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
+				unsigned long addr, int order)
+{
+	struct page *page;
+	nodemask_t *nmask;
+	struct mempolicy *pol;
+	int node = numa_node_id();
+	unsigned int cpuset_mems_cookie;
+
+retry_cpuset:
+	pol = get_vma_policy(vma, addr);
+	cpuset_mems_cookie = read_mems_allowed_begin();
+	/*
+	 * For interleave policy, we don't worry about
+	 * current node. Otherwise if current node is
+	 * in nodemask, try to allocate hugepage from
+	 * the current node. Don't fall back to other nodes
+	 * for THP.
+	 */
+	if (unlikely(pol->mode == MPOL_INTERLEAVE))
+		goto alloc_with_fallback;
+	nmask = policy_nodemask(gfp, pol);
+	if (!nmask || node_isset(node, *nmask)) {
+		mpol_cond_put(pol);
+		page = alloc_pages_exact_node(node, gfp, order);
+		if (unlikely(!page &&
+			     read_mems_allowed_retry(cpuset_mems_cookie)))
+			goto retry_cpuset;
+		return page;
+	}
+alloc_with_fallback:
+	mpol_cond_put(pol);
+	/*
+	 * if current node is not part of node mask, try
+	 * the allocation from any node, and we can do retry
+	 * in that case.
+	 */
+	return alloc_pages_vma(gfp, order, vma, addr, node);
+}
+#endif
+
 /**
  * 	alloc_pages_current - Allocate pages.
  *
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
linux-next.patch

