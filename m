From: akpm@linux-foundation.org
Subject: [merged] qlogic-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:41 -0700
Message-ID: <53ea6e31.gQzy/pfLRcUQ15Tq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:47504 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaHLTmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:43 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so1309169ykb.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, jitendra.kalsaria@qlogic.com, manish.chopra@qlogic.com, rajesh.borundia@qlogic.com, ron.mercer@qlogic.com, shahed.shaikh@qlogic.com, sony.chacko@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: qlogic: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     qlogic-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: qlogic: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Manish Chopra <manish.chopra@qlogic.com>
Cc: Sony Chacko <sony.chacko@qlogic.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>
Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
Cc: Ron Mercer <ron.mercer@qlogic.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c |    4 ---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c        |   11 ++++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c~qlogic-use-pci_zalloc_consistent drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c~qlogic-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
@@ -129,14 +129,12 @@ netxen_get_minidump_template(struct netx
 		return NX_RCODE_INVALID_ARGS;
 	}
 
-	addr = pci_alloc_consistent(adapter->pdev, size, &md_template_addr);
-
+	addr = pci_zalloc_consistent(adapter->pdev, size, &md_template_addr);
 	if (!addr) {
 		dev_err(&adapter->pdev->dev, "Unable to allocate dmable memory for template.\n");
 		return -ENOMEM;
 	}
 
-	memset(addr, 0, size);
 	memset(&cmd, 0, sizeof(cmd));
 	memset(&cmd.rsp, 1, sizeof(struct _cdrp_cmd));
 	cmd.req.cmd = NX_CDRP_CMD_GET_TEMP_HDR;
diff -puN drivers/net/ethernet/qlogic/qlge/qlge_main.c~qlogic-use-pci_zalloc_consistent drivers/net/ethernet/qlogic/qlge/qlge_main.c
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c~qlogic-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -2727,23 +2727,22 @@ static void ql_free_shadow_space(struct
 static int ql_alloc_shadow_space(struct ql_adapter *qdev)
 {
 	qdev->rx_ring_shadow_reg_area =
-	    pci_alloc_consistent(qdev->pdev,
-				 PAGE_SIZE, &qdev->rx_ring_shadow_reg_dma);
+		pci_zalloc_consistent(qdev->pdev, PAGE_SIZE,
+				      &qdev->rx_ring_shadow_reg_dma);
 	if (qdev->rx_ring_shadow_reg_area == NULL) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Allocation of RX shadow space failed.\n");
 		return -ENOMEM;
 	}
-	memset(qdev->rx_ring_shadow_reg_area, 0, PAGE_SIZE);
+
 	qdev->tx_ring_shadow_reg_area =
-	    pci_alloc_consistent(qdev->pdev, PAGE_SIZE,
-				 &qdev->tx_ring_shadow_reg_dma);
+		pci_zalloc_consistent(qdev->pdev, PAGE_SIZE,
+				      &qdev->tx_ring_shadow_reg_dma);
 	if (qdev->tx_ring_shadow_reg_area == NULL) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Allocation of TX shadow space failed.\n");
 		goto err_wqp_sh_area;
 	}
-	memset(qdev->tx_ring_shadow_reg_area, 0, PAGE_SIZE);
 	return 0;
 
 err_wqp_sh_area:
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

