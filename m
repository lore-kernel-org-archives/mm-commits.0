Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90982C43217
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 21:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiKBV2f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 17:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiKBV2N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 17:28:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1AAE02D
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 14:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDBBCB82414
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 21:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954B6C433C1;
        Wed,  2 Nov 2022 21:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667424489;
        bh=2QmAtIyVt4WTaopB4G+OQ7wLG9t1zOvnCUU+OPgkgA8=;
        h=Date:To:From:Subject:From;
        b=oEbnPCVxBhbPdzvkk8PSc4OPp8u3gQSKvNyOTPR6d0JY1sS0wyIjoOcbP0K9RvBuq
         5VV1mS1TfphbYFaXXCxBSiEBApvNQmZTHMXf7eNkA0KksGHo+886DdH3d6Sfnl0qFB
         BIqNoGgKzAt/ol3+2Bv2PXDXQfIe0tUwPT02oHBc=
Date:   Wed, 02 Nov 2022 14:28:08 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch removed from -mm tree
Message-Id: <20221102212809.954B6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: add ops fields to zs_pool to store evict handlers
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zsmalloc: add ops fields to zs_pool to store evict handlers
Date: Wed, 26 Oct 2022 13:06:12 -0700

This adds fields to zs_pool to store evict handlers for writeback,
analogous to the zbud allocator.

Link: https://lkml.kernel.org/r/20221026200613.1031261-5-nphamcs@gmail.com
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

 mm/zsmalloc.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers
+++ a/mm/zsmalloc.c
@@ -225,6 +225,12 @@ struct link_free {
 	};
 };
 
+struct zs_pool;
+
+struct zs_ops {
+	int (*evict)(struct zs_pool *pool, unsigned long handle);
+};
+
 struct zs_pool {
 	const char *name;
 
@@ -242,6 +248,12 @@ struct zs_pool {
 	/* List tracking the zspages in LRU order by most recently added object */
 	struct list_head lru;
 
+#ifdef CONFIG_ZPOOL
+	const struct zs_ops *ops;
+	struct zpool *zpool;
+	const struct zpool_ops *zpool_ops;
+#endif
+
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -379,6 +391,18 @@ static void record_obj(unsigned long han
 
 #ifdef CONFIG_ZPOOL
 
+static int zs_zpool_evict(struct zs_pool *pool, unsigned long handle)
+{
+	if (pool->zpool && pool->zpool_ops && pool->zpool_ops->evict)
+		return pool->zpool_ops->evict(pool->zpool, handle);
+	else
+		return -ENOENT;
+}
+
+static const struct zs_ops zs_zpool_ops = {
+	.evict =	zs_zpool_evict
+};
+
 static void *zs_zpool_create(const char *name, gfp_t gfp,
 			     const struct zpool_ops *zpool_ops,
 			     struct zpool *zpool)
@@ -388,7 +412,18 @@ static void *zs_zpool_create(const char
 	 * different contexts and its caller must provide a valid
 	 * gfp mask.
 	 */
-	return zs_create_pool(name);
+	struct zs_pool *pool;
+
+	pool = zs_create_pool(name);
+	if (pool) {
+		pool->zpool = zpool;
+		pool->zpool_ops = zpool_ops;
+
+		if (zpool_ops)
+			pool->ops = &zs_zpool_ops;
+	}
+
+	return pool;
 }
 
 static void zs_zpool_destroy(void *pool)
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

