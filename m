From: akpm@linux-foundation.org
Subject: - calgary-fix-mis-handled-pci-topology.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:15:06 -0700
Message-ID: <200708141915.l7EJF6ld016758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765776AbXHNTVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernarde@br.ibm.com, ak@suse.de, mfb@br.ibm.com, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Calgary: fix mis-handled PCI topology
has been removed from the -mm tree.  Its filename was
     calgary-fix-mis-handled-pci-topology.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Calgary: fix mis-handled PCI topology
From: Murillo Fernandes Bernardes <bernarde@br.ibm.com>

Current code assumed that devices were directly connected to a Calgary
bridge, as it tried to get the iommu table directly from the parent bus
controller.

When we have another bridge between the Calgary/CalIOC2 bridge and the
device we should look upwards until we get to the top (Calgary/CalIOC2
bridge), where the iommu table resides.

Signed-off-by: Murillo Fernandes Bernardes <mfb@br.ibm.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~calgary-fix-mis-handled-pci-topology arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~calgary-fix-mis-handled-pci-topology
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -367,16 +367,15 @@ static inline struct iommu_table *find_i
 
 	pdev = to_pci_dev(dev);
 
-	/* is the device behind a bridge? */
-	if (unlikely(pdev->bus->parent))
-		pbus = pdev->bus->parent;
-	else
-		pbus = pdev->bus;
+	pbus = pdev->bus;
+
+	/* is the device behind a bridge? Look for the root bus */
+	while (pbus->parent)
+		pbus = pbus->parent;
 
 	tbl = pci_iommu(pbus);
 
-	BUG_ON(pdev->bus->parent &&
-	       (tbl->it_busno != pdev->bus->parent->number));
+	BUG_ON(tbl && (tbl->it_busno != pbus->number));
 
 	return tbl;
 }
_

Patches currently in -mm which might be from bernarde@br.ibm.com are
