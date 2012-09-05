From: akpm@linux-foundation.org
Subject: + mm-support-migrate_discard.patch added to -mm tree
Date: Wed, 05 Sep 2012 16:36:40 -0700
Message-ID: <20120905233641.04F84100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:65382 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966Ab2IEXgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Sep 2012 19:36:43 -0400
Received: by vbnl22 with SMTP id l22so128256vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 05 Sep 2012 16:36:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, riel@redhat.com


The patch titled
     Subject: mm: support MIGRATE_DISCARD
has been added to the -mm tree.  Its filename is
     mm-support-migrate_discard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: support MIGRATE_DISCARD

Introduce MIGRATE_DISCARD mode in migration.  It drops *clean cache pages*
instead of migration so that migration latency could be reduced by
avoiding (memcpy + page remapping).  It's useful for CMA because latency
of migration is very important rather than eviction of background
processes's workingset.  In addition, it needs less free pages for
migration targets so it could avoid memory reclaiming to get free pages,
which is another factor increase latency.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate_mode.h |    7 +++++
 mm/migrate.c                 |   41 ++++++++++++++++++++++++++++++---
 mm/page_alloc.c              |    2 -
 3 files changed, 46 insertions(+), 4 deletions(-)

diff -puN include/linux/migrate_mode.h~mm-support-migrate_discard include/linux/migrate_mode.h
--- a/include/linux/migrate_mode.h~mm-support-migrate_discard
+++ a/include/linux/migrate_mode.h
@@ -14,6 +14,13 @@
  */
 #define MIGRATE_SYNC		((__force migrate_mode_t)0x4)
 
+/*
+ * MIGRTATE_DISCARD will discard clean cache page instead of migration.
+ * MIGRATE_ASYNC, MIGRATE_SYNC_LIGHT, MIGRATE_SYNC shouldn't be used
+ * together with OR flag in current implementation.
+ */
+#define MIGRATE_DISCARD		((__force migrate_mode_t)0x8)
+
 typedef unsigned __bitwise__ migrate_mode_t;
 
 #endif		/* MIGRATE_MODE_H_INCLUDED */
diff -puN mm/migrate.c~mm-support-migrate_discard mm/migrate.c
--- a/mm/migrate.c~mm-support-migrate_discard
+++ a/mm/migrate.c
@@ -678,6 +678,19 @@ static int move_to_new_page(struct page 
 	return rc;
 }
 
+static int discard_page(struct page *page)
+{
+	int ret = -EAGAIN;
+
+	struct address_space *mapping = page_mapping(page);
+	if (page_has_private(page))
+		if (!try_to_release_page(page, GFP_KERNEL))
+			return ret;
+	if (remove_mapping(mapping, page))
+		ret = 0;
+	return ret;
+}
+
 static int __unmap_and_move(struct page *page, struct page *newpage,
 			int force, bool offlining, migrate_mode_t mode)
 {
@@ -685,6 +698,9 @@ static int __unmap_and_move(struct page 
 	int remap_swapcache = 1;
 	struct mem_cgroup *mem;
 	struct anon_vma *anon_vma = NULL;
+	enum ttu_flags ttu_flags;
+	bool discard_mode = false;
+	bool file = false;
 
 	if (!trylock_page(page)) {
 		if (!force || (mode & MIGRATE_ASYNC))
@@ -799,12 +815,31 @@ static int __unmap_and_move(struct page 
 		goto skip_unmap;
 	}
 
+	file = page_is_file_cache(page);
+	ttu_flags = TTU_IGNORE_ACCESS;
+retry:
+	if (!(mode & MIGRATE_DISCARD) || !file || PageDirty(page))
+		ttu_flags |= (TTU_MIGRATION | TTU_IGNORE_MLOCK);
+	else
+		discard_mode = true;
+
 	/* Establish migration ptes or remove ptes */
-	try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+	rc = try_to_unmap(page, ttu_flags);
 
 skip_unmap:
-	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page, remap_swapcache, mode);
+	if (rc == SWAP_SUCCESS) {
+		if (!discard_mode) {
+			rc = move_to_new_page(newpage, page,
+					remap_swapcache, mode);
+		} else {
+			rc = discard_page(page);
+			goto uncharge;
+		}
+	} else if (rc == SWAP_MLOCK && discard_mode) {
+		mode &= ~MIGRATE_DISCARD;
+		discard_mode = false;
+		goto retry;
+	}
 
 	if (rc && remap_swapcache)
 		remove_migration_ptes(page, page);
diff -puN mm/page_alloc.c~mm-support-migrate_discard mm/page_alloc.c
--- a/mm/page_alloc.c~mm-support-migrate_discard
+++ a/mm/page_alloc.c
@@ -5701,7 +5701,7 @@ static int __alloc_contig_migrate_range(
 
 		ret = migrate_pages(&cc.migratepages,
 				    __alloc_contig_migrate_alloc,
-				    0, false, MIGRATE_SYNC);
+				    0, false, MIGRATE_SYNC|MIGRATE_DISCARD);
 	}
 
 	putback_lru_pages(&cc.migratepages);
_

Patches currently in -mm which might be from minchan@kernel.org are

memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-change-enum-migrate_mode-with-bitwise-type.patch
mm-support-migrate_discard.patch

