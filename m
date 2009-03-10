From: akpm@linux-foundation.org
Subject: + pcie-portdrv-eliminate-double-kfree-in-remove-path.patch added to -mm tree
Date: Mon, 09 Mar 2009 19:16:48 -0700
Message-ID: <200903100216.n2A2GmaT001951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661AbZCJCQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 22:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, jbarnes@virtuousgeek.org, matthew@wil.cx, rjw@sisk.pl


The patch titled
     PCIe portdrv: eliminate double kfree in remove path
has been added to the -mm tree.  Its filename is
     pcie-portdrv-eliminate-double-kfree-in-remove-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -93,7 +93,6 @@ static int __devinit pcie_portdrv_probe 
 static void pcie_portdrv_remove (struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	kfree(pci_get_drvdata(dev));
 }
 
 static int error_detected_iter(struct device *device, void *data)
_

Patches currently in -mm which might be from achiang@hp.com are

linux-next.patch
pcie-portdrv-eliminate-double-kfree-in-remove-path.patch
pcie-aer-during-disable-check-subordinate-before-walking.patch

