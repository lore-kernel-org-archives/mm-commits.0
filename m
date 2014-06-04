From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-cleanup-isolate_freepages-fix-2.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:25:17 -0700
Message-ID: <538f9ccd.qeQ8drqRszjDypqi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaFDWZS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:25:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunghwan.yun@samsung.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: [folded-merged] mm-compaction-cleanup-isolate_freepages-fix-2.patch removed from -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sunghwan.yun@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:25:17 -0700


The patch titled
     Subject: mm-compaction-cleanup-isolate_freepages-fix 2
has been removed from the -mm tree.  Its filename was
     mm-compaction-cleanup-isolate_freepages-fix-2.patch

This patch was dropped because it was folded into mm-compaction-cleanup-isolate_freepages.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-cleanup-isolate_freepages-fix 2

Cleanup detection of compaction scanners crossing in isolate_freepages(). 
To make sure compact_finished() observes scanners crossing, we can just
set free_pfn to migrate_pfn instead of confusing max() construct.

Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix-2
+++ a/mm/compaction.c
@@ -758,7 +758,7 @@ static void isolate_freepages(struct zon
 	 * so that compact_finished() may detect this
 	 */
 	if (pfn < low_pfn)
-		next_free_pfn = max(pfn, zone->zone_start_pfn);
+		next_free_pfn = cc->migrate_pfn;
 
 	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2.patch

