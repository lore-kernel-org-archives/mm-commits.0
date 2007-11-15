From: akpm@linux-foundation.org
Subject: - drivers-misc-move-misplaced-pci_dev_puts.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:23 -0800
Message-ID: <200711152109.lAFL9N1e015438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbXKOVQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/misc: Move misplaced pci_dev_put's
has been removed from the -mm tree.  Its filename was
     drivers-misc-move-misplaced-pci_dev_puts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/misc: Move misplaced pci_dev_put's
From: Julia Lawall <julia@diku.dk>

Move pci_dev_put outside the loops in which it occurs.  Within the loop,
pci_dev_put is done implicitly by pci_get_device.

The problem was detected using the following semantic patch, and corrected
by hand.

@@
expression dev;
expression E;
@@

- pci_dev_put(dev)
   ... when != dev = E
- pci_get_device(...,dev)

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ioc4.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/misc/ioc4.c~drivers-misc-move-misplaced-pci_dev_puts drivers/misc/ioc4.c
--- a/drivers/misc/ioc4.c~drivers-misc-move-misplaced-pci_dev_puts
+++ a/drivers/misc/ioc4.c
@@ -244,10 +244,11 @@ ioc4_variant(struct ioc4_driver_data *id
 		    idd->idd_pdev->bus->number == pdev->bus->number &&
 		    3 == PCI_SLOT(pdev->devfn))
 			found = 1;
-		pci_dev_put(pdev);
 	} while (pdev && !found);
-	if (NULL != pdev)
+	if (NULL != pdev) {
+		pci_dev_put(pdev);
 		return IOC4_VARIANT_IO9;
+	}
 
 	/* IO10: Look for a Vitesse VSC 7174 at the same bus and slot 3. */
 	pdev = NULL;
@@ -258,10 +259,11 @@ ioc4_variant(struct ioc4_driver_data *id
 		    idd->idd_pdev->bus->number == pdev->bus->number &&
 		    3 == PCI_SLOT(pdev->devfn))
 			found = 1;
-		pci_dev_put(pdev);
 	} while (pdev && !found);
-	if (NULL != pdev)
+	if (NULL != pdev) {
+		pci_dev_put(pdev);
 		return IOC4_VARIANT_IO10;
+	}
 
 	/* PCI-RT: No SCSI/SATA controller will be present */
 	return IOC4_VARIANT_PCI_RT;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-alsa.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
