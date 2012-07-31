From: akpm@linux-foundation.org
Subject: [folded] mm-have-order-0-compaction-start-off-where-it-left-v3.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:31:03 -0700
Message-ID: <20120731233103.E18BEA028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43759 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2GaXbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:31:05 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4818782obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:31:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, jaschut@sandia.gov, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: have order > 0 compaction start off where it left
has been removed from the -mm tree.  Its filename was
     mm-have-order-0-compaction-start-off-where-it-left-v3.patch

This patch was dropped because it was folded into mm-have-order-0-compaction-start-off-where-it-left.patch

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: have order > 0 compaction start off where it left

This patch makes the comment for cc->wrapped longer, explaining what is
really going on.  It also incorporates the comment fix pointed out by
Minchan.

Additionally, Minchan found that, when no pages get isolated, high_pfn
could be a value that is much lower than desired, which might potentially
cause compaction to skip a range of pages.

Only assign zone->compact_cache_free_pfn if we actually isolated free
pages for compaction.

Split out the calculation to get the start of the last page block in a
zone into its own, commented function.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Jim Schutt <jaschut@sandia.gov>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/compaction.c        |   30 ++++++++++++++++++++++--------
 mm/internal.h          |    6 +++++-
 3 files changed, 28 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-have-order-0-compaction-start-off-where-it-left-v3 include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-have-order-0-compaction-start-off-where-it-left-v3
+++ a/include/linux/mmzone.h
@@ -368,7 +368,7 @@ struct zone {
 	spinlock_t		lock;
 	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
-	/* pfn where the last order > 0 compaction isolated free pages */
+	/* pfn where the last incremental compaction isolated free pages */
 	unsigned long		compact_cached_free_pfn;
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG
diff -puN mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-v3 mm/compaction.c
--- a/mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-v3
+++ a/mm/compaction.c
@@ -472,10 +472,11 @@ static void isolate_freepages(struct zon
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated)
+		if (isolated) {
 			high_pfn = max(high_pfn, pfn);
-		if (cc->order > 0)
-			zone->compact_cached_free_pfn = high_pfn;
+			if (cc->order > 0)
+				zone->compact_cached_free_pfn = high_pfn;
+		}
 	}
 
 	/* split_free_page does not map the pages */
@@ -569,6 +570,21 @@ static isolate_migrate_t isolate_migrate
 	return ISOLATE_SUCCESS;
 }
 
+/*
+ * Returns the start pfn of the laste page block in a zone.
+ * This is the starting point for full compaction of a zone.
+ * Compaction searches for free pages from the end of each zone,
+ * while isolate_freepages_block scans forward inside each page
+ * block.
+ */
+static unsigned long start_free_pfn(struct zone *zone)
+{
+	unsigned long free_pfn;
+	free_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	free_pfn &= ~(pageblock_nr_pages-1);
+	return free_pfn;
+}
+
 static int compact_finished(struct zone *zone,
 			    struct compact_control *cc)
 {
@@ -587,10 +603,9 @@ static int compact_finished(struct zone 
 	if (cc->free_pfn <= cc->migrate_pfn) {
 		if (cc->order > 0 && !cc->wrapped) {
 			/* We started partway through; restart at the end. */
-			unsigned long free_pfn;
-			free_pfn = zone->zone_start_pfn + zone->spanned_pages;
-			free_pfn &= ~(pageblock_nr_pages-1);
+			unsigned long free_pfn = start_free_pfn(zone);
 			zone->compact_cached_free_pfn = free_pfn;
+			cc->free_pfn = free_pfn;
 			cc->wrapped = 1;
 			return COMPACT_CONTINUE;
 		}
@@ -703,8 +718,7 @@ static int compact_zone(struct zone *zon
 		cc->start_free_pfn = cc->free_pfn;
 	} else {
 		/* Order == -1 starts at the end of the zone. */
-		cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
-		cc->free_pfn &= ~(pageblock_nr_pages-1);
+		cc->free_pfn = start_free_pfn(zone);
 	}
 
 	migrate_prep_local();
diff -puN mm/internal.h~mm-have-order-0-compaction-start-off-where-it-left-v3 mm/internal.h
--- a/mm/internal.h~mm-have-order-0-compaction-start-off-where-it-left-v3
+++ a/mm/internal.h
@@ -121,7 +121,11 @@ struct compact_control {
 	unsigned long start_free_pfn;	/* where we started the search */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
-	bool wrapped;			/* Last round for order>0 compaction */
+	bool wrapped;			/* Order > 0 compactions are
+					   incremental, once free_pfn
+					   and migrate_pfn meet, we restart
+					   from the top of the zone;
+					   remember we wrapped around. */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
swap-allow-swap-readahead-to-be-merged.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-remove-unused-lru_all_evictable.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
netvm-prevent-a-stream-specific-deadlock.patch
selinux-tag-avc-cache-alloc-as-non-critical.patch
mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch
mm-swap-implement-generic-handler-for-swap_activate.patch
mm-add-support-for-direct_io-to-highmem-pages.patch
nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch
nfs-disable-data-cache-revalidation-for-swapfiles.patch
nfs-enable-swap-on-nfs.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
tmpfs-distribute-interleave-better-across-nodes.patch

