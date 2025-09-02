Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD182EA72B
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756857178; cv=none; b=NR+I8hwlzt4hciDCCHak6QRZr+6BWVQr5GQjvp2xkx/rsAYrbfwnf5YTy4QF5XsHebZYNxPdAaFkHsMhl9DmQRP1xhs8x2x+xXBjZbQBttFmwsv0YMS/cjzS2XuBLW4iUUpd6IjNxtyo0yeHsJakFJ1PC/XDd4dJObOzPzF1inM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756857178; c=relaxed/simple;
	bh=r1Rv+AR0Na5zTvT/3mAkInSlOra7AvkENJEmGvjoIOQ=;
	h=Date:To:From:Subject:Message-Id; b=ALmsFDu5/DWMvgJB2d4+D9TLJ9vEXZX34qziRY3eGJp9JtFvRkg0jJPj0F8Anmd6yt3AQLOekAUHWJqHV3DJHgoZ3CWVf9xJfezgVw+5K9KKqxiRphODJAZULRdovSYqdqB94VB29NNgqosKh+aRhx+q4xQQPXadQtGB/WOkPhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VEKiXlCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VEKiXlCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C279C4CEED;
	Tue,  2 Sep 2025 23:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756857178;
	bh=r1Rv+AR0Na5zTvT/3mAkInSlOra7AvkENJEmGvjoIOQ=;
	h=Date:To:From:Subject:From;
	b=VEKiXlCclKth95EfqEF7ubeNdXtl3HSAGphRtadJFIvR22XBBuEcAbkspRoL6nTwl
	 QA7QGGUf2BZdmBk0TYdxhkd6zn+HGJ/46eN7q+Fcqoka3QIHNg/Uh0SLT/O6z8LuDL
	 YJT5XSUv5SHBxUlJScIuu07N5JJVTEUWuzXOqQVM=
Date: Tue, 02 Sep 2025 16:52:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-alloc-flags-for-__cma_alloc.patch added to mm-new branch
Message-Id: <20250902235258.0C279C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cma: add alloc flags for __cma_alloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-add-alloc-flags-for-__cma_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-add-alloc-flags-for-__cma_alloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: cma: add alloc flags for __cma_alloc()
Date: Tue, 2 Sep 2025 20:48:18 +0800

In order to support frozen page allocation in the following changes,
adding the alloc flags for __cma_alloc().

Link: https://lkml.kernel.org/r/20250902124820.3081488-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/cma.c~mm-cma-add-alloc-flags-for-__cma_alloc
+++ a/mm/cma.c
@@ -778,7 +778,8 @@ static void cma_debug_show_areas(struct
 
 static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 				unsigned long count, unsigned int align,
-				struct page **pagep, gfp_t gfp)
+				struct page **pagep, gfp_t gfp,
+				acr_flags_t alloc_flags)
 {
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
 	unsigned long start, pfn, mask, offset;
@@ -836,7 +837,7 @@ static int cma_range_alloc(struct cma *c
 		spin_unlock_irq(&cma->lock);
 
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		ret = alloc_contig_range(pfn, pfn + count, alloc_flags, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (!ret)
 			break;
@@ -857,7 +858,7 @@ out:
 }
 
 static struct page *__cma_alloc(struct cma *cma, unsigned long count,
-		       unsigned int align, gfp_t gfp)
+		       unsigned int align, gfp_t gfp, acr_flags_t alloc_flags)
 {
 	struct page *page = NULL;
 	int ret = -ENOMEM, r;
@@ -879,7 +880,7 @@ static struct page *__cma_alloc(struct c
 		page = NULL;
 
 		ret = cma_range_alloc(cma, &cma->ranges[r], count, align,
-				       &page, gfp);
+				       &page, gfp, alloc_flags);
 		if (ret != -EBUSY || page)
 			break;
 	}
@@ -927,7 +928,9 @@ static struct page *__cma_alloc(struct c
 struct page *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
 {
-	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
+	return __cma_alloc(cma, count, align,
+			   GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0),
+			   ACR_FLAGS_CMA);
 }
 
 struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
@@ -937,7 +940,7 @@ struct folio *cma_alloc_folio(struct cma
 	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
-	page = __cma_alloc(cma, 1 << order, order, gfp);
+	page = __cma_alloc(cma, 1 << order, order, gfp, ACR_FLAGS_CMA);
 
 	return page ? page_folio(page) : NULL;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch
mm-page_alloc-add-alloc_contig_frozen_pages.patch
mm-cma-add-alloc-flags-for-__cma_alloc.patch
mm-cma-add-__cma_release.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

