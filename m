From: akpm@linux-foundation.org
Subject: [merged] enic-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:35 -0700
Message-ID: <53ea6e2b.p3APFyV4XRUQ/XjC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:33416 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbaHLTmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:36 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so1307163qgd.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, _govind@gmx.com, benve@cisco.com, davem@davemloft.net, neepatel@cisco.com, ssujith@cisco.com, mm-commits@vger.kernel.org


The patch titled
     Subject: enic: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     enic-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: enic: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Sujith Sankar <ssujith@cisco.com>
Cc: Govindarajulu Varadarajan <_govind@gmx.com>
Cc: Neel Patel <neepatel@cisco.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/cisco/enic/vnic_dev.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/net/ethernet/cisco/enic/vnic_dev.c~enic-use-pci_zalloc_consistent drivers/net/ethernet/cisco/enic/vnic_dev.c
--- a/drivers/net/ethernet/cisco/enic/vnic_dev.c~enic-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/cisco/enic/vnic_dev.c
@@ -432,14 +432,12 @@ int vnic_dev_fw_info(struct vnic_dev *vd
 	int err = 0;
 
 	if (!vdev->fw_info) {
-		vdev->fw_info = pci_alloc_consistent(vdev->pdev,
-			sizeof(struct vnic_devcmd_fw_info),
-			&vdev->fw_info_pa);
+		vdev->fw_info = pci_zalloc_consistent(vdev->pdev,
+						      sizeof(struct vnic_devcmd_fw_info),
+						      &vdev->fw_info_pa);
 		if (!vdev->fw_info)
 			return -ENOMEM;
 
-		memset(vdev->fw_info, 0, sizeof(struct vnic_devcmd_fw_info));
