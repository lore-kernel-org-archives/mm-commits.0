Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04581137F
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eU6wcUWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FF4C433C8;
	Wed, 20 Dec 2023 00:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030731;
	bh=TidNYRknEEgOC86CaqAbRIQL2HlgroaBfMkRNntfvOg=;
	h=Date:To:From:Subject:From;
	b=eU6wcUWvIg3BWYnITC9zoTVQ0vkPw7JAYDpP1IV9XdBVuHdqmFACRo/8UQKiYE30O
	 7xn/ek9nqUjXIx9P6Lj1hXNrc6P3O1Hjeh5SaW21dhRp+yQ0yD6KZzLYe/a1C0teY3
	 WTbB/s0yKmJVsjEd1QISOEn8POLyxaph/DwsskVo=
Date: Tue, 19 Dec 2023 16:05:30 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-return-value-for-kasan_mempool_poison_object.patch added to mm-unstable branch
Message-Id: <20231220000531.69FF4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: add return value for kasan_mempool_poison_object
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-add-return-value-for-kasan_mempool_poison_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-return-value-for-kasan_mempool_poison_object.patch

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
Subject: kasan: add return value for kasan_mempool_poison_object
Date: Tue, 19 Dec 2023 23:28:48 +0100

Add a return value for kasan_mempool_poison_object that lets the caller
know whether the allocation is affected by a double-free or an
invalid-free bug.  The caller can use this return value to stop operating
on the object.

Also introduce a check_page_allocation helper function to improve the code
readability.

Link: https://lkml.kernel.org/r/618af65273875fb9f56954285443279b15f1fcd9.1703024586.git.andreyknvl@google.com
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

 include/linux/kasan.h |   17 ++++++++++++-----
 mm/kasan/common.c     |   21 ++++++++++-----------
 2 files changed, 22 insertions(+), 16 deletions(-)

--- a/include/linux/kasan.h~kasan-add-return-value-for-kasan_mempool_poison_object
+++ a/include/linux/kasan.h
@@ -212,7 +212,7 @@ static __always_inline void * __must_che
 	return (void *)object;
 }
 
-void __kasan_mempool_poison_object(void *ptr, unsigned long ip);
+bool __kasan_mempool_poison_object(void *ptr, unsigned long ip);
 /**
  * kasan_mempool_poison_object - Check and poison a mempool slab allocation.
  * @ptr: Pointer to the slab allocation.
@@ -225,16 +225,20 @@ void __kasan_mempool_poison_object(void
  * without putting it into the quarantine (for the Generic mode).
  *
  * This function also performs checks to detect double-free and invalid-free
- * bugs and reports them.
+ * bugs and reports them. The caller can use the return value of this function
+ * to find out if the allocation is buggy.
  *
  * This function operates on all slab allocations including large kmalloc
  * allocations (the ones returned by kmalloc_large() or by kmalloc() with the
  * size > KMALLOC_MAX_SIZE).
+ *
+ * Return: true if the allocation can be safely reused; false otherwise.
  */
-static __always_inline void kasan_mempool_poison_object(void *ptr)
+static __always_inline bool kasan_mempool_poison_object(void *ptr)
 {
 	if (kasan_enabled())
-		__kasan_mempool_poison_object(ptr, _RET_IP_);
+		return __kasan_mempool_poison_object(ptr, _RET_IP_);
+	return true;
 }
 
 /*
@@ -293,7 +297,10 @@ static inline void *kasan_krealloc(const
 {
 	return (void *)object;
 }
-static inline void kasan_mempool_poison_object(void *ptr) {}
+static inline bool kasan_mempool_poison_object(void *ptr)
+{
+	return true;
+}
 static inline bool kasan_check_byte(const void *address)
 {
 	return true;
--- a/mm/kasan/common.c~kasan-add-return-value-for-kasan_mempool_poison_object
+++ a/mm/kasan/common.c
@@ -254,7 +254,7 @@ bool __kasan_slab_free(struct kmem_cache
 	return ____kasan_slab_free(cache, object, ip, true, init);
 }
 
-static inline bool ____kasan_kfree_large(void *ptr, unsigned long ip)
+static inline bool check_page_allocation(void *ptr, unsigned long ip)
 {
 	if (!kasan_arch_is_ready())
 		return false;
@@ -269,17 +269,14 @@ static inline bool ____kasan_kfree_large
 		return true;
 	}
 
-	/*
-	 * The object will be poisoned by kasan_poison_pages() or
-	 * kasan_mempool_poison_object().
-	 */
-
 	return false;
 }
 
 void __kasan_kfree_large(void *ptr, unsigned long ip)
 {
-	____kasan_kfree_large(ptr, ip);
+	check_page_allocation(ptr, ip);
+
+	/* The object will be poisoned by kasan_poison_pages(). */
 }
 
 void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
@@ -429,7 +426,7 @@ void * __must_check __kasan_krealloc(con
 		return ____kasan_kmalloc(slab->slab_cache, object, size, flags);
 }
 
-void __kasan_mempool_poison_object(void *ptr, unsigned long ip)
+bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 {
 	struct folio *folio;
 
@@ -442,13 +439,15 @@ void __kasan_mempool_poison_object(void
 	 * KMALLOC_MAX_SIZE, and kmalloc falls back onto page_alloc.
 	 */
 	if (unlikely(!folio_test_slab(folio))) {
-		if (____kasan_kfree_large(ptr, ip))
-			return;
+		if (check_page_allocation(ptr, ip))
+			return false;
 		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
+		return true;
 	} else {
 		struct slab *slab = folio_slab(folio);
 
-		____kasan_slab_free(slab->slab_cache, ptr, ip, false, false);
+		return !____kasan_slab_free(slab->slab_cache, ptr, ip,
+						false, false);
 	}
 }
 
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

