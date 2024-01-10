Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB9C4689
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fKzplRnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F54C433C7;
	Wed, 10 Jan 2024 04:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704859637;
	bh=SjrgXhLnshrMZY8IJHejlxwPEHHZh96IMH7Qtz5pfmk=;
	h=Date:To:From:Subject:From;
	b=fKzplRnt6g6phV8L6nMQ4c7eGN4afUD5sd14gCtZmByG5cfqA41DP7q60VTjIPaTb
	 3Y7eh7mkRZAAPkFRJblfRfm6plZh7wF7pS8WJzAuk6Pa3tsGVvwH5VmDXYJab1zpAC
	 7hwS9VUKyYsi5cL9VMAVixyZUyLR1BF309ikVmFw=
Date: Tue, 09 Jan 2024 20:07:15 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,lmark@codeaurora.org,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-fix-placement-of-trace_cma_alloc_start-finish.patch added to mm-unstable branch
Message-Id: <20240110040717.44F54C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: fix placement of trace_cma_alloc_start/finish
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-fix-placement-of-trace_cma_alloc_start-finish.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-fix-placement-of-trace_cma_alloc_start-finish.patch

This patch will later appear in the mm-unstable branch at
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
From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm/cma: fix placement of trace_cma_alloc_start/finish
Date: Tue, 9 Jan 2024 17:22:33 -0800

The current placement of trace_cma_alloc_start/finish misses the fail
cases: !cma || !cma->count || !cma->bitmap.

trace_cma_alloc_finish is also not emitted for the failure case
where bitmap_count > bitmap_maxno.

Fix these missed cases by moving the start event before the failure
checks and moving the finish event to the out label.

Link: https://lkml.kernel.org/r/20240110012234.3793639-1-kaleshsingh@google.com
Fixes: 7bc1aec5e287 ("mm: cma: add trace events for CMA alloc perf testing")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Liam Mark <lmark@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/cma.c~mm-cma-fix-placement-of-trace_cma_alloc_start-finish
+++ a/mm/cma.c
@@ -436,6 +436,9 @@ struct page *cma_alloc(struct cma *cma,
 	unsigned long i;
 	struct page *page = NULL;
 	int ret = -ENOMEM;
+	const char *name = cma ? cma->name : NULL;
+
+	trace_cma_alloc_start(name, count, align);
 
 	if (!cma || !cma->count || !cma->bitmap)
 		goto out;
@@ -446,8 +449,6 @@ struct page *cma_alloc(struct cma *cma,
 	if (!count)
 		goto out;
 
-	trace_cma_alloc_start(cma->name, count, align);
-
 	mask = cma_bitmap_aligned_mask(cma, align);
 	offset = cma_bitmap_aligned_offset(cma, align);
 	bitmap_maxno = cma_bitmap_maxno(cma);
@@ -496,8 +497,6 @@ struct page *cma_alloc(struct cma *cma,
 		start = bitmap_no + mask + 1;
 	}
 
-	trace_cma_alloc_finish(cma->name, pfn, page, count, align, ret);
-
 	/*
 	 * CMA can allocate multiple page blocks, which results in different
 	 * blocks being marked with different tags. Reset the tags to ignore
@@ -516,6 +515,7 @@ struct page *cma_alloc(struct cma *cma,
 
 	pr_debug("%s(): returned %p\n", __func__, page);
 out:
+	trace_cma_alloc_finish(name, pfn, page, count, align, ret);
 	if (page) {
 		count_vm_event(CMA_ALLOC_SUCCESS);
 		cma_sysfs_account_success_pages(cma, count);
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-cma-fix-placement-of-trace_cma_alloc_start-finish.patch

