From: akpm@linux-foundation.org
Subject: - e100-do-pci_dma_sync-after-skb_alloc-for-proper-operation-on-ixp4xx.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:49 -0700
Message-ID: <200807020747.m627lnei005680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762329AbYGBHsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kexin.hao@windriver.com, auke-jan.h.kok@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     e100: do pci_dma_sync after skb_alloc for proper operation on ixp4xx
has been removed from the -mm tree.  Its filename was
     e100-do-pci_dma_sync-after-skb_alloc-for-proper-operation-on-ixp4xx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e100: do pci_dma_sync after skb_alloc for proper operation on ixp4xx
From: Kevin Hao <kexin.hao@windriver.com>

Do a DMA sync after we've allocated a new skb and link it with the
previous RFD.  Otherwise the previous RFD may reference the previously
freed skb and cause kernel corruption.

Previously there was such a DMA sync at this place, but it was removed by
commit 7734f6e6bcd7ba78b00e93e74a4ddafd9886cdea.  Restoring this sync
operation eliminates the regression.

Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
Auke Kok <auke-jan.h.kok@intel.com>
Cc: <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: "Ronciak, John" <john.ronciak@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e100.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/e100.c~e100-do-pci_dma_sync-after-skb_alloc-for-proper-operation-on-ixp4xx drivers/net/e100.c
--- a/drivers/net/e100.c~e100-do-pci_dma_sync-after-skb_alloc-for-proper-operation-on-ixp4xx
+++ a/drivers/net/e100.c
@@ -1692,6 +1692,8 @@ static int e100_rx_alloc_skb(struct nic 
 	if (rx->prev->skb) {
 		struct rfd *prev_rfd = (struct rfd *)rx->prev->skb->data;
 		put_unaligned_le32(rx->dma_addr, &prev_rfd->link);
+		pci_dma_sync_single_for_device(nic->pdev, rx->prev->dma_addr,
+			sizeof(struct rfd), PCI_DMA_TODEVICE);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from kexin.hao@windriver.com are

linux-next.patch

