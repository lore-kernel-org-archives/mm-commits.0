Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5F2C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C05DB64F29
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhBZBRY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhBZBRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF82864EE2;
        Fri, 26 Feb 2021 01:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302183;
        bh=7gEYKZB64tN1w9z8rqAjUYw4K2eSczZUtQqGKkhHqvY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VRaNjik0rN5Ms+Vp+pLoINhEfzBaxNPUk25qo9qqxHF8IYgfSQqmHISC9X9hh/TQw
         WX1OfFd6gp9zdUS5Dcqjs/sRKwxDxj+O0k8vWhTpDrDBkXC+IgkpWwzMNH7ZRFCf2V
         kpctMVZl5nsbuzJwSSIFvbpI5UyxFkShh6ybwSuo=
Date:   Thu, 25 Feb 2021 17:16:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, riel@surriel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org,
        xuyu@linux.alibaba.com
Subject:  [patch 016/118] mm,thp,shm: limit gfp mask to no more
 than specified
Message-ID: <20210226011622.Yk-B2Pcu0%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1505,6 +1505,26 @@ static struct page *shmem_swapin(swp_ent
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
@@ -1864,6 +1884,7 @@ repeat:
 
 alloc_huge:
 	huge_gfp = vma_thp_gfp_mask(vma);
+	huge_gfp = limit_gfp_mask(huge_gfp, gfp);
 	page = shmem_alloc_and_acct_page(huge_gfp, inode, index, true);
 	if (IS_ERR(page)) {
 alloc_nohuge:
_
