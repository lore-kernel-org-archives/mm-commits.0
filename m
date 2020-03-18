From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch added to
 -mm tree
Date: Wed, 18 Mar 2020 13:31:57 -0700
Message-ID: <20200318203157.eCYCKLRdz%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCRUb6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 16:31:58 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agx@sigxcpu.org, andreas.schaufler@gmx.de, guro@fb.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, riel@surriel.com


The patch titled
     Subject: mm: hugetlb: fix hugetlb_cma_reserve() if CONFIG_NUMA isn't set
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch

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
@@ -5441,16 +5441,21 @@ void __init hugetlb_cma_reserve(int orde
 
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
