From: akpm@linux-foundation.org
Subject: + intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64.patch added to -mm tree
Date: Mon, 02 Jul 2007 21:56:23 -0700
Message-ID: <200707030456.l634uNsD000301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbXGCE4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 00:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com


The patch titled
     Fix Intel DMAR crash on AMD x86_64
has been added to the -mm tree.  Its filename is
     intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
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
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
intel-iommu-iommu-floppy-workaround-fix-fix.patch
