Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AAA446A1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739430; cv=none; b=b3RlC1eN3jOOU9MbRw0PDKiGtWlIABp3amBnDMznG9WpS/noB1G3vpvX2/lDUdyqZhL/emnUdNd7PgVmGG1kBF2yT8nAPEXYBaUoFDoBoHDH/gs4+xIdNrvCk5cmguFxCFBvc7Oak7GdjU0uZ+NdkZTZuVGlVs4y3QPADSoqZnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739430; c=relaxed/simple;
	bh=pV5ipewHvFvyDALnRyvIXcTgQ9s3ldwpuFP9hRz7JgU=;
	h=Date:To:From:Subject:Message-Id; b=jCM+URnTHJbQvS9lpOhUCepnhxxrm6ohYbZwW2PJxqR/qhkbdLq537cgIVgrK8DPQpMP1kirodu7MLlsh8H3NfOGxSjU7B9lzppYMX7852HxXdPLBeSCt4Nh8hEbxyT9HdZwZc5uQ2zd3kW8z70rBz0jxUwO4T+tmkpwRtKNwzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kE5eRI6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kE5eRI6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A0DC4CEC6;
	Thu, 24 Oct 2024 03:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739429;
	bh=pV5ipewHvFvyDALnRyvIXcTgQ9s3ldwpuFP9hRz7JgU=;
	h=Date:To:From:Subject:From;
	b=kE5eRI6me7/3bhtR2U7CmAPr/ua7C4aQnXvYpZiia2U3seW87V8GJ86fkfZBZhSBs
	 Ua1EOefJq2xrMcQOR9Lu+PpaMVK83q51bJgH/YZ2t0Bc6XWUNyVeuvzumXML9TVvCQ
	 ByVzB1nuvHOk6vu5LGGObcm5tPIcrv2JsMhWoLj4=
Date: Wed, 23 Oct 2024 20:10:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-avoid-indirect-function-call-by-providing-default-swap.patch added to mm-nonmm-unstable branch
Message-Id: <20241024031029.95A0DC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: avoid indirect function call by providing default swap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-avoid-indirect-function-call-by-providing-default-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-avoid-indirect-function-call-by-providing-default-swap.patch

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
Subject: lib min_heap: avoid indirect function call by providing default swap
Date: Sun, 20 Oct 2024 12:01:53 +0800

The non-inline min heap API can result in an indirect function call to the
custom swap function.  This becomes particularly costly when
CONFIG_MITIGATION_RETPOLINE is enabled, as indirect function calls are
expensive in this case.

To address this, copy the code from lib/sort.c and provide a default
builtin swap implementation that performs element swaps based on the
element size.  This change allows most users to avoid the overhead of
indirect function calls, improving efficiency.

