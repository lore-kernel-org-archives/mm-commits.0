Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BBA13E233
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875973; cv=none; b=Pxu4DCs3llv55jMywZTT908FMTfmdpZpB+A8ZyhR35pxuUcze3CUitu9catsN2Zj9YRsnkP/Gu5IfszQyhAt0mgOHr1yq64+oLXG2+bDejitN3Hg1sRDuQ/9qAnXU45DM7s5I6m+pZ/oTFOrEIcjc1gVXHNkJp1owzaVK3zIBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875973; c=relaxed/simple;
	bh=DCInuc/PRH3O9fJOFuSmsABcKzf+wBTDh/10pk3calU=;
	h=Date:To:From:Subject:Message-Id; b=MGpx9qbitC++vHJ+CkqZpq9pP+JJC/kd9NLlNCopeS5Qw+ARGTpVLgHdwQshCxXwkA2Plz9nCXcVB5kpsnq5ASkrwCwhUwUp4sJbCC0ZBZKr656uxGxfDNOZiWDgkNvMnNzmCusF4/chhQEeUwn2rDGXBPoeMdVlRr7DuulVYns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0A9oDFBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0A9oDFBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0F0C433C7;
	Fri,  2 Feb 2024 12:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875972;
	bh=DCInuc/PRH3O9fJOFuSmsABcKzf+wBTDh/10pk3calU=;
	h=Date:To:From:Subject:From;
	b=0A9oDFBiUex/6kK2VtKQ8kzmoK5KZf2JKOvM/49G3cW/4vQkKo+JlRVrL/RFr+mGZ
	 9QmIa9M6XVzWtQtRn25PHaG9rx/XTZHGYx7lHyGpALW1r/ZQXORTo2g2Dg7WbICjCa
	 jlPrEzsumNgIvERyUMuT4wPAfcRsdwz0fevKyB8w=
Date: Fri, 02 Feb 2024 04:12:50 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,kaleshsingh@google.com,iamjoonsoo.kim@lge.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch added to mm-unstable branch
Message-Id: <20240202121252.4E0F0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: Don't treat bad input arguments for cma_alloc() as its failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/cma: Don't treat bad input arguments for cma_alloc() as its failure
Date: Thu, 1 Feb 2024 08:07:14 +0530

Invalid cma_alloc() input scenarios - including excess allocation request
should neither be counted as CMA_ALLOC_FAIL nor 'cma->nr_pages_failed' be
updated when applicable with CONFIG_CMA_SYSFS. This also drops 'out' jump
label which has become redundant.

Link: https://lkml.kernel.org/r/20240201023714.3871061-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/cma.c~mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure
+++ a/mm/cma.c
@@ -441,13 +441,13 @@ struct page *cma_alloc(struct cma *cma,
 	trace_cma_alloc_start(name, count, align);
 
 	if (!cma || !cma->count || !cma->bitmap)
-		goto out;
+		return page;
 
 	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
 		(void *)cma, cma->name, count, align);
 
 	if (!count)
-		goto out;
+		return page;
 
 	mask = cma_bitmap_aligned_mask(cma, align);
 	offset = cma_bitmap_aligned_offset(cma, align);
@@ -455,7 +455,7 @@ struct page *cma_alloc(struct cma *cma,
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 
 	if (bitmap_count > bitmap_maxno)
-		goto out;
+		return page;
 
 	for (;;) {
 		spin_lock_irq(&cma->lock);
@@ -514,15 +514,13 @@ struct page *cma_alloc(struct cma *cma,
 	}
 
 	pr_debug("%s(): returned %p\n", __func__, page);
-out:
 	trace_cma_alloc_finish(name, pfn, page, count, align, ret);
 	if (page) {
 		count_vm_event(CMA_ALLOC_SUCCESS);
 		cma_sysfs_account_success_pages(cma, count);
 	} else {
 		count_vm_event(CMA_ALLOC_FAIL);
-		if (cma)
-			cma_sysfs_account_fail_pages(cma, count);
+		cma_sysfs_account_fail_pages(cma, count);
 	}
 
 	return page;
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch

