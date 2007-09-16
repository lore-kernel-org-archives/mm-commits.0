From: akpm@linux-foundation.org
Subject: - pci-x-pci-express-read-control-interfaces-mthca.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:56 -0700
Message-ID: <200709160926.l8G9QugM009220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbXIPJiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oruba@amd.com, mst@mellanox.co.il, rolandd@cisco.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     PCI-X/PCI-Express read control interfaces: use them in mthca
has been removed from the -mm tree.  Its filename was
     pci-x-pci-express-read-control-interfaces-mthca.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI-X/PCI-Express read control interfaces: use them in mthca
From: "Peter Oruba" <peter.oruba@amd.com>

These driver changes incorporate the proposed PCI-X / PCI-Express read byte
count interface.  Reading and setting those valuse doesn't take place
"manually", instead wrapping functions are called to allow quirks for some
PCI bridges.

Signed-off by: Peter Oruba <peter.oruba@amd.com>
Based on work by Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Michael S. Tsirkin <mst@mellanox.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/mthca/mthca_main.c |   38 +++++----------------
 1 files changed, 10 insertions(+), 28 deletions(-)

diff -puN drivers/infiniband/hw/mthca/mthca_main.c~pci-x-pci-express-read-control-interfaces-mthca drivers/infiniband/hw/mthca/mthca_main.c
--- a/drivers/infiniband/hw/mthca/mthca_main.c~pci-x-pci-express-read-control-interfaces-mthca
+++ a/drivers/infiniband/hw/mthca/mthca_main.c
@@ -137,45 +137,27 @@ static const char mthca_version[] __devi
 
 static int mthca_tune_pci(struct mthca_dev *mdev)
 {
-	int cap;
-	u16 val;
-
 	if (!tune_pci)
 		return 0;
 
 	/* First try to max out Read Byte Count */
-	cap = pci_find_capability(mdev->pdev, PCI_CAP_ID_PCIX);
-	if (cap) {
-		if (pci_read_config_word(mdev->pdev, cap + PCI_X_CMD, &val)) {
-			mthca_err(mdev, "Couldn't read PCI-X command register, "
-				  "aborting.\n");
-			return -ENODEV;
-		}
-		val = (val & ~PCI_X_CMD_MAX_READ) | (3 << 2);
-		if (pci_write_config_word(mdev->pdev, cap + PCI_X_CMD, val)) {
-			mthca_err(mdev, "Couldn't write PCI-X command register, "
-				  "aborting.\n");
+	if (pci_find_capability(mdev->pdev, PCI_CAP_ID_PCIX)) {
+		if (pcix_set_mmrbc(mdev->pdev, pcix_get_max_mmrbc(mdev->pdev))) {
+			mthca_err(mdev, "Couldn't set PCI-X max read count, "
+				"aborting.\n");
 			return -ENODEV;
 		}
 	} else if (!(mdev->mthca_flags & MTHCA_FLAG_PCIE))
 		mthca_info(mdev, "No PCI-X capability, not setting RBC.\n");
 
-	cap = pci_find_capability(mdev->pdev, PCI_CAP_ID_EXP);
-	if (cap) {
-		if (pci_read_config_word(mdev->pdev, cap + PCI_EXP_DEVCTL, &val)) {
-			mthca_err(mdev, "Couldn't read PCI Express device control "
-				  "register, aborting.\n");
-			return -ENODEV;
-		}
-		val = (val & ~PCI_EXP_DEVCTL_READRQ) | (5 << 12);
-		if (pci_write_config_word(mdev->pdev, cap + PCI_EXP_DEVCTL, val)) {
-			mthca_err(mdev, "Couldn't write PCI Express device control "
-				  "register, aborting.\n");
+	if (pci_find_capability(mdev->pdev, PCI_CAP_ID_EXP)) {
+		if (pcie_set_readrq(mdev->pdev, 4096)) {
+			mthca_err(mdev, "Couldn't write PCI Express read request, "
+				"aborting.\n");
 			return -ENODEV;
 		}
-	} else if (mdev->mthca_flags & MTHCA_FLAG_PCIE)
-		mthca_info(mdev, "No PCI Express capability, "
-			   "not setting Max Read Request Size.\n");
+	} else if (!(mdev->mthca_flags & MTHCA_FLAG_PCIE))
+		mthca_info(mdev, "No PCI-X capability, not setting RBC.\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from peter.oruba@amd.com are

git-infiniband.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
