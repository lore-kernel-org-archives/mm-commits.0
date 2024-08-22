Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411021D04A8
	for <mm-commits@vger.kernel.org>; Thu, 22 Aug 2024 19:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724354806; cv=none; b=eXBxDdqqQ5mDQ5JIz1eo2Bpo+w0zYDNtUntTNybgxjYG0Akrz5jgxYD4YEvne5Nw+85DVfx98bCPoRtcyV7XKM4Dnnm7FlZvze1OctIXAdsmQt0Fj1b6K2baElTQerdzKrPtRTsa6QWCEo5XsYl9uRH0JB78lqAksYQPZLcvfFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724354806; c=relaxed/simple;
	bh=Q28AOgFCQlTkHfJp8kDwfQuSDF8pNE4v8joDOXoQR4Q=;
	h=Date:To:From:Subject:Message-Id; b=kk0Npo9uhekl+EzzyJj5c3AwepIrXlDgm8G/rvuSA1Ekpt6FiEbmdPFv2fy633MiNbzuOeHkqbl/R13WhZfd8aORAkXirw0rOglbGJT5rj2usSmHiaxxRQDTArUGpXMDUnAZ5Moa066UuyI57KEjX7eWuFhtxzXczh2r4AUX/9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oqqaJYax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oqqaJYax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF93EC32782;
	Thu, 22 Aug 2024 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724354805;
	bh=Q28AOgFCQlTkHfJp8kDwfQuSDF8pNE4v8joDOXoQR4Q=;
	h=Date:To:From:Subject:From;
	b=oqqaJYaxUMZNZiEiBM/Ar948pO+F0r2z8ss/9eXsyzuR4kuEUGuk4HgppbX4Qyybm
	 HAJxIKZiHm0PKf10zx4GE9qb50kLrOnMSGi9QRsKmaOhEdCYiH4SVA51BDi2BdW9Fv
	 5MhbmTNgYE0STGmIdxRVsvuxmUZHNjmKk6ZZAcE8=
Date: Thu, 22 Aug 2024 12:26:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,muchun.song@linux.dev,fvdl@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-cma_allocfree_folio-fix.patch added to mm-unstable branch
Message-Id: <20240822192645.AF93EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-cma-add-cma_allocfree_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-add-cma_allocfree_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-add-cma_allocfree_folio-fix.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm-cma-add-cma_allocfree_folio-fix
Date: Thu, 22 Aug 2024 11:24:14 -0600

fix WARN in cma_alloc_folio()

Link: https://lkml.kernel.org/r/Zsd0PgAQmbpR8jS6@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-add-cma_allocfree_folio-fix
+++ a/mm/cma.c
@@ -522,7 +522,7 @@ struct folio *cma_alloc_folio(struct cma
 {
 	struct page *page;
 
-	if (WARN_ON(!order || !(gfp | __GFP_COMP)))
+	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
 	page = __cma_alloc(cma, 1 << order, order, gfp);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch
mm-swap-remove-boilerplate-fix.patch
mm-hugetlb_vmemmap-batch-hvo-work-when-demoting.patch
mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch

