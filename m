Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1299FEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjFSXZv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjFSXXv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CFC199A
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEEE260FD7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFB8C433C8;
        Mon, 19 Jun 2023 23:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216970;
        bh=GdSokrFC6pvaNhhwHW6A2h5Hdx82NgyWwkRDEa6dvuY=;
        h=Date:To:From:Subject:From;
        b=UVuOTfWnxaYcuvUfMMSW+qy5TeLTq+xal1vQgAaDm27NEhH9o4T88p6bXHcaRqosQ
         D6WsJdnerrXYoMnHloUQ5bET9JhrJY5p78oLM7H+v8XN7JTuTr+rDvDc/AUStf2tL2
         0hAATmBvsBvGBUp2E/HmuqlWxDLXoddxf0aQcWs0=
Date:   Mon, 19 Jun 2023 16:22:49 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-shrink-from-zpool-interface.patch removed from -mm tree
Message-Id: <20230619232250.1FFB8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: remove shrink from zpool interface
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-shrink-from-zpool-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: remove shrink from zpool interface
Date: Mon, 12 Jun 2023 11:38:13 +0200

Now that all three zswap backends have removed their shrink code, it is
no longer necessary for the zpool interface to include shrink/writeback
endpoints.

Link: https://lkml.kernel.org/r/20230612093815.133504-6-cerasuolodomenico@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |   20 +---------------
 mm/z3fold.c           |    4 ---
 mm/zbud.c             |    4 ---
 mm/zpool.c            |   48 +---------------------------------------
 mm/zsmalloc.c         |    4 ---
 mm/zswap.c            |   27 +++++-----------------
 6 files changed, 14 insertions(+), 93 deletions(-)

--- a/include/linux/zpool.h~mm-zswap-remove-shrink-from-zpool-interface
+++ a/include/linux/zpool.h
@@ -14,10 +14,6 @@
 
 struct zpool;
 
-struct zpool_ops {
-	int (*evict)(struct zpool *pool, unsigned long handle);
-};
-
 /*
  * Control how a handle is mapped.  It will be ignored if the
  * implementation does not support it.  Its use is optional.
@@ -39,8 +35,7 @@ enum zpool_mapmode {
 
 bool zpool_has_pool(char *type);
 
-struct zpool *zpool_create_pool(const char *type, const char *name,
-			gfp_t gfp, const struct zpool_ops *ops);
+struct zpool *zpool_create_pool(const char *type, const char *name, gfp_t gfp);
 
 const char *zpool_get_type(struct zpool *pool);
 
@@ -53,9 +48,6 @@ int zpool_malloc(struct zpool *pool, siz
 
 void zpool_free(struct zpool *pool, unsigned long handle);
 
-int zpool_shrink(struct zpool *pool, unsigned int pages,
-			unsigned int *reclaimed);
-
 void *zpool_map_handle(struct zpool *pool, unsigned long handle,
 			enum zpool_mapmode mm);
 
@@ -72,7 +64,6 @@ u64 zpool_get_total_size(struct zpool *p
  * @destroy:	destroy a pool.
  * @malloc:	allocate mem from a pool.
  * @free:	free mem from a pool.
- * @shrink:	shrink the pool.
  * @sleep_mapped: whether zpool driver can sleep during map.
  * @map:	map a handle.
  * @unmap:	unmap a handle.
@@ -87,10 +78,7 @@ struct zpool_driver {
 	atomic_t refcount;
 	struct list_head list;
 
-	void *(*create)(const char *name,
-			gfp_t gfp,
-			const struct zpool_ops *ops,
-			struct zpool *zpool);
+	void *(*create)(const char *name, gfp_t gfp);
 	void (*destroy)(void *pool);
 
 	bool malloc_support_movable;
@@ -98,9 +86,6 @@ struct zpool_driver {
 				unsigned long *handle);
 	void (*free)(void *pool, unsigned long handle);
 
-	int (*shrink)(void *pool, unsigned int pages,
-				unsigned int *reclaimed);
-
 	bool sleep_mapped;
 	void *(*map)(void *pool, unsigned long handle,
 				enum zpool_mapmode mm);
@@ -113,7 +98,6 @@ void zpool_register_driver(struct zpool_
 
 int zpool_unregister_driver(struct zpool_driver *driver);
 
-bool zpool_evictable(struct zpool *pool);
 bool zpool_can_sleep_mapped(struct zpool *pool);
 
 #endif
--- a/mm/z3fold.c~mm-zswap-remove-shrink-from-zpool-interface
+++ a/mm/z3fold.c
@@ -1364,9 +1364,7 @@ static const struct movable_operations z
  * zpool
  ****************/
 
-static void *z3fold_zpool_create(const char *name, gfp_t gfp,
-			       const struct zpool_ops *zpool_ops,
-			       struct zpool *zpool)
+static void *z3fold_zpool_create(const char *name, gfp_t gfp)
 {
 	return z3fold_create_pool(name, gfp);
 }
--- a/mm/zbud.c~mm-zswap-remove-shrink-from-zpool-interface
+++ a/mm/zbud.c
@@ -380,9 +380,7 @@ static u64 zbud_get_pool_size(struct zbu
  * zpool
  ****************/
 
-static void *zbud_zpool_create(const char *name, gfp_t gfp,
-			       const struct zpool_ops *zpool_ops,
-			       struct zpool *zpool)
+static void *zbud_zpool_create(const char *name, gfp_t gfp)
 {
 	return zbud_create_pool(gfp);
 }
--- a/mm/zpool.c~mm-zswap-remove-shrink-from-zpool-interface
+++ a/mm/zpool.c
@@ -133,7 +133,6 @@ EXPORT_SYMBOL(zpool_has_pool);
  * @type:	The type of the zpool to create (e.g. zbud, zsmalloc)
  * @name:	The name of the zpool (e.g. zram0, zswap)
  * @gfp:	The GFP flags to use when allocating the pool.
- * @ops:	The optional ops callback.
  *
  * This creates a new zpool of the specified type.  The gfp flags will be
  * used when allocating memory, if the implementation supports it.  If the
@@ -145,8 +144,7 @@ EXPORT_SYMBOL(zpool_has_pool);
  *
  * Returns: New zpool on success, NULL on failure.
  */
-struct zpool *zpool_create_pool(const char *type, const char *name, gfp_t gfp,
-		const struct zpool_ops *ops)
+struct zpool *zpool_create_pool(const char *type, const char *name, gfp_t gfp)
 {
 	struct zpool_driver *driver;
 	struct zpool *zpool;
@@ -173,7 +171,7 @@ struct zpool *zpool_create_pool(const ch
 	}
 
 	zpool->driver = driver;
-	zpool->pool = driver->create(name, gfp, ops, zpool);
+	zpool->pool = driver->create(name, gfp);
 
 	if (!zpool->pool) {
 		pr_err("couldn't create %s pool\n", type);
@@ -280,30 +278,6 @@ void zpool_free(struct zpool *zpool, uns
 }
 
 /**
- * zpool_shrink() - Shrink the pool size
- * @zpool:	The zpool to shrink.
- * @pages:	The number of pages to shrink the pool.
- * @reclaimed:	The number of pages successfully evicted.
- *
- * This attempts to shrink the actual memory size of the pool
- * by evicting currently used handle(s).  If the pool was
- * created with no zpool_ops, or the evict call fails for any
- * of the handles, this will fail.  If non-NULL, the @reclaimed
- * parameter will be set to the number of pages reclaimed,
- * which may be more than the number of pages requested.
- *
- * Implementations must guarantee this to be thread-safe.
- *
- * Returns: 0 on success, negative value on error/failure.
- */
-int zpool_shrink(struct zpool *zpool, unsigned int pages,
-			unsigned int *reclaimed)
-{
-	return zpool->driver->shrink ?
-	       zpool->driver->shrink(zpool->pool, pages, reclaimed) : -EINVAL;
-}
-
-/**
  * zpool_map_handle() - Map a previously allocated handle into memory
  * @zpool:	The zpool that the handle was allocated from
  * @handle:	The handle to map
@@ -360,24 +334,6 @@ u64 zpool_get_total_size(struct zpool *z
 }
 
 /**
- * zpool_evictable() - Test if zpool is potentially evictable
- * @zpool:	The zpool to test
- *
- * Zpool is only potentially evictable when it's created with struct
- * zpool_ops.evict and its driver implements struct zpool_driver.shrink.
- *
- * However, it doesn't necessarily mean driver will use zpool_ops.evict
- * in its implementation of zpool_driver.shrink. It could do internal
- * defragmentation instead.
- *
- * Returns: true if potentially evictable; false otherwise.
- */
-bool zpool_evictable(struct zpool *zpool)
-{
-	return zpool->driver->shrink;
-}
-
-/**
  * zpool_can_sleep_mapped - Test if zpool can sleep when do mapped.
  * @zpool:	The zpool to test
  *
--- a/mm/zsmalloc.c~mm-zswap-remove-shrink-from-zpool-interface
+++ a/mm/zsmalloc.c
@@ -351,9 +351,7 @@ static void record_obj(unsigned long han
 
 #ifdef CONFIG_ZPOOL
 
-static void *zs_zpool_create(const char *name, gfp_t gfp,
-			     const struct zpool_ops *zpool_ops,
-			     struct zpool *zpool)
+static void *zs_zpool_create(const char *name, gfp_t gfp)
 {
 	/*
 	 * Ignore global gfp flags: zs_malloc() may be invoked from
--- a/mm/zswap.c~mm-zswap-remove-shrink-from-zpool-interface
+++ a/mm/zswap.c
@@ -258,10 +258,6 @@ static int zswap_writeback_entry(struct
 static int zswap_pool_get(struct zswap_pool *pool);
 static void zswap_pool_put(struct zswap_pool *pool);
 
-static const struct zpool_ops zswap_zpool_ops = {
-	.evict = zswap_writeback_entry
-};
-
 static bool zswap_is_full(void)
 {
 	return totalram_pages() * zswap_max_pool_percent / 100 <
@@ -379,12 +375,9 @@ static void zswap_free_entry(struct zswa
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
 	else {
-		/* zpool_evictable will be removed once all 3 backends have migrated */
-		if (!zpool_evictable(entry->pool->zpool)) {
-			spin_lock(&entry->pool->lru_lock);
-			list_del(&entry->lru);
-			spin_unlock(&entry->pool->lru_lock);
-		}
+		spin_lock(&entry->pool->lru_lock);
+		list_del(&entry->lru);
+		spin_unlock(&entry->pool->lru_lock);
 		zpool_free(entry->pool->zpool, entry->handle);
 		zswap_pool_put(entry->pool);
 	}
@@ -665,12 +658,8 @@ static void shrink_worker(struct work_st
 						shrink_work);
 	int ret, failures = 0;
 
-	/* zpool_evictable will be removed once all 3 backends have migrated */
 	do {
-		if (zpool_evictable(pool->zpool))
-			ret = zpool_shrink(pool->zpool, 1, NULL);
-		else
-			ret = zswap_reclaim_entry(pool);
+		ret = zswap_reclaim_entry(pool);
 		if (ret) {
 			zswap_reject_reclaim_fail++;
 			if (ret != -EAGAIN)
@@ -708,7 +697,7 @@ static struct zswap_pool *zswap_pool_cre
 	/* unique name for each pool specifically required by zsmalloc */
 	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
 
-	pool->zpool = zpool_create_pool(type, name, gfp, &zswap_zpool_ops);
+	pool->zpool = zpool_create_pool(type, name, gfp);
 	if (!pool->zpool) {
 		pr_err("%s zpool not available\n", type);
 		goto error;
@@ -1394,8 +1383,7 @@ insert_entry:
 			zswap_entry_put(tree, dupentry);
 		}
 	} while (ret == -EEXIST);
-	/* zpool_evictable will be removed once all 3 backends have migrated */
-	if (entry->length && !zpool_evictable(entry->pool->zpool)) {
+	if (entry->length) {
 		spin_lock(&entry->pool->lru_lock);
 		list_add(&entry->lru, &entry->pool->lru);
 		spin_unlock(&entry->pool->lru_lock);
@@ -1514,8 +1502,7 @@ freeentry:
 	if (!ret && zswap_exclusive_loads_enabled) {
 		zswap_invalidate_entry(tree, entry);
 		*exclusive = true;
-	} else if (entry->length && !zpool_evictable(entry->pool->zpool)) {
-		/* zpool_evictable will be removed once all 3 backends have migrated */
+	} else if (entry->length) {
 		spin_lock(&entry->pool->lru_lock);
 		list_move(&entry->lru, &entry->pool->lru);
 		spin_unlock(&entry->pool->lru_lock);
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are


