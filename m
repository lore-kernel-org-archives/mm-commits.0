From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-introduce-alloc_nodemask_of_node.patch removed from -mm tree
Date: Fri, 11 Sep 2009 10:43:01 -0700
Message-ID: <200909111743.n8BHh1Wb021976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708AbZIKRoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 13:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, mel@csn.ul.ie, nacc@us.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: introduce alloc_nodemask_of_node()
has been removed from the -mm tree.  Its filename was
     hugetlb-introduce-alloc_nodemask_of_node.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: introduce alloc_nodemask_of_node()
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Introduce nodemask macro to allocate a nodemask and initialize it to
contain a single node, using the macro init_nodemask_of_node() factored
out of the nodemask_of_node() macro.

alloc_nodemask_of_node() coded as a macro to avoid header dependency hell.

This will be used to construct the huge pages "nodes_allowed" nodemask for
a single node when basing nodes_allowed on a preferred/local mempolicy or
when a persistent huge page pool page count is modified via a per node
sysfs attribute.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN include/linux/nodemask.h~hugetlb-introduce-alloc_nodemask_of_node include/linux/nodemask.h
--- a/include/linux/nodemask.h~hugetlb-introduce-alloc_nodemask_of_node
+++ a/include/linux/nodemask.h
@@ -245,18 +245,36 @@ static inline int __next_node(int n, con
 	return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
 }
 
+static inline void init_nodemask_of_node(nodemask_t *mask, int node)
+{
+	nodes_clear(*(mask));
+	node_set((node), *(mask));
+}
+
 #define nodemask_of_node(node)						\
 ({									\
 	typeof(_unused_nodemask_arg_) m;				\
 	if (sizeof(m) == sizeof(unsigned long)) {			\
 		m.bits[0] = 1UL<<(node);				\
 	} else {							\
-		nodes_clear(m);						\
-		node_set((node), m);					\
+		init_nodemask_of_node(&m, (node));			\
 	}								\
 	m;								\
 })
 
+/*
+ * returns pointer to kmalloc()'d nodemask initialized to contain the
+ * specified node.  Caller must free with kfree().
+ */
+#define alloc_nodemask_of_node(node)					\
+({									\
+	typeof(_unused_nodemask_arg_) *nmp;				\
+	nmp = kmalloc(sizeof(*nmp), GFP_KERNEL);			\
+	if (nmp)							\
+		init_nodemask_of_node(nmp, (node));			\
+	nmp;								\
+})
+
 #define first_unset_node(mask) __first_unset_node(&(mask))
 static inline int __first_unset_node(const nodemask_t *maskp)
 {
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
hugetlb-introduce-alloc_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy-fix.patch
hugetlb-promote-numa_no_node-to-generic-constant.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-add-per-node-hstate-attributes-fix.patch
hugetlb-update-hugetlb-documentation-for-mempolicy-based-management.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch

