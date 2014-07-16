From: akpm@linux-foundation.org
Subject: [withdrawn] mm-zbud-zbud_alloc-minor-param-change.patch removed
 from -mm tree
Date: Wed, 16 Jul 2014 14:09:59 -0700
Message-ID: <53c6ea27.GDl15SePbitkaacN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42838 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaGPVKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 17:10:00 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so209053yhl.5
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 14:10:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, bob.liu@oracle.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, minchan@kernel.org, ngupta@vflare.org, riel@redhat.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: zbud_alloc() minor param change
has been removed from the -mm tree.  Its filename was
     mm-zbud-zbud_alloc-minor-param-change.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zbud: zbud_alloc() minor param change

Change zbud to store gfp_t flags passed at pool creation to use for
each alloc; this allows the api to be closer to the existing zsmalloc
interface, and the only current zbud user (zswap) uses the same gfp
flags for all allocs.  Update zswap to use changed interface.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Seth Jennings <sjennings@variantweb.net>
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

 include/linux/zbud.h |    2 +-
 mm/zbud.c            |   27 +++++++++++++++------------
 mm/zswap.c           |    6 +++---
 3 files changed, 19 insertions(+), 16 deletions(-)

diff -puN include/linux/zbud.h~mm-zbud-zbud_alloc-minor-param-change include/linux/zbud.h
--- a/include/linux/zbud.h~mm-zbud-zbud_alloc-minor-param-change
+++ a/include/linux/zbud.h
@@ -11,7 +11,7 @@ struct zbud_ops {
 
 struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops);
 void zbud_destroy_pool(struct zbud_pool *pool);
-int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, unsigned int size,
 	unsigned long *handle);
 void zbud_free(struct zbud_pool *pool, unsigned long handle);
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
diff -puN mm/zbud.c~mm-zbud-zbud_alloc-minor-param-change mm/zbud.c
--- a/mm/zbud.c~mm-zbud-zbud_alloc-minor-param-change
+++ a/mm/zbud.c
@@ -94,6 +94,7 @@ struct zbud_pool {
 	struct list_head lru;
 	u64 pages_nr;
 	struct zbud_ops *ops;
+	gfp_t gfp;
 };
 
 /*
@@ -193,9 +194,12 @@ static int num_free_chunks(struct zbud_h
 *****************/
 /**
  * zbud_create_pool() - create a new zbud pool
- * @gfp:	gfp flags when allocating the zbud pool structure
+ * @gfp:	gfp flags when growing the pool
  * @ops:	user-defined operations for the zbud pool
  *
+ * gfp should not set __GFP_HIGHMEM as highmem pages cannot be used
+ * as zbud pool pages.
+ *
  * Return: pointer to the new zbud pool or NULL if the metadata allocation
  * failed.
  */
@@ -204,7 +208,9 @@ struct zbud_pool *zbud_create_pool(gfp_t
 	struct zbud_pool *pool;
 	int i;
 
-	pool = kmalloc(sizeof(struct zbud_pool), gfp);
+	if (gfp & __GFP_HIGHMEM)
+		return NULL;
+	pool = kmalloc(sizeof(struct zbud_pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
 	spin_lock_init(&pool->lock);
@@ -214,6 +220,7 @@ struct zbud_pool *zbud_create_pool(gfp_t
 	INIT_LIST_HEAD(&pool->lru);
 	pool->pages_nr = 0;
 	pool->ops = ops;
+	pool->gfp = gfp;
 	return pool;
 }
 
@@ -232,7 +239,6 @@ void zbud_destroy_pool(struct zbud_pool
  * zbud_alloc() - allocates a region of a given size
  * @pool:	zbud pool from which to allocate
  * @size:	size in bytes of the desired allocation
- * @gfp:	gfp flags used if the pool needs to grow
  * @handle:	handle of the new allocation
  *
  * This function will attempt to find a free region in the pool large enough to
@@ -240,14 +246,11 @@ void zbud_destroy_pool(struct zbud_pool
  * performed first. If no suitable free region is found, then a new page is
  * allocated and added to the pool to satisfy the request.
  *
- * gfp should not set __GFP_HIGHMEM as highmem pages cannot be used
- * as zbud pool pages.
- *
- * Return: 0 if success and handle is set, otherwise -EINVAL if the size or
- * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
- * a new page.
+ * Return: 0 if success and @handle is set, -ENOSPC if the @size is too large,
+ * -EINVAL if the @size is 0, or -ENOMEM if the pool was unable to
+ * allocate a new page.
  */
-int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, unsigned int size,
 			unsigned long *handle)
 {
 	int chunks, i, freechunks;
@@ -255,7 +258,7 @@ int zbud_alloc(struct zbud_pool *pool, u
 	enum buddy bud;
 	struct page *page;
 
-	if (!size || (gfp & __GFP_HIGHMEM))
+	if (!size)
 		return -EINVAL;
 	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED - CHUNK_SIZE)
 		return -ENOSPC;
@@ -279,7 +282,7 @@ int zbud_alloc(struct zbud_pool *pool, u
 
 	/* Couldn't find unbuddied zbud page, create new one */
 	spin_unlock(&pool->lock);
-	page = alloc_page(gfp);
+	page = alloc_page(pool->gfp);
 	if (!page)
 		return -ENOMEM;
 	spin_lock(&pool->lock);
diff -puN mm/zswap.c~mm-zbud-zbud_alloc-minor-param-change mm/zswap.c
--- a/mm/zswap.c~mm-zbud-zbud_alloc-minor-param-change
+++ a/mm/zswap.c
@@ -679,8 +679,7 @@ static int zswap_frontswap_store(unsigne
 
 	/* store */
 	len = dlen + sizeof(struct zswap_header);
-	ret = zbud_alloc(zswap_pool, len, __GFP_NORETRY | __GFP_NOWARN,
-		&handle);
+	ret = zbud_alloc(zswap_pool, len, &handle);
 	if (ret == -ENOSPC) {
 		zswap_reject_compress_poor++;
 		goto freepage;
@@ -900,7 +899,8 @@ static int __init init_zswap(void)
 
 	pr_info("loading zswap\n");
 
-	zswap_pool = zbud_create_pool(GFP_KERNEL, &zswap_zbud_ops);
+	zswap_pool = zbud_create_pool(__GFP_NORETRY | __GFP_NOWARN,
+			&zswap_zbud_ops);
 	if (!zswap_pool) {
 		pr_err("zbud pool creation failed\n");
 		goto error;
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-update-zswap-to-use-zpool-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch

