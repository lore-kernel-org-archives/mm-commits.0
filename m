Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3083BC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjBCGnx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjBCGmN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182A01F937
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C77B8B82980
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C38C4339C;
        Fri,  3 Feb 2023 06:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406304;
        bh=vx52mrCrrJNU5QziQBBPt12zMdwjPTAkjVGO3Nzhl7s=;
        h=Date:To:From:Subject:From;
        b=Crj2d/1fXETpPOa6zD8VmkiGJFX/RQurQAH2NRJB2tMIbtgd9EOYieLLYUmQR1jQq
         kxdhzUYGhqQgQJbfXZMgcbwlfS/qPRRJHzWBIMPTkB5dUIlmnDBZm0GJudrsOeRMKp
         LyshgtAbypQk9HniZM1LZxS4sx6kcL1+EuC4/4GE=
Date:   Thu, 02 Feb 2023 22:38:23 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-rename-compact_control-rescan-to-finish_pageblock.patch removed from -mm tree
Message-Id: <20230203063824.72C38C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, compaction: rename compact_control->rescan to finish_pageblock
has been removed from the -mm tree.  Its filename was
     mm-compaction-rename-compact_control-rescan-to-finish_pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2372,17 +2372,17 @@ compact_zone(struct compact_control *cc,
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


