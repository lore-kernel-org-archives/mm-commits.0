Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD5354723
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 03:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768620663; cv=none; b=OSxMNM3qH9OdjeFgYy86sdZzOVVFF49VGzPaTKmCiF3UA9cQiwCxEgELW7kilnJCoGfn8ylgjR/zShyCNTxBadBk0zhc/d84gz8xPkEQPufi2kjV15k0mJFPyvzPlXk8lnrpysrHjbrd9VYrGP8ecgENq3S+4K7xWb1guGCfsaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768620663; c=relaxed/simple;
	bh=FjHy+0CIkZaD96Ob2Uv5MxGRjkTs9Zq6KNHBhFwLw5g=;
	h=Date:To:From:Subject:Message-Id; b=sJ0v7y8rM8xG5ssg58+Rqt0j6s8q8E8RnGaHsIE45p3mwR5S+TL1haIxyfsJUkC3wvWzg0vnQ265UisuwmVZHGrXkAzkBM5iszRLNVIla9anwEnOBanT/yfC/5ePtOadJiWZPpBujxHW4M34ZVb+2jXy3rZKLVA2/37zCnjbyrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PXzLMdmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PXzLMdmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BF3C4CEF7;
	Sat, 17 Jan 2026 03:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768620663;
	bh=FjHy+0CIkZaD96Ob2Uv5MxGRjkTs9Zq6KNHBhFwLw5g=;
	h=Date:To:From:Subject:From;
	b=PXzLMdmuhVf2GBzG5Mw60UcfIhVQAX1uKOcKOiEPFpSrwKG//KgyeH7iGMIQ/IMSC
	 apFTuqct3GrIGV4hTT8vQaWQFbyAOsikjDA1v1w+BBZYCim9jhbME3LsADegxQrDrK
	 bfQt/7T/alBWVKo1uefbxsSok9sCA5om+ED8txKQ=
Date: Fri, 16 Jan 2026 19:31:02 -0800
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-make-common-caches-global.patch added to mm-new branch
Message-Id: <20260117033103.24BF3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: make common caches global
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-make-common-caches-global.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-make-common-caches-global.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: make common caches global
Date: Sat, 17 Jan 2026 11:54:05 +0900

Currently, zsmalloc creates kmem_cache of handles and zspages for each
pool, which may be suboptimal from the memory usage point of view (extra
internal fragmentation per pool).  Systems that create multiple zsmalloc
pools may benefit from shared common zsmalloc caches.

Make handles and zspages kmem caches global.  The memory savings depend on
particular setup and data patterns and can be found via slabinfo.

Link: https://lkml.kernel.org/r/20260117025406.799428-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  106 ++++++++++++++++++++++--------------------------
 1 file changed, 50 insertions(+), 56 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-make-common-caches-global
+++ a/mm/zsmalloc.c
@@ -193,12 +193,13 @@ struct link_free {
 	};
 };
 
+static struct kmem_cache *handle_cachep;
+static struct kmem_cache *zspage_cachep;
+
 struct zs_pool {
 	const char *name;
 
 	struct size_class *size_class[ZS_SIZE_CLASSES];
-	struct kmem_cache *handle_cachep;
-	struct kmem_cache *zspage_cachep;
 
 	atomic_long_t pages_allocated;
 
@@ -371,60 +372,28 @@ static void init_deferred_free(struct zs
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
-static int create_cache(struct zs_pool *pool)
+static unsigned long cache_alloc_handle(gfp_t gfp)
 {
-	char *name;
-
-	name = kasprintf(GFP_KERNEL, "zs_handle-%s", pool->name);
-	if (!name)
-		return -ENOMEM;
-	pool->handle_cachep = kmem_cache_create(name, ZS_HANDLE_SIZE,
-						0, 0, NULL);
-	kfree(name);
-	if (!pool->handle_cachep)
-		return -EINVAL;
-
-	name = kasprintf(GFP_KERNEL, "zspage-%s", pool->name);
-	if (!name)
-		return -ENOMEM;
-	pool->zspage_cachep = kmem_cache_create(name, sizeof(struct zspage),
-						0, 0, NULL);
-	kfree(name);
-	if (!pool->zspage_cachep) {
-		kmem_cache_destroy(pool->handle_cachep);
-		pool->handle_cachep = NULL;
-		return -EINVAL;
-	}
+	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-	return 0;
-}
-
-static void destroy_cache(struct zs_pool *pool)
-{
-	kmem_cache_destroy(pool->handle_cachep);
-	kmem_cache_destroy(pool->zspage_cachep);
+	return (unsigned long)kmem_cache_alloc(handle_cachep, gfp);
 }
 
-static unsigned long cache_alloc_handle(struct zs_pool *pool, gfp_t gfp)
+static void cache_free_handle(unsigned long handle)
 {
-	return (unsigned long)kmem_cache_alloc(pool->handle_cachep,
-			gfp & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
+	kmem_cache_free(handle_cachep, (void *)handle);
 }
 
-static void cache_free_handle(struct zs_pool *pool, unsigned long handle)
+static struct zspage *cache_alloc_zspage(gfp_t gfp)
 {
-	kmem_cache_free(pool->handle_cachep, (void *)handle);
-}
+	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-static struct zspage *cache_alloc_zspage(struct zs_pool *pool, gfp_t flags)
-{
-	return kmem_cache_zalloc(pool->zspage_cachep,
-			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
+	return kmem_cache_zalloc(zspage_cachep, gfp);
 }
 
-static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
+static void cache_free_zspage(struct zspage *zspage)
 {
-	kmem_cache_free(pool->zspage_cachep, zspage);
+	kmem_cache_free(zspage_cachep, zspage);
 }
 
 /* class->lock(which owns the handle) synchronizes races */
@@ -853,7 +822,7 @@ static void __free_zspage(struct zs_pool
 		zpdesc = next;
 	} while (zpdesc != NULL);
 
-	cache_free_zspage(pool, zspage);
+	cache_free_zspage(zspage);
 
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
@@ -966,7 +935,7 @@ static struct zspage *alloc_zspage(struc
 {
 	int i;
 	struct zpdesc *zpdescs[ZS_MAX_PAGES_PER_ZSPAGE];
-	struct zspage *zspage = cache_alloc_zspage(pool, gfp);
+	struct zspage *zspage = cache_alloc_zspage(gfp);
 
 	if (!zspage)
 		return NULL;
@@ -988,7 +957,7 @@ static struct zspage *alloc_zspage(struc
 				zpdesc_dec_zone_page_state(zpdescs[i]);
 				free_zpdesc(zpdescs[i]);
 			}
-			cache_free_zspage(pool, zspage);
+			cache_free_zspage(zspage);
 			return NULL;
 		}
 		__zpdesc_set_zsmalloc(zpdesc);
@@ -1339,7 +1308,7 @@ unsigned long zs_malloc(struct zs_pool *
 	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
 		return (unsigned long)ERR_PTR(-ENOSPC);
 
-	handle = cache_alloc_handle(pool, gfp);
+	handle = cache_alloc_handle(gfp);
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
@@ -1363,7 +1332,7 @@ unsigned long zs_malloc(struct zs_pool *
 
 	zspage = alloc_zspage(pool, class, gfp, nid);
 	if (!zspage) {
-		cache_free_handle(pool, handle);
+		cache_free_handle(handle);
 		return (unsigned long)ERR_PTR(-ENOMEM);
 	}
 
@@ -1443,7 +1412,7 @@ void zs_free(struct zs_pool *pool, unsig
 		free_zspage(pool, class, zspage);
 
 	spin_unlock(&class->lock);
-	cache_free_handle(pool, handle);
+	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
@@ -2105,9 +2074,6 @@ struct zs_pool *zs_create_pool(const cha
 	if (!pool->name)
 		goto err;
 
-	if (create_cache(pool))
-		goto err;
-
 	/*
 	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
@@ -2229,20 +2195,47 @@ void zs_destroy_pool(struct zs_pool *poo
 		kfree(class);
 	}
 
-	destroy_cache(pool);
 	kfree(pool->name);
 	kfree(pool);
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
+static void zs_destroy_caches(void)
+{
+	kmem_cache_destroy(handle_cachep);
+	handle_cachep = NULL;
+	kmem_cache_destroy(zspage_cachep);
+	zspage_cachep = NULL;
+}
+
+static int __init zs_init_caches(void)
+{
+	handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
+					  0, 0, NULL);
+	zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
+					  0, 0, NULL);
+
+	if (!handle_cachep || !zspage_cachep) {
+		zs_destroy_caches();
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 static int __init zs_init(void)
 {
-	int rc __maybe_unused;
+	int rc;
+
+	rc = zs_init_caches();
+	if (rc)
+		return rc;
 
 #ifdef CONFIG_COMPACTION
 	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
-	if (rc)
+	if (rc) {
+		zs_destroy_caches();
 		return rc;
+	}
 #endif
 	zs_stat_init();
 	return 0;
@@ -2254,6 +2247,7 @@ static void __exit zs_exit(void)
 	set_movable_ops(NULL, PGTY_zsmalloc);
 #endif
 	zs_stat_exit();
+	zs_destroy_caches();
 }
 
 module_init(zs_init);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch
zram-use-u32-for-entry-ac_time-tracking.patch
zram-rename-internal-slot-api.patch
zram-rename-internal-slot-api-fix.patch
zram-trivial-fix-of-recompress_slot-coding-styles.patch
zram-fixup-read_block_state.patch
zram-drop-pp_in_progress.patch
zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

