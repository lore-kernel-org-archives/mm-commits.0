Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1003C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 04:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiDMEtj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 00:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiDMEtX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 00:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0C031DDD
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DCB261BA9
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 04:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE67C385A4;
        Wed, 13 Apr 2022 04:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649825221;
        bh=r6UhT1ZxFZI2O20qF1g5kwcYs5tzsctqAVeTV14F/yg=;
        h=Date:To:From:Subject:From;
        b=C9fOd9xPb6DVhL/BR7v75lbMyLFn0C2kvMZhsqzn6JFjggm4jYusvGdJTehNhiUoW
         NZTJmd5AKL3cNhiS0Rqv83bayz95El16wUyVcLoAc5P4NS4+2AEXP6w1SwLlIa9+mN
         42UowwOm00PCaoS0Ms2EjO7iV2dNGwEsqyaw6V8s=
Date:   Tue, 12 Apr 2022 21:47:00 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        liuyuntao10@huawei.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-clean-up-hugetlb_cma_reserve.patch added to -mm tree
Message-Id: <20220413044701.6EE67C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: clean up hugetlb_cma_reserve
has been added to the -mm tree.  Its filename is
     hugetlb-clean-up-hugetlb_cma_reserve.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-clean-up-hugetlb_cma_reserve.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-clean-up-hugetlb_cma_reserve.patch

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
Subject: hugetlb: clean up hugetlb_cma_reserve

Use more generic functions to deal with issues related to online nodes. 
The changes will make the code simplified.

Link: https://lkml.kernel.org/r/20220413032915.251254-5-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~hugetlb-clean-up-hugetlb_cma_reserve
+++ a/mm/hugetlb.c
@@ -7026,7 +7026,7 @@ void __init hugetlb_cma_reserve(int orde
 		if (hugetlb_cma_size_in_node[nid] == 0)
 			continue;
 
-		if (!node_state(nid, N_ONLINE)) {
+		if (!node_online(nid)) {
 			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
 			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
 			hugetlb_cma_size_in_node[nid] = 0;
@@ -7065,7 +7065,7 @@ void __init hugetlb_cma_reserve(int orde
 	}
 
 	reserved = 0;
-	for_each_node_state(nid, N_ONLINE) {
+	for_each_online_node(nid) {
 		int res;
 		char name[CMA_MAX_NAME];
 
_

Patches currently in -mm which might be from liupeng256@huawei.com are

hugetlb-fix-wrong-use-of-nr_online_nodes.patch
hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
hugetlb-fix-return-value-of-__setup-handlers.patch
hugetlb-clean-up-hugetlb_cma_reserve.patch

