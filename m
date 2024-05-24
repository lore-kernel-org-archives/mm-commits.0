Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3F15BAF0
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716579029; cv=none; b=WzIgS+5oB0xXTRN7f9JAZC67LJpQA2TkeMtaPdFJECQHykDlGmy9MU8cD/0ExhbU3KomoIwvaU/ujizA023U45NjXrCc5gHEmMiRQmNzp4IgiLpfEjcNkZlo46UQsDxZtoIg+xVDB1KtPymuwYYwkb6PdjWcNd50BQJXV3xOo64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716579029; c=relaxed/simple;
	bh=I8CR5d88Rs3BOkKfBW2Lc0ji5xyicd37mfOmtaUrhTY=;
	h=Date:To:From:Subject:Message-Id; b=seHXm7ya9LITufqFQvLRQF4HhCivQSL7ANKEtxsp+q4tt+5gEzkojQIoWd4SN/NGcPLRUIsse8Ew5C79AqY29SgFrS+3UP+F/UsRbP5ITIMidH7D4EfSKx4s2olCg7+1WYoWsBEJ6huk1Sx52+8l28PhNJaTAZ/oi7fG0BHWPqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fGSRTRyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fGSRTRyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581E1C2BBFC;
	Fri, 24 May 2024 19:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716579029;
	bh=I8CR5d88Rs3BOkKfBW2Lc0ji5xyicd37mfOmtaUrhTY=;
	h=Date:To:From:Subject:From;
	b=fGSRTRyXkGvgsRNRyf+LYtIsr6re8HwaRFq0b5RHIsU8jdH78ZBx+32+XF4WjVI3w
	 GKNDTokaIUu6pULIL18J9LFrOGA/n2+YWlY42g7E+HfsMGVgMEe/nnwOjhTU4pcxBz
	 w+2Mp0PS4Hco4b9GjUTa8Rzo3vC2CGjN5YVkOSLk=
Date: Fri, 24 May 2024 12:30:28 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,colyli@suse.de,bfoster@redhat.com,bagasdotme@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-add-min_heap_init.patch added to mm-nonmm-unstable branch
Message-Id: <20240524193029.581E1C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: add min_heap_init()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-add-min_heap_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-add-min_heap_init.patch

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
Subject: lib min_heap: add min_heap_init()
Date: Fri, 24 May 2024 23:29:47 +0800

Add min_heap_init() for initializing heap with data, nr, and size.

Link: https://lkml.kernel.org/r/20240524152958.919343-6-visitorckw@gmail.com
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

 include/linux/min_heap.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-min_heap_init
+++ a/include/linux/min_heap.h
@@ -38,6 +38,21 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs);
 };
 
+/* Initialize a min-heap. */
+static __always_inline
+void __min_heap_init(min_heap_char *heap, void *data, int size)
+{
+	heap->nr = 0;
+	heap->size = size;
+	if (data)
+		heap->data = data;
+	else
+		heap->data = heap->preallocated;
+}
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init((min_heap_char *)_heap, _data, _size)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
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

