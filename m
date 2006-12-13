From: akpm@osdl.org
Subject: - pcieport-driver-remove-invalid-warning-message.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:16 -0800
Message-ID: <200612130656.kBD6uGOC030710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965047AbWLMG4Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaneshige.kenji@jp.fujitsu.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pcieport-driver: remove invalid warning message
has been removed from the -mm tree.  Its filename was
     pcieport-driver-remove-invalid-warning-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pcieport-driver: remove invalid warning message
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

I got the following warning messages on some PCI Express ports.

    pcie_portdrv_probe->Dev[1263:10cf] has invalid IRQ. Check vendor BIOS

I think this message is improper because those PCI Express ports don't
use an interrupt pin. This message should not be displayed for devices
which don't use an interrupt pin.

The following warning message should not be displayed for devices
which don't use an interrupt pin.

    pcie_portdrv_probe->Dev[XXXX:XXXX] has invalid IRQ. Check vendor BIOS

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/pcie/portdrv_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pcie/portdrv_pci.c~pcieport-driver-remove-invalid-warning-message drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pcieport-driver-remove-invalid-warning-message
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -90,7 +90,7 @@ static int __devinit pcie_portdrv_probe 
 		return -ENODEV;
 	
 	pci_set_master(dev);
-        if (!dev->irq) {
+        if (!dev->irq && dev->pin) {
 		printk(KERN_WARNING 
 		"%s->Dev[%04x:%04x] has invalid IRQ. Check vendor BIOS\n", 
 		__FUNCTION__, dev->device, dev->vendor);
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

origin.patch

