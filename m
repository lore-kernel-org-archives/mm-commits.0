Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A365619BB8
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGwgw4ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0689CC433C8;
	Wed, 20 Dec 2023 00:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030725;
	bh=yA+roN4npivXunuESCCPg4lcpsu41mWCrdoE616gi1I=;
	h=Date:To:From:Subject:From;
	b=XGwgw4ekItGLKKDPGAjD6sebjlvYe2V7U0ee3QTFYpHaQRjSToH0tndTblYDYrfsi
	 rkBJnUu6lU2qMZFp8A/VS52+mt7mjEEa3iOYxo96GhP8Uq+qxrLl70azfNZOm0HIKo
	 I8Qh89OSoQaWbZ4eVdEvlgTc+883IEIXZ4z8uyDg=
Date: Tue, 19 Dec 2023 16:05:24 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object.patch added to mm-unstable branch
Message-Id: <20231220000525.0689CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: rename kasan_slab_free_mempool to kasan_mempool_poison_object
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object.patch

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
Subject: kasan: rename kasan_slab_free_mempool to kasan_mempool_poison_object
Date: Tue, 19 Dec 2023 23:28:45 +0100

Patch series "kasan: save mempool stack traces".

This series updates KASAN to save alloc and free stack traces for
secondary-level allocators that cache and reuse allocations internally
instead of giving them back to the underlying allocator (e.g.  mempool).

As a part of this change, introduce and document a set of KASAN hooks:

bool kasan_mempool_poison_pages(struct page *page, unsigned int order);
void kasan_mempool_unpoison_pages(struct page *page, unsigned int order);
bool kasan_mempool_poison_object(void *ptr);
void kasan_mempool_unpoison_object(void *ptr, size_t size);

and use them in the mempool code.

Besides mempool, skbuff and io_uring also cache allocations and already
use KASAN hooks to poison those.  Their code is updated to use the new
mempool hooks.

The new hooks save alloc and free stack traces (for normal kmalloc and
slab objects; stack traces for large kmalloc objects and page_alloc are
not supported by KASAN yet), improve the readability of the users' code,
and also allow the users to prevent double-free and invalid-free bugs; see
the patches for the details.


This patch (of 21):

Rename kasan_slab_free_mempool to kasan_mempool_poison_object.

kasan_slab_free_mempool is a slightly confusing name: it is unclear
whether this function poisons the object when it is freed into mempool or
does something when the object is freed from mempool to the underlying
allocator.

The new name also aligns with other mempool-related KASAN hooks added in
the following patches in this series.

Link: https://lkml.kernel.org/r/cover.1703024586.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/c5618685abb7cdbf9fb4897f565e7759f601da84.1703024586.git.andreyknvl@google.com
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

 include/linux/kasan.h  |    8 ++++----
 io_uring/alloc_cache.h |    3 +--
 mm/kasan/common.c      |    4 ++--
 mm/mempool.c           |    2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/kasan.h~kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object
+++ a/include/linux/kasan.h
@@ -172,11 +172,11 @@ static __always_inline void kasan_kfree_
 		__kasan_kfree_large(ptr, _RET_IP_);
 }
 
-void __kasan_slab_free_mempool(void *ptr, unsigned long ip);
-static __always_inline void kasan_slab_free_mempool(void *ptr)
+void __kasan_mempool_poison_object(void *ptr, unsigned long ip);
+static __always_inline void kasan_mempool_poison_object(void *ptr)
 {
 	if (kasan_enabled())
-		__kasan_slab_free_mempool(ptr, _RET_IP_);
+		__kasan_mempool_poison_object(ptr, _RET_IP_);
 }
 
 void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
@@ -256,7 +256,7 @@ static inline bool kasan_slab_free(struc
 	return false;
 }
 static inline void kasan_kfree_large(void *ptr) {}
-static inline void kasan_slab_free_mempool(void *ptr) {}
+static inline void kasan_mempool_poison_object(void *ptr) {}
 static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags, bool init)
 {
--- a/io_uring/alloc_cache.h~kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object
+++ a/io_uring/alloc_cache.h
@@ -16,8 +16,7 @@ static inline bool io_alloc_cache_put(st
 	if (cache->nr_cached < cache->max_cached) {
 		cache->nr_cached++;
 		wq_stack_add_head(&entry->node, &cache->list);
-		/* KASAN poisons object */
-		kasan_slab_free_mempool(entry);
+		kasan_mempool_poison_object(entry);
 		return true;
 	}
 	return false;
--- a/mm/kasan/common.c~kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object
+++ a/mm/kasan/common.c
@@ -271,7 +271,7 @@ static inline bool ____kasan_kfree_large
 
 	/*
 	 * The object will be poisoned by kasan_poison_pages() or
-	 * kasan_slab_free_mempool().
+	 * kasan_mempool_poison_object().
 	 */
 
 	return false;
@@ -282,7 +282,7 @@ void __kasan_kfree_large(void *ptr, unsi
 	____kasan_kfree_large(ptr, ip);
 }
 
-void __kasan_slab_free_mempool(void *ptr, unsigned long ip)
+void __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 {
 	struct folio *folio;
 
--- a/mm/mempool.c~kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object
+++ a/mm/mempool.c
@@ -107,7 +107,7 @@ static inline void poison_element(mempoo
 static __always_inline void kasan_poison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
-		kasan_slab_free_mempool(element);
+		kasan_mempool_poison_object(element);
 	else if (pool->alloc == mempool_alloc_pages)
 		kasan_poison_pages(element, (unsigned long)pool->pool_data,
 				   false);
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

