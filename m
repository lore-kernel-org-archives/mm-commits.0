From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch added to
 -mm tree
Date: Tue, 07 Jul 2020 12:56:57 -0700
Message-ID: <20200707195657.WZifBLlPz%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgGGT46 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:56:58 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, jonathan.cameron@huawei.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, song.bao.hua@hisilicon.com


The patch titled
     Subject: mm/hugetlb: avoid hardcoding while checking if cma is enable
has been added to the -mm tree.  Its filename is
     mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch

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
Subject: mm/hugetlb: avoid hardcoding while checking if cma is enable

hugetlb_cma[0] can be NULL due to various reasons, for example, node0 has
no memory.  so NULL hugetlb_cma[0] doesn't necessarily mean cma is not
enabled.  gigantic pages might have been reserved on other nodes.

Link: http://lkml.kernel.org/r/20200707040204.30132-1-song.bao.hua@hisilicon.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable
+++ a/mm/hugetlb.c
@@ -2547,6 +2547,20 @@ static void __init gather_bootmem_preall
 	}
 }
 
+bool __init hugetlb_cma_enabled(void)
+{
+#ifdef CONFIG_CMA
+	int node;
+
+	for_each_online_node(node) {
+		if (hugetlb_cma[node])
+			return true;
+	}
+#endif
+
+	return false;
+}
+
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long i;
@@ -2572,7 +2586,7 @@ static void __init hugetlb_hstate_alloc_
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (hstate_is_gigantic(h)) {
-			if (IS_ENABLED(CONFIG_CMA) && hugetlb_cma[0]) {
+			if (hugetlb_cma_enabled()) {
 				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
 				break;
 			}
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch
mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch
mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch
