Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00597C0015E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 17:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjHAR4e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 13:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjHAR4d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 13:56:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AEF2110
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 10:56:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F6C361602
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 17:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BB8C433C7;
        Tue,  1 Aug 2023 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690912590;
        bh=D4N6bFkl6dXDGCGR81Q+DF07bgoxXeliZc5CPxn6icU=;
        h=Date:To:From:Subject:From;
        b=HBVENjX5HeOQ4EDoZznq2xBKi+TTM44ogPZur0Jo0J4tH8josKEsXEhCN3Vywpj00
         eTfDBCpiZAW3+OLByXET8AVdHBlNotiydTTkU5ITtchC9rZ67JysduecLiAt4arqMJ
         PzbT+dLzmuypkNBbYuPLxA8NcjBAXvJih7qYvC/M=
Date:   Tue, 01 Aug 2023 10:56:29 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-endless-looping-over-same-migrate-block.patch added to mm-hotfixes-unstable branch
Message-Id: <20230801175630.71BB8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix endless looping over same migrate block
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-compaction-fix-endless-looping-over-same-migrate-block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-endless-looping-over-same-migrate-block.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: compaction: fix endless looping over same migrate block
Date: Mon, 31 Jul 2023 13:24:50 -0400

During stress testing, the following situation was observed:

     70 root      39  19       0      0      0 R 100.0   0.0 959:29.92 khugepaged
 310936 root      20   0   84416  25620    512 R  99.7   1.5 642:37.22 hugealloc

Tracing shows isolate_migratepages_block() endlessly looping over the
first block in the DMA zone:

       hugealloc-310936  [001] ..... 237297.415718: mm_compaction_finished: node=0 zone=DMA      order=9 ret=no_suitable_page
       hugealloc-310936  [001] ..... 237297.415718: mm_compaction_isolate_migratepages: range=(0x1 ~ 0x400) nr_scanned=513 nr_taken=0
       hugealloc-310936  [001] ..... 237297.415718: mm_compaction_finished: node=0 zone=DMA      order=9 ret=no_suitable_page
       hugealloc-310936  [001] ..... 237297.415718: mm_compaction_isolate_migratepages: range=(0x1 ~ 0x400) nr_scanned=513 nr_taken=0
       hugealloc-310936  [001] ..... 237297.415718: mm_compaction_finished: node=0 zone=DMA      order=9 ret=no_suitable_page
       hugealloc-310936  [001] ..... 237297.415718: mm_compaction_isolate_migratepages: range=(0x1 ~ 0x400) nr_scanned=513 nr_taken=0
       hugealloc-310936  [001] ..... 237297.415718: mm_compaction_finished: node=0 zone=DMA      order=9 ret=no_suitable_page
       hugealloc-310936  [001] ..... 237297.415718: mm_compaction_isolate_migratepages: range=(0x1 ~ 0x400) nr_scanned=513 nr_taken=0

The problem is that the functions tries to test and set the skip bit once
on the block, to avoid skipping on its own skip-set, using
pageblock_aligned() on the pfn as a test.  But because this is the DMA
zone which starts at pfn 1, this is never true for the first block, and
the skip bit isn't set or tested at all.  As a result,
fast_find_migrateblock() returns the same pageblock over and over.

If the pfn isn't pageblock-aligned, also check if it's the start of the
zone to ensure test-and-set-exactly-once on unaligned ranges.

Thanks to Vlastimil Babka for the help in debugging this.

Link: https://lkml.kernel.org/r/20230731172450.1632195-1-hannes@cmpxchg.org
Fixes: 90ed667c03fe ("Revert "Revert "mm/compaction: fix set skip in fast_find_migrateblock""")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-endless-looping-over-same-migrate-block
+++ a/mm/compaction.c
@@ -912,11 +912,12 @@ isolate_migratepages_block(struct compac
 
 		/*
 		 * Check if the pageblock has already been marked skipped.
-		 * Only the aligned PFN is checked as the caller isolates
+		 * Only the first PFN is checked as the caller isolates
 		 * COMPACT_CLUSTER_MAX at a time so the second call must
 		 * not falsely conclude that the block should be skipped.
 		 */
-		if (!valid_page && pageblock_aligned(low_pfn)) {
+		if (!valid_page && (pageblock_aligned(low_pfn) ||
+				    low_pfn == cc->zone->zone_start_pfn)) {
 			if (!isolation_suitable(cc, page)) {
 				low_pfn = end_pfn;
 				folio = NULL;
@@ -2002,7 +2003,8 @@ static isolate_migrate_t isolate_migrate
 		 * before making it "skip" so other compaction instances do
 		 * not scan the same block.
 		 */
-		if (pageblock_aligned(low_pfn) &&
+		if ((pageblock_aligned(low_pfn) ||
+		     low_pfn == cc->zone->zone_start_pfn) &&
 		    !fast_find_block && !isolation_suitable(cc, page))
 			continue;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-fix-endless-looping-over-same-migrate-block.patch
mm-kill-frontswap.patch
mm-kill-frontswap-fix.patch
mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch
mm-zswap-tighten-up-entry-invalidation.patch
mm-zswap-kill-zswap_get_swap_cache_page.patch

