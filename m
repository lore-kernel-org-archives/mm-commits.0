Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969CCC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjFSXZw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjFSXXv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0DF19A1
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F12360FAF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996ADC433C0;
        Mon, 19 Jun 2023 23:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216972;
        bh=FJOGjR2ViMestIV4tROPbtJDSfxoNk7Cq5XFnDcGKiY=;
        h=Date:To:From:Subject:From;
        b=VRpbCpPkNrXw0A0H5yjG5C+9p0+iPWmOnwQ8n+8lkCsXTxCRmMGiJpZQtPfpPuD6h
         mp/Z7J8Ni1k1Y4N+h1s64NtWTWvbJFwK9C/ojsx4L7rchK7kMN5cb95V+QQdt+r+TQ
         lo+tcwCWVK7aMr6pICWojETpaBSQ7w4fX0dtxXR4=
Date:   Mon, 19 Jun 2023 16:22:52 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-zswap_header.patch removed from -mm tree
Message-Id: <20230619232252.996ADC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: remove zswap_header
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-zswap_header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: remove zswap_header
Date: Mon, 12 Jun 2023 11:38:15 +0200

Previously, zswap_header served the purpose of storing the swpentry within
zpool pages.  This allowed zpool implementations to pass relevant
information to the writeback function.  However, with the current
implementation, writeback is directly handled within zswap.  Consequently,
there is no longer a necessity for zswap_header, as the swp_entry_t can be
stored directly in zswap_entry.

