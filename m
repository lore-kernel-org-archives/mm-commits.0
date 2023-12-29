Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A28D13AE4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zd/w0PZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B25C433C9;
	Fri, 29 Dec 2023 20:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880080;
	bh=4b+RVoTnNT4iG7ehvUKS1nbS4HORl2L103A14e0udSs=;
	h=Date:To:From:Subject:From;
	b=Zd/w0PZbgZDubY5zVr8rmXZjIO4/YOswOuoue2VlqB76ab9K5foJtB0Tjhh2n01Qu
	 hvElRFueI8sSws8AI1KZpXwLTr/tNSv1AZ+7fASQEUJ4joxReES8ybB7uWdFXDmJKF
	 /zyufa1/iNJGa4FgGKmEmQth/j1SyRC0jmJDPDXU=
Date: Fri, 29 Dec 2023 12:01:19 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,juntong.deng@outlook.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-clean-up-kasan_cache_create.patch removed from -mm tree
Message-Id: <20231229200120.08B25C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: clean up kasan_cache_create
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-kasan_cache_create.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean up kasan_cache_create
Date: Thu, 21 Dec 2023 19:35:37 +0100

Reorganize the code to avoid nested if/else checks to improve the
readability.

Also drop the confusing comments about KMALLOC_MAX_SIZE checks: they are
relevant for both SLUB and SLAB (originally, the comments likely confused
KMALLOC_MAX_SIZE with KMALLOC_MAX_CACHE_SIZE).

Link: https://lkml.kernel.org/r/20231221183540.168428-1-andrey.konovalov@linux.dev
Fixes: a5989d4ed40c ("kasan: improve free meta storage in Generic KASAN")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Juntong Deng <juntong.deng@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |   67 +++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

--- a/mm/kasan/generic.c~kasan-clean-up-kasan_cache_create
+++ a/mm/kasan/generic.c
@@ -382,16 +382,11 @@ void kasan_cache_create(struct kmem_cach
 
 	ok_size = *size;
 
-	/* Add alloc meta into redzone. */
+	/* Add alloc meta into the redzone. */
 	cache->kasan_info.alloc_meta_offset = *size;
 	*size += sizeof(struct kasan_alloc_meta);
 
-	/*
-	 * If alloc meta doesn't fit, don't add it.
-	 * This can only happen with SLAB, as it has KMALLOC_MAX_SIZE equal
-	 * to KMALLOC_MAX_CACHE_SIZE and doesn't fall back to page_alloc for
-	 * larger sizes.
-	 */
+	/* If alloc meta doesn't fit, don't add it. */
 	if (*size > KMALLOC_MAX_SIZE) {
 		cache->kasan_info.alloc_meta_offset = 0;
 		*size = ok_size;
@@ -402,36 +397,52 @@ void kasan_cache_create(struct kmem_cach
 	orig_alloc_meta_offset = cache->kasan_info.alloc_meta_offset;
 
 	/*
-	 * Add free meta into redzone when it's not possible to store
+	 * Store free meta in the redzone when it's not possible to store
 	 * it in the object. This is the case when:
 	 * 1. Object is SLAB_TYPESAFE_BY_RCU, which means that it can
 	 *    be touched after it was freed, or
 	 * 2. Object has a constructor, which means it's expected to
-	 *    retain its content until the next allocation, or
-	 * 3. Object is too small and SLUB DEBUG is enabled. Avoid
-	 *    free meta that exceeds the object size corrupts the
-	 *    SLUB DEBUG metadata.
-	 * Otherwise cache->kasan_info.free_meta_offset = 0 is implied.
-	 * If the object is smaller than the free meta and SLUB DEBUG
-	 * is not enabled, it is still possible to store part of the
-	 * free meta in the object.
+	 *    retain its content until the next allocation.
 	 */
 	if ((cache->flags & SLAB_TYPESAFE_BY_RCU) || cache->ctor) {
 		cache->kasan_info.free_meta_offset = *size;
 		*size += sizeof(struct kasan_free_meta);
-	} else if (cache->object_size < sizeof(struct kasan_free_meta)) {
-		if (__slub_debug_enabled()) {
-			cache->kasan_info.free_meta_offset = *size;
-			*size += sizeof(struct kasan_free_meta);
-		} else {
-			rem_free_meta_size = sizeof(struct kasan_free_meta) -
-									cache->object_size;
-			*size += rem_free_meta_size;
-			if (cache->kasan_info.alloc_meta_offset != 0)
-				cache->kasan_info.alloc_meta_offset += rem_free_meta_size;
-		}
+		goto free_meta_added;
 	}
 
+	/*
+	 * Otherwise, if the object is large enough to contain free meta,
+	 * store it within the object.
+	 */
+	if (sizeof(struct kasan_free_meta) <= cache->object_size) {
+		/* cache->kasan_info.free_meta_offset = 0 is implied. */
+		goto free_meta_added;
+	}
+
+	/*
+	 * For smaller objects, store the beginning of free meta within the
+	 * object and the end in the redzone. And thus shift the location of
+	 * alloc meta to free up space for free meta.
+	 * This is only possible when slub_debug is disabled, as otherwise
+	 * the end of free meta will overlap with slub_debug metadata.
+	 */
+	if (!__slub_debug_enabled()) {
+		rem_free_meta_size = sizeof(struct kasan_free_meta) -
+							cache->object_size;
+		*size += rem_free_meta_size;
+		if (cache->kasan_info.alloc_meta_offset != 0)
+			cache->kasan_info.alloc_meta_offset += rem_free_meta_size;
+		goto free_meta_added;
+	}
+
+	/*
+	 * If the object is small and slub_debug is enabled, store free meta
+	 * in the redzone after alloc meta.
+	 */
+	cache->kasan_info.free_meta_offset = *size;
+	*size += sizeof(struct kasan_free_meta);
+
+free_meta_added:
 	/* If free meta doesn't fit, don't add it. */
 	if (*size > KMALLOC_MAX_SIZE) {
 		cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
@@ -441,7 +452,7 @@ void kasan_cache_create(struct kmem_cach
 
 	/* Calculate size with optimal redzone. */
 	optimal_size = cache->object_size + optimal_redzone(cache->object_size);
-	/* Limit it with KMALLOC_MAX_SIZE (relevant for SLAB only). */
+	/* Limit it with KMALLOC_MAX_SIZE. */
 	if (optimal_size > KMALLOC_MAX_SIZE)
 		optimal_size = KMALLOC_MAX_SIZE;
 	/* Use optimal size if the size with added metas is not large enough. */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

