From: akpm@linux-foundation.org
Subject: +
 mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch added to
 -mm tree
Date: Mon, 12 Jan 2015 16:10:41 -0800
Message-ID: <54b46281.88WkLtQN93XHiSk1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbbAMAKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:10:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ggdavisiv@gmail.com, aneesh.kumar@linux.vnet.ibm.com, george_davis@mentor.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix totalcma_pages to include DT defined CMA regions
has been added to the -mm tree.  Its filename is
     mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "George G. Davis" <ggdavisiv@gmail.com>
Subject: mm: cma: fix totalcma_pages to include DT defined CMA regions

The totalcma_pages variable is not updated to account for CMA regions
defined via device tree reserved-memory sub-nodes.  Fix this omission by
moving the calculation of totalcma_pages into cma_init_reserved_mem()
instead of cma_declare_contiguous() such that it will include reserved
memory used by all CMA regions.

Signed-off-by: George G. Davis <george_davis@mentor.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/cma.c~mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions mm/cma.c
--- a/mm/cma.c~mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions
+++ a/mm/cma.c
@@ -199,6 +199,7 @@ int __init cma_init_reserved_mem(phys_ad
 	cma->order_per_bit = order_per_bit;
 	*res_cma = cma;
 	cma_area_count++;
+	totalcma_pages += (size / PAGE_SIZE);
 
 	return 0;
 }
@@ -337,7 +338,6 @@ int __init cma_declare_contiguous(phys_a
 	if (ret)
 		goto err;
 
-	totalcma_pages += (size / PAGE_SIZE);
 	pr_info("Reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
 		&base);
 	return 0;
_

Patches currently in -mm which might be from ggdavisiv@gmail.com are

mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch

