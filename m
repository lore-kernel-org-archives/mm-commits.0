Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8628313AC2
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y3dy1XDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B3FC433C8;
	Fri, 29 Dec 2023 20:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880043;
	bh=dFkhS6jEKgBWMNEN7Y4ozgtUWwClddQGWfMp9alN0H4=;
	h=Date:To:From:Subject:From;
	b=Y3dy1XDQzl78oVYqS5ZxUnjcN+xdQAZT9+kzK0Sq3S8hV1DfcLVLih6+BZ42A0zXS
	 PMQyjVXINb70Ivt7EQeNs70OHpKA3az2EoBSFyKK3E1g7KEtHCVb/qJKzBZ5gFYiwT
	 MtyWBblu4e1v8npd5GFNHibA2DS0Cof9B5fFid4E=
Date: Fri, 29 Dec 2023 12:00:42 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-clean-up-and-rename-____kasan_kmalloc.patch removed from -mm tree
Message-Id: <20231229200043.51B3FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: clean up and rename ____kasan_kmalloc
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-and-rename-____kasan_kmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kasan-stop-leaking-stack-trace-handles.patch

