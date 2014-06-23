From: akpm@linux-foundation.org
Subject: + mm-zpool-update-zswap-to-use-zpool.patch added to -mm tree
Date: Mon, 23 Jun 2014 14:49:11 -0700
Message-ID: <53a8a0d7.Ay5VFuUhQoOuGJNH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbaFWVtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 17:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, bob.liu@oracle.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, minchan@kernel.org, ngupta@vflare.org, riel@redhat.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: update zswap to use zpool
has been added to the -mm tree.  Its filename is
     mm-zpool-update-zswap-to-use-zpool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-update-zswap-to-use-zpool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-update-zswap-to-use-zpool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zpool: update zswap to use zpool

Change zswap to use the zpool api instead of directly using zbud.  Add a
boot-time param to allow selecting which zpool implementation to use, with
zbud as the default.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 -
 mm/zswap.c |   76 ++++++++++++++++++++++++++++++---------------------
 2 files changed, 46 insertions(+), 32 deletions(-)

diff -puN mm/Kconfig~mm-zpool-update-zswap-to-use-zpool mm/Kconfig
--- a/mm/Kconfig~mm-zpool-update-zswap-to-use-zpool
+++ a/mm/Kconfig
@@ -535,7 +535,7 @@ config ZSWAP
 	bool "Compressed cache for swap pages (EXPERIMENTAL)"
 	depends on FRONTSWAP && CRYPTO=y
 	select CRYPTO_LZO
-	select ZBUD
+	select ZPOOL
 	default n
 	help
 	  A lightweight compressed cache for swap pages.  It takes
diff -puN mm/zswap.c~mm-zpool-update-zswap-to-use-zpool mm/zswap.c
--- a/mm/zswap.c~mm-zpool-update-zswap-to-use-zpool
+++ a/mm/zswap.c
@@ -34,7 +34,7 @@
 #include <linux/swap.h>
 #include <linux/crypto.h>
 #include <linux/mempool.h>
-#include <linux/zbud.h>
+#include <linux/zpool.h>
 
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
@@ -45,8 +45,8 @@
 /*********************************
 * statistics
 **********************************/
-/* Number of memory pages used by the compressed pool */
-static u64 zswap_pool_pages;
+/* Total bytes used by the compressed storage */
+static u64 zswap_pool_total_size;
 /* The number of compressed pages currently stored in zswap */
 static atomic_t zswap_stored_pages = ATOMIC_INIT(0);
 
@@ -89,8 +89,13 @@ static unsigned int zswap_max_pool_perce
 module_param_named(max_pool_percent,
 			zswap_max_pool_percent, uint, 0644);
 
-/* zbud_pool is shared by all of zswap backend  */
-static struct zbud_pool *zswap_pool;
+/* Compressed storage to use */
+#define ZSWAP_ZPOOL_DEFAULT "zbud"
+static char *zswap_zpool_type = ZSWAP_ZPOOL_DEFAULT;
+module_param_named(zpool, zswap_zpool_type, charp, 0444);
+
+/* zpool is shared by all of zswap backend  */
+static struct zpool *zswap_pool;
 
 /*********************************
 * compression functions
@@ -168,7 +173,7 @@ static void zswap_comp_exit(void)
  *            be held while changing the refcount.  Since the lock must
  *            be held, there is no reason to also make refcount atomic.
  * offset - the swap offset for the entry.  Index into the red-black tree.
- * handle - zbud allocation handle that stores the compressed page data
+ * handle - zpool allocation handle that stores the compressed page data
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression
  */
@@ -284,15 +289,15 @@ static void zswap_rb_erase(struct rb_roo
 }
 
 /*
- * Carries out the common pattern of freeing and entry's zbud allocation,
+ * Carries out the common pattern of freeing and entry's zpool allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
 static void zswap_free_entry(struct zswap_entry *entry)
 {
-	zbud_free(zswap_pool, entry->handle);
+	zpool_free(zswap_pool, entry->handle);
 	zswap_entry_cache_free(entry);
 	atomic_dec(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(zswap_pool);
+	zswap_pool_total_size = zpool_get_total_size(zswap_pool);
 }
 
 /* caller must hold the tree lock */
@@ -409,7 +414,7 @@ cleanup:
 static bool zswap_is_full(void)
 {
 	return totalram_pages * zswap_max_pool_percent / 100 <
-		zswap_pool_pages;
+		DIV_ROUND_UP(zswap_pool_total_size, PAGE_SIZE);
 }
 
 /*********************************
@@ -525,7 +530,7 @@ static int zswap_get_swap_cache_page(swp
  * the swap cache, the compressed version stored by zswap can be
  * freed.
  */
