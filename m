Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6AB13ADC
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WbsZl/qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFEAC433C9;
	Fri, 29 Dec 2023 20:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880074;
	bh=HCafscOl/5iA2//04ix2he18o/EAMc1COrfqeqyIyJI=;
	h=Date:To:From:Subject:From;
	b=WbsZl/qDrbb1u7BTnN2WoiMXj1QXK9uBC5Ppj5lHODdVTr4sHv7RlA+gFTEa6WrzH
	 myOiIrFSiowjSXi8J+q4sRjzjSe/Ws4Kt3z2GSpsdVOdbPPv4s7DdjRIhmUw67wRVi
	 DAINh4Y7PWaiVHKI9r2xAjqx7Kc3R8I28dY4ZjQE=
Date: Fri, 29 Dec 2023 12:01:13 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-clean-up-is_kfence_address-checks.patch removed from -mm tree
Message-Id: <20231229200114.0AFEAC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: clean up is_kfence_address checks
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-is_kfence_address-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean up is_kfence_address checks
Date: Thu, 21 Dec 2023 21:04:48 +0100

1. Do not untag addresses that are passed to is_kfence_address: it
   tolerates tagged addresses.

2. Move is_kfence_address checks from internal KASAN functions
   (kasan_poison/unpoison, etc.) to external-facing ones.

   Note that kasan_poison/unpoison are never called outside of KASAN/slab
   code anymore; the comment is wrong, so drop it.

3. Simplify/reorganize the code around the updated checks.

Link: https://lkml.kernel.org/r/1065732315ef4e141b6177d8f612232d4d5bc0ab.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   26 +++++++++++++++++---------
 mm/kasan/kasan.h  |   16 ++--------------
 mm/kasan/shadow.c |   12 ------------
 3 files changed, 19 insertions(+), 35 deletions(-)

--- a/mm/kasan/common.c~kasan-clean-up-is_kfence_address-checks
+++ a/mm/kasan/common.c
@@ -79,6 +79,9 @@ EXPORT_SYMBOL(kasan_disable_current);
 
 void __kasan_unpoison_range(const void *address, size_t size)
 {
+	if (is_kfence_address(address))
+		return;
+
 	kasan_unpoison(address, size, false);
 }
 
@@ -218,9 +221,6 @@ static inline bool poison_slab_object(st
 	tagged_object = object;
 	object = kasan_reset_tag(object);
 
-	if (is_kfence_address(object))
-		return false;
-
 	if (unlikely(nearest_obj(cache, virt_to_slab(object), object) != object)) {
 		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
@@ -247,7 +247,12 @@ static inline bool poison_slab_object(st
 bool __kasan_slab_free(struct kmem_cache *cache, void *object,
 				unsigned long ip, bool init)
 {
-	bool buggy_object = poison_slab_object(cache, object, ip, init);
+	bool buggy_object;
+
+	if (is_kfence_address(object))
+		return false;
+
+	buggy_object = poison_slab_object(cache, object, ip, init);
 
 	return buggy_object ? true : kasan_quarantine_put(cache, object);
 }
@@ -359,7 +364,7 @@ void * __must_check __kasan_kmalloc(stru
 	if (unlikely(object == NULL))
 		return NULL;
 
-	if (is_kfence_address(kasan_reset_tag(object)))
+	if (is_kfence_address(object))
 		return (void *)object;
 
 	/* The object has already been unpoisoned by kasan_slab_alloc(). */
@@ -417,7 +422,7 @@ void * __must_check __kasan_krealloc(con
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return (void *)object;
 
-	if (is_kfence_address(kasan_reset_tag(object)))
+	if (is_kfence_address(object))
 		return (void *)object;
 
 	/*
@@ -483,6 +488,9 @@ bool __kasan_mempool_poison_object(void
 		return true;
 	}
 
+	if (is_kfence_address(ptr))
+		return false;
+
 	slab = folio_slab(folio);
 	return !poison_slab_object(slab->slab_cache, ptr, ip, false);
 }
@@ -492,9 +500,6 @@ void __kasan_mempool_unpoison_object(voi
 	struct slab *slab;
 	gfp_t flags = 0; /* Might be executing under a lock. */
 
-	if (is_kfence_address(kasan_reset_tag(ptr)))
-		return;
-
 	slab = virt_to_slab(ptr);
 
 	/*
@@ -507,6 +512,9 @@ void __kasan_mempool_unpoison_object(voi
 		return;
 	}
 
+	if (is_kfence_address(ptr))
+		return;
+
 	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
 	unpoison_slab_object(slab->slab_cache, ptr, size, flags);
 
--- a/mm/kasan/kasan.h~kasan-clean-up-is_kfence_address-checks
+++ a/mm/kasan/kasan.h
@@ -466,35 +466,23 @@ static inline u8 kasan_random_tag(void)
 
 static inline void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 {
-	addr = kasan_reset_tag(addr);
-
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(addr))
-		return;
-
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 	if (WARN_ON(size & KASAN_GRANULE_MASK))
 		return;
 
-	hw_set_mem_tag_range((void *)addr, size, value, init);
+	hw_set_mem_tag_range(kasan_reset_tag(addr), size, value, init);
 }
 
 static inline void kasan_unpoison(const void *addr, size_t size, bool init)
 {
 	u8 tag = get_tag(addr);
 
-	addr = kasan_reset_tag(addr);
-
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(addr))
-		return;
-
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
-	hw_set_mem_tag_range((void *)addr, size, tag, init);
+	hw_set_mem_tag_range(kasan_reset_tag(addr), size, tag, init);
 }
 
 static inline bool kasan_byte_accessible(const void *addr)
--- a/mm/kasan/shadow.c~kasan-clean-up-is_kfence_address-checks
+++ a/mm/kasan/shadow.c
@@ -135,10 +135,6 @@ void kasan_poison(const void *addr, size
 	 */
 	addr = kasan_reset_tag(addr);
 
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(addr))
-		return;
-
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 	if (WARN_ON(size & KASAN_GRANULE_MASK))
@@ -175,14 +171,6 @@ void kasan_unpoison(const void *addr, si
 	 */
 	addr = kasan_reset_tag(addr);
 
-	/*
-	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
-	 * that calls to ksize(), where size is not a multiple of machine-word
-	 * size, would otherwise poison the invalid portion of the word.
-	 */
-	if (is_kfence_address(addr))
-		return;
-
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

