Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B7A13AF3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B1IoHuPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C68BC433C9;
	Fri, 29 Dec 2023 20:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880044;
	bh=xnQfkbuVbUnLJ+GCg6ebAvwIOihbR9WVbC+phbRrwd0=;
	h=Date:To:From:Subject:From;
	b=B1IoHuPbAJlz7FCJdp/OrjFcTXzYkg7RQ6+mg/HVFpe7BCc4tPYgnMu1rG1NZEDft
	 uznZS2gxTsCpIFWLraAbJY2SYA8EDJhQHp9UQR5vCsGzqy+BriwpFpnCJdQPc+gJPi
	 YZeDKSmqiLNTfBrnD6nO1LeIogbSgmaYYsBBwAVk=
Date: Fri, 29 Dec 2023 12:00:43 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-introduce-poison_kmalloc_large_redzone.patch removed from -mm tree
Message-Id: <20231229200044.6C68BC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: introduce poison_kmalloc_large_redzone
has been removed from the -mm tree.  Its filename was
     kasan-introduce-poison_kmalloc_large_redzone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kasan-stop-leaking-stack-trace-handles.patch

