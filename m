From: akpm@linux-foundation.org
Subject: + pci-fix-msi-x-with-niu-cards.patch added to -mm tree
Date: Mon, 11 May 2009 13:15:01 -0700
Message-ID: <200905112015.n4BKF1Di020042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbZEKUR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 16:17:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, davem@davemloft.net, jbarnes@virtuousgeek.org, willy@linux.intel.com


The patch titled
     pci: fix MSI-X with NIU cards
has been added to the -mm tree.  Its filename is
     pci-fix-msi-x-with-niu-cards.patch

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
Subject: pci: fix MSI-X with NIU cards
From: Matthew Wilcox <matthew@wil.cx>

The NIU device refuses to allow accesses to MSI-X registers before MSI-X
is enabled.  This patch fixes the problem by moving the read of the mask
register to after MSI-X is enabled.

Reported-by: David S. Miller <davem@davemloft.net>
Tested-by: David S. Miller <davem@davemloft.net>
Reviewed-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/pci/msi.c~pci-fix-msi-x-with-niu-cards drivers/pci/msi.c
--- a/drivers/pci/msi.c~pci-fix-msi-x-with-niu-cards
+++ a/drivers/pci/msi.c
@@ -455,8 +455,6 @@ static int msix_capability_init(struct p
 		entry->msi_attrib.default_irq = dev->irq;
 		entry->msi_attrib.pos = pos;
 		entry->mask_base = base;
-		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
-					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
 		msix_mask_irq(entry, 1);
 
 		list_add_tail(&entry->list, &dev->msi_list);
@@ -493,6 +491,12 @@ static int msix_capability_init(struct p
 	msix_set_enable(dev, 1);
 	dev->msix_enabled = 1;
 
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		int vector = entry->msi_attrib.entry_nr;
+		entry->masked = readl(base + vector * PCI_MSIX_ENTRY_SIZE +
+					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from matthew@wil.cx are

linux-next.patch
scsi-ncr53c8xx-div-reaches-1.patch
pci-fix-msi-x-with-niu-cards.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
make-sure-nobodys-leaking-resources.patch

