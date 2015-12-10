From: akpm@linux-foundation.org
Subject: + mips-fix-dma-contiguous-allocation.patch added to -mm tree
Date: Thu, 10 Dec 2015 14:18:00 -0800
Message-ID: <5669fa18.yc6+mfHuqdvpXCTa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbbLJWSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2015 17:18:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qais.yousef@imgtec.com, mgorman@techsingularity.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MIPS: fix DMA contiguous allocation
has been added to the -mm tree.  Its filename is
     mips-fix-dma-contiguous-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-fix-dma-contiguous-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-fix-dma-contiguous-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qais Yousef <qais.yousef@imgtec.com>
Subject: MIPS: fix DMA contiguous allocation

Recent changes to how GFP_ATOMIC is defined seems to have broken the
condition to use mips_alloc_from_contiguous() in
mips_dma_alloc_coherent().

I couldn't bottom out the exact change but I think it's this one

d0164adc89f6 ("mm, page_alloc: distinguish between being unable to sleep,
unwilling to sleep and avoiding waking kswapd").

GFP_ATOMIC has multiple bits set and the check for !(gfp & GFP_ATOMIC)
isn't enough.

The reason behind this condition is to check whether we can potentially do
a sleeping memory allocation.  Use gfpflags_allow_blocking() instead which
should be more robust.

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/dma-default.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/mm/dma-default.c~mips-fix-dma-contiguous-allocation arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~mips-fix-dma-contiguous-allocation
+++ a/arch/mips/mm/dma-default.c
@@ -145,7 +145,7 @@ static void *mips_dma_alloc_coherent(str
 
 	gfp = massage_gfp_flags(dev, gfp);
 
-	if (IS_ENABLED(CONFIG_DMA_CMA) && !(gfp & GFP_ATOMIC))
+	if (IS_ENABLED(CONFIG_DMA_CMA) && gfpflags_allow_blocking(gfp))
 		page = dma_alloc_from_contiguous(dev,
 					count, get_order(size));
 	if (!page)
_

Patches currently in -mm which might be from qais.yousef@imgtec.com are

mips-fix-dma-contiguous-allocation.patch

