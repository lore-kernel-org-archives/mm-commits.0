Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7533C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293165; cv=none; b=LEaWJCxe3rftQJ94uPuU/5+/e3cAt56+Sdz9a/dqZe/KRO0aBOUSLEArlGF7XwxBhQSE4PZauWNBD5hAmrtVnTPEmGFgsoN93hC8QXjHoBAQlYjFcU+spbGYvz06Hao1FUYsg3iiiR0qpHj7Kh+QJMyFgSu2eK68qnPKFmiT40w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293165; c=relaxed/simple;
	bh=1oBg7XPY2dbgpm7/ufHwHPdv38+4qdxszN5EbkjQoQQ=;
	h=Date:To:From:Subject:Message-Id; b=EYPhop0gQGiSU+Oa381DkIN1SiUMyBe2oQLx8vvXJ+WCoUnC8Ph68Z3GSqjUWaackKhmRHsj2R1pWN8fDU9VvRnBMVreW4Abpy2LEHjkNBF0pNEvrEKOyUvKsaTsS4ymtjJfRsRrCzCALIwBbZ5Z+6wJhnKvWRc8f6oDuO80w34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xGgF0/3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xGgF0/3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15D8C32782;
	Tue, 25 Jun 2024 05:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293164;
	bh=1oBg7XPY2dbgpm7/ufHwHPdv38+4qdxszN5EbkjQoQQ=;
	h=Date:To:From:Subject:From;
	b=xGgF0/3LKI4o8/2PoF7l9KYvV+KaSpFccMC2jKRcpOIimnzhmGYsGgfqz0wo+/7cJ
	 EyxgEm0fjxvPlA7cpczqKD4SKWV8Dwq4ajqfaBi5paF6jEEIlZ/FhEVmbVeWimAqdV
	 GZO4SCnZuNQCcbQPgwtBMGM2lriVa6iAFKXoedwM=
Date: Mon, 24 Jun 2024 22:26:04 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-add-min_heap_full.patch removed from -mm tree
Message-Id: <20240625052604.C15D8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: add min_heap_full()
has been removed from the -mm tree.  Its filename was
     lib-min_heap-add-min_heap_full.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add min_heap_full()
Date: Fri, 24 May 2024 23:29:49 +0800

Add min_heap_full() which returns a boolean value indicating whether the
heap has reached its maximum capacity.

Link: https://lkml.kernel.org/r/20240524152958.919343-8-visitorckw@gmail.com
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

 include/linux/min_heap.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-min_heap_full
+++ a/include/linux/min_heap.h
@@ -63,6 +63,16 @@ void *__min_heap_peek(struct min_heap_ch
 #define min_heap_peek(_heap)	\
 	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
 
+/* Check if the heap is full. */
+static __always_inline
+bool __min_heap_full(min_heap_char *heap)
+{
+	return heap->nr == heap->size;
+}
+
+#define min_heap_full(_heap)	\
+	__min_heap_full((min_heap_char *)_heap)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
_

Patches currently in -mm which might be from visitorckw@gmail.com are


