Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B551FA0
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560056; cv=none; b=KHhFEWQn6zbrKHXrTr3Ym1gvWGAYzXwiB67LIs0/HEGzHYPKFUQp2W+QLXnE2KBLALF3ZKRuvBP/Ci6e/N8BVon3n14+EINoUjvtonpNvAPIfOMVTt+Z9uRiYzknQnmDLfTGSf8iJMDeJNo99Rx0ATJK4ZEatgPEZhwCnWRjFu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560056; c=relaxed/simple;
	bh=pDRXxnQKPGeQN+5dw/0+jud5sZ9skxq+wlz7Op6N7Mo=;
	h=Date:To:From:Subject:Message-Id; b=jZ9fN5kDaBF6a0UiffJTQrPEFW8is3EgqZPjYU/ZOXpV9r9zxF3IY+yjWmdkXYZ/Y+OGv71ToaKQOlK14EbFTrruxVkKjPhJa0D11P+VzcdVdBFJ/B1yBUFIPu8t86qXQeSpDvZCghM+OCjq2yW9wLS9waTrfW+lPl8ChQHgnyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cw/oFtl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cw/oFtl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17EFC43390;
	Thu, 22 Feb 2024 00:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560055;
	bh=pDRXxnQKPGeQN+5dw/0+jud5sZ9skxq+wlz7Op6N7Mo=;
	h=Date:To:From:Subject:From;
	b=cw/oFtl648O1KuuEsNUUWOApv6txMlJa19CaRe9QHlXClQSk5yrjH+xT5fFBMjISf
	 S9DbQ85/hMKhtB3DyxZVxlTqaGtevU/kjIzAqIIm2N6+S/I31njjJJjt5sf1UKqdBV
	 t1cVcjRZYeozPedD+QlFmOCJjZygvWZhUxV+f9Ao=
Date: Wed, 21 Feb 2024 16:00:55 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,lmark@codeaurora.org,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-fix-placement-of-trace_cma_alloc_start-finish.patch removed from -mm tree
Message-Id: <20240222000055.A17EFC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: fix placement of trace_cma_alloc_start/finish
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-placement-of-trace_cma_alloc_start-finish.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


