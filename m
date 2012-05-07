From: akpm@linux-foundation.org
Subject: + mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch added to -mm tree
Date: Mon, 07 May 2012 14:27:48 -0700
Message-ID: <20120507212748.E0760A0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:53315 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab2EGV1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2012 17:27:51 -0400
Received: by faaa25 with SMTP id a25so285342faa.1
        for <mm-commits@vger.kernel.org>; Mon, 07 May 2012 14:27:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org


The patch titled
     Subject: mm: bootmem: rename alloc_bootmem_core to alloc_bootmem_bdata
has been added to the -mm tree.  Its filename is
     mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: bootmem: rename alloc_bootmem_core to alloc_bootmem_bdata

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
mm-remove-swap-token-code.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
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
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch
documentation-memcg-future-proof-hierarchical-statistics-documentation.patch
mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch
mm-bootmem-remove-redundant-offset-check-when-finally-freeing-bootmem.patch
mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch
mm-bootmem-split-out-goal-to-node-mapping-from-goal-dropping.patch
mm-bootmem-allocate-in-order-nodegoal-goal-node-anywhere.patch
mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-nobootmem-panic-on-node-specific-allocation-failure.patch
mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch

