Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D30C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C42222CB9
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAXBLY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAXBLX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:11:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F33F522CB9;
        Sun, 24 Jan 2021 01:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611450642;
        bh=tvQPDC1pwcE9Zbsdcee/g6f5PHme5+xPD+7PUZcI/zs=;
        h=Date:From:To:Subject:From;
        b=1zbokm25u9VdHXIo/kZtMFTwgTT+kADz9/PmOMoEskpzBYkGPa/5JPdc0MrSTE+LY
         A8n9GJxnptSTgnqqCTpJbMBAYR4CWcAQ1nBI+RFNcTknCPQYe1b3rd73ovcR5P1XEf
         JF+JGviEOYCk9DFKArZoYckBya5/i1b3r3/9YryI=
Date:   Sat, 23 Jan 2021 17:10:41 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-workingsetc-avoid-unnecessary-max=5Fnodes-estimation-in-?=
 =?US-ASCII?Q?count=5Fshadow=5Fnodes.patch?= added to -mm tree
Message-ID: <20210124011041.C5hesos93%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/workingset.c: avoid unnecessary max_nodes estimation in count_shadow_nodes()
has been added to the -mm tree.  Its filename is
     mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch

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
Subject: mm/workingset.c: avoid unnecessary max_nodes estimation in count_shadow_nodes()

If list_lru_shrink_count is 0, we always return SHRINK_EMPTY regardless of
the value of max_nodes.  So we can return early if nodes == 0 to save some
cpu cycles of approximating a reasonable limit for the nodes.

Link: https://lkml.kernel.org/r/20210123073825.46709-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/workingset.c~mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes
+++ a/mm/workingset.c
@@ -461,6 +461,8 @@ static unsigned long count_shadow_nodes(
 	unsigned long pages;
 
 	nodes = list_lru_shrink_count(&shadow_nodes, sc);
+	if (!nodes)
+		return SHRINK_EMPTY;
 
 	/*
 	 * Approximate a reasonable limit for the nodes
@@ -503,9 +505,6 @@ static unsigned long count_shadow_nodes(
 
 	max_nodes = pages >> (XA_CHUNK_SHIFT - 3);
 
-	if (!nodes)
-		return SHRINK_EMPTY;
-
 	if (nodes <= max_nodes)
 		return 0;
 	return nodes - max_nodes;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

