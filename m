From: akpm@linux-foundation.org
Subject: + zsmalloc-require-gfp-in-zs_malloc-v2.patch added to -mm tree
Date: Fri, 29 Apr 2016 13:52:41 -0700
Message-ID: <5723c999.cEgWrSD6396LS/DM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbcD2Uwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 16:52:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-require-gfp-in-zs_malloc-v2
has been added to the -mm tree.  Its filename is
     zsmalloc-require-gfp-in-zs_malloc-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-require-gfp-in-zs_malloc-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-require-gfp-in-zs_malloc-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc-require-gfp-in-zs_malloc-v2

Pass GFP flags to zs_malloc() instead of using a fixed mask supplied to
zs_create_pool(), so we can be more flexible, but, more importantly, we
need this to switch zram to per-cpu compression streams -- zram will try
to allocate handle with preemption disabled in a fast path and switch to
a slow path (using different gfp mask) if the fast one has failed.

Apart from that, this also align zs_malloc() interface with zspool/zbud.

Link: http://lkml.kernel.org/r/20160429150942.GA637@swordfish
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 include/linux/zsmalloc.h      |    2 +-
 mm/zsmalloc.c                 |    9 +++++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zsmalloc-require-gfp-in-zs_malloc-v2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zsmalloc-require-gfp-in-zs_malloc-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -514,7 +514,7 @@ static struct zram_meta *zram_meta_alloc
 		goto out_error;
 	}
 
-	meta->mem_pool = zs_create_pool(pool_name, GFP_NOIO | __GFP_HIGHMEM);
+	meta->mem_pool = zs_create_pool(pool_name);
 	if (!meta->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		goto out_error;
diff -puN include/linux/zsmalloc.h~zsmalloc-require-gfp-in-zs_malloc-v2 include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~zsmalloc-require-gfp-in-zs_malloc-v2
+++ a/include/linux/zsmalloc.h
@@ -41,7 +41,7 @@ struct zs_pool_stats {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(const char *name, gfp_t flags);
+struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags);
diff -puN mm/zsmalloc.c~zsmalloc-require-gfp-in-zs_malloc-v2 mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-require-gfp-in-zs_malloc-v2
+++ a/mm/zsmalloc.c
@@ -323,7 +323,12 @@ static void *zs_zpool_create(const char
 			     const struct zpool_ops *zpool_ops,
 			     struct zpool *zpool)
 {
-	return zs_create_pool(name, gfp);
+	/*
+	 * Ignore global gfp flags: zs_malloc() may be invoked from
+	 * different contexts and its caller must provide a valid
+	 * gfp mask.
+	 */
+	return zs_create_pool(name);
 }
 
 static void zs_zpool_destroy(void *pool)
@@ -1874,7 +1879,7 @@ static int zs_register_shrinker(struct z
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
+struct zs_pool *zs_create_pool(const char *name)
 {
 	int i;
 	struct zs_pool *pool;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-require-gfp-in-zs_malloc.patch
zsmalloc-require-gfp-in-zs_malloc-v2.patch
zram-user-per-cpu-compression-streams.patch

