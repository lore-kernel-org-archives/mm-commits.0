From: akpm@linux-foundation.org
Subject: [merged] b44-use-kernel-dma-addresses-for-the-kernel-dma-api.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:55 -0700
Message-ID: <200904071909.n37J9tvv012556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbZDGUEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 16:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, davem@davemloft.net, sergio@sergiomb.no-ip.org, stable@kernel.org, zambrano@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     b44: use kernel DMA addresses for the kernel DMA API
has been removed from the -mm tree.  Its filename was
     b44-use-kernel-dma-addresses-for-the-kernel-dma-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b44: use kernel DMA addresses for the kernel DMA API
From: Michael Buesch <mb@bu3sch.de>

We must not use the device DMA addresses for the kernel DMA API, because
device DMA addresses have an additional offset added for the SSB translation.

Use the original dma_addr_t for the sync operation.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12969

Cc: <stable@kernel.org>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Gary Zambrano <zambrano@broadcom.com>
Reported-by: Sergio M Basto <sergio@sergiomb.no-ip.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/b44.c~b44-use-kernel-dma-addresses-for-the-kernel-dma-api drivers/net/b44.c
--- a/drivers/net/b44.c~b44-use-kernel-dma-addresses-for-the-kernel-dma-api
+++ a/drivers/net/b44.c
@@ -750,7 +750,7 @@ static void b44_recycle_rx(struct b44 *b
 					     dest_idx * sizeof(*dest_desc),
 					     DMA_BIDIRECTIONAL);
 
-	ssb_dma_sync_single_for_device(bp->sdev, le32_to_cpu(src_desc->addr),
+	ssb_dma_sync_single_for_device(bp->sdev, dest_map->mapping,
 				       RX_PKT_BUF_SZ,
 				       DMA_FROM_DEVICE);
 }
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
linux-next.patch

