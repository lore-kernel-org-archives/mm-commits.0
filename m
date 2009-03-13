From: akpm@linux-foundation.org
Subject: [merged] pcie-aer-during-disable-check-subordinate-before-walking.patch removed from -mm tree
Date: Fri, 13 Mar 2009 11:19:51 -0700
Message-ID: <200903131819.n2DIJpd1008651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759036AbZCMSXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 14:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, andrew.patterson@hp.com, matthew@wil.cx, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PCIe: AER: during disable, check subordinate before walking
has been removed from the -mm tree.  Its filename was
     pcie-aer-during-disable-check-subordinate-before-walking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCIe: AER: during disable, check subordinate before walking
From: Alex Chiang <achiang@hp.com>

Commit 47a8b0cc (Enable PCIe AER only after checking firmware
support) wants to walk the PCI bus in the remove path to disable
AER, and calls pci_walk_bus for downstream bridges.

Unfortunately, in the remove path, we remove devices and bridges in a
depth-first manner, starting with the furthest downstream bridge and
working our way backwards.

The furthest downstream bridges will not have a dev->subordinate, and we
hit a NULL deref in pci_walk_bus.

Check for dev->subordinate first before attempting to walk the PCI
hierarchy below us.

Acked-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv_core.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/pci/pcie/aer/aerdrv_core.c~pcie-aer-during-disable-check-subordinate-before-walking drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~pcie-aer-during-disable-check-subordinate-before-walking
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -133,6 +133,9 @@ static void set_downstream_devices_error
 						   bool enable)
 {
 	set_device_error_reporting(dev, &enable);
+
+	if (!dev->subordinate)
+		return;
 	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
 }
 
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch
pcie-portdrv-eliminate-double-kfree-in-remove-path.patch

