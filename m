From: akpm@linux-foundation.org
Subject: [merged] dma-apitxt-remove-dma_sync_single_range-description.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:22 -0400
Message-ID: <201003150702.o2F72tEm016892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935892Ab0COHDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     DMA-API.txt: remove dma_sync_single_range description
has been removed from the -mm tree.  Its filename was
     dma-apitxt-remove-dma_sync_single_range-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: DMA-API.txt: remove dma_sync_single_range description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single_for_cpu/for_device supports a partial sync so there is no
point to have dma_sync_single_range (also dma_sync_single was obsoleted
long ago, replaced with dma_sync_single_for_cpu/for_device).

There is no user of dma_sync_single_range() in mainline and only Alpha
architecture supports dma_sync_single_range().  So it's unlikely that
someone out of the tree uses it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David Miller <davem@davemloft.net>
Acked-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-apitxt-remove-dma_sync_single_range-description Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-apitxt-remove-dma_sync_single_range-description
+++ a/Documentation/DMA-API.txt
@@ -528,16 +528,6 @@ into the width returned by this call.  I
 of two for easy alignment.
 
 void
-dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-
-Does a partial sync, starting at offset and continuing for size.  You
-must be careful to observe the cache alignment and width when doing
-anything like this.  You must also be extra careful about accessing
-memory you intend to sync partially.
