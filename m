Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D760F3D988
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060074; cv=none; b=PTH5YBSktntQY/9WSzbddtut5WL+8fkimzBs9IvSgUn0MAyOFyT5riXfjx9d20d9qEIRq+yaVZkYCCBnLKGXMms4u8CCNwxdk/NwM8F7AqMHGC3FpIhIt4fAx2qDBLJJ2IQ8cm5dotIjvnwbeZp7cEe65zt6ZCZJTtbJQqJ0g88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060074; c=relaxed/simple;
	bh=ea0i9YpK80J2uam33VHr0KsnMta7iCnM0/G7ZlISldo=;
	h=Date:To:From:Subject:Message-Id; b=g7EEsziDRbVGZKtAU9rwO+HmaGGrVxfJnH7XtFDDIT0RvLTIVFsILLceVR+tKAR82WqKy5tCakjO04hLzH3S0KT0VXmKOYGlGWMyQ7mdjKK4fPuAOVcsHGe1BiLIMc9u7RPNYxaEduOpg4Fw7bhog2LyHyLcApMXadC7NSgFhqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fud+m/dR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fud+m/dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D964C433F1;
	Tue, 27 Feb 2024 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709060074;
	bh=ea0i9YpK80J2uam33VHr0KsnMta7iCnM0/G7ZlISldo=;
	h=Date:To:From:Subject:From;
	b=Fud+m/dR6GsZxoGjvdhlid3UVZmlrkZx2NjG7PxaEEY0fkACyLLZNWt1D7zM4sFF7
	 pADIb0xdgeiTaIG7ZjbTXC2KN5UosajX7f5ZnTuYKlK3XFKxYGQDS2LjOE7fiyF2mz
	 fVlGkGgDGnbTzpBStaZRXQlstB94neGvbAldTN68=
Date: Tue, 27 Feb 2024 10:54:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,jianfeng.w.wang@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-convert-cma_alloc-to-return-folio.patch added to mm-unstable branch
Message-Id: <20240227185434.4D964C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: convert cma_alloc() to return folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-convert-cma_alloc-to-return-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-convert-cma_alloc-to-return-folio.patch

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
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Subject: mm/cma: convert cma_alloc() to return folio
Date: Tue, 27 Feb 2024 10:13:38 -0800

Change cma_alloc() to return struct folio.  This further increases the
usage of folios in mm/hugetlb.

Link: https://lkml.kernel.org/r/20240227181338.59932-1-jianfeng.w.wang@oracle.com
Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_builtin.c |    6 ++++--
 drivers/dma-buf/heaps/cma_heap.c     |   18 +++++++++---------
 drivers/s390/char/vmcp.c             |    8 ++++----
 include/linux/cma.h                  |    3 ++-
 kernel/dma/contiguous.c              |    8 ++++++--
 mm/cma.c                             |    4 ++--
 mm/cma_debug.c                       |    6 +++---
 mm/hugetlb.c                         |   13 +++++++------
 8 files changed, 37 insertions(+), 29 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_builtin.c~mm-cma-convert-cma_alloc-to-return-folio