Link: https://lkml.kernel.org/r/20230612093815.133504-8-cerasuolodomenico@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Tested-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   52 +++++++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 30 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-zswap_header
+++ a/mm/zswap.c
@@ -197,7 +197,7 @@ struct zswap_pool {
  */
 struct zswap_entry {
 	struct rb_node rbnode;
-	pgoff_t offset;
+	swp_entry_t swpentry;
 	int refcount;
 	unsigned int length;
 	struct zswap_pool *pool;
@@ -209,10 +209,6 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
-struct zswap_header {
-	swp_entry_t swpentry;
-};
-
 /*
  * The tree lock in the zswap_tree struct protects a few things:
  * - the rbtree
@@ -254,7 +250,7 @@ static bool zswap_has_pool;
 	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
 		 zpool_get_type((p)->zpool))
 
-static int zswap_writeback_entry(struct zswap_entry *entry, struct zswap_header *zhdr,
+static int zswap_writeback_entry(struct zswap_entry *entry,
 				 struct zswap_tree *tree);
 static int zswap_pool_get(struct zswap_pool *pool);
 static void zswap_pool_put(struct zswap_pool *pool);
@@ -315,12 +311,14 @@ static struct zswap_entry *zswap_rb_sear
 {
 	struct rb_node *node = root->rb_node;
 	struct zswap_entry *entry;
+	pgoff_t entry_offset;
 
 	while (node) {
 		entry = rb_entry(node, struct zswap_entry, rbnode);
-		if (entry->offset > offset)
+		entry_offset = swp_offset(entry->swpentry);
+		if (entry_offset > offset)
 			node = node->rb_left;
-		else if (entry->offset < offset)
+		else if (entry_offset < offset)
 			node = node->rb_right;
 		else
 			return entry;
@@ -337,13 +335,15 @@ static int zswap_rb_insert(struct rb_roo
 {
 	struct rb_node **link = &root->rb_node, *parent = NULL;
 	struct zswap_entry *myentry;
+	pgoff_t myentry_offset, entry_offset = swp_offset(entry->swpentry);
 
 	while (*link) {
 		parent = *link;
 		myentry = rb_entry(parent, struct zswap_entry, rbnode);
-		if (myentry->offset > entry->offset)
+		myentry_offset = swp_offset(myentry->swpentry);
+		if (myentry_offset > entry_offset)
 			link = &(*link)->rb_left;
-		else if (myentry->offset < entry->offset)
+		else if (myentry_offset < entry_offset)
 			link = &(*link)->rb_right;
 		else {
 			*dupentry = myentry;
@@ -601,7 +601,6 @@ static struct zswap_pool *zswap_pool_fin
 
 static int zswap_reclaim_entry(struct zswap_pool *pool)
 {
-	struct zswap_header *zhdr;
 	struct zswap_entry *entry;
 	struct zswap_tree *tree;
 	pgoff_t swpoffset;
@@ -615,15 +614,13 @@ static int zswap_reclaim_entry(struct zs
 	}
 	entry = list_last_entry(&pool->lru, struct zswap_entry, lru);
 	list_del_init(&entry->lru);
-	zhdr = zpool_map_handle(pool->zpool, entry->handle, ZPOOL_MM_RO);
-	tree = zswap_trees[swp_type(zhdr->swpentry)];
-	zpool_unmap_handle(pool->zpool, entry->handle);
 	/*
 	 * Once the lru lock is dropped, the entry might get freed. The
 	 * swpoffset is copied to the stack, and entry isn't deref'd again
 	 * until the entry is verified to still be alive in the tree.
 	 */
-	swpoffset = swp_offset(zhdr->swpentry);
+	swpoffset = swp_offset(entry->swpentry);
+	tree = zswap_trees[swp_type(entry->swpentry)];
 	spin_unlock(&pool->lru_lock);
 
 	/* Check for invalidate() race */
@@ -636,7 +633,7 @@ static int zswap_reclaim_entry(struct zs
 	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
-	ret = zswap_writeback_entry(entry, zhdr, tree);
+	ret = zswap_writeback_entry(entry, tree);
 
 	spin_lock(&tree->lock);
 	if (ret) {
@@ -1055,10 +1052,10 @@ static int zswap_get_swap_cache_page(swp
  * the swap cache, the compressed version stored by zswap can be
  * freed.
  */
-static int zswap_writeback_entry(struct zswap_entry *entry, struct zswap_header *zhdr,
+static int zswap_writeback_entry(struct zswap_entry *entry,
 				 struct zswap_tree *tree)
 {
-	swp_entry_t swpentry = zhdr->swpentry;
+	swp_entry_t swpentry = entry->swpentry;
 	struct page *page;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
@@ -1098,7 +1095,7 @@ static int zswap_writeback_entry(struct
 		 * writing.
 		 */
 		spin_lock(&tree->lock);
-		if (zswap_rb_search(&tree->rbroot, entry->offset) != entry) {
+		if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
 			spin_unlock(&tree->lock);
 			delete_from_swap_cache(page_folio(page));
 			ret = -ENOMEM;
@@ -1110,8 +1107,7 @@ static int zswap_writeback_entry(struct
 		acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
 		dlen = PAGE_SIZE;
 
-		zhdr = zpool_map_handle(pool, entry->handle, ZPOOL_MM_RO);
-		src = (u8 *)zhdr + sizeof(struct zswap_header);
+		src = zpool_map_handle(pool, entry->handle, ZPOOL_MM_RO);
 		if (!zpool_can_sleep_mapped(pool)) {
 			memcpy(tmp, src, entry->length);
 			src = tmp;
@@ -1205,11 +1201,10 @@ static int zswap_frontswap_store(unsigne
 	struct obj_cgroup *objcg = NULL;
 	struct zswap_pool *pool;
 	int ret;
-	unsigned int hlen, dlen = PAGE_SIZE;
+	unsigned int dlen = PAGE_SIZE;
 	unsigned long handle, value;
 	char *buf;
 	u8 *src, *dst;
-	struct zswap_header zhdr = { .swpentry = swp_entry(type, offset) };
 	gfp_t gfp;
 
 	/* THP isn't supported */
@@ -1254,7 +1249,7 @@ static int zswap_frontswap_store(unsigne
 		src = kmap_atomic(page);
 		if (zswap_is_page_same_filled(src, &value)) {
 			kunmap_atomic(src);
-			entry->offset = offset;
+			entry->swpentry = swp_entry(type, offset);
 			entry->length = 0;
 			entry->value = value;
 			atomic_inc(&zswap_same_filled_pages);
@@ -1308,11 +1303,10 @@ static int zswap_frontswap_store(unsigne
 	}
 
 	/* store */
-	hlen = sizeof(zhdr);
 	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 	if (zpool_malloc_support_movable(entry->pool->zpool))
 		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
-	ret = zpool_malloc(entry->pool->zpool, hlen + dlen, gfp, &handle);
+	ret = zpool_malloc(entry->pool->zpool, dlen, gfp, &handle);
 	if (ret == -ENOSPC) {
 		zswap_reject_compress_poor++;
 		goto put_dstmem;
@@ -1322,13 +1316,12 @@ static int zswap_frontswap_store(unsigne
 		goto put_dstmem;
 	}
 	buf = zpool_map_handle(entry->pool->zpool, handle, ZPOOL_MM_WO);
-	memcpy(buf, &zhdr, hlen);
-	memcpy(buf + hlen, dst, dlen);
+	memcpy(buf, dst, dlen);
 	zpool_unmap_handle(entry->pool->zpool, handle);
 	mutex_unlock(acomp_ctx->mutex);
 
 	/* populate entry */
-	entry->offset = offset;
+	entry->swpentry = swp_entry(type, offset);
 	entry->handle = handle;
 	entry->length = dlen;
 
@@ -1437,7 +1430,6 @@ static int zswap_frontswap_load(unsigned
 	/* decompress */
 	dlen = PAGE_SIZE;
 	src = zpool_map_handle(entry->pool->zpool, entry->handle, ZPOOL_MM_RO);
-	src += sizeof(struct zswap_header);
 
 	if (!zpool_can_sleep_mapped(entry->pool->zpool)) {
 		memcpy(tmp, src, entry->length);
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are


