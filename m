From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:12 -0700
Message-ID: <20120322201812.A7727A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33403 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2CVUSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, riel@redhat.com, smf.linux@ntlworld.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: forcibly scan highmem if there are too many buffer_heads pinning highmem
has been removed from the -mm tree.  Its filename was
     mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mel@csn.ul.ie>
Subject: mm: vmscan: forcibly scan highmem if there are too many buffer_heads pinning highmem

Stuart Foster reported on https://bugzilla.kernel.org/show_bug.cgi?id=42578
that copying large amounts of data from NTFS caused an OOM kill on 32-bit
X86 with 16G of memory. Andrew Morton correctly identified that the problem
was NTFS was using 512 blocks meaning each page had 8 buffer_heads in low
memory pinning it.

In the past, direct reclaim used to scan highmem even if the allocating
process did not specify __GFP_HIGHMEM but not any more.  kswapd no longer
will reclaim from zones that are above the high watermark.  The intention
in both cases was to minimise unnecessary reclaim.  The downside is on
machines with large amounts of highmem that lowmem can be fully consumed
by buffer_heads with nothing trying to free them.

The following patch is based on a suggestion by Andrew Morton to extend
the buffer_heads_over_limit case to force kswapd and direct reclaim to
scan the highmem zone regardless of the allocation request or watermarks.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=42578

[hughd@google.com: move buffer_heads_over_limit check up]
[akpm@linux-foundation.org: buffer_heads_over_limit is unlikely]
Reported-by: Stuart Foster <smf.linux@ntlworld.com>
Tested-by: Stuart Foster <smf.linux@ntlworld.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: stable <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem
+++ a/mm/vmscan.c
@@ -1642,18 +1642,6 @@ static void move_active_pages_to_lru(str
 	unsigned long pgmoved = 0;
 	struct page *page;
 
-	if (buffer_heads_over_limit) {
-		spin_unlock_irq(&zone->lru_lock);
-		list_for_each_entry(page, list, lru) {
-			if (page_has_private(page) && trylock_page(page)) {
-				if (page_has_private(page))
-					try_to_release_page(page, 0);
-				unlock_page(page);
-			}
-		}
-		spin_lock_irq(&zone->lru_lock);
-	}
-
 	while (!list_empty(list)) {
 		struct lruvec *lruvec;
 
@@ -1735,6 +1723,14 @@ static void shrink_active_list(unsigned 
 			continue;
 		}
 
+		if (unlikely(buffer_heads_over_limit)) {
+			if (page_has_private(page) && trylock_page(page)) {
+				if (page_has_private(page))
+					try_to_release_page(page, 0);
+				unlock_page(page);
+			}
+		}
+
 		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
@@ -2238,6 +2234,14 @@ static bool shrink_zones(int priority, s
 	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
 
+	/*
+	 * If the number of buffer_heads in the machine exceeds the maximum
+	 * allowed level, force direct reclaim to scan the highmem zone as
+	 * highmem pages could be pinning lowmem pages storing buffer_heads
+	 */
+	if (buffer_heads_over_limit)
+		sc->gfp_mask |= __GFP_HIGHMEM;
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -2727,6 +2731,17 @@ loop_again:
 			 */
 			age_active_anon(zone, &sc, priority);
 
+			/*
+			 * If the number of buffer_heads in the machine
+			 * exceeds the maximum allowed level and this node
+			 * has a highmem zone, force kswapd to reclaim from
+			 * it to relieve lowmem pressure.
+			 */
+			if (buffer_heads_over_limit && is_highmem_idx(i)) {
+				end_zone = i;
+				break;
+			}
+
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
@@ -2802,7 +2817,8 @@ loop_again:
 						COMPACT_SKIPPED)
 				testorder = 0;
 
-			if (!zone_watermark_ok_safe(zone, testorder,
+			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
+				    !zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone) + balance_gap,
 					end_zone, 0)) {
 				shrink_zone(priority, zone, &sc);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
add-debugging-aid-for-memory-initialisation-problems.patch

