Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95E421B9C1
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767118579; cv=none; b=pmZ8GpkRbH0/mmq/1Q5TZb47x9UmuSv4nHA4UTFSLgINKyfgPTMdf7RvpzTBg4OuLx96y0eo9/sAnButO7ZuIRawen+xOTPm3Tyxy+4eu9lAv9JXcaNPfyuBBtVNd7wNsa/tnRRJopgfxGtxaoj44Twxwo8488lCXJtjS/ySWTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767118579; c=relaxed/simple;
	bh=i57SPtPOqzqinLpbs//PqS4yQ2QKduj8P143cwafM7Q=;
	h=Date:To:From:Subject:Message-Id; b=UvqP96jSvS6KLDTi7yLiFZPQEWsXWNI+Xduy/7aUlbdjZrL04kyjLa8XQXPuOm6l9RO+OuybEAQtdJsdeXu/Zx0ILUjyEgYBK+5Q8z6YcgRzX/0GoxeS+LN2gy1dqz1GVb+opN1/CKB/bjPsolLc/vF8/LhsZcgZyXyhOb0z4RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZox/ksr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZox/ksr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E50C4CEFB;
	Tue, 30 Dec 2025 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767118579;
	bh=i57SPtPOqzqinLpbs//PqS4yQ2QKduj8P143cwafM7Q=;
	h=Date:To:From:Subject:From;
	b=HZox/ksrrSEzK6sDePqhiH45QGOii/OK0tHV2RomRVZFI8bPmfUwo8IL97/z3WUe2
	 SXV6HMNkFrBwSR3TN48JXLNxXrDz4QEDMKYHJL/Sfxu5FizY7cx/dOv65Yr5tD6Nv3
	 uhHtJG8/HKbofV9zZP4uyiqUVZJj36RpB4W7odC4=
Date: Tue, 30 Dec 2025 10:16:18 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-kill-cma_pages_valid.patch added to mm-new branch
Message-Id: <20251230181619.21E50C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cma: kill cma_pages_valid()
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-kill-cma_pages_valid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-kill-cma_pages_valid.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: cma: kill cma_pages_valid()
Date: Tue, 30 Dec 2025 15:24:19 +0800

Kill cma_pages_valid() which only used in cma_release(), also cleanup code
duplication between cma pages valid checking and cma memrange finding.

Link: https://lkml.kernel.org/r/20251230072422.265265-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    1 
 mm/cma.c            |   48 +++++++++---------------------------------
 2 files changed, 11 insertions(+), 38 deletions(-)

--- a/include/linux/cma.h~mm-cma-kill-cma_pages_valid
+++ a/include/linux/cma.h
@@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_ad
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
-extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
--- a/mm/cma.c~mm-cma-kill-cma_pages_valid
+++ a/mm/cma.c
@@ -942,36 +942,6 @@ struct folio *cma_alloc_folio(struct cma
 	return page ? page_folio(page) : NULL;
 }
 
-bool cma_pages_valid(struct cma *cma, const struct page *pages,
-		     unsigned long count)
-{
-	unsigned long pfn, end;
-	int r;
-	struct cma_memrange *cmr;
-	bool ret;
-
-	if (!cma || !pages || count > cma->count)
-		return false;
-
-	pfn = page_to_pfn(pages);
-	ret = false;
-
-	for (r = 0; r < cma->nranges; r++) {
-		cmr = &cma->ranges[r];
-		end = cmr->base_pfn + cmr->count;
-		if (pfn >= cmr->base_pfn && pfn < end) {
-			ret = pfn + count <= end;
-			break;
-		}
-	}
-
-	if (!ret)
-		pr_debug("%s(page %p, count %lu)\n",
-				__func__, (void *)pages, count);
-
-	return ret;
-}
-
 /**
  * cma_release() - release allocated pages
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -991,23 +961,27 @@ bool cma_release(struct cma *cma, const
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
-	if (!cma_pages_valid(cma, pages, count))
+	if (!cma || !pages || count > cma->count)
 		return false;
 
 	pfn = page_to_pfn(pages);
-	end_pfn = pfn + count;
 
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
-		if (pfn >= cmr->base_pfn &&
-		    pfn < (cmr->base_pfn + cmr->count)) {
-			VM_BUG_ON(end_pfn > cmr->base_pfn + cmr->count);
-			break;
+		end_pfn = cmr->base_pfn + cmr->count;
+		if (pfn >= cmr->base_pfn && pfn < end_pfn) {
+			if (pfn + count <= end_pfn)
+				break;
+
+			VM_WARN_ON_ONCE(1);
 		}
 	}
 
-	if (r == cma->nranges)
+	if (r == cma->nranges) {
+		pr_debug("%s(page %p, count %lu, no cma range matches the page range)\n",
+			 __func__, (void *)pages, count);
 		return false;
+	}
 
 	free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

