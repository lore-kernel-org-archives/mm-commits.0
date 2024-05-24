Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4125B5D3
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716579045; cv=none; b=cXn34Ho57nRlQ3cvslm0SehK9eD5KlzdQh6vf53C6+ZvljGrtPxf5s5uQFI37mX46eCMFTw78Rj6EVxoWpToJPPi91pHv3Y1nhK3Ari3iLk30eo5vIf97w6n1FLRsh0aP2YoQV0m/XcidnQ9ebyF8s65EfgXFigfrIV5Uf/JSkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716579045; c=relaxed/simple;
	bh=bCZfvyya5Bk+tp4/m6mPd3Hj+mea6luT38i/im2RS0Q=;
	h=Date:To:From:Subject:Message-Id; b=u3wAJPaxPRs7ZMzGt1/96uDCb+4fGnoCcx1b8oyLdUcSJ0aARozzVoVoBq8nWcEYQtNv7LYJrCB7Nv8Yx1G1PYuQn8kpwctNsCoTU2YzY1FkjQrrPBkO61UBXOGJprSVxZYJZRK3HYZrOqT08hD0KMrm5+HNVNfHCFNV79hFQOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jqUrpL3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jqUrpL3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A07AC2BBFC;
	Fri, 24 May 2024 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716579045;
	bh=bCZfvyya5Bk+tp4/m6mPd3Hj+mea6luT38i/im2RS0Q=;
	h=Date:To:From:Subject:From;
	b=jqUrpL3vMd5U4H8RxUZnbbEi2kZjNCU1CL1/Jv92AW7MmSMhs0Y6iNp3yCKm2gk8J
	 Vq0PYFvxAGNbJ3GHpxbolgdJIUCjqskUrR6/SkgKWhJ40D9BeU4Q8GMtzhy/qp5q/8
	 quuPoe7X08xk6x3KSNE1IUgCFx/O7JmZ/RYLrhJk=
Date: Fri, 24 May 2024 12:30:44 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch added to mm-nonmm-unstable branch
Message-Id: <20240524193045.0A07AC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: rename min_heapify() to min_heap_sift_down()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch

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
Subject: lib min_heap: rename min_heapify() to min_heap_sift_down()
Date: Fri, 24 May 2024 23:29:54 +0800

After adding min_heap_sift_up(), the naming convention has been adjusted
to maintain consistency with the min_heap_sift_up().  Consequently,
min_heapify() has been renamed to min_heap_sift_down().

Link: https://lkml.kernel.org/CAP-5=fVcBAxt8Mw72=NCJPRJfjDaJcqk4rjbadgouAEAHz_q1A@mail.gmail.com
Link: https://lkml.kernel.org/r/20240524152958.919343-13-visitorckw@gmail.com
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

 drivers/md/dm-vdo/repair.c |    2 +-
 include/linux/min_heap.h   |   14 +++++++-------
 kernel/events/core.c       |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-vdo/repair.c~lib-min_heap-rename-min_heapify-to-min_heap_sift_down
+++ a/drivers/md/dm-vdo/repair.c
@@ -183,7 +183,7 @@ static struct numbered_block_mapping *so
 	 */
 	last = &repair->entries[--heap->nr];
 	swap_mappings(heap->data, last, NULL);
-	min_heapify(heap, 0, &repair_min_heap, NULL);
+	min_heap_sift_down(heap, 0, &repair_min_heap, NULL);
 	return last;
 }
 
--- a/include/linux/min_heap.h~lib-min_heap-rename-min_heapify-to-min_heap_sift_down
+++ a/include/linux/min_heap.h
@@ -75,7 +75,7 @@ bool __min_heap_full(min_heap_char *heap
 
 /* Sift the element at pos down the heap. */
 static __always_inline
-void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
+void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *left, *right;
@@ -108,8 +108,8 @@ void __min_heapify(min_heap_char *heap,
 	}
 }
 
-#define min_heapify(_heap, _pos, _func, _args)	\
-	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
+#define min_heap_sift_down(_heap, _pos, _func, _args)	\
+	__min_heap_sift_down((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
 /* Sift up ith element from the heap, O(log2(nr)). */
 static __always_inline
@@ -139,7 +139,7 @@ void __min_heapify_all(min_heap_char *he
 	int i;
 
 	for (i = heap->nr / 2 - 1; i >= 0; i--)
-		__min_heapify(heap, i, elem_size, func, args);
+		__min_heap_sift_down(heap, i, elem_size, func, args);
 }
 
 #define min_heapify_all(_heap, _func, _args)	\
@@ -158,7 +158,7 @@ bool __min_heap_pop(min_heap_char *heap,
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 
 	return true;
 }
@@ -178,7 +178,7 @@ void __min_heap_pop_push(min_heap_char *
 		void *args)
 {
 	memcpy(heap->data, element, elem_size);
-	__min_heapify(heap, 0, elem_size, func, args);
+	__min_heap_sift_down(heap, 0, elem_size, func, args);
 }
 
 #define min_heap_pop_push(_heap, _element, _func, _args)	\
@@ -232,7 +232,7 @@ bool __min_heap_del(min_heap_char *heap,
 		return true;
 	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
 	__min_heap_sift_up(heap, elem_size, idx, func, args);
-	__min_heapify(heap, idx, elem_size, func, args);
+	__min_heap_sift_down(heap, idx, elem_size, func, args);
 
 	return true;
 }
--- a/kernel/events/core.c~lib-min_heap-rename-min_heapify-to-min_heap_sift_down
+++ a/kernel/events/core.c
@@ -3795,7 +3795,7 @@ static noinline int visit_groups_merge(s
 
 		*evt = perf_event_groups_next(*evt, pmu);
 		if (*evt)
-			min_heapify(&event_heap, 0, &perf_min_heap, NULL);
+			min_heap_sift_down(&event_heap, 0, &perf_min_heap, NULL);
 		else
 			min_heap_pop(&event_heap, &perf_min_heap, NULL);
 	}
_

Patches currently in -mm which might be from visitorckw@gmail.com are

perf-core-fix-several-typos.patch
bcache-fix-typo.patch
bcachefs-fix-typo.patch
lib-min_heap-add-type-safe-interface.patch
lib-min_heap-add-min_heap_init.patch
lib-min_heap-add-min_heap_peek.patch
lib-min_heap-add-min_heap_full.patch
lib-min_heap-add-args-for-min_heap_callbacks.patch
lib-min_heap-add-min_heap_sift_up.patch
lib-min_heap-add-min_heap_del.patch
lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch
lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch
lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up.patch
lib-test_min_heap-add-test-for-heap_del.patch
bcache-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap.patch

