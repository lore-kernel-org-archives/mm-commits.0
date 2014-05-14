From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch removed from -mm tree
Date: Wed, 14 May 2014 13:34:47 -0700
Message-ID: <5373d367.RnaBkWyPYrj9tGMe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaENUes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 16:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, vbabka@suse.cz

Subject: [folded-merged] mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch removed from -mm tree
To: vbabka@suse.cz,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 13:34:47 -0700


The patch titled
     Subject: mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch

This patch was dropped because it was folded into mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix

Use VM_BUG_ON_PAGE instead of VM_BUG_ON as suggested by Sasha Levin.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix
+++ a/mm/page_alloc.c
@@ -712,7 +712,7 @@ static void free_pcppages_bulk(struct zo
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
 
-			VM_BUG_ON(!check_freepage_migratetype(page));
+			VM_BUG_ON_PAGE(!check_freepage_migratetype(page), page);
 			mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
@@ -1210,7 +1210,7 @@ static int rmqueue_bulk(struct zone *zon
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
-		VM_BUG_ON(!check_freepage_migratetype(page));
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
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2.patch

