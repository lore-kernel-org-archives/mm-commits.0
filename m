From: akpm@linux-foundation.org
Subject: + mm-compaction-make-isolate_lru_page-filter-aware-again.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:29:54 -0800
Message-ID: <20111216232955.CA9D35C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58161 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab1LPX36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:29:58 -0500
Received: by mail-ee0-f74.google.com with SMTP id c1so110660eek.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:29:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: compaction: make isolate_lru_page() filter-aware again
has been added to the -mm tree.  Its filename is
     mm-compaction-make-isolate_lru_page-filter-aware-again.patch

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
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: make isolate_lru_page() filter-aware again

Commit 39deaf85 ("mm: compaction: make isolate_lru_page() filter-aware")
noted that compaction does not migrate dirty or writeback pages and that
is was meaningless to pick the page and re-add it to the LRU list.  This
had to be partially reverted because some dirty pages can be migrated by
compaction without blocking.

This patch updates "mm: compaction: make isolate_lru_page" by skipping
over pages that migration has no possibility of migrating to minimise LRU
disruption.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel<riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/compaction.c        |    3 +++
 mm/vmscan.c            |   35 +++++++++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-make-isolate_lru_page-filter-aware-again include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-make-isolate_lru_page-filter-aware-again
+++ a/include/linux/mmzone.h
@@ -173,6 +173,8 @@ static inline int is_unevictable_lru(enu
 #define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
 /* Isolate unmapped file */
 #define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)
+/* Isolate for asynchronous migration */
+#define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x10)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff -puN mm/compaction.c~mm-compaction-make-isolate_lru_page-filter-aware-again mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-isolate_lru_page-filter-aware-again
+++ a/mm/compaction.c
@@ -349,6 +349,9 @@ static isolate_migrate_t isolate_migrate
 			continue;
 		}
 
+		if (!cc->sync)
+			mode |= ISOLATE_ASYNC_MIGRATE;
+
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, mode, 0) != 0)
 			continue;
diff -puN mm/vmscan.c~mm-compaction-make-isolate_lru_page-filter-aware-again mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-make-isolate_lru_page-filter-aware-again
+++ a/mm/vmscan.c
@@ -1049,8 +1049,39 @@ int __isolate_lru_page(struct page *page
 
 	ret = -EBUSY;
 
-	if ((mode & ISOLATE_CLEAN) && (PageDirty(page) || PageWriteback(page)))
-		return ret;
+	/*
+	 * To minimise LRU disruption, the caller can indicate that it only
+	 * wants to isolate pages it will be able to operate on without
+	 * blocking - clean pages for the most part.
+	 *
+	 * ISOLATE_CLEAN means that only clean pages should be isolated. This
+	 * is used by reclaim when it is cannot write to backing storage
+	 *
+	 * ISOLATE_ASYNC_MIGRATE is used to indicate that it only wants to pages
+	 * that it is possible to migrate without blocking
+	 */
+	if (mode & (ISOLATE_CLEAN|ISOLATE_ASYNC_MIGRATE)) {
+		/* All the caller can do on PageWriteback is block */
+		if (PageWriteback(page))
+			return ret;
+
+		if (PageDirty(page)) {
+			struct address_space *mapping;
+
+			/* ISOLATE_CLEAN means only clean pages */
+			if (mode & ISOLATE_CLEAN)
+				return ret;
+
+			/*
+			 * Only pages without mappings or that have a
+			 * ->migratepage callback are possible to migrate
+			 * without blocking
+			 */
+			mapping = page_mapping(page);
+			if (mapping && !mapping->a_ops->migratepage)
+				return ret;
+		}
+	}
 
 	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
 		return ret;
_
Subject: Subject: mm: compaction: make isolate_lru_page() filter-aware again

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
revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
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

