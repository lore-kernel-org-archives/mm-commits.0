Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D8F768E4
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 17:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708451931; cv=none; b=Xw09tIWTKVoR1TiFVjcI9Eu4IGRfy6vtmWF4m9HHu5FuPWhh4EQu4O8RSqIhrDnrhjtT07iq4Rbuk3gyqrYojAofqTxIc1q2oOWVMwRJ8HsR/FWKepAeczFyfeB7pGHZ2KAKC28BEOpVap01u9A2bGPZYAglQ/yw9A82jd7wJds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708451931; c=relaxed/simple;
	bh=BFm7Fq4EmHyBGFv6xuvLL8/F/ngaokuLuF2et+k9jqw=;
	h=Date:To:From:Subject:Message-Id; b=WRFOtb3wzdze0z2tNvQUpLzBQaL9Y9vdnuLQpWFZi9VPDA1PXjH7PQP9++0VvgDLy1jCbTi6LiQteO7tPG263cKln7rYc/y+aXyk3QxQPmDYFxTtUeXchWV8GJTw3vezqkTAsROH3d0mYIjERkm+gJM50Y5fUqTIZOcEITQxbro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ylq1nGrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ylq1nGrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B51C433F1;
	Tue, 20 Feb 2024 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708451931;
	bh=BFm7Fq4EmHyBGFv6xuvLL8/F/ngaokuLuF2et+k9jqw=;
	h=Date:To:From:Subject:From;
	b=Ylq1nGrVH3yVWinjQWAQDwvrAAY94vunKQxevnNOEcXsre6y+GNQLNKj70amh7Jqp
	 Q5SA2uCL/MiOGLlw83LH9QjXs7MEhh4SO6dMykcsozsJLwSOo5FS9EI/7Sys+DBeDr
	 WGSjgLNcK1+xg1QVlaSA3TmcvkkFMskXJSexAS0M=
Date: Tue, 20 Feb 2024 09:58:50 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-remove-set_zspage_mapping.patch added to mm-unstable branch
Message-Id: <20240220175851.23B51C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: remove set_zspage_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-remove-set_zspage_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove-set_zspage_mapping.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch
mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch
mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch
mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch

