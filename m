From: akpm@linux-foundation.org
Subject: [merged] mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:18:57 -0700
Message-ID: <543d6911.YfSBrWcoMqexKgV3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaJNSS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: fix cma bitmap aligned mask computing
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-cma-bitmap-aligned-mask-computing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/cma: fix cma bitmap aligned mask computing

The current cma bitmap aligned mask computation is incorrect.  It could
cause an unexpected alignment when using cma_alloc() if the wanted align
order is larger than cma->order_per_bit.

Take kvm for example (PAGE_SHIFT = 12), kvm_cma->order_per_bit is set to
6.  When kvm_alloc_rma() tries to alloc kvm_rma_pages, it will use 15 as
the expected align value.  After using the current implementation however,
we get 0 as cma bitmap aligned mask other than 511.

This patch fixes the cma bitmap aligned mask calculation.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>	[3.17]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/cma.c~mm-cma-fix-cma-bitmap-aligned-mask-computing mm/cma.c
--- a/mm/cma.c~mm-cma-fix-cma-bitmap-aligned-mask-computing
+++ a/mm/cma.c
@@ -58,7 +58,9 @@ unsigned long cma_get_size(struct cma *c
 
 static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
 {
-	return (1UL << (align_order >> cma->order_per_bit)) - 1;
+	if (align_order <= cma->order_per_bit)
+		return 0;
+	return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
 static unsigned long cma_bitmap_maxno(struct cma *cma)
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch

