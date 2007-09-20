From: akpm@linux-foundation.org
Subject: - fix-numa-memory-policy-reference-counting.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:59 -0700
Message-ID: <200709202115.l8KLFxMt002964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724AbXITV2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Fix NUMA Memory Policy Reference Counting
has been removed from the -mm tree.  Its filename was
     fix-numa-memory-policy-reference-counting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix NUMA Memory Policy Reference Counting
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

This patch proposes fixes to the reference counting of memory policy in the
page allocation paths and in show_numa_map().  Extracted from my "Memory
Policy Cleanups and Enhancements" series as stand-alone.

Shared policy lookup [shmem] has always added a reference to the policy,
but this was never unrefed after page allocation or after formatting the
numa map data.

Default system policy should not require additional ref counting, nor
should the current task's task policy.  However, show_numa_map() calls
get_vma_policy() to examine what may be [likely is] another task's policy. 
The latter case needs protection against freeing of the policy.

This patch adds a reference count to a mempolicy returned by
get_vma_policy() when the policy is a vma policy or another task's
mempolicy.  Again, shared policy is already reference counted on lookup.  A
matching "unref" [__mpol_free()] is performed in alloc_page_vma() for
shared and vma policies, and in show_numa_map() for shared and another
task's mempolicy.  We can call __mpol_free() directly, saving an admittedly
inexpensive inline NULL test, because we know we have a non-NULL policy.

Handling policy ref counts for hugepages is a bit trickier. 
huge_zonelist() returns a zone list that might come from a shared or vma
'BIND policy.  In this case, we should hold the reference until after the
huge page allocation in dequeue_hugepage().  The patch modifies
huge_zonelist() to return a pointer to the mempolicy if it needs to be
unref'd after allocation.

Kernel Build [16cpu, 32GB, ia64] - average of 10 runs:

		w/o patch	w/ refcount patch
	    Avg	  Std Devn	   Avg	  Std Devn
Real:	 100.59	    0.38	 100.63	    0.43
User:	1209.60	    0.37	1209.91	    0.31
System:   81.52	    0.42	  81.64	    0.34

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    4 -
 mm/hugetlb.c              |    4 +
 mm/mempolicy.c            |   79 +++++++++++++++++++++++++++++++-----
 3 files changed, 75 insertions(+), 12 deletions(-)

diff -puN include/linux/mempolicy.h~fix-numa-memory-policy-reference-counting include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~fix-numa-memory-policy-reference-counting
+++ a/include/linux/mempolicy.h
@@ -159,7 +159,7 @@ extern void mpol_fix_fork_child_flag(str
 
 extern struct mempolicy default_policy;
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
-		unsigned long addr, gfp_t gfp_flags);
+		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol);
 extern unsigned slab_node(struct mempolicy *policy);
 
 extern enum zone_type policy_zone;
@@ -256,7 +256,7 @@ static inline void mpol_fix_fork_child_f
 #define set_cpuset_being_rebound(x) do {} while (0)
 
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
-		unsigned long addr, gfp_t gfp_flags)
+ 		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol)
 {
 	return NODE_DATA(0)->node_zonelists + gfp_zone(gfp_flags);
 }
diff -puN mm/hugetlb.c~fix-numa-memory-policy-reference-counting mm/hugetlb.c
--- a/mm/hugetlb.c~fix-numa-memory-policy-reference-counting
+++ a/mm/hugetlb.c
@@ -71,8 +71,9 @@ static struct page *dequeue_huge_page(st
 {
 	int nid;
 	struct page *page = NULL;
+	struct mempolicy *mpol;
 	struct zonelist *zonelist = huge_zonelist(vma, address,
-						htlb_alloc_mask);
+					htlb_alloc_mask, &mpol);
 	struct zone **z;
 
 	for (z = zonelist->zones; *z; z++) {
@@ -87,6 +88,7 @@ static struct page *dequeue_huge_page(st
 			break;
 		}
 	}
+	mpol_free(mpol);	/* unref if mpol !NULL */
 	return page;
 }
 
