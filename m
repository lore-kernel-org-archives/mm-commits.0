Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660A233C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293166; cv=none; b=H789AxZQXW5igP4SPe8hy3bJorF3dp/b3cnUF6Bow8MDwskkCD/MXBHqeIe1zjWjJibzay04SAwBUCjvnmADqw8+OsK2n9LtrCKAHjhF9jdUkLGBGM02JIT80z2aIDOXiwkaFTu99E1Fqmr6MT1mtWxjegI9EaPxfaCHDohLLb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293166; c=relaxed/simple;
	bh=BJIs5lv5jetzAD4ORakAVwWcd/DVy57lko13iRxZYrM=;
	h=Date:To:From:Subject:Message-Id; b=Py6stVJkNu6t91xj0+5MbFJ++rrUUcc8i3XmsjM9fIfDkvHY7EDxG+q0v6nIwDSm8CwSYzgwfHYOncaXFDynXrLVHvnuG7Wl7TY5qM9tRWFiGqMI0tZXr2qoagzulKvalgH2t048fRMHiYt4f88/dNtvwY5cEea6SIr0KyQ1m7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OXHrW1lH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXHrW1lH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD95C32782;
	Tue, 25 Jun 2024 05:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293166;
	bh=BJIs5lv5jetzAD4ORakAVwWcd/DVy57lko13iRxZYrM=;
	h=Date:To:From:Subject:From;
	b=OXHrW1lHP6rgH7dAWm1jR0EruTWwVfP1KAT5CbzFSlPOJiIuOGanDodBsR6vcWkXk
	 +t3AQYarZTJ8x/6blNP3uhAJV9XLSeq+Yce6PjOhM5SPngVm0dbcaoQ+QADSw1qNYC
	 FTDCXAom0laasTOIOVXRj84OFGRcikHPR2SP2mUQ=
Date: Mon, 24 Jun 2024 22:26:05 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-add-args-for-min_heap_callbacks.patch removed from -mm tree
Message-Id: <20240625052605.EFD95C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: add args for min_heap_callbacks
has been removed from the -mm tree.  Its filename was
     lib-min_heap-add-args-for-min_heap_callbacks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add args for min_heap_callbacks
Date: Fri, 24 May 2024 23:29:50 +0800

Add a third parameter 'args' for the 'less' and 'swp' functions in the
'struct min_heap_callbacks'.  This additional parameter allows these
comparison and swap functions to handle extra arguments when necessary.

Link: https://lkml.kernel.org/r/20240524152958.919343-9-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-vdo/repair.c     |   10 +++---
 drivers/md/dm-vdo/slab-depot.c |    9 +++--
 include/linux/min_heap.h       |   51 +++++++++++++++----------------
 kernel/events/core.c           |   10 +++---
 lib/test_min_heap.c            |   26 +++++++--------
 5 files changed, 54 insertions(+), 52 deletions(-)

--- a/drivers/md/dm-vdo/repair.c~lib-min_heap-add-args-for-min_heap_callbacks
+++ a/drivers/md/dm-vdo/repair.c
@@ -137,7 +137,7 @@ struct repair_completion {
  * to sort by slot while still ensuring we replay all entries with the same slot in the exact order
  * as they appeared in the journal.
  */
-static bool mapping_is_less_than(const void *item1, const void *item2)
+static bool mapping_is_less_than(const void *item1, const void *item2, void __always_unused *args)
 {
 	const struct numbered_block_mapping *mapping1 =
 		(const struct numbered_block_mapping *) item1;
@@ -156,7 +156,7 @@ static bool mapping_is_less_than(const v
 	return 0;
 }
 
-static void swap_mappings(void *item1, void *item2)
+static void swap_mappings(void *item1, void *item2, void __always_unused *args)
 {
 	struct numbered_block_mapping *mapping1 = item1;
 	struct numbered_block_mapping *mapping2 = item2;
@@ -182,8 +182,8 @@ static struct numbered_block_mapping *so
 	 * restore the heap invariant, and return a pointer to the popped element.
 	 */
 	last = &repair->entries[--heap->nr];
-	swap_mappings(heap->data, last);
-	min_heapify(heap, 0, &repair_min_heap);
+	swap_mappings(heap->data, last, NULL);
+	min_heapify(heap, 0, &repair_min_heap, NULL);
 	return last;
 }
 
@@ -1123,7 +1123,7 @@ static void recover_block_map(struct vdo
 		.nr = repair->block_map_entry_count,
 		.size = repair->block_map_entry_count,
 	};
-	min_heapify_all(&repair->replay_heap, &repair_min_heap);
+	min_heapify_all(&repair->replay_heap, &repair_min_heap, NULL);
 
 	vdo_log_info("Replaying %zu recovery entries into block map",
 		     repair->block_map_entry_count);
--- a/drivers/md/dm-vdo/slab-depot.c~lib-min_heap-add-args-for-min_heap_callbacks
+++ a/drivers/md/dm-vdo/slab-depot.c
@@ -3288,7 +3288,8 @@ int vdo_release_block_reference(struct b
  * Thus, the ordering is reversed from the usual sense since min_heap returns smaller elements
  * before larger ones.
  */
-static bool slab_status_is_less_than(const void *item1, const void *item2)
+static bool slab_status_is_less_than(const void *item1, const void *item2,
+					void __always_unused *args)
 {
 	const struct slab_status *info1 = item1;
 	const struct slab_status *info2 = item2;
@@ -3300,7 +3301,7 @@ static bool slab_status_is_less_than(con
 	return info1->slab_number < info2->slab_number;
 }
 
-static void swap_slab_statuses(void *item1, void *item2)
+static void swap_slab_statuses(void *item1, void *item2, void __always_unused *args)
 {
 	struct slab_status *info1 = item1;
 	struct slab_status *info2 = item2;
@@ -3525,7 +3526,7 @@ static int __must_check vdo_prepare_slab
 		.nr = allocator->slab_count,
 		.size = allocator->slab_count,
 	};
-	min_heapify_all(&heap, &slab_status_min_heap);
+	min_heapify_all(&heap, &slab_status_min_heap, NULL);
 
 	while (heap.nr > 0) {
 		bool high_priority;
@@ -3533,7 +3534,7 @@ static int __must_check vdo_prepare_slab
 		struct slab_journal *journal;
 
 		current_slab_status = slab_statuses[0];
-		min_heap_pop(&heap, &slab_status_min_heap);
+		min_heap_pop(&heap, &slab_status_min_heap, NULL);
 		slab = depot->slabs[current_slab_status.slab_number];
 
 		if ((depot->load_type == VDO_SLAB_DEPOT_REBUILD_LOAD) ||
--- a/include/linux/min_heap.h~lib-min_heap-add-args-for-min_heap_callbacks
+++ a/include/linux/min_heap.h
@@ -34,8 +34,8 @@ typedef DEFINE_MIN_HEAP(char, min_heap_c
  * @swp: Swap elements function.
  */
 struct min_heap_callbacks {
-	bool (*less)(const void *lhs, const void *rhs);
-	void (*swp)(void *lhs, void *rhs);
+	bool (*less)(const void *lhs, const void *rhs, void *args);
+	void (*swp)(void *lhs, void *rhs, void *args);
 };
 
 /* Initialize a min-heap. */
@@ -76,7 +76,7 @@ bool __min_heap_full(min_heap_char *heap
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
 	void *data = heap->data;
@@ -89,7 +89,7 @@ void __min_heapify(min_heap_char *heap,
 			break;
 		left = data + (i * 2 + 1) * elem_size;
 		right = data + (i * 2 + 2) * elem_size;
-		i = func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
+		i = func->less(left, right, args) ? i * 2 + 1 : i * 2 + 2;
 	}
 
 	/* Special case for the last leaf with no sibling. */
@@ -97,38 +97,38 @@ void __min_heapify(min_heap_char *heap,
 		i = i * 2 + 1;
 
 	/* Backtrack to the correct location. */
-	while (i != pos && func->less(root, data + i * elem_size))
+	while (i != pos && func->less(root, data + i * elem_size, args))
 		i = (i - 1) / 2;
 
 	/* Shift the element into its correct place. */
 	j = i;
 	while (i != pos) {
 		i = (i - 1) / 2;
-		func->swp(data + i * elem_size, data + j * elem_size);
+		func->swp(data + i * elem_size, data + j * elem_size, args);
 	}
 }
 
-#define min_heapify(_heap, _pos, _func)	\
-	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func)
+#define min_heapify(_heap, _pos, _func, _args)	\
+	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heapify(heap, i, elem_size, func);
+		__min_heapify(heap, i, elem_size, func, args);
 }
 
-#define min_heapify_all(_heap, _func)	\
-	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func)
+#define min_heapify_all(_heap, _func, _args)	\
+	__min_heapify_all((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
 void __min_heap_pop(min_heap_char *heap, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
@@ -138,11 +138,11 @@ void __min_heap_pop(min_heap_char *heap,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heapify(heap, 0, elem_size, func);
+	__min_heapify(heap, 0, elem_size, func, args);
 }
 
-#define min_heap_pop(_heap, _func)	\
-	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func)
+#define min_heap_pop(_heap, _func, _args)	\
+	__min_heap_pop((min_heap_char *)_heap, __minheap_obj_size(_heap), _func, _args)
 
 /*
  * Remove the minimum element and then push the given element. The
@@ -152,19 +152,20 @@ void __min_heap_pop(min_heap_char *heap,
 static __always_inline
 void __min_heap_pop_push(min_heap_char *heap,
 		const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func,
+		void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heapify(heap, 0, elem_size, func);
+	__min_heapify(heap, 0, elem_size, func, args);
 }
 
-#define min_heap_pop_push(_heap, _element, _func)	\
-	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func)
+#define min_heap_pop_push(_heap, _element, _func, _args)	\
+	__min_heap_pop_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
 void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
-		const struct min_heap_callbacks *func)
+		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 	void *child, *parent;
@@ -182,13 +183,13 @@ void __min_heap_push(min_heap_char *heap
 	for (; pos > 0; pos = (pos - 1) / 2) {
 		child = data + (pos * elem_size);
 		parent = data + ((pos - 1) / 2) * elem_size;
-		if (func->less(parent, child))
+		if (func->less(parent, child, args))
 			break;
-		func->swp(parent, child);
+		func->swp(parent, child, args);
 	}
 }
 
-#define min_heap_push(_heap, _element, _func)	\
-	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func)
+#define min_heap_push(_heap, _element, _func, _args)	\
+	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
 #endif /* _LINUX_MIN_HEAP_H */
--- a/kernel/events/core.c~lib-min_heap-add-args-for-min_heap_callbacks
+++ a/kernel/events/core.c
@@ -3686,7 +3686,7 @@ void __perf_event_task_sched_out(struct
 	perf_cgroup_switch(next);
 }
 
-static bool perf_less_group_idx(const void *l, const void *r)
+static bool perf_less_group_idx(const void *l, const void *r, void __always_unused *args)
 {
 	const struct perf_event *le = *(const struct perf_event **)l;
 	const struct perf_event *re = *(const struct perf_event **)r;
@@ -3694,7 +3694,7 @@ static bool perf_less_group_idx(const vo
 	return le->group_index < re->group_index;
 }
 
-static void swap_ptr(void *l, void *r)
+static void swap_ptr(void *l, void *r, void __always_unused *args)
 {
 	void **lp = l, **rp = r;
 
@@ -3786,7 +3786,7 @@ static noinline int visit_groups_merge(s
 		perf_assert_pmu_disabled((*evt)->pmu_ctx->pmu);
 	}
 
-	min_heapify_all(&event_heap, &perf_min_heap);
+	min_heapify_all(&event_heap, &perf_min_heap, NULL);
 
 	while (event_heap.nr) {
 		ret = func(*evt, data);
@@ -3795,9 +3795,9 @@ static noinline int visit_groups_merge(s
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap);
+			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
 		else
-			min_heap_pop(&event_heap, &perf_min_heap);
+			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
 
 	return 0;
--- a/lib/test_min_heap.c~lib-min_heap-add-args-for-min_heap_callbacks
+++ a/lib/test_min_heap.c
@@ -13,17 +13,17 @@
 
 DEFINE_MIN_HEAP(int, min_heap_test);
 
-static __init bool less_than(const void *lhs, const void *rhs)
+static __init bool less_than(const void *lhs, const void *rhs, void __always_unused *args)
 {
 	return *(int *)lhs < *(int *)rhs;
 }
 
-static __init bool greater_than(const void *lhs, const void *rhs)
+static __init bool greater_than(const void *lhs, const void *rhs, void __always_unused *args)
 {
 	return *(int *)lhs > *(int *)rhs;
 }
 
-static __init void swap_ints(void *lhs, void *rhs)
+static __init void swap_ints(void *lhs, void *rhs, void __always_unused *args)
 {
 	int temp = *(int *)lhs;
 
@@ -40,7 +40,7 @@ static __init int pop_verify_heap(bool m
 	int last;
 
 	last = values[0];
-	min_heap_pop(heap, funcs);
+	min_heap_pop(heap, funcs, NULL);
 	while (heap->nr > 0) {
 		if (min_heap) {
 			if (last > values[0]) {
@@ -56,7 +56,7 @@ static __init int pop_verify_heap(bool m
 			}
 		}
 		last = values[0];
-		min_heap_pop(heap, funcs);
+		min_heap_pop(heap, funcs, NULL);
 	}
 	return err;
 }
@@ -77,7 +77,7 @@ static __init int test_heapify_all(bool
 	int i, err;
 
 	/* Test with known set of values. */
-	min_heapify_all(&heap, &funcs);
+	min_heapify_all(&heap, &funcs, NULL);
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 
@@ -86,7 +86,7 @@ static __init int test_heapify_all(bool
 	for (i = 0; i < heap.nr; i++)
 		values[i] = get_random_u32();
 
-	min_heapify_all(&heap, &funcs);
+	min_heapify_all(&heap, &funcs, NULL);
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
 	return err;
@@ -110,14 +110,14 @@ static __init int test_heap_push(bool mi
 
 	/* Test with known set of values copied from data. */
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &data[i], &funcs);
+		min_heap_push(&heap, &data[i], &funcs, NULL);
 
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 	/* Test with randomly generated values. */
 	while (heap.nr < heap.size) {
 		temp = get_random_u32();
-		min_heap_push(&heap, &temp, &funcs);
+		min_heap_push(&heap, &temp, &funcs, NULL);
 	}
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
@@ -143,22 +143,22 @@ static __init int test_heap_pop_push(boo
 	/* Fill values with data to pop and replace. */
 	temp = min_heap ? 0x80000000 : 0x7FFFFFFF;
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &temp, &funcs);
+		min_heap_push(&heap, &temp, &funcs, NULL);
 
 	/* Test with known set of values copied from data. */
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_pop_push(&heap, &data[i], &funcs);
+		min_heap_pop_push(&heap, &data[i], &funcs, NULL);
 
 	err = pop_verify_heap(min_heap, &heap, &funcs);
 
 	heap.nr = 0;
 	for (i = 0; i < ARRAY_SIZE(data); i++)
-		min_heap_push(&heap, &temp, &funcs);
+		min_heap_push(&heap, &temp, &funcs, NULL);
 
 	/* Test with randomly generated values. */
 	for (i = 0; i < ARRAY_SIZE(data); i++) {
 		temp = get_random_u32();
-		min_heap_pop_push(&heap, &temp, &funcs);
+		min_heap_pop_push(&heap, &temp, &funcs, NULL);
 	}
 	err += pop_verify_heap(min_heap, &heap, &funcs);
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are


