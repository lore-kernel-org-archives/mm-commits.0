Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FD2C56201
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F5FF2083E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fttPIyMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgKYXYU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgKYXYU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 18:24:20 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2A9E2083E;
        Wed, 25 Nov 2020 23:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606346659;
        bh=niWVBOVnXetNXCaSdY/MkLtQpfmAvSSAvrSFjFFtVV8=;
        h=Date:From:To:Subject:From;
        b=fttPIyMls8o319BCsBquQnvIsnqY8OopHfw9Yv4eoDarFe8ia0HZJHUwPZPSYaNzJ
         1RJCwMak/JoY4ZG/GfyWJ3ZLqP2U7F6nixRHwkY9g/aWNlzM2ImkdabxhEM84uPmwX
         3QWjs6176u2wFv/IHMN+rogQlop0UIfCwTtj151k=
Date:   Wed, 25 Nov 2020 15:24:18 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        vbabka@suse.cz, willy@infradead.org, xuyu@linux.alibaba.com
Subject:  + mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch
 added to -mm tree
Message-ID: <20201125232418.Fc15ZsxLH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,shm: limit gfp mask to no more than specified
has been added to the -mm tree.  Its filename is
     mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm,thp,shm: limit gfp mask to no more than specified

Matthew Wilcox pointed out that the i915 driver opportunistically
allocates tmpfs memory, but will happily reclaim some of its pool if no
memory is available.

Make sure the gfp mask used to opportunistically allocate a THP is always
at least as restrictive as the original gfp mask.

Link: https://lkml.kernel.org/r/20201124194925.623931-3-riel@surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/mm/shmem.c~mmthpshm-limit-gfp-mask-to-no-more-than-specified
+++ a/mm/shmem.c
@@ -1452,6 +1452,26 @@ static struct page *shmem_swapin(swp_ent
 	return page;
 }
 
+/*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some of the flags set permissions, while others set limitations.
+ */
+static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t result = huge_gfp & ~allowflags;
+
+	/*
+	 * Minimize the result gfp by taking the union with the deny flags,
+	 * and the intersection of the allow flags.
+	 */
+	result |= (limit_gfp & denyflags);
+	result |= (huge_gfp & limit_gfp) & allowflags;
+
+	return result;
+}
+
 static struct page *shmem_alloc_hugepage(gfp_t gfp,
 		struct shmem_inode_info *info, pgoff_t index)
 {
@@ -1811,6 +1831,7 @@ repeat:
 
 alloc_huge:
 	huge_gfp = vma_thp_gfp_mask(vma);
+	huge_gfp = limit_gfp_mask(huge_gfp, gfp);
 	page = shmem_alloc_and_acct_page(huge_gfp, inode, index, true);
 	if (IS_ERR(page)) {
 alloc_nohuge:
_

Patches currently in -mm which might be from riel@surriel.com are

mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch
mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch
mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch

