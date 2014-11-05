From: akpm@linux-foundation.org
Subject: + mm-cma-align-to-physical-address-not-cma-region-position.patch
 added to -mm tree
Date: Wed, 05 Nov 2014 13:53:23 -0800
Message-ID: <545a9c53.+fQzEXd5vbMgvoyF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaKEVxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 16:53:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.0xf0@gmail.com, iamjoonsoo.kim@lge.com, kgene.kim@samsung.com, lauraa@codeaurora.org, laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: align to physical address, not CMA region position
has been added to the -mm tree.  Its filename is
     mm-cma-align-to-physical-address-not-cma-region-position.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-align-to-physical-address-not-cma-region-position.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-align-to-physical-address-not-cma-region-position.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gregory Fong <gregory.0xf0@gmail.com>
Subject: mm: cma: align to physical address, not CMA region position

The alignment in cma_alloc() was done w.r.t. the bitmap.  This is a
problem when, for example:

- a device requires 16M (order 12) alignment
- the CMA region is not 16 M aligned

In such a case, can result with the CMA region starting at, say,
0x2f800000 but any allocation you make from there will be aligned from
there.  Requesting an allocation of 32 M with 16 M alignment will result
in an allocation from 0x2f800000 to 0x31800000, which doesn't work very
well if your strange device requires 16M alignment.

Change to use bitmap_find_next_zero_area_off() to account for the

Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN mm/cma.c~mm-cma-align-to-physical-address-not-cma-region-position mm/cma.c
--- a/mm/cma.c~mm-cma-align-to-physical-address-not-cma-region-position
+++ a/mm/cma.c
@@ -63,6 +63,17 @@ static unsigned long cma_bitmap_aligned_
 	return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
+static unsigned long cma_bitmap_aligned_offset(struct cma *cma, int align_order)
+{
+	unsigned int alignment;
+
+	if (align_order <= cma->order_per_bit)
+		return 0;
+	alignment = 1UL << (align_order - cma->order_per_bit);
+	return ALIGN(cma->base_pfn, alignment) -
+		(cma->base_pfn >> cma->order_per_bit);
+}
+
 static unsigned long cma_bitmap_maxno(struct cma *cma)
 {
 	return cma->count >> cma->order_per_bit;
@@ -328,7 +339,7 @@ err:
  */
 struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
 {
-	unsigned long mask, pfn, start = 0;
+	unsigned long mask, offset, pfn, start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
 	struct page *page = NULL;
 	int ret;
@@ -343,13 +354,15 @@ struct page *cma_alloc(struct cma *cma,
 		return NULL;
 
 	mask = cma_bitmap_aligned_mask(cma, align);
+	offset = cma_bitmap_aligned_offset(cma, align);
 	bitmap_maxno = cma_bitmap_maxno(cma);
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 
 	for (;;) {
 		mutex_lock(&cma->lock);
-		bitmap_no = bitmap_find_next_zero_area(cma->bitmap,
-				bitmap_maxno, start, bitmap_count, mask);
+		bitmap_no = bitmap_find_next_zero_area_off(cma->bitmap,
+				bitmap_maxno, start, bitmap_count, mask,
+				offset);
 		if (bitmap_no >= bitmap_maxno) {
 			mutex_unlock(&cma->lock);
 			break;
_

Patches currently in -mm which might be from gregory.0xf0@gmail.com are

lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch

