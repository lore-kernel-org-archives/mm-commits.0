Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF87FC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 20:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiKHUDd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 15:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiKHUDZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 15:03:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3A81F9
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 12:03:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E683FB81C1F
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 20:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A127C433C1;
        Tue,  8 Nov 2022 20:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667937798;
        bh=jTcdKPwTAip5jNzY6+oyEOT7RX4Fs558tY93oFCkitw=;
        h=Date:To:From:Subject:From;
        b=qVkMfRr/1pAKPDEPF2w8e9Kxpm2ds8JMPNYMXw1P9BS79P4O0uuUgU4SJPasDmG7C
         G0ifFWVRsSaMH/EKIWlgcrL46djBaRwAjIU3SZjAx0SDnHVBLgnC+pEX4g0NA7O3vB
         0syB00BDXfTNSsOhgEIsqHxlwj7TRmoktflOuP28=
Date:   Tue, 08 Nov 2022 12:03:16 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch added to mm-unstable branch
Message-Id: <20221108200318.8A127C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: implement writeback mechanism for zsmalloc
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

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
Subject: zsmalloc: implement writeback mechanism for zsmalloc
Date: Tue, 8 Nov 2022 11:32:07 -0800

This commit adds the writeback mechanism for zsmalloc, analogous to the
zbud allocator.  Zsmalloc will attempt to determine the coldest zspage
(i.e least recently used) in the pool, and attempt to write back all the
stored compressed objects via the pool's evict handler.

Link: https://lkml.kernel.org/r/20221108193207.3297327-6-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  200 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 185 insertions(+), 15 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-implement-writeback-mechanism-for-zsmalloc
+++ a/mm/zsmalloc.c
@@ -271,10 +271,13 @@ struct zspage {
 	/* links the zspage to the lru list in the pool */
 	struct list_head lru;
 
+	bool under_reclaim;
+
+	/* list of unfreed handles whose objects have been reclaimed */
+	unsigned long *deferred_handles;
+
 	struct zs_pool *pool;
-#ifdef CONFIG_COMPACTION
 	rwlock_t lock;
-#endif
 };
 
 struct mapping_area {
@@ -295,10 +298,11 @@ static bool ZsHugePage(struct zspage *zs
 	return zspage->huge;
 }
 
-#ifdef CONFIG_COMPACTION
 static void migrate_lock_init(struct zspage *zspage);
 static void migrate_read_lock(struct zspage *zspage);
 static void migrate_read_unlock(struct zspage *zspage);
+
+#ifdef CONFIG_COMPACTION
 static void migrate_write_lock(struct zspage *zspage);
 static void migrate_write_lock_nested(struct zspage *zspage);
 static void migrate_write_unlock(struct zspage *zspage);
@@ -306,9 +310,6 @@ static void kick_deferred_free(struct zs
 static void init_deferred_free(struct zs_pool *pool);
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage);
 #else
-static void migrate_lock_init(struct zspage *zspage) {}
-static void migrate_read_lock(struct zspage *zspage) {}
-static void migrate_read_unlock(struct zspage *zspage) {}
 static void migrate_write_lock(struct zspage *zspage) {}
 static void migrate_write_lock_nested(struct zspage *zspage) {}
 static void migrate_write_unlock(struct zspage *zspage) {}
@@ -439,6 +440,27 @@ static void zs_zpool_free(void *pool, un
 	zs_free(pool, handle);
 }
 
+static int zs_reclaim_page(struct zs_pool *pool, unsigned int retries);
+
+static int zs_zpool_shrink(void *pool, unsigned int pages,
+			unsigned int *reclaimed)
+{
+	unsigned int total = 0;
+	int ret = -EINVAL;
+
+	while (total < pages) {
+		ret = zs_reclaim_page(pool, 8);
+		if (ret < 0)
+			break;
+		total++;
+	}
+
+	if (reclaimed)
+		*reclaimed = total;
+
+	return ret;
+}
+
 static void *zs_zpool_map(void *pool, unsigned long handle,
 			enum zpool_mapmode mm)
 {
@@ -477,6 +499,7 @@ static struct zpool_driver zs_zpool_driv
 	.malloc_support_movable = true,
 	.malloc =		  zs_zpool_malloc,
 	.free =			  zs_zpool_free,
+	.shrink =		  zs_zpool_shrink,
 	.map =			  zs_zpool_map,
 	.unmap =		  zs_zpool_unmap,
 	.total_size =		  zs_zpool_total_size,
@@ -953,6 +976,21 @@ unlock:
 	return 0;
 }
 
+/*
+ * Free all the deferred handles whose objects are freed in zs_free.
+ */
+static void free_handles(struct zs_pool *pool, struct zspage *zspage)
+{
+	unsigned long handle = (unsigned long)zspage->deferred_handles;
+
+	while (handle) {
+		unsigned long nxt_handle = handle_to_obj(handle);
+
+		cache_free_handle(pool, handle);
+		handle = nxt_handle;
+	}
+}
+
 static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 				struct zspage *zspage)
 {
@@ -967,6 +1005,9 @@ static void __free_zspage(struct zs_pool
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(fg != ZS_EMPTY);
 
+	/* Free all deferred handles from zs_free */
+	free_handles(pool, zspage);
+
 	next = page = get_first_page(zspage);
 	do {
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
@@ -1049,6 +1090,8 @@ static void init_zspage(struct size_clas
 	}
 
 	INIT_LIST_HEAD(&zspage->lru);
+	zspage->under_reclaim = false;
+	zspage->deferred_handles = NULL;
 
 	set_freeobj(zspage, 0);
 }
@@ -1491,11 +1534,8 @@ unsigned long zs_malloc(struct zs_pool *
 		fix_fullness_group(class, zspage);
 		record_obj(handle, obj);
 		class_stat_inc(class, OBJ_USED, 1);
-		/* Move the zspage to front of pool's LRU */
-		move_to_front(pool, zspage);
-		spin_unlock(&pool->lock);
 
-		return handle;
+		goto out;
 	}
 
 	spin_unlock(&pool->lock);
@@ -1519,6 +1559,8 @@ unsigned long zs_malloc(struct zs_pool *
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
+
+out:
 	/* Move the zspage to front of pool's LRU */
 	move_to_front(pool, zspage);
 	spin_unlock(&pool->lock);
@@ -1576,12 +1618,24 @@ void zs_free(struct zs_pool *pool, unsig
 
 	obj_free(class->size, obj);
 	class_stat_dec(class, OBJ_USED, 1);
+
+	if (zspage->under_reclaim) {
+		/*
+		 * Reclaim needs the handles during writeback. It'll free
+		 * them along with the zspage when it's done with them.
+		 *
+		 * Record current deferred handle at the memory location
+		 * whose address is given by handle.
+		 */
+		record_obj(handle, (unsigned long)zspage->deferred_handles);
+		zspage->deferred_handles = (unsigned long *)handle;
+		spin_unlock(&pool->lock);
+		return;
+	}
 	fullness = fix_fullness_group(class, zspage);
-	if (fullness != ZS_EMPTY)
-		goto out;
+	if (fullness == ZS_EMPTY)
+		free_zspage(pool, class, zspage);
 
-	free_zspage(pool, class, zspage);
-out:
 	spin_unlock(&pool->lock);
 	cache_free_handle(pool, handle);
 }
@@ -1781,7 +1835,7 @@ static enum fullness_group putback_zspag
 	return fullness;
 }
 
-#ifdef CONFIG_COMPACTION
+#if defined(CONFIG_ZPOOL) || defined(CONFIG_COMPACTION)
 /*
  * To prevent zspage destroy during migration, zspage freeing should
  * hold locks of all pages in the zspage.
@@ -1823,6 +1877,24 @@ static void lock_zspage(struct zspage *z
 	}
 	migrate_read_unlock(zspage);
 }
+#endif /* defined(CONFIG_ZPOOL) || defined(CONFIG_COMPACTION) */
+
+#ifdef CONFIG_ZPOOL
+/*
+ * Unlocks all the pages of the zspage.
+ *
+ * pool->lock must be held before this function is called
+ * to prevent the underlying pages from migrating.
+ */
+static void unlock_zspage(struct zspage *zspage)
+{
+	struct page *page = get_first_page(zspage);
+
+	do {
+		unlock_page(page);
+	} while ((page = get_next_page(page)) != NULL);
+}
+#endif /* CONFIG_ZPOOL */
 
 static void migrate_lock_init(struct zspage *zspage)
 {
@@ -1839,6 +1911,7 @@ static void migrate_read_unlock(struct z
 	read_unlock(&zspage->lock);
 }
 
+#ifdef CONFIG_COMPACTION
 static void migrate_write_lock(struct zspage *zspage)
 {
 	write_lock(&zspage->lock);
@@ -2419,6 +2492,103 @@ void zs_destroy_pool(struct zs_pool *poo
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
+#ifdef CONFIG_ZPOOL
+static int zs_reclaim_page(struct zs_pool *pool, unsigned int retries)
+{
+	int i, obj_idx, ret = 0;
+	unsigned long handle;
+	struct zspage *zspage;
+	struct page *page;
+	enum fullness_group fullness;
+
+	if (retries == 0 || !pool->ops || !pool->ops->evict)
+		return -EINVAL;
+
+	/* Lock LRU and fullness list */
+	spin_lock(&pool->lock);
+	if (list_empty(&pool->lru)) {
+		spin_unlock(&pool->lock);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < retries; i++) {
+		struct size_class *class;
+
+		zspage = list_last_entry(&pool->lru, struct zspage, lru);
+		list_del(&zspage->lru);
+
+		/* zs_free may free objects, but not the zspage and handles */
+		zspage->under_reclaim = true;
+
+		class = zspage_class(pool, zspage);
+		fullness = get_fullness_group(class, zspage);
+
+		/* Lock out object allocations and object compaction */
+		remove_zspage(class, zspage, fullness);
+
+		spin_unlock(&pool->lock);
+
+		/* Lock backing pages into place */
+		lock_zspage(zspage);
+
+		obj_idx = 0;
+		page = zspage->first_page;
+		while (1) {
+			handle = find_alloced_obj(class, page, &obj_idx);
+			if (!handle) {
+				page = get_next_page(page);
+				if (!page)
+					break;
+				obj_idx = 0;
+				continue;
+			}
+
+			/*
+			 * This will write the object and call
+			 * zs_free.
+			 *
+			 * zs_free will free the object, but the
+			 * under_reclaim flag prevents it from freeing
+			 * the zspage altogether. This is necessary so
+			 * that we can continue working with the
+			 * zspage potentially after the last object
+			 * has been freed.
+			 */
+			ret = pool->ops->evict(pool, handle);
+			if (ret)
+				goto next;
+
+			obj_idx++;
+		}
+
+next:
+		/* For freeing the zspage, or putting it back in the pool and LRU list. */
+		spin_lock(&pool->lock);
+		zspage->under_reclaim = false;
+
+		if (!get_zspage_inuse(zspage)) {
+			/*
+			 * Fullness went stale as zs_free() won't touch it
+			 * while the page is removed from the pool. Fix it
+			 * up for the check in __free_zspage().
+			 */
+			zspage->fullness = ZS_EMPTY;
+
+			__free_zspage(pool, class, zspage);
+			spin_unlock(&pool->lock);
+			return 0;
+		}
+
+		putback_zspage(class, zspage);
+		list_add(&zspage->lru, &pool->lru);
+		unlock_zspage(zspage);
+	}
+
+	spin_unlock(&pool->lock);
+	return -EAGAIN;
+}
+#endif /* CONFIG_ZPOOL */
+
 static int __init zs_init(void)
 {
 	int ret;
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch
zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

