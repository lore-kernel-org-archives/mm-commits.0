Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D19E13ADB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z0PnHPW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14568C433C8;
	Fri, 29 Dec 2023 20:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880035;
	bh=y3Zom4QOKQE7Mfy6gf1mnzI4Lz+oTTIOv/zjn+GiFs0=;
	h=Date:To:From:Subject:From;
	b=Z0PnHPW2+URFiKrs1sQ2RjyMUgWGwSQpX0lqaWcybp5tVRt9PFKfJFC4IyZvteWkZ
	 rq0S7ZAWxl44SEYR8JkFa7h2jv70mKwHWWxfDTqW4nndyuIX/4fCqGhF0Q4TamcPgt
	 1Z9XbbyS5vwTnqLloEiWtL82X2EoX7drbVW5PFSI=
Date: Fri, 29 Dec 2023 12:00:34 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-move-kasan_mempool_poison_object.patch removed from -mm tree
Message-Id: <20231229200035.14568C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: move kasan_mempool_poison_object
has been removed from the -mm tree.  Its filename was
     kasan-move-kasan_mempool_poison_object.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move kasan_mempool_poison_object
Date: Tue, 19 Dec 2023 23:28:46 +0100

Move kasan_mempool_poison_object after all slab-related KASAN hooks.

This is a preparatory change for the following patches in this series.

No functional changes.

Link: https://lkml.kernel.org/r/23ea215409f43c13cdf9ecc454501a264c107d67.1703024586.git.andreyknvl@google.com
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

 include/linux/kasan.h |   16 ++++++-------
 mm/kasan/common.c     |   46 ++++++++++++++++++++--------------------
 2 files changed, 31 insertions(+), 31 deletions(-)

--- a/include/linux/kasan.h~kasan-move-kasan_mempool_poison_object
+++ a/include/linux/kasan.h
@@ -172,13 +172,6 @@ static __always_inline void kasan_kfree_
 		__kasan_kfree_large(ptr, _RET_IP_);
 }
 
-void __kasan_mempool_poison_object(void *ptr, unsigned long ip);
-static __always_inline void kasan_mempool_poison_object(void *ptr)
-{
-	if (kasan_enabled())
-		__kasan_mempool_poison_object(ptr, _RET_IP_);
-}
-
 void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
 				       void *object, gfp_t flags, bool init);
 static __always_inline void * __must_check kasan_slab_alloc(
@@ -219,6 +212,13 @@ static __always_inline void * __must_che
 	return (void *)object;
 }
 
+void __kasan_mempool_poison_object(void *ptr, unsigned long ip);
+static __always_inline void kasan_mempool_poison_object(void *ptr)
+{
+	if (kasan_enabled())
+		__kasan_mempool_poison_object(ptr, _RET_IP_);
+}
+
 /*
  * Unlike kasan_check_read/write(), kasan_check_byte() is performed even for
  * the hardware tag-based mode that doesn't rely on compiler instrumentation.
@@ -256,7 +256,6 @@ static inline bool kasan_slab_free(struc
 	return false;
 }
 static inline void kasan_kfree_large(void *ptr) {}
-static inline void kasan_mempool_poison_object(void *ptr) {}
 static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags, bool init)
 {
@@ -276,6 +275,7 @@ static inline void *kasan_krealloc(const
 {
 	return (void *)object;
 }
+static inline void kasan_mempool_poison_object(void *ptr) {}
 static inline bool kasan_check_byte(const void *address)
 {
 	return true;
--- a/mm/kasan/common.c~kasan-move-kasan_mempool_poison_object
+++ a/mm/kasan/common.c
@@ -282,29 +282,6 @@ void __kasan_kfree_large(void *ptr, unsi
 	____kasan_kfree_large(ptr, ip);
 }
 
-void __kasan_mempool_poison_object(void *ptr, unsigned long ip)
-{
-	struct folio *folio;
-
-	folio = virt_to_folio(ptr);
-
-	/*
-	 * Even though this function is only called for kmem_cache_alloc and
-	 * kmalloc backed mempool allocations, those allocations can still be
-	 * !PageSlab() when the size provided to kmalloc is larger than
-	 * KMALLOC_MAX_SIZE, and kmalloc falls back onto page_alloc.
-	 */
-	if (unlikely(!folio_test_slab(folio))) {
-		if (____kasan_kfree_large(ptr, ip))
-			return;
-		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
-	} else {
-		struct slab *slab = folio_slab(folio);
-
-		____kasan_slab_free(slab->slab_cache, ptr, ip, false, false);
-	}
-}
-
 void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
 					void *object, gfp_t flags, bool init)
 {
@@ -452,6 +429,29 @@ void * __must_check __kasan_krealloc(con
 		return ____kasan_kmalloc(slab->slab_cache, object, size, flags);
 }
 
+void __kasan_mempool_poison_object(void *ptr, unsigned long ip)
+{
+	struct folio *folio;
+
+	folio = virt_to_folio(ptr);
+
+	/*
+	 * Even though this function is only called for kmem_cache_alloc and
+	 * kmalloc backed mempool allocations, those allocations can still be
+	 * !PageSlab() when the size provided to kmalloc is larger than
+	 * KMALLOC_MAX_SIZE, and kmalloc falls back onto page_alloc.
+	 */
+	if (unlikely(!folio_test_slab(folio))) {
+		if (____kasan_kfree_large(ptr, ip))
+			return;
+		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
+	} else {
+		struct slab *slab = folio_slab(folio);
+
+		____kasan_slab_free(slab->slab_cache, ptr, ip, false, false);
+	}
+}
+
 bool __kasan_check_byte(const void *address, unsigned long ip)
 {
 	if (!kasan_byte_accessible(address)) {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

