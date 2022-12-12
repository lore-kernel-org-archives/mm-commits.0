Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35B5C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiLLCOg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiLLCNz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670EEBE36
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD24160EC6
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA7BC433F0;
        Mon, 12 Dec 2022 02:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811233;
        bh=l+b7ERXIAevnr53qXgA4TQuqKheTC6pQC+1WabIpJkU=;
        h=Date:To:From:Subject:From;
        b=ilckAybO/+FmDVYSCCB1gL39xMu1S8vfOCbz2haCkfXO+Yz+YGN7aPHWySlof+jIJ
         CFjjSylAMQEJdBClmCsu5HIDlesabO1oLVF5eszG2Oz3AM6XbuYKlUYM0PC09v+DOL
         HBx/UvkWQ1GFHXYbSw9ARW5SScTS78SykNUzqX4w=
Date:   Sun, 11 Dec 2022 18:13:52 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch removed from -mm tree
Message-Id: <20221212021353.2FA7BC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: add a LRU to zs_pool to keep track of zspages in LRU order
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zsmalloc: add a LRU to zs_pool to keep track of zspages in LRU order
Date: Mon, 28 Nov 2022 11:16:13 -0800

This helps determines the coldest zspages as candidates for writeback.

Link: https://lkml.kernel.org/r/20221128191616.1261026-5-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
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


