From: akpm@linux-foundation.org
Subject: [to-be-updated]
 z3fold-the-3-fold-allocator-for-compressed-pages-v3.patch removed from -mm
 tree
Date: Mon, 09 May 2016 13:46:06 -0700
Message-ID: <5730f70e.KG24PcUCYPR2SSfq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbcEIUqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 16:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, sjenning@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold-the-3-fold-allocator-for-compressed-pages-v3
has been removed from the -mm tree.  Its filename was
     z3fold-the-3-fold-allocator-for-compressed-pages-v3.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold-the-3-fold-allocator-for-compressed-pages-v3

The changes since the last version (v2) are:
* addressed checkpatch rants
* incorporated fixes basing on feedback from akpm in [2]
* added Documentation/vm/z3fold.txt
* improved free space accounting for a page, allowing for better object
  packing within a page.

The changes since the first (v1) version are:
* various concurrency fixes made after intensive testing on SMP/HMP
  platforms.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/z3fold.txt |   27 +++
 mm/Kconfig                  |    3 
 mm/z3fold.c                 |  300 +++++++++++++++++-----------------
 3 files changed, 185 insertions(+), 145 deletions(-)

diff -puN /dev/null Documentation/vm/z3fold.txt
--- /dev/null
+++ a/Documentation/vm/z3fold.txt
@@ -0,0 +1,27 @@
+z3fold
+------
+
+z3fold is a special purpose allocator for storing compressed pages.
+It is designed to store up to three compressed pages per physical page.
+It is a zbud derivative which allows for higher compression
+ratio keeping the simplicity and determinism of its predecessor.
+
+The main differences between z3fold and zbud are:
+* unlike zbud, z3fold allows for up to PAGE_SIZE allocations
+* z3fold can hold up to 3 compressed pages in its page
+* z3fold doesn't export any API itself and is thus intended to be used
+  via the zpool API.
+
+To keep the determinism and simplicity, z3fold, just like zbud, always
+stores an integral number of compressed pages per page, but it can store
+up to 3 pages unlike zbud which can store at most 2. Therefore the
+compression ratio goes to around 2.7x while zbud's one is around 1.7x.
+
+Unlike zbud (but like zsmalloc for that matter) z3fold_alloc() does not
+return a dereferenceable pointer. Instead, it returns an unsigned long
+handle which encodes actual location of the allocated object.
+
+Keeping effective compression ratio close to zsmalloc's, z3fold doesn't
+depend on MMU enabled and provides more predictable reclaim behavior
+which makes it a better fit for small and response-critical systems.
+
diff -puN mm/Kconfig~z3fold-the-3-fold-allocator-for-compressed-pages-v3 mm/Kconfig
--- a/mm/Kconfig~z3fold-the-3-fold-allocator-for-compressed-pages-v3
+++ a/mm/Kconfig
@@ -577,7 +577,8 @@ config ZBUD
 	  density approach when reclaim will be used.
 
 config Z3FOLD
-	tristate "Low density storage for compressed pages"
+	tristate "Higher density storage for compressed pages"
+	depends on ZPOOL
 	default n
 	help
 	  A special purpose allocator for storing compressed pages.
diff -puN mm/z3fold.c~z3fold-the-3-fold-allocator-for-compressed-pages-v3 mm/z3fold.c
--- a/mm/z3fold.c~z3fold-the-3-fold-allocator-for-compressed-pages-v3
+++ a/mm/z3fold.c
@@ -1,18 +1,21 @@
 /*
  * z3fold.c
  *
- * Copyright (C) 2016, Vitaly Wool <vitalywool@gmail.com>
+ * Author: Vitaly Wool <vitalywool@gmail.com>
+ * Copyright (C) 2016, Sony Mobile Communications Inc.
  *
  * This implementation is heavily based on zbud written by Seth Jennings.
  *
  * z3fold is an special purpose allocator for storing compressed pages. It
  * can store up to three compressed pages per page which improves the
- * compression ratio of zbud while pertaining its concept and simplicity.
+ * compression ratio of zbud while retaining its main concepts (e. g. always
+ * storing an integral number of objects per page) and simplicity.
  * It still has simple and deterministic reclaim properties that make it
- * preferable to a higher density approach when reclaim is used.
+ * preferable to a higher density approach (with no requirement on integral
+ * number of object per page) when reclaim is used.
  *
  * As in zbud, pages are divided into "chunks".  The size of the chunks is
- * fixed at compile time and determined by NCHUNKS_ORDER below.
+ * fixed at compile time and is determined by NCHUNKS_ORDER below.
  *
  * The z3fold API doesn't differ from zbud API and zpool is also supported.
  */
@@ -36,9 +39,9 @@
  * adjusting internal fragmentation.  It also determines the number of
  * freelists maintained in each pool. NCHUNKS_ORDER of 6 means that the
  * allocation granularity will be in chunks of size PAGE_SIZE/64. As one chunk
- * in allocated page is occupied by z3fold header, NCHUNKS will be calculated to
- * 63 which shows the max number of free chunks in z3fold page, also there will be
- * 63 freelists per pool.
+ * in allocated page is occupied by z3fold header, NCHUNKS will be calculated
+ * to 63 which shows the max number of free chunks in z3fold page, also there
+ * will be 63 freelists per pool.
  */
 #define NCHUNKS_ORDER	6
 
@@ -54,17 +57,6 @@ struct z3fold_ops {
 	int (*evict)(struct z3fold_pool *pool, unsigned long handle);
 };
 
-/* Forward declarations */
-struct z3fold_pool *z3fold_create_pool(gfp_t gfp, const struct z3fold_ops *ops);
-void z3fold_destroy_pool(struct z3fold_pool *pool);
-int z3fold_alloc(struct z3fold_pool *pool, size_t size, gfp_t gfp,
-	unsigned long *handle);
-void z3fold_free(struct z3fold_pool *pool, unsigned long handle);
-int z3fold_reclaim_page(struct z3fold_pool *pool, unsigned int retries);
-void *z3fold_map(struct z3fold_pool *pool, unsigned long handle);
-void z3fold_unmap(struct z3fold_pool *pool, unsigned long handle);
-u64 z3fold_get_pool_size(struct z3fold_pool *pool);
-
 /**
  * struct z3fold_pool - stores metadata for each z3fold pool
  * @lock:	protects all pool fields and first|last_chunk fields of any
@@ -132,103 +124,6 @@ enum z3fold_page_flags {
 };
 
 /*****************
- * zpool
- ****************/
-
-#ifdef CONFIG_ZPOOL
-
-static int z3fold_zpool_evict(struct z3fold_pool *pool, unsigned long handle)
-{
-	if (pool->zpool && pool->zpool_ops && pool->zpool_ops->evict)
-		return pool->zpool_ops->evict(pool->zpool, handle);
-	else
-		return -ENOENT;
-}
-
-static const struct z3fold_ops z3fold_zpool_ops = {
-	.evict =	z3fold_zpool_evict
-};
-
-static void *z3fold_zpool_create(const char *name, gfp_t gfp,
-			       const struct zpool_ops *zpool_ops,
-			       struct zpool *zpool)
-{
-	struct z3fold_pool *pool;
-
-	pool = z3fold_create_pool(gfp, zpool_ops ? &z3fold_zpool_ops : NULL);
-	if (pool) {
-		pool->zpool = zpool;
-		pool->zpool_ops = zpool_ops;
-	}
-	return pool;
-}
-
-static void z3fold_zpool_destroy(void *pool)
-{
-	z3fold_destroy_pool(pool);
-}
-
-static int z3fold_zpool_malloc(void *pool, size_t size, gfp_t gfp,
-			unsigned long *handle)
-{
-	return z3fold_alloc(pool, size, gfp, handle);
-}
-static void z3fold_zpool_free(void *pool, unsigned long handle)
-{
-	z3fold_free(pool, handle);
-}
-
-static int z3fold_zpool_shrink(void *pool, unsigned int pages,
-			unsigned int *reclaimed)
-{
-	unsigned int total = 0;
-	int ret = -EINVAL;
-
-	while (total < pages) {
-		ret = z3fold_reclaim_page(pool, 8);
-		if (ret < 0)
-			break;
-		total++;
-	}
-
-	if (reclaimed)
-		*reclaimed = total;
-
-	return ret;
-}
-
-static void *z3fold_zpool_map(void *pool, unsigned long handle,
-			enum zpool_mapmode mm)
-{
-	return z3fold_map(pool, handle);
-}
-static void z3fold_zpool_unmap(void *pool, unsigned long handle)
-{
-	z3fold_unmap(pool, handle);
-}
-
-static u64 z3fold_zpool_total_size(void *pool)
-{
-	return z3fold_get_pool_size(pool) * PAGE_SIZE;
-}
-
-static struct zpool_driver z3fold_zpool_driver = {
-	.type =		"z3fold",
-	.owner =	THIS_MODULE,
-	.create =	z3fold_zpool_create,
-	.destroy =	z3fold_zpool_destroy,
-	.malloc =	z3fold_zpool_malloc,
-	.free =		z3fold_zpool_free,
-	.shrink =	z3fold_zpool_shrink,
-	.map =		z3fold_zpool_map,
-	.unmap =	z3fold_zpool_unmap,
-	.total_size =	z3fold_zpool_total_size,
-};
-
-MODULE_ALIAS("zpool-z3fold");
-#endif /* CONFIG_ZPOOL */
-
-/*****************
  * Helpers
 *****************/
 
