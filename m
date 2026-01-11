Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B43D1925BC
	for <mm-commits@vger.kernel.org>; Sun, 11 Jan 2026 01:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768096681; cv=none; b=L3ehpvGJ1YUw1kDlC8IHaVK7Ln1NatuTsjhWb7S07PWMwyeNxW90quMPcMV4WGQN1vGX7ZIispIvwP48kBys2Jno0oKG+h0qVp3LDsoGQhv9a0CRo/YbD2XKkTGaJoZTkWsPe15R1sPmOLtR4G5nT2PqyxFT5I01/6//YWAQY0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768096681; c=relaxed/simple;
	bh=i2IOwRZDlBWXFXygZBKV8hG4Ux08ktObdwN1jwtsLiQ=;
	h=Date:To:From:Subject:Message-Id; b=RAACnWggEP8tWmKDzxIDzhgpZ9Ry4K1UVKb2N71yFVMw21oUcS2CNnX1LP/jARM+obe2YyhdMKU/IYrfgOdOE4dggKW4YAhJd+LVPceuNzEOGtN9dQw7DxhVyVeKwLbrhepX89epTaPqv2myAKz0fmh4IouGPRNxpk/ZG8OoIxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M2bNfjq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M2bNfjq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CC3C4CEF1;
	Sun, 11 Jan 2026 01:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768096680;
	bh=i2IOwRZDlBWXFXygZBKV8hG4Ux08ktObdwN1jwtsLiQ=;
	h=Date:To:From:Subject:From;
	b=M2bNfjq1/jNkiiIEePMChFaPM0r8gx90ZPgqsr3kyQu72o0ISKQB2Q/fnyP48yPjb
	 KNesWNeO4Eo7/Z83xQ5yy0CWP1yBrPfab3tLOfzB8xgr38yjqlqQOhprSkNulClo03
	 8ogGMvnZHW1fdapyWOM0DnwQazQ5AbztMM5HTJ/Q=
Date: Sat, 10 Jan 2026 17:58:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,claudiu.beznea.uj@bp.renesas.com,broonie@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-kill-cma_pages_valid.patch added to mm-new branch
Message-Id: <20260111015800.C8CC3C4CEF1@smtp.kernel.org>
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
Date: Fri, 9 Jan 2026 17:31:33 +0800

Kill cma_pages_valid() which only used in cma_release(), also cleanup code
duplication between cma pages valid checking and cma memrange finding.

Link: https://lkml.kernel.org/r/20260109093136.1491549-4-wangkefeng.wang@huawei.com
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
Cc: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Cc: Mark Brown <broonie@kernel.org>
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

