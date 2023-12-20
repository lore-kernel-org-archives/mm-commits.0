Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51816EBE
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y00TI5jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB06C433C7;
	Wed, 20 Dec 2023 00:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703030735;
	bh=TtnKeej6+ue3BDnx6jL4t96CScrctc4fJtOzBV7ceZg=;
	h=Date:To:From:Subject:From;
	b=y00TI5jGC+Y4Gq1hoCR6RzKHEekPRiZAit6lSXVZOYvHvKrV6yYLT3xoqmgvr5Elv
	 QzHQQckJ7Fn21pHXGuhu2WbC2BRJrlo4fOnKatvYkLbzh0F4mqth1Wncnhy3iT1ed/
	 ONhv2emhYb6x8cJRpF5/4uRa16mc9S3u6yBcHvJw=
Date: Tue, 19 Dec 2023 16:05:35 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-introduce-kasan_mempool_poison_pages.patch added to mm-unstable branch
Message-Id: <20231220000535.AFB06C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: introduce kasan_mempool_poison_pages
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-introduce-kasan_mempool_poison_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-introduce-kasan_mempool_poison_pages.patch

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
Subject: kasan: introduce kasan_mempool_poison_pages
Date: Tue, 19 Dec 2023 23:28:50 +0100

Introduce and document a kasan_mempool_poison_pages hook to be used by the
mempool code instead of kasan_poison_pages.

Compated to kasan_poison_pages, the new hook:

1. For the tag-based modes, skips checking and poisoning allocations that
   were not tagged due to sampling.

2. Checks for double-free and invalid-free bugs.

In the future, kasan_poison_pages can also be updated to handle #2, but
this is out-of-scope of this series.

Link: https://lkml.kernel.org/r/88dc7340cce28249abf789f6e0c792c317df9ba5.1703024586.git.andreyknvl@google.com
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

 include/linux/kasan.h |   27 +++++++++++++++++++++++++++
 mm/kasan/common.c     |   23 +++++++++++++++++++++++
 2 files changed, 50 insertions(+)

--- a/include/linux/kasan.h~kasan-introduce-kasan_mempool_poison_pages
+++ a/include/linux/kasan.h
@@ -212,6 +212,29 @@ static __always_inline void * __must_che
 	return (void *)object;
 }
 
+bool __kasan_mempool_poison_pages(struct page *page, unsigned int order,
+				  unsigned long ip);
+/**
+ * kasan_mempool_poison_pages - Check and poison a mempool page allocation.
+ * @page: Pointer to the page allocation.
+ * @order: Order of the allocation.
+ *
+ * This function is intended for kernel subsystems that cache page allocations
+ * to reuse them instead of freeing them back to page_alloc (e.g. mempool).
+ *
+ * This function is similar to kasan_mempool_poison_object() but operates on
+ * page allocations.
+ *
+ * Return: true if the allocation can be safely reused; false otherwise.
+ */
+static __always_inline bool kasan_mempool_poison_pages(struct page *page,
+						       unsigned int order)
+{
+	if (kasan_enabled())
+		return __kasan_mempool_poison_pages(page, order, _RET_IP_);
+	return true;
+}
+
 bool __kasan_mempool_poison_object(void *ptr, unsigned long ip);
 /**
  * kasan_mempool_poison_object - Check and poison a mempool slab allocation.
@@ -326,6 +349,10 @@ static inline void *kasan_krealloc(const
 {
 	return (void *)object;
 }
+static inline bool kasan_mempool_poison_pages(struct page *page, unsigned int order)
+{
+	return true;
+}
 static inline bool kasan_mempool_poison_object(void *ptr)
 {
 	return true;
--- a/mm/kasan/common.c~kasan-introduce-kasan_mempool_poison_pages
+++ a/mm/kasan/common.c
@@ -426,6 +426,29 @@ void * __must_check __kasan_krealloc(con
 		return ____kasan_kmalloc(slab->slab_cache, object, size, flags);
 }
 
+bool __kasan_mempool_poison_pages(struct page *page, unsigned int order,
+				  unsigned long ip)
+{
+	unsigned long *ptr;
+
+	if (unlikely(PageHighMem(page)))
+		return true;
+
+	/* Bail out if allocation was excluded due to sampling. */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
+	    page_kasan_tag(page) == KASAN_TAG_KERNEL)
+		return true;
+
+	ptr = page_address(page);
+
+	if (check_page_allocation(ptr, ip))
+		return false;
+
+	kasan_poison(ptr, PAGE_SIZE << order, KASAN_PAGE_FREE, false);
+
+	return true;
+}
+
 bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 {
 	struct folio *folio;
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

