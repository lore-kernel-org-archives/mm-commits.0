From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch added to -mm tree
Date: Mon, 20 May 2013 13:58:48 -0700
Message-ID: <519a8e88.lsCvQA1R6vyuvOxw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab3ETU6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 16:58:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: + mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch added to -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 13:58:48 -0700


The patch titled
     Subject: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch

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
Subject: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix

Historically, kswapd used to congestion_wait() at higher priorities if it
was not making forward progress. This made no sense as the failure to make
progress could be completely independent of IO. It was later replaced by
wait_iff_congested() and removed entirely by commit 258401a6 (mm: don't
wait on congested zones in balance_pgdat()) as it was duplicating logic
in shrink_inactive_list().

This is problematic. If kswapd encounters many pages under writeback and
it continues to scan until it reaches the high watermark then it will
quickly skip over the pages under writeback and reclaim clean young
pages or push applications out to swap.

The use of wait_iff_congested() is not suited to kswapd as it will only
stall if the underlying BDI is really congested or a direct reclaimer was
unable to write to the underlying BDI. kswapd bypasses the BDI congestion
as it sets PF_SWAPWRITE but even if this was taken into account then it
would cause direct reclaimers to stall on writeback which is not desirable.

This patch sets a ZONE_WRITEBACK flag if direct reclaim or kswapd is
encountering too many pages under writeback. If this flag is set and
kswapd encounters a PageReclaim page under writeback then it'll assume
that the LRU lists are being recycled too quickly before IO can complete
and block waiting for some IO to complete.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix
+++ a/mm/vmscan.c
@@ -732,9 +732,11 @@ static unsigned long shrink_page_list(st
 		 *    under writeback and this page is both under writeback and
 		 *    PageReclaim then it indicates that pages are being queued
 		 *    for IO but are being recycled through the LRU before the
-		 *    IO can complete. In this case, wait on the IO to complete
-		 *    and then clear the ZONE_WRITEBACK flag to recheck if the
-		 *    condition exists.
+		 *    IO can complete. Waiting on the page itself risks an
+		 *    indefinite stall if it is impossible to writeback the
+		 *    page due to IO error or disconnected storage so instead
+		 *    block for HZ/10 or until some IO completes then clear the
+		 *    ZONE_WRITEBACK flag to recheck if the condition exists.
 		 *
 		 * 2) Global reclaim encounters a page, memcg encounters a
 		 *    page that is not marked for immediate reclaim or
@@ -764,7 +766,7 @@ static unsigned long shrink_page_list(st
 			if (current_is_kswapd() &&
 			    PageReclaim(page) &&
 			    zone_is_reclaim_writeback(zone)) {
-				wait_on_page_writeback(page);
+				congestion_wait(BLK_RW_ASYNC, HZ/10);
 				zone_clear_flag(zone, ZONE_WRITEBACK);
 
 			/* Case 2 above */
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch
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
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-memmap_init_zone-performance-improvement.patch

