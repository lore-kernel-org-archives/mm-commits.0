Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAF917EF
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZVf231yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E66DC433C7;
	Wed, 20 Dec 2023 00:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030743;
	bh=DjaRTSzuvDancRFLF6b+8qCNUEO7bFzDcnJyWJPntEE=;
	h=Date:To:From:Subject:From;
	b=ZVf231yKQcaKNj344tIlrqpMa4o4iONN8UEIv6tphLmph4n9Eu8zCikA5tAk0x1lq
	 sxGWdY1Zgen72a2Q+grNBhMl3q1vhQxtUwOTKbuwcO48E/0tVsX1icm0xEbuZRwoDd
	 OgQQ1IX3TBYPK2f6GlqWBQrEBvFW/nFIMbjhiH9U=
Date: Tue, 19 Dec 2023 16:05:43 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-clean-up-and-rename-____kasan_kmalloc.patch added to mm-unstable branch
Message-Id: <20231220000543.9E66DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: clean up and rename ____kasan_kmalloc
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-clean-up-and-rename-____kasan_kmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-clean-up-and-rename-____kasan_kmalloc.patch

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
Subject: kasan: clean up and rename ____kasan_kmalloc
Date: Tue, 19 Dec 2023 23:28:54 +0100

Introduce a new poison_kmalloc_redzone helper function that poisons the
redzone for kmalloc object.

Drop the confusingly named ____kasan_kmalloc function and instead use
poison_kmalloc_redzone along with the other required parts of
____kasan_kmalloc in the callers' code.

This is a preparatory change for the following patches in this series.

Link: https://lkml.kernel.org/r/5881232ad357ec0d59a5b1aefd9e0673a386399a.1703024586.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

--- a/mm/kasan/common.c~kasan-clean-up-and-rename-____kasan_kmalloc
+++ a/mm/kasan/common.c
@@ -312,26 +312,12 @@ void * __must_check __kasan_slab_alloc(s
 	return tagged_object;
 }
 
-static inline void *____kasan_kmalloc(struct kmem_cache *cache,
+static inline void poison_kmalloc_redzone(struct kmem_cache *cache,
 				const void *object, size_t size, gfp_t flags)
 {
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
-	if (gfpflags_allow_blocking(flags))
-		kasan_quarantine_reduce();
-
-	if (unlikely(object == NULL))
-		return NULL;
-
-	if (is_kfence_address(kasan_reset_tag(object)))
-		return (void *)object;
-
-	/*
-	 * The object has already been unpoisoned by kasan_slab_alloc() for
-	 * kmalloc() or by kasan_krealloc() for krealloc().
-	 */
-
 	/*
 	 * The redzone has byte-level precision for the generic mode.
 	 * Partially poison the last object granule to cover the unaligned
@@ -355,14 +341,25 @@ static inline void *____kasan_kmalloc(st
 	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
 		kasan_save_alloc_info(cache, (void *)object, flags);
 
-	/* Keep the tag that was set by kasan_slab_alloc(). */
-	return (void *)object;
 }
 
 void * __must_check __kasan_kmalloc(struct kmem_cache *cache, const void *object,
 					size_t size, gfp_t flags)
 {
-	return ____kasan_kmalloc(cache, object, size, flags);
+	if (gfpflags_allow_blocking(flags))
+		kasan_quarantine_reduce();
+
+	if (unlikely(object == NULL))
+		return NULL;
+
+	if (is_kfence_address(kasan_reset_tag(object)))
+		return (void *)object;
+
+	/* The object has already been unpoisoned by kasan_slab_alloc(). */
+	poison_kmalloc_redzone(cache, object, size, flags);
+
+	/* Keep the tag that was set by kasan_slab_alloc(). */
+	return (void *)object;
 }
 EXPORT_SYMBOL(__kasan_kmalloc);
 
@@ -408,6 +405,9 @@ void * __must_check __kasan_krealloc(con
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return (void *)object;
 
+	if (is_kfence_address(kasan_reset_tag(object)))
+		return (void *)object;
+
 	/*
 	 * Unpoison the object's data.
 	 * Part of it might already have been unpoisoned, but it's unknown
@@ -420,8 +420,10 @@ void * __must_check __kasan_krealloc(con
 	/* Piggy-back on kmalloc() instrumentation to poison the redzone. */
 	if (unlikely(!slab))
 		return __kasan_kmalloc_large(object, size, flags);
-	else
-		return ____kasan_kmalloc(slab->slab_cache, object, size, flags);
+	else {
+		poison_kmalloc_redzone(slab->slab_cache, object, size, flags);
+		return (void *)object;
+	}
 }
 
 bool __kasan_mempool_poison_pages(struct page *page, unsigned int order,
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

