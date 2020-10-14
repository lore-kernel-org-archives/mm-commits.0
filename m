Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44277C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E60A3221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709372;
	bh=yixtMFGN2ak7iYbkaUOGinQk4lUfikXPKwVSo0+osrE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2UNeZRiYknE8nevtRaOWoJohitcpArthX4kXMLTF5s2lWkboYtaY1jvFWJnizy+Tc
	 g6qlxdU1YrjAi85QaW9b3ixbAaKnqag0UoRlzqmfpcKSqVvXxXdVfyJnjGTumqNZQ9
	 Cx54jN7hm12yKCd6XE90jQ+VqrBx/+6nFMRdELZY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgJNVCv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3705206B2;
        Wed, 14 Oct 2020 21:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709370;
        bh=yixtMFGN2ak7iYbkaUOGinQk4lUfikXPKwVSo0+osrE=;
        h=Date:From:To:Subject:From;
        b=OQ4K0C0zFZ8xlxRTokzlUEZctkQrJPzHU2RfZHzbE8Qsqj+2IE5KkEwnLMS3XN+v4
         E6H9uoNciym70QqHzVlGunk/5oCVkefcyNwCf3pMuo4/gZaZKB+H4kw9QpIsEta0gz
         iOnPASMrhkGH+/T7GyXl+MpAb1xuJDZRQIFtK55Y=
Date:   Wed, 14 Oct 2020 14:02:50 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mateusznosek0@gmail.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        rppt@kernel.org
Subject:  [merged]
 mm-page_allocc-clean-code-by-merging-two-functions.patch removed from -mm
 tree
Message-ID: <20201014210250.dF0urk7Hx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: clean code by merging two functions
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-clean-code-by-merging-two-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-page_poisonc-replace-bool-variable-with-static-key.patch

