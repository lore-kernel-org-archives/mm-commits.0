From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-split-off-flag-for-not-updating-skip-hints.patch removed from
 -mm tree
Date: Mon, 20 Nov 2017 13:22:55 -0800
Message-ID: <20171120212255.VM0p_wB0W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbdKTVW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:22:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, vbabka@suse.cz


The patch titled
     Subject: mm, compaction: split off flag for not updating skip hints
has been removed from the -mm tree.  Its filename was
     mm-compaction-split-off-flag-for-not-updating-skip-hints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: split off flag for not updating skip hints

Pageblock skip hints were added as a heuristic for compaction, which
shares core code with CMA.  Since CMA reliability would suffer from the
heuristics, compact_control flag ignore_skip_hint was added for the CMA
use case.  Since 6815bf3f233e ("mm/compaction: respect ignore_skip_hint in
update_pageblock_skip") the flag also means that CMA won't *update* the
skip hints in addition to ignoring them.

Today, direct compaction can also ignore the skip hints in the last resort
attempt, but there's no reason not to set them when isolation fails in
such case.  Thus, this patch splits off a new no_set_skip_hint flag to
avoid the updating, which only CMA sets.  This should improve the
heuristics a bit, and allow us to simplify the persistent skip bit
handling as the next step.

Link: http://lkml.kernel.org/r/20171102121706.21504-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 mm/internal.h   |    1 +
 mm/page_alloc.c |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-split-off-flag-for-not-updating-skip-hints mm/compaction.c
--- a/mm/compaction.c~mm-compaction-split-off-flag-for-not-updating-skip-hints
+++ a/mm/compaction.c
@@ -295,7 +295,7 @@ static void update_pageblock_skip(struct
 	struct zone *zone = cc->zone;
 	unsigned long pfn;
 
-	if (cc->ignore_skip_hint)
+	if (cc->no_set_skip_hint)
 		return;
 
 	if (!page)
diff -puN mm/internal.h~mm-compaction-split-off-flag-for-not-updating-skip-hints mm/internal.h
--- a/mm/internal.h~mm-compaction-split-off-flag-for-not-updating-skip-hints
+++ a/mm/internal.h
@@ -198,6 +198,7 @@ struct compact_control {
 	const int classzone_idx;	/* zone index of a direct compactor */
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
+	bool no_set_skip_hint;		/* Don't mark blocks for skipping */
 	bool ignore_block_suitable;	/* Scan blocks considered unsuitable */
 	bool direct_compaction;		/* False from kcompactd or /proc/... */
 	bool whole_zone;		/* Whole zone should/has been scanned */
diff -puN mm/page_alloc.c~mm-compaction-split-off-flag-for-not-updating-skip-hints mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-split-off-flag-for-not-updating-skip-hints
+++ a/mm/page_alloc.c
@@ -7619,6 +7619,7 @@ int alloc_contig_range(unsigned long sta
 		.zone = page_zone(pfn_to_page(start)),
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
+		.no_set_skip_hint = true,
 		.gfp_mask = current_gfp_context(gfp_mask),
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
_

Patches currently in -mm which might be from vbabka@suse.cz are


