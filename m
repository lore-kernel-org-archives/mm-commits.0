From: akpm@linux-foundation.org
Subject: [merged] pci-pcie-portdrv-remove-unnecessary-function.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:29 -0800
Message-ID: <200901261904.n0QJ4Tlo029967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656AbZAZTHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:07:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     PCI PCIe portdrv: remove unnecessary function
has been removed from the -mm tree.  Its filename was
     pci-pcie-portdrv-remove-unnecessary-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI PCIe portdrv: remove unnecessary function
From: Rafael J. Wysocki <rjw@sisk.pl>

The function pcie_portdrv_save_config() in portdrv_pci.c is not necessary.
 Remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/portdrv_pci.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/pci/pcie/portdrv_pci.c~pci-pcie-portdrv-remove-unnecessary-function drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pci-pcie-portdrv-remove-unnecessary-function
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -32,11 +32,6 @@ MODULE_LICENSE("GPL");
 /* global data */
 static const char device_name[] = "pcieport-driver";
 
-static int pcie_portdrv_save_config(struct pci_dev *dev)
-{
-	return pci_save_state(dev);
-}
