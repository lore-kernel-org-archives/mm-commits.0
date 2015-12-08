From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch removed from -mm
 tree
Date: Tue, 08 Dec 2015 12:36:32 -0800
Message-ID: <56673f50.Ew0S1vuqi78qLSn7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbbLHUge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 15:36:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, dave.hansen@intel.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mingo@kernel.org, riel@redhat.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: increase SWAP_CLUSTER_MAX to batch TLB flushes
has been removed from the -mm tree.  Its filename was
     mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: increase SWAP_CLUSTER_MAX to batch TLB flushes

Pages that are unmapped for reclaim must be flushed before being freed to
avoid corruption due to a page being freed and reallocated while a stale
TLB entry exists.  When reclaiming mapped pages, the requires one IPI per
SWAP_CLUSTER_MAX.  This patch increases SWAP_CLUSTER_MAX to 256 so more
pages can be flushed with a single IPI.  This number was selected because
it reduced IPIs for TLB shootdowns by 40% on a workload that is dominated
by mapped pages.

Note that it is expected that doubling SWAP_CLUSTER_MAX would not always
halve the IPIs as it is workload dependent.  Reclaim efficiency was not
100% on this workload which was picked for being IPI-intensive and was
closer to 35%.  More importantly, reclaim does not always isolate in
SWAP_CLUSTER_MAX pages.  The LRU lists for a zone may be small, the
priority can be low and even when reclaiming a lot of pages, the last
isolation may not be exactly SWAP_CLUSTER_MAX.

There are a few potential issues with increasing SWAP_CLUSTER_MAX.

1. LRU lock hold times increase slightly because more pages are being
   isolated.
2. There are slight timing changes due to more pages having to be
   processed before they are freed. There is a slight risk that more
   pages than are necessary get reclaimed.
3. There is a risk that too_many_isolated checks will be easier to
   trigger resulting in a HZ/10 stall.
4. The rotation rate of active->inactive is slightly faster but there
   should be fewer rotations before the lists get balanced so it
   shouldn't matter.
5. More pages are reclaimed in a single pass if zone_reclaim_mode is
   active but that thing sucks hard when it's enabled no matter what
6. More pages are isolated for compaction so page hold times there
   are longer while they are being copied

It's unlikely any of these will be problems but worth keeping in mind if
there are any reclaim-related bug reports in the near future.

[hannes@cmpxchg.org: fix scan window after SWAP_CLUSTER_MAX increase]
[akpm@linux-foundation.org: s/SWAP_CLUSTER_MAX/SWAP_CLUSTER_MAX * 2/, per Johannes]
[js1304@gmail.com: restore COMPACT_CLUSTER_MAX to 32]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/vmpressure.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/swap.h~mm-increase-swap_cluster_max-to-batch-tlb-flushes include/linux/swap.h
--- a/include/linux/swap.h~mm-increase-swap_cluster_max-to-batch-tlb-flushes
+++ a/include/linux/swap.h
@@ -154,8 +154,8 @@ enum {
 	SWP_SCANNING	= (1 << 10),	/* refcount in scan_swap_map */
 };
 
-#define SWAP_CLUSTER_MAX 32UL
-#define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
+#define SWAP_CLUSTER_MAX 256UL
+#define COMPACT_CLUSTER_MAX 32UL
 
 /*
  * Ratio between zone->managed_pages and the "gap" that above the per-zone
diff -puN mm/vmpressure.c~mm-increase-swap_cluster_max-to-batch-tlb-flushes mm/vmpressure.c
--- a/mm/vmpressure.c~mm-increase-swap_cluster_max-to-batch-tlb-flushes
+++ a/mm/vmpressure.c
@@ -38,7 +38,7 @@
  * TODO: Make the window size depend on machine size, as we do for vmstat
  * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 2;
 
 /*
  * These thresholds are used when we account memory pressure through
_

Patches currently in -mm which might be from mgorman@suse.de are


