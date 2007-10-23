From: akpm@linux-foundation.org
Subject: - intel-iommu-intel-iommu-cmdline-option-forcedac.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:46:57 -0700
Message-ID: <200710230646.l9N6kv6w004245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbXJWGrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.coms


The patch titled
     Intel IOMMU: Intel iommu cmdline option - forcedac
has been removed from the -mm tree.  Its filename was
     intel-iommu-intel-iommu-cmdline-option-forcedac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Intel IOMMU: Intel iommu cmdline option - forcedac
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Introduce intel_iommu=forcedac commandline option.  This option is helpful to
verify the pci device capability of handling physical dma'able address greater
than 4G.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 drivers/pci/intel-iommu.c           |    7 ++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~intel-iommu-intel-iommu-cmdline-option-forcedac Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~intel-iommu-intel-iommu-cmdline-option-forcedac
+++ a/Documentation/kernel-parameters.txt
@@ -781,6 +781,13 @@ and is between 256 and 4096 characters. 
 			bypassed by not enabling DMAR with this option. In
 			this case, gfx device will use physical address for
 			DMA.
+		forcedac [x86_64]
+			With this option iommu will not optimize to look
+			for io virtual address below 32 bit forcing dual
+			address cycle on pci bus for cards supporting greater
+			than 32 bit addressing. The default is to look
+			for translation below 32 bit and if not available
+			then look in the higher range.
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
diff -puN drivers/pci/intel-iommu.c~intel-iommu-intel-iommu-cmdline-option-forcedac drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-intel-iommu-cmdline-option-forcedac
+++ a/drivers/pci/intel-iommu.c
@@ -54,6 +54,7 @@ static void domain_remove_dev_info(struc
 
 static int dmar_disabled;
 static int __initdata dmar_map_gfx = 1;
+static int dmar_forcedac;
 
 #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
@@ -71,6 +72,10 @@ static int __init intel_iommu_setup(char
 			dmar_map_gfx = 0;
 			printk(KERN_INFO
 				"Intel-IOMMU: disable GFX device mapping\n");
+		} else if (!strncmp(str, "forcedac", 8)) {
+			printk (KERN_INFO
+				"Intel-IOMMU: Forcing DAC for PCI devices\n");
+			dmar_forcedac = 1;
 		}
 
 		str += strcspn(str, ",");
@@ -1558,7 +1563,7 @@ static dma_addr_t __intel_map_single(str
 
 	start_addr = IOVA_START_ADDR;
 
-	if (pdev->dma_mask <= DMA_32BIT_MASK) {
+	if ((pdev->dma_mask <= DMA_32BIT_MASK) || (dmar_forcedac)) {
 		iova = iommu_alloc_iova(domain, addr, size, start_addr,
 			pdev->dma_mask);
 	} else  {
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

origin.patch
