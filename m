Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EF0C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 04:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiDMEtU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 00:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiDMEtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 00:49:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BAE26ADA
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9326B820FE
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 04:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555D2C385A4;
        Wed, 13 Apr 2022 04:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649825216;
        bh=JmKLWwESV2V7JxLq9cq3Hl/6C0vsBAn8XKNxk8YGw6k=;
        h=Date:To:From:Subject:From;
        b=iiy5r1tJLiqBM38Xg1RrbcZfDbw8gAdIHKy1wUSobuIccK84288cWftqDqRuwCgKE
         VJyNMK9IRS2W4LyaTA6ExDQm31pEB7zZaYitkEnDd9F4WNEQIF44YaBc1E/UQqGq1S
         d3CuPTm3GS0PL+zPxIvvNxRimQRc5rlhiKF9q+4o=
Date:   Tue, 12 Apr 2022 21:46:55 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        liuyuntao10@huawei.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-wrong-use-of-nr_online_nodes.patch added to -mm tree
Message-Id: <20220413044656.555D2C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix wrong use of nr_online_nodes
has been added to the -mm tree.  Its filename is
     hugetlb-fix-wrong-use-of-nr_online_nodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-wrong-use-of-nr_online_nodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-wrong-use-of-nr_online_nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peng Liu <liupeng256@huawei.com>
Subject: hugetlb: fix wrong use of nr_online_nodes

Patch series "hugetlb: Fix some incorrect behavior", v3.

This series fix three bugs of hugetlb:
1) Invalid use of nr_online_nodes;
2) Inconsistency between 1G hugepage and 2M hugepage;
3) Useless information in dmesg.


This patch (of 4):

Certain systems are designed to have sparse/discontiguous nodes.  In this
case, nr_online_nodes can not be used to walk through numa node.  Also, a
valid node may be greater than nr_online_nodes.

However, in hugetlb, it is assumed that nodes are contiguous.  Recheck all
the places that use nr_online_nodes, and repair them one by one.

Link: https://lkml.kernel.org/r/20220413032915.251254-1-liupeng256@huawei.com
Link: https://lkml.kernel.org/r/20220413032915.251254-2-liupeng256@huawei.com
Fixes: 4178158ef8ca ("hugetlbfs: fix issue of preallocation of gigantic pages can't work")
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Fixes: e79ce9832316 ("hugetlbfs: fix a truncation issue in hugepages parameter")
Fixes: f9317f77a6e0 ("hugetlb: clean up potential spectre issue warnings")
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~hugetlb-fix-wrong-use-of-nr_online_nodes
+++ a/mm/hugetlb.c
@@ -2986,7 +2986,7 @@ int __alloc_bootmem_huge_page(struct hst
 	struct huge_bootmem_page *m = NULL; /* initialize for clang */
 	int nr_nodes, node;
 
-	if (nid != NUMA_NO_NODE && nid >= nr_online_nodes)
+	if (nid != NUMA_NO_NODE && !node_online(nid))
 		return 0;
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
@@ -3095,7 +3095,7 @@ static void __init hugetlb_hstate_alloc_
 	}
 
 	/* do node specific alloc */
-	for (i = 0; i < nr_online_nodes; i++) {
+	for_each_online_node(i) {
 		if (h->max_huge_pages_node[i] > 0) {
 			hugetlb_hstate_alloc_pages_onenode(h, i);
 			node_specific_alloc = true;
@@ -4059,7 +4059,7 @@ static int __init hugetlb_init(void)
 			default_hstate.max_huge_pages =
 				default_hstate_max_huge_pages;
 
-			for (i = 0; i < nr_online_nodes; i++)
+			for_each_online_node(i)
 				default_hstate.max_huge_pages_node[i] =
 					default_hugepages_in_node[i];
 		}
@@ -4174,9 +4174,9 @@ static int __init hugepages_setup(char *
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
 				return 0;
 			}
-			if (tmp >= nr_online_nodes)
+			if (!node_online(tmp))
 				goto invalid;
-			node = array_index_nospec(tmp, nr_online_nodes);
+			node = array_index_nospec(tmp, MAX_NUMNODES);
 			p += count + 1;
 			/* Parse hugepages */
 			if (sscanf(p, "%lu%n", &tmp, &count) != 1)
@@ -4304,7 +4304,7 @@ static int __init default_hugepagesz_set
 	 */
 	if (default_hstate_max_huge_pages) {
 		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
-		for (i = 0; i < nr_online_nodes; i++)
+		for_each_online_node(i)
 			default_hstate.max_huge_pages_node[i] =
 				default_hugepages_in_node[i];
 		if (hstate_is_gigantic(&default_hstate))
_

Patches currently in -mm which might be from liupeng256@huawei.com are

hugetlb-fix-wrong-use-of-nr_online_nodes.patch
hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
hugetlb-fix-return-value-of-__setup-handlers.patch
hugetlb-clean-up-hugetlb_cma_reserve.patch