-static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
+static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 {
 	struct zswap_header *zhdr;
 	swp_entry_t swpentry;
@@ -541,9 +546,9 @@ static int zswap_writeback_entry(struct
 	};
 
 	/* extract swpentry from data */
-	zhdr = zbud_map(pool, handle);
+	zhdr = zpool_map_handle(pool, handle, ZPOOL_MM_RO);
 	swpentry = zhdr->swpentry; /* here */
-	zbud_unmap(pool, handle);
+	zpool_unmap_handle(pool, handle);
 	tree = zswap_trees[swp_type(swpentry)];
 	offset = swp_offset(swpentry);
 
@@ -573,13 +578,13 @@ static int zswap_writeback_entry(struct
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
 		/* decompress */
 		dlen = PAGE_SIZE;
-		src = (u8 *)zbud_map(zswap_pool, entry->handle) +
-			sizeof(struct zswap_header);
+		src = (u8 *)zpool_map_handle(zswap_pool, entry->handle,
+				ZPOOL_MM_RO) + sizeof(struct zswap_header);
 		dst = kmap_atomic(page);
 		ret = zswap_comp_op(ZSWAP_COMPOP_DECOMPRESS, src,
 				entry->length, dst, &dlen);
 		kunmap_atomic(dst);
-		zbud_unmap(zswap_pool, entry->handle);
+		zpool_unmap_handle(zswap_pool, entry->handle);
 		BUG_ON(ret);
 		BUG_ON(dlen != PAGE_SIZE);
 
@@ -652,7 +657,7 @@ static int zswap_frontswap_store(unsigne
 	/* reclaim space if needed */
 	if (zswap_is_full()) {
 		zswap_pool_limit_hit++;
-		if (zbud_reclaim_page(zswap_pool, 8)) {
+		if (zpool_shrink(zswap_pool, 1, NULL)) {
 			zswap_reject_reclaim_fail++;
 			ret = -ENOMEM;
 			goto reject;
@@ -679,7 +684,7 @@ static int zswap_frontswap_store(unsigne
 
 	/* store */
 	len = dlen + sizeof(struct zswap_header);
-	ret = zbud_alloc(zswap_pool, len, &handle);
+	ret = zpool_malloc(zswap_pool, len, &handle);
 	if (ret == -ENOSPC) {
 		zswap_reject_compress_poor++;
 		goto freepage;
@@ -688,11 +693,11 @@ static int zswap_frontswap_store(unsigne
 		zswap_reject_alloc_fail++;
 		goto freepage;
 	}
-	zhdr = zbud_map(zswap_pool, handle);
+	zhdr = zpool_map_handle(zswap_pool, handle, ZPOOL_MM_RW);
 	zhdr->swpentry = swp_entry(type, offset);
 	buf = (u8 *)(zhdr + 1);
 	memcpy(buf, dst, dlen);
-	zbud_unmap(zswap_pool, handle);
+	zpool_unmap_handle(zswap_pool, handle);
 	put_cpu_var(zswap_dstmem);
 
 	/* populate entry */
@@ -715,7 +720,7 @@ static int zswap_frontswap_store(unsigne
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(zswap_pool);
+	zswap_pool_total_size = zpool_get_total_size(zswap_pool);
 
 	return 0;
 
@@ -751,13 +756,13 @@ static int zswap_frontswap_load(unsigned
 
 	/* decompress */
 	dlen = PAGE_SIZE;
-	src = (u8 *)zbud_map(zswap_pool, entry->handle) +
-			sizeof(struct zswap_header);
+	src = (u8 *)zpool_map_handle(zswap_pool, entry->handle,
+			ZPOOL_MM_RO) + sizeof(struct zswap_header);
 	dst = kmap_atomic(page);
 	ret = zswap_comp_op(ZSWAP_COMPOP_DECOMPRESS, src, entry->length,
 		dst, &dlen);
 	kunmap_atomic(dst);
-	zbud_unmap(zswap_pool, entry->handle);
+	zpool_unmap_handle(zswap_pool, entry->handle);
 	BUG_ON(ret);
 
 	spin_lock(&tree->lock);
@@ -810,7 +815,7 @@ static void zswap_frontswap_invalidate_a
 	zswap_trees[type] = NULL;
 }
 
-static struct zbud_ops zswap_zbud_ops = {
+static struct zpool_ops zswap_zpool_ops = {
 	.evict = zswap_writeback_entry
 };
 
@@ -868,8 +873,8 @@ static int __init zswap_debugfs_init(voi
 			zswap_debugfs_root, &zswap_written_back_pages);
 	debugfs_create_u64("duplicate_entry", S_IRUGO,
 			zswap_debugfs_root, &zswap_duplicate_entry);
-	debugfs_create_u64("pool_pages", S_IRUGO,
-			zswap_debugfs_root, &zswap_pool_pages);
+	debugfs_create_u64("pool_total_size", S_IRUGO,
+			zswap_debugfs_root, &zswap_pool_total_size);
 	debugfs_create_atomic_t("stored_pages", S_IRUGO,
 			zswap_debugfs_root, &zswap_stored_pages);
 
@@ -894,17 +899,26 @@ static void __exit zswap_debugfs_exit(vo
 **********************************/
 static int __init init_zswap(void)
 {
+	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN;
+
 	if (!zswap_enabled)
 		return 0;
 
 	pr_info("loading zswap\n");
 
-	zswap_pool = zbud_create_pool(__GFP_NORETRY | __GFP_NOWARN,
-			&zswap_zbud_ops);
+	zswap_pool = zpool_create_pool(zswap_zpool_type, gfp, &zswap_zpool_ops);
+	if (!zswap_pool && strcmp(zswap_zpool_type, ZSWAP_ZPOOL_DEFAULT)) {
+		pr_info("%s zpool not available\n", zswap_zpool_type);
+		zswap_zpool_type = ZSWAP_ZPOOL_DEFAULT;
+		zswap_pool = zpool_create_pool(zswap_zpool_type, gfp,
+					       &zswap_zpool_ops);
+	}
 	if (!zswap_pool) {
-		pr_err("zbud pool creation failed\n");
+		pr_err("%s zpool not available\n", zswap_zpool_type);
+		pr_err("zpool creation failed\n");
 		goto error;
 	}
+	pr_info("using %s pool\n", zswap_zpool_type);
 
 	if (zswap_entry_cache_create()) {
 		pr_err("entry cache creation failed\n");
@@ -928,7 +942,7 @@ pcpufail:
 compfail:
 	zswap_entry_cache_destroy();
 cachefail:
-	zbud_destroy_pool(zswap_pool);
+	zpool_destroy_pool(zswap_pool);
 error:
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch

