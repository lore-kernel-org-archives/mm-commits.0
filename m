From: akpm@linux-foundation.org
Subject: +
 mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak.patch added to
 -mm tree
Date: Tue, 30 Jun 2020 19:10:56 -0700
Message-ID: <20200701021056.dhjn0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgGACK7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robin.murphy@arm.com, riel@surriel.com, mike.kravetz@oracle.com, mhocko@kernel.org, js1304@gmail.com, Jonathan.Cameron@huawei.com, guro@fb.com, aslan@fb.com, andreas.schaufler@gmx.de, song.bao.hua@hisilicon.com


The patch titled
     Subject: mm/cma.c: use exact_nid true to fix possible per-numa cma leak
has been added to the -mm tree.  Its filename is
     mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/cma.c: use exact_nid true to fix possible per-numa cma leak

Calling cma_declare_contiguous_nid() with false exact_nid for per-numa
reservation can easily cause cma leak and various confusion.  For example,
mm/hugetlb.c is trying to reserve per-numa cma for gigantic pages.  But it
can easily leak cma and make users confused when system has memoryless
nodes.

In case the system has 4 numa nodes, and only numa node0 has memory.  if
we set hugetlb_cma=4G in bootargs, mm/hugetlb.c will get 4 cma areas for 4
different numa nodes.  since exact_nid=false in current code, all 4 numa
nodes will get cma successfully from node0, but hugetlb_cma[1 to 3] will
never be available to hugepage will only allocate memory from
hugetlb_cma[0].

In case the system has 4 numa nodes, both numa node0&2 has memory, other
nodes have no memory.  if we set hugetlb_cma=4G in bootargs, mm/hugetlb.c
will get 4 cma areas for 4 different numa nodes.  since exact_nid=false in
current code, all 4 numa nodes will get cma successfully from node0 or 2,
but hugetlb_cma[1] and [3] will never be available to hugepage as
mm/hugetlb.c will only allocate memory from hugetlb_cma[0] and
hugetlb_cma[2].  This causes permanent leak of the cma areas which are
supposed to be used by memoryless node.

Of cource we can workaround the issue by letting mm/hugetlb.c scan all cma
areas in alloc_gigantic_page() even node_mask includes node0 only.  that
means when node_mask includes node0 only, we can get page from
hugetlb_cma[1] to hugetlb_cma[3].  But this will cause kernel crash in
free_gigantic_page() while it wants to free page by:
cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order)

On the other hand, exact_nid=false won't consider numa distance, it might
be not that useful to leverage cma areas on remote nodes.  I feel it is
much simpler to make exact_nid true to make everything clear.  After that,
memoryless nodes won't be able to reserve per-numa CMA from other nodes
which have memory.

Link: http://lkml.kernel.org/r/20200628074345.27228-1-song.bao.hua@hisilicon.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Aslan Bakirov <aslan@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andreas Schaufler <andreas.schaufler@gmx.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak
+++ a/mm/cma.c
@@ -339,13 +339,13 @@ int __init cma_declare_contiguous_nid(ph
 		 */
 		if (base < highmem_start && limit > highmem_start) {
 			addr = memblock_alloc_range_nid(size, alignment,
-					highmem_start, limit, nid, false);
+					highmem_start, limit, nid, true);
 			limit = highmem_start;
 		}
 
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
-					limit, nid, false);
+					limit, nid, true);
 			if (!addr) {
 				ret = -ENOMEM;
 				goto err;
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak.patch
mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch
