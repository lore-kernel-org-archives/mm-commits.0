Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AB314D283
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 01:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693445; cv=none; b=YJeFSEHsX23isSuD0BQ5O6okMKLICyXhnt4G23O1/7rkeNF1TYu1GI1w0dfweSluhOL6UTzurzPZT1ZpdLdek7Ct0EuCbkOQEp7VMG5SATY/R50sQbSpdAG/V8xkAzy85kZSx1anMIsCooh9v9GKImTNiNwvgEhj0URCStIlh00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693445; c=relaxed/simple;
	bh=rQAZ/xXPO4XDeTZbWQxXLd+sLwI2RYiIfYP7njonMmE=;
	h=Date:To:From:Subject:Message-Id; b=N4xtpD6YJc8pD0m+QPdQkzUbNFohtOeaQCb4NIrZRpxqzWi/ze6OThUmPYyxIlk6mf3lLT5hM1j7nGpJaohkbdhiy8bpR5Lfl4lIgP66iYdGxpEN5rzdvKTIS2ZuXUli6RjzKy/46NfxOYhZLy9auu4es/3Im66+snfxrc0BqfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SoIkilHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SoIkilHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1D8C4CEE3;
	Thu, 12 Jun 2025 01:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749693444;
	bh=rQAZ/xXPO4XDeTZbWQxXLd+sLwI2RYiIfYP7njonMmE=;
	h=Date:To:From:Subject:From;
	b=SoIkilHi+5v2PA8wmwV1J5ZjR97uRFz127YMPmElbXKP5nrgGeu7ylEsGz9cBoO1X
	 U+tVhfyDB+HJv2lFOB6FS8wwipLhkUwvRAwTHHTwCTRP4RgCDGi/vyAeydKO0Qs08z
	 +mhbZBoCXfjXw1X/yqXyqhlxw9l9nGtMSkFrrDHU=
Date: Wed, 11 Jun 2025 18:57:23 -0700
To: mm-commits@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,corbet@lwn.net,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-add-equal-elements-aware-sift_down-variant.patch added to mm-nonmm-unstable branch
Message-Id: <20250612015724.5F1D8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: add equal-elements-aware sift_down variant
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-add-equal-elements-aware-sift_down-variant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-add-equal-elements-aware-sift_down-variant.patch

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
Subject: lib min_heap: add equal-elements-aware sift_down variant
Date: Wed, 11 Jun 2025 05:55:09 +0800

Patch series "Fix bcache regression with equality-aware heap APIs".

This patch series introduces equality-aware variants of the min heap API
that use a top-down heapify strategy to improve performance when many
elements are equal under the comparison function.  It also updates the
documentation accordingly and modifies bcache to use the new APIs to fix a
performance regression caused by the switch to the generic min heap
library.

In particular, invalidate_buckets_lru() in bcache suffered from increased
comparison overhead due to the bottom-up strategy introduced in commit
866898efbb25 ("bcache: remove heap-related macros and switch to generic
min_heap").  The regression is addressed by switching to the
equality-aware variants and using the inline versions to avoid function
call overhead in this hot path.


This patch (of 8):

The existing min_heap_sift_down() uses the bottom-up heapify variant,
which reduces the number of comparisons from ~2 * log2(n) to ~1 * log2(n)
when all elements are distinct.  However, in workloads where the heap
contains many equal elements, this bottom-up variant can degenerate and
perform up to 2 * log2(n) comparisons, while the traditional top-down
variant needs only O(1) comparisons in such cases.

To address this, introduce min_heap_sift_down_eqaware(), a top-down
heapify variant optimized for scenarios with many equal elements.  This
variant avoids unnecessary comparisons and swaps when elements are already
equal or in the correct position.

Link: https://lkml.kernel.org/r/20250610215516.1513296-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20250610215516.1513296-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Robert Pang <robertpang@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   51 +++++++++++++++++++++++++++++++++++++
 lib/min_heap.c           |    7 +++++
 2 files changed, 58 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-equal-elements-aware-sift_down-variant
+++ a/include/linux/min_heap.h
@@ -292,6 +292,52 @@ void __min_heap_sift_down_inline(min_hea
 	__min_heap_sift_down_inline(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
 				    __minheap_obj_size(_heap), _func, _args)
 
+/*
+ * Sift the element at pos down the heap.
+ *
+ * Variants of heap functions using an equal-elements-aware sift_down.
+ * These may perform better when the heap contains many equal elements.
+ */
+static __always_inline
+void __min_heap_sift_down_eqaware_inline(min_heap_char * heap, size_t pos, size_t elem_size,
+					 const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
+	/* pre-scale counters for performance */
+	size_t a = pos * elem_size;
+	size_t b, c, smallest;
+	size_t n = heap->nr * elem_size;
+
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
+	for (;;) {
+		b = 2 * a + elem_size;
+		c = b + elem_size;
+		smallest = a;
+
+		if (b >= n)
+			break;
+
+		if (func->less(data + b, data + smallest, args))
+			smallest = b;
+
+		if (c < n && func->less(data + c, data + smallest, args))
+			smallest = c;
+
+		if (smallest == a)
+			break;
+
+		do_swap(data + a, data + smallest, elem_size, swp, args);
+		a = smallest;
+	}
+}
+
+#define min_heap_sift_down_eqaware_inline(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down_inline(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
+				    __minheap_obj_size(_heap), _func, _args)
+
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
 void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx,
@@ -433,6 +479,8 @@ void *__min_heap_peek(struct min_heap_ch
 bool __min_heap_full(min_heap_char *heap);
 void __min_heap_sift_down(min_heap_char *heap, size_t pos, size_t elem_size,
 			  const struct min_heap_callbacks *func, void *args);
+void __min_heap_sift_down_eqaware(min_heap_char *heap, size_t pos, size_t elem_size,
+				  const struct min_heap_callbacks *func, void *args);
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args);
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
@@ -455,6 +503,9 @@ bool __min_heap_del(min_heap_char *heap,
 #define min_heap_sift_down(_heap, _pos, _func, _args)	\
 	__min_heap_sift_down(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
 			     __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down_eqaware(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down_eqaware(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
+			     __minheap_obj_size(_heap), _func, _args)
 #define min_heap_sift_up(_heap, _idx, _func, _args)	\
 	__min_heap_sift_up(container_of(&(_heap)->nr, min_heap_char, nr),	\
 			   __minheap_obj_size(_heap), _idx, _func, _args)
--- a/lib/min_heap.c~lib-min_heap-add-equal-elements-aware-sift_down-variant
+++ a/lib/min_heap.c
@@ -27,6 +27,13 @@ void __min_heap_sift_down(min_heap_char
 }
 EXPORT_SYMBOL(__min_heap_sift_down);
 
+void __min_heap_sift_down_eqaware(min_heap_char *heap, size_t pos, size_t elem_size,
+				  const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_sift_down_eqaware_inline(heap, pos, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_sift_down_eqaware);
+
 void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
 			const struct min_heap_callbacks *func, void *args)
 {
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

