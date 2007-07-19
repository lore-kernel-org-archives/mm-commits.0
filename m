From: akpm@linux-foundation.org
Subject: - x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:07 -0700
Message-ID: <200707192009.l6JK97uf020546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760840AbXGSUP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: introduce handle_quirks() for various chipset quirks
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: introduce handle_quirks() for various chipset quirks
From: Muli Ben-Yehuda <muli@il.ibm.com>

Move the aic94xx split completion timeout handling there.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -807,6 +807,20 @@ static void __init calgary_set_split_com
 	readq(target); /* flush */
 }
 
+static void __init calgary_handle_quirks(struct pci_dev* dev)
+{
+	unsigned char busnum = dev->bus->number;
+	struct iommu_table *tbl = dev->sysdata;
+
+	/*
+	 * Give split completion a longer timeout on bus 1 for aic94xx
+	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
+	 */
+	if (busnum == 1)
+		calgary_set_split_completion_timeout(tbl->bbar, busnum,
+						     CCR_2SEC_TIMEOUT);
+}
+
 static void __init calgary_enable_translation(struct pci_dev *dev)
 {
 	u32 val32;
@@ -831,14 +845,6 @@ static void __init calgary_enable_transl
 	writel(cpu_to_be32(val32), target);
 	readl(target); /* flush */
 
-	/*
-	 * Give split completion a longer timeout on bus 1 for aic94xx
-	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
-	 */
-	if (busnum == 1)
-		calgary_set_split_completion_timeout(bbar, busnum,
-						     CCR_2SEC_TIMEOUT);
-
 	init_timer(&tbl->watchdog_timer);
 	tbl->watchdog_timer.function = &calgary_watchdog;
 	tbl->watchdog_timer.data = (unsigned long)dev;
@@ -890,6 +896,9 @@ static int __init calgary_init_one(struc
 
 	pci_dev_get(dev);
 	dev->bus->self = dev;
+
+	calgary_handle_quirks(dev);
+
 	calgary_enable_translation(dev);
 
 	return 0;
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
