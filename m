From: akpm@linux-foundation.org
Subject: [merged] alpha-remove-dma_sync_single_range.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:25 -0400
Message-ID: <201003150702.o2F72wbj016895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935904Ab0COHDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: remove dma_sync_single_range
has been removed from the -mm tree.  Its filename was
     alpha-remove-dma_sync_single_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: remove dma_sync_single_range
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single_for_cpu/for_device supports a partial sync so there is no
point to have dma_sync_single_range (also dma_sync_single was obsoleted
long ago, replaced with dma_sync_single_for_cpu/for_device).

There is no user of dma_sync_single_range() in mainline and only Alpha
architecture supports dma_sync_single_range().  So it's unlikely that
someone out of the tree uses it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Acked-by: Matt Turner <mattst88@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~alpha-remove-dma_sync_single_range arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~alpha-remove-dma_sync_single_range
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -59,7 +59,6 @@ int dma_set_mask(struct device *dev, u64
 
 #define dma_sync_single_for_cpu(dev, addr, size, dir)	  ((void)0)
 #define dma_sync_single_for_device(dev, addr, size, dir)  ((void)0)
-#define dma_sync_single_range(dev, addr, off, size, dir)  ((void)0)
 #define dma_sync_sg_for_cpu(dev, sg, nents, dir)	  ((void)0)
 #define dma_sync_sg_for_device(dev, sg, nents, dir)	  ((void)0)
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

