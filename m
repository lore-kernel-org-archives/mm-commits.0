From: akpm@linux-foundation.org
Subject: [merged] mm-cma-fix-cma-aligned-offset-calculation.patch removed
 from -mm tree
Date: Mon, 16 Mar 2015 11:02:40 -0700
Message-ID: <55071ac0.gcO2wiukJoo9YTUo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbbCPSCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dpetigara@broadcom.com, gregory.0xf0@gmail.com, mina86@mina86.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix CMA aligned offset calculation
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-cma-aligned-offset-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Danesh Petigara <dpetigara@broadcom.com>
Subject: mm: cma: fix CMA aligned offset calculation

The CMA aligned offset calculation is incorrect for non-zero order_per_bit
values.

For example, if cma->order_per_bit=1, cma->base_pfn= 0x2f800000 and
align_order=12, the function returns a value of 0x17c00 instead of 0x400.

This patch fixes the CMA aligned offset calculation.

The previous calculation was wrong and would return too-large values for
the offset, so that when cma_alloc looks for free pages in the bitmap with
the requested alignment > order_per_bit, it starts too far into the bitmap
and so CMA allocations will fail despite there actually being plenty of
free pages remaining.  It will also probably have the wrong alignment. 
With this change, we will get the correct offset into the bitmap.

One affected user is powerpc KVM, which has kvm_cma->order_per_bit set to
KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, or 18 - 12 = 6.

[gregory.0xf0@gmail.com: changelog additions]
Signed-off-by: Danesh Petigara <dpetigara@broadcom.com>
Reviewed-by: Gregory Fong <gregory.0xf0@gmail.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/cma.c~mm-cma-fix-cma-aligned-offset-calculation mm/cma.c
--- a/mm/cma.c~mm-cma-fix-cma-aligned-offset-calculation
+++ a/mm/cma.c
@@ -64,15 +64,17 @@ static unsigned long cma_bitmap_aligned_
 	return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
+/*
+ * Find a PFN aligned to the specified order and return an offset represented in
+ * order_per_bits.
+ */
 static unsigned long cma_bitmap_aligned_offset(struct cma *cma, int align_order)
 {
-	unsigned int alignment;
