From: akpm@linux-foundation.org
Subject: - x86_64-set-the-irq_chip-name-for-lapic.patch removed from -mm tree
Date: Tue, 26 Jun 2007 21:53:52 -0700
Message-ID: <200706270453.l5R4rqT1010132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46203 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbXF0EyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 00:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, ak@suse.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     x86_64: set the irq_chip name for lapic
has been removed from the -mm tree.  Its filename was
     x86_64-set-the-irq_chip-name-for-lapic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: set the irq_chip name for lapic
From: Suresh Siddha <suresh.b.siddha@intel.com>

/proc/interrupts:

            CPU0       CPU1
   0:    6343294          0    <NULL>-edge      timer

Set the irq_chip name for lapic.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-set-the-irq_chip-name-for-lapic arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-set-the-irq_chip-name-for-lapic
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1546,6 +1546,7 @@ static void ack_lapic_irq (unsigned int 
 static void end_lapic_irq (unsigned int i) { /* nothing */ }
 
 static struct hw_interrupt_type lapic_irq_type __read_mostly = {
+	.name = "local-APIC",
 	.typename = "local-APIC-edge",
 	.startup = NULL, /* startup_irq() not used for IRQ0 */
 	.shutdown = NULL, /* shutdown_irq() not used for IRQ0 */
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
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
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
