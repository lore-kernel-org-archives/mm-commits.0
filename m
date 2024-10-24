Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07B3446A1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739421; cv=none; b=bHSP2DAut79vTZRLDuZnnWj5KZmzkKngg4FXMFqNt3j2eNKFYH7J4EHbGGTuxVB0C/vnfiu+B6iBYtwr/4JeIdz8WBLk2z6tG4A2qRKC6Tt2j7J0cCZNj6zRAuro+04WeNep/Fj/F45H+m/AD+JzNhEqlEzRQI26iBduFTzLrj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739421; c=relaxed/simple;
	bh=y2Kn9tLTXRYap7R13Zye1Qc0Qf+5MC6OwJhL7ayfGN8=;
	h=Date:To:From:Subject:Message-Id; b=TLgF6gwssi7oxg4CKpCIkEpeeEMEN8tQJxCP3Km8nn/Y9XyBbQlJugcXAoQ+qwXEWHR4zpP/x2B7jYrprHMtni+FWhGAe4DiVfUdp8hDrMzD5U/XkhULPMmRth7A1fcRWcQvY2K/vcdnRcOaJHKXHnDKYug+yHB43FYR+tzKT8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wTz2buWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wTz2buWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECBFC4CEC6;
	Thu, 24 Oct 2024 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739421;
	bh=y2Kn9tLTXRYap7R13Zye1Qc0Qf+5MC6OwJhL7ayfGN8=;
	h=Date:To:From:Subject:From;
	b=wTz2buWQ8lCb3Q4utfUinmMmN/vPedwdYq8pyEHXC3Hq5h8/gsjbyNH16p8gWEVFh
	 B9IuuhYzMqEoANqSoWNOCqRrQdDuOp8afqZ4O6FVbwMAWmwekU6EDLJ+Xica8zD+on
	 z4wUklYLpDKosjCDz9UypjpiYgruCOAbdmrCikwc=
Date: Wed, 23 Oct 2024 20:10:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,akpm@linux-foundation.org,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20241024031021.8ECBFC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/min_heap: introduce non-inline versions of min heap API functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions.patch

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
Subject: lib/min_heap: introduce non-inline versions of min heap API functions
Date: Sun, 20 Oct 2024 12:01:51 +0800

Patch series "Enhance min heap API with non-inline functions and
optimizations", v2.

Add non-inline versions of the min heap API functions in lib/min_heap.c
and updates all users outside of kernel/events/core.c to use these
non-inline versions.  To mitigate the performance impact of indirect
function calls caused by the non-inline versions of the swap and compare
functions, a builtin swap has been introduced that swaps elements based on
their size.  Additionally, it micro-optimizes the efficiency of the min
heap by pre-scaling the counter, following the same approach as in
lib/sort.c.  Documentation for the min heap API has also been added to the
core-api section.


This patch (of 10):

All current min heap API functions are marked with '__always_inline'. 
However, as the number of users increases, inlining these functions
everywhere leads to a increase in kernel size.

In performance-critical paths, such as when perf events are enabled and
min heap functions are called on every context switch, it is important to
retain the inline versions for optimal performance.  To balance this, the
original inline functions are kept, and additional non-inline versions of
the functions have been added in lib/min_heap.c.

Link: https://lkml.kernel.org/r/20241020040200.939973-1-visitorckw@gmail.com
Link: https://lore.kernel.org/20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org
Link: https://lkml.kernel.org/r/20241020040200.939973-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/Kconfig |    1 
 drivers/md/dm-vdo/Kconfig |    1 
 fs/bcachefs/Kconfig       |    1 
 include/linux/min_heap.h  |  129 ++++++++++++++++++++++++------------
 kernel/events/core.c      |    6 -
 lib/Kconfig               |    3 
 lib/Kconfig.debug         |    1 
 lib/Makefile              |    1 
 lib/min_heap.c            |   70 +++++++++++++++++++
 9 files changed, 167 insertions(+), 46 deletions(-)

--- a/drivers/md/bcache/Kconfig~lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions
+++ a/drivers/md/bcache/Kconfig
@@ -5,6 +5,7 @@ config BCACHE
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select CRC64
 	select CLOSURES
