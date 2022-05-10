Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6FBC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiEJEUP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiEJESQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3B6F68BA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2727C61744
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B61C385A6;
        Tue, 10 May 2022 04:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156054;
        bh=eqgc9jWkGZdxmq2NCtv5/0pFphwSDyppskEKvqzV+rM=;
        h=Date:To:From:Subject:From;
        b=bomFO8PnFPOQ/VxUHaJImocaU2wbunXHLjtjMNoPUzsqHnmM0tWXPRcnrNgz3BwqG
         D3LgGWT5hMMFFeIYqTTxQeuEJkxQ2nj4PqkPthPJrvH6bXxcsYu2ZmuZRFz8xctDe+
         DnydEOCVdEe5AgsfT33pFsxq631g4/67oC97tkjU=
Date:   Mon, 09 May 2022 21:14:13 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        david@redhat.com, dave@stgolabs.net, akpm@linux-foundation.org,
        liupeng256@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch removed from -mm tree
Message-Id: <20220510041414.78B61C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use for_each_online_node and node_online instead of open coding
has been removed from the -mm tree.  Its filename was
     mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Peng Liu <liupeng256@huawei.com>
Subject: mm: use for_each_online_node and node_online instead of open coding

Use more generic functions to deal with issues related to online nodes. 
The changes will make the code simplified.

Link: https://lkml.kernel.org/r/20220429030218.644635-1-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Suggested-by: Davidlohr Bueso <dave@stgolabs.net>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/uncached.c |    2 +-
 mm/hugetlb.c                |    4 ++--
 mm/page_ext.c               |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/ia64/kernel/uncached.c~mm-using-for_each_online_node-and-node_online-instead-of-open-coding
+++ a/arch/ia64/kernel/uncached.c
@@ -261,7 +261,7 @@ static int __init uncached_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_ONLINE) {
+	for_each_online_node(nid) {
 		uncached_pools[nid].pool = gen_pool_create(PAGE_SHIFT, nid);
 		mutex_init(&uncached_pools[nid].add_chunk_mutex);
 	}
--- a/mm/hugetlb.c~mm-using-for_each_online_node-and-node_online-instead-of-open-coding
+++ a/mm/hugetlb.c
@@ -6971,7 +6971,7 @@ void __init hugetlb_cma_reserve(int orde
 		if (hugetlb_cma_size_in_node[nid] == 0)
 			continue;
 
-		if (!node_state(nid, N_ONLINE)) {
+		if (!node_online(nid)) {
 			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
 			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
 			hugetlb_cma_size_in_node[nid] = 0;
@@ -7010,7 +7010,7 @@ void __init hugetlb_cma_reserve(int orde
 	}
 
 	reserved = 0;
-	for_each_node_state(nid, N_ONLINE) {
+	for_each_online_node(nid) {
 		int res;
 		char name[CMA_MAX_NAME];
 
--- a/mm/page_ext.c~mm-using-for_each_online_node-and-node_online-instead-of-open-coding
+++ a/mm/page_ext.c
@@ -320,7 +320,7 @@ static int __meminit online_page_ext(uns
 		 * online__pages(), and start_pfn should exist.
 		 */
 		nid = pfn_to_nid(start_pfn);
-		VM_BUG_ON(!node_state(nid, N_ONLINE));
+		VM_BUG_ON(!node_online(nid));
 	}
 
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION)
_

Patches currently in -mm which might be from liupeng256@huawei.com are


