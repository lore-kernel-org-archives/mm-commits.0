Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AECEC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 17:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D49A264F0D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 17:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbhBXR3N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 12:29:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhBXR3M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 12:29:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A3DD64F0C;
        Wed, 24 Feb 2021 17:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614187711;
        bh=Ee/yXod1N2l8eflVqrDSBWg4Z6lb9PNV0u93mdSx6ng=;
        h=Date:From:To:Subject:From;
        b=rmbcLmAkpp2PkVKa9lXZUIQlJK586rr5r/IWc/5enpLC8EYJv1r0JVSLYcRA1kPRA
         l3Z6rw8oaVWAjdIwt1kFVgfN4sZzgSWg434q5Ct8QVon2pD22/ghKdxc04qMbjo85L
         SiM/7YqKDQns67nZXCWpZkvkrZObddUT+7wbIYrU=
Date:   Wed, 24 Feb 2021 09:28:30 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        vbabka@suse.cz, willy@infradead.org, xuyu@linux.alibaba.com
Subject:  +
 mmshmemthp-limit-shmem-thp-allocations-to-requested-zones.patch added to
 -mm tree
Message-ID: <20210224172830.A4rx6d0re%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,shmem,thp: limit shmem THP allocations to requested zones
has been added to the -mm tree.  Its filename is
     mmshmemthp-limit-shmem-thp-allocations-to-requested-zones.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmshmemthp-limit-shmem-thp-allocations-to-requested-zones.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmshmemthp-limit-shmem-thp-allocations-to-requested-zones.patch

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
Subject: mm,shmem,thp: limit shmem THP allocations to requested zones

Hugh pointed out that the gma500 driver uses shmem pages, but needs to
limit them to the DMA32 zone.  Ensure the allocations resulting from the
gfp_mask returned by limit_gfp_mask use the zone flags that were
originally passed to shmem_getpage_gfp.

Link: https://lkml.kernel.org/r/20210224121016.1314ed6d@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mmshmemthp-limit-shmem-thp-allocations-to-requested-zones
+++ a/mm/shmem.c
@@ -1513,7 +1513,11 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 {
 	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
 	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t result = huge_gfp & ~allowflags;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
 
 	/*
 	 * Minimize the result gfp by taking the union with the deny flags,
_

Patches currently in -mm which might be from riel@surriel.com are

mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch
mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch
mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch
mmshmemthp-limit-shmem-thp-allocations-to-requested-zones.patch

