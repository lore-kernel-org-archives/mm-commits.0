From: akpm@linux-foundation.org
Subject: + mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch
 added to -mm tree
Date: Fri, 30 Jan 2015 15:28:02 -0800
Message-ID: <54cc1382.EgfFpljuWomrQ44k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761090AbbA3X2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:28:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: merge alloc_hugepage_vma to alloc_pages_vma
has been added to the -mm tree.  Its filename is
     mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch

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
Subject: mm/mempolicy.c: merge alloc_hugepage_vma to alloc_pages_vma

Commit "mm/thp: Allocate transparent hugepages on local node" introduced
alloc_hugepage_vma() to mm/mempolicy.c to perform a special policy for THP
allocations.  The function has the same interface as alloc_pages_vma(),
shares a lot of boilerplate code and a long comment.

This patch merges the hugepage special case into alloc_pages_vma.  The
extra if condition should be cheap enough price to pay.  We also prevent a
(however unlikely) race with parallel mems_allowed update, which could
make hugepage allocation restart only within the fallback call to
alloc_hugepage_vma() and not reconsider the special rule in
alloc_hugepage_vma().

Also by making sure mpol_cond_put(pol) is always called before actual
allocation attempt, we can use a single exit path within the function.

Also update the comment for missing node parameter and obsolete reference
to mm_sem.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   12 ++--
 mm/mempolicy.c      |  118 +++++++++++-------------------------------
 2 files changed, 39 insertions(+), 91 deletions(-)

diff -puN include/linux/gfp.h~mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma include/linux/gfp.h
--- a/include/linux/gfp.h~mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma
+++ a/include/linux/gfp.h
@@ -334,22 +334,22 @@ alloc_pages(gfp_t gfp_mask, unsigned int
 }
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr,
-			int node);
-extern struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
-				       unsigned long addr, int order);
+			int node, bool hugepage);
+#define alloc_hugepage_vma(gfp_mask, vma, addr, order)	\
+	alloc_pages_vma(gfp_mask, order, vma, addr, numa_node_id(), true)
 #else
 #define alloc_pages(gfp_mask, order) \
 		alloc_pages_node(numa_node_id(), gfp_mask, order)
-#define alloc_pages_vma(gfp_mask, order, vma, addr, node)	\
+#define alloc_pages_vma(gfp_mask, order, vma, addr, node, false)\
 	alloc_pages(gfp_mask, order)
 #define alloc_hugepage_vma(gfp_mask, vma, addr, order)	\
 	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
-	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id())
+	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id(), false)
 #define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
-	alloc_pages_vma(gfp_mask, 0, vma, addr, node)
+	alloc_pages_vma(gfp_mask, 0, vma, addr, node, false)
 
 extern struct page *alloc_kmem_pages(gfp_t gfp_mask, unsigned int order);
 extern struct page *alloc_kmem_pages_node(int nid, gfp_t gfp_mask,
diff -puN mm/mempolicy.c~mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma
+++ a/mm/mempolicy.c
@@ -1988,120 +1988,68 @@ static struct page *alloc_page_interleav
  *	@order:Order of the GFP allocation.
  * 	@vma:  Pointer to VMA or NULL if not available.
  *	@addr: Virtual Address of the allocation. Must be inside the VMA.
+ *	@node: Which node to prefer for allocation (modulo policy).
+ *	@hugepage: for hugepages try only the preferred node if possible
  *
  * 	This function allocates a page from the kernel page pool and applies
  *	a NUMA policy associated with the VMA or the current process.
  *	When VMA is not NULL caller must hold down_read on the mmap_sem of the
  *	mm_struct of the VMA to prevent it from going away. Should be used for
- *	all allocations for pages that will be mapped into
- * 	user space. Returns NULL when no page can be allocated.
- *
- *	Should be called with the mm_sem of the vma hold.
+ *	all allocations for pages that will be mapped into user space. Returns
+ *	NULL when no page can be allocated.
  */
 struct page *
 alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr, int node)
