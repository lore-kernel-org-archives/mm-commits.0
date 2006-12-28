From: akpm@osdl.org
Subject: + sparc32-add-offset-in-pci_map_sg.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:25:18 -0800
Message-ID: <200612282325.kBSNPIMt016039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41374 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbWL1X2s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:28:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jan.andersson@ieee.org, davem@davemloft.net, wli@holomorphy.com


The patch titled
     sparc32: add offset in pci_map_sg()
has been added to the -mm tree.  Its filename is
     sparc32-add-offset-in-pci_map_sg.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sparc32: add offset in pci_map_sg()
From: Jan Andersson jan.andersson@ieee.org

Add sg->offset to sg->dvma_address in pci_map_sg() on sparc32.  Without the
offset, transfers to buffers that do not begin on a page boundary will not
work as expected.

Signed-off-by: Jan Andersson <jan.andersson@ieee.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sparc/kernel/ioport.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/sparc/kernel/ioport.c~sparc32-add-offset-in-pci_map_sg arch/sparc/kernel/ioport.c
--- a/arch/sparc/kernel/ioport.c~sparc32-add-offset-in-pci_map_sg
+++ a/arch/sparc/kernel/ioport.c
@@ -726,7 +726,8 @@ int pci_map_sg(struct pci_dev *hwdev, st
 	/* IIep is write-through, not flushing. */
 	for (n = 0; n < nents; n++) {
 		BUG_ON(page_address(sg->page) == NULL);
-		sg->dvma_address = virt_to_phys(page_address(sg->page));
+		sg->dvma_address =
+			virt_to_phys(page_address(sg->page)) + sg->offset;
 		sg->dvma_length = sg->length;
 		sg++;
 	}
_

Patches currently in -mm which might be from jan.andersson@ieee.org are

sparc32-add-offset-in-pci_map_sg.patch

