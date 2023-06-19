Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C1FEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjFSXZy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjFSXXv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDC6199B
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FBFB60F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A176C433C8;
        Mon, 19 Jun 2023 23:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216971;
        bh=R94A+w66WFmbWEXbXAFj63IZkt4+wlRnDym/jbM9LjA=;
        h=Date:To:From:Subject:From;
        b=IFBN+E5/dRWu8HG0OuXa5mHkMtaiJ0Ca56RAg660fG2+ovfw4CWAn7l+oJ96O2xWW
         0oekIl1Z4rvycIaWouA4sG91zXPmky8nY4045AmsoV5ul1aTX6e7QmukMlwT/viQNh
         rW4ey8BR06b2+mX2mukAuejAtjwNNRyokKnZ+r5c=
Date:   Mon, 19 Jun 2023 16:22:50 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-simplify-writeback-function.patch removed from -mm tree
Message-Id: <20230619232251.8A176C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: simplify writeback function
has been removed from the -mm tree.  Its filename was
     mm-zswap-simplify-writeback-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: simplify writeback function
Date: Mon, 12 Jun 2023 11:38:14 +0200

zswap_writeback_entry() used to be a callback for the backends, which
don't know about struct zswap_entry.

Now that the only user is the generic zswap LRU reclaimer, it can be
simplified: pass the pinned zswap_entry directly, and consolidate the
refcount management in the shrink function.

Link: https://lkml.kernel.org/r/20230612093815.133504-7-cerasuolodomenico@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Tested-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   70 +++++++++++++--------------------------------------
 1 file changed, 19 insertions(+), 51 deletions(-)

--- a/mm/zswap.c~mm-zswap-simplify-writeback-function
+++ a/mm/zswap.c
@@ -254,7 +254,8 @@ static bool zswap_has_pool;
 	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
 		 zpool_get_type((p)->zpool))
 
-static int zswap_writeback_entry(struct zpool *pool, unsigned long handle);
+static int zswap_writeback_entry(struct zswap_entry *entry, struct zswap_header *zhdr,
+				 struct zswap_tree *tree);
 static int zswap_pool_get(struct zswap_pool *pool);
 static void zswap_pool_put(struct zswap_pool *pool);
 
@@ -635,7 +636,7 @@ static int zswap_reclaim_entry(struct zs
 	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
-	ret = zswap_writeback_entry(pool->zpool, entry->handle);
+	ret = zswap_writeback_entry(entry, zhdr, tree);
 
 	spin_lock(&tree->lock);
 	if (ret) {
@@ -643,8 +644,17 @@ static int zswap_reclaim_entry(struct zs
 		spin_lock(&pool->lru_lock);
 		list_move(&entry->lru, &pool->lru);
 		spin_unlock(&pool->lru_lock);
+		goto put_unlock;
 	}
 
+	/* Check for invalidate() race */
+	if (entry != zswap_rb_search(&tree->rbroot, swpoffset))
+		goto put_unlock;
+
+	/* Drop base reference */
+	zswap_entry_put(tree, entry);
+
+put_unlock:
 	/* Drop local reference */
 	zswap_entry_put(tree, entry);
 unlock:
@@ -1045,16 +1055,14 @@ static int zswap_get_swap_cache_page(swp
  * the swap cache, the compressed version stored by zswap can be
  * freed.
  */
-static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
+static int zswap_writeback_entry(struct zswap_entry *entry, struct zswap_header *zhdr,
+				 struct zswap_tree *tree)
 {
-	struct zswap_header *zhdr;
-	swp_entry_t swpentry;
-	struct zswap_tree *tree;
-	pgoff_t offset;
-	struct zswap_entry *entry;
+	swp_entry_t swpentry = zhdr->swpentry;
 	struct page *page;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
+	struct zpool *pool = entry->pool->zpool;
 
 	u8 *src, *tmp = NULL;
 	unsigned int dlen;
@@ -1069,25 +1077,6 @@ static int zswap_writeback_entry(struct
 			return -ENOMEM;
 	}
 
-	/* extract swpentry from data */
-	zhdr = zpool_map_handle(pool, handle, ZPOOL_MM_RO);
-	swpentry = zhdr->swpentry; /* here */
-	tree = zswap_trees[swp_type(swpentry)];
-	offset = swp_offset(swpentry);
-	zpool_unmap_handle(pool, handle);
-
-	/* find and ref zswap entry */
-	spin_lock(&tree->lock);
-	entry = zswap_entry_find_get(&tree->rbroot, offset);
-	if (!entry) {
-		/* entry was invalidated */
-		spin_unlock(&tree->lock);
-		kfree(tmp);
-		return 0;
-	}
-	spin_unlock(&tree->lock);
-	BUG_ON(offset != entry->offset);
-
 	/* try to allocate swap cache page */
 	switch (zswap_get_swap_cache_page(swpentry, &page)) {
 	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
@@ -1121,12 +1110,12 @@ static int zswap_writeback_entry(struct
 		acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
 		dlen = PAGE_SIZE;
 
-		zhdr = zpool_map_handle(pool, handle, ZPOOL_MM_RO);
+		zhdr = zpool_map_handle(pool, entry->handle, ZPOOL_MM_RO);
 		src = (u8 *)zhdr + sizeof(struct zswap_header);
 		if (!zpool_can_sleep_mapped(pool)) {
 			memcpy(tmp, src, entry->length);
 			src = tmp;
-			zpool_unmap_handle(pool, handle);
+			zpool_unmap_handle(pool, entry->handle);
 		}
 
 		mutex_lock(acomp_ctx->mutex);
@@ -1141,7 +1130,7 @@ static int zswap_writeback_entry(struct
 		if (!zpool_can_sleep_mapped(pool))
 			kfree(tmp);
 		else
-			zpool_unmap_handle(pool, handle);
+			zpool_unmap_handle(pool, entry->handle);
 
 		BUG_ON(ret);
 		BUG_ON(dlen != PAGE_SIZE);
@@ -1158,23 +1147,7 @@ static int zswap_writeback_entry(struct
 	put_page(page);
 	zswap_written_back_pages++;
 
-	spin_lock(&tree->lock);
-	/* drop local reference */
-	zswap_entry_put(tree, entry);
-
-	/*
-	* There are two possible situations for entry here:
-	* (1) refcount is 1(normal case),  entry is valid and on the tree
-	* (2) refcount is 0, entry is freed and not on the tree
-	*     because invalidate happened during writeback
-	*  search the tree and free the entry if find entry
-	*/
-	if (entry == zswap_rb_search(&tree->rbroot, offset))
-		zswap_entry_put(tree, entry);
-	spin_unlock(&tree->lock);
-
 	return ret;
-
 fail:
 	if (!zpool_can_sleep_mapped(pool))
 		kfree(tmp);
@@ -1183,13 +1156,8 @@ fail:
 	* if we get here due to ZSWAP_SWAPCACHE_EXIST
 	* a load may be happening concurrently.
 	* it is safe and okay to not free the entry.
-	* if we free the entry in the following put
 	* it is also okay to return !0
 	*/
-	spin_lock(&tree->lock);
-	zswap_entry_put(tree, entry);
-	spin_unlock(&tree->lock);
-
 	return ret;
 }
 
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are


