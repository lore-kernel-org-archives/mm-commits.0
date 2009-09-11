From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch removed from -mm tree
Date: Fri, 11 Sep 2009 10:43:05 -0700
Message-ID: <200909111743.n8BHh5OI022124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755785AbZIKRoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 13:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, mel@csn.ul.ie, nacc@us.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: derive huge pages nodes allowed from task mempolicy
has been removed from the -mm tree.  Its filename was
     hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: derive huge pages nodes allowed from task mempolicy
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This patch derives a "nodes_allowed" node mask from the numa mempolicy of
the task modifying the number of persistent huge pages to control the
allocation, freeing and adjusting of surplus huge pages.  This mask is
derived as follows:

* For "default" [NULL] task mempolicy, a NULL nodemask_t pointer is
  produced.  This will cause the hugetlb subsystem to use node_online_map
  as the "nodes_allowed".  This preserves the behavior before this patch.

* For "preferred" mempolicy, including explicit local allocation, a
  nodemask with the single preferred node will be produced.  "local"
  policy will NOT track any internode migrations of the task adjusting
  nr_hugepages.

* For "bind" and "interleave" policy, the mempolicy's nodemask will be
  used.

* Other than to inform the construction of the nodes_allowed node mask,
  the actual mempolicy mode is ignored.  That is, all modes behave like
  interleave over the resulting nodes_allowed mask with no "fallback".

Notes:

1) This patch introduces a subtle change in behavior: huge page
   allocation and freeing will be constrained by any mempolicy that the
   task adjusting the huge page pool inherits from its parent.  This
   policy could come from a distant ancestor.  The adminstrator adjusting
   the huge page pool without explicitly specifying a mempolicy via
   numactl might be surprised by this.  Additionaly, any mempolicy
   specified by numactl will be constrained by the cpuset in which numactl
   is invoked.  Using sysfs per node hugepages attributes to adjust the
   per node persistent huge pages count [subsequent patch] ignores
   mempolicy and cpuset constraints.

2) Hugepages allocated at boot time use the node_online_map.  An
   additional patch could implement a temporary boot time huge pages
   nodes_allowed command line parameter.

3) Using mempolicy to control persistent huge page allocation and
   freeing requires no change to hugeadm when invoking it via numactl, as
   shown in the examples below.  However, hugeadm could be enhanced to
   take the allowed nodes as an argument and set its task mempolicy
   itself.  This would allow it to detect and warn about any non-default
   mempolicy that it inherited from its parent, thus alleviating the issue
   described in Note 1 above.

See the updated documentation [next patch] for more information
about the implications of this patch.

Examples:

Starting with:

	Node 0 HugePages_Total:     0
	Node 1 HugePages_Total:     0
	Node 2 HugePages_Total:     0
	Node 3 HugePages_Total:     0

Default behavior [with or without this patch] balances persistent hugepage
allocation across nodes [with sufficient contiguous memory]:

	hugeadm --pool-pages-min=2048Kb:32

yields:

	Node 0 HugePages_Total:     8
	Node 1 HugePages_Total:     8
	Node 2 HugePages_Total:     8
	Node 3 HugePages_Total:     8

Applying mempolicy--e.g., with numactl [using '-m' a.k.a.  '--membind'
because it allows multiple nodes to be specified and it's easy to
type]--we can allocate huge pages on individual nodes or sets of nodes. 
So, starting from the condition above, with 8 huge pages per node:

	numactl -m 2 hugeadm --pool-pages-min=2048Kb:+8

yields:

	Node 0 HugePages_Total:     8
	Node 1 HugePages_Total:     8
	Node 2 HugePages_Total:    16
	Node 3 HugePages_Total:     8

The incremental 8 huge pages were restricted to node 2 by the specified
mempolicy.

Similarly, we can use mempolicy to free persistent huge pages from
specified nodes:

	numactl -m 0,1 hugeadm --pool-pages-min=2048Kb:-8

yields:

	Node 0 HugePages_Total:     4
	Node 1 HugePages_Total:     4
	Node 2 HugePages_Total:    16
	Node 3 HugePages_Total:     8

The 8 huge pages freed were balanced over nodes 0 and 1.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    3 ++
 mm/hugetlb.c              |   12 +++++++-
 mm/mempolicy.c            |   51 ++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)

