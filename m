From: akpm@linux-foundation.org
Subject: [merged] page-allocator-always-change-pageblock-ownership-when-anti-fragmentation-is-disabled.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:07 -0700
Message-ID: <200909082126.n88LQ7gc006376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbZIHV0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:26:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, dhowells@redhat.com, gerg@snapgear.com, lethal@linux-sh.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     page-allocator: always change pageblock ownership when anti-fragmentation is disabled
has been removed from the -mm tree.  Its filename was
     page-allocator-always-change-pageblock-ownership-when-anti-fragmentation-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: always change pageblock ownership when anti-fragmentation is disabled
From: Mel Gorman <mel@csn.ul.ie>

On low-memory systems, anti-fragmentation gets disabled as fragmentation
cannot be avoided on a sufficiently large boundary to be worthwhile.  Once
disabled, there is a period of time when all the pageblocks are marked
MOVABLE and the expectation is that they get marked UNMOVABLE at each call
to __rmqueue_fallback().

However, when MAX_ORDER is large the pageblocks do not change ownership
because the normal criteria are not met.  This has the effect of
prematurely breaking up too many large contiguous blocks.  This is most
serious on NOMMU systems which depend on high-order allocations to boot. 
This patch causes pageblocks to change ownership on every fallback when
anti-fragmentation is disabled.  This prevents the large blocks being
prematurely broken up.

This is a fix to commit 49255c619fbd482d704289b5eb2795f8e3b7ff2e [page
allocator: move check for disabled anti-fragmentation out of fastpath] and
the problem affects 2.6.31-rc8.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-always-change-pageblock-ownership-when-anti-fragmentation-is-disabled mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-always-change-pageblock-ownership-when-anti-fragmentation-is-disabled
+++ a/mm/page_alloc.c
@@ -817,13 +817,15 @@ __rmqueue_fallback(struct zone *zone, in
 			 * agressive about taking ownership of free pages
 			 */
 			if (unlikely(current_order >= (pageblock_order >> 1)) ||
-					start_migratetype == MIGRATE_RECLAIMABLE) {
+					start_migratetype == MIGRATE_RECLAIMABLE ||
+					page_group_by_mobility_disabled) {
 				unsigned long pages;
 				pages = move_freepages_block(zone, page,
 								start_migratetype);
 
 				/* Claim the whole block if over half of it is free */
-				if (pages >= (1 << (pageblock_order-1)))
+				if (pages >= (1 << (pageblock_order-1)) ||
+						page_group_by_mobility_disabled)
 					set_pageblock_migratetype(page,
 								start_migratetype);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
page-allocator-remove-dead-function-free_cold_page.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
mm-drop-unneeded-double-negations.patch
page-allocator-limit-the-number-of-migrate_reserve-pageblocks-per-zone.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
page-allocator-split-per-cpu-list-into-one-list-per-migrate-type.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

