From: akpm@linux-foundation.org
Subject: [folded] mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch removed from -mm tree
Date: Fri, 16 Dec 2011 15:03:21 -0800
Message-ID: <20111216230322.232155C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38388 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963Ab1LPXDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:03:24 -0500
Received: by eekc1 with SMTP id c1so110177eek.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:03:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, alan@lxorguk.ukuu.org.uk, hannes@cmpxchg.org, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3
has been removed from the -mm tree.  Its filename was
     mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch

This patch was dropped because it was folded into mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3

Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/gfp.h~mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3 include/linux/gfp.h
--- a/include/linux/gfp.h~mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3
+++ a/include/linux/gfp.h
@@ -89,6 +89,9 @@ struct vm_area_struct;
  * 1. Do not wake kswapd (hence the flag name)
  * 2. Do not use stall in synchronous compaction for high-order allocations
  *    as this may cause the caller to stall writing out pages
+ *
+ * This flag it primarily intended for use with transparent hugepage support.
+ * If the flag is used outside the VM, linux-mm should be cc'd for review.
  */
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-debug-test-for-online-nid-when-allocating-on-single-node.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch

