Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DCDC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E1A610A2
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhDIFJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhDIFJS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:09:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C20561165;
        Fri,  9 Apr 2021 05:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944874;
        bh=54cCDZmrWRIXnJGTI3OPeQwx8sC/HCpsuhTywSJXxOM=;
        h=Date:From:To:Subject:From;
        b=sM7yazF7yLrFzt6S6/P0xkNZd3xD83hcq4CW39x32nAZ3Zoug6I+Y/cqdyA5mRsk1
         iiaSxmNXYfCcOE/P5jJ9FM6rMHLp4DzTgM9rp5Hd661g5zSn1ltW5SUJVuG/ElEXoT
         BX5/+lsIZPWQUb7AU5PyOjIc9SRMrEPwP+i249hc=
Date:   Thu, 08 Apr 2021 22:07:53 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
 removed from -mm tree
Message-ID: <20210409050753.YhAOrLCoi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,compaction: let isolate_migratepages_{range,block} return error codes
has been removed from the -mm tree.  Its filename was
     mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,compaction: let isolate_migratepages_{range,block} return error codes

Currently, isolate_migratepages_{range,block} and their callers use a pfn
== 0 vs pfn != 0 scheme to let the caller know whether there was any error
during isolation.

This does not work as soon as we need to start reporting different error
codes and make sure we pass them down the chain, so they are properly
interpreted by functions like e.g: alloc_contig_range.

Let us rework isolate_migratepages_{range,block} so we can report error
codes.  Since isolate_migratepages_block will stop returning the next pfn
to be scanned, we reuse the cc->migrate_pfn field to keep track of that.

Link: https://lkml.kernel.org/r/20210319132004.4341-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   53 ++++++++++++++++++++++------------------------
 mm/internal.h   |   10 ++++++--
 mm/page_alloc.c |    7 ++----
 3 files changed, 37 insertions(+), 33 deletions(-)

--- a/mm/compaction.c~mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes
+++ a/mm/compaction.c
@@ -787,15 +787,15 @@ static bool too_many_isolated(pg_data_t
  *
  * Isolate all pages that can be migrated from the range specified by
  * [low_pfn, end_pfn). The range is expected to be within same pageblock.
- * Returns zero if there is a fatal signal pending, otherwise PFN of the
- * first page that was not scanned (which may be both less, equal to or more
- * than end_pfn).
+ * Returns errno, like -EAGAIN or -EINTR in case e.g signal pending or congestion,
+ * or 0.
+ * cc->migrate_pfn will contain the next pfn to scan (which may be both less,
+ * equal to or more that end_pfn).
  *
  * The pages are isolated on cc->migratepages list (not required to be empty),
- * and cc->nr_migratepages is updated accordingly. The cc->migrate_pfn field
- * is neither read nor updated.
- */
-static unsigned long
+ * and cc->nr_migratepages is updated accordingly.
+*/
+static int
 isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			unsigned long end_pfn, isolate_mode_t isolate_mode)
 {
@@ -810,6 +810,8 @@ isolate_migratepages_block(struct compac
 	unsigned long next_skip_pfn = 0;
 	bool skip_updated = false;
 
+	cc->migrate_pfn = low_pfn;
+
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
 	 * list by either parallel reclaimers or compaction. If there are,
@@ -818,16 +820,16 @@ isolate_migratepages_block(struct compac
 	while (unlikely(too_many_isolated(pgdat))) {
 		/* stop isolation if there are still pages not migrated */
 		if (cc->nr_migratepages)
-			return 0;
+			return -EAGAIN;
 
 		/* async migration should just abort */
 		if (cc->mode == MIGRATE_ASYNC)
-			return 0;
+			return -EAGAIN;
 
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		if (fatal_signal_pending(current))
-			return 0;
+			return -EINTR;
 	}
 
 	cond_resched();
@@ -1130,7 +1132,9 @@ fatal_pending:
 	if (nr_isolated)
 		count_compact_events(COMPACTISOLATED, nr_isolated);
 
-	return low_pfn;
+	cc->migrate_pfn = low_pfn;
+
+	return 0;
 }
 
 /**
@@ -1139,15 +1143,15 @@ fatal_pending:
  * @start_pfn: The first PFN to start isolating.
  * @end_pfn:   The one-past-last PFN.
  *
- * Returns zero if isolation fails fatally due to e.g. pending signal.
- * Otherwise, function returns one-past-the-last PFN of isolated page
- * (which may be greater than end_pfn if end fell in a middle of a THP page).
+ * Returns errno, like -EAGAIN or -EINTR in case e.g signal pending or congestion,
+ * or 0.
  */
-unsigned long
+int
 isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 							unsigned long end_pfn)
 {
 	unsigned long pfn, block_start_pfn, block_end_pfn;
+	int ret = 0;
 
 	/* Scan block by block. First and last block may be incomplete */
 	pfn = start_pfn;
@@ -1166,17 +1170,17 @@ isolate_migratepages_range(struct compac
 					block_end_pfn, cc->zone))
 			continue;
 
-		pfn = isolate_migratepages_block(cc, pfn, block_end_pfn,
-							ISOLATE_UNEVICTABLE);
+		ret = isolate_migratepages_block(cc, pfn, block_end_pfn,
+						 ISOLATE_UNEVICTABLE);
 
-		if (!pfn)
+		if (ret)
 			break;
 
 		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX)
 			break;
 	}
 
-	return pfn;
+	return ret;
 }
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
@@ -1847,7 +1851,7 @@ static isolate_migrate_t isolate_migrate
 	 */
 	for (; block_end_pfn <= cc->free_pfn;
 			fast_find_block = false,
-			low_pfn = block_end_pfn,
+			cc->migrate_pfn = low_pfn = block_end_pfn,
 			block_start_pfn = block_end_pfn,
 			block_end_pfn += pageblock_nr_pages) {
 
@@ -1889,10 +1893,8 @@ static isolate_migrate_t isolate_migrate
 		}
 
 		/* Perform the isolation */
-		low_pfn = isolate_migratepages_block(cc, low_pfn,
-						block_end_pfn, isolate_mode);
-
-		if (!low_pfn)
+		if (isolate_migratepages_block(cc, low_pfn, block_end_pfn,
+						isolate_mode))
 			return ISOLATE_ABORT;
 
 		/*
@@ -1903,9 +1905,6 @@ static isolate_migrate_t isolate_migrate
 		break;
 	}
 
-	/* Record where migration scanner will be restarted. */
-	cc->migrate_pfn = low_pfn;
-
 	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
 
--- a/mm/internal.h~mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes
+++ a/mm/internal.h
@@ -245,7 +245,13 @@ struct compact_control {
 	unsigned int nr_freepages;	/* Number of isolated free pages */
 	unsigned int nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
-	unsigned long migrate_pfn;	/* isolate_migratepages search base */
+	/*
+	 * Acts as an in/out parameter to page isolation for migration.
+	 * isolate_migratepages uses it as a search base.
+	 * isolate_migratepages_block will update the value to the next pfn
+	 * after the last isolated one.
+	 */
+	unsigned long migrate_pfn;
 	unsigned long fast_start_pfn;	/* a pfn to start linear scan from */
 	struct zone *zone;
 	unsigned long total_migrate_scanned;
@@ -281,7 +287,7 @@ struct capture_control {
 unsigned long
 isolate_freepages_range(struct compact_control *cc,
 			unsigned long start_pfn, unsigned long end_pfn);
-unsigned long
+int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
 int find_suitable_fallback(struct free_area *area, unsigned int order,
--- a/mm/page_alloc.c~mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes
+++ a/mm/page_alloc.c
@@ -8689,11 +8689,10 @@ static int __alloc_contig_migrate_range(
 
 		if (list_empty(&cc->migratepages)) {
 			cc->nr_migratepages = 0;
-			pfn = isolate_migratepages_range(cc, pfn, end);
-			if (!pfn) {
-				ret = -EINTR;
+			ret = isolate_migratepages_range(cc, pfn, end);
+			if (ret && ret != -EAGAIN)
 				break;
-			}
+			pfn = cc->migrate_pfn;
 			tries = 0;
 		} else if (++tries == 5) {
 			ret = -EBUSY;
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