+	select MIN_HEAP
 	help
 	Allows a block device to be used as cache for other devices; uses
 	a btree for indexing and the layout is optimized for SSDs.
--- a/drivers/md/dm-vdo/Kconfig~lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions
+++ a/drivers/md/dm-vdo/Kconfig
@@ -7,6 +7,7 @@ config DM_VDO
 	select DM_BUFIO
 	select LZ4_COMPRESS
 	select LZ4_DECOMPRESS
+	select MIN_HEAP
 	help
 	  This device mapper target presents a block device with
 	  deduplication, compression and thin-provisioning.
--- a/fs/bcachefs/Kconfig~lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions
+++ a/fs/bcachefs/Kconfig
@@ -24,6 +24,7 @@ config BCACHEFS_FS
 	select XXHASH
 	select SRCU
 	select SYMBOLIC_ERRNAME
+	select MIN_HEAP
 	help
 	The bcachefs filesystem - a modern, copy on write filesystem, with
 	support for multiple devices, compression, checksumming, etc.
--- a/include/linux/min_heap.h~lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions
+++ a/include/linux/min_heap.h
@@ -40,7 +40,7 @@ struct min_heap_callbacks {
 
 /* Initialize a min-heap. */
 static __always_inline
-void __min_heap_init(min_heap_char *heap, void *data, int size)
+void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
 {
 	heap->nr = 0;
 	heap->size = size;
@@ -50,33 +50,33 @@ void __min_heap_init(min_heap_char *heap
 		heap->data = heap->preallocated;
 }
 
-#define min_heap_init(_heap, _data, _size)	\
-	__min_heap_init((min_heap_char *)_heap, _data, _size)
+#define min_heap_init_inline(_heap, _data, _size)	\
+	__min_heap_init_inline((min_heap_char *)_heap, _data, _size)
 
 /* Get the minimum element from the heap. */
 static __always_inline
-void *__min_heap_peek(struct min_heap_char *heap)
+void *__min_heap_peek_inline(struct min_heap_char *heap)
 {
 	return heap->nr ? heap->data : NULL;
 }
 
-#define min_heap_peek(_heap)	\
-	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+#define min_heap_peek_inline(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek_inline((min_heap_char *)_heap))
 
 /* Check if the heap is full. */
 static __always_inline
-bool __min_heap_full(min_heap_char *heap)
+bool __min_heap_full_inline(min_heap_char *heap)
 {
 	return heap->nr == heap->size;
 }
 
-#define min_heap_full(_heap)	\
-	__min_heap_full((min_heap_char *)_heap)
+#define min_heap_full_inline(_heap)	\
+	__min_heap_full_inline((min_heap_char *)_heap)
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
-		const struct min_heap_callbacks *func, void *args)
+void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t elem_size,
+				 const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
 	void *data = heap->data;
@@ -108,13 +108,14 @@ void __min_heap_sift_down(min_heap_char
 	}
 }
 
-#define min_heap_sift_down(_heap, _pos, _func, _args)	\
-	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down_inline(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down_inline((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap),	\
+				    _func, _args)
 
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
-		const struct min_heap_callbacks *func, void *args)
+void __min_heap_sift_up_inline(min_heap_char *heap, size_t elem_size, size_t idx,
+			       const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 	size_t parent;
@@ -128,27 +129,28 @@ void __min_heap_sift_up(min_heap_char *h
 	}
 }
 
-#define min_heap_sift_up(_heap, _idx, _func, _args)	\
-	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+#define min_heap_sift_up_inline(_heap, _idx, _func, _args)	\
+	__min_heap_sift_up_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx,	\
+				  _func, _args)
 
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
-void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		const struct min_heap_callbacks *func, void *args)
+void __min_heapify_all_inline(min_heap_char *heap, size_t elem_size,
+			      const struct min_heap_callbacks *func, void *args)
 {
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heap_sift_down(heap, i, elem_size, func, args);
+		__min_heap_sift_down_inline(heap, i, elem_size, func, args);
 }
 
