From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zswap-only-save-zswap-header-if-zpool-is-shrinkable.patch removed from -mm
 tree
Date: Wed, 10 Jan 2018 15:32:54 -0800
Message-ID: <5a56a2a6.qXM/a2kmlos2g8Bq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751896AbeAJXc4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jan 2018 18:32:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, ddstreet@ieee.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: only save zswap header if zpool is shrinkable
has been removed from the -mm tree.  Its filename was
     zswap-only-save-zswap-header-if-zpool-is-shrinkable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: zswap: only save zswap header if zpool is shrinkable

We waste sizeof(swp_entry_t) for zswap header when using zsmalloc
as zpool driver because zsmalloc doesn't support eviction.

Add zpool_shrinkable() to detect if zpool is shrinkable, and use
it in zswap to avoid waste memory for zswap header.

Link: http://lkml.kernel.org/r/20180108225101.15790-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    2 ++
 mm/zpool.c            |   17 ++++++++++++++++-
 mm/zsmalloc.c         |    7 -------
 mm/zswap.c            |   16 ++++++++--------
 4 files changed, 26 insertions(+), 16 deletions(-)

diff -puN include/linux/zpool.h~zswap-only-save-zswap-header-if-zpool-is-shrinkable include/linux/zpool.h
--- a/include/linux/zpool.h~zswap-only-save-zswap-header-if-zpool-is-shrinkable
+++ a/include/linux/zpool.h
@@ -108,4 +108,6 @@ void zpool_register_driver(struct zpool_
 
 int zpool_unregister_driver(struct zpool_driver *driver);
 
+bool zpool_shrinkable(struct zpool *pool);
+
 #endif
diff -puN mm/zpool.c~zswap-only-save-zswap-header-if-zpool-is-shrinkable mm/zpool.c
--- a/mm/zpool.c~zswap-only-save-zswap-header-if-zpool-is-shrinkable
+++ a/mm/zpool.c
@@ -296,7 +296,8 @@ void zpool_free(struct zpool *zpool, uns
 int zpool_shrink(struct zpool *zpool, unsigned int pages,
 			unsigned int *reclaimed)
 {
-	return zpool->driver->shrink(zpool->pool, pages, reclaimed);
+	return zpool_shrinkable(zpool) ?
+	       zpool->driver->shrink(zpool->pool, pages, reclaimed) : -EINVAL;
 }
 
 /**
@@ -355,6 +356,20 @@ u64 zpool_get_total_size(struct zpool *z
 	return zpool->driver->total_size(zpool->pool);
 }
 
+/**
+ * zpool_shrinkable() - Test if zpool is shrinkable
+ * @pool	The zpool to test
+ *
+ * Zpool is only shrinkable when it's created with struct
+ * zpool_ops.evict and its driver implements struct zpool_driver.shrink.
+ *
+ * Returns: true if shrinkable; false otherwise.
+ */
+bool zpool_shrinkable(struct zpool *zpool)
+{
+	return zpool->ops && zpool->ops->evict && zpool->driver->shrink;
+}
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
 MODULE_DESCRIPTION("Common API for compressed memory storage");
diff -puN mm/zsmalloc.c~zswap-only-save-zswap-header-if-zpool-is-shrinkable mm/zsmalloc.c
--- a/mm/zsmalloc.c~zswap-only-save-zswap-header-if-zpool-is-shrinkable
+++ a/mm/zsmalloc.c
@@ -404,12 +404,6 @@ static void zs_zpool_free(void *pool, un
 	zs_free(pool, handle);
 }
 
-static int zs_zpool_shrink(void *pool, unsigned int pages,
-			unsigned int *reclaimed)
-{
-	return -EINVAL;
-}
-
 static void *zs_zpool_map(void *pool, unsigned long handle,
 			enum zpool_mapmode mm)
 {
@@ -447,7 +441,6 @@ static struct zpool_driver zs_zpool_driv
 	.destroy =	zs_zpool_destroy,
 	.malloc =	zs_zpool_malloc,
 	.free =		zs_zpool_free,
-	.shrink =	zs_zpool_shrink,
 	.map =		zs_zpool_map,
 	.unmap =	zs_zpool_unmap,
 	.total_size =	zs_zpool_total_size,
diff -puN mm/zswap.c~zswap-only-save-zswap-header-if-zpool-is-shrinkable mm/zswap.c
--- a/mm/zswap.c~zswap-only-save-zswap-header-if-zpool-is-shrinkable
+++ a/mm/zswap.c
@@ -1063,8 +1063,8 @@ static int zswap_frontswap_store(unsigne
 	}
 
 	/* store */
-	len = dlen + sizeof(struct zswap_header);
-	ret = zpool_malloc(entry->pool->zpool, len,
+	hlen = zpool_shrinkable(entry->pool->zpool) ? sizeof(zhdr) : 0;
+	ret = zpool_malloc(entry->pool->zpool, hlen + dlen,
 			   __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM,
 			   &handle);
 	if (ret == -ENOSPC) {
@@ -1075,10 +1075,9 @@ static int zswap_frontswap_store(unsigne
 		zswap_reject_alloc_fail++;
 		goto put_dstmem;
 	}
-	zhdr = zpool_map_handle(entry->pool->zpool, handle, ZPOOL_MM_RW);
-	zhdr->swpentry = swp_entry(type, offset);
-	buf = (u8 *)(zhdr + 1);
-	memcpy(buf, dst, dlen);
+	buf = zpool_map_handle(entry->pool->zpool, handle, ZPOOL_MM_RW);
+	memcpy(buf, &zhdr, hlen);
+	memcpy(buf + hlen, dst, dlen);
 	zpool_unmap_handle(entry->pool->zpool, handle);
 	put_cpu_var(zswap_dstmem);
 
@@ -1149,8 +1148,9 @@ static int zswap_frontswap_load(unsigned
 
 	/* decompress */
 	dlen = PAGE_SIZE;
-	src = (u8 *)zpool_map_handle(entry->pool->zpool, entry->handle,
-			ZPOOL_MM_RO) + sizeof(struct zswap_header);
+	src = zpool_map_handle(entry->pool->zpool, entry->handle, ZPOOL_MM_RO);
+	if (zpool_shrinkable(entry->pool->zpool))
+		src += sizeof(struct zswap_header);
 	dst = kmap_atomic(page);
 	tfm = *get_cpu_ptr(entry->pool->tfm);
 	ret = crypto_comp_decompress(tfm, src, entry->length, dst, &dlen);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-dont-expose-page-to-fast-gup-before-its-ready.patch
zswap-only-save-zswap-header-when-necessary.patch
memcg-refactor-mem_cgroup_resize_limit.patch

