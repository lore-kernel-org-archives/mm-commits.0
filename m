From: akpm@linux-foundation.org
Subject: [merged] pci-dmar-correct-off-by-one-error.patch removed from -mm tree
Date: Mon, 31 Aug 2009 14:19:06 -0700
Message-ID: <200908312119.n7VLJ6PW019201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZHaV2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Aug 2009 17:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: troy.heber@hp.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     pci/dmar: correct off-by-one error in dmar_fault()
has been removed from the -mm tree.  Its filename was
     pci-dmar-correct-off-by-one-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci/dmar: correct off-by-one error in dmar_fault()
From: Troy Heber <troy.heber@hp.com>

DMAR faults are recorded into a ring of "fault recording registers". 
fault_index is a 0-based index into the ring.  The code allows the 0-based
fault_index to be equal to the total number of fault registers available
from the cap_num_fault_regs() macro, which causes access beyond the last
available register.

Signed-off-by Troy Heber <troy.heber@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/dmar.c~pci-dmar-correct-off-by-one-error drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~pci-dmar-correct-off-by-one-error
+++ a/drivers/pci/dmar.c
@@ -1225,7 +1225,7 @@ irqreturn_t dmar_fault(int irq, void *de
 				source_id, guest_addr);
 
 		fault_index++;
-		if (fault_index > cap_num_fault_regs(iommu->cap))
+		if (fault_index >= cap_num_fault_regs(iommu->cap))
 			fault_index = 0;
 		spin_lock_irqsave(&iommu->register_lock, flag);
 	}
_

Patches currently in -mm which might be from troy.heber@hp.com are

linux-next.patch

