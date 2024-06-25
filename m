Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8CE144D1C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293167; cv=none; b=Xskre74JsMnRUVmH3nCSdVWY1k9Qgz3dfo/jP4nIx/NHdY8mgxH5D8xsRIJrAOKNEJFP0oLm9nI3+jFA6qSpiyKQtJoJL6JbkOCB4GudifSY1sfRUV77GrFT7X2SJhG40Ned0nIJDbTgm+2BamRgiXiFAVXuvvQo8YbY5p3LYpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293167; c=relaxed/simple;
	bh=JhYAtWfxKPTbvq+ZBCQXWWNaoIr7re8m1G57mlB4QdM=;
	h=Date:To:From:Subject:Message-Id; b=XRHk7vOgR9OTWDChVpoa5vWjOvDcqHHCLhagninTd10NWIG0XA18a6UBA+Qi/tx7s5OLEOegCjKJ0oj5NhxCIhBjKr9IpwOnUh2+ukEMDt/l7K2vo4qDDSQ6pMZpkfTgO+M6h7mZO8nrF+hJ3dZ5AP4wyKEYEft4W3HfsZtE2Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZ7MtI1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZ7MtI1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307B9C32782;
	Tue, 25 Jun 2024 05:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293167;
	bh=JhYAtWfxKPTbvq+ZBCQXWWNaoIr7re8m1G57mlB4QdM=;
	h=Date:To:From:Subject:From;
	b=mZ7MtI1DeBP6sC05n0rB6omQNXnwbrs8Oz0BE1grd8h/W3BMVw+VM4sgIg32JjsN7
	 xI4FCEzNtA1BN8OcDPrzKSLZU6muRwiia5SGDtfauTzkt/fIV5Z7MUphmgCVBc4QR6
	 pIOXi/e90t7q17vrNCfzTyBGsS1yp69XP/sg8RIw=
Date: Mon, 24 Jun 2024 22:26:06 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-add-min_heap_sift_up.patch removed from -mm tree
Message-Id: <20240625052607.307B9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: add min_heap_sift_up()
has been removed from the -mm tree.  Its filename was
     lib-min_heap-add-min_heap_sift_up.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add min_heap_sift_up()
Date: Fri, 24 May 2024 23:29:51 +0800

Add min_heap_sift_up() to sift up the element at index 'idx' in the
heap.

Link: https://lkml.kernel.org/r/20240524152958.919343-10-visitorckw@gmail.com
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

 include/linux/min_heap.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-min_heap_sift_up
+++ a/include/linux/min_heap.h
@@ -111,6 +111,26 @@ void __min_heapify(min_heap_char *heap,
 #define min_heapify(_heap, _pos, _func, _args)	\
 	__min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_heap), _func, _args)
 
+/* Sift up ith element from the heap, O(log2(nr)). */
+static __always_inline
+void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
+		const struct min_heap_callbacks *func, void *args)
+{
+	void *data = heap->data;
+	size_t parent;
+
+	while (idx) {
+		parent = (idx - 1) / 2;
+		if (func->less(data + parent * elem_size, data + idx * elem_size, args))
+			break;
+		func->swp(data + parent * elem_size, data + idx * elem_size, args);
+		idx = parent;
+	}
+}
+
+#define min_heap_sift_up(_heap, _idx, _func, _args)	\
+	__min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_heap), _idx, _func, _args)
+
 /* Floyd's approach to heapification that is O(nr). */
 static __always_inline
 void __min_heapify_all(min_heap_char *heap, size_t elem_size,
_

Patches currently in -mm which might be from visitorckw@gmail.com are


