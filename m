From: akpm@linux-foundation.org
Subject: + zsmalloc-zram-introduce-zs_pool_stats-api.patch added to -mm
 tree
Date: Wed, 08 Jul 2015 15:37:58 -0700
Message-ID: <559da646.x2/SmX3yFQtdQkRs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbbGHWh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:37:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc/zram: introduce zs_pool_stats api
has been added to the -mm tree.  Its filename is
     zsmalloc-zram-introduce-zs_pool_stats-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-zram-introduce-zs_pool_stats-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-zram-introduce-zs_pool_stats-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc/zram: introduce zs_pool_stats api

`zs_compact_control' accounts the number of migrated objects but it has a
limited lifespan -- we lose it as soon as zs_compaction() returns back to
zram.  It worked fine, because (a) zram had it's own counter of migrated
objects and (b) only zram could trigger compaction.  However, this does
not work for automatic pool compaction (not issued by zram).  To account
objects migrated during auto-compaction (issued by the shrinker) we need
to store this number in zs_pool.

Define a new `struct zs_pool_stats' structure to keep zs_pool's stats
there.  It provides only `num_migrated', as of this writing, but it surely
can be extended.

A new zsmalloc zs_pool_stats() symbol exports zs_pool's stats back to
caller.

Use zs_pool_stats() in zram and remove `num_migrated' from zram_stats.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 +++++++++------
 drivers/block/zram/zram_drv.h |    1 -
 include/linux/zsmalloc.h      |    6 ++++++
 mm/zsmalloc.c                 |   29 +++++++++++++++--------------
 4 files changed, 30 insertions(+), 21 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zsmalloc-zram-introduce-zs_pool_stats-api drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zsmalloc-zram-introduce-zs_pool_stats-api
+++ a/drivers/block/zram/zram_drv.c
@@ -388,7 +388,6 @@ static ssize_t comp_algorithm_store(stru
 static ssize_t compact_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
-	unsigned long nr_migrated;
 	struct zram *zram = dev_to_zram(dev);
 	struct zram_meta *meta;
 
@@ -399,8 +398,7 @@ static ssize_t compact_store(struct devi
 	}
 
 	meta = zram->meta;
-	nr_migrated = zs_compact(meta->mem_pool);
-	atomic64_add(nr_migrated, &zram->stats.num_migrated);
+	zs_compact(meta->mem_pool);
 	up_read(&zram->init_lock);
 
 	return len;
@@ -428,26 +426,31 @@ static ssize_t mm_stat_show(struct devic
 		struct device_attribute *attr, char *buf)
 {
 	struct zram *zram = dev_to_zram(dev);
+	struct zs_pool_stats pool_stats;
 	u64 orig_size, mem_used = 0;
 	long max_used;
 	ssize_t ret;
 
+	memset(&pool_stats, 0x00, sizeof(struct zs_pool_stats));
+
 	down_read(&zram->init_lock);
-	if (init_done(zram))
+	if (init_done(zram)) {
 		mem_used = zs_get_total_pages(zram->meta->mem_pool);
+		zs_pool_stats(zram->meta->mem_pool, &pool_stats);
+	}
 
 	orig_size = atomic64_read(&zram->stats.pages_stored);
 	max_used = atomic_long_read(&zram->stats.max_used_pages);
 
 	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8lu %8ld %8llu %8llu\n",
+			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu\n",
 			orig_size << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.compr_data_size),
 			mem_used << PAGE_SHIFT,
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.zero_pages),
-			(u64)atomic64_read(&zram->stats.num_migrated));
+			pool_stats.num_migrated);
 	up_read(&zram->init_lock);
 
 	return ret;