-#define min_heapify_all(_heap, _func, _args)	\
-	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+#define min_heapify_all_inline(_heap, _func, _args)	\
+	__min_heapify_all_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
-		const struct min_heap_callbacks *func, void *args)
+bool __min_heap_pop_inline(min_heap_char *heap, size_t elem_size,
+			   const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
@@ -158,13 +160,13 @@ bool __min_heap_pop(min_heap_char *heap,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heap_sift_down(heap, 0, elem_size, func, args);
+	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
 
 	return true;
 }
 
-#define min_heap_pop(_heap, _func, _args)	\
-	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_pop_inline(_heap, _func, _args)	\
+	__min_heap_pop_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
 
 /*
  * Remove the minimum element and then push the given element. The
@@ -172,22 +174,21 @@ bool __min_heap_pop(min_heap_char *heap,
  * efficient than a pop followed by a push that does 2.
  */
 static __always_inline
-void __min_heap_pop_push(min_heap_char *heap,
-		const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func,
-		void *args)
+void __min_heap_pop_push_inline(min_heap_char *heap, const void *element, size_t elem_size,
+				const struct min_heap_callbacks *func, void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heap_sift_down(heap, 0, elem_size, func, args);
+	__min_heap_sift_down_inline(heap, 0, elem_size, func, args);
 }
 
-#define min_heap_pop_push(_heap, _element, _func, _args)	\
-	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_pop_push_inline(_heap, _element, _func, _args)	\
+	__min_heap_pop_push_inline((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
+				   _func, _args)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func, void *args)
+bool __min_heap_push_inline(min_heap_char *heap, const void *element, size_t elem_size,
+			    const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 	int pos;
@@ -201,18 +202,19 @@ bool __min_heap_push(min_heap_char *heap
 	heap->nr++;
 
 	/* Sift child at pos up. */
-	__min_heap_sift_up(heap, elem_size, pos, func, args);
+	__min_heap_sift_up_inline(heap, elem_size, pos, func, args);
 
 	return true;
 }
 
-#define min_heap_push(_heap, _element, _func, _args)	\
-	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_push_inline(_heap, _element, _func, _args)	\
+	__min_heap_push_inline((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
+			       _func, _args)
 
 /* Remove ith element from the heap, O(log2(nr)). */
 static __always_inline
-bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
-		const struct min_heap_callbacks *func, void *args)
+bool __min_heap_del_inline(min_heap_char *heap, size_t elem_size, size_t idx,
+			   const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
@@ -224,12 +226,53 @@ bool __min_heap_del(min_heap_char *heap,
 	if (idx == heap->nr)
 		return true;
 	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
-	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heap_sift_down(heap, idx, elem_size, func, args);
+	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
+	__min_heap_sift_down_inline(heap, idx, elem_size, func, args);
 
 	return true;
 }
 
+#define min_heap_del_inline(_heap, _idx, _func, _args)	\
+	__min_heap_del_inline((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx,	\
+			      _func, _args)
+
+void __min_heap_init(min_heap_char *heap, void *data, int size);
+void *__min_heap_peek(struct min_heap_char *heap);
+bool __min_heap_full(min_heap_char *heap);
+void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
+			  const struct min_heap_callbacks *func, void *args);
+void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
+			const struct min_heap_callbacks *func, void *args);
+void __min_heapify_all(min_heap_char *heap, size_t elem_size,
+		       const struct min_heap_callbacks *func, void *args);
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
+		    const struct min_heap_callbacks *func, void *args);
+void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
+			 const struct min_heap_callbacks *func, void *args);
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+		     const struct min_heap_callbacks *func, void *args);
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		    const struct min_heap_callbacks *func, void *args);
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init((min_heap_char *)_heap, _data, _size)
+#define min_heap_peek(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+#define min_heap_full(_heap)	\
+	__min_heap_full((min_heap_char *)_heap)
+#define min_heap_sift_down(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_up(_heap, _idx, _func, _args)	\
+	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+#define min_heapify_all(_heap, _func, _args)	\
+	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_pop(_heap, _func, _args)	\
+	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_pop_push(_heap, _element, _func, _args)	\
+	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap),	\
+			    _func, _args)
+#define min_heap_push(_heap, _element, _func, _args)	\
+	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 #define min_heap_del(_heap, _idx, _func, _args)	\
 	__min_heap_del((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
 
--- a/kernel/events/core.c~lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions
+++ a/kernel/events/core.c
@@ -3870,7 +3870,7 @@ static noinline int visit_groups_merge(s
 		perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
 	}
 
-	min_heapify_all(&event_heap, &perf_min_heap, NULL);
+	min_heapify_all_inline(&event_heap, &perf_min_heap, NULL);
 
 	while (event_heap.nr) {
 		ret = func(*evt, data);
@@ -3879,9 +3879,9 @@ static noinline int visit_groups_merge(s
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down_inline(&event_heap, 0, &perf_min_heap, NULL);
 		else
-			min_heap_pop(&event_heap, &perf_min_heap, NULL);
+			min_heap_pop_inline(&event_heap, &perf_min_heap, NULL);
 	}
 
 	return 0;
--- a/lib/Kconfig~lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions
+++ a/lib/Kconfig
@@ -780,3 +780,6 @@ config FIRMWARE_TABLE
 
 config UNION_FIND
 	bool
+
+config MIN_HEAP
+	bool
--- a/lib/Kconfig.debug~lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions
+++ a/lib/Kconfig.debug
@@ -2279,6 +2279,7 @@ config TEST_LIST_SORT
 config TEST_MIN_HEAP
 	tristate "Min heap test"
 	depends on DEBUG_KERNEL || m
+	select MIN_HEAP
 	help
 	  Enable this to turn on min heap function tests. This test is
 	  executed only once during system boot (so affects only boot time),
--- a/lib/Makefile~lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions
+++ a/lib/Makefile
@@ -40,6 +40,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 lib-$(CONFIG_UNION_FIND) += union_find.o
 lib-$(CONFIG_PRINTK) += dump_stack.o
 lib-$(CONFIG_SMP) += cpumask.o
+lib-$(CONFIG_MIN_HEAP) += min_heap.o
 
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
diff --git a/lib/min_heap.c a/lib/min_heap.c
new file mode 100644
--- /dev/null
+++ a/lib/min_heap.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/export.h>
+#include <linux/min_heap.h>
+
+void __min_heap_init(min_heap_char *heap, void *data, int size)
+{
+	__min_heap_init_inline(heap, data, size);
+}
+EXPORT_SYMBOL(__min_heap_init);
+
+void *__min_heap_peek(struct min_heap_char *heap)
+{
+	return __min_heap_peek_inline(heap);
+}
+EXPORT_SYMBOL(__min_heap_peek);
+
+bool __min_heap_full(min_heap_char *heap)
+{
+	return __min_heap_full_inline(heap);
+}
+EXPORT_SYMBOL(__min_heap_full);
+
+void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
+			  const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_sift_down_inline(heap, pos, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_sift_down);
+
+void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
+			const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_sift_up_inline(heap, elem_size, idx, func, args);
+}
+EXPORT_SYMBOL(__min_heap_sift_up);
+
+void __min_heapify_all(min_heap_char *heap, size_t elem_size,
+		       const struct min_heap_callbacks *func, void *args)
+{
+	__min_heapify_all_inline(heap, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heapify_all);
+
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
+		    const struct min_heap_callbacks *func, void *args)
+{
+	return __min_heap_pop_inline(heap, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_pop);
+
+void __min_heap_pop_push(min_heap_char *heap, const void *element, size_t elem_size,
+			 const struct min_heap_callbacks *func, void *args)
+{
+	__min_heap_pop_push_inline(heap, element, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_pop_push);
+
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+		     const struct min_heap_callbacks *func, void *args)
+{
+	return __min_heap_push_inline(heap, element, elem_size, func, args);
+}
+EXPORT_SYMBOL(__min_heap_push);
+
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		    const struct min_heap_callbacks *func, void *args)
+{
+	return __min_heap_del_inline(heap, elem_size, idx, func, args);
+}
+EXPORT_SYMBOL(__min_heap_del);
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

