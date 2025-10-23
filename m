Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F2028E00
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250208; cv=none; b=PrsBxFg7NDByOWuWvDQw18JySmNXgG3JuyTOPS0YnfTosfE0YdRCeMKy9e7Hywc7L/IvgtNfJLVoVqTFQhr6yiNBLqpsQXRg7+jLQpvAdDAUkdmMWuZJ6ql3jI7CMYC2FoTsq8FJ4QlNGQpmDJoQwE+1+bDhDJ1JKWSsdshMotY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250208; c=relaxed/simple;
	bh=NFNB+hOYVoGJ0Ud8aMVRwpuUu1URuf7mY3QA5iYh8N0=;
	h=Date:To:From:Subject:Message-Id; b=k/DCcqsSaLH/Lj4W1sSsC7bvdKMdKGePH8UkR3vKLRbEWNAt21pEaAyKB5NQvwO2IgetwOTy0KYsNIajOwViH9IB7/zQw13d0XJKU48C2B8ejU/61Nl7I4aRPoln2IrMrihUJjm9WQ2OXQZuJNl/aHZbRsrxHMlZfptqglO2PnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mCw/s/2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mCw/s/2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6FFC4CEE7;
	Thu, 23 Oct 2025 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761250206;
	bh=NFNB+hOYVoGJ0Ud8aMVRwpuUu1URuf7mY3QA5iYh8N0=;
	h=Date:To:From:Subject:From;
	b=mCw/s/2cnIEofuUExPTth0yHk1zZEja1ztyzRpKkyfRCT6vm+Oy/64YW9eTq+e1PU
	 cOOhyI0aTNmtCwS7drWIwTppu/8bzo3kYp3CANn/7c+53qwCofyNbM3q3SIRG73qLk
	 WavjMRauc6PgdPrnSUbCZFPWGmuywy33n2f2lzd8=
Date: Thu, 23 Oct 2025 13:10:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-__cma_release.patch added to mm-new branch
Message-Id: <20251023201006.DC6FFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cma: add __cma_release()
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-add-__cma_release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-add-__cma_release.patch

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
Subject: mm: cma: add __cma_release()
Date: Thu, 23 Oct 2025 19:59:37 +0800

Kill cma_pages_valid() which only used in cma_release(), also cleanup code
duplication between cma pages valid checking and cma memrange finding, add
__cma_release() helper to prepare for the upcoming frozen page release.

Link: https://lkml.kernel.org/r/20251023115940.3573158-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    1 
 mm/cma.c            |   62 ++++++++++++++----------------------------
 2 files changed, 21 insertions(+), 42 deletions(-)

--- a/include/linux/cma.h~mm-cma-add-__cma_release
+++ a/include/linux/cma.h
@@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_ad
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
-extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
--- a/mm/cma.c~mm-cma-add-__cma_release
+++ a/mm/cma.c
@@ -942,34 +942,43 @@ struct folio *cma_alloc_folio(struct cma
 	return page ? page_folio(page) : NULL;
 }
 
-bool cma_pages_valid(struct cma *cma, const struct page *pages,
-		     unsigned long count)
+static bool __cma_release(struct cma *cma, const struct page *pages,
+			  unsigned long count)
 {
 	unsigned long pfn, end;
 	int r;
 	struct cma_memrange *cmr;
-	bool ret;
+
+	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
 	if (!cma || !pages || count > cma->count)
 		return false;
 
 	pfn = page_to_pfn(pages);
-	ret = false;
 
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 		end = cmr->base_pfn + cmr->count;
 		if (pfn >= cmr->base_pfn && pfn < end) {
-			ret = pfn + count <= end;
-			break;
+			if (pfn + count <= end)
+				break;
+
+			VM_WARN_ON_ONCE(1);
 		}
 	}
 
-	if (!ret)
-		pr_debug("%s(page %p, count %lu)\n",
-				__func__, (void *)pages, count);
+	if (r == cma->nranges) {
+		pr_debug("%s(page %p, count %lu, no cma range matches the page range)\n",
+			 __func__, (void *)pages, count);
+		return false;
+	}
 
-	return ret;
+	free_contig_range(pfn, count);
+	cma_clear_bitmap(cma, cmr, pfn, count);
+	cma_sysfs_account_release_pages(cma, count);
+	trace_cma_release(cma->name, pfn, pages, count);
+
+	return true;
 }
 
 /**
@@ -985,36 +994,7 @@ bool cma_pages_valid(struct cma *cma, co
 bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
-	struct cma_memrange *cmr;
-	unsigned long pfn, end_pfn;
-	int r;
-
-	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
-
-	if (!cma_pages_valid(cma, pages, count))
-		return false;
-
-	pfn = page_to_pfn(pages);
-	end_pfn = pfn + count;
-
-	for (r = 0; r < cma->nranges; r++) {
-		cmr = &cma->ranges[r];
-		if (pfn >= cmr->base_pfn &&
-		    pfn < (cmr->base_pfn + cmr->count)) {
-			VM_BUG_ON(end_pfn > cmr->base_pfn + cmr->count);
-			break;
-		}
-	}
-
-	if (r == cma->nranges)
-		return false;
-
-	free_contig_range(pfn, count);
-	cma_clear_bitmap(cma, cmr, pfn, count);
-	cma_sysfs_account_release_pages(cma, count);
-	trace_cma_release(cma->name, pfn, pages, count);
-
-	return true;
+	return __cma_release(cma, pages, count);
 }
 
 bool cma_free_folio(struct cma *cma, const struct folio *folio)
@@ -1022,7 +1002,7 @@ bool cma_free_folio(struct cma *cma, con
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
 
-	return cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch
mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-add-__cma_release.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

