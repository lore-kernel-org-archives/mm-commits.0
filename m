From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-introduce-compaction-and-migration-for-ballooned-pages.patch removed from -mm tree
Date: Thu, 15 Nov 2012 11:57:18 -0800
Message-ID: <20121115195718.BCD03100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55023 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768751Ab2KOT5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 14:57:20 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so214493qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 11:57:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, andi@firstfloor.org, konrad.wilk@oracle.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce compaction and migration for ballooned pages
has been removed from the -mm tree.  Its filename was
     mm-introduce-compaction-and-migration-for-ballooned-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: introduce compaction and migration for ballooned pages

Memory fragmentation introduced by ballooning might reduce significantly
the number of 2MB contiguous memory blocks that can be used within a
guest, thus imposing performance penalties associated with the reduced
number of transparent huge pages that could be used by the guest workload.

This patch introduces the helper functions as well as the necessary
changes to teach compaction and migration bits how to cope with pages
which are part of a guest memory balloon, in order to make them movable by
memory compaction procedures.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   21 +++++++++++++++++++--
 mm/migrate.c    |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-introduce-compaction-and-migration-for-ballooned-pages mm/compaction.c
--- a/mm/compaction.c~mm-introduce-compaction-and-migration-for-ballooned-pages
+++ a/mm/compaction.c
@@ -14,6 +14,7 @@
 #include <linux/backing-dev.h>
 #include <linux/sysctl.h>
 #include <linux/sysfs.h>
+#include <linux/balloon_compaction.h>
 #include "internal.h"
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
@@ -565,9 +566,24 @@ isolate_migratepages_range(struct zone *
 			goto next_pageblock;
 		}
 
-		/* Check may be lockless but that's ok as we recheck later */
-		if (!PageLRU(page))
+		/*
+		 * Check may be lockless but that's ok as we recheck later.
+		 * It's possible to migrate LRU pages and balloon pages
+		 * Skip any other type of page
+		 */
+		if (!PageLRU(page)) {
+			if (unlikely(balloon_page_movable(page))) {
+				if (locked && balloon_page_isolate(page)) {
+					/* Successfully isolated */
+					cc->finished_update_migrate = true;
+					list_add(&page->lru, migratelist);
+					cc->nr_migratepages++;
+					nr_isolated++;
+					goto check_compact_cluster;
+				}
+			}
 			continue;
+		}
 
 		/*
 		 * PageLRU is set. lru_lock normally excludes isolation
@@ -621,6 +637,7 @@ isolate_migratepages_range(struct zone *
 		cc->nr_migratepages++;
 		nr_isolated++;
 
+check_compact_cluster:
 		/* Avoid isolating too much */
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
 			++low_pfn;
diff -puN mm/migrate.c~mm-introduce-compaction-and-migration-for-ballooned-pages mm/migrate.c
--- a/mm/migrate.c~mm-introduce-compaction-and-migration-for-ballooned-pages
+++ a/mm/migrate.c
@@ -35,6 +35,7 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
+#include <linux/balloon_compaction.h>
 
 #include <asm/tlbflush.h>
 
@@ -79,7 +80,10 @@ void putback_lru_pages(struct list_head 
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		putback_lru_page(page);
+		if (unlikely(balloon_page_movable(page)))
+			balloon_page_putback(page);
+		else
+			putback_lru_page(page);
 	}
 }
 
@@ -778,6 +782,18 @@ static int __unmap_and_move(struct page 
 		}
 	}
 
+	if (unlikely(balloon_page_movable(page))) {
+		/*
+		 * A ballooned page does not need any special attention from
+		 * physical to virtual reverse mapping procedures.
+		 * Skip any attempt to unmap PTEs or to remap swap cache,
+		 * in order to avoid burning cycles at rmap level, and perform
+		 * the page migration right away (proteced by page lock).
+		 */
+		rc = balloon_page_migrate(newpage, page, mode);
+		goto uncharge;
+	}
+
 	/*
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
@@ -814,7 +830,9 @@ skip_unmap:
 		put_anon_vma(anon_vma);
 
 uncharge:
-	mem_cgroup_end_migration(mem, page, newpage, rc == MIGRATEPAGE_SUCCESS);
+	mem_cgroup_end_migration(mem, page, newpage,
+				 (rc == MIGRATEPAGE_SUCCESS ||
+				  rc == MIGRATEPAGE_BALLOON_SUCCESS));
 unlock:
 	unlock_page(page);
 out:
@@ -846,6 +864,20 @@ static int unmap_and_move(new_page_t get
 			goto out;
 
 	rc = __unmap_and_move(page, newpage, force, offlining, mode);
+
+	if (unlikely(rc == MIGRATEPAGE_BALLOON_SUCCESS)) {
+		/*
+		 * A ballooned page has been migrated already.
+		 * Now, it's the time to remove the old page from the isolated
+		 * pageset list and handle it back to Buddy, wrap-up counters
+		 * and return.
+		 */
+		dec_zone_page_state(page, NR_ISOLATED_ANON +
+				    page_is_file_cache(page));
+		put_page(page);
+		__free_page(page);
+		return 0;
+	}
 out:
 	if (rc != -EAGAIN) {
 		/*
_

Patches currently in -mm which might be from aquini@redhat.com are

virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
mm-introduce-putback_movable_pages.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

