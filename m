Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CCEC46467
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 21:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiK1VkE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 16:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiK1VkB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 16:40:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3A42ED6F
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 13:39:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEEF361489
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 21:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B50C433C1;
        Mon, 28 Nov 2022 21:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669671594;
        bh=hGT0EcYIhVmmigOCVuQtn0RDPzoFN7svQWlmGqIooXw=;
        h=Date:To:From:Subject:From;
        b=q/3EhXUtkyRUVbPiSSNJiG9QhGt9k9qNr82iB4ds10NNCaA1brgDwHeLFO9ZjBT3i
         V04Nul0XLhxDhtValYyNkDzdt3cpQ9xaODwGRzQ/wcmBMcZ3ISrKqT108oS7bXq5rd
         ZYsebYybQKjxrDX/Yr4A+ifDQ6jIbYKSIYKvVnh4=
Date:   Mon, 28 Nov 2022 13:39:53 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch added to mm-unstable branch
Message-Id: <20221128213954.16B50C433C1@smtp.kernel.org>
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
Date: Mon, 28 Nov 2022 11:16:13 -0800

This helps determines the coldest zspages as candidates for writeback.

Link: https://lkml.kernel.org/r/20221128191616.1261026-5-nphamcs@gmail.com
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

 mm/zsmalloc.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order
+++ a/mm/zsmalloc.c
@@ -239,6 +239,11 @@ struct zs_pool {
 	/* Compact classes */
 	struct shrinker shrinker;
 
+#ifdef CONFIG_ZPOOL
+	/* List tracking the zspages in LRU order by most recently added object */
+	struct list_head lru;
+#endif
+
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -260,6 +265,12 @@ struct zspage {
 	unsigned int freeobj;
 	struct page *first_page;
 	struct list_head list; /* fullness list */
+
+#ifdef CONFIG_ZPOOL
+	/* links the zspage to the lru list in the pool */
+	struct list_head lru;
+#endif
+
 	struct zs_pool *pool;
 #ifdef CONFIG_COMPACTION
 	rwlock_t lock;
@@ -953,6 +964,9 @@ static void free_zspage(struct zs_pool *
 	}
 
 	remove_zspage(class, zspage, ZS_EMPTY);
+#ifdef CONFIG_ZPOOL
+	list_del(&zspage->lru);
+#endif
 	__free_zspage(pool, class, zspage);
 }
 
@@ -998,6 +1012,10 @@ static void init_zspage(struct size_clas
 		off %= PAGE_SIZE;
 	}
 
+#ifdef CONFIG_ZPOOL
+	INIT_LIST_HEAD(&zspage->lru);
+#endif
+
 	set_freeobj(zspage, 0);
 }
 
@@ -1270,6 +1288,31 @@ void *zs_map_object(struct zs_pool *pool
 	obj_to_location(obj, &page, &obj_idx);
 	zspage = get_zspage(page);
 
+#ifdef CONFIG_ZPOOL
+	/*
+	 * Move the zspage to front of pool's LRU.
+	 *
+	 * Note that this is swap-specific, so by definition there are no ongoing
+	 * accesses to the memory while the page is swapped out that would make
+	 * it "hot". A new entry is hot, then ages to the tail until it gets either
+	 * written back or swaps back in.
+	 *
+	 * Furthermore, map is also called during writeback. We must not put an
+	 * isolated page on the LRU mid-reclaim.
+	 *
+	 * As a result, only update the LRU when the page is mapped for write
+	 * when it's first instantiated.
+	 *
+	 * This is a deviation from the other backends, which perform this update
+	 * in the allocation function (zbud_alloc, z3fold_alloc).
+	 */
+	if (mm == ZS_MM_WO) {
+		if (!list_empty(&zspage->lru))
+			list_del(&zspage->lru);
+		list_add(&zspage->lru, &pool->lru);
+	}
+#endif
+
 	/*
 	 * migration cannot move any zpages in this zspage. Here, pool->lock
 	 * is too heavy since callers would take some time until they calls
@@ -1988,6 +2031,9 @@ static void async_free_zspage(struct wor
 		VM_BUG_ON(fullness != ZS_EMPTY);
 		class = pool->size_class[class_idx];
 		spin_lock(&pool->lock);
+#ifdef CONFIG_ZPOOL
+		list_del(&zspage->lru);
+#endif
 		__free_zspage(pool, class, zspage);
 		spin_unlock(&pool->lock);
 	}
@@ -2299,6 +2345,10 @@ struct zs_pool *zs_create_pool(const cha
 	 */
 	zs_register_shrinker(pool);
 
+#ifdef CONFIG_ZPOOL
+	INIT_LIST_HEAD(&pool->lru);
+#endif
+
 	return pool;
 
 err:
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch
zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

