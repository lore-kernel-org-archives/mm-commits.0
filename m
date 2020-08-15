Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9ADC433E3
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CAD52063A
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529585;
	bh=RaErheH0wBZzO3v8LJYi30xc71jA3roWtfjwy+QC7SQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Y4uS8zOHs70GGKTkHzSRSEH3OQwc6hsDu2XlwuEqTFNYy6AJnveo8cbC8H61ewEkG
	 WzvpwZbo/d9amJQWC4y6weF8TB7tepvl8raKxKMUp3/9z7AiOa00sLPxbPvGS+LG7q
	 w2VymYyItKy7brm/r+ccP72wWsgSMPnoYQzINBMY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgHOWK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbgHOWKZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A49022C9E;
        Sat, 15 Aug 2020 00:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451434;
        bh=RaErheH0wBZzO3v8LJYi30xc71jA3roWtfjwy+QC7SQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fG0mKbWrUwsqFB/DdLyk7OLsCDR0T3gfWhUb2HCNYe1IYx+FOWQUjTYSOqr9X3YxV
         0XbLc7EM/x9lNaNdeyauzvuPJpEVkQiHMcGHKKtniPtxnWW/ByXVziQmvVqmxnY4Kg
         NLD5XP2KJzz5jwrWDZfy9lYGh2rKrvxtj6dnqmbw=
Date:   Fri, 14 Aug 2020 17:30:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 10/39] mm: add thp_size
Message-ID: <20200815003033.ExVW4LEAX%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add thp_size

This function returns the number of bytes in a THP.  It is like
page_size(), but compiles to just PAGE_SIZE if CONFIG_TRANSPARENT_HUGEPAGE
is disabled.

Link: http://lkml.kernel.org/r/20200629151959.15779-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/btt.c    |    4 +---
 drivers/nvdimm/pmem.c   |    6 ++----
 include/linux/huge_mm.h |   11 +++++++++++
 mm/internal.h           |    2 +-
 mm/page_io.c            |    2 +-
 mm/page_vma_mapped.c    |    4 ++--
 6 files changed, 18 insertions(+), 11 deletions(-)

--- a/drivers/nvdimm/btt.c~mm-add-thp_size
+++ a/drivers/nvdimm/btt.c
@@ -1490,10 +1490,8 @@ static int btt_rw_page(struct block_devi
 {
 	struct btt *btt = bdev->bd_disk->private_data;
 	int rc;
-	unsigned int len;
 
-	len = hpage_nr_pages(page) * PAGE_SIZE;
-	rc = btt_do_bvec(btt, NULL, page, len, 0, op, sector);
+	rc = btt_do_bvec(btt, NULL, page, thp_size(page), 0, op, sector);
 	if (rc == 0)
 		page_endio(page, op_is_write(op), 0);
 
--- a/drivers/nvdimm/pmem.c~mm-add-thp_size
+++ a/drivers/nvdimm/pmem.c
@@ -238,11 +238,9 @@ static int pmem_rw_page(struct block_dev
 	blk_status_t rc;
 
 	if (op_is_write(op))
-		rc = pmem_do_write(pmem, page, 0, sector,
-				   hpage_nr_pages(page) * PAGE_SIZE);
+		rc = pmem_do_write(pmem, page, 0, sector, thp_size(page));
 	else
-		rc = pmem_do_read(pmem, page, 0, sector,
-				   hpage_nr_pages(page) * PAGE_SIZE);
+		rc = pmem_do_read(pmem, page, 0, sector, thp_size(page));
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
 	 * retries on any error, so we can only invoke page_endio() in
--- a/include/linux/huge_mm.h~mm-add-thp_size
+++ a/include/linux/huge_mm.h
@@ -462,4 +462,15 @@ static inline bool thp_migration_support
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+/**
+ * thp_size - Size of a transparent huge page.
+ * @page: Head page of a transparent huge page.
+ *
+ * Return: Number of bytes in this page.
+ */
+static inline unsigned long thp_size(struct page *page)
+{
+	return PAGE_SIZE << thp_order(page);
+}
+
 #endif /* _LINUX_HUGE_MM_H */
--- a/mm/internal.h~mm-add-thp_size
+++ a/mm/internal.h
@@ -396,7 +396,7 @@ vma_address(struct page *page, struct vm
 	unsigned long start, end;
 
 	start = __vma_address(page, vma);
-	end = start + PAGE_SIZE * (hpage_nr_pages(page) - 1);
+	end = start + thp_size(page) - PAGE_SIZE;
 
 	/* page should be within @vma mapping range */
 	VM_BUG_ON_VMA(end < vma->vm_start || start >= vma->vm_end, vma);
--- a/mm/page_io.c~mm-add-thp_size
+++ a/mm/page_io.c
@@ -40,7 +40,7 @@ static struct bio *get_swap_bio(gfp_t gf
 		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_end_io = end_io;
 
-		bio_add_page(bio, page, PAGE_SIZE * hpage_nr_pages(page), 0);
+		bio_add_page(bio, page, thp_size(page), 0);
 	}
 	return bio;
 }
--- a/mm/page_vma_mapped.c~mm-add-thp_size
+++ a/mm/page_vma_mapped.c
@@ -227,7 +227,7 @@ next_pte:
 			if (pvmw->address >= pvmw->vma->vm_end ||
 			    pvmw->address >=
 					__vma_address(pvmw->page, pvmw->vma) +
-					hpage_nr_pages(pvmw->page) * PAGE_SIZE)
+					thp_size(pvmw->page))
 				return not_found(pvmw);
 			/* Did we cross page table boundary? */
 			if (pvmw->address % PMD_SIZE == 0) {
@@ -268,7 +268,7 @@ int page_mapped_in_vma(struct page *page
 	unsigned long start, end;
 
 	start = __vma_address(page, vma);
-	end = start + PAGE_SIZE * (hpage_nr_pages(page) - 1);
+	end = start + thp_size(page) - PAGE_SIZE;
 
 	if (unlikely(end < vma->vm_start || start >= vma->vm_end))
 		return 0;
_
