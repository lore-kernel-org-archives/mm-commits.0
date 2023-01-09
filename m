Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5537C63797
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbjAIXpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238070AbjAIXok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:44:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418C3120BB
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:44:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD14A61494
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FECC433F1;
        Mon,  9 Jan 2023 23:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673307878;
        bh=H7aYGjgEbY0M1wsz7TWItYWvL9Zq24xqRAuXMljQ1qo=;
        h=Date:To:From:Subject:From;
        b=yjkUhbvliR5NtwaKBGBDklzvxhVWux+xxtqCTi813/Nt2/DHW+Wp2N+sTYbk5Io0y
         HeyfEmbgF5CFK/0DdXeTxloN5nkIfOqAdmRbKbJfGbmn0TkUh3Y3jwTWW/INFhuIp1
         EVonZ/8A+BFbYo7zPD9jD4Rnhp0Ja924wFAJ8NM8=
Date:   Mon, 09 Jan 2023 15:44:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch added to mm-unstable branch
Message-Id: <20230109234438.06FECC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: treat RT tasks similar to __GFP_HIGH
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: treat RT tasks similar to __GFP_HIGH
Date: Mon, 9 Jan 2023 15:16:26 +0000

RT tasks are allowed to dip below the min reserve but ALLOC_HARDER is
typically combined with ALLOC_MIN_RESERVE so RT tasks are a little
unusual.  While there is some justification for allowing RT tasks access
to memory reserves, there is a strong chance that a RT task that is also
under memory pressure is at risk of missing deadlines anyway.  Relax how
much reserves an RT task can access by treating it the same as __GFP_HIGH
allocations.

Link: https://lkml.kernel.org/r/20230109151631.24923-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high
+++ a/mm/page_alloc.c
@@ -4862,7 +4862,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
 	} else if (unlikely(rt_task(current)) && in_task())
-		alloc_flags |= ALLOC_HARDER;
+		alloc_flags |= ALLOC_MIN_RESERVE;
 
 	alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, alloc_flags);
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves.patch
mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves.patch

