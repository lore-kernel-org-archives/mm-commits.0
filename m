From: akpm@linux-foundation.org
Subject: [wrecked] mm-zsmalloc-add-per-class-compact-trace-event.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 16:19:07 -0700
Message-ID: <57fec4eb.AJZDp0OlLU1nWpaM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40671 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932975AbcJLXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 19:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: add per-class compact trace event
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-per-class-compact-trace-event.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: add per-class compact trace event

add per-class compact trace event to get number of migrated objects
and number of freed pages.

trace log is like below:

            bash-3863  [001] ....   141.791366: zs_compact_start: pool zram0
            bash-3863  [001] ....   141.791372: zs_compact: class 254: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791375: zs_compact: class 202: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791385: zs_compact: class 190: 1 objects migrated, 3 pages freed
            bash-3863  [001] ....   141.791393: zs_compact: class 168: 2 objects migrated, 2 pages freed
            bash-3863  [001] ....   141.791396: zs_compact: class 151: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791407: zs_compact: class 144: 5 objects migrated, 4 pages freed
            bash-3863  [001] ....   141.791427: zs_compact: class 126: 8 objects migrated, 8 pages freed
            bash-3863  [001] ....   141.791433: zs_compact: class 111: 1 objects migrated, 4 pages freed
            bash-3863  [001] ....   141.791459: zs_compact: class 107: 18 objects migrated, 12 pages freed
            bash-3863  [001] ....   141.791487: zs_compact: class 100: 18 objects migrated, 16 pages freed
            bash-3863  [001] ....   141.791509: zs_compact: class  94: 18 objects migrated, 9 pages freed
            bash-3863  [001] ....   141.791560: zs_compact: class  91: 44 objects migrated, 24 pages freed
            bash-3863  [001] ....   141.791605: zs_compact: class  83: 35 objects migrated, 20 pages freed
            bash-3863  [001] ....   141.791616: zs_compact: class  76: 8 objects migrated, 4 pages freed
            bash-3863  [001] ....   141.791644: zs_compact: class  74: 21 objects migrated, 9 pages freed
            bash-3863  [001] ....   141.791665: zs_compact: class  71: 18 objects migrated, 10 pages freed
            bash-3863  [001] ....   141.791736: zs_compact: class  67: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791763: zs_compact: class  66: 22 objects migrated, 8 pages freed
            bash-3863  [001] ....   141.791820: zs_compact: class  62: 18 objects migrated, 6 pages freed
            bash-3863  [001] ....   141.791826: zs_compact: class  58: 1 objects migrated, 4 pages freed
            bash-3863  [001] ....   141.791829: zs_compact: class  57: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791834: zs_compact: class  54: 2 objects migrated, 2 pages freed
...
            bash-3863  [001] ....   141.791952: zs_compact: class   4: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791964: zs_compact: class   3: 14 objects migrated, 1 pages freed
            bash-3863  [001] ....   141.791966: zs_compact: class   2: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791968: zs_compact: class   1: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791971: zs_compact: class   0: 0 objects migrated, 0 pages freed
            bash-3863  [001] ....   141.791973: zs_compact_end: pool zram0: 155 pages compacted


Also this patch changes trace_zsmalloc_compact_start[end] to
trace_zs_compact_start[end] to keep function naming consistent with others
in zsmalloc.

Link: http://lkml.kernel.org/r/1467882338-4300-8-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/zsmalloc.h |   40 ++++++++++++++++++++++--------
 mm/zsmalloc.c                   |   25 ++++++++++++------
 2 files changed, 47 insertions(+), 18 deletions(-)

diff -puN include/trace/events/zsmalloc.h~mm-zsmalloc-add-per-class-compact-trace-event include/trace/events/zsmalloc.h
--- a/include/trace/events/zsmalloc.h~mm-zsmalloc-add-per-class-compact-trace-event
+++ a/include/trace/events/zsmalloc.h
@@ -7,7 +7,7 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(zsmalloc_compact_start,
+TRACE_EVENT(zs_compact_start,
 
 	TP_PROTO(const char *pool_name),
 
@@ -25,29 +25,49 @@ TRACE_EVENT(zsmalloc_compact_start,
 		  __entry->pool_name)
 );
 
-TRACE_EVENT(zsmalloc_compact_end,
+TRACE_EVENT(zs_compact_end,
 
-	TP_PROTO(const char *pool_name, unsigned long pages_compacted,
-			unsigned long pages_total_compacted),
+	TP_PROTO(const char *pool_name, unsigned long pages_compacted),
 
-	TP_ARGS(pool_name, pages_compacted, pages_total_compacted),
+	TP_ARGS(pool_name, pages_compacted),
 
 	TP_STRUCT__entry(
 		__field(const char *, pool_name)
 		__field(unsigned long, pages_compacted)
-		__field(unsigned long, pages_total_compacted)
 	),
 
 	TP_fast_assign(
 		__entry->pool_name = pool_name;
 		__entry->pages_compacted = pages_compacted;
-		__entry->pages_total_compacted = pages_total_compacted;
 	),
 
-	TP_printk("pool %s: %ld pages compacted(total %ld)",
+	TP_printk("pool %s: %ld pages compacted",
 		  __entry->pool_name,
-		  __entry->pages_compacted,
-		  __entry->pages_total_compacted)
+		  __entry->pages_compacted)
+);
+
+TRACE_EVENT(zs_compact,
+
+	TP_PROTO(int class, unsigned long nr_migrated_obj, unsigned long nr_freed_pages),
+
+	TP_ARGS(class, nr_migrated_obj, nr_freed_pages),
+
+	TP_STRUCT__entry(
+		__field(int, class)
+		__field(unsigned long, nr_migrated_obj)
+		__field(unsigned long, nr_freed_pages)
+	),
+
+	TP_fast_assign(
+		__entry->class = class;
+		__entry->nr_migrated_obj = nr_migrated_obj;
+		__entry->nr_freed_pages = nr_freed_pages;
+	),
+
+	TP_printk("class %3d: %ld objects migrated, %ld pages freed",
+		  __entry->class,
+		  __entry->nr_migrated_obj,
+		  __entry->nr_freed_pages)
 );
 
 #endif /* _TRACE_ZSMALLOC_H */
diff -puN mm/zsmalloc.c~mm-zsmalloc-add-per-class-compact-trace-event mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-add-per-class-compact-trace-event
+++ a/mm/zsmalloc.c
@@ -1770,9 +1770,12 @@ struct zs_compact_control {
 	/* Destination page for migration which should be a first page
 	 * of zspage. */
 	struct page *d_page;
-	 /* Starting object index within @s_page which used for live object
-	  * in the subpage. */
+	/* Starting object index within @s_page which used for live object
+	 * in the subpage. */
 	int obj_idx;
+
+	unsigned long nr_migrated_obj;
+	unsigned long nr_freed_pages;
 };
 
 static int migrate_zspage(struct zs_pool *pool, struct size_class *class,
@@ -1806,6 +1809,7 @@ static int migrate_zspage(struct zs_pool
 		free_obj = obj_malloc(class, get_zspage(d_page), handle);
 		zs_object_copy(class, free_obj, used_obj);
 		obj_idx++;
+		cc->nr_migrated_obj++;
 		/*
 		 * record_obj updates handle's value to free_obj and it will
 		 * invalidate lock bit(ie, HANDLE_PIN_BIT) of handle, which
@@ -2263,7 +2267,10 @@ static unsigned long zs_can_compact(stru
 
 static void __zs_compact(struct zs_pool *pool, struct size_class *class)
 {
-	struct zs_compact_control cc;
+	struct zs_compact_control cc = {
+		.nr_migrated_obj = 0,
+		.nr_freed_pages = 0,
+	};
 	struct zspage *src_zspage;
 	struct zspage *dst_zspage = NULL;
 
@@ -2295,7 +2302,7 @@ static void __zs_compact(struct zs_pool
 		putback_zspage(class, dst_zspage);
 		if (putback_zspage(class, src_zspage) == ZS_EMPTY) {
 			free_zspage(pool, class, src_zspage);
-			pool->stats.pages_compacted += class->pages_per_zspage;
+			cc.nr_freed_pages += class->pages_per_zspage;
 		}
 		spin_unlock(&class->lock);
 		cond_resched();
@@ -2306,6 +2313,9 @@ static void __zs_compact(struct zs_pool
 		putback_zspage(class, src_zspage);
 
 	spin_unlock(&class->lock);
+
+	pool->stats.pages_compacted += cc.nr_freed_pages;
+	trace_zs_compact(class->index, cc.nr_migrated_obj, cc.nr_freed_pages);
 }
 
 unsigned long zs_compact(struct zs_pool *pool)
@@ -2314,7 +2324,7 @@ unsigned long zs_compact(struct zs_pool
 	struct size_class *class;
 	unsigned long pages_compacted_before = pool->stats.pages_compacted;
 
-	trace_zsmalloc_compact_start(pool->name);
+	trace_zs_compact_start(pool->name);
 
 	for (i = zs_size_classes - 1; i >= 0; i--) {
 		class = pool->size_class[i];
@@ -2325,9 +2335,8 @@ unsigned long zs_compact(struct zs_pool
 		__zs_compact(pool, class);
 	}
 
-	trace_zsmalloc_compact_end(pool->name,
-		pool->stats.pages_compacted - pages_compacted_before,
-		pool->stats.pages_compacted);
+	trace_zs_compact_end(pool->name,
+		pool->stats.pages_compacted - pages_compacted_before);
 
 	return pool->stats.pages_compacted;
 }
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are