+		unsigned long addr, int node, bool hugepage)
 {
 	struct mempolicy *pol;
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
+	struct zonelist *zl;
+	nodemask_t *nmask;
 
 retry_cpuset:
 	pol = get_vma_policy(vma, addr);
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
-	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
+	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage &&
+					pol->mode != MPOL_INTERLEAVE)) {
+		/*
+		 * For hugepage allocation and non-interleave policy which
+		 * allows the current node, we only try to allocate from the
+		 * current node and don't fall back to other nodes, as the
+		 * cost of remote accesses would likely offset THP benefits.
+		 *
+		 * If the policy is interleave, or does not allow the current
+		 * node in its nodemask, we allocate the standard way.
+		 */
+		nmask = policy_nodemask(gfp, pol);
+		if (!nmask || node_isset(node, *nmask)) {
+			mpol_cond_put(pol);
+			page = alloc_pages_exact_node(node, gfp, order);
+			goto out;
+		}
+	}
+
+	if (pol->mode == MPOL_INTERLEAVE) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
 		page = alloc_page_interleave(gfp, order, nid);
-		if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
-			goto retry_cpuset;
-
-		return page;
+		goto out;
 	}
-	page = __alloc_pages_nodemask(gfp, order,
-				      policy_zonelist(gfp, pol, node),
-				      policy_nodemask(gfp, pol));
+
+	nmask = policy_nodemask(gfp, pol);
+	zl = policy_zonelist(gfp, pol, node);
 	mpol_cond_put(pol);
+	page = __alloc_pages_nodemask(gfp, order, zl, nmask);
+out:
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 	return page;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/**
- * alloc_hugepage_vma: Allocate a hugepage for a VMA
- * @gfp:
- *   %GFP_USER	  user allocation.
- *   %GFP_KERNEL  kernel allocations,
- *   %GFP_HIGHMEM highmem/user allocations,
- *   %GFP_FS	  allocation should not call back into a file system.
- *   %GFP_ATOMIC  don't sleep.
- *
- * @vma:   Pointer to VMA or NULL if not available.
- * @addr:  Virtual Address of the allocation. Must be inside the VMA.
- * @order: Order of the hugepage for gfp allocation.
- *
- * This functions allocate a huge page from the kernel page pool and applies
- * a NUMA policy associated with the VMA or the current process.
- * For policy other than %MPOL_INTERLEAVE, we make sure we allocate hugepage
- * only from the current node if the current node is part of the node mask.
- * If we can't allocate a hugepage we fail the allocation and don' try to fallback
- * to other nodes in the node mask. If the current node is not part of node mask
- * or if the NUMA policy is MPOL_INTERLEAVE we use the allocator that can
- * fallback to nodes in the policy node mask.
- *
- * When VMA is not NULL caller must hold down_read on the mmap_sem of the
- * mm_struct of the VMA to prevent it from going away. Should be used for
- * all allocations for pages that will be mapped into
- * user space. Returns NULL when no page can be allocated.
- *
- * Should be called with vma->vm_mm->mmap_sem held.
- *
- */
-struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
-				unsigned long addr, int order)
-{
-	struct page *page;
-	nodemask_t *nmask;
-	struct mempolicy *pol;
-	int node = numa_node_id();
-	unsigned int cpuset_mems_cookie;
-
-retry_cpuset:
-	pol = get_vma_policy(vma, addr);
-	cpuset_mems_cookie = read_mems_allowed_begin();
-	/*
-	 * For interleave policy, we don't worry about
-	 * current node. Otherwise if current node is
-	 * in nodemask, try to allocate hugepage from
-	 * the current node. Don't fall back to other nodes
-	 * for THP.
-	 */
-	if (unlikely(pol->mode == MPOL_INTERLEAVE))
-		goto alloc_with_fallback;
-	nmask = policy_nodemask(gfp, pol);
-	if (!nmask || node_isset(node, *nmask)) {
-		mpol_cond_put(pol);
-		page = alloc_pages_exact_node(node, gfp, order);
-		if (unlikely(!page &&
-			     read_mems_allowed_retry(cpuset_mems_cookie)))
-			goto retry_cpuset;
-		return page;
-	}
-alloc_with_fallback:
-	mpol_cond_put(pol);
-	/*
-	 * if current node is not part of node mask, try
-	 * the allocation from any node, and we can do retry
-	 * in that case.
-	 */
-	return alloc_pages_vma(gfp, order, vma, addr, node);
-}
-#endif
-
 /**
  * 	alloc_pages_current - Allocate pages.
  *
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch

