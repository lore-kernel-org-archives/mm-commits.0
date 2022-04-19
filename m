Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F86C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 04:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiDSEJM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 00:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiDSEJM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 00:09:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D438925E85
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 21:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8527FB80A72
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 04:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA8CC385A5;
        Tue, 19 Apr 2022 04:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650341188;
        bh=qdE19jiqxhc/12OAHSvYDkinPvoEIIRQUdXMddQOxfE=;
        h=Date:To:From:Subject:From;
        b=0d6fCea7MoeAJiTAPRpbe8QFFEQg8D89p4JLOwsM5AsFySmuv4l2uGNlzCcZrunPu
         6TnSf0XGOwvh3VYkkoHXvxoZ1EbG475erc43FZrUNw6khNEhl3NjGBhShL+zU7vEMe
         /TVbUxoBnEKI3F4MTmnirXuAkaJqbbgTjLEnG09A=
Date:   Mon, 18 Apr 2022 21:06:27 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        liuyuntao10@huawei.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch added to -mm tree
Message-Id: <20220419040628.2CA8CC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: Fix wrong use of nr_online_nodes
has been added to the -mm tree.  Its filename is
     hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch

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
Subject: hugetlb: Fix wrong use of nr_online_nodes

Make sure nid is valid before use node_online, and
__alloc_bootmem_huge_page is no need to check node_online, which is
suggested by Kefeng.

Link: https://lkml.kernel.org/r/20220416103526.3287348-1-liupeng256@huawei.com
Fixes: 4178158ef8ca ("hugetlbfs: fix issue of preallocation of gigantic pages can't work")
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Fixes: e79ce9832316 ("hugetlbfs: fix a truncation issue in hugepages parameter")
Fixes: f9317f77a6e0 ("hugetlb: clean up potential spectre issue warnings")
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-fix-wrong-use-of-nr_online_nodes-v4
+++ a/mm/hugetlb.c
@@ -2986,8 +2986,6 @@ int __alloc_bootmem_huge_page(struct hst
 	struct huge_bootmem_page *m = NULL; /* initialize for clang */
 	int nr_nodes, node;
 
-	if (nid != NUMA_NO_NODE && !node_online(nid))
-		return 0;
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
 		m = memblock_alloc_try_nid_raw(huge_page_size(h), huge_page_size(h),
@@ -4174,7 +4172,7 @@ static int __init hugepages_setup(char *
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
 				return 0;
 			}
-			if (!node_online(tmp))
+			if (tmp >= MAX_NUMNODES || !node_online(tmp))
 				goto invalid;
 			node = array_index_nospec(tmp, MAX_NUMNODES);
 			p += count + 1;
_

Patches currently in -mm which might be from liupeng256@huawei.com are

hugetlb-fix-wrong-use-of-nr_online_nodes.patch
hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch
hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
hugetlb-fix-return-value-of-__setup-handlers.patch
hugetlb-clean-up-hugetlb_cma_reserve.patch

