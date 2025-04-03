Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FCB195FEF
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 04:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743653393; cv=none; b=njMrJ3aA87tlmHmuL2Af4AqPiJc+L/IU0P9yeyLhO+oaUa4LAZk0GvLDtHgnBVONcx13tBliIL08grnFMehQkOqmjx5+3sTWT53ZDcvORI/ZaomysLX0toNZTWZII8gNMVfhtU0tL4onhc5RTimNYLNDdQ0SIGNVwmvAz4TbTaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743653393; c=relaxed/simple;
	bh=iFH7TXSWI+4Z4L3rZcRBPRl4EJX+aOX+OGZKCxMLC40=;
	h=Date:To:From:Subject:Message-Id; b=ZhWx4M3TES6QDPpJrgMX93F5rxmWGdrX3yRUzjFsq+CRu3JndV7Ra1qudPXL1VPon/5ZFGfhwUgtBAAOI/KJNqjFk6XUZqh/acXzbUdGJc09YS7tEgZvrvpRP+hV7+3xWoKpE5rBENqJDzmRB8W48UwS3J7UmgZ1+fRuqETRhDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Auhb0Uax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Auhb0Uax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E4CC4CEE3;
	Thu,  3 Apr 2025 04:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743653393;
	bh=iFH7TXSWI+4Z4L3rZcRBPRl4EJX+aOX+OGZKCxMLC40=;
	h=Date:To:From:Subject:From;
	b=Auhb0UaxdbjJD9BP4JJStGto70ehvnXuymV6GflCRzb/8NcV6K08vlNnbQKBQXAFc
	 EYqzNDOIlrlnyhJ27+SQwRYJALLi+UMvt1nVhZE2pS3oq6lCz/JrwZlSI6w4bmtlpO
	 9c47XajYbWSmDlDEMnXU9dt9jVd49M7nVexb9+No=
Date: Wed, 02 Apr 2025 21:09:52 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,sj@kernel.org,nphamcs@gmail.com,minchan@kernel.org,Jonathan.Cameron@huawei.com,hannes@cmpxchg.org,gourry@gourry.net,dan.j.williams@intel.com,chengming.zhou@linux.dev,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch added to mm-new branch
Message-Id: <20250403040953.24E4CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch

This patch will later appear in the mm-new branch at
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

zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch

