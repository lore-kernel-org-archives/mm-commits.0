Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6602FECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiJ1Vkt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJ1Vki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:40:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC68F1D2B51
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85F43B82AAC
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FEFC43470;
        Fri, 28 Oct 2022 21:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666993232;
        bh=jr6EWFtXtaIOFP7uvGqb+6gBaxoLpx3+tYtlbSCwLYE=;
        h=Date:To:From:Subject:From;
        b=jWeyOT8bixQHaIPgeIQNIjiHCrkSv6GIN2ZlTUWv4txgJhEDDVw6yWVnjrcrbn9Vg
         UxG8UFKmXqj5ITOj4XeFx2Tjr6Gc1/DcIpjBrKHx505lCWvo+Y11d+Pscl0LPmtJZF
         /ElzfwJowrVtZy6dKD8xKOqrNlhwBUcGdydugsog=
Date:   Fri, 28 Oct 2022 14:40:31 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch added to mm-unstable branch
Message-Id: <20221028214032.20FEFC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: add a LRU to zs_pool to keep track of zspages in LRU order
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch

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


--- a/mm/zsmalloc.c~zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order
+++ a/mm/zsmalloc.c
@@ -231,6 +231,9 @@ struct zs_pool {
 	/* Compact classes */
 	struct shrinker shrinker;
 
+	/* List tracking the zspages in LRU order by most recently added object */
+	struct list_head lru;
+
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -252,6 +255,10 @@ struct zspage {
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
@@ -344,6 +351,16 @@ static void cache_free_zspage(struct zs_
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
@@ -948,6 +965,7 @@ static void free_zspage(struct zs_pool *
 	}
 
 	remove_zspage(class, zspage, ZS_EMPTY);
+	list_del(&zspage->lru);
 	__free_zspage(pool, class, zspage);
 }
 
@@ -993,6 +1011,8 @@ static void init_zspage(struct size_clas
 		off %= PAGE_SIZE;
 	}
 
+	INIT_LIST_HEAD(&zspage->lru);
+
 	set_freeobj(zspage, 0);
 }
 
@@ -1434,6 +1454,8 @@ unsigned long zs_malloc(struct zs_pool *
 		fix_fullness_group(class, zspage);
 		record_obj(handle, obj);
 		class_stat_inc(class, OBJ_USED, 1);
+		/* Move the zspage to front of pool's LRU */
+		move_to_front(pool, zspage);
 		spin_unlock(&pool->lock);
 
 		return handle;
@@ -1460,6 +1482,8 @@ unsigned long zs_malloc(struct zs_pool *
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
+	/* Move the zspage to front of pool's LRU */
+	move_to_front(pool, zspage);
 	spin_unlock(&pool->lock);
 
 	return handle;
@@ -1983,6 +2007,7 @@ static void async_free_zspage(struct wor
 		VM_BUG_ON(fullness != ZS_EMPTY);
 		class = pool->size_class[class_idx];
 		spin_lock(&pool->lock);
+		list_del(&zspage->lru);
 		__free_zspage(pool, class, zspage);
 		spin_unlock(&pool->lock);
 	}
@@ -2315,6 +2340,8 @@ struct zs_pool *zs_create_pool(const cha
 	 */
 	zs_register_shrinker(pool);
 
+	INIT_LIST_HEAD(&pool->lru);
+
 	return pool;
 
 err:
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch
zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

