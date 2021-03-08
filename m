Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A08BC433E9
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7883652B4
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCHUB5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhCHUBu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 15:01:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40D6365238;
        Mon,  8 Mar 2021 20:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615233710;
        bh=A/Ufuwqlk6ERelMSD5y1kZdVnScapOoRwWsMfXhgZco=;
        h=Date:From:To:Subject:From;
        b=pLVSoC3HLlE4+ted+X9TI5ZC9KpuKQi4ClfwgEPJ851pa4yO7Hoc+/lOtHrZk5bLi
         +YZ9vOUUWs4oHLGQZcSQLTjl+5Ax6n3teAipuNT2CAERe/xo9v9c0p7tVsrtqaDYTh
         xFryNT/MQJ6HPDk3NO+8CmtiB6Ba7hUwOmKQgYgs=
Date:   Mon, 08 Mar 2021 12:01:49 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch added to -mm
 tree
Message-ID: <20210308200149.9MkNsPS-_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use some helper functions to cleanup code
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: use some helper functions to cleanup code

Patch series "Some cleanups for hugetlb".

This series contains cleanups to remove unnecessary VM_BUG_ON_PAGE, use
helper function and so on.  I also collect some previous patches into this
series in case they are forgotten.


This patch (of 5):

We could use pages_per_huge_page to get the number of pages per hugepage,
use get_hstate_idx to calculate hstate index, and use hstate_is_gigantic
to check if a hstate is gigantic to make code more succinct.

Link: https://lkml.kernel.org/r/20210308112809.26107-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/hugetlb.c         |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-use-some-helper-functions-to-cleanup-code
+++ a/fs/hugetlbfs/inode.c
@@ -1435,7 +1435,7 @@ static int get_hstate_idx(int page_size_
 
 	if (!h)
 		return -1;
-	return h - hstates;
+	return hstate_index(h);
 }
 
 /*
--- a/mm/hugetlb.c~mm-hugetlb-use-some-helper-functions-to-cleanup-code
+++ a/mm/hugetlb.c
@@ -1274,7 +1274,7 @@ static void free_gigantic_page(struct pa
 static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
-	unsigned long nr_pages = 1UL << huge_page_order(h);
+	unsigned long nr_pages = pages_per_huge_page(h);
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
@@ -3268,10 +3268,10 @@ static int __init hugepages_setup(char *
 
 	/*
 	 * Global state is always initialized later in hugetlb_init.
-	 * But we need to allocate >= MAX_ORDER hstates here early to still
+	 * But we need to allocate gigantic hstates here early to still
 	 * use the bootmem allocator.
 	 */
-	if (hugetlb_max_hstate && parsed_hstate->order >= MAX_ORDER)
+	if (hugetlb_max_hstate && hstate_is_gigantic(parsed_hstate))
 		hugetlb_hstate_alloc_pages(parsed_hstate);
 
 	last_mhp = mhp;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch

