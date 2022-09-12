Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9688BECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiILDag (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILD3R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE30286C0
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EF29B80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1861C433D6;
        Mon, 12 Sep 2022 03:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953337;
        bh=TGN0kEhQrQIPa9xRktZcbKJ4CbPHcN8SEy5o2m9tX4M=;
        h=Date:To:From:Subject:From;
        b=ed7N+I1paA3WMFz3N6koXRMwqIpoDQMFMYbBHhq4FgtpOYNBv/k4Dbd5MdhdRhHNv
         ti/R4r9vfeei2WVWDxC64vXSjYiJ8kSD67Eqc8ULkigV5FG7HdOKuhQAe02Tb5/LQN
         88GN9gxBdy4uWLbnmNY9sqZ4rZUDZ+99bV2w9thQ=
Date:   Sun, 11 Sep 2022 20:28:57 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb_cgroup-use-helper-macro-numa_no_node.patch removed from -mm tree
Message-Id: <20220912032857.D1861C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb_cgroup: use helper macro NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-use-helper-macro-numa_no_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: use helper macro NUMA_NO_NODE
Date: Fri, 29 Jul 2022 16:01:05 +0800

It's better to use NUMA_NO_NODE instead of magic number -1. Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220729080106.12752-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-use-helper-macro-numa_no_node
+++ a/mm/hugetlb_cgroup.c
@@ -154,9 +154,9 @@ hugetlb_cgroup_css_alloc(struct cgroup_s
 	 * function.
 	 */
 	for_each_node(node) {
-		/* Set node_to_alloc to -1 for offline nodes. */
+		/* Set node_to_alloc to NUMA_NO_NODE for offline nodes. */
 		int node_to_alloc =
-			node_state(node, N_NORMAL_MEMORY) ? node : -1;
+			node_state(node, N_NORMAL_MEMORY) ? node : NUMA_NO_NODE;
 		h_cgroup->nodeinfo[node] =
 			kzalloc_node(sizeof(struct hugetlb_cgroup_per_node),
 				     GFP_KERNEL, node_to_alloc);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

