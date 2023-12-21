Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAC55E59
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOKHJmhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9122C433C8;
	Thu, 21 Dec 2023 21:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703195264;
	bh=Yx3aL6KJ1+m0mtofT//msHr++zViToyWAktwsTj17Zk=;
	h=Date:To:From:Subject:From;
	b=UOKHJmhYXeebIASIVBRR37SUfjyEGXpkN73kkL0zhyzT9jBvbRfvq6CDiPQJ0ZSTB
	 gE/f9/vg5hsmS47a0dykflPXcjOppm2pYv677aXVV1+6ppGVfsrmHCtsZ+avAg1Kdj
	 7P3De6E3xF6GDF4VXKucQ3UU8QX/+NUxF4cIKWp0=
Date: Thu, 21 Dec 2023 13:47:43 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,juntong.deng@outlook.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-clean-up-kasan_cache_create.patch added to mm-unstable branch
Message-Id: <20231221214744.B9122C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: clean up kasan_cache_create
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-clean-up-kasan_cache_create.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-clean-up-kasan_cache_create.patch

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
Cc: Marco Elver <elver@google.com>
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

kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object.patch
kasan-move-kasan_mempool_poison_object.patch
kasan-document-kasan_mempool_poison_object.patch
kasan-add-return-value-for-kasan_mempool_poison_object.patch
kasan-introduce-kasan_mempool_unpoison_object.patch
kasan-introduce-kasan_mempool_poison_pages.patch
kasan-introduce-kasan_mempool_unpoison_pages.patch
kasan-clean-up-__kasan_mempool_poison_object.patch
kasan-save-free-stack-traces-for-slab-mempools.patch
kasan-clean-up-and-rename-____kasan_kmalloc.patch
kasan-introduce-poison_kmalloc_large_redzone.patch
kasan-save-alloc-stack-traces-for-mempool.patch
mempool-skip-slub_debug-poisoning-when-kasan-is-enabled.patch
mempool-use-new-mempool-kasan-hooks.patch
mempool-introduce-mempool_use_prealloc_only.patch
kasan-add-mempool-tests.patch
kasan-rename-pagealloc-tests.patch
kasan-reorder-tests.patch
kasan-rename-and-document-kasan_unpoison_object_data.patch
skbuff-use-mempool-kasan-hooks.patch
io_uring-use-mempool-kasan-hook.patch
lib-stackdepot-add-printk_deferred_enter-exit-guards.patch
kasan-handle-concurrent-kasan_record_aux_stack-calls.patch
kasan-memset-free-track-in-qlink_free.patch
lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch
kasan-arm64-improve-comments-for-kasan_shadow_start-end.patch
mm-kasan-use-kasan_tag_kernel-instead-of-0xff.patch
kasan-improve-kasan_non_canonical_hook.patch
kasan-clean-up-kasan_requires_meta.patch
kasan-update-kasan_poison-documentation-comment.patch
kasan-clean-up-is_kfence_address-checks.patch
kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc.patch
kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests.patch
kasan-export-kasan_poison-as-gpl.patch
kasan-remove-slub-checks-for-page_alloc-fallbacks-in-tests.patch
kasan-speed-up-match_all_mem_tag-test-for-sw_tags.patch
kasan-clean-up-kasan_cache_create.patch
kasan-reuse-kasan_track-in-kasan_stack_ring_entry.patch
kasan-simplify-saving-extra-info-into-tracks.patch
kasan-simplify-kasan_complete_mode_report_info-for-tag-based-modes.patch

