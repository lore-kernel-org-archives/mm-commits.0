From: akpm@linux-foundation.org
Subject: + fix-wrong-proc-iomem-on-sgi-altix.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:52:13 -0800
Message-ID: <200703151852.l2FIqFUc023382@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35677 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbXCOSwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, jlan@engr.sgi.com, jpk@sgi.com, tony.luck@intel.com


The patch titled
     Fix wrong /proc/iomem on SGI Altix
has been added to the -mm tree.  Its filename is
     fix-wrong-proc-iomem-on-sgi-altix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix wrong /proc/iomem on SGI Altix
From: Bernhard Walle <bwalle@suse.de>

In sn_io_slot_fixup(), the parent is re-set from the bus to
io(port|mem)_resource because the address is changed in a way that it's not
child of the bus any more.

However, only the root is set but not the parent/child/sibling relationship
in the resource tree which causes 'cat /proc/iomem' to stop after this
memory area.  Depding on the poition in the tree the iomem may be nearly
completely empty.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: John Keller <jpk@sgi.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/io_init.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN arch/ia64/sn/kernel/io_init.c~fix-wrong-proc-iomem-on-sgi-altix arch/ia64/sn/kernel/io_init.c
--- a/arch/ia64/sn/kernel/io_init.c~fix-wrong-proc-iomem-on-sgi-altix
+++ a/arch/ia64/sn/kernel/io_init.c
@@ -247,10 +247,18 @@ sn_io_slot_fixup(struct pci_dev *dev)
 		addr = ((addr << 4) >> 4) | __IA64_UNCACHED_OFFSET;
 		dev->resource[idx].start = addr;
 		dev->resource[idx].end = addr + size;
+
+		/*
+		 * if it's already in the device structure, remove it before
+		 * inserting
+		 */
+		if (dev->resource[idx].parent && dev->resource[idx].parent->child)
+			release_resource(&dev->resource[idx]);
+
 		if (dev->resource[idx].flags & IORESOURCE_IO)
-			dev->resource[idx].parent = &ioport_resource;
+			insert_resource(&ioport_resource, &dev->resource[idx]);
 		else
-			dev->resource[idx].parent = &iomem_resource;
+			insert_resource(&iomem_resource, &dev->resource[idx]);
 		/* If ROM, mark as shadowed in PROM */
 		if (idx == PCI_ROM_RESOURCE)
 			dev->resource[idx].flags |= IORESOURCE_ROM_BIOS_COPY;
_

Patches currently in -mm which might be from bwalle@suse.de are

git-acpi.patch
git-r8169.patch
fix-wrong-proc-iomem-on-sgi-altix.patch
