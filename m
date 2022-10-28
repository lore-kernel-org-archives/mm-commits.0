Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91777ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiJ1Vkj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiJ1Vke (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:40:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718B51CDCDE
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D69FEB82899
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9BCC433B5;
        Fri, 28 Oct 2022 21:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666993230;
        bh=fMQNNNqfjfAIZRl2i7jOxB46LdWFTgjIoqtqHVEoTso=;
        h=Date:To:From:Subject:From;
        b=VbuEdVS4qT9f3snZGTvN3jMbmZ0Uq+PqJoG/n++vqEXpne6st3xRnahbtk/QewnnD
         QuERNQh277grOWO1uOFM4gPAg787dHRbWB337jFmzHIQuF/ZcIpGUyRdXP2cIMtMyk
         KMcqRRgxRyTGdras7w6UVWWrYr3XwW/adWq2rrMU=
Date:   Fri, 28 Oct 2022 14:40:29 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch added to mm-unstable branch
Message-Id: <20221028214030.6C9BCC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: consolidate zs_pool's migrate_lock and size_class's locks
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zsmalloc: consolidate zs_pool's migrate_lock and size_class's locks
Date: Wed, 26 Oct 2022 13:06:10 -0700

Currently, zsmalloc has a hierarchy of locks, which includes a pool-level
migrate_lock, and a lock for each size class.  We have to obtain both
locks in the hotpath in most cases anyway, except for zs_malloc.  This
exception will no longer exist when we introduce a LRU into the zs_pool
for the new writeback functionality - we will need to obtain a pool-level
lock to synchronize LRU handling even in zs_malloc.

In preparation for zsmalloc writeback, consolidate these locks into a
single pool-level lock, which drastically reduces the complexity of
synchronization in zsmalloc.

Link: https://lkml.kernel.org/r/20221026200613.1031261-3-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks
+++ a/mm/zsmalloc.c
@@ -33,8 +33,7 @@
 /*
  * lock ordering:
  *	page_lock
- *	pool->migrate_lock
- *	class->lock
+ *	pool->lock
  *	zspage->lock
  */
 
@@ -180,7 +179,6 @@ static struct dentry *zs_stat_root;
 static const int fullness_threshold_frac = 4;
 
 struct size_class {
-	spinlock_t lock;
 	struct list_head fullness_list[NR_ZS_FULLNESS];
 	/*
 	 * Size of objects stored in this class. Must be multiple
@@ -239,8 +237,7 @@ struct zs_pool {
 #ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
 #endif
-	/* protect page/zspage migration */
-	rwlock_t migrate_lock;
+	spinlock_t lock;
 };
 
 struct zspage {
@@ -347,7 +344,7 @@ static void cache_free_zspage(struct zs_
 	kmem_cache_free(pool->zspage_cachep, zspage);
 }
 
-/* class->lock(which owns the handle) synchronizes races */
+/* pool->lock(which owns the handle) synchronizes races */
 static void record_obj(unsigned long handle, unsigned long obj)
 {
 	*(unsigned long *)handle = obj;
@@ -444,7 +441,7 @@ static __maybe_unused int is_first_page(
 	return PagePrivate(page);
 }
 
-/* Protected by class->lock */
+/* Protected by pool->lock */
 static inline int get_zspage_inuse(struct zspage *zspage)
 {
 	return zspage->inuse;
@@ -589,13 +586,13 @@ static int zs_stats_size_show(struct seq
 		if (class->index != i)
 			continue;
 
-		spin_lock(&class->lock);
+		spin_lock(&pool->lock);
 		class_almost_full = zs_stat_get(class, CLASS_ALMOST_FULL);
 		class_almost_empty = zs_stat_get(class, CLASS_ALMOST_EMPTY);
 		obj_allocated = zs_stat_get(class, OBJ_ALLOCATED);
 		obj_used = zs_stat_get(class, OBJ_USED);
 		freeable = zs_can_compact(class);
-		spin_unlock(&class->lock);
+		spin_unlock(&pool->lock);
 
 		objs_per_zspage = class->objs_per_zspage;
 		pages_used = obj_allocated / objs_per_zspage *
@@ -911,7 +908,7 @@ static void __free_zspage(struct zs_pool
 
 	get_zspage_mapping(zspage, &class_idx, &fg);
 
-	assert_spin_locked(&class->lock);
+	assert_spin_locked(&pool->lock);
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(fg != ZS_EMPTY);
@@ -1263,19 +1260,19 @@ void *zs_map_object(struct zs_pool *pool
 	BUG_ON(in_interrupt());
 
 	/* It guarantees it can get zspage from handle safely */
-	read_lock(&pool->migrate_lock);
+	spin_lock(&pool->lock);
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &page, &obj_idx);
 	zspage = get_zspage(page);
 
 	/*
-	 * migration cannot move any zpages in this zspage. Here, class->lock
+	 * migration cannot move any zpages in this zspage. Here, pool->lock
 	 * is too heavy since callers would take some time until they calls
 	 * zs_unmap_object API so delegate the locking from class to zspage
 	 * which is smaller granularity.
 	 */
 	migrate_read_lock(zspage);
-	read_unlock(&pool->migrate_lock);
+	spin_unlock(&pool->lock);
 
 	class = zspage_class(pool, zspage);
 	off = (class->size * obj_idx) & ~PAGE_MASK;
@@ -1428,8 +1425,8 @@ unsigned long zs_malloc(struct zs_pool *
 	size += ZS_HANDLE_SIZE;
 	class = pool->size_class[get_size_class_index(pool, size)];
 
-	/* class->lock effectively protects the zpage migration */
-	spin_lock(&class->lock);
+	/* pool->lock effectively protects the zpage migration */
+	spin_lock(&pool->lock);
 	zspage = find_get_zspage(class);
 	if (likely(zspage)) {
 		obj = obj_malloc(pool, zspage, handle);
@@ -1437,12 +1434,12 @@ unsigned long zs_malloc(struct zs_pool *
 		fix_fullness_group(class, zspage);
 		record_obj(handle, obj);
 		class_stat_inc(class, OBJ_USED, 1);
-		spin_unlock(&class->lock);
+		spin_unlock(&pool->lock);
 
 		return handle;
 	}
 
-	spin_unlock(&class->lock);
+	spin_unlock(&pool->lock);
 
 	zspage = alloc_zspage(pool, class, gfp);
 	if (!zspage) {
@@ -1450,7 +1447,7 @@ unsigned long zs_malloc(struct zs_pool *
 		return (unsigned long)ERR_PTR(-ENOMEM);
 	}
 
-	spin_lock(&class->lock);
+	spin_lock(&pool->lock);
 	obj = obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
@@ -1463,7 +1460,7 @@ unsigned long zs_malloc(struct zs_pool *
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
-	spin_unlock(&class->lock);
+	spin_unlock(&pool->lock);
 
 	return handle;
 }
@@ -1507,16 +1504,14 @@ void zs_free(struct zs_pool *pool, unsig
 		return;
 
 	/*
-	 * The pool->migrate_lock protects the race with zpage's migration
+	 * The pool->lock protects the race with zpage's migration
 	 * so it's safe to get the page from handle.
 	 */
-	read_lock(&pool->migrate_lock);
+	spin_lock(&pool->lock);
 	obj = handle_to_obj(handle);
 	obj_to_page(obj, &f_page);
 	zspage = get_zspage(f_page);
 	class = zspage_class(pool, zspage);
-	spin_lock(&class->lock);
-	read_unlock(&pool->migrate_lock);
 
 	obj_free(class->size, obj);
 	class_stat_dec(class, OBJ_USED, 1);
@@ -1526,7 +1521,7 @@ void zs_free(struct zs_pool *pool, unsig
 
 	free_zspage(pool, class, zspage);
 out:
-	spin_unlock(&class->lock);
+	spin_unlock(&pool->lock);
 	cache_free_handle(pool, handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
@@ -1883,16 +1878,12 @@ static int zs_page_migrate(struct page *
 	pool = zspage->pool;
 
 	/*
-	 * The pool migrate_lock protects the race between zpage migration
+	 * The pool's lock protects the race between zpage migration
 	 * and zs_free.
 	 */
-	write_lock(&pool->migrate_lock);
+	spin_lock(&pool->lock);
 	class = zspage_class(pool, zspage);
 
-	/*
-	 * the class lock protects zpage alloc/free in the zspage.
-	 */
-	spin_lock(&class->lock);
 	/* the migrate_write_lock protects zpage access via zs_map_object */
 	migrate_write_lock(zspage);
 
@@ -1922,10 +1913,9 @@ static int zs_page_migrate(struct page *
 	replace_sub_page(class, zspage, newpage, page);
 	/*
 	 * Since we complete the data copy and set up new zspage structure,
-	 * it's okay to release migration_lock.
+	 * it's okay to release the pool's lock.
 	 */
-	write_unlock(&pool->migrate_lock);
-	spin_unlock(&class->lock);
+	spin_unlock(&pool->lock);
 	dec_zspage_isolation(zspage);
 	migrate_write_unlock(zspage);
 
@@ -1980,9 +1970,9 @@ static void async_free_zspage(struct wor
 		if (class->index != i)
 			continue;
 
-		spin_lock(&class->lock);
+		spin_lock(&pool->lock);
 		list_splice_init(&class->fullness_list[ZS_EMPTY], &free_pages);
-		spin_unlock(&class->lock);
+		spin_unlock(&pool->lock);
 	}
 
 	list_for_each_entry_safe(zspage, tmp, &free_pages, list) {
@@ -1992,9 +1982,9 @@ static void async_free_zspage(struct wor
 		get_zspage_mapping(zspage, &class_idx, &fullness);
 		VM_BUG_ON(fullness != ZS_EMPTY);
 		class = pool->size_class[class_idx];
-		spin_lock(&class->lock);
+		spin_lock(&pool->lock);
 		__free_zspage(pool, class, zspage);
-		spin_unlock(&class->lock);
+		spin_unlock(&pool->lock);
 	}
 };
 
@@ -2055,10 +2045,11 @@ static unsigned long __zs_compact(struct
 	struct zspage *dst_zspage = NULL;
 	unsigned long pages_freed = 0;
 
-	/* protect the race between zpage migration and zs_free */
-	write_lock(&pool->migrate_lock);
-	/* protect zpage allocation/free */
-	spin_lock(&class->lock);
+	/*
+	 * protect the race between zpage migration and zs_free
+	 * as well as zpage allocation/free
+	 */
+	spin_lock(&pool->lock);
 	while ((src_zspage = isolate_zspage(class, true))) {
 		/* protect someone accessing the zspage(i.e., zs_map_object) */
 		migrate_write_lock(src_zspage);
@@ -2083,7 +2074,7 @@ static unsigned long __zs_compact(struct
 			putback_zspage(class, dst_zspage);
 			migrate_write_unlock(dst_zspage);
 			dst_zspage = NULL;
-			if (rwlock_is_contended(&pool->migrate_lock))
+			if (spin_is_contended(&pool->lock))
 				break;
 		}
 
@@ -2100,11 +2091,9 @@ static unsigned long __zs_compact(struct
 			pages_freed += class->pages_per_zspage;
 		} else
 			migrate_write_unlock(src_zspage);
-		spin_unlock(&class->lock);
-		write_unlock(&pool->migrate_lock);
+		spin_unlock(&pool->lock);
 		cond_resched();
-		write_lock(&pool->migrate_lock);
-		spin_lock(&class->lock);
+		spin_lock(&pool->lock);
 	}
 
 	if (src_zspage) {
@@ -2112,8 +2101,7 @@ static unsigned long __zs_compact(struct
 		migrate_write_unlock(src_zspage);
 	}
 
-	spin_unlock(&class->lock);
-	write_unlock(&pool->migrate_lock);
+	spin_unlock(&pool->lock);
 
 	return pages_freed;
 }
@@ -2236,7 +2224,7 @@ struct zs_pool *zs_create_pool(const cha
 		goto err;
 
 	init_deferred_free(pool);
-	rwlock_init(&pool->migrate_lock);
+	spin_lock_init(&pool->lock);
 
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
@@ -2308,7 +2296,6 @@ struct zs_pool *zs_create_pool(const cha
 		class->index = i;
 		class->pages_per_zspage = pages_per_zspage;
 		class->objs_per_zspage = objs_per_zspage;
-		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
 		for (fullness = ZS_EMPTY; fullness < NR_ZS_FULLNESS;
 							fullness++)
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch
zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

