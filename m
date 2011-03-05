From: akpm@linux-foundation.org
Subject: + mm-use-correct-numa-policy-node-for-transparent-hugepages.patch added to -mm tree
Date: Fri, 04 Mar 2011 16:01:46 -0800
Message-ID: <201103050001.p2501kFL011653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760072Ab1CEAB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 19:01:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: use correct numa policy node for transparent hugepages
has been added to the -mm tree.  Its filename is
     mm-use-correct-numa-policy-node-for-transparent-hugepages.patch

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
Subject: mm: use correct numa policy node for transparent hugepages
From: Andi Kleen <ak@linux.intel.com>

Pass down the correct node for a transparent hugepage allocation.  Most
callers continue to use the current node, however the hugepaged daemon now
uses the previous node of the first to be collapsed page instead.  This
ensures that khugepaged does not mess up local memory for an existing
process which uses local policy.

The choice of node is somewhat primitive currently: it just uses the node
of the first page in the pmd range.  An alternative would be to look at
multiple pages and use the most popular node.  I used the simplest variant
for now which should work well enough for the case of all pages being on
the same node.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   24 +++++++++++++++++-------
 mm/mempolicy.c   |    3 ++-
 2 files changed, 19 insertions(+), 8 deletions(-)

diff -puN mm/huge_memory.c~mm-use-correct-numa-policy-node-for-transparent-hugepages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-use-correct-numa-policy-node-for-transparent-hugepages
+++ a/mm/huge_memory.c
@@ -650,10 +650,10 @@ static inline gfp_t alloc_hugepage_gfpma
 
 static inline struct page *alloc_hugepage_vma(int defrag,
 					      struct vm_area_struct *vma,
-					      unsigned long haddr)
+					      unsigned long haddr, int nd)
 {
 	return alloc_pages_vma(alloc_hugepage_gfpmask(defrag),
-			       HPAGE_PMD_ORDER, vma, haddr, numa_node_id());
+			       HPAGE_PMD_ORDER, vma, haddr, nd);
 }
 
 #ifndef CONFIG_NUMA
@@ -678,7 +678,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		if (unlikely(khugepaged_enter(vma)))
 			return VM_FAULT_OOM;
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					  vma, haddr);
+					  vma, haddr, numa_node_id());
 		if (unlikely(!page))
 			goto out;
 		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
@@ -902,7 +902,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow())
 		new_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					      vma, haddr);
+					      vma, haddr, numa_node_id());
 	else
 		new_page = NULL;
 
@@ -1745,7 +1745,8 @@ static void __collapse_huge_page_copy(pt
 static void collapse_huge_page(struct mm_struct *mm,
 			       unsigned long address,
 			       struct page **hpage,
-			       struct vm_area_struct *vma)
+			       struct vm_area_struct *vma,
+			       int node)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -1773,7 +1774,8 @@ static void collapse_huge_page(struct mm
 	 * mmap_sem in read mode is good idea also to allow greater
 	 * scalability.
 	 */
-	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address);
+	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
+				      node);
 	if (unlikely(!new_page)) {
 		up_read(&mm->mmap_sem);
 		*hpage = ERR_PTR(-ENOMEM);
@@ -1919,6 +1921,7 @@ static int khugepaged_scan_pmd(struct mm
 	struct page *page;
 	unsigned long _address;
 	spinlock_t *ptl;
+	int node = -1;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -1949,6 +1952,13 @@ static int khugepaged_scan_pmd(struct mm
 		page = vm_normal_page(vma, _address, pteval);
 		if (unlikely(!page))
 			goto out_unmap;
+		/*
+		 * Chose the node of the first page. This could
+		 * be more sophisticated and look at more pages,
+		 * but isn't for now.
+		 */
+		if (node == -1)
+			node = page_to_nid(page);
 		VM_BUG_ON(PageCompound(page));
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
 			goto out_unmap;
@@ -1965,7 +1975,7 @@ out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (ret)
 		/* collapse_huge_page will return with the mmap_sem released */
-		collapse_huge_page(mm, address, hpage, vma);
+		collapse_huge_page(mm, address, hpage, vma, node);
 out:
 	return ret;
 }
diff -puN mm/mempolicy.c~mm-use-correct-numa-policy-node-for-transparent-hugepages mm/mempolicy.c
--- a/mm/mempolicy.c~mm-use-correct-numa-policy-node-for-transparent-hugepages
+++ a/mm/mempolicy.c
@@ -1891,7 +1891,8 @@ struct page *alloc_pages_current(gfp_t g
 		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
 	else
 		page = __alloc_pages_nodemask(gfp, order,
-			policy_zonelist(gfp, pol), policy_nodemask(gfp, pol));
+	      			policy_zonelist(gfp, pol, numa_node_id()),
+				policy_nodemask(gfp, pol));
 	put_mems_allowed();
 	return page;
 }
_

Patches currently in -mm which might be from ak@linux.intel.com are

mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy.patch
mm-add-alloc_page_vma_node.patch
mm-preserve-original-node-for-transparent-huge-page-copies.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages.patch
linux-next.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

