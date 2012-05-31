From: akpm@linux-foundation.org
Subject: [merged] mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:21 -0700
Message-ID: <20120531191521.76AA8A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40770 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab2EaTPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:23 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so134118vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bootmem: pass pgdat instead of pgdat->bdata down the stack
has been removed from the -mm tree.  Its filename was
     mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: bootmem: pass pgdat instead of pgdat->bdata down the stack

Pass down the node descriptor instead of the more specific bootmem node
descriptor down the call stack, like nobootmem does, when there is no good
reason for the two to be different.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/bootmem.c~mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack
+++ a/mm/bootmem.c
@@ -698,18 +698,19 @@ void * __init __alloc_bootmem(unsigned l
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-static void * __init ___alloc_bootmem_node_nopanic(bootmem_data_t *bdata,
+static void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
 {
 	void *ptr;
 
 again:
-	ptr = alloc_arch_preferred_bootmem(bdata, size, align, goal, limit);
+	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size,
+					   align, goal, limit);
 	if (ptr)
 		return ptr;
 
-	ptr = alloc_bootmem_bdata(bdata, size, align, goal, limit);
+	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, limit);
 	if (ptr)
 		return ptr;
 
@@ -731,17 +732,16 @@ void * __init __alloc_bootmem_node_nopan
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-	return ___alloc_bootmem_node_nopanic(pgdat->bdata, size,
-					     align, goal, 0);
+	return ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
 }
 
-void * __init ___alloc_bootmem_node(bootmem_data_t *bdata, unsigned long size,
+void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				    unsigned long align, unsigned long goal,
 				    unsigned long limit)
 {
 	void *ptr;
 
-	ptr = ___alloc_bootmem_node_nopanic(bdata, size, align, goal, 0);
+	ptr = ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
@@ -771,7 +771,7 @@ void * __init __alloc_bootmem_node(pg_da
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-	return  ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
+	return  ___alloc_bootmem_node(pgdat, size, align, goal, 0);
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -869,6 +869,6 @@ void * __init __alloc_bootmem_low_node(p
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-	return ___alloc_bootmem_node(pgdat->bdata, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
+	return ___alloc_bootmem_node(pgdat, size, align,
+				     goal, ARCH_LOW_ADDRESS_LIMIT);
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

