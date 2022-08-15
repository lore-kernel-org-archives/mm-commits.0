Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9059DC25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 01:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiHOBXD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 21:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiHOBXC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 21:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A3612617
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 18:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11E9A60F8D
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 01:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C6CC433C1;
        Mon, 15 Aug 2022 01:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660526580;
        bh=gNCcdU4NNhfk7Z8gYFJaT/sQsKiWDpcAOGP8PcgTtzc=;
        h=Date:To:From:Subject:From;
        b=Ak1NWWDtWYuCVnHKNkltNPLu94JaAhIS69oU1Ix3lR4AHe1Ii8MzxMOASaCuFB1XP
         WsY9HATDcG++ybsOIihLl0L/YxtzheTJHNrTbaEFnj/hLXGr+Yr/sJoZtpuWIUkyza
         B4L0afc81d5nniEJo02pXEgIUlP53uXBMdeEmWQY=
Date:   Sun, 14 Aug 2022 18:22:59 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        zhouchuyi@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch added to mm-unstable branch
Message-Id: <20220815012300.57C6CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix set skip in fast_find_migrateblock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

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
From: Chuyi Zhou <zhouchuyi@bytedance.com>
Subject: mm/compaction: fix set skip in fast_find_migrateblock
Date: Wed, 13 Jul 2022 14:20:09 +0800

When we successfully find a pageblock in fast_find_migrateblock(), the
block will be set skip-flag through set_pageblock_skip().  However, when
entering isolate_migratepages_block(), the whole pageblock will be skipped
due to the branch 'if (!valid_page && IS_ALIGNED(low_pfn,
pageblock_nr_pages))'.  Eventually we will goto isolate_abort and isolate
nothing.  That cause fast_find_migrateblock useless.

In this patch, when we find a suitable pageblock in fast_find_
migrateblock, we do noting but let isolate_migratepages_block to set skip
flag to the pageblock after scan it.  Normally, we would isolate some
pages from the fast-find block.

I use mmtest/thpscale-madvhugepage test it. Here is the result:
                            baseline               patch
Amean     fault-both-1      1331.66 (   0.00%)     1261.04 *   5.30%*
Amean     fault-both-3      1383.95 (   0.00%)     1191.69 *  13.89%*
Amean     fault-both-5      1568.13 (   0.00%)     1445.20 *   7.84%*
Amean     fault-both-7      1819.62 (   0.00%)     1555.13 *  14.54%*
Amean     fault-both-12     1106.96 (   0.00%)     1149.43 *  -3.84%*
Amean     fault-both-18     2196.93 (   0.00%)     1875.77 *  14.62%*
Amean     fault-both-24     2642.69 (   0.00%)     2671.21 *  -1.08%*
Amean     fault-both-30     2901.89 (   0.00%)     2857.32 *   1.54%*
Amean     fault-both-32     3747.00 (   0.00%)     3479.23 *   7.15%*

Link: https://lkml.kernel.org/r/20220713062009.597255-1-zhouchuyi@bytedance.com
Fixes: 70b44595eafe9 ("mm, compaction: use free lists to quickly locate a migration source")
Signed-off-by: zhouchuyi <zhouchuyi@bytedance.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-set-skip-in-fast_find_migrateblock
+++ a/mm/compaction.c
@@ -1853,7 +1853,6 @@ static unsigned long fast_find_migratebl
 					pfn = cc->zone->zone_start_pfn;
 				cc->fast_search_fail = 0;
 				found_block = true;
-				set_pageblock_skip(freepage);
 				break;
 			}
 		}
_

Patches currently in -mm which might be from zhouchuyi@bytedance.com are

mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

