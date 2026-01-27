Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2283191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486698; cv=none; b=nEtVb/240ClM4vk+oOBfgwP2LwInMUmdoyvFLgEf/xwEqlltZcqrXgzCn24TGrvlr6qIApsbzHACPq9VtdesAiEs2GoycZiwnoLy8qzL7fGvczDApjdnKrkPyGijrJz0VRDFdC2OowXux9ZmcZ21aKZpt+Fl6W1lCyAsMdNqJ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486698; c=relaxed/simple;
	bh=wmglTrKzmdzf+Su74rSEJujLdZitXtc+FExtBXTGfxQ=;
	h=Date:To:From:Subject:Message-Id; b=aI/dBKAvZiEGVC0KXaQ1W56nW8Owfw26ciOsHPCHOStcpriwKNpWsJVzmm5o7uXRgbAzZ6kjh7eMIvrrlFIDTjCIsgZb+cxy18nTlmRzK9ZE5jbOFTWp8z0DSQC07+oNq0C0mfgzC4T3aNHTx4iBFBnGo6QNbEpn7fGLCnCdgRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sKw6+25q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sKw6+25q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA06C116C6;
	Tue, 27 Jan 2026 04:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486697;
	bh=wmglTrKzmdzf+Su74rSEJujLdZitXtc+FExtBXTGfxQ=;
	h=Date:To:From:Subject:From;
	b=sKw6+25qupBNkljOY6wfadnSw/u9xmjfQbpHSUTf2Z+C2TWag4ltSCI8/7w9N5aSw
	 ZdlcJr5fy36DEsBMqAvbC3XdOERRKrE50UuGrINPtbuRtJc/vgBHdk8/9wBMHWPpDU
	 Jon921TbXk+yA6WjQ3lkFDZTT/wQkUIQBwicKtqo=
Date: Mon, 26 Jan 2026 20:04:57 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,claudiu.beznea.uj@bp.renesas.com,broonie@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-kill-cma_pages_valid.patch removed from -mm tree
Message-Id: <20260127040457.CEA06C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cma: kill cma_pages_valid()
has been removed from the -mm tree.  Its filename was
     mm-cma-kill-cma_pages_valid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_isolation-introduce-page_is_unmovable.patch
mm-page_alloc-optimize-pfn_range_valid_contig.patch
mm-hugetlb-optimize-replace_free_hugepage_folios.patch
mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

