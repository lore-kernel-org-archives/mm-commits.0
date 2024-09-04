Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBE933D5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422182; cv=none; b=PESHnfymL0kDocqMLjjCKCPXmAi3DAmpuc2ZnhaparnbfNQCAk9Gi4oN0kflmnswIMkg50dC0yHKZcfGtBj+iNoMsz7bxQftZ5RAV1aD0cR2Bwb3g9n9VHziEQFXcsUAErMGovUqBAkSfJbNNYQ0hBXKv54mCxiGPwWkrKJkQyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422182; c=relaxed/simple;
	bh=48FF/JO8PsvLGMTyzofbXODWrA1DlC6eLX0Ji6aq514=;
	h=Date:To:From:Subject:Message-Id; b=hH2MI61HWOK8th/yPJrmuAhTvebcbiO/84iTF76uW93cvx4ZFnZDqIcfAwFJzNrrkUoZa/BldD3tA0/KqRwRCprQ18VFnXWJztbSinuyGOhPLOiz96qjdVhoujexU5ZxB4n5bm7kUWZTFTAn3JXSc/8NLBARCpDaS6eJNUy1DiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RHPq579h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RHPq579h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C218AC4CEC2;
	Wed,  4 Sep 2024 03:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422181;
	bh=48FF/JO8PsvLGMTyzofbXODWrA1DlC6eLX0Ji6aq514=;
	h=Date:To:From:Subject:From;
	b=RHPq579h1kwIVXO5x1CpbxtkBLzMCoQSF6pTk9nhrdgah7KjeDm2vM/nwRpklBhuB
	 tR5bNYmT060xP2v0Y9NuX6uO/e3XhGwlBiCXejYjiXQanKfa5lwt72QyOJ7v7WOu/t
	 6EYdbyv5Z+aVCWhRj8uWm+mAt9yHcJfW1d7FmAfg=
Date: Tue, 03 Sep 2024 20:56:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,willy@infradead.org,muchun.song@linux.dev,liaoyu15@huawei.com,fvdl@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-contig_alloc-support-__gfp_comp-fix.patch removed from -mm tree
Message-Id: <20240904035621.C218AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-contig_alloc-support-__gfp_comp-fix
has been removed from the -mm tree.  Its filename was
     mm-contig_alloc-support-__gfp_comp-fix.patch

This patch was dropped because it was folded into mm-contig_alloc-support-__gfp_comp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-contig_alloc-support-__gfp_comp-fix
Date: Thu Aug 22 11:32:43 AM PDT 2024

fix folio_alloc_gigantic_noprof() WARN expression, per Yu Liao

Cc: Frank van der Linden <fvdl@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yu Liao <liaoyu15@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-contig_alloc-support-__gfp_comp-fix
+++ a/include/linux/gfp.h
@@ -452,7 +452,7 @@ static inline struct folio *folio_alloc_
 {
 	struct page *page;
 
-	if (WARN_ON(!order || !(gfp | __GFP_COMP)))
+	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
 	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-contig_alloc-support-__gfp_comp.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

