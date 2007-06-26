From: akpm@linux-foundation.org
Subject: + intel-iommu-intel-iommu-cmdline-option-forcedac.patch added to -mm tree
Date: Mon, 25 Jun 2007 23:43:03 -0700
Message-ID: <200706260643.l5Q6h3l7020236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbXFZGnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 02:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.com, suresh.b.siddha@intel.com


The patch titled
     Intel IOMMU: Intel iommu cmdline option - forcedac
has been added to the -mm tree.  Its filename is
     intel-iommu-intel-iommu-cmdline-option-forcedac.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -794,6 +794,13 @@ and is between 256 and 4096 characters. 
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
@@ -53,6 +53,7 @@ static void domain_remove_dev_info(struc
 
 static int dmar_disabled;
 static int __initdata dmar_map_gfx = 1;
+static int dmar_forcedac;
 
 #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
@@ -70,6 +71,10 @@ static int __init intel_iommu_setup(char
 			dmar_map_gfx = 0;
 			printk(KERN_INFO
 				"Intel-IOMMU: disable GFX device mapping\n");
+		} else if (!strncmp(str, "forcedac", 8)) {
+			printk (KERN_INFO
+				"Intel-IOMMU: Forcing DAC for PCI devices\n");
+			dmar_forcedac = 1;
 		}
 
 		str += strcspn(str, ",");
@@ -1557,7 +1562,7 @@ static dma_addr_t __intel_map_single(str
 
 	start_addr = IOVA_START_ADDR;
 
-	if (pdev->dma_mask <= DMA_32BIT_MASK) {
+	if ((pdev->dma_mask <= DMA_32BIT_MASK) || (dmar_forcedac)) {
 		iova = iommu_alloc_iova(domain, addr, size, start_addr,
 			pdev->dma_mask);
 	} else  {
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
