From: akpm@linux-foundation.org
Subject: [merged] pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci.patch removed from -mm tree
Date: Mon, 25 Jul 2011 12:04:46 -0700
Message-ID: <201107251903.p6PJ3tTr022511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510Ab1GYTEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 15:04:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiejun.chen@windriver.com, jbarnes@virtuousgeek.org, rajesh.shah@intel.com, mm-commits@vger.kernel.org


The patch titled
     pci: enumerate the PCI device only removed out PCI hierarchy of OS when re-scanning PCI
has been removed from the -mm tree.  Its filename was
     pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: enumerate the PCI device only removed out PCI hierarchy of OS when re-scanning PCI
From: Tiejun Chen <tiejun.chen@windriver.com>

When hot-plugging a root bridge, we always prevent assigning a bus number
that already exists.  This makes sure we don't step over an existing bus. 
But sometimes we only remove PCI device in PCI hieratchy of OS, i,e.

echo 1 > /sys/bus/pci/devices/.../remove

but actually don't hotplug this device out the platform, so in this case
we still should re-scan this bus to enumerate this device when re-scanning
PCI again.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: <rajesh.shah@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/pci/probe.c~pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci
+++ a/drivers/pci/probe.c
@@ -725,12 +725,14 @@ int __devinit pci_scan_bridge(struct pci
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
 		/* Prevent assigning a bus number that already exists.
-		 * This can happen when a bridge is hot-plugged */
-		if (pci_find_bus(pci_domain_nr(bus), max+1))
-			goto out;
-		child = pci_add_new_bus(bus, dev, ++max);
-		if (!child)
-			goto out;
+		 * This can happen when a bridge is hot-plugged, so in
+		 * this case we only re-scan this bus. */
+		child = pci_find_bus(pci_domain_nr(bus), max+1);
+		if (!child) {
+			child = pci_add_new_bus(bus, dev, ++max);
+			if (!child)
+				goto out;
+		}
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
 		      | ((unsigned int)(child->secondary)   <<  8)
_

Patches currently in -mm which might be from tiejun.chen@windriver.com are

linux-next.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch

