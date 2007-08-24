From: akpm@linux-foundation.org
Subject: + fix-ide-legacy-mode-resources.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:15:24 -0700
Message-ID: <200708242215.l7OMFPwE017451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759251AbXHXWPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, greg@kroah.com, ralf@linux-mips.org


The patch titled
     fix IDE legacy mode resources
has been added to the -mm tree.  Its filename is
     fix-ide-legacy-mode-resources.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix IDE legacy mode resources
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

I got the following error on MIPS Cobalt.

PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
pata_via 0000:00:09.1: failed to request/iomap BARs for port 0 (errno=-16)
PCI: Unable to reserve I/O region #3:8@f0000170 for device 0000:00:09.1
pata_via 0000:00:09.1: failed to request/iomap BARs for port 1 (errno=-16)
pata_via 0000:00:09.1: no available native port

The legacy mode IDE resources set the following order.

pci_setup_device()
    Legacy mode ATA controllers have fixed addresses.
    IDE resources: 0x1F0-0x1F7, 0x3F6, 0x170-0x177, 0x376
    |
    V
pcibios_fixup_bus()
    MIPS Cobalt PCI bus regions have the -0x10000000 offset from PCI resources.
    pcibios_fixup_bus() fix PCI bus regions.
    0x1F0 - 0x10000000 = 0xF00001F0
    |
    V
ata_pci_init_one()
    PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1

In some architectures, PCI bus regions have the offset from PCI resources. 
For this reason, pci_setup_device() should set PCI bus regions to
dev->resource[].

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   42 ++++++++++++++++++++++++++++++------------
 1 files changed, 30 insertions(+), 12 deletions(-)

diff -puN drivers/pci/probe.c~fix-ide-legacy-mode-resources drivers/pci/probe.c
--- a/drivers/pci/probe.c~fix-ide-legacy-mode-resources
+++ a/drivers/pci/probe.c
@@ -793,22 +793,40 @@ static int pci_setup_device(struct pci_d
 		 */
 		if (class == PCI_CLASS_STORAGE_IDE) {
 			u8 progif;
+			struct pci_bus_region region;
+			struct resource resource;
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				dev->resource[0].start = 0x1F0;
-				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = LEGACY_IO_RESOURCE;
-				dev->resource[1].start = 0x3F6;
-				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = LEGACY_IO_RESOURCE;
+				resource.start = 0x1F0;
+				resource.end = 0x1F7;
+				resource.flags = LEGACY_IO_RESOURCE;
+				pcibios_resource_to_bus(dev, &region, &resource);
+				dev->resource[0].start = region.start;
+				dev->resource[0].end = region.end;
+				dev->resource[0].flags = resource.flags;
+				resource.start = 0x3F6;
+				resource.end = 0x3F6;
+				resource.flags = LEGACY_IO_RESOURCE;
+				pcibios_resource_to_bus(dev, &region, &resource);
+				dev->resource[1].start = region.start;
+				dev->resource[1].end = region.end;
+				dev->resource[1].flags = resource.flags;
 			}
 			if ((progif & 4) == 0) {
-				dev->resource[2].start = 0x170;
-				dev->resource[2].end = 0x177;
-				dev->resource[2].flags = LEGACY_IO_RESOURCE;
-				dev->resource[3].start = 0x376;
-				dev->resource[3].end = 0x376;
-				dev->resource[3].flags = LEGACY_IO_RESOURCE;
+				resource.start = 0x170;
+				resource.end = 0x177;
+				resource.flags = LEGACY_IO_RESOURCE;
+				pcibios_resource_to_bus(dev, &region, &resource);
+				dev->resource[2].start = region.start;
+				dev->resource[2].end = region.end;
+				dev->resource[2].flags = resource.flags;
+				resource.start = 0x376;
+				resource.end = 0x376;
+				resource.flags = LEGACY_IO_RESOURCE;
+				pcibios_resource_to_bus(dev, &region, &resource);
+				dev->resource[3].start = region.start;
+				dev->resource[3].end = region.end;
+				dev->resource[3].flags = resource.flags;
 			}
 		}
 		break;
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
git-mips.patch
git-mtd.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
