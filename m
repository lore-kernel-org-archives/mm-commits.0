From: akpm@linux-foundation.org
Subject: - pci-handle-pci_name-being-const.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:26:58 -0700
Message-ID: <200807040726.m647Qwm6019317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYGDH1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:27:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@suse.de, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     PCI: handle pci_name() being const
has been removed from the -mm tree.  Its filename was
     pci-handle-pci_name-being-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI: handle pci_name() being const
From: Greg Kroah-Hartman <gregkh@suse.de>

This changes pci_setup_device to handle pci_name() now returning a
constant string.

Cc: Jesse Barns <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pci/probe.c~pci-handle-pci_name-being-const drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-handle-pci_name-being-const
+++ a/drivers/pci/probe.c
@@ -713,9 +713,9 @@ static int pci_setup_device(struct pci_d
 {
 	u32 class;
 
-	snprintf(dev->dev.bus_id, BUS_ID_SIZE,
-		 "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
-		 dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
+	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
+		     dev->bus->number, PCI_SLOT(dev->devfn),
+		     PCI_FUNC(dev->devfn));
 
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
 	dev->revision = class & 0xff;
_

Patches currently in -mm which might be from gregkh@suse.de are

origin.patch
linux-next.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
drivers-usb-class-cdc-acmc-fix-build-with-config_pm=n.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch
hugetlb-new-sysfs-interface.patch
checkpatch-usb_free_urb-can-take-null.patch
firmware-use-memory_read_from_buffer.patch
edac-core-fix-to-use-dynamic-kobject.patch

