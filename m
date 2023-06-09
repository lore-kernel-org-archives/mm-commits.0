Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDD5C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjFIXb3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjFIXaC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:30:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E2C423B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D89CB6169F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFC2C433D2;
        Fri,  9 Jun 2023 23:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353334;
        bh=lDUoegqy3U1d3vZLqpmA234e/4B6iskSVI4EtxABURA=;
        h=Date:To:From:Subject:From;
        b=CYwKEgLLfCVMvUpZ0B52und393RUzw64HgvnWIbIv2Rk+x9hs+m6i0+nilQHy4VEH
         OU71ylrVVNRtVoGP6PrwJZKq/FTq3REgVfNu8waGN24x4Sx6sL3rNWUi9QoLusyuK0
         LQrjwSyc9Qq1R17xJU342HGeDk7cetKH4Ho0oT8A=
Date:   Fri, 09 Jun 2023 16:28:53 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch removed from -mm tree
Message-Id: <20230609232854.3BFC2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: drop redundant watermark check in compaction_zonelist_suitable()
has been removed from the -mm tree.  Its filename was
     mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: drop redundant watermark check in compaction_zonelist_suitable()
Date: Fri, 19 May 2023 14:39:59 +0200

The watermark check in compaction_zonelist_suitable(), called from
should_compact_retry(), is sandwiched between two watermark checks
already: before, there are freelist attempts as part of direct reclaim and
direct compaction; after, there is a last-minute freelist attempt in
__alloc_pages_may_oom().

The check in compaction_zonelist_suitable() isn't necessary. Kill it.

Link: https://lkml.kernel.org/r/20230519123959.77335-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/compaction.c~mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable
+++ a/mm/compaction.c
@@ -2278,13 +2278,6 @@ bool compaction_zonelist_suitable(struct
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
 				ac->highest_zoneidx, ac->nodemask) {
 		unsigned long available;
-		unsigned long watermark;
-
-		/* Allocation can already succeed, nothing to do */
-		watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
-		if (zone_watermark_ok(zone, order, watermark,
-				      ac->highest_zoneidx, alloc_flags))
-			continue;
 
 		/*
 		 * Do not consider all the reclaimable memory because we do not
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_isolation-write-proper-kerneldoc.patch

