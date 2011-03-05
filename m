From: akpm@linux-foundation.org
Subject: + mm-use-__gfp_other_node-for-transparent-huge-pages.patch added to -mm tree
Date: Fri, 04 Mar 2011 16:07:56 -0800
Message-ID: <201103050007.p2507uuo011933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759880Ab1CEAIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 19:08:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: use __GFP_OTHER_NODE for transparent huge pages
has been added to the -mm tree.  Its filename is
     mm-use-__gfp_other_node-for-transparent-huge-pages.patch

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
Subject: mm: use __GFP_OTHER_NODE for transparent huge pages
From: Andi Kleen <ak@linux.intel.com>

Pass __GFP_OTHER_NODE for transparent hugepages NUMA allocations done by the
hugepages daemon.  This way the low level accounting for local versus
remote pages works correctly.

Contains improvements from Andrea Arcangeli

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/huge_memory.c~mm-use-__gfp_other_node-for-transparent-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-use-__gfp_other_node-for-transparent-huge-pages
+++ a/mm/huge_memory.c
@@ -643,23 +643,24 @@ static int __do_huge_pmd_anonymous_page(
 	return ret;
 }
 
-static inline gfp_t alloc_hugepage_gfpmask(int defrag)
+static inline gfp_t alloc_hugepage_gfpmask(int defrag, gfp_t extra_gfp)
 {
-	return GFP_TRANSHUGE & ~(defrag ? 0 : __GFP_WAIT);
+	return (GFP_TRANSHUGE & ~(defrag ? 0 : __GFP_WAIT)) | extra_gfp;
 }
 
 static inline struct page *alloc_hugepage_vma(int defrag,
 					      struct vm_area_struct *vma,
-					      unsigned long haddr, int nd)
+					      unsigned long haddr, int nd,
+					      gfp_t extra_gfp)
 {
-	return alloc_pages_vma(alloc_hugepage_gfpmask(defrag),
+	return alloc_pages_vma(alloc_hugepage_gfpmask(defrag, extra_gfp),
 			       HPAGE_PMD_ORDER, vma, haddr, nd);
 }
 
 #ifndef CONFIG_NUMA
 static inline struct page *alloc_hugepage(int defrag)
 {
-	return alloc_pages(alloc_hugepage_gfpmask(defrag),
+	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
 			   HPAGE_PMD_ORDER);
 }
 #endif
@@ -678,7 +679,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		if (unlikely(khugepaged_enter(vma)))
 			return VM_FAULT_OOM;
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					  vma, haddr, numa_node_id());
+					  vma, haddr, numa_node_id(), 0);
 		if (unlikely(!page))
 			goto out;
 		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
@@ -799,7 +800,8 @@ static int do_huge_pmd_wp_page_fallback(
 	}
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE,
+		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE | 
+					       __GFP_OTHER_NODE,
 					       vma, address, page_to_nid(page));
 		if (unlikely(!pages[i] ||
 			     mem_cgroup_newpage_charge(pages[i], mm,
@@ -902,7 +904,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow())
 		new_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					      vma, haddr, numa_node_id());
+					      vma, haddr, numa_node_id(), 0);
 	else
 		new_page = NULL;
 
@@ -1775,7 +1777,7 @@ static void collapse_huge_page(struct mm
 	 * scalability.
 	 */
 	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
-				      node);
+				      node, __GFP_OTHER_NODE);
 	if (unlikely(!new_page)) {
 		up_read(&mm->mmap_sem);
 		*hpage = ERR_PTR(-ENOMEM);
_

Patches currently in -mm which might be from ak@linux.intel.com are

mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy.patch
mm-add-alloc_page_vma_node.patch
mm-preserve-original-node-for-transparent-huge-page-copies.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages-checkpatch-fixes.patch
linux-next.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
mm-add-__gfp_other_node-flag.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-add-vm-counters-for-transparent-hugepages.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

