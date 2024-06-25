Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5BB144D1C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293169; cv=none; b=JzzARFnxYMtrJOO8vu+oXUD1gtDbwlq9hSmcqzAvN01FIVGYS5g2mKmaTUUyDPwvT9wWzJZT8f6kul/rZyvwxKfM3Y2Tr0b8hq72dcbL1oBatx0I0fr+aKDWFulNK8rjfE/T8PazDmj9M7jYa2AsdJU0pHWAJs0RuZzs8C2KOTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293169; c=relaxed/simple;
	bh=sf+YtivepRqMmjLvrMUwaqUuygWE/jRUkx7WYEFlE+I=;
	h=Date:To:From:Subject:Message-Id; b=rvA4OK/JPefTbXPA4j1KfZL5HchWXI4O9cfrV+997hjn7La8Pjns/1srrAkk8nEcrYuWF5Rgu0K0YcsHoQzXPSBwRqMVIJ6Y0hmfo72t4AE1qgqfCrhoCrhVKQ0APbhmBfuPPKQjc9lnprFCsRaBKt0mb35g5vEwv13YrbYO7Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DEB74oAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DEB74oAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944F2C32782;
	Tue, 25 Jun 2024 05:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293169;
	bh=sf+YtivepRqMmjLvrMUwaqUuygWE/jRUkx7WYEFlE+I=;
	h=Date:To:From:Subject:From;
	b=DEB74oAfHSgtMmBbslLZ067lbwhTv+3KeEqEcePZebEUeKPOwRntlDGtbAJSs2xLl
	 cuy0IEVksXknj+kTm7axJ0vGMDh2F3UqpP42qWNIorLYfGbczIZeISrs1kRTy6GXMC
	 pQuyYWMffaKry3gYYEo6KpmelWmoorTW2A5gu1R0=
Date: Mon, 24 Jun 2024 22:26:09 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch removed from -mm tree
Message-Id: <20240625052609.944F2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: update min_heap_push() and min_heap_pop() to return bool values
has been removed from the -mm tree.  Its filename was
     lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


