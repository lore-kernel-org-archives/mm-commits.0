Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212C2C46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjANEkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjANEkf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:40:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A43A9
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:40:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9B3760A27
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169E1C433EF;
        Sat, 14 Jan 2023 04:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673671233;
        bh=YblOFdCeH7rHlC+ePcbPhByJ0aKiTD3tdOCuSpO6+SE=;
        h=Date:To:From:Subject:From;
        b=nocUEyqTS24vf+XNtpt+V3FVjOTJkto8eYUm1h0dd/rwUod5rTIqUwpFaXRBiklJq
         1dGuP/BbInV2xx+QXbYrF1TucyNeSqrO6fJloddB48cPHLBE+TeymdjKbHmnZWC8qm
         DOu18Hwoz1qchsgNNoTpWjVPoD+s3m4m+5hUlwfg=
Date:   Fri, 13 Jan 2023 20:40:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch added to mm-unstable branch
Message-Id: <20230114044033.169E1C433EF@smtp.kernel.org>
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
Date: Fri, 13 Jan 2023 11:12:13 +0000

RT tasks are allowed to dip below the min reserve but ALLOC_HARDER is
typically combined with ALLOC_MIN_RESERVE so RT tasks are a little
unusual.  While there is some justification for allowing RT tasks access
to memory reserves, there is a strong chance that a RT task that is also
under memory pressure is at risk of missing deadlines anyway.  Relax how
much reserves an RT task can access by treating it the same as __GFP_HIGH
allocations.

Note that in a future kernel release that the RT special casing will be
removed.  Hard realtime tasks should be locking down resources in advance
and ensuring enough memory is available.  Even a soft-realtime task like
audio or video live decoding which cannot jitter should be allocating both
memory and any disk space required up-front before the recording starts
instead of relying on reserves.  At best, reserve access will only delay
the problem by a very short interval.

Link: https://lkml.kernel.org/r/20230113111217.14134-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high
+++ a/mm/page_alloc.c
@@ -4865,7 +4865,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
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
mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves.patch

