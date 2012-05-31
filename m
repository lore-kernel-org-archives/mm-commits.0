From: akpm@linux-foundation.org
Subject: [merged] mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:19 -0700
Message-ID: <20120531191519.77278A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:54101 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab2EaTPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:21 -0400
Received: by mail-we0-f202.google.com with SMTP id e53so75842wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nobootmem: unify allocation policy of (non-)panicking node allocations
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: nobootmem: unify allocation policy of (non-)panicking node allocations

While the panicking node-specific allocation function tries to satisfy
node+goal, goal, node, anywhere, the non-panicking function still does
node+goal, goal, anywhere.

Make it simpler: define the panicking version in terms of the non-panicking
one, like the node-agnostic interface, so they always behave the same way
apart from how to deal with allocation failure.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |  106 +++++++++++++++++++++++------------------------
 1 file changed, 54 insertions(+), 52 deletions(-)

diff -puN mm/nobootmem.c~mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations
+++ a/mm/nobootmem.c
@@ -274,6 +274,57 @@ void * __init __alloc_bootmem(unsigned l
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
+static void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+						   unsigned long size,
+						   unsigned long align,
+						   unsigned long goal,
+						   unsigned long limit)
+{
+	void *ptr;
+
+again:
+	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
+					goal, limit);
+	if (ptr)
+		return ptr;
+
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
+					goal, limit);
+	if (ptr)
+		return ptr;
+
+	if (goal) {
+		goal = 0;
+		goto again;
+	}
+
+	return NULL;
+}
+
+void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	return ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
+}
+
+void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
+				    unsigned long align, unsigned long goal,
+				    unsigned long limit)
+{
+	void *ptr;
+
+	ptr = ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, limit);
+	if (ptr)
+		return ptr;
+
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
+	return NULL;
+}
+
 /**
  * __alloc_bootmem_node - allocate boot memory from a specific node
  * @pgdat: node to allocate from
@@ -292,30 +343,10 @@ void * __init __alloc_bootmem(unsigned l
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	void *ptr;
-
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-again:
-	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
-					 goal, -1ULL);
-	if (ptr)
-		return ptr;
-
-	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
-					goal, -1ULL);
-	if (ptr)
-		return ptr;
-
-	if (goal) {
-		goal = 0;
-		goto again;
-	}
-
-	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
-	panic("Out of memory");
-	return NULL;
+	return ___alloc_bootmem_node(pgdat, size, align, goal, 0);
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -346,22 +377,6 @@ void * __init alloc_bootmem_section(unsi
 }
 #endif
 
-void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
-				   unsigned long align, unsigned long goal)
-{
-	void *ptr;
-
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
-	ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
-						 goal, -1ULL);
-	if (ptr)
-		return ptr;
-
-	return __alloc_bootmem_nopanic(size, align, goal);
-}
-
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
@@ -403,22 +418,9 @@ void * __init __alloc_bootmem_low(unsign
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	void *ptr;
-
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
-	if (ptr)
-		return ptr;
-
-	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
-					goal, ARCH_LOW_ADDRESS_LIMIT);
-	if (ptr)
-		return ptr;
-
-	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
-	panic("Out of memory");
-	return NULL;
+	return ___alloc_bootmem_node(pgdat, size, align, goal,
+				     ARCH_LOW_ADDRESS_LIMIT);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-slab-remove-duplicate-check.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

