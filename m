Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6B64084E
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884620; cv=none; b=d6mdalR6NJ3c4IbnLh7PI5aoG0OrYqFBReCNr56oFMjigWTKlczJTxKb6Wy0w+Bm8OlL9JdBzFYIVZV6UF5M5SNCcARcw0/ibFbYckWPmEXaBIMW0gVY7vFfse+ZGd5lwR0isuPWOkxwsAeAFby3oNk8wCsXQCwpJL3utUH11MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884620; c=relaxed/simple;
	bh=reWsYsoVHSGbsLK08aNpX0fXAnQnr3KHE7ohn3A8LNI=;
	h=Date:To:From:Subject:Message-Id; b=tz0edE+Sp3GPOWxSVcPPOvAtc4r+zs6qRlsh7RnKXCTFJvwrog1snhnUif1tMaZExfYNz5YecAJAG9PAgXtkAYdbm8S00fNObpSPMAYF2fxr+rN5ST/GcqUYc/5T4edr4wZEEQoLJd+q9dPzhHBQGR/uhSzHYrPrhVuG2yo6pa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TZHq4VVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TZHq4VVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076B6C433F1;
	Tue, 19 Mar 2024 21:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710884620;
	bh=reWsYsoVHSGbsLK08aNpX0fXAnQnr3KHE7ohn3A8LNI=;
	h=Date:To:From:Subject:From;
	b=TZHq4VVGVy9Vicfi+5Z4GKVV9CmCl1UtuV3Zo94wnkQv6ZPdNxsf08QezDjvQ5UC6
	 uM3M4vR9m+1Eg/h+6kcmz6PMbAboPf7gPULSpDmXyNRto5AboGINyAIDlbblBYBz7v
	 GdakTAh27OGVMZ2d6nN1/rLFlDLNatIDlClgiZxc=
Date: Tue, 19 Mar 2024 14:43:39 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,chengming.zhou@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zpool-return-pool-size-in-pages.patch added to mm-unstable branch
Message-Id: <20240319214340.076B6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zpool: return pool size in pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zpool-return-pool-size-in-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zpool-return-pool-size-in-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zpool: return pool size in pages
Date: Tue, 12 Mar 2024 11:34:12 -0400

All zswap backends track their pool sizes in pages.  Currently they
multiply by PAGE_SIZE for zswap, only for zswap to divide again in order
to do limit math.  Report pages directly.

Link: https://lkml.kernel.org/r/20240312153901.3441-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    4 ++--
 mm/z3fold.c           |   10 +++++-----
 mm/zbud.c             |   10 +++++-----
 mm/zpool.c            |   10 +++++-----
 mm/zsmalloc.c         |    6 +++---
 mm/zswap.c            |    6 +++---
 6 files changed, 23 insertions(+), 23 deletions(-)

--- a/include/linux/zpool.h~mm-zpool-return-pool-size-in-pages
+++ a/include/linux/zpool.h
@@ -53,7 +53,7 @@ void *zpool_map_handle(struct zpool *poo
 
 void zpool_unmap_handle(struct zpool *pool, unsigned long handle);
 
-u64 zpool_get_total_size(struct zpool *pool);
+u64 zpool_get_total_pages(struct zpool *pool);
 
 
 /**
@@ -91,7 +91,7 @@ struct zpool_driver {
 				enum zpool_mapmode mm);
 	void (*unmap)(void *pool, unsigned long handle);
 
-	u64 (*total_size)(void *pool);
+	u64 (*total_pages)(void *pool);
 };
 
 void zpool_register_driver(struct zpool_driver *driver);
--- a/mm/z3fold.c~mm-zpool-return-pool-size-in-pages
+++ a/mm/z3fold.c
@@ -1237,12 +1237,12 @@ static void z3fold_unmap(struct z3fold_p
 }
 
 /**
- * z3fold_get_pool_size() - gets the z3fold pool size in pages
+ * z3fold_get_pool_pages() - gets the z3fold pool size in pages
  * @pool:	pool whose size is being queried
  *
  * Returns: size in pages of the given pool.
  */
-static u64 z3fold_get_pool_size(struct z3fold_pool *pool)
+static u64 z3fold_get_pool_pages(struct z3fold_pool *pool)
 {
 	return atomic64_read(&pool->pages_nr);
 }
@@ -1402,9 +1402,9 @@ static void z3fold_zpool_unmap(void *poo
 	z3fold_unmap(pool, handle);
 }
 
-static u64 z3fold_zpool_total_size(void *pool)
+static u64 z3fold_zpool_total_pages(void *pool)
 {
-	return z3fold_get_pool_size(pool) * PAGE_SIZE;
+	return z3fold_get_pool_pages(pool);
 }
 
 static struct zpool_driver z3fold_zpool_driver = {
@@ -1417,7 +1417,7 @@ static struct zpool_driver z3fold_zpool_
 	.free =		z3fold_zpool_free,
 	.map =		z3fold_zpool_map,
 	.unmap =	z3fold_zpool_unmap,
-	.total_size =	z3fold_zpool_total_size,
+	.total_pages =	z3fold_zpool_total_pages,
 };
 
 MODULE_ALIAS("zpool-z3fold");
--- a/mm/zbud.c~mm-zpool-return-pool-size-in-pages
+++ a/mm/zbud.c
@@ -365,13 +365,13 @@ static void zbud_unmap(struct zbud_pool
 }
 
 /**
- * zbud_get_pool_size() - gets the zbud pool size in pages
+ * zbud_get_pool_pages() - gets the zbud pool size in pages
  * @pool:	pool whose size is being queried
  *
  * Returns: size in pages of the given pool.  The pool lock need not be
  * taken to access pages_nr.
  */
-static u64 zbud_get_pool_size(struct zbud_pool *pool)
+static u64 zbud_get_pool_pages(struct zbud_pool *pool)
 {
 	return pool->pages_nr;
 }
@@ -410,9 +410,9 @@ static void zbud_zpool_unmap(void *pool,
 	zbud_unmap(pool, handle);
 }
 
-static u64 zbud_zpool_total_size(void *pool)
+static u64 zbud_zpool_total_pages(void *pool)
 {
-	return zbud_get_pool_size(pool) * PAGE_SIZE;
+	return zbud_get_pool_pages(pool);
 }
 
 static struct zpool_driver zbud_zpool_driver = {
@@ -425,7 +425,7 @@ static struct zpool_driver zbud_zpool_dr
 	.free =		zbud_zpool_free,
 	.map =		zbud_zpool_map,
 	.unmap =	zbud_zpool_unmap,
-	.total_size =	zbud_zpool_total_size,
+	.total_pages =	zbud_zpool_total_pages,
 };
 
 MODULE_ALIAS("zpool-zbud");
--- a/mm/zpool.c~mm-zpool-return-pool-size-in-pages
+++ a/mm/zpool.c
@@ -321,16 +321,16 @@ void zpool_unmap_handle(struct zpool *zp
 }
 
 /**
- * zpool_get_total_size() - The total size of the pool
+ * zpool_get_total_pages() - The total size of the pool
  * @zpool:	The zpool to check
  *
- * This returns the total size in bytes of the pool.
+ * This returns the total size in pages of the pool.
  *
- * Returns: Total size of the zpool in bytes.
+ * Returns: Total size of the zpool in pages.
  */
-u64 zpool_get_total_size(struct zpool *zpool)
+u64 zpool_get_total_pages(struct zpool *zpool)
 {
-	return zpool->driver->total_size(zpool->pool);
+	return zpool->driver->total_pages(zpool->pool);
 }
 
 /**
--- a/mm/zsmalloc.c~mm-zpool-return-pool-size-in-pages
+++ a/mm/zsmalloc.c
@@ -399,9 +399,9 @@ static void zs_zpool_unmap(void *pool, u
 	zs_unmap_object(pool, handle);
 }
 
-static u64 zs_zpool_total_size(void *pool)
+static u64 zs_zpool_total_pages(void *pool)
 {
-	return zs_get_total_pages(pool) << PAGE_SHIFT;
+	return zs_get_total_pages(pool);
 }
 
 static struct zpool_driver zs_zpool_driver = {
@@ -414,7 +414,7 @@ static struct zpool_driver zs_zpool_driv
 	.free =			  zs_zpool_free,
 	.map =			  zs_zpool_map,
 	.unmap =		  zs_zpool_unmap,
-	.total_size =		  zs_zpool_total_size,
+	.total_pages =		  zs_zpool_total_pages,
 };
 
 MODULE_ALIAS("zpool-zsmalloc");
--- a/mm/zswap.c~mm-zpool-return-pool-size-in-pages
+++ a/mm/zswap.c
@@ -513,18 +513,18 @@ static unsigned long zswap_accept_thr_pa
 unsigned long zswap_total_pages(void)
 {
 	struct zswap_pool *pool;
-	u64 total = 0;
+	unsigned long total = 0;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pool, &zswap_pools, list) {
 		int i;
 
 		for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
-			total += zpool_get_total_size(pool->zpools[i]);
+			total += zpool_get_total_pages(pool->zpools[i]);
 	}
 	rcu_read_unlock();
 
-	return total >> PAGE_SHIFT;
+	return total;
 }
 
 /*********************************
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-cachestat-fix-two-shmem-bugs.patch
mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch

