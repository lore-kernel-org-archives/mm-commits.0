From: akpm@linux-foundation.org
Subject: + mm-add-thp_size.patch added to -mm tree
Date: Tue, 30 Jun 2020 18:39:38 -0700
Message-ID: <20200701013938.Cg1Ce%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgGABjk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 21:39:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ziy@nvidia.com, william.kucharski@oracle.com, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, david@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: add thp_size
has been added to the -mm tree.  Its filename is
     mm-add-thp_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-thp_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-thp_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

vmalloc-convert-to-xarray.patch
mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch
