Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C90CB663
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739433; cv=none; b=OQtG3dYgLmj+4pMA550wwzO82FUHfJ6+MKlnttPPYlQStkZbO0eUWab38BrfGoNQDCF8EADW6b5U5OyPod6TBtmEkt6Mwy48i/tzzjW8aqcT1pCF0NWX7HHaZ6G5KT4Dv8DEPnFojIqFO0V3GFRzazZvgdPfNRzaiFrFe0YK4yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739433; c=relaxed/simple;
	bh=QQaUwt3lSAcG/RE7BdrW9CfV5+0VHfg9mj8DGsFeHuM=;
	h=Date:To:From:Subject:Message-Id; b=fsG4Fe1S8NThRVf7Vn3P7QCp/2rYWrW6IrRwGk0+gI9SDIJrOcwHmw9FrjEg9D+NvY7o4W6U/l3eVDTLdKp/+/FMRUIZ/TSLsbQbyIeNbwalfLExYZiw19TTFlihPPjhwyXhQEXfTesp4mUJ+QtE09JRvvapZn55egcFqIcUhbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WeGdssei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WeGdssei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B08C433C7;
	Sat, 24 Feb 2024 01:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739432;
	bh=QQaUwt3lSAcG/RE7BdrW9CfV5+0VHfg9mj8DGsFeHuM=;
	h=Date:To:From:Subject:From;
	b=WeGdssei4VC0BkUL9XTL+2r8wS4BN60I7fRFgHRwpLxSYIWSQkjSjSPpyluEkJIBN
	 x9PEF5supnyaXrPIXTSpgetlJhz0CbeizIK0JEYiuqesK1E4NWBynQB5zXUOcgHUyn
	 jSG50hJcTyNr/vfmdJVEYbJyhAv29/9JDPv3EGIc=
Date: Fri, 23 Feb 2024 17:50:32 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-remove-migrate_write_lock_nested.patch removed from -mm tree
Message-Id: <20240224015032.D3B08C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: remove migrate_write_lock_nested()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-remove-migrate_write_lock_nested.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zsmalloc: remove migrate_write_lock_nested()
Date: Mon, 19 Feb 2024 13:33:52 +0000

The migrate write lock is to protect the race between zspage migration and
zspage objects' map users.

We only need to lock out the map users of src zspage, not dst zspage,
which is safe to map by users concurrently, since we only need to do
obj_malloc() from dst zspage.

So we can remove the migrate_write_lock_nested() use case.

As we are here, cleanup the __zs_compact() by moving putback_zspage()
outside of migrate_write_unlock since we hold pool lock, no malloc or free
users can come in.

Link: https://lkml.kernel.org/r/20240219-b4-szmalloc-migrate-v1-2-34cd49c6545b@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove-migrate_write_lock_nested
+++ a/mm/zsmalloc.c
@@ -279,7 +279,6 @@ static void migrate_lock_init(struct zsp
 static void migrate_read_lock(struct zspage *zspage);
 static void migrate_read_unlock(struct zspage *zspage);
 static void migrate_write_lock(struct zspage *zspage);
-static void migrate_write_lock_nested(struct zspage *zspage);
 static void migrate_write_unlock(struct zspage *zspage);
 
 #ifdef CONFIG_COMPACTION
@@ -1727,11 +1726,6 @@ static void migrate_write_lock(struct zs
 	write_lock(&zspage->lock);
 }
 
-static void migrate_write_lock_nested(struct zspage *zspage)
-{
-	write_lock_nested(&zspage->lock, SINGLE_DEPTH_NESTING);
-}
-
 static void migrate_write_unlock(struct zspage *zspage)
 {
 	write_unlock(&zspage->lock);
@@ -2003,19 +1997,17 @@ static unsigned long __zs_compact(struct
 			dst_zspage = isolate_dst_zspage(class);
 			if (!dst_zspage)
 				break;
-			migrate_write_lock(dst_zspage);
 		}
 
 		src_zspage = isolate_src_zspage(class);
 		if (!src_zspage)
 			break;
 
-		migrate_write_lock_nested(src_zspage);
-
+		migrate_write_lock(src_zspage);
 		migrate_zspage(pool, src_zspage, dst_zspage);
-		fg = putback_zspage(class, src_zspage);
 		migrate_write_unlock(src_zspage);
 
+		fg = putback_zspage(class, src_zspage);
 		if (fg == ZS_INUSE_RATIO_0) {
 			free_zspage(pool, class, src_zspage);
 			pages_freed += class->pages_per_zspage;
@@ -2025,7 +2017,6 @@ static unsigned long __zs_compact(struct
 		if (get_fullness_group(class, dst_zspage) == ZS_INUSE_RATIO_100
 		    || spin_is_contended(&pool->lock)) {
 			putback_zspage(class, dst_zspage);
-			migrate_write_unlock(dst_zspage);
 			dst_zspage = NULL;
 
 			spin_unlock(&pool->lock);
@@ -2034,15 +2025,12 @@ static unsigned long __zs_compact(struct
 		}
 	}
 
-	if (src_zspage) {
+	if (src_zspage)
 		putback_zspage(class, src_zspage);
-		migrate_write_unlock(src_zspage);
-	}
 
-	if (dst_zspage) {
+	if (dst_zspage)
 		putback_zspage(class, dst_zspage);
-		migrate_write_unlock(dst_zspage);
-	}
+
 	spin_unlock(&pool->lock);
 
 	return pages_freed;
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

