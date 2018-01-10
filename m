From: akpm@linux-foundation.org
Subject: + zswap-only-save-zswap-header-when-necessary.patch added to -mm
 tree
Date: Wed, 10 Jan 2018 15:32:43 -0800
Message-ID: <5a56a29b.OPfYabETUTuWgTLn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbeAJXco (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jan 2018 18:32:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, ddstreet@ieee.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: only save zswap header when necessary
has been added to the -mm tree.  Its filename is
     zswap-only-save-zswap-header-when-necessary.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-only-save-zswap-header-when-necessary.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-only-save-zswap-header-when-necessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: zswap: only save zswap header when necessary

We waste sizeof(swp_entry_t) for zswap header when using zsmalloc as zpool
driver because zsmalloc doesn't support eviction.

Add zpool_evictable() to detect if zpool is potentially evictable, and use
it in zswap to avoid waste memory for zswap header.

Link: http://lkml.kernel.org/r/20180110224741.83751-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    2 ++
 mm/zpool.c            |   26 ++++++++++++++++++++++++--
 mm/zsmalloc.c         |    7 -------
 mm/zswap.c            |   20 ++++++++++----------
 4 files changed, 36 insertions(+), 19 deletions(-)

diff -puN include/linux/zpool.h~zswap-only-save-zswap-header-when-necessary include/linux/zpool.h
--- a/include/linux/zpool.h~zswap-only-save-zswap-header-when-necessary
+++ a/include/linux/zpool.h
@@ -108,4 +108,6 @@ void zpool_register_driver(struct zpool_
 
 int zpool_unregister_driver(struct zpool_driver *driver);
 
+bool zpool_evictable(struct zpool *pool);
+
 #endif
diff -puN mm/zpool.c~zswap-only-save-zswap-header-when-necessary mm/zpool.c
--- a/mm/zpool.c~zswap-only-save-zswap-header-when-necessary
+++ a/mm/zpool.c
@@ -21,6 +21,7 @@ struct zpool {
 	struct zpool_driver *driver;
 	void *pool;
 	const struct zpool_ops *ops;
+	bool evictable;
 
 	struct list_head list;
 };
@@ -142,7 +143,7 @@ EXPORT_SYMBOL(zpool_has_pool);
  *
  * This creates a new zpool of the specified type.  The gfp flags will be
  * used when allocating memory, if the implementation supports it.  If the
- * ops param is NULL, then the created zpool will not be shrinkable.
+ * ops param is NULL, then the created zpool will not be evictable.
  *
  * Implementations must guarantee this to be thread-safe.
  *
@@ -180,6 +181,8 @@ struct zpool *zpool_create_pool(const ch
 	zpool->driver = driver;
 	zpool->pool = driver->create(name, gfp, ops, zpool);
 	zpool->ops = ops;
+	zpool->evictable = zpool->driver->shrink &&
+			   zpool->ops && zpool->ops->evict;
 
 	if (!zpool->pool) {
 		pr_err("couldn't create %s pool\n", type);
@@ -296,7 +299,8 @@ void zpool_free(struct zpool *zpool, uns
 int zpool_shrink(struct zpool *zpool, unsigned int pages,
 			unsigned int *reclaimed)
 {
-	return zpool->driver->shrink(zpool->pool, pages, reclaimed);
+	return zpool->driver->shrink ?
+	       zpool->driver->shrink(zpool->pool, pages, reclaimed) : -EINVAL;
 }
 
 /**
@@ -355,6 +359,24 @@ u64 zpool_get_total_size(struct zpool *z
 	return zpool->driver->total_size(zpool->pool);
 }
 
+/**
+ * zpool_evictable() - Test if zpool is potentially evictable
+ * @pool	The zpool to test
+ *
+ * Zpool is only potentially evictable when it's created with struct
+ * zpool_ops.evict and its driver implements struct zpool_driver.shrink.
+ *
+ * However, it doesn't necessarily mean driver will use zpool_ops.evict
+ * in its implementation of zpool_driver.shrink. It could do internal
+ * defragmentation instead.
+ *
+ * Returns: true if potentially evictable; false otherwise.
+ */
+bool zpool_evictable(struct zpool *zpool)
+{
+	return zpool->evictable;
+}
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
 MODULE_DESCRIPTION("Common API for compressed memory storage");
diff -puN mm/zsmalloc.c~zswap-only-save-zswap-header-when-necessary mm/zsmalloc.c
--- a/mm/zsmalloc.c~zswap-only-save-zswap-header-when-necessary
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
diff -puN mm/zswap.c~zswap-only-save-zswap-header-when-necessary mm/zswap.c
--- a/mm/zswap.c~zswap-only-save-zswap-header-when-necessary
+++ a/mm/zswap.c
@@ -1001,11 +1001,11 @@ static int zswap_frontswap_store(unsigne
 	struct zswap_entry *entry, *dupentry;
 	struct crypto_comp *tfm;
 	int ret;
-	unsigned int dlen = PAGE_SIZE, len;
+	unsigned int hlen, dlen = PAGE_SIZE;
 	unsigned long handle, value;
 	char *buf;
 	u8 *src, *dst;
-	struct zswap_header *zhdr;
+	struct zswap_header zhdr = { .swpentry = swp_entry(type, offset) };
 
 	if (!zswap_enabled || !tree) {
 		ret = -ENODEV;
@@ -1063,8 +1063,8 @@ static int zswap_frontswap_store(unsigne
 	}
 
 	/* store */
-	len = dlen + sizeof(struct zswap_header);
-	ret = zpool_malloc(entry->pool->zpool, len,
+	hlen = zpool_evictable(entry->pool->zpool) ? sizeof(zhdr) : 0;
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
+	if (zpool_evictable(entry->pool->zpool))
+		src += sizeof(struct zswap_header);
 	dst = kmap_atomic(page);
 	tfm = *get_cpu_ptr(entry->pool->tfm);
 	ret = crypto_comp_decompress(tfm, src, entry->length, dst, &dlen);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-dont-expose-page-to-fast-gup-before-its-ready.patch
zswap-only-save-zswap-header-when-necessary.patch
zswap-only-save-zswap-header-if-zpool-is-shrinkable.patch
memcg-refactor-mem_cgroup_resize_limit.patch

