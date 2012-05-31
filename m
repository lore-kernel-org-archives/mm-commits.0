From: akpm@linux-foundation.org
Subject: [merged] mm-nobootmem-panic-on-node-specific-allocation-failure.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:17 -0700
Message-ID: <20120531191517.65F5CA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60314 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab2EaTPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:18 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so136095qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nobootmem: panic on node-specific allocation failure
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-panic-on-node-specific-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: nobootmem: panic on node-specific allocation failure

__alloc_bootmem_node and __alloc_bootmem_low_node documentation claims
the functions panic on allocation failure.  Do it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/nobootmem.c~mm-nobootmem-panic-on-node-specific-allocation-failure mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-panic-on-node-specific-allocation-failure
+++ a/mm/nobootmem.c
@@ -305,11 +305,17 @@ again:
 
 	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
 					goal, -1ULL);
-	if (!ptr && goal) {
+	if (ptr)
+		return ptr;
+
+	if (goal) {
 		goal = 0;
 		goto again;
 	}
-	return ptr;
+
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
+	return NULL;
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -407,6 +413,12 @@ void * __init __alloc_bootmem_low_node(p
 	if (ptr)
 		return ptr;
 
-	return  __alloc_memory_core_early(MAX_NUMNODES, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
+					goal, ARCH_LOW_ADDRESS_LIMIT);
+	if (ptr)
+		return ptr;
+
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
+	return NULL;
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

