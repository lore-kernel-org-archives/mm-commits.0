From: akpm@linux-foundation.org
Subject: [failures]
 mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch removed from -mm tree
Date: Wed, 14 May 2014 13:35:07 -0700
Message-ID: <5373d37b.u7dwDtdxZrzrtLUX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaENUfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 16:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ytk.lee@samsung.com, riel@redhat.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, m.szyprowski@samsung.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hughd@google.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: [failures] mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch removed from -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,hughd@google.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,m.szyprowski@samsung.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,riel@redhat.com,ytk.lee@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 13:35:07 -0700


The patch titled
     Subject: mm/page_alloc: DEBUG_VM checks for free_list placement of CMA and RESERVE pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: DEBUG_VM checks for free_list placement of CMA and RESERVE pages

For the MIGRATE_RESERVE pages, it is important they do not get misplaced
on free_list of other migratetype, otherwise the whole MIGRATE_RESERVE
pageblock might be changed to other migratetype in
try_to_steal_freepages().  For MIGRATE_CMA, the pages also must not go to
a different free_list, otherwise they could get allocated as unmovable and
result in CMA failure.

This is ensured by setting the freepage_migratetype appropriately when
placing pages on pcp lists, and using the information when releasing them
back to free_list.  It is also assumed that CMA and RESERVE pageblocks are
created only in the init phase.  This patch adds DEBUG_VM checks to catch
any regressions introduced for this invariant.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN include/linux/mm.h~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages include/linux/mm.h
diff -puN mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages
+++ a/mm/page_alloc.c
@@ -663,6 +663,25 @@ static inline int free_pages_check(struc
 }
 
 /*
+ * Check that a freepage cannot end up on a wrong free_list for "sensitive"
+ * migratetypes. Return false if it could. Useful for VM_BUG_ON checks.
+ */
+static bool check_freepage_migratetype(struct page *page)
+{
+	int pageblock_mt = get_pageblock_migratetype(page);
+	int freepage_mt = get_freepage_migratetype(page);
+
+	/*
+	 * For RESERVE and CMA pageblocks, the freepage_migratetype must
+	 * match their migratetype. For other pageblocks, we don't care.
+	 */
+	if (pageblock_mt != MIGRATE_RESERVE && !is_migrate_cma(pageblock_mt))
+		return true;
+
+	return (freepage_mt == pageblock_mt);
+}
+
+/*
  * Frees a number of pages from the PCP lists
  * Assumes all pages on list are in same zone, and of same order.
  * count is the number of pages to free.
@@ -711,6 +730,8 @@ static void free_pcppages_bulk(struct zo
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
+
+			VM_BUG_ON_PAGE(!check_freepage_migratetype(page), page);
 			mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
@@ -1208,6 +1229,7 @@ static int rmqueue_bulk(struct zone *zon
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
+		VM_BUG_ON_PAGE(!check_freepage_migratetype(page), page);
 
 		/*
 		 * Split buddy pages returned by expand() are received here
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
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

