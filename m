Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FDF188596
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855641; cv=none; b=ZmIRx36863r0WjF6vNUWcLnj269ZqP33elZeLjH9Rpc3p1TxuCG12jbnI6d9bdipYaOsKkZ+rH6yMfhH/58F7IAM2o5334LCEFG73+locfPBI+aOymD2KaWG6YKz6Pi7fhVqAYwTFazWmj9ijwByr3QX/+RUppyPRYsprXlVrDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855641; c=relaxed/simple;
	bh=MprbMXC7OKTRaIT/Q+6oKZkCOZPpva6b3Ud2EAGV7s8=;
	h=Date:To:From:Subject:Message-Id; b=g4LpVmtGOtoAKEPICxdtnijh8z1+scgP/lHPXPj12fvPE0fmD71co+v+Cc83nX+5AlblnWo1xliuIS9pcpY9HtJMuoyiRtNAXcUgXzSaSUqsaOzyXmsC5NkXp+geebg09/p6yqG7OeetcbabBeynQjshfLmOO7a7aTZi7Aw9Lbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x0/xFZ/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x0/xFZ/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9461C4CECF;
	Wed,  6 Nov 2024 01:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855641;
	bh=MprbMXC7OKTRaIT/Q+6oKZkCOZPpva6b3Ud2EAGV7s8=;
	h=Date:To:From:Subject:From;
	b=x0/xFZ/uaLcxhoDQRNjZCfB/qDxDzTOZ341XKbELdeM3b6DZBDX2CG5y0v2pr7eSq
	 UxF8OmaajJowvF8qTPz74kv/SvUn08z/2FqrfvaaVkEzJUWQliYu889rxgy8S5mqXc
	 E0zrHEhkV+Nh8TmsAEhaSmKKHnYjydmQijAeY2kU=
Date: Tue, 05 Nov 2024 17:14:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-optimize-min-heap-by-prescaling-counters-for-better-performance.patch removed from -mm tree
Message-Id: <20241106011401.A9461C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: optimize min heap by prescaling counters for better performance
has been removed from the -mm tree.  Its filename was
     lib-min_heap-optimize-min-heap-by-prescaling-counters-for-better-performance.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: optimize min heap by prescaling counters for better performance
Date: Sun, 20 Oct 2024 12:01:52 +0800

Improve the efficiency of the min heap by prescaling counters, eliminating
the need to repeatedly compute 'index * element_size' when accessing
elements.  By doing so, we avoid the overhead associated with
recalculating the byte offset for each heap operation.

However, with prescaling, the calculation for the parent element's
location is no longer as simple as '(i - 1) / 2'.  To address this, we
copy the parent function from 'lib/sort.c', which calculates the parent
offset in a branchless manner without using any division instructions.

This optimization should result in a more efficient heap implementation by
reducing the computational overhead of finding parent and child offsets.

Link: https://lkml.kernel.org/r/20241020040200.939973-3-visitorckw@gmail.com
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

 include/linux/min_heap.h |   73 ++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 24 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-optimize-min-heap-by-prescaling-counters-for-better-performance
+++ a/include/linux/min_heap.h
@@ -38,6 +38,32 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs, void *args);
 };
 
+/**
+ * parent - given the offset of the child, find the offset of the parent.
+ * @i: the offset of the heap element whose parent is sought.  Non-zero.
+ * @lsbit: a precomputed 1-bit mask, equal to "size & -size"
+ * @size: size of each element
+ *
+ * In terms of array indexes, the parent of element j = @i/@size is simply
+ * (j-1)/2.  But when working in byte offsets, we can't use implicit
+ * truncation of integer divides.
+ *
+ * Fortunately, we only need one bit of the quotient, not the full divide.
+ * @size has a least significant bit.  That bit will be clear if @i is
+ * an even multiple of @size, and set if it's an odd multiple.
+ *
+ * Logically, we're doing "if (i & lsbit) i -= size;", but since the
+ * branch is unpredictable, it's done with a bit of clever branch-free
+ * code instead.
+ */
+__attribute_const__ __always_inline
+static size_t parent(size_t i, unsigned int lsbit, size_t size)
+{
+	i -= size;
+	i -= size & -(i & lsbit);
+	return i / 2;
+}
+
 /* Initialize a min-heap. */
 static __always_inline
 void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
@@ -78,33 +104,30 @@ static __always_inline
 void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
 				 const struct min_heap_callbacks *func, void *args)
 {
-	void *left, *right;
+	const unsigned long lsbit = elem_size & -elem_size;
 	void *data = heap->data;
-	void *root = data + pos * elem_size;
-	int i = pos, j;
+	/* pre-scale counters for performance */
+	size_t a = pos * elem_size;
+	size_t b, c, d;
+	size_t n = heap->nr * elem_size;
 
 	/* Find the sift-down path all the way to the leaves. */
-	for (;;) {
-		if (i * 2 + 2 >= heap->nr)
-			break;
-		left = data + (i * 2 + 1) * elem_size;
-		right = data + (i * 2 + 2) * elem_size;
-		i = func->less(left, right, args) ? i * 2 + 1 : i * 2 + 2;
-	}
+	for (b = a; c = 2 * b + elem_size, (d = c + elem_size) < n;)
+		b = func->less(data + c, data + d, args) ? c : d;
 
 	/* Special case for the last leaf with no sibling. */
-	if (i * 2 + 2 == heap->nr)
-		i = i * 2 + 1;
+	if (d == n)
+		b = c;
 
 	/* Backtrack to the correct location. */
-	while (i != pos && func->less(root, data + i * elem_size, args))
-		i = (i - 1) / 2;
+	while (b != a && func->less(data + a, data + b, args))
+		b = parent(b, lsbit, elem_size);
 
 	/* Shift the element into its correct place. */
-	j = i;
-	while (i != pos) {
-		i = (i - 1) / 2;
-		func->swp(data + i * elem_size, data + j * elem_size, args);
+	c = b;
+	while (b != a) {
+		b = parent(b, lsbit, elem_size);
+		func->swp(data + b, data + c, args);
 	}
 }
 
@@ -117,15 +140,17 @@ static __always_inline
 void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx,
 			       const struct min_heap_callbacks *func, void *args)
 {
+	const unsigned long lsbit = elem_size & -elem_size;
 	void *data = heap->data;
-	size_t parent;
+	/* pre-scale counters for performance */
+	size_t a = idx * elem_size, b;
 
-	while (idx) {
-		parent = (idx - 1) / 2;
-		if (func->less(data + parent * elem_size, data + idx * elem_size, args))
+	while (a) {
+		b = parent(a, lsbit, elem_size);
+		if (func->less(data + b, data + a, args))
 			break;
-		func->swp(data + parent * elem_size, data + idx * elem_size, args);
-		idx = parent;
+		func->swp(data + a, data + b, args);
+		a = b;
 	}
 }
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are


