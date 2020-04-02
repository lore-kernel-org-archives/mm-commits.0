From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch removed
 from -mm tree
Date: Wed, 01 Apr 2020 19:27:59 -0700
Message-ID: <20200402022759.sgP-kK8Ci%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732435AbgDBC2A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 22:28:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agx@sigxcpu.org, andreas.schaufler@gmx.de, guro@fb.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, riel@surriel.com


The patch titled
     Subject: mm: hugetlb: fix hugetlb_cma_reserve() if CONFIG_NUMA isn't set
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: hugetlb: fix hugetlb_cma_reserve() if CONFIG_NUMA isn't set

If CONFIG_NUMA isn't set, there is no need to ensure that the hugetlb cma
area belongs to a specific numa node.

min/max_low_pfn can be used for limiting the maximum size of the
hugetlb_cma area.

Also for_each_mem_pfn_range() is defined only if
CONFIG_HAVE_MEMBLOCK_NODE_MAP is set, and on arm (unlike most other
architectures) it depends on CONFIG_NUMA.  This makes the build fail if
CONFIG_NUMA isn't set.

Link: http://lkml.kernel.org/r/20200318153424.3202304-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Andreas Schaufler <andreas.schaufler@gmx.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Guido Gnther <agx@sigxcpu.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set
+++ a/mm/hugetlb.c
@@ -5576,16 +5576,21 @@ void __init hugetlb_cma_reserve(int orde
 
 	reserved = 0;
 	for_each_node_state(nid, N_ONLINE) {
-		unsigned long start_pfn, end_pfn;
 		unsigned long min_pfn = 0, max_pfn = 0;
-		int res, i;
+		int res;
+#ifdef CONFIG_NUMA
+		unsigned long start_pfn, end_pfn;
+		int i;
 
 		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			if (!min_pfn)
 				min_pfn = start_pfn;
 			max_pfn = end_pfn;
 		}
