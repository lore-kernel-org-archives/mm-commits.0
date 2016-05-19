From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks-fix.patch
 removed from -mm tree
Date: Thu, 19 May 2016 16:53:33 -0700
Message-ID: <573e51fd.8zyI31mYdZ+NOqkS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbcESXxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: Check once if a zone has isolated pageblocks -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks-fix.patch

This patch was dropped because it was folded into mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: Check once if a zone has isolated pageblocks -fix

Vlastimil Babka pointed out that the original code was protected by
the zone lock and provided a fix.

This is a fix to the mmotm patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch . Once
applied the following line should be removed from the changelog "Technically
this is race-prone but so is the existing code."

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks-fix
+++ a/mm/page_alloc.c
@@ -831,9 +831,10 @@ static void free_pcppages_bulk(struct zo
 	int batch_free = 0;
 	int to_free = count;
 	unsigned long nr_scanned;
-	bool isolated_pageblocks = has_isolate_pageblock(zone);
+	bool isolated_pageblocks;
 
 	spin_lock(&zone->lock);
+	isolated_pageblocks = has_isolate_pageblock(zone);
 	nr_scanned = zone_page_state(zone, NR_PAGES_SCANNED);
 	if (nr_scanned)
 		__mod_zone_page_state(zone, NR_PAGES_SCANNED, -nr_scanned);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch
mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch
mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed.patch

