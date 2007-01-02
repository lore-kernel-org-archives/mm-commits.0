From: akpm@osdl.org
Subject: - sparc32-add-offset-in-pci_map_sg.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:25:26 -0800
Message-ID: <200701020725.l027PQOM013043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37717 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934AbXABH2x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:28:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.andersson@ieee.org, davem@davemloft.net, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     sparc32: add offset in pci_map_sg()
has been removed from the -mm tree.  Its filename was
     sparc32-add-offset-in-pci_map_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 1 deletion(-)

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
