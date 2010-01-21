From: akpm@linux-foundation.org
Subject: [merged] vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:52 -0800
Message-ID: <201001212127.o0LLRqrM030677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329Ab0AUV2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, will.newton@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: kswapd: don't retry balance_pgdat() if all zones are unreclaimable
has been removed from the -mm tree.  Its filename was
     vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: kswapd: don't retry balance_pgdat() if all zones are unreclaimable
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Commit f50de2d3 (vmscan: have kswapd sleep for a short interval and double
check it should be asleep) can cause kswapd to enter an infinite loop if
running on a single-CPU system.  If all zones are unreclaimble,
sleeping_prematurely return 1 and kswapd will call balance_pgdat() again. 
but it's totally meaningless, balance_pgdat() doesn't anything against
unreclaimable zone!

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reported-by: Will Newton <will.newton@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Tested-by: Will Newton <will.newton@gmail.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmscan.c~vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable
+++ a/mm/vmscan.c
@@ -1922,6 +1922,9 @@ static int sleeping_prematurely(pg_data_
 		if (!populated_zone(zone))
 			continue;
 
+		if (zone_is_all_unreclaimable(zone))
+			continue;
+
 		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
 								0, 0))
 			return 1;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
vmstat-add-anon_scan_ratio-field-to-zoneinfo.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-fix-mbind-vma-merge-problem.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

