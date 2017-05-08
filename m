From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch removed from -mm tree
Date: Mon, 08 May 2017 15:37:03 -0700
Message-ID: <5910f30f.fYS4AkBUiW3KbMK/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40406 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdEHWhE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-split-smallest-stolen-page-in-fallback-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch

This patch was dropped because it was folded into mm-page_alloc-split-smallest-stolen-page-in-fallback.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-page_alloc-split-smallest-stolen-page-in-fallback-fix

The lkp-robot reported a test case stuck on boot due to the patch [1]
which was due to endless loop in the modified __rmqueue().  It blindly
expected that move_freepages_block() will succeed, but that can fail due
to last pageblock pfn not belonging to the same zone as the fallback
candidate page.

This fix checks the result of move_freepages_block() and steals the single
candidate page if it fails, which was also effectively done before [1].

[1] mmotm: mm-page_alloc-split-smallest-stolen-page-in-fallback.patch

Link: http://lkml.kernel.org/r/59d71b35-d556-4fc9-ee2e-1574259282fd@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-split-smallest-stolen-page-in-fallback-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-split-smallest-stolen-page-in-fallback-fix
+++ a/mm/page_alloc.c
@@ -1972,6 +1972,9 @@ static void steal_suitable_fallback(stru
 		goto single_page;
 
 	pages = move_freepages_block(zone, page, start_type);
+	/* moving whole block can fail due to zone boundary conditions */
+	if (!pages)
+		goto single_page;
 
 	/* Claim the whole block if over half of it is free */
 	if (pages >= (1 << (pageblock_order-1)) ||
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch
mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch
mm-introduce-memalloc_noreclaim_saverestore.patch
treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch
treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix.patch
mtd-nand-nandsim-convert-to-memalloc_noreclaim_.patch