diff -puN include/linux/mempolicy.h~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy
+++ a/include/linux/mempolicy.h
@@ -201,6 +201,7 @@ extern void mpol_fix_fork_child_flag(str
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
+extern nodemask_t *alloc_nodemask_of_mempolicy(void);
 extern unsigned slab_node(struct mempolicy *policy);
 
 extern enum zone_type policy_zone;
@@ -328,6 +329,8 @@ static inline struct zonelist *huge_zone
 	return node_zonelist(0, gfp_flags);
 }
 
+static inline nodemask_t *alloc_nodemask_of_mempolicy(void) { return NULL; }
+
 static inline int do_migrate_pages(struct mm_struct *mm,
 			const nodemask_t *from_nodes,
 			const nodemask_t *to_nodes, int flags)
diff -puN mm/hugetlb.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy
+++ a/mm/hugetlb.c
@@ -1246,11 +1246,19 @@ static int adjust_pool_surplus(struct hs
 static unsigned long set_max_huge_pages(struct hstate *h, unsigned long count)
 {
 	unsigned long min_count, ret;
-	nodemask_t *nodes_allowed = &node_online_map;
+	nodemask_t *nodes_allowed;
 
 	if (h->order >= MAX_ORDER)
 		return h->max_huge_pages;
 
+	nodes_allowed = alloc_nodemask_of_mempolicy();
+	if (!nodes_allowed) {
+		printk(KERN_WARNING "%s unable to allocate nodes allowed mask "
+			"for huge page allocation.  Falling back to default.\n",
+			current->comm);
+		nodes_allowed = &node_online_map;
+	}
+
 	/*
 	 * Increase the pool size
 	 * First take pages out of surplus state.  Then make up the
@@ -1311,6 +1319,8 @@ static unsigned long set_max_huge_pages(
 out:
 	ret = persistent_huge_pages(h);
 	spin_unlock(&hugetlb_lock);
+	if (nodes_allowed != &node_online_map)
+		kfree(nodes_allowed);
 	return ret;
 }
 
diff -puN mm/mempolicy.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy mm/mempolicy.c
--- a/mm/mempolicy.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy
+++ a/mm/mempolicy.c
@@ -1564,6 +1564,57 @@ struct zonelist *huge_zonelist(struct vm
 	}
 	return zl;
 }
+
+/*
+ * alloc_nodemask_of_mempolicy
+ *
+ * Returns a [pointer to a] nodelist based on the current task's mempolicy.
+ *
+ * If the task's mempolicy is "default" [NULL], return NULL for default
+ * behavior.  Otherwise, extract the policy nodemask for 'bind'
+ * or 'interleave' policy or construct a nodemask for 'preferred' or
+ * 'local' policy and return a pointer to a kmalloc()ed nodemask_t.
+ *
+ * N.B., it is the caller's responsibility to free a returned nodemask.
+ */
+nodemask_t *alloc_nodemask_of_mempolicy(void)
+{
+	nodemask_t *nodes_allowed = NULL;
+	struct mempolicy *mempolicy;
+	int nid;
+
+	if (!current->mempolicy)
+		return NULL;
+
+	mpol_get(current->mempolicy);
+	nodes_allowed = kmalloc(sizeof(*nodes_allowed), GFP_KERNEL);
+	if (!nodes_allowed)
+		return NULL;		/* silently default */
+
+	nodes_clear(*nodes_allowed);
+	mempolicy = current->mempolicy;
+	switch (mempolicy->mode) {
+	case MPOL_PREFERRED:
+		if (mempolicy->flags & MPOL_F_LOCAL)
+			nid = numa_node_id();
+		else
+			nid = mempolicy->v.preferred_node;
+		node_set(nid, *nodes_allowed);
+		break;
+
+	case MPOL_BIND:
+		/* Fall through */
+	case MPOL_INTERLEAVE:
+		*nodes_allowed =  mempolicy->v.nodes;
+		break;
+
+	default:
+		BUG();
+	}
+
+	mpol_put(current->mempolicy);
+	return nodes_allowed;
+}
 #endif
 
 /* Allocate a page in interleaved policy.
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy-fix.patch
hugetlb-promote-numa_no_node-to-generic-constant.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-add-per-node-hstate-attributes-fix.patch
hugetlb-update-hugetlb-documentation-for-mempolicy-based-management.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch

