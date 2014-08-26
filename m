From: akpm@linux-foundation.org
Subject: + arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
 added to -mm tree
Date: Tue, 26 Aug 2014 16:10:09 -0700
Message-ID: <53fd13d1.9Ads/3kNH5BlZCP6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:41783 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbaHZXKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:10:10 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so3054087oah.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:10:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, drake@endlessm.com, iamjoonsoo.kim@lge.com, linux@arm.linux.org.uk, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mm: don't limit default CMA region only to low memory
has been added to the -mm tree.  Its filename is
     arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: ARM: mm: don't limit default CMA region only to low memory

DMA-mapping supports CMA regions places either in low or high memory, so
there is no longer needed to limit default CMA regions only to low memory.
 The real limit is still defined by architecture specific DMA limit.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Daniel Drake <drake@endlessm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mm/init.c~arm-mm-dont-limit-default-cma-region-only-to-low-memory arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arm-mm-dont-limit-default-cma-region-only-to-low-memory
+++ a/arch/arm/mm/init.c
@@ -322,7 +322,7 @@ void __init arm_memblock_init(const stru
 	 * reserve memory for DMA contigouos allocations,
 	 * must come from DMA area inside low memory
 	 */
-	dma_contiguous_reserve(min(arm_dma_limit, arm_lowmem_limit));
+	dma_contiguous_reserve(arm_dma_limit);
 
 	arm_memblock_steal_permitted = false;
 	memblock_dump_all();
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
linux-next.patch

