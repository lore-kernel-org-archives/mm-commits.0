From: akpm@linux-foundation.org
Subject: [merged] mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:05 -0700
Message-ID: <20120531191505.6E293A060B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62879 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab2EaTPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:06 -0400
Received: by mail-gg0-f202.google.com with SMTP id h3so135414gge.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bootmem: rename alloc_bootmem_core to alloc_bootmem_bdata
has been removed from the -mm tree.  Its filename was
     mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: bootmem: rename alloc_bootmem_core to alloc_bootmem_bdata

Callsites need to provide a bootmem_data_t *, make the naming more
descriptive.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/bootmem.c~mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata
+++ a/mm/bootmem.c
@@ -468,7 +468,7 @@ static unsigned long __init align_off(st
 	return ALIGN(base + off, align) - base;
 }
 
-static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
+static void * __init alloc_bootmem_bdata(struct bootmem_data *bdata,
 					unsigned long size, unsigned long align,
 					unsigned long goal, unsigned long limit)
 {
@@ -589,7 +589,7 @@ static void * __init alloc_arch_preferre
 		p_bdata = bootmem_arch_preferred_node(bdata, size, align,
 							goal, limit);
 		if (p_bdata)
-			return alloc_bootmem_core(p_bdata, size, align,
+			return alloc_bootmem_bdata(p_bdata, size, align,
 							goal, limit);
 	}
 #endif
@@ -615,7 +615,7 @@ restart:
 		if (limit && bdata->node_min_pfn >= PFN_DOWN(limit))
 			break;
 
-		region = alloc_bootmem_core(bdata, size, align, goal, limit);
+		region = alloc_bootmem_bdata(bdata, size, align, goal, limit);
 		if (region)
 			return region;
 	}
@@ -695,7 +695,7 @@ static void * __init ___alloc_bootmem_no
 	if (ptr)
 		return ptr;
 
-	ptr = alloc_bootmem_core(bdata, size, align, goal, limit);
+	ptr = alloc_bootmem_bdata(bdata, size, align, goal, limit);
 	if (ptr)
 		return ptr;
 
@@ -744,7 +744,7 @@ void * __init __alloc_bootmem_node_high(
 		unsigned long new_goal;
 
 		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
-		ptr = alloc_bootmem_core(pgdat->bdata, size, align,
+		ptr = alloc_bootmem_bdata(pgdat->bdata, size, align,
 						 new_goal, 0);
 		if (ptr)
 			return ptr;
@@ -773,7 +773,7 @@ void * __init alloc_bootmem_section(unsi
 	goal = pfn << PAGE_SHIFT;
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
-	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, 0);
+	return alloc_bootmem_bdata(bdata, size, SMP_CACHE_BYTES, goal, 0);
 }
 #endif
 
@@ -789,7 +789,7 @@ void * __init __alloc_bootmem_node_nopan
 	if (ptr)
 		return ptr;
 
-	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
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

