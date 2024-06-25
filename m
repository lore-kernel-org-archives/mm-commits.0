Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10F3142E76
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293163; cv=none; b=tAKxsqGKf5ZyoHHH9VW+w34KQk+XCqZ58ZrY6x3iEeME3jVvjfyl2MpTOweCNZUNyqluEmaalbcwY/9UmEg4Xn1Gl/y/TfDSgB5KeG2IXdV+J+agR/FKwCNfDYcdLGMVyM4VY10FHeLisTqiVIlqRcxX3LNUK1cTvGxHjskuAiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293163; c=relaxed/simple;
	bh=Oh7FvLyD05kgz9v3PcUDCzAX8EbVX/rD5w6QdMF1h0k=;
	h=Date:To:From:Subject:Message-Id; b=OsG4NPKUhjPnQwcxhuz/OjXhHA7/kbT0yPqGRtq16jR0zVWMRyrbV7VlUNjAKZXI+qMW+JG1kKYr/luQt24FsXYza7T/FqvU+t+HW41+GNQNpH7mK9zgezXl2bW1nXFG+Tu2EmE/9MQaqRKEy8UrAMPO5LiIWHkJiikuDeQe4Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kn+aKSbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kn+aKSbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EB0C32782;
	Tue, 25 Jun 2024 05:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293163;
	bh=Oh7FvLyD05kgz9v3PcUDCzAX8EbVX/rD5w6QdMF1h0k=;
	h=Date:To:From:Subject:From;
	b=Kn+aKSbbMloXzhb2Gsh3MDzE5EJ9xF4pAsspo+6A7AYT30kvBJMOI1v4/fS19ba2S
	 lENFstmQt1qiIoJxHGThzdAWgCQod+OxzlvH0tKBHJ7p8XwIyMBZ6SEAy58J1WPD5q
	 VTmMavOFpiCTFqUchH6utfKMvNKBP54TMs9x+Lrw=
Date: Mon, 24 Jun 2024 22:26:03 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-min_heap-add-min_heap_peek.patch removed from -mm tree
Message-Id: <20240625052603.95EB0C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: add min_heap_peek()
has been removed from the -mm tree.  Its filename was
     lib-min_heap-add-min_heap_peek.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: add min_heap_peek()
Date: Fri, 24 May 2024 23:29:48 +0800

Add min_heap_peek() to retrieve a pointer to the smallest element.  The
pointer is cast to the appropriate type of heap elements.

Link: https://lkml.kernel.org/r/20240524152958.919343-7-visitorckw@gmail.com
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

--- a/include/linux/min_heap.h~lib-min_heap-add-min_heap_peek
+++ a/include/linux/min_heap.h
@@ -53,6 +53,16 @@ void __min_heap_init(min_heap_char *heap
 #define min_heap_init(_heap, _data, _size)	\
 	__min_heap_init((min_heap_char *)_heap, _data, _size)
 
+/* Get the minimum element from the heap. */
+static __always_inline
+void *__min_heap_peek(struct min_heap_char *heap)
+{
+	return heap->nr ? heap->data : NULL;
+}
+
+#define min_heap_peek(_heap)	\
+	(__minheap_cast(_heap) __min_heap_peek((min_heap_char *)_heap))
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
_

Patches currently in -mm which might be from visitorckw@gmail.com are


