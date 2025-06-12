Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A92D770FE
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 01:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693451; cv=none; b=oxN6nXly6SEFcbuQbS49IlOekb9unA62lg03LB4IhwawJRjqPU5ZzzlqTH0gdk59p6s3Yicfg2d5kv/v5SZ43mxEsaR5Jzb1rMlZ7+PCHducs+py+7yYF9pmZikbiUHuFt23aKHPUWlaZlW7vWQcpP1tNblixtf2YFEjOIq0I+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693451; c=relaxed/simple;
	bh=qNwCkBH3vpio5Je41I1Bsqs06jzybby5KVcIHF4gIcQ=;
	h=Date:To:From:Subject:Message-Id; b=EQ0uTjw8E7YD0wxHnqyhWjbzP09ZkjUKgSZQxz4/5lM8njM7jfVBgAdPfBU/Tihk8OcuV1cCz7rmCTuCrxdudqwt8oVQh1QuZcZHOHoYqCQsLmLAxfZW7dOb7aohfH3viPoJQhtrC/EKbr58z07rXoFHthfklkiQpjDlF3HG6uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oap7oisK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oap7oisK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B569C4CEE3;
	Thu, 12 Jun 2025 01:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749693451;
	bh=qNwCkBH3vpio5Je41I1Bsqs06jzybby5KVcIHF4gIcQ=;
	h=Date:To:From:Subject:From;
	b=oap7oisKah8bSUFCf5FtfUlIfywtpdtYFyhABgigvDQc+InHMcpRPyk6QOGoYglMb
	 /97he7CfMbgUHkPgoOa+VfteRKs8djo9btYJr5EIshirIrRZZdvRFETuzKIDSF/X6F
	 z6w32zZheadFgdEvboSZP3N2k7L+N3ddH57dG6jI=
Date: Wed, 11 Jun 2025 18:57:30 -0700
To: mm-commits@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,corbet@lwn.net,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-add-eqaware-variant-of-min_heap_del.patch added to mm-nonmm-unstable branch
Message-Id: <20250612015731.5B569C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: add eqaware variant of min_heap_del()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-add-eqaware-variant-of-min_heap_del.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-add-eqaware-variant-of-min_heap_del.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add eqaware variant of min_heap_del()
Date: Wed, 11 Jun 2025 05:55:14 +0800

Introduce min_heap_del_eqaware() as a variant of min_heap_del() that uses
the equality-aware version of sift_down, which is implemented in a
top-down manner.

This top-down sift_down reduces the number of comparisons from O(log2(n))
to O(1) in cases where many elements have equal priority.  It enables more
efficient heap construction when the heap contains a large number of equal
elements.

Link: https://lkml.kernel.org/r/20250610215516.1513296-7-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Robert Pang <robertpang@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   19 ++++++++++++++-----
 lib/min_heap.c           |    4 ++--
 2 files changed, 16 insertions(+), 7 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-add-eqaware-variant-of-min_heap_del
+++ a/include/linux/min_heap.h
@@ -470,10 +470,12 @@ bool __min_heap_push_inline(min_heap_cha
 /* Remove ith element from the heap, O(log2(nr)). */
 static __always_inline
 bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
-			   const struct min_heap_callbacks *func, void *args)
+			   const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
 	void *data = heap->data;
 	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
+	siftdown_fn_t sift_down = eqaware ? __min_heap_sift_down_eqaware_inline :
+					    __min_heap_sift_down_inline;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
 		return false;
@@ -487,14 +489,18 @@ bool __min_heap_del_inline(min_heap_char
 		return true;
 	do_swap(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size, swp, args);
 	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
-	__min_heap_sift_down_inline(heap, idx, elem_size, func, args);
+	sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
 
 #define min_heap_del_inline(_heap, _idx, _func, _args)	\
 	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
-			      __minheap_obj_size(_heap), _idx, _func, _args)
+			      __minheap_obj_size(_heap), _idx, _func, _args, false)
+
+#define min_heap_del_eqaware_inline(_heap, _idx, _func, _args)	\
+	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
+			      __minheap_obj_size(_heap), _idx, _func, _args, true)
 
 void __min_heap_init(min_heap_char *heap, void *data, size_t size);
 void *__min_heap_peek(struct min_heap_char *heap);
@@ -514,7 +520,7 @@ void __min_heap_pop_push(min_heap_char *
 bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		     const struct min_heap_callbacks *func, void *args);
 bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
-		    const struct min_heap_callbacks *func, void *args);
+		    const struct min_heap_callbacks *func, void *args, bool eqaware);
 
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init(container_of(&(_heap)->nr, min_heap_char, nr), _data, _size)
@@ -554,6 +560,9 @@ bool __min_heap_del(min_heap_char *heap,
 			__minheap_obj_size(_heap), _func, _args)
 #define min_heap_del(_heap, _idx, _func, _args)	\
 	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
-		       __minheap_obj_size(_heap), _idx, _func, _args)
+		       __minheap_obj_size(_heap), _idx, _func, _args, false)
+#define min_heap_del_eqaware(_heap, _idx, _func, _args)	\
+	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
+		       __minheap_obj_size(_heap), _idx, _func, _args, true)
 
 #endif /* _LINUX_MIN_HEAP_H */
--- a/lib/min_heap.c~lib-min_heap-add-eqaware-variant-of-min_heap_del
+++ a/lib/min_heap.c
@@ -70,8 +70,8 @@ bool __min_heap_push(min_heap_char *heap
 EXPORT_SYMBOL(__min_heap_push);
 
 bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
-		    const struct min_heap_callbacks *func, void *args)
+		    const struct min_heap_callbacks *func, void *args, bool eqaware)
 {
-	return __min_heap_del_inline(heap, elem_size, idx, func, args);
+	return __min_heap_del_inline(heap, elem_size, idx, func, args, eqaware);
 }
 EXPORT_SYMBOL(__min_heap_del);
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch
lib-min_heap-add-equal-elements-aware-sift_down-variant.patch
lib-min_heap-add-typedef-for-sift_down-function-pointer.patch
lib-min_heap-add-eqaware-variant-of-min_heapify_all.patch
lib-min_heap-add-eqaware-variant-of-min_heap_pop.patch
lib-min_heap-add-eqaware-variant-of-min_heap_pop_push.patch
lib-min_heap-add-eqaware-variant-of-min_heap_del.patch
documentation-core-api-min_heap-document-_eqaware-variants-of-min-heap-apis.patch
bcache-fix-the-tail-io-latency-regression-by-using-equality-aware-min-heap-api.patch

