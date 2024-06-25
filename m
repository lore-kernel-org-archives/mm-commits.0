Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC8633C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293168; cv=none; b=Zyi7epHH9fLI6yZ/BXqtu7tfTj44OCVIu+uvFwCUsQLZbSid3nKj5ndbqQDb2rtjEMg7TRFKhKyOtzixEC87gD2rGPT9NyD03s0Ng0AMwBsLzBO6aCG/bN3RaEbIEwYp1NeI18aO7XdiEhMpj2GUtESCpZbzJOEigqAdQcWPzrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293168; c=relaxed/simple;
	bh=4GU0dqlMN4Ta4PYnh/kMDpMqmYrUW73QT1vBio8TmEw=;
	h=Date:To:From:Subject:Message-Id; b=GiihlyHyqnsL8zqnI9bD9TaUz+OELPtV2LbMdbdXawXoUl7Jym3e068iO5iVCOBi1LGmo6HmQbh6hrvsqjyPOTcME05nHEBVVFEfktYOWYctZeeg4bYvlZQ6c0xZFGoteTZv41bnythXfX/kQ1YDdT18iUrKVyh9RQdhKFmePD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y4X26mD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y4X26mD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67826C32782;
	Tue, 25 Jun 2024 05:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293168;
	bh=4GU0dqlMN4Ta4PYnh/kMDpMqmYrUW73QT1vBio8TmEw=;
	h=Date:To:From:Subject:From;
	b=Y4X26mD1QVT7uzin5zkO8b1HsGN5LpCdQsyqQIygZed/AkPrwAttjKT7/Aeez+uM0
	 L6TLNPocoqBgTcQqoy2HPKvDgu5I1vWWl+IyTs2fWQJbCkgE1ZTwpYMIlFLhJeaWYq
	 8XinFdF5jbModQFqYKhbYoGGWvi5hPqsli89E9wM=
Date: Mon, 24 Jun 2024 22:26:07 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-add-min_heap_del.patch removed from -mm tree
Message-Id: <20240625052608.67826C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: add min_heap_del()
has been removed from the -mm tree.  Its filename was
     lib-min_heap-add-min_heap_del.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add min_heap_del()
Date: Fri, 24 May 2024 23:29:52 +0800

Add min_heap_del() to delete the element at index 'idx' in the heap.

Link: https://lkml.kernel.org/r/20240524152958.919343-11-visitorckw@gmail.com
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

 include/linux/min_heap.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-min_heap_del
+++ a/include/linux/min_heap.h
@@ -212,4 +212,28 @@ void __min_heap_push(min_heap_char *heap
 #define min_heap_push(_heap, _element, _func, _args)	\
 	__min_heap_push((min_heap_char *)_heap, _element, __minheap_obj_size(_heap), _func, _args)
 
+/* Remove ith element from the heap, O(log2(nr)). */
+static __always_inline
+bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+
+	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
+		return false;
+
+	/* Place last element at the root (position 0) and then sift down. */
+	heap->nr--;
+	if (idx == heap->nr)
+		return true;
+	func->swp(data + (idx * elem_size), data + (heap->nr * elem_size), args);
+	__min_heap_sift_up(heap, elem_size, idx, func, args);
+	__min_heapify(heap, idx, elem_size, func, args);
+
+	return true;
+}
+
+#define min_heap_del(_heap, _idx, _func, _args)	\
+	__min_heap_del((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 #endif /* _LINUX_MIN_HEAP_H */
_

Patches currently in -mm which might be from visitorckw@gmail.com are


