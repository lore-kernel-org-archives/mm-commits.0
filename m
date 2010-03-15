From: akpm@linux-foundation.org
Subject: [merged] um-remove-dma_sync_single_range.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:28 -0400
Message-ID: <201003150703.o2F7311L016898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935902Ab0COHDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: remove dma_sync_single_range
has been removed from the -mm tree.  Its filename was
     um-remove-dma_sync_single_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: remove dma_sync_single_range
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single_for_cpu/for_device supports a partial sync so there is no
point to have dma_sync_single_range (also dma_sync_single was obsoleted
long ago, replaced with dma_sync_single_for_cpu/for_device).

There is no user of dma_sync_single_range() in mainline and only Alpha
architecture supports dma_sync_single_range().  So it's unlikely that
someone out of the tree uses it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Dike <jdike@addtoit.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/dma-mapping.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN arch/um/include/asm/dma-mapping.h~um-remove-dma_sync_single_range arch/um/include/asm/dma-mapping.h
--- a/arch/um/include/asm/dma-mapping.h~um-remove-dma_sync_single_range
+++ a/arch/um/include/asm/dma-mapping.h
@@ -104,14 +104,6 @@ dma_get_cache_alignment(void)
 }
 
 static inline void
-dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-{
-	BUG();
-}
