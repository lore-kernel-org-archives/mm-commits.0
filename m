From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-the-name-of-hugetlb-cma.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 13:28:22 -0700
Message-ID: <20200617202822.Ho691%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgFQU2X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 16:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.kravetz@oracle.com, guro@fb.com, song.bao.hua@hisilicon.com


The patch titled
     Subject: mm: hugetlb: fix the name of hugetlb CMA
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-the-name-of-hugetlb-cma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-the-name-of-hugetlb-cma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-the-name-of-hugetlb-cma.patch

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
Subject: mm: hugetlb: fix the name of hugetlb CMA

Once we enable CMA_DEBUGFS, we will get the below errors: directory
'cma-hugetlb' with parent 'cma' already present.

We should have different names for different CMA areas.

Link: http://lkml.kernel.org/r/20200616223131.33828-3-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-the-name-of-hugetlb-cma
+++ a/mm/hugetlb.c
@@ -5692,12 +5692,14 @@ void __init hugetlb_cma_reserve(int orde
 	reserved = 0;
 	for_each_node_state(nid, N_ONLINE) {
 		int res;
+		char name[20];
 
 		size = min(per_node, hugetlb_cma_size - reserved);
 		size = round_up(size, PAGE_SIZE << order);
 
+		snprintf(name, 20, "hugetlb%d", nid);
 		res = cma_declare_contiguous_nid(0, size, 0, PAGE_SIZE << order,
-						 0, false, "hugetlb",
+						 0, false, name,
 						 &hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch
