From: akpm@linux-foundation.org
Subject: [merged]
 mm-cma-print-allocation-failure-reason-and-bitmap-status.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:27:02 -0800
Message-ID: <58b48b96.x65ajnrBClo54CXs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaewon31.kim@samsung.com, iamjoonsoo.kim@lge.com, labbott@redhat.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: print allocation failure reason and bitmap status
has been removed from the -mm tree.  Its filename was
     mm-cma-print-allocation-failure-reason-and-bitmap-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: mm: cma: print allocation failure reason and bitmap status

There are many reasons of CMA allocation failure such as EBUSY, ENOMEM,
EINTR.  But we did not know error reason so far.  This patch prints the
error value.

Additionally if CONFIG_CMA_DEBUG is enabled, this patch shows bitmap
status to know available pages.  Actually CMA internally tries on all
available regions because some regions can be failed because of EBUSY. 
Bitmap status is useful to know in detail on both ENONEM and EBUSY;

 ENOMEM: not tried at all because of no available region
         it could be too small total region or could be fragmentation issue
 EBUSY:  tried some region but all failed

This is an ENOMEM example with this patch.
[   12.415458]  [2:   Binder:714_1:  744] cma: cma_alloc: alloc failed, req-size: 256 pages, ret: -12

If CONFIG_CMA_DEBUG is enabled, avabile pages also will be shown as
concatenated size@position format.  So 4@572 means that there are 4
available pages at 572 position starting from 0 position.
[   12.415503]  [2:   Binder:714_1:  744] cma: number of available pages: 4@572+7@585+7@601+8@632+38@730+166@1114+127@1921=> 357 free of 2048 total pages

Link: http://lkml.kernel.org/r/1485909785-3952-1-git-send-email-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff -puN mm/cma.c~mm-cma-print-allocation-failure-reason-and-bitmap-status mm/cma.c
--- a/mm/cma.c~mm-cma-print-allocation-failure-reason-and-bitmap-status
+++ a/mm/cma.c
@@ -348,6 +348,32 @@ err:
 	return ret;
 }
 
+#ifdef CONFIG_CMA_DEBUG
+static void cma_debug_show_areas(struct cma *cma)
+{
+	unsigned long next_zero_bit, next_set_bit;
+	unsigned long start = 0;
+	unsigned int nr_zero, nr_total = 0;
+
+	mutex_lock(&cma->lock);
+	pr_info("number of available pages: ");
+	for (;;) {
+		next_zero_bit = find_next_zero_bit(cma->bitmap, cma->count, start);
+		if (next_zero_bit >= cma->count)
+			break;
+		next_set_bit = find_next_bit(cma->bitmap, cma->count, next_zero_bit);
+		nr_zero = next_set_bit - next_zero_bit;
+		pr_cont("%s%u@%lu", nr_total ? "+" : "", nr_zero, next_zero_bit);
+		nr_total += nr_zero;
+		start = next_zero_bit + nr_zero;
+	}
+	pr_cont("=> %u free of %lu total pages\n", nr_total, cma->count);
+	mutex_unlock(&cma->lock);
+}
+#else
+static inline void cma_debug_show_areas(struct cma *cma) { }
+#endif
+
 /**
  * cma_alloc() - allocate pages from contiguous area
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -365,7 +391,7 @@ struct page *cma_alloc(struct cma *cma,
 	unsigned long start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
 	struct page *page = NULL;
-	int ret;
+	int ret = -ENOMEM;
 
 	if (!cma || !cma->count)
 		return NULL;
@@ -423,6 +449,12 @@ struct page *cma_alloc(struct cma *cma,
 
 	trace_cma_alloc(pfn, page, count, align);
 
+	if (ret) {
+		pr_info("%s: alloc failed, req-size: %zu pages, ret: %d\n",
+			__func__, count, ret);
+		cma_debug_show_areas(cma);
+	}
+
 	pr_debug("%s(): returned %p\n", __func__, page);
 	return page;
 }
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are


