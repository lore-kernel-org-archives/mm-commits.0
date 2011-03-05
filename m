From: akpm@linux-foundation.org
Subject: + mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy.patch added to -mm tree
Date: Fri, 04 Mar 2011 16:01:40 -0800
Message-ID: <201103050001.p2501eh7011641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760032Ab1CEABx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 19:01:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: change alloc_pages_vma to pass down the policy node for local policy
has been added to the -mm tree.  Its filename is
     mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy.patch

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
Subject: mm: change alloc_pages_vma to pass down the policy node for local policy
From: Andi Kleen <ak@linux.intel.com>

Currently alloc_pages_vma() always uses the local node as policy node for
the LOCAL policy.  Pass this node down as an argument instead.

No behaviour change from this patch, but will be needed for followons.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    9 +++++----
 mm/huge_memory.c    |    2 +-
 mm/mempolicy.c      |   11 +++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/gfp.h~mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy include/linux/gfp.h
--- a/include/linux/gfp.h~mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy
+++ a/include/linux/gfp.h
@@ -332,16 +332,17 @@ alloc_pages(gfp_t gfp_mask, unsigned int
 	return alloc_pages_current(gfp_mask, order);
 }
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
-			struct vm_area_struct *vma, unsigned long addr);
+		    	struct vm_area_struct *vma, unsigned long addr,
+			int node);
 #else
 #define alloc_pages(gfp_mask, order) \
 		alloc_pages_node(numa_node_id(), gfp_mask, order)
-#define alloc_pages_vma(gfp_mask, order, vma, addr)	\
+#define alloc_pages_vma(gfp_mask, order, vma, addr, node)	\
 	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
-#define alloc_page_vma(gfp_mask, vma, addr)	\
-	alloc_pages_vma(gfp_mask, 0, vma, addr)
+#define alloc_page_vma(gfp_mask, vma, addr)			\
+	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id())
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
diff -puN mm/huge_memory.c~mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy mm/huge_memory.c
--- a/mm/huge_memory.c~mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy
+++ a/mm/huge_memory.c
@@ -653,7 +653,7 @@ static inline struct page *alloc_hugepag
 					      unsigned long haddr)
 {
 	return alloc_pages_vma(alloc_hugepage_gfpmask(defrag),
-			       HPAGE_PMD_ORDER, vma, haddr);
+			       HPAGE_PMD_ORDER, vma, haddr, numa_node_id());
 }
 
 #ifndef CONFIG_NUMA
diff -puN mm/mempolicy.c~mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy
+++ a/mm/mempolicy.c
@@ -1524,10 +1524,9 @@ static nodemask_t *policy_nodemask(gfp_t
 }
 
 /* Return a zonelist indicated by gfp for node representing a mempolicy */
-static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy)
+static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy,
+	int nd)
 {
-	int nd = numa_node_id();
-
 	switch (policy->mode) {
 	case MPOL_PREFERRED:
 		if (!(policy->flags & MPOL_F_LOCAL))
@@ -1679,7 +1678,7 @@ struct zonelist *huge_zonelist(struct vm
 		zl = node_zonelist(interleave_nid(*mpol, vma, addr,
 				huge_page_shift(hstate_vma(vma))), gfp_flags);
 	} else {
-		zl = policy_zonelist(gfp_flags, *mpol);
+		zl = policy_zonelist(gfp_flags, *mpol, numa_node_id());
 		if ((*mpol)->mode == MPOL_BIND)
 			*nodemask = &(*mpol)->v.nodes;
 	}
@@ -1820,7 +1819,7 @@ static struct page *alloc_page_interleav
  */
 struct page *
 alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr)
+		unsigned long addr, int node)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
@@ -1836,7 +1835,7 @@ alloc_pages_vma(gfp_t gfp, int order, st
 		put_mems_allowed();
 		return page;
 	}
-	zl = policy_zonelist(gfp, pol);
+	zl = policy_zonelist(gfp, pol, node);
 	if (unlikely(mpol_needs_cond_ref(pol))) {
 		/*
 		 * slow path: ref counted shared policy
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

