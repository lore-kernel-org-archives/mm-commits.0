Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C34E17555
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934319; cv=none; b=s3C+aMU0uSOl8ZfxQDi8oZ5Zn8yPxeV9DiNWVs9byQ8sNrukJIf1Zxh20iftqwWJEk5ia+dFXAp5CZ2Os9PvZ1GirmbCxr9InCeBjcasK6aBRrYG4VHCJJtNSx8aOcsaB1MxRY5j9HiXYUH81TtgshJagoDatVZG1fQKN7CWvXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934319; c=relaxed/simple;
	bh=PzMWglAa4xtGM0cPX9IuBbni3CIAGTVxISkl2d0hWpk=;
	h=Date:To:From:Subject:Message-Id; b=amjZ/ObSijv6/wYNJmDCnQEJt9dlJxjDOmXc2+Usjm98UvXMesrUbAYWY/G8h20PCwly6LcDgATVjGKZFNadLM0377sjv+YROer+H2W4fBDOfSne9u78US+JSpVpW8liTD/FACuXABf45+aSKcNP+kzxz5ftIzjDHfB9x7kkEeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gwUnHgMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gwUnHgMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AC6C4CEE4;
	Sun, 11 May 2025 03:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934318;
	bh=PzMWglAa4xtGM0cPX9IuBbni3CIAGTVxISkl2d0hWpk=;
	h=Date:To:From:Subject:From;
	b=gwUnHgMf5/B52qDX33ZSlT2AuyniuqgIcrEqWlgc2GBDSLLlf3hHo5zT29ZfRsi5j
	 7ofZc3UB3O2GcmdEtzDlblEfPYwTF5AGZoDXImzH+X5kKoMQQtnlq+jmF8asNnCimV
	 TvMwe3AUzCvJmGTpICNmhBJ00yGNQG5y0aKbcVyo=
Date: Sat, 10 May 2025 20:31:58 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,sj@kernel.org,nphamcs@gmail.com,minchan@kernel.org,Jonathan.Cameron@huawei.com,hannes@cmpxchg.org,gourry@gourry.net,dan.j.williams@intel.com,chengming.zhou@linux.dev,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch removed from -mm tree
Message-Id: <20250511033158.C0AC6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix
has been removed from the -mm tree.  Its filename was
     zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch

This patch was dropped because it was folded into zsmalloc-prefer-the-the-original-pages-node-for-compressed-data.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix
Date: Thu, 3 Apr 2025 12:55:46 +0900

coding-style fixes

Link: https://lkml.kernel.org/r/mnvexa7kseswglcqbhlot4zg3b3la2ypv2rimdl5mh5glbmhvz@wi6bgqn47hge
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    4 ++--
 mm/zpool.c            |    2 +-
 mm/zsmalloc.c         |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/zpool.h~zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix
+++ a/include/linux/zpool.h
@@ -22,7 +22,7 @@ const char *zpool_get_type(struct zpool
 void zpool_destroy_pool(struct zpool *pool);
 
 int zpool_malloc(struct zpool *pool, size_t size, gfp_t gfp,
-			unsigned long *handle, const int nid);
+		 unsigned long *handle, const int nid);
 
 void zpool_free(struct zpool *pool, unsigned long handle);
 
@@ -64,7 +64,7 @@ struct zpool_driver {
 	void (*destroy)(void *pool);
 
 	int (*malloc)(void *pool, size_t size, gfp_t gfp,
-				unsigned long *handle, const int nid);
+		      unsigned long *handle, const int nid);
 	void (*free)(void *pool, unsigned long handle);
 
 	void *(*obj_read_begin)(void *pool, unsigned long handle,
--- a/mm/zpool.c~zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix
+++ a/mm/zpool.c
@@ -239,7 +239,7 @@ const char *zpool_get_type(struct zpool
  * Returns: 0 on success, negative value on error.
  */
 int zpool_malloc(struct zpool *zpool, size_t size, gfp_t gfp,
-			unsigned long *handle, const int nid)
+		 unsigned long *handle, const int nid)
 {
 	return zpool->driver->malloc(zpool->pool, size, gfp, handle, nid);
 }
--- a/mm/zsmalloc.c~zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix
+++ a/mm/zsmalloc.c
@@ -462,7 +462,7 @@ static void zs_zpool_destroy(void *pool)
 }
 
 static int zs_zpool_malloc(void *pool, size_t size, gfp_t gfp,
-			unsigned long *handle, const int nid)
+			   unsigned long *handle, const int nid)
 {
 	*handle = zs_malloc(pool, size, gfp, nid);
 
@@ -1043,8 +1043,8 @@ static void create_page_chain(struct siz
  * Allocate a zspage for the given size class
  */
 static struct zspage *alloc_zspage(struct zs_pool *pool,
-					struct size_class *class,
-					gfp_t gfp, const int nid)
+				   struct size_class *class,
+				   gfp_t gfp, const int nid)
 {
 	int i;
 	struct zpdesc *zpdescs[ZS_MAX_PAGES_PER_ZSPAGE];
@@ -1343,7 +1343,7 @@ static unsigned long obj_malloc(struct z
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
  */
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
-				const int nid)
+			const int nid)
 {
 	unsigned long handle;
 	struct size_class *class;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch
zsmalloc-prefer-the-the-original-pages-node-for-compressed-data.patch
zram-modernize-writeback-interface.patch
zram-modernize-writeback-interface-v3.patch
zram-modernize-writeback-interface-v4.patch
zsmalloc-cleanup-headers-includes.patch
documentation-zram-update-idle-pages-tracking-documentation.patch

