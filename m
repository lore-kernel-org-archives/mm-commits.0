Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296B1C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E034D64F31
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhBZBTF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhBZBTB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED2F64EE1;
        Fri, 26 Feb 2021 01:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302300;
        bh=G3fzc0n79dYrwknqRnaUBvuu+ph8JUOAygaKRd5dCfI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=17eKktsfB6ZPqnzxLIweWTUrhmT0RsCy2rgiiVvh4+BB7RCXmB8hiWLsupsNygIBZ
         D3kMkpNdZKieyJYyRDid7sUtkZ16uWYLva0ehHrMuEJLgOzFxFimeJ4ObQi8HdhP0n
         yb3RGXrDp9b0g5+G8kiBDubN/+rWes2D+zr1GBQQ=
Date:   Thu, 25 Feb 2021 17:18:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        colin.king@canonical.com, dan.carpenter@oracle.com,
        ddstreet@ieee.org, efault@gmx.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        sjenning@redhat.com, song.bao.hua@hisilicon.com,
        tiantao6@hisilicon.com, torvalds@linux-foundation.org,
        vitaly.wool@konsulko.com
Subject:  [patch 047/118] mm/zswap: add the flag can_sleep_mapped
Message-ID: <20210226011817.uaL3uUR-J%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>
Subject: mm/zswap: add the flag can_sleep_mapped

Patch series "Fix the compatibility of zsmalloc and zswap".

Patch #1 adds a flag to zpool, then zswap used to determine if zpool
drivers such as zbud/z3fold/zsmalloc will enter an atomic context after
mapping.

The difference between zbud/z3fold and zsmalloc is that zsmalloc requires
an atomic context that since its map function holds a preempt-disabled,
but zbud/z3fold don't require an atomic context.  So patch #2 sets flag
sleep_mapped to true indicating that zbud/z3fold can sleep after mapping. 
zsmalloc didn't support sleep after mapping, so don't set that flag to
true.


This patch (of 2):

Add a flag to zpool, named is "can_sleep_mapped", and have it set true for
zbud/z3fold, not set this flag for zsmalloc, so its default value is
false.  Then zswap could go the current path if the flag is true; and if
it's false, copy data from src to a temporary buffer, then unmap the
handle, take the mutex, process the buffer instead of src to avoid
sleeping function called from atomic context.

[natechancellor@gmail.com: add return value in zswap_frontswap_load]
  Link: https://lkml.kernel.org/r/20210121214804.926843-1-natechancellor@gmail.com
[tiantao6@hisilicon.com: fix potential memory leak]
  Link: https://lkml.kernel.org/r/1611538365-51811-1-git-send-email-tiantao6@hisilicon.com
[colin.king@canonical.com: fix potential uninitialized pointer read on tmp]
  Link: https://lkml.kernel.org/r/20210128141728.639030-1-colin.king@canonical.com
[tiantao6@hisilicon.com: fix variable 'entry' is uninitialized when used]
  Link: https://lkml.kernel.org/r/1611223030-58346-1-git-send-email-tiantao6@hisilicon.comLink: https://lkml.kernel.org/r/1611035683-12732-1-git-send-email-tiantao6@hisilicon.com
Link: https://lkml.kernel.org/r/1611035683-12732-2-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Mike Galbraith <efault@gmx.de>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    3 ++
 mm/zpool.c            |   13 ++++++++++
 mm/zswap.c            |   51 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 62 insertions(+), 5 deletions(-)

--- a/include/linux/zpool.h~mm-zswap-add-the-flag-can_sleep_mapped
+++ a/include/linux/zpool.h
@@ -73,6 +73,7 @@ u64 zpool_get_total_size(struct zpool *p
  * @malloc:	allocate mem from a pool.
  * @free:	free mem from a pool.
  * @shrink:	shrink the pool.
+ * @sleep_mapped: whether zpool driver can sleep during map.
  * @map:	map a handle.
  * @unmap:	unmap a handle.
  * @total_size:	get total size of a pool.
@@ -100,6 +101,7 @@ struct zpool_driver {
 	int (*shrink)(void *pool, unsigned int pages,
 				unsigned int *reclaimed);
 
+	bool sleep_mapped;
 	void *(*map)(void *pool, unsigned long handle,
 				enum zpool_mapmode mm);
 	void (*unmap)(void *pool, unsigned long handle);
@@ -112,5 +114,6 @@ void zpool_register_driver(struct zpool_
 int zpool_unregister_driver(struct zpool_driver *driver);
 
 bool zpool_evictable(struct zpool *pool);
+bool zpool_can_sleep_mapped(struct zpool *pool);
 
 #endif
--- a/mm/zpool.c~mm-zswap-add-the-flag-can_sleep_mapped
+++ a/mm/zpool.c
@@ -23,6 +23,7 @@ struct zpool {
 	void *pool;
 	const struct zpool_ops *ops;
 	bool evictable;
+	bool can_sleep_mapped;
 
 	struct list_head list;
 };
@@ -183,6 +184,7 @@ struct zpool *zpool_create_pool(const ch
 	zpool->pool = driver->create(name, gfp, ops, zpool);
 	zpool->ops = ops;
 	zpool->evictable = driver->shrink && ops && ops->evict;
+	zpool->can_sleep_mapped = driver->sleep_mapped;
 
 	if (!zpool->pool) {
 		pr_err("couldn't create %s pool\n", type);
@@ -393,6 +395,17 @@ bool zpool_evictable(struct zpool *zpool
 	return zpool->evictable;
 }
 
+/**
+ * zpool_can_sleep_mapped - Test if zpool can sleep when do mapped.
+ * @zpool:	The zpool to test
+ *
+ * Returns: true if zpool can sleep; false otherwise.
+ */
+bool zpool_can_sleep_mapped(struct zpool *zpool)
+{
+	return zpool->can_sleep_mapped;
+}
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
 MODULE_DESCRIPTION("Common API for compressed memory storage");
--- a/mm/zswap.c~mm-zswap-add-the-flag-can_sleep_mapped
+++ a/mm/zswap.c
@@ -935,13 +935,19 @@ static int zswap_writeback_entry(struct
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
 
-	u8 *src;
+	u8 *src, *tmp = NULL;
 	unsigned int dlen;
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 	};
 
+	if (!zpool_can_sleep_mapped(pool)) {
+		tmp = kmalloc(PAGE_SIZE, GFP_ATOMIC);
+		if (!tmp)
+			return -ENOMEM;
+	}
+
 	/* extract swpentry from data */
 	zhdr = zpool_map_handle(pool, handle, ZPOOL_MM_RO);
 	swpentry = zhdr->swpentry; /* here */
@@ -955,6 +961,7 @@ static int zswap_writeback_entry(struct
 		/* entry was invalidated */
 		spin_unlock(&tree->lock);
 		zpool_unmap_handle(pool, handle);
+		kfree(tmp);
 		return 0;
 	}
 	spin_unlock(&tree->lock);
@@ -979,6 +986,14 @@ static int zswap_writeback_entry(struct
 		dlen = PAGE_SIZE;
 		src = (u8 *)zhdr + sizeof(struct zswap_header);
 
+		if (!zpool_can_sleep_mapped(pool)) {
+
+			memcpy(tmp, src, entry->length);
+			src = tmp;
+
+			zpool_unmap_handle(pool, handle);
+		}
+
 		mutex_lock(acomp_ctx->mutex);
 		sg_init_one(&input, src, entry->length);
 		sg_init_table(&output, 1);
@@ -1033,7 +1048,11 @@ fail:
 	spin_unlock(&tree->lock);
 
 end:
-	zpool_unmap_handle(pool, handle);
+	if (zpool_can_sleep_mapped(pool))
+		zpool_unmap_handle(pool, handle);
+	else
+		kfree(tmp);
+
 	return ret;
 }
 
@@ -1235,7 +1254,7 @@ static int zswap_frontswap_load(unsigned
 	struct zswap_entry *entry;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	u8 *src, *dst;
+	u8 *src, *dst, *tmp;
 	unsigned int dlen;
 	int ret;
 
@@ -1253,15 +1272,33 @@ static int zswap_frontswap_load(unsigned
 		dst = kmap_atomic(page);
 		zswap_fill_page(dst, entry->value);
 		kunmap_atomic(dst);
+		ret = 0;
 		goto freeentry;
 	}
 
+	if (!zpool_can_sleep_mapped(entry->pool->zpool)) {
+
+		tmp = kmalloc(entry->length, GFP_ATOMIC);
+		if (!tmp) {
+			ret = -ENOMEM;
+			goto freeentry;
+		}
+	}
+
 	/* decompress */
 	dlen = PAGE_SIZE;
 	src = zpool_map_handle(entry->pool->zpool, entry->handle, ZPOOL_MM_RO);
 	if (zpool_evictable(entry->pool->zpool))
 		src += sizeof(struct zswap_header);
 
+	if (!zpool_can_sleep_mapped(entry->pool->zpool)) {
+
+		memcpy(tmp, src, entry->length);
+		src = tmp;
+
+		zpool_unmap_handle(entry->pool->zpool, entry->handle);
+	}
+
 	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
 	mutex_lock(acomp_ctx->mutex);
 	sg_init_one(&input, src, entry->length);
@@ -1271,7 +1308,11 @@ static int zswap_frontswap_load(unsigned
 	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
 	mutex_unlock(acomp_ctx->mutex);
 
-	zpool_unmap_handle(entry->pool->zpool, entry->handle);
+	if (zpool_can_sleep_mapped(entry->pool->zpool))
+		zpool_unmap_handle(entry->pool->zpool, entry->handle);
+	else
+		kfree(tmp);
+
 	BUG_ON(ret);
 
 freeentry:
@@ -1279,7 +1320,7 @@ freeentry:
 	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
-	return 0;
+	return ret;
 }
 
 /* frees an entry in zswap */
_
