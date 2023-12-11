Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0910B468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WVeBVFwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C758CC433C7;
	Mon, 11 Dec 2023 00:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256114;
	bh=IR22y/bT8y0JZas6ZuBvwiGGWxNkGjqO7gfpJKp6mAI=;
	h=Date:To:From:Subject:From;
	b=WVeBVFwl6x9BtEEI6KgNBkh5siN1QNlgxU71b/ycyMWiJWV+RdNYRm4ZvVrfRPK9D
	 iFN/ZyWeOmUtN01sg9cLLBf5vH504pyqNmAAjR1jIYwaVzOOA6m9eSbMuHnQtRsdoI
	 sjuVEVXe9GPHKBlnriRGIIMwdrdBIhacB3X1hwuc=
Date: Sun, 10 Dec 2023 16:55:14 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,juntong.deng@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-improve-free-meta-storage-in-generic-kasan.patch removed from -mm tree
Message-Id: <20231211005514.C758CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: improve free meta storage in Generic KASAN
has been removed from the -mm tree.  Its filename was
     kasan-improve-free-meta-storage-in-generic-kasan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Juntong Deng <juntong.deng@outlook.com>
Subject: kasan: improve free meta storage in Generic KASAN
Date: Mon, 20 Nov 2023 04:46:29 +0800

Currently free meta can only be stored in object if the object is not
smaller than free meta.

After the improvement, when the object is smaller than free meta and SLUB
DEBUG is not enabled, it is possible to store part of the free meta in the
object, reducing the increased size of the red zone.

Example:

free meta size: 16 bytes
alloc meta size: 16 bytes
object size: 8 bytes
optimal redzone size (object_size <= 64): 16 bytes

Before improvement:
actual redzone size = alloc meta size + free meta size = 32 bytes

After improvement:
actual redzone size = alloc meta size + (free meta size - object size)
                    = 24 bytes

[juntong.deng@outlook.com: make kasan_metadata_size() adapt to the improved free meta storage]
  Link: https://lkml.kernel.org/r/VI1P193MB0752675D6E0A2D16CE656F8299BAA@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM
Link: https://lkml.kernel.org/r/VI1P193MB0752DE2CCD9046B5FED0AA8E99B5A@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/mm/kasan/generic.c~kasan-improve-free-meta-storage-in-generic-kasan
+++ a/mm/kasan/generic.c
@@ -362,6 +362,8 @@ void kasan_cache_create(struct kmem_cach
 {
 	unsigned int ok_size;
 	unsigned int optimal_size;
+	unsigned int rem_free_meta_size;
+	unsigned int orig_alloc_meta_offset;
 
 	if (!kasan_requires_meta())
 		return;
@@ -395,6 +397,9 @@ void kasan_cache_create(struct kmem_cach
 		/* Continue, since free meta might still fit. */
 	}
 
+	ok_size = *size;
+	orig_alloc_meta_offset = cache->kasan_info.alloc_meta_offset;
+
 	/*
 	 * Add free meta into redzone when it's not possible to store
 	 * it in the object. This is the case when:
@@ -402,23 +407,37 @@ void kasan_cache_create(struct kmem_cach
 	 *    be touched after it was freed, or
 	 * 2. Object has a constructor, which means it's expected to
 	 *    retain its content until the next allocation, or
-	 * 3. Object is too small.
+	 * 3. Object is too small and SLUB DEBUG is enabled. Avoid
+	 *    free meta that exceeds the object size corrupts the
+	 *    SLUB DEBUG metadata.
 	 * Otherwise cache->kasan_info.free_meta_offset = 0 is implied.
+	 * If the object is smaller than the free meta and SLUB DEBUG
+	 * is not enabled, it is still possible to store part of the
+	 * free meta in the object.
 	 */
-	if ((cache->flags & SLAB_TYPESAFE_BY_RCU) || cache->ctor ||
-	    cache->object_size < sizeof(struct kasan_free_meta)) {
-		ok_size = *size;
-
+	if ((cache->flags & SLAB_TYPESAFE_BY_RCU) || cache->ctor) {
 		cache->kasan_info.free_meta_offset = *size;
 		*size += sizeof(struct kasan_free_meta);
-
-		/* If free meta doesn't fit, don't add it. */
-		if (*size > KMALLOC_MAX_SIZE) {
-			cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
-			*size = ok_size;
+	} else if (cache->object_size < sizeof(struct kasan_free_meta)) {
+		if (__slub_debug_enabled()) {
+			cache->kasan_info.free_meta_offset = *size;
+			*size += sizeof(struct kasan_free_meta);
+		} else {
+			rem_free_meta_size = sizeof(struct kasan_free_meta) -
+									cache->object_size;
+			*size += rem_free_meta_size;
+			if (cache->kasan_info.alloc_meta_offset != 0)
+				cache->kasan_info.alloc_meta_offset += rem_free_meta_size;
 		}
 	}
 
+	/* If free meta doesn't fit, don't add it. */
+	if (*size > KMALLOC_MAX_SIZE) {
+		cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
+		cache->kasan_info.alloc_meta_offset = orig_alloc_meta_offset;
+		*size = ok_size;
+	}
+
 	/* Calculate size with optimal redzone. */
 	optimal_size = cache->object_size + optimal_redzone(cache->object_size);
 	/* Limit it with KMALLOC_MAX_SIZE (relevant for SLAB only). */
_

Patches currently in -mm which might be from juntong.deng@outlook.com are


