Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8EAC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjBCGkO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjBCGjW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348DF8CA8D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E65A1B82984
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7F8C433D2;
        Fri,  3 Feb 2023 06:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406216;
        bh=MOM70FsjluOP5021JQtCo/xpWOcRte6WYw/T9zNUbKA=;
        h=Date:To:From:Subject:From;
        b=A1c40BKxCkKnf3VJlkM+J5+9sHKAVjq/kgS51e517ScpqoubASOSZ5txHbMsnNd6d
         HXlLerCMSylW2vcRV9K03QVK1/7BDjsY+6vUptZ+aMUtBVzB+jUZDzMYbHIbBWwxTp
         gYPtrqqLO2qirx8rqZfMhrUOKjokSuCRLVUcnHhw=
Date:   Thu, 02 Feb 2023 22:36:55 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch removed from -mm tree
Message-Id: <20230203063656.8B7F8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: treat RT tasks similar to __GFP_HIGH
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


