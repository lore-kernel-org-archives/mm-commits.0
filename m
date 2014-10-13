From: akpm@linux-foundation.org
Subject: + mm-cma-fix-cma-bitmap-aligned-mask-computing.patch added to -mm tree
Date: Mon, 13 Oct 2014 12:35:18 -0700
Message-ID: <543c2976.h69xw6btlGWmK9tD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaJMTfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 15:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: fix cma bitmap aligned mask computing
has been added to the -mm tree.  Its filename is
     mm-cma-fix-cma-bitmap-aligned-mask-computing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-cma-bitmap-aligned-mask-computing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>	[3.17]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/cma.c~mm-cma-fix-cma-bitmap-aligned-mask-computing mm/cma.c
--- a/mm/cma.c~mm-cma-fix-cma-bitmap-aligned-mask-computing
+++ a/mm/cma.c
@@ -58,7 +58,10 @@ unsigned long cma_get_size(struct cma *c
 
 static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
 {
-	return (1UL << (align_order >> cma->order_per_bit)) - 1;
+	if (align_order <= cma->order_per_bit)
+		return 0;
+	else
+		return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
 static unsigned long cma_bitmap_maxno(struct cma *cma)
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing.patch

