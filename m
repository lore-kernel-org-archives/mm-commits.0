Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EE6BA2D
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739439; cv=none; b=Bbj21uveAvjwyMy2CgD68VByNN9dZFq/cPMJGnukXmnJtKvDHvgdXPEAfigQFbpLAmJE8dsmzupX+1DIMhg/A8gGubZcSOLqkW+CBz368rpBLbdesnS6iqFNuJLwkW07NFobGmG+yM0uJA4+lJncz808P+TBJjyZ2h6PnswzBKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739439; c=relaxed/simple;
	bh=ItLv/z7Mb831UWbYy69/dngPk+fHm9LzXQBr6Y76y68=;
	h=Date:To:From:Subject:Message-Id; b=V0u89TfZ0KDN1lV00WNNeipm7JCy0B9xr85K+tADZHXVHZa+7HJIiBGNfq2eFii/0CXLlnuQJurQmGUCEcd2zOjKiLns1hMXhH+bH+bGO4zWrW1zCSTH+ySaLuFr096nD6YFu19oxxtNoxhukORl+uLs2uRifEEq6Bxucfn1q24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FlH5ZOGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FlH5ZOGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEC1C433C7;
	Sat, 24 Feb 2024 01:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739439;
	bh=ItLv/z7Mb831UWbYy69/dngPk+fHm9LzXQBr6Y76y68=;
	h=Date:To:From:Subject:From;
	b=FlH5ZOGwWk7OUFAFLdigtAxPJnzyTCBgsmlk6Dajvlc/+ZUXRuavLe4NTTKgHaspg
	 HTmZoAPv1C3SaLkSvT1lTBWAfT0788EfWjnTKGCRYZTYTnzZRiJJSW14dw+1AGbNjy
	 5pHmHCkQA0F/MvunidTL7QYL9VLDQIMH2HtAVcOU=
Date: Fri, 23 Feb 2024 17:50:39 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-remove-set_zspage_mapping.patch removed from -mm tree
Message-Id: <20240224015039.ABEC1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: remove set_zspage_mapping()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-remove-set_zspage_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zsmalloc: remove set_zspage_mapping()
Date: Tue, 20 Feb 2024 06:53:00 +0000

Patch series "mm/zsmalloc: some cleanup for get/set_zspage_mapping()".

The discussion[1] with Sergey shows there are some cleanup works to do
in get/set_zspage_mapping():

- the fullness returned from get_zspage_mapping() is not stable outside
  pool->lock, this usage pattern is confusing, but should be ok in this
  free_zspage path.

- we seldom use the class_idx returned from get_zspage_mapping(), only
  free_zspage path use to get its class.

- set_zspage_mapping() always set the zspage->class, but it's never
  changed after zspage allocated.

[1] https://lore.kernel.org/all/a6c22e30-cf10-4122-91bc-ceb9fb57a5d6@bytedance.com/


This patch (of 3):

We only need to update zspage->fullness when insert_zspage(), since
zspage->class is never changed after allocated.

Link: https://lkml.kernel.org/r/20240220-b4-zsmalloc-cleanup-v1-0-5c5ee4ccdd87@bytedance.com
Link: https://lkml.kernel.org/r/20240220-b4-zsmalloc-cleanup-v1-1-5c5ee4ccdd87@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove-set_zspage_mapping
+++ a/mm/zsmalloc.c
@@ -486,14 +486,6 @@ static struct size_class *zspage_class(s
 	return pool->size_class[zspage->class];
 }
 
-static void set_zspage_mapping(struct zspage *zspage,
-			       unsigned int class_idx,
-			       int fullness)
-{
-	zspage->class = class_idx;
-	zspage->fullness = fullness;
-}
-
 /*
  * zsmalloc divides the pool into various size classes where each
  * class maintains a list of zspages where each zspage is divided
@@ -688,6 +680,7 @@ static void insert_zspage(struct size_cl
 {
 	class_stat_inc(class, fullness, 1);
 	list_add(&zspage->list, &class->fullness_list[fullness]);
+	zspage->fullness = fullness;
 }
 
 /*
@@ -725,7 +718,6 @@ static int fix_fullness_group(struct siz
 
 	remove_zspage(class, zspage, currfg);
 	insert_zspage(class, zspage, newfg);
-	set_zspage_mapping(zspage, class_idx, newfg);
 out:
 	return newfg;
 }
@@ -1005,6 +997,7 @@ static struct zspage *alloc_zspage(struc
 	create_page_chain(class, zspage, pages);
 	init_zspage(class, zspage);
 	zspage->pool = pool;
+	zspage->class = class->index;
 
 	return zspage;
 }
@@ -1397,7 +1390,6 @@ unsigned long zs_malloc(struct zs_pool *
 	obj = obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
-	set_zspage_mapping(zspage, class->index, newfg);
 	record_obj(handle, obj);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
 	class_stat_inc(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
@@ -1655,7 +1647,6 @@ static int putback_zspage(struct size_cl
 
 	fullness = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, fullness);
-	set_zspage_mapping(zspage, class->index, fullness);
 
 	return fullness;
 }
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