diff -puN drivers/block/zram/zram_drv.h~zsmalloc-zram-introduce-zs_pool_stats-api drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zsmalloc-zram-introduce-zs_pool_stats-api
+++ a/drivers/block/zram/zram_drv.h
@@ -78,7 +78,6 @@ struct zram_stats {
 	atomic64_t compr_data_size;	/* compressed size of pages stored */
 	atomic64_t num_reads;	/* failed + successful */
 	atomic64_t num_writes;	/* --do-- */
-	atomic64_t num_migrated;	/* no. of migrated object */
 	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
diff -puN include/linux/zsmalloc.h~zsmalloc-zram-introduce-zs_pool_stats-api include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~zsmalloc-zram-introduce-zs_pool_stats-api
+++ a/include/linux/zsmalloc.h
@@ -34,6 +34,11 @@ enum zs_mapmode {
 	 */
 };
 
+struct zs_pool_stats {
+	/* How many objects were migrated */
+	unsigned long num_migrated;
+};
+
 struct zs_pool;
 
 struct zs_pool *zs_create_pool(char *name, gfp_t flags);
@@ -49,4 +54,5 @@ void zs_unmap_object(struct zs_pool *poo
 unsigned long zs_get_total_pages(struct zs_pool *pool);
 unsigned long zs_compact(struct zs_pool *pool);
 
+void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 #endif
diff -puN mm/zsmalloc.c~zsmalloc-zram-introduce-zs_pool_stats-api mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-zram-introduce-zs_pool_stats-api
+++ a/mm/zsmalloc.c
@@ -245,6 +245,7 @@ struct zs_pool {
 	gfp_t flags;	/* allocation flags used when growing pool */
 	atomic_long_t pages_allocated;
 
+	struct zs_pool_stats stats;
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -1578,7 +1579,7 @@ struct zs_compact_control {
 	 /* Starting object index within @s_page which used for live object
 	  * in the subpage. */
 	int index;
-	/* how many of objects are migrated */
+	/* How many of objects were migrated */
 	int nr_migrated;
 };
 
@@ -1590,7 +1591,6 @@ static int migrate_zspage(struct zs_pool
 	struct page *s_page = cc->s_page;
 	struct page *d_page = cc->d_page;
 	unsigned long index = cc->index;
-	int nr_migrated = 0;
 	int ret = 0;
 
 	while (1) {
@@ -1617,13 +1617,12 @@ static int migrate_zspage(struct zs_pool
 		record_obj(handle, free_obj);
 		unpin_tag(handle);
 		obj_free(pool, class, used_obj);
-		nr_migrated++;
+		cc->nr_migrated++;
 	}
 
 	/* Remember last position in this iteration */
 	cc->s_page = s_page;
 	cc->index = index;
-	cc->nr_migrated = nr_migrated;
 
 	return ret;
 }
@@ -1699,14 +1698,13 @@ static unsigned long zs_can_compact(stru
 	return obj_wasted * get_pages_per_zspage(class->size);
 }
 
-static unsigned long __zs_compact(struct zs_pool *pool,
-				struct size_class *class)
+static void __zs_compact(struct zs_pool *pool, struct size_class *class)
 {
 	struct zs_compact_control cc;
 	struct page *src_page;
 	struct page *dst_page = NULL;
-	unsigned long nr_total_migrated = 0;
 
+	cc.nr_migrated = 0;
 	spin_lock(&class->lock);
 	while ((src_page = isolate_source_page(class))) {
 
@@ -1728,7 +1726,6 @@ static unsigned long __zs_compact(struct
 				break;
 
 			putback_zspage(pool, class, dst_page);
-			nr_total_migrated += cc.nr_migrated;
 		}
 
 		/* Stop if we couldn't find slot */
@@ -1738,7 +1735,6 @@ static unsigned long __zs_compact(struct
 		putback_zspage(pool, class, dst_page);
 		putback_zspage(pool, class, src_page);
 		spin_unlock(&class->lock);
-		nr_total_migrated += cc.nr_migrated;
 		cond_resched();
 		spin_lock(&class->lock);
 	}
@@ -1746,15 +1742,14 @@ static unsigned long __zs_compact(struct
 	if (src_page)
 		putback_zspage(pool, class, src_page);
 
-	spin_unlock(&class->lock);
+	pool->stats.num_migrated += cc.nr_migrated;
 
-	return nr_total_migrated;
+	spin_unlock(&class->lock);
 }
 
 unsigned long zs_compact(struct zs_pool *pool)
 {
 	int i;
-	unsigned long nr_migrated = 0;
 	struct size_class *class;
 
 	for (i = zs_size_classes - 1; i >= 0; i--) {
@@ -1763,13 +1758,19 @@ unsigned long zs_compact(struct zs_pool
 			continue;
 		if (class->index != i)
 			continue;
-		nr_migrated += __zs_compact(pool, class);
+		__zs_compact(pool, class);
 	}
 
-	return nr_migrated;
+	return pool->stats.num_migrated;
 }
 EXPORT_SYMBOL_GPL(zs_compact);
 
+void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats)
+{
+	memcpy(stats, &pool->stats, sizeof(struct zs_pool_stats));
+}
+EXPORT_SYMBOL_GPL(zs_pool_stats);
+
 /**
  * zs_create_pool - Creates an allocation pool to work from.
  * @flags: allocation flags used to allocate pool metadata
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch

