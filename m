From: akpm@linux-foundation.org
Subject: [merged] mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:15 -0700
Message-ID: <20120531191515.65AAFA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:54101 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab2EaTPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:18 -0400
Received: by were53 with SMTP id e53so75842wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bootmem: unify allocation policy of (non-)panicking node allocations
has been removed from the -mm tree.  Its filename was
     mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: bootmem: unify allocation policy of (non-)panicking node allocations

While the panicking node-specific allocation function tries to satisfy
node+goal, goal, node, anywhere, the non-panicking function still does
node+goal, goal, anywhere.

Make it simpler: define the panicking version in terms of the
non-panicking one, like the node-agnostic interface, so they always behave
the same way apart from how to deal with allocation failure.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff -puN mm/bootmem.c~mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations
+++ a/mm/bootmem.c
@@ -698,7 +698,7 @@ void * __init __alloc_bootmem(unsigned l
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
+static void * __init ___alloc_bootmem_node_nopanic(bootmem_data_t *bdata,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
 {
@@ -722,6 +722,29 @@ again:
 		goto again;
 	}
 
+	return NULL;
+}
+
+void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	return ___alloc_bootmem_node_nopanic(pgdat->bdata, size,
+					     align, goal, 0);
+}
+
+void * __init ___alloc_bootmem_node(bootmem_data_t *bdata, unsigned long size,
+				    unsigned long align, unsigned long goal,
+				    unsigned long limit)
+{
+	void *ptr;
+
+	ptr = ___alloc_bootmem_node_nopanic(bdata, size, align, goal, 0);
+	if (ptr)
+		return ptr;
+
 	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
 	panic("Out of memory");
 	return NULL;
@@ -802,25 +825,6 @@ void * __init alloc_bootmem_section(unsi
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
-	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
-	if (ptr)
-		return ptr;
-
-	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, 0);
-	if (ptr)
-		return ptr;
-
-	return __alloc_bootmem_nopanic(size, align, goal);
-}
-
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
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