+++ a/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -57,10 +57,12 @@ early_param("kvm_cma_resv_ratio", early_
 
 struct page *kvm_alloc_hpt_cma(unsigned long nr_pages)
 {
+	struct folio *folio;
 	VM_BUG_ON(order_base_2(nr_pages) < KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
 
-	return cma_alloc(kvm_cma, nr_pages, order_base_2(HPT_ALIGN_PAGES),
-			 false);
+	folio = cma_alloc(kvm_cma, nr_pages, order_base_2(HPT_ALIGN_PAGES),
+			false);
+	return folio ? &folio->page : NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_alloc_hpt_cma);
 
--- a/drivers/dma-buf/heaps/cma_heap.c~mm-cma-convert-cma_alloc-to-return-folio
+++ a/drivers/dma-buf/heaps/cma_heap.c
@@ -283,7 +283,7 @@ static struct dma_buf *cma_heap_allocate
 	size_t size = PAGE_ALIGN(len);
 	pgoff_t pagecount = size >> PAGE_SHIFT;
 	unsigned long align = get_order(size);
-	struct page *cma_pages;
+	struct folio *cma_folios;
 	struct dma_buf *dmabuf;
 	int ret = -ENOMEM;
 	pgoff_t pg;
@@ -299,14 +299,14 @@ static struct dma_buf *cma_heap_allocate
 	if (align > CONFIG_CMA_ALIGNMENT)
 		align = CONFIG_CMA_ALIGNMENT;
 
-	cma_pages = cma_alloc(cma_heap->cma, pagecount, align, false);
-	if (!cma_pages)
+	cma_folios = cma_alloc(cma_heap->cma, pagecount, align, false);
+	if (!cma_folios)
 		goto free_buffer;
 
 	/* Clear the cma pages */
-	if (PageHighMem(cma_pages)) {
+	if (folio_test_highmem(cma_folios)) {
 		unsigned long nr_clear_pages = pagecount;
-		struct page *page = cma_pages;
+		struct page *page = &cma_folios->page;
 
 		while (nr_clear_pages > 0) {
 			void *vaddr = kmap_atomic(page);
@@ -323,7 +323,7 @@ static struct dma_buf *cma_heap_allocate
 			nr_clear_pages--;
 		}
 	} else {
-		memset(page_address(cma_pages), 0, size);
+		memset(folio_address(cma_folios), 0, size);
 	}
 
 	buffer->pages = kmalloc_array(pagecount, sizeof(*buffer->pages), GFP_KERNEL);
@@ -333,9 +333,9 @@ static struct dma_buf *cma_heap_allocate
 	}
 
 	for (pg = 0; pg < pagecount; pg++)
-		buffer->pages[pg] = &cma_pages[pg];
+		buffer->pages[pg] = &cma_folios[pg].page;
 
-	buffer->cma_pages = cma_pages;
+	buffer->cma_pages = &cma_folios->page;
 	buffer->heap = cma_heap;
 	buffer->pagecount = pagecount;
 
@@ -355,7 +355,7 @@ static struct dma_buf *cma_heap_allocate
 free_pages:
 	kfree(buffer->pages);
 free_cma:
-	cma_release(cma_heap->cma, cma_pages, pagecount);
+	cma_release(cma_heap->cma, &cma_folios->page, pagecount);
 free_buffer:
 	kfree(buffer);
 
--- a/drivers/s390/char/vmcp.c~mm-cma-convert-cma_alloc-to-return-folio
+++ a/drivers/s390/char/vmcp.c
@@ -59,7 +59,7 @@ void __init vmcp_cma_reserve(void)
 
 static void vmcp_response_alloc(struct vmcp_session *session)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	int nr_pages, order;
 
 	order = get_order(session->bufsize);
@@ -70,9 +70,9 @@ static void vmcp_response_alloc(struct v
 	 * anymore the system won't work anyway.
 	 */
 	if (order > 2)
-		page = cma_alloc(vmcp_cma, nr_pages, 0, false);
-	if (page) {
-		session->response = (char *)page_to_virt(page);
+		folio = cma_alloc(vmcp_cma, nr_pages, 0, false);
+	if (folio) {
+		session->response = (char *)page_to_virt(&folio->page);
 		session->cma_alloc = 1;
 		return;
 	}
--- a/include/linux/cma.h~mm-cma-convert-cma_alloc-to-return-folio
+++ a/include/linux/cma.h
@@ -21,6 +21,7 @@
 #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
 
 struct cma;
+struct page;
 
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
@@ -44,7 +45,7 @@ extern int cma_init_reserved_mem(phys_ad
 					unsigned int order_per_bit,
 					const char *name,
 					struct cma **res_cma);
-extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
+extern struct folio *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
 extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
--- a/kernel/dma/contiguous.c~mm-cma-convert-cma_alloc-to-return-folio
+++ a/kernel/dma/contiguous.c
@@ -304,10 +304,12 @@ int __init dma_contiguous_reserve_area(p
 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
 				       unsigned int align, bool no_warn)
 {
+	struct folio *folio;
 	if (align > CONFIG_CMA_ALIGNMENT)
 		align = CONFIG_CMA_ALIGNMENT;
 
-	return cma_alloc(dev_get_cma_area(dev), count, align, no_warn);
+	folio = cma_alloc(dev_get_cma_area(dev), count, align, no_warn);
+	return folio ? &folio->page : NULL;
 }
 
 /**
@@ -328,9 +330,11 @@ bool dma_release_from_contiguous(struct
 
 static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
 {
+	struct folio *folio;
 	unsigned int align = min(get_order(size), CONFIG_CMA_ALIGNMENT);
 
-	return cma_alloc(cma, size >> PAGE_SHIFT, align, gfp & __GFP_NOWARN);
+	folio = cma_alloc(cma, size >> PAGE_SHIFT, align, gfp & __GFP_NOWARN);
+	return folio ? &folio->page : NULL;
 }
 
 /**
--- a/mm/cma.c~mm-cma-convert-cma_alloc-to-return-folio
+++ a/mm/cma.c
@@ -417,7 +417,7 @@ static void cma_debug_show_areas(struct
  * This function allocates part of contiguous memory on specific
  * contiguous memory area.
  */
-struct page *cma_alloc(struct cma *cma, unsigned long count,
+struct folio *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
 {
 	unsigned long mask, offset;
@@ -514,7 +514,7 @@ struct page *cma_alloc(struct cma *cma,
 		cma_sysfs_account_fail_pages(cma, count);
 	}
 
-	return page;
+	return page ? page_folio(page) : NULL;
 }
 
 bool cma_pages_valid(struct cma *cma, const struct page *pages,
--- a/mm/cma_debug.c~mm-cma-convert-cma_alloc-to-return-folio
+++ a/mm/cma_debug.c
@@ -131,14 +131,14 @@ DEFINE_DEBUGFS_ATTRIBUTE(cma_free_fops,
 static int cma_alloc_mem(struct cma *cma, int count)
 {
 	struct cma_mem *mem;
-	struct page *p;
+	struct folio *folio;
 
 	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
 	if (!mem)
 		return -ENOMEM;
 
-	p = cma_alloc(cma, count, 0, false);
-	if (!p) {
+	folio = cma_alloc(cma, count, 0, false);
+	if (!folio) {
 		kfree(mem);
 		return -ENOMEM;
 	}
--- a/mm/hugetlb.c~mm-cma-convert-cma_alloc-to-return-folio
+++ a/mm/hugetlb.c
@@ -1572,13 +1572,14 @@ static struct folio *alloc_gigantic_foli
 
 #ifdef CONFIG_CMA
 	{
+		struct folio *folio;
 		int node;
 
 		if (hugetlb_cma[nid]) {
-			page = cma_alloc(hugetlb_cma[nid], nr_pages,
+			folio = cma_alloc(hugetlb_cma[nid], nr_pages,
 					huge_page_order(h), true);
-			if (page)
-				return page_folio(page);
+			if (folio)
+				return folio;
 		}
 
 		if (!(gfp_mask & __GFP_THISNODE)) {
@@ -1586,10 +1587,10 @@ static struct folio *alloc_gigantic_foli
 				if (node == nid || !hugetlb_cma[node])
 					continue;
 
-				page = cma_alloc(hugetlb_cma[node], nr_pages,
+				folio = cma_alloc(hugetlb_cma[node], nr_pages,
 						huge_page_order(h), true);
-				if (page)
-					return page_folio(page);
+				if (folio)
+					return folio;
 			}
 		}
 	}
_

Patches currently in -mm which might be from jianfeng.w.wang@oracle.com are

mm-cma-convert-cma_alloc-to-return-folio.patch

