From: akpm@linux-foundation.org
Subject: - intel-iommu-pmen-support-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:35:42 -0800
Message-ID: <200802080835.m188ZN4M015850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756843AbYBHIf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:35:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     intel-iommu-PMEN-think-oh patch.
has been removed from the -mm tree.  Its filename was
     intel-iommu-pmen-support-fix.patch

This patch was dropped because it was folded into intel-iommu-pmen-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
intel-iommu-pmen-support.patch
intel-iommu-pmen-support-fix.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
