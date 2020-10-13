Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95297C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B9AF2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633353;
	bh=8QppMaNMEYVPC1U4181l8fRsa6CPNpjtlzfNCQGiqNE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wLKdHUBy136CYqBwtnYFPu5yiN5sGbEdivF++9SL/f/4hrUyGgGM7XCXdxvx+ULJO
	 It2kHeqERL3AroILntnGG7kNAngygURwS21EIjHOu/0eEWzuYRxHc+QItuJes9520W
	 PmGESmnXeAyem5m7cThYoXn84Q10YTMnv30PYum4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388560AbgJMXzx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXzw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFE2F2223F;
        Tue, 13 Oct 2020 23:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633352;
        bh=8QppMaNMEYVPC1U4181l8fRsa6CPNpjtlzfNCQGiqNE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hhQN7U39tVR1fTT+oBBDIfUFxOIhqfqAE3j50//InTaeDsyfIjQubvS5bwUfXqrC5
         rzxIaht+jMbgYRBQFaCNR7kAsTusj+K77El0LUb7VZVAZW6b/Zoi6zCt2UAi/5urh5
         3kBHWiGUAmUSJAfZymkHRQsr2++eR/64JnBXUHlE=
Date:   Tue, 13 Oct 2020 16:55:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mateusznosek0@gmail.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 135/181] mm/page_alloc.c: clean code by merging
 two functions
Message-ID: <20201013235551.f89V8fOm6%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_alloc.c: clean code by merging two functions

finalise_ac() is just 'epilogue' for 'prepare_alloc_pages'.  Therefore
there is no need to keep them both so 'finalise_ac' content can be merged
into prepare_alloc_pages() code.  It would make __alloc_pages_nodemask()
cleaner when it comes to readability.

Link: https://lkml.kernel.org/r/20200916110118.6537-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-clean-code-by-merging-two-functions
+++ a/mm/page_alloc.c
@@ -4838,12 +4838,6 @@ static inline bool prepare_alloc_pages(g
 
 	*alloc_flags = current_alloc_flags(gfp_mask, *alloc_flags);
 
-	return true;
-}
-
-/* Determine whether to spread dirty pages and what the first usable zone */
-static inline void finalise_ac(gfp_t gfp_mask, struct alloc_context *ac)
-{
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
@@ -4854,6 +4848,8 @@ static inline void finalise_ac(gfp_t gfp
 	 */
 	ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
+
+	return true;
 }
 
 /*
@@ -4882,8 +4878,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
 		return NULL;
 
-	finalise_ac(gfp_mask, &ac);
-
 	/*
 	 * Forbid the first pass from falling back to types that fragment
 	 * memory until all local zones are considered.
_
