Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AA7C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245274AbiD2Q5z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242283AbiD2Q5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:57:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B53DA6D9
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B91ED61AF8
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC51C385A7;
        Fri, 29 Apr 2022 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651251275;
        bh=ZDMMRTg2cNpOFAnfDkZ4oTKVay7GC3A2r2N9G/q6lpo=;
        h=Date:To:From:Subject:From;
        b=Cimk1W+NweEh4IHGTcFw3RpOoV/V6ddUn8fiYaFMh4p0BU6+zZAf0IRC6SQnibbCb
         hwEeVVCKDVw4mh/HEVNxLO5rQBbcFpkptgT9Ciavz/2lHZ+HtLfcDF7NjyTgntHNN4
         umogjrBaaAvoSbf9Ho8CslKUrNqlcPH4JA4Tp8yc=
Date:   Fri, 29 Apr 2022 09:54:34 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        wangkefeng.wang@huawei.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, liuyuntao10@huawei.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch removed from -mm tree
Message-Id: <20220429165435.1CC51C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: Fix wrong use of nr_online_nodes
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch

This patch was dropped because it was folded into hugetlb-fix-wrong-use-of-nr_online_nodes.patch

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
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
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
hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
hugetlb-fix-return-value-of-__setup-handlers.patch
mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch

