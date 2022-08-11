Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D6FC19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 22:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiHKWHY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 18:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiHKWHX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 18:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD43B45F73
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 15:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49175614A3
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 22:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A9DC433C1;
        Thu, 11 Aug 2022 22:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660255641;
        bh=vJYQ1Zy7zOI+wUa/za1ZjC+1OsTAmZDuoK5QdN4HRCI=;
        h=Date:To:From:Subject:From;
        b=cDu1u4mXftlYp7oQ4ZWLx3S4FsyPHZoaA1yTw9gvyWBgJXKh2G8s9/gthRQR+kJcq
         16znLG6cBduWq2+e3Pg5II+eTnVUC4rUYQTU/14kmfLIOWKzFriawaOx97Q7D12svt
         E0u9KR9830y1CR2W0vrOace1tGKDggtjkJLvnCwE=
Date:   Thu, 11 Aug 2022 15:07:20 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, mhocko@kernel.org,
        mgorman@techsingularity.net, wuyun.abel@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-only-search-higher-order-when-fallback.patch added to mm-unstable branch
Message-Id: <20220811220721.91A9DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: only search higher order when fallback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-only-search-higher-order-when-fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-only-search-higher-order-when-fallback.patch

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
From: Abel Wu <wuyun.abel@bytedance.com>
Subject: mm/page_alloc: only search higher order when fallback
Date: Wed, 3 Aug 2022 10:51:21 +0800

It seems unnecessary to search pages with order < alloc_order in
fallback allocation.

This can currently happen with ALLOC_NOFRAGMENT and alloc_order >
pageblock_order, so add a test to prevent it.

[vbabka@suse.cz: changelog addition]
Link: https://lkml.kernel.org/r/20220803025121.47018-1-wuyun.abel@bytedance.com
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-search-higher-order-when-fallback
+++ a/mm/page_alloc.c
@@ -3010,7 +3010,7 @@ __rmqueue_fallback(struct zone *zone, in
 	 * i.e. orders < pageblock_order. If there are no local zones free,
 	 * the zonelists will be reiterated without ALLOC_NOFRAGMENT.
 	 */
-	if (alloc_flags & ALLOC_NOFRAGMENT)
+	if (order < pageblock_order && alloc_flags & ALLOC_NOFRAGMENT)
 		min_order = pageblock_order;
 
 	/*
_

Patches currently in -mm which might be from wuyun.abel@bytedance.com are

mm-mempolicy-fix-lock-contention-on-mems_allowed.patch
mm-page_alloc-only-search-higher-order-when-fallback.patch

