From: akpm@linux-foundation.org
Subject: [merged] rtlwifi-use-pci_zalloc_consistent.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:51 -0700
Message-ID: <53ea6e3b.PYo7PPGRwPMKfYYj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:37641 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaHLTmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:52 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1920824obc.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtlwifi: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     rtlwifi-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: rtlwifi: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rtlwifi/pci.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/net/wireless/rtlwifi/pci.c~rtlwifi-use-pci_zalloc_consistent drivers/net/wireless/rtlwifi/pci.c
--- a/drivers/net/wireless/rtlwifi/pci.c~rtlwifi-use-pci_zalloc_consistent
+++ a/drivers/net/wireless/rtlwifi/pci.c
@@ -1092,16 +1092,14 @@ static int _rtl_pci_init_tx_ring(struct
 	u32 nextdescaddress;
 	int i;
 
-	ring = pci_alloc_consistent(rtlpci->pdev,
-				    sizeof(*ring) * entries, &dma);
-
+	ring = pci_zalloc_consistent(rtlpci->pdev, sizeof(*ring) * entries,
+				     &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Cannot allocate TX ring (prio = %d)\n", prio);
 		return -ENOMEM;
 	}
 
-	memset(ring, 0, sizeof(*ring) * entries);
 	rtlpci->tx_ring[prio].desc = ring;
 	rtlpci->tx_ring[prio].dma = dma;
 	rtlpci->tx_ring[prio].idx = 0;
@@ -1139,10 +1137,9 @@ static int _rtl_pci_init_rx_ring(struct
 	for (rx_queue_idx = 0; rx_queue_idx < RTL_PCI_MAX_RX_QUEUE;
 	     rx_queue_idx++) {
 		rtlpci->rx_ring[rx_queue_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rx_queue_idx].
-						desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rx_queue_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rx_queue_idx].dma);
 
 		if (!rtlpci->rx_ring[rx_queue_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rx_queue_idx].desc & 0xFF) {
@@ -1151,10 +1148,6 @@ static int _rtl_pci_init_rx_ring(struct
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rx_queue_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) *
-		       rtlpci->rxringcount);
