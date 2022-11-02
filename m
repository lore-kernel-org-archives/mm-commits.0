Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A509BC43219
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 21:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiKBV2e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 17:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiKBV2M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 17:28:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC7EDFFE
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 14:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB6EAB8250E
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 21:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA76C433D6;
        Wed,  2 Nov 2022 21:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667424488;
        bh=sWfZb1PXkbychxrw3/7r1plNJMvXFwLpkrJTshq81aI=;
        h=Date:To:From:Subject:From;
        b=kj8DfPpaGtgHHRcTC+AboRSMPHX2CkV1ArHrDuHhfPq6D9kIcl750l2GhqpstdtP2
         geOfzfOd6QXQImVvBuDeaZ/6F5GeUN3DpLHznh71n1D0XdTi/RlcXY+jxrzB+qNJaY
         ei+CL4oW/5unVG4LuOFYltuh9MnhEX0rtpf5pqt0=
Date:   Wed, 02 Nov 2022 14:28:07 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch removed from -mm tree
Message-Id: <20221102212808.5AA76C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: add a LRU to zs_pool to keep track of zspages in LRU order
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zsmalloc: add a LRU to zs_pool to keep track of zspages in LRU order
Date: Wed, 26 Oct 2022 13:06:11 -0700

This helps determines the coldest zspages as candidates for writeback.

Link: https://lkml.kernel.org/r/20221026200613.1031261-4-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order
+++ a/mm/zsmalloc.c
@@ -239,6 +239,9 @@ struct zs_pool {
 	/* Compact classes */
 	struct shrinker shrinker;
 
+	/* List tracking the zspages in LRU order by most recently added object */
+	struct list_head lru;
+
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -260,6 +263,10 @@ struct zspage {
 	unsigned int freeobj;
 	struct page *first_page;
 	struct list_head list; /* fullness list */
+
+	/* links the zspage to the lru list in the pool */
+	struct list_head lru;
+
 	struct zs_pool *pool;
 #ifdef CONFIG_COMPACTION
 	rwlock_t lock;
@@ -352,6 +359,16 @@ static void cache_free_zspage(struct zs_
 	kmem_cache_free(pool->zspage_cachep, zspage);
 }
 
+/* Moves the zspage to the front of the zspool's LRU */
+static void move_to_front(struct zs_pool *pool, struct zspage *zspage)
+{
+	assert_spin_locked(&pool->lock);
+
+	if (!list_empty(&zspage->lru))
+		list_del(&zspage->lru);
+	list_add(&zspage->lru, &pool->lru);
+}
+
 /* pool->lock(which owns the handle) synchronizes races */
 static void record_obj(unsigned long handle, unsigned long obj)
 {
@@ -953,6 +970,7 @@ static void free_zspage(struct zs_pool *
 	}
 
 	remove_zspage(class, zspage, ZS_EMPTY);
+	list_del(&zspage->lru);
 	__free_zspage(pool, class, zspage);
 }
 
@@ -998,6 +1016,8 @@ static void init_zspage(struct size_clas
 		off %= PAGE_SIZE;
 	}
 
+	INIT_LIST_HEAD(&zspage->lru);
+
 	set_freeobj(zspage, 0);
 }
 
@@ -1418,6 +1438,8 @@ unsigned long zs_malloc(struct zs_pool *
 		fix_fullness_group(class, zspage);
 		record_obj(handle, obj);
 		class_stat_inc(class, OBJ_USED, 1);
+		/* Move the zspage to front of pool's LRU */
+		move_to_front(pool, zspage);
 		spin_unlock(&pool->lock);
 
 		return handle;
@@ -1444,6 +1466,8 @@ unsigned long zs_malloc(struct zs_pool *
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
+	/* Move the zspage to front of pool's LRU */
+	move_to_front(pool, zspage);
 	spin_unlock(&pool->lock);
 
 	return handle;
@@ -1967,6 +1991,7 @@ static void async_free_zspage(struct wor
 		VM_BUG_ON(fullness != ZS_EMPTY);
 		class = pool->size_class[class_idx];
 		spin_lock(&pool->lock);
+		list_del(&zspage->lru);
 		__free_zspage(pool, class, zspage);
 		spin_unlock(&pool->lock);
 	}
@@ -2278,6 +2303,8 @@ struct zs_pool *zs_create_pool(const cha
 	 */
 	zs_register_shrinker(pool);
 
+	INIT_LIST_HEAD(&pool->lru);
+
 	return pool;
 
 err:
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

