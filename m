Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC4D320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560149; cv=none; b=DLZXy9+oPfZshnpO84TBNKsl/OOxwUG50JrOSjQaXbQTkaLejakJEwc3X00XJnPfNBuvNiJUi6FedthOpbfUXvUm+be4dTZI6fbknGZTdh7+O+BDz0I0+B4HWyRgGU4C8TgO4bN0RyHNp6CWUC8NfIuVnW1Yw/5S3C2jfg7mpE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560149; c=relaxed/simple;
	bh=dXiO4t09rxquSR5DKZiYwlVvq3QNpGOia8Fu6JUE9l8=;
	h=Date:To:From:Subject:Message-Id; b=pWwegUTyYaeHdJYphzXeuNHrwcSkAH76pEorkVMxM1ha5PRt2U54k159cNmkU8sROGkPnW1VEFDexSO3XGE5hXM0Bb9sXkenXZufIuPWQSYXMpD7i6oSdfh1acIDDaxN6N9uliwL7KKkEy0nAaBuuVvWVsq7wOJ3INQq5tteFLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=URzXActl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="URzXActl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80E6C433F1;
	Thu, 22 Feb 2024 00:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560149;
	bh=dXiO4t09rxquSR5DKZiYwlVvq3QNpGOia8Fu6JUE9l8=;
	h=Date:To:From:Subject:From;
	b=URzXActlVe7fO3wBpsEDdbXyDxWLf5RZLDkHx8Pa1hE48hCCkX2vtgcrSOBJOlPhh
	 EkxjPIWOwBLlsVo4V185s9A9xDgY0Vhr+pGkUIsloFVJAxE65n4vCOmLrtuQAJq/c5
	 6KtDMFnFzFE/RN7ESOSlS9VZ2ZJOnUXdkN01AByE=
Date: Wed, 21 Feb 2024 16:02:28 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,kaleshsingh@google.com,iamjoonsoo.kim@lge.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch removed from -mm tree
Message-Id: <20240222000228.E80E6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: don't treat bad input arguments for cma_alloc() as its failure
has been removed from the -mm tree.  Its filename was
     mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/cma: don't treat bad input arguments for cma_alloc() as its failure
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


