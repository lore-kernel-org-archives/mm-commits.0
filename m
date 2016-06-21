From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch added
 to -mm tree
Date: Tue, 21 Jun 2016 15:50:02 -0700
Message-ID: <5769c49a.7vk4WSJ/ftNUE67+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbcFUWuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 18:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: cache the last node whose dirty limit is reached
has been added to the -mm tree.  Its filename is
     mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: page_alloc: cache the last node whose dirty limit is reached

If a page is about to be dirtied then the page allocator attempts to limit
the total number of dirty pages that exists in any given zone.  The call
to node_dirty_ok is expensive so this patch records if the last pgdat
examined hit the dirty limits.  In some cases, this reduces the number of
calls to node_dirty_ok().

Link: http://lkml.kernel.org/r/1466518566-30034-26-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached
+++ a/mm/page_alloc.c
@@ -2855,6 +2855,8 @@ get_page_from_freelist(gfp_t gfp_mask, u
 {
 	struct zoneref *z = ac->preferred_zoneref;
 	struct zone *zone;
+	struct pglist_data *last_pgdat_dirty_limit = NULL;
+
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
@@ -2887,8 +2889,15 @@ get_page_from_freelist(gfp_t gfp_mask, u
 		 * will require awareness of nodes in the
 		 * dirty-throttling and the flusher threads.
 		 */
-		if (ac->spread_dirty_pages && !node_dirty_ok(zone->zone_pgdat))
-			continue;
+		if (ac->spread_dirty_pages) {
+			if (last_pgdat_dirty_limit == zone->zone_pgdat)
+				continue;
+
+			if (!node_dirty_ok(zone->zone_pgdat)) {
+				last_pgdat_dirty_limit = zone->zone_pgdat;
+				continue;
+			}
+		}
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 		if (!zone_watermark_fast(zone, order, mark,
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-update-classzone_idx-if-buffer_heads_over_limit.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch

