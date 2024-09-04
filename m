Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733A433D5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422213; cv=none; b=tv3i2P2C6Rx0vI8nrUO0ex7Yc9okxDJCHuYtv5oEQRKSt9zBnqYf2wJi1wPR/HF7Dmzwp8YGExuF63X0geAhVULKZXuMYKgAo6sJ7DDoV3ubUIhmqd+CfC3o+ru97XWSZoE/mcppwhPZQwSVxKpJxUgSG7+Z8quM2LubtHXhKkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422213; c=relaxed/simple;
	bh=p799eRHBQe8pwNY1dqBh8ncMxVqNd5XdUa9DdaC/S3o=;
	h=Date:To:From:Subject:Message-Id; b=ozeasy2U+GgTHjXoOy29Qb2Gy9m41AartAL66vgTriQBqnDuPutauboxvJ6qHcYn4aBtfOPehWivtwnDDdPU9JVBgpGVEbBa3uSTEv/D74HeeRWc6NCHxSXTfzQ7PFUJlG9SytUlTzyN6N7CB4Jb8Nf9a/c0V4CzedXkvyuZXOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qfpflj6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qfpflj6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44264C4CEC2;
	Wed,  4 Sep 2024 03:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422213;
	bh=p799eRHBQe8pwNY1dqBh8ncMxVqNd5XdUa9DdaC/S3o=;
	h=Date:To:From:Subject:From;
	b=Qfpflj6kMEUC6HILLZ2xwN1pzkyOt3KiT67tW7k4DRgmVDaIaAWRlEslfBevwbC6U
	 OTLNjHZAE0DFaVmKPPVWQlFxcz9BSEK1h44HrMU68Tu87JRUWYvTKKf+wGmcpeRO/g
	 2JvelKTatiSTU6y85zdO5L7r6Ph+6E4FcHjX8bMI=
Date: Tue, 03 Sep 2024 20:56:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,muchun.song@linux.dev,fvdl@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-cma-add-cma_allocfree_folio-fix.patch removed from -mm tree
Message-Id: <20240904035653.44264C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-cma-add-cma_allocfree_folio-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-add-cma_allocfree_folio-fix.patch

This patch was dropped because it was folded into mm-cma-add-cma_allocfree_folio.patch

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

mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

