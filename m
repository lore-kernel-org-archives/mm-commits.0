Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F00ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiILD3k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095E827B35
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7C98B80C71
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A14FC433B5;
        Mon, 12 Sep 2022 03:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953324;
        bh=F3ihd9BCynXz8BsSwIz3vOB2GIGHIDSeyfJ7S5ujKMU=;
        h=Date:To:From:Subject:From;
        b=nD+X6T0Vh4k8sIniATlyXtdr2aNiAGfWquEsmp2aTDJGHOYwzvEcOwoK8fMenPCz8
         Vf6ydVPyiLZHPi6gtgoOBSMff7GdJ/XAIUfxO93PRqX2YrkC3nEB8jcwK3+hmNeouY
         koj+dFPPgLoD+GmE2IxZfF2Y+0QjjYhElzwjRbjA=
Date:   Sun, 11 Sep 2022 20:28:43 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, mhocko@kernel.org,
        mgorman@techsingularity.net, wuyun.abel@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-only-search-higher-order-when-fallback.patch removed from -mm tree
Message-Id: <20220912032844.5A14FC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: only search higher order when fallback
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-search-higher-order-when-fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


