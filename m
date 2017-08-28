From: akpm@linux-foundation.org
Subject: +
 arm-cma-avoid-double-mapping-to-the-cma-area-if-config_highmem-=-y.patch
 added to -mm tree
Date: Mon, 28 Aug 2017 16:00:09 -0700
Message-ID: <59a4a079.uSvGf8tndmKw2jLC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdH1XAK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Aug 2017 19:00:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, linux@armlinux.org.uk, m.szyprowski@samsung.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: CMA: avoid double mapping to the CMA area if CONFIG_HIGHMEM=y
has been added to the -mm tree.  Its filename is
     arm-cma-avoid-double-mapping-to-the-cma-area-if-config_highmem-=-y.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-cma-avoid-double-mapping-to-the-cma-area-if-config_highmem-%3D-y.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-cma-avoid-double-mapping-to-the-cma-area-if-config_highmem-%3D-y.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: ARM: CMA: avoid double mapping to the CMA area if CONFIG_HIGHMEM=y

CMA area is now managed by the separate zone, ZONE_MOVABLE, to fix many MM
related problems.  In this implementation, if CONFIG_HIGHMEM = y, then
ZONE_MOVABLE is considered as HIGHMEM and the memory of the CMA area is
also considered as HIGHMEM.  That means that they are considered as the
page without direct mapping.  However, CMA area could be in a lowmem and
the memory could have direct mapping.

In ARM, when establishing a new mapping for DMA, direct mapping should be
cleared since two mapping with different cache policy could cause unknown
problem.  With this patch, PageHighmem() for the CMA memory located in
lowmem returns true so that the function for DMA mapping cannot notice
whether it needs to clear direct mapping or not, correctly.  To handle
this situation, this patch always clears direct mapping for such CMA
memory.

Link: http://lkml.kernel.org/r/1503556593-10720-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/arm/mm/dma-mapping.c~arm-cma-avoid-double-mapping-to-the-cma-area-if-config_highmem-=-y arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~arm-cma-avoid-double-mapping-to-the-cma-area-if-config_highmem-=-y
+++ a/arch/arm/mm/dma-mapping.c
@@ -513,7 +513,13 @@ void __init dma_contiguous_remap(void)
 		flush_tlb_kernel_range(__phys_to_virt(start),
 				       __phys_to_virt(end));
 
-		iotable_init(&map, 1);
+		/*
+		 * For highmem system, all the memory in CMA region will be
+		 * considered as highmem even if it's physical address belong
+		 * to lowmem. Therefore, re-mapping isn't required.
+		 */
+		if (!IS_ENABLED(CONFIG_HIGHMEM))
+			iotable_init(&map, 1);
 	}
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-mlock-use-page_zone-instead-of-page_zone_id.patch
mm-cma-manage-the-memory-of-the-cma-area-by-using-the-zone_movable.patch
mm-cma-remove-alloc_cma.patch
arm-cma-avoid-double-mapping-to-the-cma-area-if-config_highmem-=-y.patch

