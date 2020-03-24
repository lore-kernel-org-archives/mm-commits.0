From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
 added to -mm tree
Date: Mon, 23 Mar 2020 18:19:25 -0700
Message-ID: <20200324011925.J1lhQmUnH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCXBT0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 21:19:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.schaufler@gmx.de, aslan@fb.com, guro@fb.com, js1304@gmail.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: hugetlb: fix per-node size calculation for hugetlb_cma
has been added to the -mm tree.  Its filename is
     mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: hugetlb: fix per-node size calculation for hugetlb_cma

Aslan found a bug in the per-node hugetlb_cma area size calculation:
the total remaining size should cap the per-node area size instead
of be the minimal possible allocation.

Without the fix:
[    0.004136] hugetlb_cma: reserve 2048 MiB, up to 1024 MiB per node
[    0.004138] cma: Reserved 2048 MiB at 0x0000000180000000
[    0.004139] hugetlb_cma: reserved 2048 MiB on node 0

With the fix:
[    0.006780] hugetlb_cma: reserve 2048 MiB, up to 1024 MiB per node
[    0.006786] cma: Reserved 1024 MiB at 0x00000001c0000000
[    0.006787] hugetlb_cma: reserved 1024 MiB on node 0
[    0.006788] cma: Reserved 1024 MiB at 0x00000003c0000000
[    0.006789] hugetlb_cma: reserved 1024 MiB on node 1

Link: http://lkml.kernel.org/r/20200323233411.2407279-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Aslan Bakirov <aslan@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Andreas Schaufler <andreas.schaufler@gmx.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2
+++ a/mm/hugetlb.c
@@ -5582,7 +5582,7 @@ void __init hugetlb_cma_reserve(int orde
 			max_pfn = end_pfn;
 		}
 
-		size = max(per_node, hugetlb_cma_size - reserved);
+		size = min(per_node, hugetlb_cma_size - reserved);
 		size = round_up(size, PAGE_SIZE << order);
 
 		if (size > ((max_pfn - min_pfn) << PAGE_SHIFT) / 2) {
_

Patches currently in -mm which might be from guro@fb.com are

mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch
mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch
