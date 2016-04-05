From: akpm@linux-foundation.org
Subject: [to-be-updated] zsmalloc-migrate-tail-pages-in-zspage.patch
 removed from -mm tree
Date: Tue, 05 Apr 2016 14:14:24 -0700
Message-ID: <57042ab0.cFhT34LM/4bohpKM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760143AbcDEVO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: migrate tail pages in zspage
has been removed from the -mm tree.  Its filename was
     zsmalloc-migrate-tail-pages-in-zspage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: migrate tail pages in zspage

This patch enables tail page migration of zspage.

In this point, I tested zsmalloc regression with micro-benchmark which
does zs_malloc/map/unmap/zs_free for all size class in every CPU(my system
is 12) during 20 sec.

It shows 1% regression which is really small when we consider the benefit
of this feature and realworkload overhead(i.e., most overhead comes from
compression).

Signed-off-by: Minchan Kim <minchan@kernel.org>Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Russ Knize <rknize@motorola.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: YiPing Xu <xuyiping@hisilicon.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  129 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 114 insertions(+), 15 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-migrate-tail-pages-in-zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-migrate-tail-pages-in-zspage
+++ a/mm/zsmalloc.c
@@ -551,6 +551,19 @@ static void set_zspage_mapping(struct pa
 	m->class = class_idx;
 }
 
+static bool check_isolated_page(struct page *first_page)
+{
+	struct page *cursor;
+
+	for (cursor = first_page; cursor != NULL; cursor =
+					get_next_page(cursor)) {
+		if (PageIsolated(cursor))
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * zsmalloc divides the pool into various size classes where each
  * class maintains a list of zspages where each zspage is divided
@@ -1052,6 +1065,44 @@ void lock_zspage(struct page *first_page
 	} while ((cursor = get_next_page(cursor)) != NULL);
 }
 
+int trylock_zspage(struct page *first_page, struct page *locked_page)
+{
+	struct page *cursor, *fail;
+
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
+
+	for (cursor = first_page; cursor != NULL; cursor =
+			get_next_page(cursor)) {
+		if (cursor != locked_page) {
+			if (!trylock_page(cursor)) {
+				fail = cursor;
+				goto unlock;
+			}
+		}
+	}
+
+	return 1;
+unlock:
+	for (cursor = first_page; cursor != fail; cursor =
+			get_next_page(cursor)) {
+		if (cursor != locked_page)
+			unlock_page(cursor);
+	}
+
+	return 0;
+}
+
+void unlock_zspage(struct page *first_page, struct page *locked_page)
+{
+	struct page *cursor = first_page;
+
+	for (; cursor != NULL; cursor = get_next_page(cursor)) {
+		VM_BUG_ON_PAGE(!PageLocked(cursor), cursor);
+		if (cursor != locked_page)
+			unlock_page(cursor);
+	}
+}
+
 static void free_zspage(struct zs_pool *pool, struct page *first_page)
 {
 	struct page *nextp, *tmp;
@@ -1090,15 +1141,16 @@ static void init_zspage(struct size_clas
 	first_page->freelist = NULL;
 	INIT_LIST_HEAD(&first_page->lru);
 	set_zspage_inuse(first_page, 0);
-	BUG_ON(!trylock_page(first_page));
-	__SetPageMovable(first_page, mapping);
-	unlock_page(first_page);
 
 	while (page) {
 		struct page *next_page;
 		struct link_free *link;
 		void *vaddr;
 
+		BUG_ON(!trylock_page(page));
+		__SetPageMovable(page, mapping);
+		unlock_page(page);
+
 		vaddr = kmap_atomic(page);
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
@@ -1848,6 +1900,7 @@ static enum fullness_group putback_zspag
 
 	VM_BUG_ON_PAGE(!list_empty(&first_page->lru), first_page);
 	VM_BUG_ON_PAGE(ZsPageIsolate(first_page), first_page);
+	VM_BUG_ON_PAGE(check_isolated_page(first_page), first_page);
 
 	fullness = get_fullness_group(class, first_page);
 	insert_zspage(class, fullness, first_page);
@@ -1954,6 +2007,12 @@ static struct page *isolate_source_page(
 		if (!page)
 			continue;
 
+		/* To prevent race between object and page migration */
+		if (!trylock_zspage(page, NULL)) {
+			page = NULL;
+			continue;
+		}
+
 		remove_zspage(class, i, page);
 
 		inuse = get_zspage_inuse(page);
@@ -1962,6 +2021,7 @@ static struct page *isolate_source_page(
 		if (inuse != freezed) {
 			unfreeze_zspage(class, page, freezed);
 			putback_zspage(class, page);
+			unlock_zspage(page, NULL);
 			page = NULL;
 			continue;
 		}
@@ -1993,6 +2053,12 @@ static struct page *isolate_target_page(
 		if (!page)
 			continue;
 
+		/* To prevent race between object and page migration */
+		if (!trylock_zspage(page, NULL)) {
+			page = NULL;
+			continue;
+		}
+
 		remove_zspage(class, i, page);
 
 		inuse = get_zspage_inuse(page);
@@ -2001,6 +2067,7 @@ static struct page *isolate_target_page(
 		if (inuse != freezed) {
 			unfreeze_zspage(class, page, freezed);
 			putback_zspage(class, page);
+			unlock_zspage(page, NULL);
 			page = NULL;
 			continue;
 		}
@@ -2074,11 +2141,13 @@ static void __zs_compact(struct zs_pool
 			putback_zspage(class, dst_page);
 			unfreeze_zspage(class, dst_page,
 				class->objs_per_zspage);
+			unlock_zspage(dst_page, NULL);
 			spin_unlock(&class->lock);
 			dst_page = NULL;
 		}
 
 		if (zspage_empty(class, src_page)) {
+			unlock_zspage(src_page, NULL);
 			free_zspage(pool, src_page);
 			spin_lock(&class->lock);
 			zs_stat_dec(class, OBJ_ALLOCATED,
@@ -2101,12 +2170,14 @@ static void __zs_compact(struct zs_pool
 		putback_zspage(class, src_page);
 		unfreeze_zspage(class, src_page,
 				class->objs_per_zspage);
+		unlock_zspage(src_page, NULL);
 	}
 
 	if (dst_page) {
 		putback_zspage(class, dst_page);
 		unfreeze_zspage(class, dst_page,
 				class->objs_per_zspage);
+		unlock_zspage(dst_page, NULL);
 	}
 
 	spin_unlock(&class->lock);
@@ -2209,10 +2280,11 @@ bool zs_page_isolate(struct page *page,
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 	/*
-	 * In this implementation, it allows only first page migration.
+	 * first_page will not be destroyed by PG_lock of @page but it could
+	 * be migrated out. For prohibiting it, zs_page_migrate calls
+	 * trylock_zspage so it closes the race.
 	 */
-	VM_BUG_ON_PAGE(!is_first_page(page), page);
-	first_page = page;
+	first_page = get_first_page(page);
 
 	/*
 	 * Without class lock, fullness is meaningless while constant
@@ -2226,9 +2298,18 @@ bool zs_page_isolate(struct page *page,
 	if (!spin_trylock(&class->lock))
 		return false;
 
+	if (check_isolated_page(first_page))
+		goto skip_isolate;
+
+	/*
+	 * If this is first time isolation for zspage, isolate zspage from
+	 * size_class to prevent further allocations from the zspage.
+	 */
 	get_zspage_mapping(first_page, &class_idx, &fullness);
 	remove_zspage(class, fullness, first_page);
 	SetZsPageIsolate(first_page);
+
+skip_isolate:
 	SetPageIsolated(page);
 	spin_unlock(&class->lock);
 
@@ -2251,7 +2332,7 @@ int zs_page_migrate(struct address_space
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
-	first_page = page;
+	first_page = get_first_page(page);
 	get_zspage_mapping(first_page, &class_idx, &fullness);
 	pool = page->mapping->private_data;
 	class = pool->size_class[class_idx];
@@ -2266,6 +2347,13 @@ int zs_page_migrate(struct address_space
 	if (get_zspage_inuse(first_page) == 0)
 		goto out_class_unlock;
 
+	/*
+	 * It prevents first_page migration during tail page opeartion for
+	 * get_first_page's stability.
+	 */
+	if (!trylock_zspage(first_page, page))
+		goto out_class_unlock;
+
 	freezed = freeze_zspage(class, first_page);
 	if (freezed != get_zspage_inuse(first_page))
 		goto out_unfreeze;
@@ -2304,21 +2392,26 @@ int zs_page_migrate(struct address_space
 	kunmap_atomic(addr);
 
 	replace_sub_page(class, first_page, newpage, page);
-	first_page = newpage;
+	first_page = get_first_page(newpage);
 	get_page(newpage);
 	VM_BUG_ON_PAGE(get_fullness_group(class, first_page) ==
 			ZS_EMPTY, first_page);
-	ClearZsPageIsolate(first_page);
-	putback_zspage(class, first_page);
+	if (!check_isolated_page(first_page)) {
+		INIT_LIST_HEAD(&first_page->lru);
+		ClearZsPageIsolate(first_page);
+		putback_zspage(class, first_page);
+	}
+
 
 	/* Migration complete. Free old page */
 	ClearPageIsolated(page);
 	reset_page(page);
 	put_page(page);
 	ret = MIGRATEPAGE_SUCCESS;
-
+	page = newpage;
 out_unfreeze:
 	unfreeze_zspage(class, first_page, freezed);
+	unlock_zspage(first_page, page);
 out_class_unlock:
 	spin_unlock(&class->lock);
 
@@ -2336,7 +2429,7 @@ void zs_page_putback(struct page *page)
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
-	first_page = page;
+	first_page = get_first_page(page);
 	get_zspage_mapping(first_page, &class_idx, &fullness);
 	pool = page->mapping->private_data;
 	class = pool->size_class[class_idx];
@@ -2346,11 +2439,17 @@ void zs_page_putback(struct page *page)
 	 * in zs_free will wait the page lock of @page without
 	 * destroying of zspage.
 	 */
-	INIT_LIST_HEAD(&first_page->lru);
 	spin_lock(&class->lock);
 	ClearPageIsolated(page);
-	ClearZsPageIsolate(first_page);
-	putback_zspage(class, first_page);
+	/*
+	 * putback zspage to right list if this is last isolated page
+	 * putback in the zspage.
+	 */
+	if (!check_isolated_page(first_page)) {
+		INIT_LIST_HEAD(&first_page->lru);
+		ClearZsPageIsolate(first_page);
+		putback_zspage(class, first_page);
+	}
 	spin_unlock(&class->lock);
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zram-use-__gfp_movable-for-memory-allocation.patch

