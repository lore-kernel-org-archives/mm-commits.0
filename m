Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C12C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 04:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbiD2EED (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 00:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiD2EEC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 00:04:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601145C855
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 21:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21B12B832CD
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 04:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC672C385A7;
        Fri, 29 Apr 2022 04:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651204842;
        bh=2uOdx3oY8LHZJpxXUYVCKH/4hwBV71xX6779UdlR+mE=;
        h=Date:To:From:Subject:From;
        b=07tBg541KxN7jVSoXDA+1nmq0wKi4BNlL+l756YY6hrt6S6AGEdYn5Xb//ak1/vd9
         EMpMPnvjHUSE4B0tD27ycPgGj/2EQOJeUoDoTS2C9mgYTcDlYvFKNttpMjMI94jiCI
         HG7QPE1XvGlsfGcVRCon1oZ+/lrBEbaL+ymA/wKg=
Date:   Thu, 28 Apr 2022 21:00:41 -0700
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com,
        wangkefeng.wang@huawei.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, liuyuntao10@huawei.com, david@redhat.com,
        dave@stgolabs.net, baolin.wang@linux.alibaba.com,
        liupeng256@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hugetlb-clean-up-hugetlb_cma_reserve.patch removed from -mm tree
Message-Id: <20220429040042.AC672C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: clean up hugetlb_cma_reserve
has been removed from the -mm tree.  Its filename was
     hugetlb-clean-up-hugetlb_cma_reserve.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peng Liu <liupeng256@huawei.com>
Subject: hugetlb: clean up hugetlb_cma_reserve

Use more generic functions to deal with issues related to online nodes. 
The changes will make the code simplified.

Link: https://lkml.kernel.org/r/20220413032915.251254-5-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch
hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
hugetlb-fix-return-value-of-__setup-handlers.patch
mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch

