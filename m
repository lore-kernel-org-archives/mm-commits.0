From: akpm@linux-foundation.org
Subject: - fix-wrong-proc-iomem-on-sgi-altix.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:03:40 -0800
Message-ID: <200703192203.l2JM3eh2018898@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030685AbXCSWDt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:03:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, jlan@engr.sgi.com, jpk@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix wrong /proc/iomem on SGI Altix
has been removed from the -mm tree.  Its filename was
     fix-wrong-proc-iomem-on-sgi-altix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: "Luck, Tony" <tony.luck@intel.com>
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

origin.patch
