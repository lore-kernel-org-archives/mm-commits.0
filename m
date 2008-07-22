From: akpm@linux-foundation.org
Subject: - intel-iommu-rmrrs-do-not-necessarily-have-to-be-present-on-all-vt-d-capable-platforms.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:32:32 -0700
Message-ID: <200807222132.m6MLWWXd018727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbYGVVkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.y.wang@linux.intel.com, anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com, jbarnes@virtuousgeek.org, mgross@linux.intel.com, yong.y.wang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Intel IOMMU: RMRRs do not necessarily have to be present on all VT-d capable platforms
has been removed from the -mm tree.  Its filename was
     intel-iommu-rmrrs-do-not-necessarily-have-to-be-present-on-all-vt-d-capable-platforms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Intel IOMMU: RMRRs do not necessarily have to be present on all VT-d capable platforms
From: Yong Wang <yong.y.wang@linux.intel.com>

RMRRs do not necessarily have to be present on all VT-d capable platforms. 
The printk is just informational and does not need to be followed by an error
return.

Signed-off-by: Yong Y Wang <yong.y.wang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: mark gross <mgross@linux.intel.com>
Cc: Keshavamurthy, Anil S <anil.s.keshavamurthy@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/pci/dmar.c~intel-iommu-rmrrs-do-not-necessarily-have-to-be-present-on-all-vt-d-capable-platforms drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~intel-iommu-rmrrs-do-not-necessarily-have-to-be-present-on-all-vt-d-capable-platforms
+++ a/drivers/pci/dmar.c
@@ -317,10 +317,8 @@ int __init dmar_table_init(void)
 		return -ENODEV;
 	}
 
-	if (list_empty(&dmar_rmrr_units)) {
+	if (list_empty(&dmar_rmrr_units))
 		printk(KERN_INFO PREFIX "No RMRR found\n");
-		return -ENODEV;
-	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from yong.y.wang@linux.intel.com are


