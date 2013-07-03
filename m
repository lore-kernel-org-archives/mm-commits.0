From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:26:16 -0700
Message-ID: <51d496f8.0Bj/wNM+NsfjnxQs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3GCV0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de

Subject: [folded-merged] mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch removed from -mm tree
To: mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:26:16 -0700


The patch titled
     Subject: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2
has been removed from the -mm tree.  Its filename was
     mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch

This patch was dropped because it was folded into mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2

The patch "mm: vmscan: Block kswapd if it is encountering pages under
writeback" stalls in congestion_wait it encounters a page under writeback
that is marked for immediate reclaim.  Initially this was a
wait_on_page_writeback() but after the switch to congestion_wait(), there
is no guarantee the page has completed writeback and it can be placed on a
list for freeing.

This is a fix for
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2
+++ a/mm/vmscan.c
@@ -766,8 +766,10 @@ static unsigned long shrink_page_list(st
 			if (current_is_kswapd() &&
 			    PageReclaim(page) &&
 			    zone_is_reclaim_writeback(zone)) {
+				unlock_page(page);
 				congestion_wait(BLK_RW_ASYNC, HZ/10);
 				zone_clear_flag(zone, ZONE_WRITEBACK);
+				goto keep;
 
 			/* Case 2 above */
 			} else if (global_reclaim(sc) ||
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2.patch
mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch
documentation-update-address_space_operations.patch
documentation-document-the-is_dirty_writeback-aops-callback.patch

