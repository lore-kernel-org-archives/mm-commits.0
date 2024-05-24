Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1355B5D3
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 19:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716579043; cv=none; b=RDXmkKjf+xUkW5qbem6vpwt7TvLOg/iuJ2DkNUtbC/pdwc2iA+KUEKXPGi33NJ8c9LNTGjFDiFEL58Za/CLqNl0xlUHbi0g1556nFQQWbZROWegLohu1F+b+GrOEOkxPndD1vyiqQfnN/iyB9jligMNLyBXBwDoQwS7FEIGmvCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716579043; c=relaxed/simple;
	bh=lTDrxm2iPHIh3HfFUX+pJE9s/EnXprZle4glEEgEPrU=;
	h=Date:To:From:Subject:Message-Id; b=nfJ1uQJo0YqZjhpgezRv9PggQ4+PGXtt3WTSj2STjuj5XYRYWhdMDGB8BLjtvYGqzbstwvSKGITgOke4gyyNwVudaS9VVP0kJEVQj0ydNJ+CuXju/e3sSPsqjIFZJWNXbWqN1GJcIiYbN9RmDVpBajrdn5VsUEhf3gvRgrmTKB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GUaAQ40+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GUaAQ40+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F395BC2BBFC;
	Fri, 24 May 2024 19:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716579043;
	bh=lTDrxm2iPHIh3HfFUX+pJE9s/EnXprZle4glEEgEPrU=;
	h=Date:To:From:Subject:From;
	b=GUaAQ40+batjefkRMD5iHVLeIuq2Srf3nEGnZtyzP6cJCDXwa4YpninNg2ygy17KH
	 OUHEDlZGc7m79PV2+/uCQfx5oHho0CwkRPAiOaqGOExhsllxV/de0ZAs5HW3eEpJqC
	 /R+yR7yRDyZuPB5c6wPfJAMF5DbiMgk2Kw3I5HBU=
Date: Fri, 24 May 2024 12:30:42 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch added to mm-nonmm-unstable branch
Message-Id: <20240524193042.F395BC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: update min_heap_push() and min_heap_pop() to return bool values
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch

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
Subject: lib min_heap: update min_heap_push() and min_heap_pop() to return bool values
Date: Fri, 24 May 2024 23:29:53 +0800

Modify the min_heap_push() and min_heap_pop() to return a boolean value. 
They now return false when the operation fails and true when it succeeds.

Link: https://lkml.kernel.org/r/20240524152958.919343-12-visitorckw@gmail.com
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

 include/linux/min_heap.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values
+++ a/include/linux/min_heap.h
@@ -147,18 +147,20 @@ void __min_heapify_all(min_heap_char *he
 
 /* Remove minimum element from the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_pop(min_heap_char *heap, size_t elem_size,
+bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
 
 	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
-		return;
+		return false;
 
 	/* Place last element at the root (position 0) and then sift down. */
 	heap->nr--;
 	memcpy(data, data + (heap->nr * elem_size), elem_size);
 	__min_heapify(heap, 0, elem_size, func, args);
+
+	return true;
 }
 
 #define min_heap_pop(_heap, _func, _args)	\
@@ -184,7 +186,7 @@ void __min_heap_pop_push(min_heap_char *
 
 /* Push an element on to the heap, O(log2(nr)). */
 static __always_inline
-void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
+bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
@@ -192,7 +194,7 @@ void __min_heap_push(min_heap_char *heap
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
-		return;
+		return false;
 
 	/* Place at the end of data. */
 	pos = heap->nr;
@@ -207,6 +209,8 @@ void __min_heap_push(min_heap_char *heap
 			break;
 		func->swp(parent, child, args);
 	}
+
+	return true;
 }
 
 #define min_heap_push(_heap, _element, _func, _args)	\
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

