Return-Path: <SRS0=9IPz=EN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039EFC388F9
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 05:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B982A20888
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 05:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604726269;
	bh=PCbcBMBAvrwipehiDoaUY0PjoRXkp6BxWmoJD2yuL3o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nasbzDM0ZXsUlsecnCNsAz+Liy+vcUN7hPw26RCyA6hCR6Zon+JV1ESXuN6Ts0jgE
	 m2E8Uld6iPTPOyVycn6PLpR8HmLZ+6fitI+lIwCOzjNzvncjhryfdiweNPexB8fHbK
	 Pocy/Xg28tRaj9R9TR7fe8KBT1qtiUmOcTpAH508=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgKGFRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 00:17:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgKGFRt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 00:17:49 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED6E820878;
        Sat,  7 Nov 2020 05:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604726268;
        bh=PCbcBMBAvrwipehiDoaUY0PjoRXkp6BxWmoJD2yuL3o=;
        h=Date:From:To:Subject:From;
        b=ydbZhxWIivE0VoEBDw7fjfcf7A9oI088LJ3+KO1OWr2FSskuGlDHzZPyzM4AhnuDH
         Eb1NnPzH3wTdHtwk0eN/75gH/nqGieodf+drPx1XoPGK4OC263g7VSv1tPKA7rVZDY
         cquNGN/o0g/2+lDB/t6zbwkxnl2y2g+SxzyLtSWU=
Date:   Fri, 06 Nov 2020 21:17:47 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        vbabka@suse.cz, willy@infradead.org, xuyu@linux.alibaba.com
Subject:  + mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch
 added to -mm tree
Message-ID: <20201107051747.qIVBfagwx%akpm@linux-foundation.org>
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
allocates tmpfs memory, but will happily reclaim some of its
pool if no memory is available.

Make sure the gfp mask used to opportunistically allocate a THP
is always at least as restrictive as the original gfp mask.

Link: https://lkml.kernel.org/r/20201105191508.1961686-3-riel@surriel.com
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
@@ -1531,6 +1531,26 @@ static struct page *shmem_swapin(swp_ent
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
@@ -1889,6 +1909,7 @@ repeat:
 
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

