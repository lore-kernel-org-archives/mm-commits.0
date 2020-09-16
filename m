Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88C3C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 888AC21D90
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600296520;
	bh=0uQ7E2/D7otbI3AzrVI2tMYwWOhT1lywXEv6TbSaqI4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SbCEivBHk9M+ckS8Tkx02ckHqI9kxggFDknfG2/lNY3TM0sZkrzseyklrYn2yrbrt
	 rMRaAhfxF3FmtGppyK73oGHXsHV/WMXyqzUutfyDsljyT+JlxD5YHUcI8skzNdmJXC
	 lALjfFfe2dgvcplUCYsh8LWm2yGmV1v2xAgQ1tQA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgIPWsj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 18:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgIPWsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 18:48:39 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 224F621D7D;
        Wed, 16 Sep 2020 22:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600296518;
        bh=0uQ7E2/D7otbI3AzrVI2tMYwWOhT1lywXEv6TbSaqI4=;
        h=Date:From:To:Subject:From;
        b=QbbcspsYC6f0L6JoossxkT4JxOYktkvRo6mEtpFOQW3jiwKQdWIZ/GAU7w8XzBKkM
         KVYL5Jvq34qmWxvDIo59Mk8soafsub0i4JPnlLQ9Jq1aqGAGMcSYtK1bOQE36i/1iz
         uLYhZ5bxKjBH95PcPZhhhqjTVJ4DIq73YE92jIec=
Date:   Wed, 16 Sep 2020 15:48:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        mateusznosek0@gmail.com
Subject:  + mm-page_allocc-clean-code-by-merging-two-functions.patch
 added to -mm tree
Message-ID: <20200916224837.-ZHRl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: clean code by merging two functions
has been added to the -mm tree.  Its filename is
     mm-page_allocc-clean-code-by-merging-two-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-clean-code-by-merging-two-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-clean-code-by-merging-two-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_alloc.c: clean code by merging two functions

finalise_ac() is just 'epilogue' for 'prepare_alloc_pages'.  Therefore
there is no need to keep them both so 'finalise_ac' content can be merged
into prepare_alloc_pages() code.  It would make __alloc_pages_nodemask()
cleaner when it comes to readability.

Link: https://lkml.kernel.org/r/20200916110118.6537-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-clean-code-by-merging-two-functions
+++ a/mm/page_alloc.c
@@ -4824,12 +4824,6 @@ static inline bool prepare_alloc_pages(g
 
 	*alloc_flags = current_alloc_flags(gfp_mask, *alloc_flags);
 
-	return true;
-}
-
-/* Determine whether to spread dirty pages and what the first usable zone */
-static inline void finalise_ac(gfp_t gfp_mask, struct alloc_context *ac)
-{
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
@@ -4840,6 +4834,8 @@ static inline void finalise_ac(gfp_t gfp
 	 */
 	ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
+
+	return true;
 }
 
 /*
@@ -4868,8 +4864,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
 		return NULL;
 
-	finalise_ac(gfp_mask, &ac);
-
 	/*
 	 * Forbid the first pass from falling back to types that fragment
 	 * memory until all local zones are considered.
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-slabc-clean-code-by-removing-redundant-if-condition.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch
mm-page_allocc-fix-early-params-garbage-value-accesses.patch
mm-page_allocc-clean-code-by-merging-two-functions.patch
mm-compactionc-micro-optimization-remove-unnecessary-branch.patch

