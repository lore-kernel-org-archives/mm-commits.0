Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02D9ECC
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eT0Ybhl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35072C433C8;
	Wed, 20 Dec 2023 00:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030747;
	bh=3/HNgmDzabCUJqTne/zwaOO7MYrMGurhN/8pIXxq5JY=;
	h=Date:To:From:Subject:From;
	b=eT0Ybhl+g8UDMcPL+rphzo7SwrqmIu86jzd7y1Bu78U5T79clKHslRx5NyGCoyPSB
	 HjRcCxz7mu781Xgu+9TBZR+FA3qEnFBlpdTHdc1GzVnK58cQfHII+sYNOLpmoynA84
	 DeWsN3VRWyoEMx45jJgvq921FKdqPrrSvqsP1uc4=
Date: Tue, 19 Dec 2023 16:05:46 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-save-alloc-stack-traces-for-mempool.patch added to mm-unstable branch
Message-Id: <20231220000547.35072C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: save alloc stack traces for mempool
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-save-alloc-stack-traces-for-mempool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-save-alloc-stack-traces-for-mempool.patch

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
Subject: kasan: save alloc stack traces for mempool
Date: Tue, 19 Dec 2023 23:28:56 +0100

Update kasan_mempool_unpoison_object to properly poison the redzone and
save alloc strack traces for kmalloc and slab pools.

As a part of this change, split out and use a unpoison_slab_object helper
function from __kasan_slab_alloc.

Link: https://lkml.kernel.org/r/05ad235da8347cfe14d496d01b2aaf074b4f607c.1703024586.git.andreyknvl@google.com
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

 include/linux/kasan.h |    7 +++--
 mm/kasan/common.c     |   50 ++++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 13 deletions(-)

--- a/include/linux/kasan.h~kasan-save-alloc-stack-traces-for-mempool
+++ a/include/linux/kasan.h
@@ -303,9 +303,10 @@ void __kasan_mempool_unpoison_object(voi
  * mempool).
  *
  * This function unpoisons a slab allocation that was previously poisoned via
- * kasan_mempool_poison_object() without initializing its memory. For the
- * tag-based modes, this function does not assign a new tag to the allocation
- * and instead restores the original tags based on the pointer value.
+ * kasan_mempool_poison_object() and saves an alloc stack trace for it without
+ * initializing the allocation's memory. For the tag-based modes, this function
+ * does not assign a new tag to the allocation and instead restores the
+ * original tags based on the pointer value.
  *
  * This function operates on all slab allocations including large kmalloc
  * allocations (the ones returned by kmalloc_large() or by kmalloc() with the
--- a/mm/kasan/common.c~kasan-save-alloc-stack-traces-for-mempool
+++ a/mm/kasan/common.c
@@ -277,6 +277,20 @@ void __kasan_kfree_large(void *ptr, unsi
 	/* The object will be poisoned by kasan_poison_pages(). */
 }
 
+void unpoison_slab_object(struct kmem_cache *cache, void *object, gfp_t flags,
+			  bool init)
+{
+	/*
+	 * Unpoison the whole object. For kmalloc() allocations,
+	 * poison_kmalloc_redzone() will do precise poisoning.
+	 */
+	kasan_unpoison(object, cache->object_size, init);
+
+	/* Save alloc info (if possible) for non-kmalloc() allocations. */
+	if (kasan_stack_collection_enabled() && !is_kmalloc_cache(cache))
+		kasan_save_alloc_info(cache, object, flags);
+}
+
 void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
 					void *object, gfp_t flags, bool init)
 {
@@ -299,15 +313,8 @@ void * __must_check __kasan_slab_alloc(s
 	tag = assign_tag(cache, object, false);
 	tagged_object = set_tag(object, tag);
 
-	/*
-	 * Unpoison the whole object.
-	 * For kmalloc() allocations, kasan_kmalloc() will do precise poisoning.
-	 */
-	kasan_unpoison(tagged_object, cache->object_size, init);
-
-	/* Save alloc info (if possible) for non-kmalloc() allocations. */
-	if (kasan_stack_collection_enabled() && !is_kmalloc_cache(cache))
-		kasan_save_alloc_info(cache, tagged_object, flags);
+	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
+	unpoison_slab_object(cache, tagged_object, flags, init);
 
 	return tagged_object;
 }
@@ -482,7 +489,30 @@ bool __kasan_mempool_poison_object(void
 
 void __kasan_mempool_unpoison_object(void *ptr, size_t size, unsigned long ip)
 {
-	kasan_unpoison(ptr, size, false);
+	struct slab *slab;
+	gfp_t flags = 0; /* Might be executing under a lock. */
+
+	if (is_kfence_address(kasan_reset_tag(ptr)))
+		return;
+
+	slab = virt_to_slab(ptr);
+
+	/*
+	 * This function can be called for large kmalloc allocation that get
+	 * their memory from page_alloc.
+	 */
+	if (unlikely(!slab)) {
+		kasan_unpoison(ptr, size, false);
+		poison_kmalloc_large_redzone(ptr, size, flags);
+		return;
+	}
+
+	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
+	unpoison_slab_object(slab->slab_cache, ptr, size, flags);
+
+	/* Poison the redzone and save alloc info for kmalloc() allocations. */
+	if (is_kmalloc_cache(slab->slab_cache))
+		poison_kmalloc_redzone(slab->slab_cache, ptr, size, flags);
 }
 
 bool __kasan_check_byte(const void *address, unsigned long ip)
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

