From: akpm@linux-foundation.org
Subject: + intel-iommu-rmrrs-do-not-necessarily-have-to-be-present-on-all-vt-d-capable-platforms.patch added to -mm tree
Date: Thu, 10 Jul 2008 01:03:14 -0700
Message-ID: <200807100808.m6A88g3q016156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbYGJIJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jul 2008 04:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.y.wang@linux.intel.com, anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com, jbarnes@virtuousgeek.org, mgross@linux.intel.com, yong.y.wang@intel.com


The patch titled
     Intel IOMMU: RMRRs do not necessarily have to be present on all VT-d capable platforms
has been added to the -mm tree.  Its filename is
     intel-iommu-rmrrs-do-not-necessarily-have-to-be-present-on-all-vt-d-capable-platforms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

intel-iommu-rmrrs-do-not-necessarily-have-to-be-present-on-all-vt-d-capable-platforms.patch

