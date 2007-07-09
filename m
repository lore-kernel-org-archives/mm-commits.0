From: akpm@linux-foundation.org
Subject: - intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:47:02 -0700
Message-ID: <200707092347.l69Nl2SE021218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757139AbXGIXrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix Intel DMAR crash on AMD x86_64
has been removed from the -mm tree.  Its filename was
     intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64.patch

This patch was dropped because it was folded into intel-iommu-dmar-detection-and-parsing-logic.patch

------------------------------------------------------
Subject: Fix Intel DMAR crash on AMD x86_64
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Check for dmar_tbl pointer as this can be NULL on systems with no Intel
VT-d support.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pci/dmar.c~intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64 drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64
+++ a/drivers/pci/dmar.c
@@ -260,6 +260,8 @@ parse_dmar_table(void)
 	int ret = 0;
 
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	if (!dmar)
+		return -ENODEV;
 
 	if (!dmar->width) {
 		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
@@ -301,7 +303,7 @@ int __init dmar_table_init(void)
 
 	parse_dmar_table();
 	if (list_empty(&dmar_drhd_units)) {
-		printk(KERN_ERR PREFIX "No DMAR devices found\n");
+		printk(KERN_INFO PREFIX "No DMAR devices found\n");
 		return -ENODEV;
 	}
 	return 0;
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-iova-allocation-and-management-routines-fix-2.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-intel-iommu-driver-fix-duplicate-config_dmar-makefile-line.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
intel-iommu-iommu-floppy-workaround-fix-fix.patch
