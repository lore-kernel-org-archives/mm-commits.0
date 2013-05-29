From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch added to -mm tree
Date: Wed, 29 May 2013 12:48:22 -0700
Message-ID: <51a65b86.PO8iDeHRMwmTZQLl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab3E2TsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 15:48:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de

Subject: + mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch added to -mm tree
To: mgorman@suse.de
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 12:48:22 -0700


The patch titled
     Subject: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2
has been added to the -mm tree.  Its filename is
     mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
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
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-memmap_init_zone-performance-improvement.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account.patch

