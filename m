Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79655CA0ED1
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 02:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbjILCmN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239516AbjILCmB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 22:42:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0490107C6F
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 19:07:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C146BC43397;
        Mon, 11 Sep 2023 21:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694466092;
        bh=HU+EIMnbEeI3RO38WfaY6/2MIRkyZq+s/ar693cReu8=;
        h=Date:To:From:Subject:From;
        b=b2vp1GGqjB3541uUzZ8Au5AcvepWzo2MvEfM90M/5knVuMAeTZC1GjmEUPhf36lL0
         KhQfva/M5OgOd6nEkMCf6cyEK8trxIL/V31tA+QYupMC1LXz0tfsvJFFqPiVV4NdiP
         m1nglsjrNHyLiTRuY4FLVIHA8DmEYnDeS3BvF6B8=
Date:   Mon, 11 Sep 2023 14:01:32 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        wangkefeng.wang@huawei.com, vbabka@suse.cz,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-move_freepages_block-range-error.patch added to mm-unstable branch
Message-Id: <20230911210132.C146BC43397@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix move_freepages_block() range error
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-move_freepages_block-range-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-move_freepages_block-range-error.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix move_freepages_block() range error
Date: Mon, 11 Sep 2023 15:41:45 -0400

When a block is partially outside the zone of the cursor page, the
function cuts the range to the pivot page instead of the zone start.  This
can leave large parts of the block behind, which encourages incompatible
page mixing down the line (ask for one type, get another), and thus
long-term fragmentation.

This triggers reliably on the first block in the DMA zone, whose start_pfn
is 1.  The block is stolen, but everything before the pivot page (which
was often hundreds of pages) is left on the old list.

Link: https://lkml.kernel.org/r/20230911195023.247694-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-move_freepages_block-range-error
+++ a/mm/page_alloc.c
@@ -1646,7 +1646,7 @@ int move_freepages_block(struct zone *zo
 
 	/* Do not cross zone boundaries */
 	if (!zone_spans_pfn(zone, start_pfn))
-		start_pfn = pfn;
+		start_pfn = zone->zone_start_pfn;
 	if (!zone_spans_pfn(zone, end_pfn))
 		return 0;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-consolidate-free-page-accounting.patch

