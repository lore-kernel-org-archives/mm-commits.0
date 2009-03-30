From: akpm@linux-foundation.org
Subject: [merged] pcie-portdrv-eliminate-double-kfree-in-remove-path.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:21 -0700
Message-ID: <200903301906.n2UJ6LtW019018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbZC3Tdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, jbarnes@virtuousgeek.org, matthew@wil.cx, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PCIe portdrv: eliminate double kfree in remove path
has been removed from the -mm tree.  Its filename was
     pcie-portdrv-eliminate-double-kfree-in-remove-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCIe portdrv: eliminate double kfree in remove path
From: Alex Chiang <achiang@hp.com>

Commit 55633af3 ("PCIe portdrv: Use driver data to simplify code") added a
kfree of the driver private data in pcie_port_device_remove but forgot to
remove the old kfree from pcie_portdrv_remove.

Signed-off-by: Alex Chiang <achiang@hp.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/portdrv_pci.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/pci/pcie/portdrv_pci.c~pcie-portdrv-eliminate-double-kfree-in-remove-path drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pcie-portdrv-eliminate-double-kfree-in-remove-path
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -94,7 +94,6 @@ static void pcie_portdrv_remove (struct 
 {
 	pcie_port_device_remove(dev);
 	pci_disable_device(dev);
-	kfree(pci_get_drvdata(dev));
 }
 
 static int error_detected_iter(struct device *device, void *data)
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch

