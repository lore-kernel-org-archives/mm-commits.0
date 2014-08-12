From: akpm@linux-foundation.org
Subject: [merged] sky2-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:37 -0700
Message-ID: <53ea6e2d.WGqui0cwnN73zbdk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:47873 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaHLTmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:38 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so1911470oig.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, mlindner@marvell.com, stephen@networkplumber.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sky2: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     sky2-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: sky2: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mirko Lindner <mlindner@marvell.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/marvell/sky2.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/net/ethernet/marvell/sky2.c~sky2-use-pci_zalloc_consistent drivers/net/ethernet/marvell/sky2.c
--- a/drivers/net/ethernet/marvell/sky2.c~sky2-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/marvell/sky2.c
@@ -1622,11 +1622,10 @@ static int sky2_alloc_buffers(struct sky
 	if (!sky2->tx_ring)
 		goto nomem;
 
-	sky2->rx_le = pci_alloc_consistent(hw->pdev, RX_LE_BYTES,
-					   &sky2->rx_le_map);
+	sky2->rx_le = pci_zalloc_consistent(hw->pdev, RX_LE_BYTES,
+					    &sky2->rx_le_map);
 	if (!sky2->rx_le)
 		goto nomem;
-	memset(sky2->rx_le, 0, RX_LE_BYTES);
 
 	sky2->rx_ring = kcalloc(sky2->rx_pending, sizeof(struct rx_ring_info),
 				GFP_KERNEL);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

