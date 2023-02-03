Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4336C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjBCGnz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjBCGmN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA1F2278B
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46CEE61DB0
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0229C4339E;
        Fri,  3 Feb 2023 06:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406307;
        bh=Y3N4k3NibeJpVfYbsAzxMZNqWyD7vRowAoND98Mh/pU=;
        h=Date:To:From:Subject:From;
        b=ZgEMzkE0lL1dDirDxBQ+efBihMBWXemWfBVRN0FJXzmyl6K9NcSKJRvWf79gM5HmP
         FicLLWIGyGlLj9llHH1DIqn/1TYFVk+tCwdnbSt6DtH6O2F6Xe8IiIWU6OF2AcKBni
         Cg5dJLUA0mH1IJJ/bieSxJ7Jhav376jXiQ6TVX+Q=
Date:   Thu, 02 Feb 2023 22:38:27 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-finish-pageblocks-on-complete-migration-failure.patch removed from -mm tree
Message-Id: <20230203063827.A0229C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, compaction: finish pageblocks on complete migration failure
has been removed from the -mm tree.  Its filename was
     mm-compaction-finish-pageblocks-on-complete-migration-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2392,6 +2392,7 @@ compact_zone(struct compact_control *cc,
 			cc->finish_pageblock = true;
 		}
 
+rescan:
 		switch (isolate_migratepages(cc)) {
 		case ISOLATE_ABORT:
 			ret = COMPACT_CONTENDED;
@@ -2434,15 +2435,28 @@ compact_zone(struct compact_control *cc,
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


