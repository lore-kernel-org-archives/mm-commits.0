From: akpm@linux-foundation.org
Subject: + intel-iommu-pmen-support-fix.patch added to -mm tree
Date: Tue, 27 Nov 2007 15:55:26 -0800
Message-ID: <200711272355.lARNtQPu006104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbXK0Xze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 18:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com, muli@il.ibm.com


The patch titled
     intel-iommu-PMEN-think-oh patch.
has been added to the -mm tree.  Its filename is
     intel-iommu-pmen-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel-iommu-PMEN-think-oh patch.
From: mark gross <mgross@linux.intel.com>

I screwed up with my earlier patch to enable the portected memroy.  The
macro IOMMU_WAIT, exits when the condition goes true.  Without this
patch the code will hang at boot and some ( all?) vtd enabled systems.

Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-pmen-support-fix drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-pmen-support-fix
+++ a/drivers/pci/intel-iommu.c
@@ -704,7 +704,7 @@ static void iommu_disable_protect_mem_re
 
 	/* wait for the protected region status bit to clear */
 	IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
-		readl, (pmen & DMA_PMEN_PRS), pmen);
+		readl, !(pmen & DMA_PMEN_PRS), pmen);
 
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
_

Patches currently in -mm which might be from mgross@linux.intel.com are

pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
pm-qos-remove-locks-around-blocking-notifier.patch
latencyc-use-qos-infrastructure.patch
intel-iommu-pmen-support.patch
intel-iommu-pmen-support-fix.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
