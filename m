From: akpm@linux-foundation.org
Subject: + vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch added to -mm tree
Date: Wed, 25 Nov 2009 14:26:36 -0800
Message-ID: <200911252226.nAPMQaLA004360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759305AbZKYW05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 17:26:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, mangoo@wpkg.org


The patch titled
     vmscan: do not evict inactive pages when skipping an active list scan
has been added to the -mm tree.  Its filename is
     vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch

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
Subject: vmscan: do not evict inactive pages when skipping an active list scan
From: Rik van Riel <riel@redhat.com>

In AIM7 runs, recent kernels start swapping out anonymous pages well
before they should.  This is due to shrink_list falling through to
shrink_inactive_list if !inactive_anon_is_low(zone, sc), when all we
really wanted to do is pre-age some anonymous pages to give them extra
time to be referenced while on the inactive list.

The obvious fix is to make sure that shrink_list does not fall through to
scanning/reclaiming inactive pages when we called it to scan one of the
active lists.

This change should be safe because the loop in shrink_zone ensures that we
will still shrink the anon and file inactive lists whenever we should.

Reported-by: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan
+++ a/mm/vmscan.c
@@ -1472,13 +1472,15 @@ static unsigned long shrink_list(enum lr
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
-		shrink_active_list(nr_to_scan, zone, sc, priority, file);
+	if (lru == LRU_ACTIVE_FILE) {
+		if (inactive_file_is_low(zone, sc))
+		      shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
 
-	if (lru == LRU_ACTIVE_ANON && inactive_anon_is_low(zone, sc)) {
-		shrink_active_list(nr_to_scan, zone, sc, priority, file);
+	if (lru == LRU_ACTIVE_ANON) {
+		if (inactive_file_is_low(zone, sc))
+		      shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
 	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
_

Patches currently in -mm which might be from riel@redhat.com are

mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
ksm-fix-mlockfreed-to-munlocked.patch
vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch

