From: akpm@linux-foundation.org
Subject: [folded] mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:55:51 -0800
Message-ID: <20120113005551.D33F2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:48912 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2AMAzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:55:55 -0500
Received: by faaa20 with SMTP id a20so73944faa.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:55:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan@kernel.org, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch

This patch was dropped because it was folded into mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix

Consistently name enum migrate_mode parameters "mode" instead of "sync".

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/disk-io.c      |    2 +-
 fs/nfs/write.c          |    2 +-
 include/linux/migrate.h |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/btrfs/disk-io.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix
+++ a/fs/btrfs/disk-io.c
@@ -873,7 +873,7 @@ static int btree_submit_bio_hook(struct 
 #ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
 			struct page *newpage, struct page *page,
-			enum migrate_mode sync)
+			enum migrate_mode mode)
 {
 	/*
 	 * we can't safely write a btree page from here,
diff -puN fs/nfs/write.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix fs/nfs/write.c
--- a/fs/nfs/write.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix
+++ a/fs/nfs/write.c
@@ -1711,7 +1711,7 @@ out_error:
 
 #ifdef CONFIG_MIGRATION
 int nfs_migrate_page(struct address_space *mapping, struct page *newpage,
-		struct page *page, enum migrate_mode sync)
+		struct page *page, enum migrate_mode mode)
 {
 	/*
 	 * If PagePrivate is set, then the page is currently associated with
diff -puN include/linux/migrate.h~mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix include/linux/migrate.h
--- a/include/linux/migrate.h~mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix
+++ a/include/linux/migrate.h
@@ -27,10 +27,10 @@ extern int migrate_page(struct address_s
 			struct page *, struct page *, enum migrate_mode);
 extern int migrate_pages(struct list_head *l, new_page_t x,
 			unsigned long private, bool offlining,
-			enum migrate_mode sync);
+			enum migrate_mode mode);
 extern int migrate_huge_pages(struct list_head *l, new_page_t x,
 			unsigned long private, bool offlining,
-			enum migrate_mode sync);
+			enum migrate_mode mode);
 
 extern int fail_migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -49,10 +49,10 @@ extern int migrate_huge_page_move_mappin
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, bool offlining,
-		enum migrate_mode sync) { return -ENOSYS; }
+		enum migrate_mode mode) { return -ENOSYS; }
 static inline int migrate_huge_pages(struct list_head *l, new_page_t x,
 		unsigned long private, bool offlining,
-		enum migrate_mode sync) { return -ENOSYS; }
+		enum migrate_mode mode) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch

