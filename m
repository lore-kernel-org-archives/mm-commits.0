From: akpm@osdl.org
Subject: + x86_64-improved-iommu-documentation.patch added to -mm tree
Date: Thu, 14 Dec 2006 14:32:28 -0800
Message-ID: <200612142232.kBEMWS7p030887@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964919AbWLNWdJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 17:33:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: K.Weiss@science-computing.de, ak@suse.de, knweiss@science-computing.de, muli@il.ibm.com


The patch titled
     x86_64: improved iommu documentation
has been added to the -mm tree.  Its filename is
     x86_64-improved-iommu-documentation.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: improved iommu documentation
From: Karsten Weiss <K.Weiss@science-computing.de>

- add SWIOTLB config help text
- mention Documentation/x86_64/boot-options.txt in
  Documentation/kernel-parameters.txt
- remove the duplication of the iommu kernel parameter documentation.
- Better explanation of some of the iommu kernel parameter options.
- "32MB<<order" instead of "32MB^order".
- Mention the default "order" value.
- list the four existing PCI-DMA mapping implementations of arch x86_64
- group the iommu= option keywords by PCI-DMA mapping implementation.
- Distinguish iommu= option keywords from number arguments.
- Explain the meaning of DAC and SAC.

Signed-off-by: Karsten Weiss <knweiss@science-computing.de>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt   |    3 
 Documentation/x86_64/boot-options.txt |  107 ++++++++++++++++--------
 arch/x86_64/Kconfig                   |   10 +-
 arch/x86_64/kernel/pci-dma.c          |   28 ------
 4 files changed, 89 insertions(+), 59 deletions(-)

diff -puN Documentation/kernel-parameters.txt~x86_64-improved-iommu-documentation Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~x86_64-improved-iommu-documentation
+++ a/Documentation/kernel-parameters.txt
@@ -105,6 +105,9 @@ loader, and have no meaning to the kerne
 Do not modify the syntax of boot loader parameters without extreme
 need or coordination with <Documentation/i386/boot.txt>.
 
+There are also arch-specific kernel-parameters not documented here.
+See for example <Documentation/x86_64/boot-options.txt>.
+
 Note that ALL kernel parameters listed below are CASE SENSITIVE, and that
 a trailing = on the name of any parameter states that that parameter will
 be entered as an environment variable, whereas its absence indicates that
diff -puN Documentation/x86_64/boot-options.txt~x86_64-improved-iommu-documentation Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-improved-iommu-documentation
+++ a/Documentation/x86_64/boot-options.txt
@@ -176,40 +176,81 @@ PCI
   pci=lastbus=NUMBER	       Scan upto NUMBER busses, no matter what the mptable says.
   pci=noacpi		Don't use ACPI to set up PCI interrupt routing.
 
-IOMMU
+IOMMU (input/output memory management unit)
 
- iommu=[size][,noagp][,off][,force][,noforce][,leak][,memaper[=order]][,merge]
-         [,forcesac][,fullflush][,nomerge][,noaperture][,calgary]
-   size  set size of iommu (in bytes)
-   noagp don't initialize the AGP driver and use full aperture.
-   off   don't use the IOMMU
-   leak  turn on simple iommu leak tracing (only when CONFIG_IOMMU_LEAK is on)
-   memaper[=order] allocate an own aperture over RAM with size 32MB^order.
-   noforce don't force IOMMU usage. Default.
-   force  Force IOMMU.
-   merge  Do SG merging. Implies force (experimental)
-   nomerge Don't do SG merging.
-   forcesac For SAC mode for masks <40bits  (experimental)
-   fullflush Flush IOMMU on each allocation (default)
-   nofullflush Don't use IOMMU fullflush
-   allowed  overwrite iommu off workarounds for specific chipsets.
-   soft	 Use software bounce buffering (default for Intel machines)
-   noaperture Don't touch the aperture for AGP.
-   allowdac Allow DMA >4GB
-	    When off all DMA over >4GB is forced through an IOMMU or bounce
-	    buffering.
-   nodac    Forbid DMA >4GB
-   panic    Always panic when IOMMU overflows
-   calgary  Use the Calgary IOMMU if it is available
-
-  swiotlb=pages[,force]
-
-  pages  Prereserve that many 128K pages for the software IO bounce buffering.
-  force  Force all IO through the software TLB.
-
-  calgary=[64k,128k,256k,512k,1M,2M,4M,8M]
-  calgary=[translate_empty_slots]
-  calgary=[disable=<PCI bus number>]
+ Currently four x86-64 PCI-DMA mapping implementations exist:
+
+   1. <arch/x86_64/kernel/pci-nommu.c>: use no hardware/software IOMMU at all
+      (e.g. because you have < 3 GB memory).
+      Kernel boot message: "PCI-DMA: Disabling IOMMU"
+
+   2. <arch/x86_64/kernel/pci-gart.c>: AMD GART based hardware IOMMU.
+      Kernel boot message: "PCI-DMA: using GART IOMMU"
+
+   3. <arch/x86_64/kernel/pci-swiotlb.c> : Software IOMMU implementation. Used
+      e.g. if there is no hardware IOMMU in the system and it is need because
+      you have >3GB memory or told the kernel to us it (iommu=soft))
+      Kernel boot message: "PCI-DMA: Using software bounce buffering
+      for IO (SWIOTLB)"
+
+   4. <arch/x86_64/pci-calgary.c> : IBM Calgary hardware IOMMU. Used in IBM
+      pSeries and xSeries servers. This hardware IOMMU supports DMA address
+      mapping with memory protection, etc.
+      Kernel boot message: "PCI-DMA: Using Calgary IOMMU"
+
+ iommu=[<size>][,noagp][,off][,force][,noforce][,leak[=<nr_of_leak_pages>]
+	[,memaper[=<order>]][,merge][,forcesac][,fullflush][,nomerge]
+	[,noaperture][,calgary]
+
+  General iommu options:
+    off                Don't initialize and use any kind of IOMMU.
+    noforce            Don't force hardware IOMMU usage when it is not needed.
+                       (default).
+    force              Force the use of the hardware IOMMU even when it is
+                       not actually needed (e.g. because < 3 GB memory).
+    soft               Use software bounce buffering (SWIOTLB) (default for
+                       Intel machines). This can be used to prevent the usage
+                       of an available hardware IOMMU.
+
+  iommu options only relevant to the AMD GART hardware IOMMU:
+    <size>             Set the size of the remapping area in bytes.
+    allowed            Overwrite iommu off workarounds for specific chipsets.
+    fullflush          Flush IOMMU on each allocation (default).
+    nofullflush        Don't use IOMMU fullflush.
+    leak               Turn on simple iommu leak tracing (only when
+                       CONFIG_IOMMU_LEAK is on). Default number of leak pages
+                       is 20.
+    memaper[=<order>]  Allocate an own aperture over RAM with size 32MB<<order.
+                       (default: order=1, i.e. 64MB)
+    merge              Do scather-gather (SG) merging. Implies "force"
+                       (experimental).
+    nomerge            Don't do scather-gather (SG) merging.
+    noaperture         Ask the IOMMU not to touch the aperture for AGP.
+    forcesac           Force single-address cycle (SAC) mode for masks <40bits
+                       (experimental).
+    noagp              Don't initialize the AGP driver and use full aperture.
+    allowdac           Allow double-address cycle (DAC) mode, i.e. DMA >4GB.
+                       DAC is used with 32-bit PCI to push a 64-bit address in
+                       two cycles. When off all DMA over >4GB is forced through
+                       an IOMMU or software bounce buffering.
+    nodac              Forbid DAC mode, i.e. DMA >4GB.
+    panic              Always panic when IOMMU overflows.
+    calgary            Use the Calgary IOMMU if it is available
+
+  iommu options only relevant to the software bounce buffering (SWIOTLB) IOMMU
+  implementation:
+    swiotlb=<pages>[,force]
+    <pages>            Prereserve that many 128K pages for the software IO
+                       bounce buffering.
+    force              Force all IO through the software TLB.
+
+  Settings for the IBM Calgary hardware IOMMU currently found in IBM
+  pSeries and xSeries machines:
+
+    calgary=[64k,128k,256k,512k,1M,2M,4M,8M]
+    calgary=[translate_empty_slots]
+    calgary=[disable=<PCI bus number>]
+    panic              Always panic when IOMMU overflows
 
     64k,...,8M - Set the size of each PCI slot's translation table
     when using the Calgary IOMMU. This is the size of the translation
diff -puN arch/x86_64/Kconfig~x86_64-improved-iommu-documentation arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-improved-iommu-documentation
+++ a/arch/x86_64/Kconfig
@@ -454,8 +454,8 @@ config IOMMU
 	  on systems with more than 3GB. This is usually needed for USB,
 	  sound, many IDE/SATA chipsets and some other devices.
 	  Provides a driver for the AMD Athlon64/Opteron/Turion/Sempron GART
-	  based IOMMU and a software bounce buffer based IOMMU used on Intel
-	  systems and as fallback.
+	  based hardware IOMMU and a software bounce buffer based IOMMU used
+	  on Intel systems and as fallback.
 	  The code is only active when needed (enough memory and limited
 	  device) unless CONFIG_IOMMU_DEBUG or iommu=force is specified
 	  too.
@@ -492,6 +492,12 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
+	help
+	  Support for software bounce buffers used on x86-64 systems
+	  which don't have a hardware IOMMU (e.g. the current generation
+	  of Intel's x86-64 CPUs). Using this PCI devices which can only
+	  access 32-bits of memory can be used on systems with more than
+	  3 GB of memory. If unsure, say Y.
 
 config X86_MCE
 	bool "Machine check support" if EMBEDDED
diff -puN arch/x86_64/kernel/pci-dma.c~x86_64-improved-iommu-documentation arch/x86_64/kernel/pci-dma.c
--- a/arch/x86_64/kernel/pci-dma.c~x86_64-improved-iommu-documentation
+++ a/arch/x86_64/kernel/pci-dma.c
@@ -223,30 +223,10 @@ int dma_set_mask(struct device *dev, u64
 }
 EXPORT_SYMBOL(dma_set_mask);
 
-/* iommu=[size][,noagp][,off][,force][,noforce][,leak][,memaper[=order]][,merge]
-         [,forcesac][,fullflush][,nomerge][,biomerge]
-   size  set size of iommu (in bytes)
-   noagp don't initialize the AGP driver and use full aperture.
-   off   don't use the IOMMU
-   leak  turn on simple iommu leak tracing (only when CONFIG_IOMMU_LEAK is on)
-   memaper[=order] allocate an own aperture over RAM with size 32MB^order.
-   noforce don't force IOMMU usage. Default.
-   force  Force IOMMU.
-   merge  Do lazy merging. This may improve performance on some block devices.
-          Implies force (experimental)
-   biomerge Do merging at the BIO layer. This is more efficient than merge,
-            but should be only done with very big IOMMUs. Implies merge,force.
-   nomerge Don't do SG merging.
-   forcesac For SAC mode for masks <40bits  (experimental)
-   fullflush Flush IOMMU on each allocation (default)
-   nofullflush Don't use IOMMU fullflush
-   allowed  overwrite iommu off workarounds for specific chipsets.
-   soft	 Use software bounce buffering (default for Intel machines)
-   noaperture Don't touch the aperture for AGP.
-   allowdac Allow DMA >4GB
-   nodac    Forbid DMA >4GB
-   panic    Force panic when IOMMU overflows
-*/
+/*
+ * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
+ * documentation.
+ */
 __init int iommu_setup(char *p)
 {
 	iommu_merge = 1;
_

Patches currently in -mm which might be from K.Weiss@science-computing.de are

x86_64-improved-iommu-documentation.patch

