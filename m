From: akpm@linux-foundation.org
Subject: + x86-pci-fix-identity-mapping-for-sandy-bridge.patch added to -mm tree
Date: Wed, 22 Feb 2012 12:20:47 -0800
Message-ID: <20120222202048.69B31A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:41851 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2BVUUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2012 15:20:53 -0500
Received: by werb13 with SMTP id b13so17540wer.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Feb 2012 12:20:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, chrisw@sous-sol.org, drahn@suse.com, dwmw2@infradead.org, habeck@sgi.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com


The patch titled
     Subject: x86 PCI: fix identity mapping for sandy bridge
has been added to the -mm tree.  Its filename is
     x86-pci-fix-identity-mapping-for-sandy-bridge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 			ret = domain_add_dev_info(si_domain, pdev,
-						     hw ? CONTEXT_TT_PASS_THROUGH :
-						     CONTEXT_TT_MULTI_LEVEL);
-			if (ret)
+					     hw ? CONTEXT_TT_PASS_THROUGH :
+						  CONTEXT_TT_MULTI_LEVEL);
+			if (ret) {
+				/* device not associated with an iommu */
+				if (ret == -ENODEV)
+					continue;
 				return ret;
+			}
+			pr_info("IOMMU: %s identity mapping for device %s\n",
+				hw ? "hardware" : "software", pci_name(pdev));
 		}
 	}
 
_
Subject: Subject: x86 PCI: fix identity mapping for sandy bridge

Patches currently in -mm which might be from travis@sgi.com are

x86-pci-fix-identity-mapping-for-sandy-bridge.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch

