From: akpm@linux-foundation.org
Subject: - fix-ide-legacy-mode-resources.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:01 -0700
Message-ID: <200710051958.l95Jw1bv022512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763540AbXJEUBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, greg@kroah.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     fix IDE legacy mode resources
has been removed from the -mm tree.  Its filename was
     fix-ide-legacy-mode-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: use struct initialiser]
Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   48 +++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff -puN drivers/pci/probe.c~fix-ide-legacy-mode-resources drivers/pci/probe.c
--- a/drivers/pci/probe.c~fix-ide-legacy-mode-resources
+++ a/drivers/pci/probe.c
@@ -737,22 +737,46 @@ static int pci_setup_device(struct pci_d
 		 */
 		if (class == PCI_CLASS_STORAGE_IDE) {
 			u8 progif;
+			struct pci_bus_region region;
+
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				dev->resource[0].start = 0x1F0;
-				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = LEGACY_IO_RESOURCE;
-				dev->resource[1].start = 0x3F6;
-				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = LEGACY_IO_RESOURCE;
+				struct resource resource = {
+					.start = 0x1F0,
+					.end = 0x1F7,
+					.flags = LEGACY_IO_RESOURCE,
+				};
+
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
+				struct resource resource = {
+					.start = 0x170,
+					.end = 0x177,
+					.flags = LEGACY_IO_RESOURCE,
+				};
+
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

git-leds.patch
git-mips.patch
git-mtd.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
