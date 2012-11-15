From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-introduce-putback_movable_pages.patch removed from -mm tree
Date: Thu, 15 Nov 2012 11:57:26 -0800
Message-ID: <20121115195726.BB1F3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37378 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768751Ab2KOT52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 14:57:28 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so224623qab.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 11:57:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, andi@firstfloor.org, konrad.wilk@oracle.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce putback_movable_pages()
has been removed from the -mm tree.  Its filename was
     mm-introduce-putback_movable_pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: introduce putback_movable_pages()

The patch "mm: introduce compaction and migration for virtio ballooned
pages" hacks around putback_lru_pages() in order to allow ballooned pages
to be re-inserted on balloon page list as if a ballooned page was like a
LRU page.

As ballooned pages are not legitimate LRU pages, this patch introduces
putback_movable_pages() to properly cope with cases where the isolated
pageset contains ballooned pages and LRU pages, thus fixing the mentioned
inelegant hack around putback_lru_pages().

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

 include/linux/migrate.h |    2 ++
 mm/compaction.c         |    6 +++---
 mm/migrate.c            |   20 ++++++++++++++++++++
 mm/page_alloc.c         |    2 +-
 4 files changed, 26 insertions(+), 4 deletions(-)

diff -puN include/linux/migrate.h~mm-introduce-putback_movable_pages include/linux/migrate.h
--- a/include/linux/migrate.h~mm-introduce-putback_movable_pages
+++ a/include/linux/migrate.h
@@ -27,6 +27,7 @@ typedef struct page *new_page_t(struct p
 #ifdef CONFIG_MIGRATION
 
 extern void putback_lru_pages(struct list_head *l);
+extern void putback_movable_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
 extern int migrate_pages(struct list_head *l, new_page_t x,
@@ -51,6 +52,7 @@ extern int migrate_misplaced_page(struct
 #else
 
 static inline void putback_lru_pages(struct list_head *l) {}
+static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, bool offlining,
 		enum migrate_mode mode) { return -ENOSYS; }
diff -puN mm/compaction.c~mm-introduce-putback_movable_pages mm/compaction.c
--- a/mm/compaction.c~mm-introduce-putback_movable_pages
+++ a/mm/compaction.c
@@ -995,7 +995,7 @@ static int compact_zone(struct zone *zon
 		switch (isolate_migratepages(zone, cc)) {
 		case ISOLATE_ABORT:
 			ret = COMPACT_PARTIAL;
-			putback_lru_pages(&cc->migratepages);
+			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
 			goto out;
 		case ISOLATE_NONE:
@@ -1018,9 +1018,9 @@ static int compact_zone(struct zone *zon
 		trace_mm_compaction_migratepages(nr_migrate - nr_remaining,
 						nr_remaining);
 
-		/* Release LRU pages not migrated */
+		/* Release isolated pages not migrated */
 		if (err) {
-			putback_lru_pages(&cc->migratepages);
+			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
 			if (err == -ENOMEM) {
 				ret = COMPACT_PARTIAL;
diff -puN mm/migrate.c~mm-introduce-putback_movable_pages mm/migrate.c
--- a/mm/migrate.c~mm-introduce-putback_movable_pages
+++ a/mm/migrate.c
@@ -80,6 +80,26 @@ void putback_lru_pages(struct list_head 
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
+			putback_lru_page(page);
+	}
+}
+
+/*
+ * Put previously isolated pages back onto the appropriate lists
+ * from where they were once taken off for compaction/migration.
+ *
+ * This function shall be used instead of putback_lru_pages(),
+ * whenever the isolated pageset has been built by isolate_migratepages_range()
+ */
+void putback_movable_pages(struct list_head *l)
+{
+	struct page *page;
+	struct page *page2;
+
+	list_for_each_entry_safe(page, page2, l, lru) {
+		list_del(&page->lru);
+		dec_zone_page_state(page, NR_ISOLATED_ANON +
+				page_is_file_cache(page));
 		if (unlikely(balloon_page_movable(page)))
 			balloon_page_putback(page);
 		else
diff -puN mm/page_alloc.c~mm-introduce-putback_movable_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-putback_movable_pages
+++ a/mm/page_alloc.c
@@ -5797,7 +5797,7 @@ static int __alloc_contig_migrate_range(
 				    0, false, MIGRATE_SYNC);
 	}
 
-	putback_lru_pages(&cc->migratepages);
+	putback_movable_pages(&cc->migratepages);
 	return ret > 0 ? 0 : ret;
 }
 
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-add-vm-event-counters-for-balloon-pages-compaction.patch