@@ -249,6 +144,7 @@ static struct z3fold_header *init_z3fold
 	INIT_LIST_HEAD(&page->lru);
 	clear_bit(UNDER_RECLAIM, &page->private);
 	clear_bit(PAGE_HEADLESS, &page->private);
+	clear_bit(MIDDLE_CHUNK_MAPPED, &page->private);
 
 	zhdr->first_chunks = 0;
 	zhdr->middle_chunks = 0;
@@ -273,7 +169,7 @@ static unsigned long encode_handle(struc
 {
 	unsigned long handle;
 
- 	handle = (unsigned long)zhdr;
+	handle = (unsigned long)zhdr;
 	if (bud != HEADLESS)
 		handle += (bud + zhdr->first_num) & BUDDY_MASK;
 	return handle;
@@ -293,16 +189,18 @@ static int num_free_chunks(struct z3fold
 {
 	int nfree;
 	/*
-	 * There is one special case, where first_chunks == 0 and
-	 * middle_chunks != 0. In this case there may be a hole between
-	 * the middle and the last objects, or middle object may be in use
-	 * and thus temporarily unmovable.
+	 * If there is a middle object, pick up the bigger free space
+	 * either before or after it. Otherwise just subtract the number
+	 * of chunks occupied by the first and the last objects.
 	 */
-	if (zhdr->first_chunks == 0 && zhdr->middle_chunks != 0)
-		nfree = zhdr->start_middle - 1;
-	else
-		nfree = NCHUNKS - zhdr->first_chunks -
-			zhdr->middle_chunks - zhdr->last_chunks;
+	if (zhdr->middle_chunks != 0) {
+		int nfree_before = zhdr->first_chunks ?
+			0 : zhdr->start_middle - 1;
+		int nfree_after = zhdr->last_chunks ?
+			0 : NCHUNKS - zhdr->start_middle - zhdr->middle_chunks;
+		nfree = max(nfree_before, nfree_after);
+	} else
+		nfree = NCHUNKS - zhdr->first_chunks - zhdr->last_chunks;
 	return nfree;
 }
 
@@ -350,19 +248,27 @@ void z3fold_destroy_pool(struct z3fold_p
 static int z3fold_compact_page(struct z3fold_header *zhdr)
 {
 	struct page *page = virt_to_page(zhdr);
+	void *beg = zhdr;
 
-	if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0 &&
-	    zhdr->middle_chunks != 0 &&
-	    !test_bit(MIDDLE_CHUNK_MAPPED, &page->private)) {
-		/* move middle chunk to the first chunk */
-		memmove((void *)zhdr + ZHDR_SIZE_ALIGNED,
-			(void *)zhdr + (zhdr->start_middle << CHUNK_SHIFT),
-			zhdr->middle_chunks << CHUNK_SHIFT);
-		zhdr->first_chunks = zhdr->middle_chunks;
-		zhdr->middle_chunks = 0;
-		zhdr->start_middle = 0;
-		zhdr->first_num++;
-		return 1;
+	if (!test_bit(MIDDLE_CHUNK_MAPPED, &page->private) &&
+	    zhdr->middle_chunks != 0) {
+		if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
+			memmove(beg + ZHDR_SIZE_ALIGNED,
+				beg + (zhdr->start_middle << CHUNK_SHIFT),
+				zhdr->middle_chunks << CHUNK_SHIFT);
+			zhdr->first_chunks = zhdr->middle_chunks;
+			zhdr->middle_chunks = 0;
+			zhdr->start_middle = 0;
+			zhdr->first_num++;
+			return 1;
+		} else if (zhdr->first_chunks != 0 &&
+			   zhdr->start_middle != zhdr->first_chunks + 1) {
+			memmove(beg + ((zhdr->first_chunks+1) << CHUNK_SHIFT),
+				beg + (zhdr->start_middle << CHUNK_SHIFT),
+				zhdr->middle_chunks << CHUNK_SHIFT);
+			zhdr->start_middle = zhdr->first_chunks + 1;
+			return 1;
+		}
 	}
 	return 0;
 }
@@ -416,18 +322,21 @@ int z3fold_alloc(struct z3fold_pool *poo
 				if (zhdr->first_chunks == 0) {
 					if (zhdr->middle_chunks == 0)
 						bud = FIRST;
-					else if (zhdr->last_chunks == 0 &&
-						 z3fold_compact_page(zhdr))
+					else if (chunks >= zhdr->start_middle)
 						bud = LAST;
-					else
+					else if (test_bit(MIDDLE_CHUNK_MAPPED,
+						     &page->private))
 						continue;
+					else
+						bud = FIRST;
 				} else if (zhdr->last_chunks == 0)
 					bud = LAST;
 				else if (zhdr->middle_chunks == 0)
 					bud = MIDDLE;
 				else {
 					pr_err("No free chunks in unbuddied\n");
-					BUG();
+					WARN_ON(1);
+					continue;
 				}
 				list_del(&zhdr->buddy);
 				goto found;
@@ -451,6 +360,9 @@ int z3fold_alloc(struct z3fold_pool *poo
 	}
 
 found:
+	if (zhdr->middle_chunks != 0)
+		z3fold_compact_page(zhdr);
+
 	if (bud == FIRST)
 		zhdr->first_chunks = chunks;
 	else if (bud == LAST)
@@ -523,8 +435,9 @@ void z3fold_free(struct z3fold_pool *poo
 			break;
 		default:
 			pr_err("%s: unknown bud %d\n", __func__, bud);
-			BUG();
-			break;
+			WARN_ON(1);
+			spin_unlock(&pool->lock);
+			return;
 		}
 	}
 
@@ -733,7 +646,8 @@ void *z3fold_map(struct z3fold_pool *poo
 		break;
 	default:
 		pr_err("unknown buddy id %d\n", buddy);
-		BUG();
+		WARN_ON(1);
+		addr = NULL;
 		break;
 	}
 out:
@@ -779,6 +693,104 @@ u64 z3fold_get_pool_size(struct z3fold_p
 	return pool->pages_nr;
 }
 
+/*****************
+ * zpool
+ ****************/
+
+#ifdef CONFIG_ZPOOL
+
+static int z3fold_zpool_evict(struct z3fold_pool *pool, unsigned long handle)
+{
+	if (pool->zpool && pool->zpool_ops && pool->zpool_ops->evict)
+		return pool->zpool_ops->evict(pool->zpool, handle);
+	else
+		return -ENOENT;
+}
+
+static const struct z3fold_ops z3fold_zpool_ops = {
+	.evict =	z3fold_zpool_evict
+};
+
+static void *z3fold_zpool_create(const char *name, gfp_t gfp,
+			       const struct zpool_ops *zpool_ops,
+			       struct zpool *zpool)
+{
+	struct z3fold_pool *pool;
+
+	pool = z3fold_create_pool(gfp, zpool_ops ? &z3fold_zpool_ops : NULL);
+	if (pool) {
+		pool->zpool = zpool;
+		pool->zpool_ops = zpool_ops;
+	}
+	return pool;
+}
+
+static void z3fold_zpool_destroy(void *pool)
+{
+	z3fold_destroy_pool(pool);
+}
+
+static int z3fold_zpool_malloc(void *pool, size_t size, gfp_t gfp,
+			unsigned long *handle)
+{
+	return z3fold_alloc(pool, size, gfp, handle);
+}
+static void z3fold_zpool_free(void *pool, unsigned long handle)
+{
+	z3fold_free(pool, handle);
+}
+
+static int z3fold_zpool_shrink(void *pool, unsigned int pages,
+			unsigned int *reclaimed)
+{
+	unsigned int total = 0;
+	int ret = -EINVAL;
+
+	while (total < pages) {
+		ret = z3fold_reclaim_page(pool, 8);
+		if (ret < 0)
+			break;
+		total++;
+	}
+
+	if (reclaimed)
+		*reclaimed = total;
+
+	return ret;
+}
+
+static void *z3fold_zpool_map(void *pool, unsigned long handle,
+			enum zpool_mapmode mm)
+{
+	return z3fold_map(pool, handle);
+}
+static void z3fold_zpool_unmap(void *pool, unsigned long handle)
+{
+	z3fold_unmap(pool, handle);
+}
+
+static u64 z3fold_zpool_total_size(void *pool)
+{
+	return z3fold_get_pool_size(pool) * PAGE_SIZE;
+}
+
+static struct zpool_driver z3fold_zpool_driver = {
+	.type =		"z3fold",
+	.owner =	THIS_MODULE,
+	.create =	z3fold_zpool_create,
+	.destroy =	z3fold_zpool_destroy,
+	.malloc =	z3fold_zpool_malloc,
+	.free =		z3fold_zpool_free,
+	.shrink =	z3fold_zpool_shrink,
+	.map =		z3fold_zpool_map,
+	.unmap =	z3fold_zpool_unmap,
+	.total_size =	z3fold_zpool_total_size,
+};
+
+MODULE_ALIAS("zpool-z3fold");
+#endif /* CONFIG_ZPOOL */
+
+
 static int __init init_z3fold(void)
 {
 	/* Make sure the z3fold header will fit in one chunk */
_

Patches currently in -mm which might be from vitalywool@gmail.com are


