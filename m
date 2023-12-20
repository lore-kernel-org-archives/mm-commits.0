Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969EA1369
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mV9UEffg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A21C433C8;
	Wed, 20 Dec 2023 00:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030745;
	bh=ijHp6Bs+D+at5hHglB2D4+8A5FfUhDXUj5fgQLdCCN8=;
	h=Date:To:From:Subject:From;
	b=mV9UEffg2Ek/WIyGintMXslb3njUXAkHJ9OkNL3riR3nnHq3RWBIYok9+uFxF3HYn
	 9iRs9khcgajiTwg9PkRN4Vq5XHJJwtB1hU3VOY6cBxfXdS0fR16ejle6RAPpe1HOsM
	 /ZVQE6XZkkrNr6HJ8XMNiUjyE79xLArYHYJmykxY=
Date: Tue, 19 Dec 2023 16:05:44 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-introduce-poison_kmalloc_large_redzone.patch added to mm-unstable branch
Message-Id: <20231220000545.61A21C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: introduce poison_kmalloc_large_redzone
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-introduce-poison_kmalloc_large_redzone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-introduce-poison_kmalloc_large_redzone.patch

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
Subject: kasan: introduce poison_kmalloc_large_redzone
Date: Tue, 19 Dec 2023 23:28:55 +0100

Split out a poison_kmalloc_large_redzone helper from __kasan_kmalloc_large
and use it in the caller's code.

This is a preparatory change for the following patches in this series.

Link: https://lkml.kernel.org/r/93317097b668519d76097fb065201b2027436e22.1703024586.git.andreyknvl@google.com
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

 mm/kasan/common.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

--- a/mm/kasan/common.c~kasan-introduce-poison_kmalloc_large_redzone
+++ a/mm/kasan/common.c
@@ -363,23 +363,12 @@ void * __must_check __kasan_kmalloc(stru
 }
 EXPORT_SYMBOL(__kasan_kmalloc);
 
-void * __must_check __kasan_kmalloc_large(const void *ptr, size_t size,
+static inline void poison_kmalloc_large_redzone(const void *ptr, size_t size,
 						gfp_t flags)
 {
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
-	if (gfpflags_allow_blocking(flags))
-		kasan_quarantine_reduce();
-
-	if (unlikely(ptr == NULL))
-		return NULL;
-
-	/*
-	 * The object has already been unpoisoned by kasan_unpoison_pages() for
-	 * alloc_pages() or by kasan_krealloc() for krealloc().
-	 */
-
 	/*
 	 * The redzone has byte-level precision for the generic mode.
 	 * Partially poison the last object granule to cover the unaligned
@@ -389,12 +378,25 @@ void * __must_check __kasan_kmalloc_larg
 		kasan_poison_last_granule(ptr, size);
 
 	/* Poison the aligned part of the redzone. */
-	redzone_start = round_up((unsigned long)(ptr + size),
-				KASAN_GRANULE_SIZE);
+	redzone_start = round_up((unsigned long)(ptr + size), KASAN_GRANULE_SIZE);
 	redzone_end = (unsigned long)ptr + page_size(virt_to_page(ptr));
 	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
 		     KASAN_PAGE_REDZONE, false);
+}
+
+void * __must_check __kasan_kmalloc_large(const void *ptr, size_t size,
+						gfp_t flags)
+{
+	if (gfpflags_allow_blocking(flags))
+		kasan_quarantine_reduce();
+
+	if (unlikely(ptr == NULL))
+		return NULL;
 
+	/* The object has already been unpoisoned by kasan_unpoison_pages(). */
+	poison_kmalloc_large_redzone(ptr, size, flags);
+
+	/* Keep the tag that was set by alloc_pages(). */
 	return (void *)ptr;
 }
 
@@ -402,6 +404,9 @@ void * __must_check __kasan_krealloc(con
 {
 	struct slab *slab;
 
+	if (gfpflags_allow_blocking(flags))
+		kasan_quarantine_reduce();
+
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return (void *)object;
 
@@ -419,11 +424,11 @@ void * __must_check __kasan_krealloc(con
 
 	/* Piggy-back on kmalloc() instrumentation to poison the redzone. */
 	if (unlikely(!slab))
-		return __kasan_kmalloc_large(object, size, flags);
-	else {
+		poison_kmalloc_large_redzone(object, size, flags);
+	else
 		poison_kmalloc_redzone(slab->slab_cache, object, size, flags);
-		return (void *)object;
-	}
+
+	return (void *)object;
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

