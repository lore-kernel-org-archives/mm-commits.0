From: akpm@linux-foundation.org
Subject: [merged] irda-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:43 -0700
Message-ID: <53ea6e33.DHbsmNl3OaT4ftZ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:53755 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbaHLTmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:44 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1070067igi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: irda: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     irda-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: irda: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/vlsi_ir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/irda/vlsi_ir.c~irda-use-pci_zalloc_consistent drivers/net/irda/vlsi_ir.c
--- a/drivers/net/irda/vlsi_ir.c~irda-use-pci_zalloc_consistent
+++ a/drivers/net/irda/vlsi_ir.c
@@ -485,13 +485,13 @@ static int vlsi_create_hwif(vlsi_irda_de
 	idev->virtaddr = NULL;
 	idev->busaddr = 0;
 
-	ringarea = pci_alloc_consistent(idev->pdev, HW_RING_AREA_SIZE, &idev->busaddr);
+	ringarea = pci_zalloc_consistent(idev->pdev, HW_RING_AREA_SIZE,
+					 &idev->busaddr);
 	if (!ringarea) {
 		IRDA_ERROR("%s: insufficient memory for descriptor rings\n",
 			   __func__);
 		goto out;
 	}
-	memset(ringarea, 0, HW_RING_AREA_SIZE);
 
 	hwmap = (struct ring_descr_hw *)ringarea;
 	idev->rx_ring = vlsi_alloc_ring(idev->pdev, hwmap, ringsize[1],
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

