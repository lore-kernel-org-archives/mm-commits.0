Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5EBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 04:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbiD2EEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 00:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiD2EEa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 00:04:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70F060D82
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 21:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E6EAB832C5
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 04:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA74C385A7;
        Fri, 29 Apr 2022 04:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651204871;
        bh=aw4VoaCsxCI8+zWR63UC8Zof+A4N00yjHpgaIju/XVU=;
        h=Date:To:From:Subject:From;
        b=fyjI8uHQOW4jIW9CKfoBS4kZz5BCuXzfraRshfrAXorJcDPpN6voMF+WLFzLRCJa3
         1CswLFc92ytWgw1bZx1JFe7TA0SACYED+sKYSP46sCTbq88MGXMyf+yaCtH2BIG4KD
         Rjh+wWuMtKj138xeDvwleZqTzXyo/XNGk0QKMdT4=
Date:   Thu, 28 Apr 2022 21:01:10 -0700
To:     mm-commits@vger.kernel.org, dave@stgolabs.net,
        akpm@linux-foundation.org, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch added to -mm tree
Message-Id: <20220429040111.1FA74C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use for_each_online_node and node_online instead of open coding
has been added to the -mm tree.  Its filename is
     mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch

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
Subject: mm: use for_each_online_node and node_online instead of open coding

Use more generic functions to deal with issues related to online nodes. 
The changes will make the code simplified.

Link: https://lkml.kernel.org/r/20220429030218.644635-1-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Suggested-by: Davidlohr Bueso <dave@stgolabs.net>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
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

hugetlb-fix-wrong-use-of-nr_online_nodes.patch
hugetlb-fix-wrong-use-of-nr_online_nodes-v4.patch
hugetlb-fix-hugepages_setup-when-deal-with-pernode.patch
hugetlb-fix-return-value-of-__setup-handlers.patch
mm-using-for_each_online_node-and-node_online-instead-of-open-coding.patch