Link: https://lkml.kernel.org/r/20241020040200.939973-4-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |  159 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 156 insertions(+), 3 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-avoid-indirect-function-call-by-providing-default-swap
+++ a/include/linux/min_heap.h
@@ -39,6 +39,147 @@ struct min_heap_callbacks {
 };
 
 /**
+ * is_aligned - is this pointer & size okay for word-wide copying?
+ * @base: pointer to data
+ * @size: size of each element
+ * @align: required alignment (typically 4 or 8)
+ *
+ * Returns true if elements can be copied using word loads and stores.
+ * The size must be a multiple of the alignment, and the base address must
+ * be if we do not have CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.
+ *
+ * For some reason, gcc doesn't know to optimize "if (a & mask || b & mask)"
+ * to "if ((a | b) & mask)", so we do that by hand.
+ */
+__attribute_const__ __always_inline
+static bool is_aligned(const void *base, size_t size, unsigned char align)
+{
+	unsigned char lsbits = (unsigned char)size;
+
+	(void)base;
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	lsbits |= (unsigned char)(uintptr_t)base;
+#endif
+	return (lsbits & (align - 1)) == 0;
+}
+
+/**
+ * swap_words_32 - swap two elements in 32-bit chunks
+ * @a: pointer to the first element to swap
+ * @b: pointer to the second element to swap
+ * @n: element size (must be a multiple of 4)
+ *
+ * Exchange the two objects in memory.  This exploits base+index addressing,
+ * which basically all CPUs have, to minimize loop overhead computations.
+ *
+ * For some reason, on x86 gcc 7.3.0 adds a redundant test of n at the
+ * bottom of the loop, even though the zero flag is still valid from the
+ * subtract (since the intervening mov instructions don't alter the flags).
+ * Gcc 8.1.0 doesn't have that problem.
+ */
+static __always_inline
+void swap_words_32(void *a, void *b, size_t n)
+{
+	do {
+		u32 t = *(u32 *)(a + (n -= 4));
+		*(u32 *)(a + n) = *(u32 *)(b + n);
+		*(u32 *)(b + n) = t;
+	} while (n);
+}
+
+/**
+ * swap_words_64 - swap two elements in 64-bit chunks
+ * @a: pointer to the first element to swap
+ * @b: pointer to the second element to swap
+ * @n: element size (must be a multiple of 8)
+ *
+ * Exchange the two objects in memory.  This exploits base+index
+ * addressing, which basically all CPUs have, to minimize loop overhead
+ * computations.
+ *
+ * We'd like to use 64-bit loads if possible.  If they're not, emulating
+ * one requires base+index+4 addressing which x86 has but most other
+ * processors do not.  If CONFIG_64BIT, we definitely have 64-bit loads,
+ * but it's possible to have 64-bit loads without 64-bit pointers (e.g.
+ * x32 ABI).  Are there any cases the kernel needs to worry about?
+ */
+static __always_inline
+void swap_words_64(void *a, void *b, size_t n)
+{
+	do {
+#ifdef CONFIG_64BIT
+		u64 t = *(u64 *)(a + (n -= 8));
+		*(u64 *)(a + n) = *(u64 *)(b + n);
+		*(u64 *)(b + n) = t;
+#else
+		/* Use two 32-bit transfers to avoid base+index+4 addressing */
+		u32 t = *(u32 *)(a + (n -= 4));
+		*(u32 *)(a + n) = *(u32 *)(b + n);
+		*(u32 *)(b + n) = t;
+
+		t = *(u32 *)(a + (n -= 4));
+		*(u32 *)(a + n) = *(u32 *)(b + n);
+		*(u32 *)(b + n) = t;
+#endif
+	} while (n);
+}
+
+/**
+ * swap_bytes - swap two elements a byte at a time
+ * @a: pointer to the first element to swap
+ * @b: pointer to the second element to swap
+ * @n: element size
+ *
+ * This is the fallback if alignment doesn't allow using larger chunks.
+ */
+static __always_inline
+void swap_bytes(void *a, void *b, size_t n)
+{
+	do {
+		char t = ((char *)a)[--n];
+		((char *)a)[n] = ((char *)b)[n];
+		((char *)b)[n] = t;
+	} while (n);
+}
+
+/*
+ * The values are arbitrary as long as they can't be confused with
+ * a pointer, but small integers make for the smallest compare
+ * instructions.
+ */
+#define SWAP_WORDS_64 ((void (*)(void *, void *, void *))0)
+#define SWAP_WORDS_32 ((void (*)(void *, void *, void *))1)
+#define SWAP_BYTES    ((void (*)(void *, void *, void *))2)
+
+/*
+ * Selects the appropriate swap function based on the element size.
+ */
+static __always_inline
+void *select_swap_func(const void *base, size_t size)
+{
+	if (is_aligned(base, size, 8))
+		return SWAP_WORDS_64;
+	else if (is_aligned(base, size, 4))
+		return SWAP_WORDS_32;
+	else
+		return SWAP_BYTES;
+}
+
+static __always_inline
+void do_swap(void *a, void *b, size_t size, void (*swap_func)(void *lhs, void *rhs, void *args),
+	     void *priv)
+{
+	if (swap_func == SWAP_WORDS_64)
+		swap_words_64(a, b, size);
+	else if (swap_func == SWAP_WORDS_32)
+		swap_words_32(a, b, size);
+	else if (swap_func == SWAP_BYTES)
+		swap_bytes(a, b, size);
+	else
+		swap_func(a, b, priv);
+}
+
+/**
  * parent - given the offset of the child, find the offset of the parent.
  * @i: the offset of the heap element whose parent is sought.  Non-zero.
  * @lsbit: a precomputed 1-bit mask, equal to "size & -size"
@@ -106,11 +247,15 @@ void __min_heap_sift_down_inline(min_hea
 {
 	const unsigned long lsbit = elem_size & -elem_size;
 	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
 	/* pre-scale counters for performance */
 	size_t a = pos * elem_size;
 	size_t b, c, d;
 	size_t n = heap->nr * elem_size;
 
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
 	/* Find the sift-down path all the way to the leaves. */
 	for (b = a; c = 2 * b + elem_size, (d = c + elem_size) < n;)
 		b = func->less(data + c, data + d, args) ? c : d;
@@ -127,7 +272,7 @@ void __min_heap_sift_down_inline(min_hea
 	c = b;
 	while (b != a) {
 		b = parent(b, lsbit, elem_size);
-		func->swp(data + b, data + c, args);
+		do_swap(data + b, data + c, elem_size, swp, args);
 	}
 }
 
@@ -142,14 +287,18 @@ void __min_heap_sift_up_inline(min_heap_
 {
 	const unsigned long lsbit = elem_size & -elem_size;
 	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
 	/* pre-scale counters for performance */
 	size_t a = idx * elem_size, b;
 
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
 	while (a) {
 		b = parent(a, lsbit, elem_size);
 		if (func->less(data + b, data + a, args))
 			break;
-		func->swp(data + a, data + b, args);
+		do_swap(data + a, data + b, elem_size, swp, args);
 		a = b;
 	}
 }
@@ -242,15 +391,19 @@ bool __min_heap_del_inline(min_heap_char
 			   const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
+	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
 		return false;
 
+	if (!swp)
+		swp = select_swap_func(data, elem_size);
+
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	if (idx == heap->nr)
 		return true;
-	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
+	do_swap(data + (idx * elem_size), data + (heap->nr * elem_size), elem_size, swp, args);
 	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
 	__min_heap_sift_down_inline(heap, idx, elem_size, func, args);
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch
lib-list_sort-remove-unnecessary-header-includes.patch
tools-lib-list_sort-remove-unnecessary-header-includes.patch
perf-tools-update-expected-diff-for-lib-list_sortc.patch
lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions.patch
lib-min_heap-optimize-min-heap-by-prescaling-counters-for-better-performance.patch
lib-min_heap-avoid-indirect-function-call-by-providing-default-swap.patch
lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch
perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch
dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch
bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch
documentation-core-api-add-min-heap-api-introduction.patch

