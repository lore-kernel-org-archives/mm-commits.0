From: akpm@linux-foundation.org
Subject: + vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch added to -mm tree
Date: Tue, 12 Jan 2010 14:20:47 -0800
Message-ID: <201001122220.o0CMKlbp031107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab0ALWU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 17:20:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, will.newton@gmail.com


The patch titled
     vmscan: kswapd: don't retry balance_pgdat() if all zones are unreclaimable
has been added to the -mm tree.  Its filename is
     vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-page_alloc-fix-the-range-check-for-backward-merging.patch
vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

