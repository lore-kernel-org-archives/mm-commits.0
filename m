Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5882910FA
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4MeUCRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B701DC433C8;
	Wed, 20 Dec 2023 00:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030752;
	bh=6oOIzPkdFMaLa9Te6nDe5JPKB/1jSBOmfrwFpcJINj8=;
	h=Date:To:From:Subject:From;
	b=P4MeUCRTWDNCX2LGlqP0w24pe1x9uHQCZenQoGBZWcFa6U1so7tGYfNd7eWqaEOzr
	 s8BAWsBQb5PA1MVtwWGiczk2M+hL3JVd8MxiIKa2QHO/46JYn81rd42TnF3HnqdSWP
	 knTi4HQ1OlymtthWBM5+Qpvv1EBzP7CCzcXdyFWg=
Date: Tue, 19 Dec 2023 16:05:52 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempool-introduce-mempool_use_prealloc_only.patch added to mm-unstable branch
Message-Id: <20231220000552.B701DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempool: introduce mempool_use_prealloc_only
has been added to the -mm mm-unstable branch.  Its filename is
     mempool-introduce-mempool_use_prealloc_only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempool-introduce-mempool_use_prealloc_only.patch

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
Subject: mempool: introduce mempool_use_prealloc_only
Date: Tue, 19 Dec 2023 23:28:59 +0100

Introduce a new mempool_alloc_preallocated API that asks the mempool to
only use the elements preallocated during the mempool's creation when
allocating and to not attempt allocating new ones from the underlying
allocator.

This API is required to test the KASAN poisoning/unpoisoning functionality
in KASAN tests, but it might be also useful on its own.

Link: https://lkml.kernel.org/r/a14d809dbdfd04cc33bcacc632fee2abd6b83c00.1703024586.git.andreyknvl@google.com
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

 include/linux/mempool.h |    1 +
 mm/mempool.c            |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- a/include/linux/mempool.h~mempool-introduce-mempool_use_prealloc_only
+++ a/include/linux/mempool.h
@@ -51,6 +51,7 @@ extern mempool_t *mempool_create_node(in
 extern int mempool_resize(mempool_t *pool, int new_min_nr);
 extern void mempool_destroy(mempool_t *pool);
 extern void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
+extern void *mempool_alloc_preallocated(mempool_t *pool) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
 
 /*
--- a/mm/mempool.c~mempool-introduce-mempool_use_prealloc_only
+++ a/mm/mempool.c
@@ -457,6 +457,43 @@ repeat_alloc:
 EXPORT_SYMBOL(mempool_alloc);
 
 /**
+ * mempool_alloc_preallocated - allocate an element from preallocated elements
+ *                              belonging to a specific memory pool
+ * @pool:      pointer to the memory pool which was allocated via
+ *             mempool_create().
+ *
+ * This function is similar to mempool_alloc, but it only attempts allocating
+ * an element from the preallocated elements. It does not sleep and immediately
+ * returns if no preallocated elements are available.
+ *
+ * Return: pointer to the allocated element or %NULL if no elements are
+ * available.
+ */
+void *mempool_alloc_preallocated(mempool_t *pool)
+{
+	void *element;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	if (likely(pool->curr_nr)) {
+		element = remove_element(pool);
+		spin_unlock_irqrestore(&pool->lock, flags);
+		/* paired with rmb in mempool_free(), read comment there */
+		smp_wmb();
+		/*
+		 * Update the allocation stack trace as this is more useful
+		 * for debugging.
+		 */
+		kmemleak_update_trace(element);
+		return element;
+	}
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	return NULL;
+}
+EXPORT_SYMBOL(mempool_alloc_preallocated);
+
+/**
  * mempool_free - return an element to the pool.
  * @element:   pool element pointer.
  * @pool:      pointer to the memory pool which was allocated via
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

