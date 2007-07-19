From: akpm@linux-foundation.org
Subject: - x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:02 -0700
Message-ID: <200707192009.l6JK92UR020534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760776AbXGSUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: generalize calgary_increase_split_completion_timeout
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: generalize calgary_increase_split_completion_timeout
From: Muli Ben-Yehuda <muli@il.ibm.com>

... will be used by CalIOC2 later

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-generalize-calgary_increase_split_completion_timeout arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-generalize-calgary_increase_split_completion_timeout
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -775,8 +775,8 @@ static void calgary_watchdog(unsigned lo
 	}
 }
 
-static void __init calgary_increase_split_completion_timeout(void __iomem *bbar,
-	unsigned char busnum)
+static void __init calgary_set_split_completion_timeout(void __iomem *bbar,
+	unsigned char busnum, unsigned long timeout)
 {
 	u64 val64;
 	void __iomem *target;
@@ -802,7 +802,7 @@ static void __init calgary_increase_spli
 	/* zero out this PHB's timer bits */
 	mask = ~(0xFUL << phb_shift);
 	val64 &= mask;
-	val64 |= (CCR_2SEC_TIMEOUT << phb_shift);
+	val64 |= (timeout << phb_shift);
 	writeq(cpu_to_be64(val64), target);
 	readq(target); /* flush */
 }
@@ -836,7 +836,8 @@ static void __init calgary_enable_transl
 	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
 	 */
 	if (busnum == 1)
-		calgary_increase_split_completion_timeout(bbar, busnum);
+		calgary_set_split_completion_timeout(bbar, busnum,
+						     CCR_2SEC_TIMEOUT);
 
 	init_timer(&tbl->watchdog_timer);
 	tbl->watchdog_timer.function = &calgary_watchdog;
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
