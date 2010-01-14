From: akpm@linux-foundation.org
Subject: + vmscan-get_scan_ratio-cleanup.patch added to -mm tree
Date: Wed, 13 Jan 2010 17:23:51 -0800
Message-ID: <201001140123.o0E1Np2q007997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922Ab0ANBYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 20:24:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: get_scan_ratio() cleanup
has been added to the -mm tree.  Its filename is
     vmscan-get_scan_ratio-cleanup.patch

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
Subject: vmscan: get_scan_ratio() cleanup
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The get_scan_ratio() should have all scan-ratio related calculations. 
Thus, this patch move some calculation into get_scan_ratio.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~vmscan-get_scan_ratio-cleanup mm/vmscan.c
--- a/mm/vmscan.c~vmscan-get_scan_ratio-cleanup
+++ a/mm/vmscan.c
@@ -1501,6 +1501,13 @@ static void get_scan_ratio(struct zone *
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+		percent[0] = 0;
+		percent[1] = 100;
+		return;
+	}
+
 	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
 		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
@@ -1598,22 +1605,20 @@ static void shrink_zone(int priority, st
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
-	int noswap = 0;
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		noswap = 1;
-		percent[0] = 0;
-		percent[1] = 100;
-	} else
-		get_scan_ratio(zone, sc, percent);
+	get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
 		unsigned long scan;
 
+		if (percent[file] == 0) {
+			nr[l] = 0;
+			continue;
+		}
+
 		scan = zone_nr_lru_pages(zone, sc, l);
-		if (priority || noswap) {
+		if (priority) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-page_alloc-fix-the-range-check-for-backward-merging.patch
vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch
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
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

