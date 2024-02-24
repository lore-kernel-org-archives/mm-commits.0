Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D3DF6C
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739435; cv=none; b=R/9OJ2kdwBSYqW6LGBFNWJs+4Fj72GaI4MdRfKcT0SnkaRyzJzN3agSnn4R2FOwIxID4004j1mcmRja62fhsxOC7PQFsJOG4EaeEDNqP6XhVe+ioLH4+v0tR+aGEoyFkvR5MIpq++EMudI4KRad8gU/ncDC9/y01mCd0dWNtYMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739435; c=relaxed/simple;
	bh=gxSJWX42kUJr4k5ui1P38ztcwC2uJi2qkTtIwVnODRM=;
	h=Date:To:From:Subject:Message-Id; b=K7Bim4RXOTzfT+Woatf1zA7oCjo/zFvx7BThpkEKFpa00PUb6t8P67DQ18aAOQnxNe/2si2fgpyrRNQmn4usymvacUKQtWauB/geTQLNd42qKafdjJIsWZUfIs6O5pulooUkRdQPCpT7wQ7L06/UdPRw3e/YmZxKJ7FATnmR70Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qDc1ceIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qDc1ceIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD864C43390;
	Sat, 24 Feb 2024 01:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739434;
	bh=gxSJWX42kUJr4k5ui1P38ztcwC2uJi2qkTtIwVnODRM=;
	h=Date:To:From:Subject:From;
	b=qDc1ceILNw8XluSmXvRpuGS+7qLmt3yxnT9CToFX9Vy4984GnQJD89QqW0nFJLuDk
	 0pKms0ntVpMhQzm+dt8MebSx75L40VprjKLYhKAU0Xsei5jkfgH/1TgE5SpAfT8xSJ
	 uw3V4Ft5g5UQsdTNSMSxtUJVHP+Qva5uUmq6volo=
Date: Fri, 23 Feb 2024 17:50:34 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-remove-unused-zspage-isolated.patch removed from -mm tree
Message-Id: <20240224015034.AD864C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: remove unused zspage->isolated
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-remove-unused-zspage-isolated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zsmalloc: remove unused zspage->isolated
Date: Mon, 19 Feb 2024 13:33:53 +0000

The zspage->isolated is not used anywhere, we don't need to maintain it,
which needs to hold the heavy pool lock to update it, so just remove it.

Link: https://lkml.kernel.org/r/20240219-b4-szmalloc-migrate-v1-3-34cd49c6545b@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove-unused-zspage-isolated
+++ a/mm/zsmalloc.c
@@ -116,7 +116,6 @@
 #define HUGE_BITS	1
 #define FULLNESS_BITS	4
 #define CLASS_BITS	8
-#define ISOLATED_BITS	5
 #define MAGIC_VAL_BITS	8
 
 #define MAX(a, b) ((a) >= (b) ? (a) : (b))
@@ -246,7 +245,6 @@ struct zspage {
 		unsigned int huge:HUGE_BITS;
 		unsigned int fullness:FULLNESS_BITS;
 		unsigned int class:CLASS_BITS + 1;
-		unsigned int isolated:ISOLATED_BITS;
 		unsigned int magic:MAGIC_VAL_BITS;
 	};
 	unsigned int inuse;
@@ -1732,17 +1730,6 @@ static void migrate_write_unlock(struct
 }
 
 #ifdef CONFIG_COMPACTION
-/* Number of isolated subpage for *page migration* in this zspage */
-static void inc_zspage_isolation(struct zspage *zspage)
-{
-	zspage->isolated++;
-}
-
-static void dec_zspage_isolation(struct zspage *zspage)
-{
-	VM_BUG_ON(zspage->isolated == 0);
-	zspage->isolated--;
-}
 
 static const struct movable_operations zsmalloc_mops;
 
@@ -1771,21 +1758,12 @@ static void replace_sub_page(struct size
 
 static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 {
-	struct zs_pool *pool;
-	struct zspage *zspage;
-
 	/*
 	 * Page is locked so zspage couldn't be destroyed. For detail, look at
 	 * lock_zspage in free_zspage.
 	 */
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
-	zspage = get_zspage(page);
-	pool = zspage->pool;
-	spin_lock(&pool->lock);
-	inc_zspage_isolation(zspage);
-	spin_unlock(&pool->lock);
-
 	return true;
 }
 
@@ -1850,7 +1828,6 @@ static int zs_page_migrate(struct page *
 	kunmap_atomic(s_addr);
 
 	replace_sub_page(class, zspage, newpage, page);
-	dec_zspage_isolation(zspage);
 	/*
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release the pool's lock.
@@ -1872,16 +1849,7 @@ static int zs_page_migrate(struct page *
 
 static void zs_page_putback(struct page *page)
 {
-	struct zs_pool *pool;
-	struct zspage *zspage;
-
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
-
-	zspage = get_zspage(page);
-	pool = zspage->pool;
-	spin_lock(&pool->lock);
-	dec_zspage_isolation(zspage);
-	spin_unlock(&pool->lock);
 }
 
 static const struct movable_operations zsmalloc_mops = {
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

