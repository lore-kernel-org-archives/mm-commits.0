From: akpm@linux-foundation.org
Subject: + mm-cma-constify-and-use-correct-signness-in-mm-cmac.patch added to -mm tree
Date: Mon, 02 Mar 2015 15:28:12 -0800
Message-ID: <54f4f20c.DIwOcwv3STklEjHQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbbCBX2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 18:28:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, gregory.0xf0@gmail.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, pintu.k@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: constify and use correct signness in mm/cma.c
has been added to the -mm tree.  Its filename is
     mm-cma-constify-and-use-correct-signness-in-mm-cmac.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-constify-and-use-correct-signness-in-mm-cmac.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-constify-and-use-correct-signness-in-mm-cmac.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: cma: constify and use correct signness in mm/cma.c

Constify function parameters and use correct signness where needed.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Gregory Fong <gregory.0xf0@gmail.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |   12 ++++++------
 mm/cma.c            |   24 ++++++++++++++----------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff -puN include/linux/cma.h~mm-cma-constify-and-use-correct-signness-in-mm-cmac include/linux/cma.h
--- a/include/linux/cma.h~mm-cma-constify-and-use-correct-signness-in-mm-cmac
+++ a/include/linux/cma.h
@@ -16,16 +16,16 @@
 struct cma;
 
 extern unsigned long totalcma_pages;
-extern phys_addr_t cma_get_base(struct cma *cma);
-extern unsigned long cma_get_size(struct cma *cma);
+extern phys_addr_t cma_get_base(const struct cma *cma);
+extern unsigned long cma_get_size(const struct cma *cma);
 
 extern int __init cma_declare_contiguous(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
 			bool fixed, struct cma **res_cma);
-extern int cma_init_reserved_mem(phys_addr_t base,
-					phys_addr_t size, int order_per_bit,
+extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+					unsigned int order_per_bit,
 					struct cma **res_cma);
-extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
-extern bool cma_release(struct cma *cma, struct page *pages, int count);
+extern struct page *cma_alloc(struct cma *cma, unsigned int count, unsigned int align);
+extern bool cma_release(struct cma *cma, const struct page *pages, unsigned int count);
 #endif
diff -puN mm/cma.c~mm-cma-constify-and-use-correct-signness-in-mm-cmac mm/cma.c
--- a/mm/cma.c~mm-cma-constify-and-use-correct-signness-in-mm-cmac
+++ a/mm/cma.c
@@ -41,17 +41,18 @@ struct cma cma_areas[MAX_CMA_AREAS];
 unsigned cma_area_count;
 static DEFINE_MUTEX(cma_mutex);
 
-phys_addr_t cma_get_base(struct cma *cma)
+phys_addr_t cma_get_base(const struct cma *cma)
 {
 	return PFN_PHYS(cma->base_pfn);
 }
 
-unsigned long cma_get_size(struct cma *cma)
+unsigned long cma_get_size(const struct cma *cma)
 {
 	return cma->count << PAGE_SHIFT;
 }
 
-static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
+static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
+					     int align_order)
 {
 	if (align_order <= cma->order_per_bit)
 		return 0;
@@ -62,7 +63,8 @@ static unsigned long cma_bitmap_aligned_
  * Find a PFN aligned to the specified order and return an offset represented in
  * order_per_bits.
  */
-static unsigned long cma_bitmap_aligned_offset(struct cma *cma, int align_order)
+static unsigned long cma_bitmap_aligned_offset(const struct cma *cma,
+					       int align_order)
 {
 	if (align_order <= cma->order_per_bit)
 		return 0;
@@ -71,13 +73,14 @@ static unsigned long cma_bitmap_aligned_
 		- cma->base_pfn) >> cma->order_per_bit;
 }
 
-static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
-						unsigned long pages)
+static unsigned long cma_bitmap_pages_to_bits(const struct cma *cma,
+					      unsigned long pages)
 {
 	return ALIGN(pages, 1UL << cma->order_per_bit) >> cma->order_per_bit;
 }
 
-static void cma_clear_bitmap(struct cma *cma, unsigned long pfn, int count)
+static void cma_clear_bitmap(struct cma *cma, unsigned long pfn,
+			     unsigned int count)
 {
 	unsigned long bitmap_no, bitmap_count;
 
@@ -162,7 +165,8 @@ core_initcall(cma_init_reserved_areas);
  * This function creates custom contiguous area from already reserved memory.
  */
 int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
-				 int order_per_bit, struct cma **res_cma)
+					unsigned int order_per_bit,
+				 	struct cma **res_cma)
 {
 	struct cma *cma;
 	phys_addr_t alignment;
@@ -353,7 +357,7 @@ err:
  * This function allocates part of contiguous memory on specific
  * contiguous memory area.
  */
-struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
+struct page *cma_alloc(struct cma *cma, unsigned int count, unsigned int align)
 {
 	unsigned long mask, offset, pfn, start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
@@ -424,7 +428,7 @@ struct page *cma_alloc(struct cma *cma,
  * It returns false when provided pages do not belong to contiguous area and
  * true otherwise.
  */
-bool cma_release(struct cma *cma, struct page *pages, int count)
+bool cma_release(struct cma *cma, const struct page *pages, unsigned int count)
 {
 	unsigned long pfn;
 
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-release-trigger-fixpatch.patch
mm-cma-allocation-trigger-fix.patch
cma-debug-document-new-debugfs-interface.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-cma-constify-and-use-correct-signness-in-mm-cmac.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

