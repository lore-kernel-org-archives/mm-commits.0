Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF627C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbiEJEUM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbiEJESQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431C79136F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D53506173F
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1DFC385A6;
        Tue, 10 May 2022 04:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156051;
        bh=tb7nlJ9yi5lU/nXf29OQlI+v/Xd7AtZ4AgSQRcnr5PU=;
        h=Date:To:From:Subject:From;
        b=RJ+JoOcfnkSbAIAljGVLtIoeaGLxz+kMg/Qo4I/NM6+0YZzuzbAeui39yAZA31YlM
         1StrruBnvP2nf70wBxhA2N+RJrQ2bANEdSI27fbY+szNg8l1zjIEF8EvvWzP8xtw9m
         mYpYOnLOaO2YBNhFHabJK33Nnx4HeI5AbQTnyZYA=
Date:   Mon, 09 May 2022 21:14:10 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        wangkefeng.wang@huawei.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, liuyuntao10@huawei.com, david@redhat.com,
        dave@stgolabs.net, baolin.wang@linux.alibaba.com,
        liupeng256@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-fix-wrong-use-of-nr_online_nodes.patch removed from -mm tree
Message-Id: <20220510041411.2E1DFC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix wrong use of nr_online_nodes
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-wrong-use-of-nr_online_nodes.patch

This patch was dropped because it was merged into mm-stable

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

However, in hugetlb, it is assumed that nodes are contiguous.

For sparse/discontiguous nodes, the current code may treat a valid node
as invalid, and will fail to allocate all hugepages on a valid node that
"nid >= nr_online_nodes".

As David suggested:

	if (tmp >= nr_online_nodes)
		goto invalid;

Just imagine node 0 and node 2 are online, and node 1 is offline. 
Assuming that "node < 2" is valid is wrong.  

Recheck all the places that use nr_online_nodes, and repair them one by
one.

[liupeng256@huawei.com: v4]
  Link: https://lkml.kernel.org/r/20220416103526.3287348-1-liupeng256@huawei.com
Link: https://lkml.kernel.org/r/20220413032915.251254-1-liupeng256@huawei.com
Link: https://lkml.kernel.org/r/20220413032915.251254-2-liupeng256@huawei.com
Fixes: 4178158ef8ca ("hugetlbfs: fix issue of preallocation of gigantic pages can't work")
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Fixes: e79ce9832316 ("hugetlbfs: fix a truncation issue in hugepages parameter")
Fixes: f9317f77a6e0 ("hugetlb: clean up potential spectre issue warnings")
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~hugetlb-fix-wrong-use-of-nr_online_nodes
+++ a/mm/hugetlb.c
@@ -2984,8 +2984,6 @@ int __alloc_bootmem_huge_page(struct hst
 	struct huge_bootmem_page *m = NULL; /* initialize for clang */
 	int nr_nodes, node;
 
-	if (nid != NUMA_NO_NODE && nid >= nr_online_nodes)
-		return 0;
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
 		m = memblock_alloc_try_nid_raw(huge_page_size(h), huge_page_size(h),
@@ -3093,7 +3091,7 @@ static void __init hugetlb_hstate_alloc_
 	}
 
 	/* do node specific alloc */
-	for (i = 0; i < nr_online_nodes; i++) {
+	for_each_online_node(i) {
 		if (h->max_huge_pages_node[i] > 0) {
 			hugetlb_hstate_alloc_pages_onenode(h, i);
 			node_specific_alloc = true;
@@ -4057,7 +4055,7 @@ static int __init hugetlb_init(void)
 			default_hstate.max_huge_pages =
 				default_hstate_max_huge_pages;
 
-			for (i = 0; i < nr_online_nodes; i++)
+			for_each_online_node(i)
 				default_hstate.max_huge_pages_node[i] =
 					default_hugepages_in_node[i];
 		}
@@ -4172,9 +4170,9 @@ static int __init hugepages_setup(char *
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
 				return 0;
 			}
-			if (tmp >= nr_online_nodes)
+			if (tmp >= MAX_NUMNODES || !node_online(tmp))
 				goto invalid;
-			node = array_index_nospec(tmp, nr_online_nodes);
+			node = array_index_nospec(tmp, MAX_NUMNODES);
 			p += count + 1;
 			/* Parse hugepages */
 			if (sscanf(p, "%lu%n", &tmp, &count) != 1)
@@ -4302,7 +4300,7 @@ static int __init default_hugepagesz_set
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


