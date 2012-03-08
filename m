From: akpm@linux-foundation.org
Subject: [merged] x86-pci-fix-identity-mapping-for-sandy-bridge.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:37 -0800
Message-ID: <20120308191737.835AFA06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:45765 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab2CHTRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:38 -0500
Received: by qcsp5 with SMTP id p5so104032qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, chrisw@sous-sol.org, drahn@suse.com, dwmw2@infradead.org, habeck@sgi.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86 PCI: fix identity mapping for sandy bridge
has been removed from the -mm tree.  Its filename was
     x86-pci-fix-identity-mapping-for-sandy-bridge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mike Travis <travis@sgi.com>
Subject: x86 PCI: fix identity mapping for sandy bridge

With SandyBridge, Intel has changed these Socket PCI devices to have a
class type of "System Peripheral" & "Performance counter", rather than
"HostBridge".  So instead of using a "special" case to detect which
devices will not be doing DMA, use the fact that a device that is not
associated with an IOMMU, will not need an identity map.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Mike Habeck <habeck@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Daniel Rahn <drahn@suse.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/intel-iommu.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN drivers/iommu/intel-iommu.c~x86-pci-fix-identity-mapping-for-sandy-bridge drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~x86-pci-fix-identity-mapping-for-sandy-bridge
+++ a/drivers/iommu/intel-iommu.c
@@ -48,8 +48,6 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
-#define IS_BRIDGE_HOST_DEVICE(pdev) \
-			    ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
@@ -2369,18 +2367,18 @@ static int __init iommu_prepare_static_i
 		return -EFAULT;
 
 	for_each_pci_dev(pdev) {
-		/* Skip Host/PCI Bridge devices */
-		if (IS_BRIDGE_HOST_DEVICE(pdev))
-			continue;
 		if (iommu_should_identity_map(pdev, 1)) {
-			printk(KERN_INFO "IOMMU: %s identity mapping for device %s\n",
-			       hw ? "hardware" : "software", pci_name(pdev));
