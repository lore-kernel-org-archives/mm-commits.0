From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
 removed from -mm tree
Date: Wed, 08 Apr 2020 17:58:47 -0700
Message-ID: <20200409005847.gpES-P2z4%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgDIA6r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:58:47 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.schaufler@gmx.de, aslan@fb.com, guro@fb.com, js1304@gmail.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: hugetlb: fix per-node size calculation for hugetlb_cma
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch

This patch was dropped because an updated version will be merged

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
@@ -5583,7 +5583,7 @@ void __init hugetlb_cma_reserve(int orde
 			max_pfn = end_pfn;
 		}
 
-		size = max(per_node, hugetlb_cma_size - reserved);
+		size = min(per_node, hugetlb_cma_size - reserved);
 		size = round_up(size, PAGE_SIZE << order);
 
 		if (size > ((max_pfn - min_pfn) << PAGE_SHIFT) / 2) {
_

Patches currently in -mm which might be from guro@fb.com are

mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
