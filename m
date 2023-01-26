Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15075C27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjAZBRl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAZBRk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:17:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DAD45BC4
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:17:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 298AC61715
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74009C4339B;
        Thu, 26 Jan 2023 01:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674695858;
        bh=Jzh3PuORQ55mls8PFKF16ElRdMZeq0j+owoVE1XBJOc=;
        h=Date:To:From:Subject:From;
        b=oJa4Wsgww0PX3f2mOMAtklypXsfdjvZj6rwGa6ycRDV4Q47wRkn3Y1W8gb0023Njl
         rVj27potrZdKDhstDhWdn5mFtASSU/gSz2Le4Q3Ah17dvZ+VTEaB+urPWCMrW5dpm9
         RAyzIucyWrp4mCRcnl/F1S2yq+3Xuw7W5tFTaThM=
Date:   Wed, 25 Jan 2023 17:17:37 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-rename-compact_control-rescan-to-finish_pageblock.patch added to mm-unstable branch
Message-Id: <20230126011738.74009C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: rename compact_control->rescan to finish_pageblock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-rename-compact_control-rescan-to-finish_pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-rename-compact_control-rescan-to-finish_pageblock.patch

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
Subject: mm, compaction: rename compact_control->rescan to finish_pageblock
Date: Wed, 25 Jan 2023 13:44:31 +0000

Patch series "Fix excessive CPU usage during compaction".

Commit 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
fixed a problem where pageblocks found by fast_find_migrateblock() were
ignored. Unfortunately there were numerous bug reports complaining about high
CPU usage and massive stalls once 6.1 was released. Due to the severity,
the patch was reverted by Vlastimil as a short-term fix[1] to -stable.		

The underlying problem for each of the bugs is suspected to be the
repeated scanning of the same pageblocks.  This series should guarantee
forward progress even with commit 7efc3b726103.  More information is in
the changelog for patch 4.

[1] http://lore.kernel.org/r/20230113173345.9692-1-vbabka@suse.cz


This patch (of 4):

The rescan field was not well named albeit accurate at the time.  Rename
the field to finish_pageblock to indicate that the remainder of the
pageblock should be scanned regardless of COMPACT_CLUSTER_MAX.  The intent
is that pageblocks with transient failures get marked for skipping to
avoid revisiting the same pageblock.

Link: https://lkml.kernel.org/r/20230125134434.18017-2-mgorman@techsingularity.net
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


--- a/mm/compaction.c~mm-compaction-rename-compact_control-rescan-to-finish_pageblock
+++ a/mm/compaction.c
@@ -1101,12 +1101,12 @@ isolate_success_no_list:
 
 		/*
 		 * Avoid isolating too much unless this block is being
-		 * rescanned (e.g. dirty/writeback pages, parallel allocation)
+		 * fully scanned (e.g. dirty/writeback pages, parallel allocation)
 		 * or a lock is contended. For contention, isolate quickly to
 		 * potentially remove one source of contention.
 		 */
 		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX &&
-		    !cc->rescan && !cc->contended) {
+		    !cc->finish_pageblock && !cc->contended) {
 			++low_pfn;
 			break;
 		}
@@ -1171,14 +1171,14 @@ isolate_abort:
 	}
 
 	/*
-	 * Updated the cached scanner pfn once the pageblock has been scanned
+	 * Update the cached scanner pfn once the pageblock has been scanned.
 	 * Pages will either be migrated in which case there is no point
 	 * scanning in the near future or migration failed in which case the
 	 * failure reason may persist. The block is marked for skipping if
 	 * there were no pages isolated in the block or if the block is
 	 * rescanned twice in a row.
 	 */
-	if (low_pfn == end_pfn && (!nr_isolated || cc->rescan)) {
+	if (low_pfn == end_pfn && (!nr_isolated || cc->finish_pageblock)) {
 		if (valid_page && !skip_updated)
 			set_pageblock_skip(valid_page);
 		update_cached_migrate(cc, low_pfn);
@@ -2373,17 +2373,17 @@ compact_zone(struct compact_control *cc,
 		unsigned long iteration_start_pfn = cc->migrate_pfn;
 
 		/*
-		 * Avoid multiple rescans which can happen if a page cannot be
-		 * isolated (dirty/writeback in async mode) or if the migrated
-		 * pages are being allocated before the pageblock is cleared.
-		 * The first rescan will capture the entire pageblock for
-		 * migration. If it fails, it'll be marked skip and scanning
-		 * will proceed as normal.
+		 * Avoid multiple rescans of the same pageblock which can
+		 * happen if a page cannot be isolated (dirty/writeback in
+		 * async mode) or if the migrated pages are being allocated
+		 * before the pageblock is cleared.  The first rescan will
+		 * capture the entire pageblock for migration. If it fails,
+		 * it'll be marked skip and scanning will proceed as normal.
 		 */
-		cc->rescan = false;
+		cc->finish_pageblock = false;
 		if (pageblock_start_pfn(last_migrated_pfn) ==
 		    pageblock_start_pfn(iteration_start_pfn)) {
-			cc->rescan = true;
+			cc->finish_pageblock = true;
 		}
 
 		switch (isolate_migratepages(cc)) {
--- a/mm/internal.h~mm-compaction-rename-compact_control-rescan-to-finish_pageblock
+++ a/mm/internal.h
@@ -448,7 +448,11 @@ struct compact_control {
 	bool proactive_compaction;	/* kcompactd proactive compaction */
 	bool whole_zone;		/* Whole zone should/has been scanned */
 	bool contended;			/* Signal lock contention */
-	bool rescan;			/* Rescanning the same pageblock */
+	bool finish_pageblock;		/* Scan the remainder of a pageblock. Used
+					 * when there are potentially transient
+					 * isolation or migration failures to
+					 * ensure forward progress.
+					 */
 	bool alloc_contig;		/* alloc_contig_range allocation */
 };
 
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