diff -puN mm/mempolicy.c~fix-numa-memory-policy-reference-counting mm/mempolicy.c
--- a/mm/mempolicy.c~fix-numa-memory-policy-reference-counting
+++ a/mm/mempolicy.c
@@ -1077,21 +1077,37 @@ asmlinkage long compat_sys_mbind(compat_
 
 #endif
 
-/* Return effective policy for a VMA */
+/*
+ * get_vma_policy(@task, @vma, @addr)
+ * @task - task for fallback if vma policy == default
+ * @vma   - virtual memory area whose policy is sought
+ * @addr  - address in @vma for shared policy lookup
+ *
+ * Returns effective policy for a VMA at specified address.
+ * Falls back to @task or system default policy, as necessary.
+ * Returned policy has extra reference count if shared, vma,
+ * or some other task's policy [show_numa_maps() can pass
+ * @task != current].  It is the caller's responsibility to
+ * free the reference in these cases.
+ */
 static struct mempolicy * get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = task->mempolicy;
+	int shared_pol = 0;
 
 	if (vma) {
-		if (vma->vm_ops && vma->vm_ops->get_policy)
+		if (vma->vm_ops && vma->vm_ops->get_policy) {
 			pol = vma->vm_ops->get_policy(vma, addr);
-		else if (vma->vm_policy &&
+			shared_pol = 1;	/* if pol non-NULL, add ref below */
+		} else if (vma->vm_policy &&
 				vma->vm_policy->policy != MPOL_DEFAULT)
 			pol = vma->vm_policy;
 	}
 	if (!pol)
 		pol = &default_policy;
+	else if (!shared_pol && pol != current->mempolicy)
+		mpol_get(pol);	/* vma or other task's policy */
 	return pol;
 }
 
@@ -1207,19 +1223,45 @@ static inline unsigned interleave_nid(st
 }
 
 #ifdef CONFIG_HUGETLBFS
-/* Return a zonelist suitable for a huge page allocation. */
+/*
+ * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
+ * @vma = virtual memory area whose policy is sought
+ * @addr = address in @vma for shared policy lookup and interleave policy
+ * @gfp_flags = for requested zone
+ * @mpol = pointer to mempolicy pointer for reference counted 'BIND policy
+ *
+ * Returns a zonelist suitable for a huge page allocation.
+ * If the effective policy is 'BIND, returns pointer to policy's zonelist.
+ * If it is also a policy for which get_vma_policy() returns an extra
+ * reference, we must hold that reference until after allocation.
+ * In that case, return policy via @mpol so hugetlb allocation can drop
+ * the reference.  For non-'BIND referenced policies, we can/do drop the
+ * reference here, so the caller doesn't need to know about the special case
+ * for default and current task policy.
+ */
 struct zonelist *huge_zonelist(struct vm_area_struct *vma, unsigned long addr,
-							gfp_t gfp_flags)
+				gfp_t gfp_flags, struct mempolicy **mpol)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
+	struct zonelist *zl;
 
+	*mpol = NULL;		/* probably no unref needed */
 	if (pol->policy == MPOL_INTERLEAVE) {
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
+		__mpol_free(pol);		/* finished with pol */
 		return NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_flags);
 	}
-	return zonelist_policy(GFP_HIGHUSER, pol);
+
+	zl = zonelist_policy(GFP_HIGHUSER, pol);
+	if (unlikely(pol != &default_policy && pol != current->mempolicy)) {
+		if (pol->policy != MPOL_BIND)
+			__mpol_free(pol);	/* finished with pol */
+		else
+			*mpol = pol;	/* unref needed after allocation */
+	}
+	return zl;
 }
 #endif
 
@@ -1264,6 +1306,7 @@ struct page *
 alloc_page_vma(gfp_t gfp, struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
+	struct zonelist *zl;
 
 	cpuset_update_task_memory_state();
 
@@ -1273,7 +1316,19 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
 		return alloc_page_interleave(gfp, 0, nid);
 	}
-	return __alloc_pages(gfp, 0, zonelist_policy(gfp, pol));
+	zl = zonelist_policy(gfp, pol);
+	if (pol != &default_policy && pol != current->mempolicy) {
+		/*
+		 * slow path: ref counted policy -- shared or vma
+		 */
+		struct page *page =  __alloc_pages(gfp, 0, zl);
+		__mpol_free(pol);
+		return page;
+	}
+	/*
+	 * fast path:  default or task policy
+	 */
+	return __alloc_pages(gfp, 0, zl);
 }
 
 /**
@@ -1872,6 +1927,7 @@ int show_numa_map(struct seq_file *m, vo
 	struct numa_maps *md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
+	struct mempolicy *pol;
 	int n;
 	char buffer[50];
 
@@ -1882,8 +1938,13 @@ int show_numa_map(struct seq_file *m, vo
 	if (!md)
 		return 0;
 
-	mpol_to_str(buffer, sizeof(buffer),
-			    get_vma_policy(priv->task, vma, vma->vm_start));
+	pol = get_vma_policy(priv->task, vma, vma->vm_start);
+	mpol_to_str(buffer, sizeof(buffer), pol);
+	/*
+	 * unref shared or other task's mempolicy
+	 */
+	if (pol != &default_policy && pol != current->mempolicy)
+		__mpol_free(pol);
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
add-node-states-sysfs-class-attributes-v5.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
