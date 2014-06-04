From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch removed
 from -mm tree
Date: Wed, 04 Jun 2014 15:30:32 -0700
Message-ID: <538f9e08.917YJsCSek/oG0jp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFDWac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mina86@mina86.com, vbabka@suse.cz

Subject: [folded-merged] mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch removed from -mm tree
To: vbabka@suse.cz,mina86@mina86.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:30:32 -0700


The patch titled
     Subject: mm-compaction-do-not-count-migratepages-when-unnecessary-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch

This patch was dropped because it was folded into mm-compaction-do-not-count-migratepages-when-unnecessary.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-do-not-count-migratepages-when-unnecessary-fix

list_for_each is enough for counting the list length.  We also avoid
including struct page definition this way.

Suggested-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/trace/events/compaction.h~mm-compaction-do-not-count-migratepages-when-unnecessary-fix include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-do-not-count-migratepages-when-unnecessary-fix
+++ a/include/trace/events/compaction.h
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/tracepoint.h>
-#include <linux/mm_types.h>
 #include <trace/events/gfpflags.h>
 
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
@@ -62,7 +61,7 @@ TRACE_EVENT(mm_compaction_migratepages,
 
 	TP_fast_assign(
 		unsigned long nr_failed = 0;
-		struct page *page;
+		struct list_head *page_lru;
 
 		/*
 		 * migrate_pages() returns either a non-negative number
@@ -73,7 +72,7 @@ TRACE_EVENT(mm_compaction_migratepages,
 		if (migrate_rc >= 0)
 			nr_failed = migrate_rc;
 		else
-			list_for_each_entry(page, migratepages, lru)
+			list_for_each(page_lru, migratepages)
 				nr_failed++;
 
 		__entry->nr_migrated = nr_all - nr_failed;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
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

