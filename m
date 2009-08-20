From: akpm@linux-foundation.org
Subject: + pci-dmar-correct-off-by-one-error.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:46:25 -0700
Message-ID: <200908202146.n7KLkP5w018146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbZHTVrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: troy.heber@hp.com, dwmw2@infradead.org


The patch titled
     pci/dmar: correct off-by-one error in dmar_fault()
has been added to the -mm tree.  Its filename is
     pci-dmar-correct-off-by-one-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

pci-dmar-correct-off-by-one-error.patch

