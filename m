Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A7D13AC4
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G6HaTWEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1F1C433C8;
	Fri, 29 Dec 2023 20:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880039;
	bh=8vCBPP0vPrzkP61PakUlnXY+FuTqiboNUBtY+8hAeM4=;
	h=Date:To:From:Subject:From;
	b=G6HaTWEb6GHf+MrfxhX+ex5jgEVCleIcOhCByVbb2JRSlFXlSpEPneCpYA6MpjYbt
	 jTStsUGe7WrIxSVqMP6Odu6horQDjGb+9La84UhE+AqcuzmKbD2cWo4ceH88JQ3HLo
	 37+8bzpNXFHVqfaDpeVyLQvCSLg/MShhFd013D0o=
Date: Fri, 29 Dec 2023 12:00:38 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-introduce-kasan_mempool_poison_pages.patch removed from -mm tree
Message-Id: <20231229200039.3D1F1C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: introduce kasan_mempool_poison_pages
has been removed from the -mm tree.  Its filename was
     kasan-introduce-kasan_mempool_poison_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kasan-stop-leaking-stack-trace-handles.patch

