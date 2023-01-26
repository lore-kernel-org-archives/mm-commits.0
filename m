Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216EBC27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbjAZBRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAZBRr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:17:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B95B3A91
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E99A6616F6
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D40CC433D2;
        Thu, 26 Jan 2023 01:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674695864;
        bh=GrPaJpu8vDUk3pjM3e0Z3DeCHkCCNcNuI1mP8PTlrqg=;
        h=Date:To:From:Subject:From;
        b=OHrIK5fMH2fdWbSU13+rmw5jillOK7cpVlcspqOd6tCymsDFqBoMHWTTQnheTHaYR
         q3ajA1fkIfYyAwYJ5QheLYnX+KmzmiUDVcAMZrgLidjbHvAs8OUGKddVgql88rFwj2
         kAGyi0J1W/YJYn9R5rTw0fORGIvsKh5HWt6ZewBw=
Date:   Wed, 25 Jan 2023 17:17:43 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-finish-pageblocks-on-complete-migration-failure.patch added to mm-unstable branch
Message-Id: <20230126011744.4D40CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: finish pageblocks on complete migration failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-finish-pageblocks-on-complete-migration-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-finish-pageblocks-on-complete-migration-failure.patch

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
Subject: mm, compaction: finish pageblocks on complete migration failure
Date: Wed, 25 Jan 2023 13:44:34 +0000

Commit 7efc3b726103 ("mm/compaction: fix set skip in
fast_find_migrateblock") address an issue where a pageblock selected by
fast_find_migrateblock() was ignored.  Unfortunately, the same fix
resulted in numerous reports of khugepaged or kcompactd stalling for long
periods of time or consuming 100% of CPU.

Tracing showed that there was a lot of rescanning between a small subset
of pageblocks because the conditions for marking the block skip are not
met.  The scan is not reaching the end of the pageblock because enough
pages were isolated but none were migrated successfully.  Eventually it
circles back to the same block.

Pageblock skip tracking tries to minimise both latency and excessive
scanning but tracking exactly when a block is fully scanned requires an
excessive amount of state.  This patch forcibly rescans a pageblock when
all isolated pages fail to migrate even though it could be for transient
reasons such as page writeback or page dirty.  This will sometimes migrate
too many pages but pageblocks will be marked skip and forward progress
will be made.

"Usemen" from the mmtests configuration
workload-usemem-stress-numa-compact was used to stress compaction.  The
compaction trace events were recorded using a 6.2-rc5 kernel that includes
commit 7efc3b726103 and count of unique ranges were measured.  The top 5
ranges were

   3076 range=(0x10ca00-0x10cc00)
   3076 range=(0x110a00-0x110c00)
   3098 range=(0x13b600-0x13b800)
   3104 range=(0x141c00-0x141e00)
  11424 range=(0x11b600-0x11b800)

While this workload is very different than what the bugs reported, the
pattern of the same subset of blocks being repeatedly scanned is observed.
At one point, *only* the range range=(0x11b600 ~ 0x11b800) was scanned
for 2 seconds.  14 seconds passed between the first migration-related
event and the last.

With the series applied including this patch, the top 5 ranges were

      1 range=(0x11607e-0x116200)
      1 range=(0x116200-0x116278)
      1 range=(0x116278-0x116400)
      1 range=(0x116400-0x116424)
      1 range=(0x116424-0x116600)

Only unique ranges were scanned and the time between the first
migration-related event was 0.11 milliseconds.

Link: https://lkml.kernel.org/r/20230125134434.18017-5-mgorman@techsingularity.net
Fixes: 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-finish-pageblocks-on-complete-migration-failure
+++ a/mm/compaction.c
@@ -2393,6 +2393,7 @@ compact_zone(struct compact_control *cc,
 			cc->finish_pageblock = true;
 		}
 
+rescan:
 		switch (isolate_migratepages(cc)) {
 		case ISOLATE_ABORT:
 			ret = COMPACT_CONTENDED;
@@ -2435,15 +2436,28 @@ compact_zone(struct compact_control *cc,
 				goto out;
 			}
 			/*
-			 * We failed to migrate at least one page in the current
-			 * order-aligned block, so skip the rest of it.
+			 * If an ASYNC or SYNC_LIGHT fails to migrate a page
+			 * within the current order-aligned block, scan the
+			 * remainder of the pageblock. This will mark the
+			 * pageblock "skip" to avoid rescanning in the near
+			 * future. This will isolate more pages than necessary
+			 * for the request but avoid loops due to
+			 * fast_find_migrateblock revisiting blocks that were
+			 * recently partially scanned.
 			 */
-			if (cc->direct_compaction &&
-						(cc->mode == MIGRATE_ASYNC)) {
-				cc->migrate_pfn = block_end_pfn(
-						cc->migrate_pfn - 1, cc->order);
-				/* Draining pcplists is useless in this case */
-				last_migrated_pfn = 0;
+			if (cc->direct_compaction && !cc->finish_pageblock &&
+						(cc->mode < MIGRATE_SYNC)) {
+				cc->finish_pageblock = true;
+
+				/*
+				 * Draining pcplists does not help THP if
+				 * any page failed to migrate. Even after
+				 * drain, the pageblock will not be free.
+				 */
+				if (cc->order == COMPACTION_HPAGE_ORDER)
+					last_migrated_pfn = 0;
+
+				goto rescan;
 			}
 		}
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves.patch
mm-compaction-rename-compact_control-rescan-to-finish_pageblock.patch
mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages.patch
mm-compaction-finish-scanning-the-current-pageblock-if-requested.patch
mm-compaction-finish-pageblocks-on-complete-migration-failure.patch

