From: akpm@linux-foundation.org
Subject: + mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch added to -mm tree
Date: Thu, 24 Feb 2011 13:23:01 -0800
Message-ID: <201102242123.p1OLN2Cu027312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756563Ab1BXVXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 16:23:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, riel@redhat.com, shaohua.li@intel.com, tim.c.chen@intel.com


The patch titled
     mm: vmscan: kswapd should not free an excessive number of pages when balancing small zones
has been added to the -mm tree.  Its filename is
     mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch

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
Subject: mm: vmscan: kswapd should not free an excessive number of pages when balancing small zones
From: Mel Gorman <mel@csn.ul.ie>

When reclaiming for order-0 pages, kswapd requires that all zones be
balanced.  Each cycle through balance_pgdat() does background ageing on
all zones if necessary and applies equal pressure on the inactive zone
unless a lot of pages are free already.

A "lot of free pages" is defined as a "balance gap" above the high
watermark which is currently 7*high_watermark.  Historically this was
reasonable as min_free_kbytes was small.  However, on systems using huge
pages, it is recommended that min_free_kbytes is higher and it is tuned
with hugeadm --set-recommended-min_free_kbytes.  With the introduction of
transparent huge page support, this recommended value is also applied.  On
X86-64 with 4G of memory, min_free_kbytes becomes 67584 so one would
expect around 68M of memory to be free.  The Normal zone is approximately
35000 pages so under even normal memory pressure such as copying a large
file, it gets exhausted quickly.  As it is getting exhausted, kswapd
applies pressure equally to all zones, including the DMA32 zone.  DMA32 is
approximately 700,000 pages with a high watermark of around 23,000 pages. 
In this situation, kswapd will reclaim around (23000*8 where 8 is the high
watermark + balance gap of 7 * high watermark) pages or 718M of pages
before the zone is ignored.  What the user sees is that free memory far
higher than it should be.

To avoid an excessive number of pages being reclaimed from the larger
zones, explicitely defines the "balance gap" to be either 1% of the zone
or the low watermark for the zone, whichever is smaller.  While kswapd
will check all zones to apply pressure, it'll ignore zones that meets the
(high_wmark + balance_gap) watermark.

To test this, 80G were copied from a partition and the amount of memory
being used was recorded.  A comparison of a patch and unpatched kernel can
be seen at
http://www.csn.ul.ie/~mel/postings/minfree-20110222/memory-usage-hydra.ps
and shows that kswapd is not reclaiming as much memory with the patch
applied.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    9 +++++++++
 mm/vmscan.c          |   16 +++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff -puN include/linux/swap.h~mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones include/linux/swap.h
--- a/include/linux/swap.h~mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones
+++ a/include/linux/swap.h
@@ -155,6 +155,15 @@ enum {
 #define SWAP_CLUSTER_MAX 32
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
+/*
+ * Ratio between the present memory in the zone and the "gap" that
+ * we're allowing kswapd to shrink in addition to the per-zone high
+ * wmark, even for zones that already have the high wmark satisfied,
+ * in order to provide better per-zone lru behavior. We are ok to
+ * spend not more than 1% of the memory for this zone balancing "gap".
+ */
+#define KSWAPD_ZONE_BALANCE_GAP_RATIO 100
+
 #define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
 #define SWAP_MAP_BAD	0x3f	/* Note pageblock is bad, in first swap_map */
 #define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
diff -puN mm/vmscan.c~mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones
+++ a/mm/vmscan.c
@@ -2400,6 +2400,7 @@ loop_again:
 			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
+			unsigned long balance_gap;
 
 			if (!populated_zone(zone))
 				continue;
@@ -2416,11 +2417,20 @@ loop_again:
 			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask);
 
 			/*
-			 * We put equal pressure on every zone, unless one
-			 * zone has way too many pages free already.
+			 * We put equal pressure on every zone, unless
+			 * one zone has way too many pages free
+			 * already. The "too many pages" is defined
+			 * as the high wmark plus a "gap" where the
+			 * gap is either the low watermark or 1%
+			 * of the zone, whichever is smaller.
 			 */
+			balance_gap = min(low_wmark_pages(zone),
+				(zone->present_pages +
+					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
+				KSWAPD_ZONE_BALANCE_GAP_RATIO);
 			if (!zone_watermark_ok_safe(zone, order,
-					8*high_wmark_pages(zone), end_zone, 0))
+					high_wmark_pages(zone) + balance_gap,
+					end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-grab-rcu-read-lock-in-move_pages.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
mm-rename-drop_anon_vma-to-put_anon_vma.patch
mm-move-anon_vma-ref-out-from-under-config_foo.patch
mm-simplify-anon_vma-refcounts.patch
mm-deactivate-invalidated-pages.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
add-debugging-aid-for-memory-initialisation-problems.patch

