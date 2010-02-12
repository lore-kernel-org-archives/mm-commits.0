From: akpm@linux-foundation.org
Subject: + dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch added to -mm tree
Date: Fri, 12 Feb 2010 12:08:03 -0800
Message-ID: <201002122008.o1CK83JT024049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757458Ab0BLUIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 15:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, benh@kernel.crashing.org, davem@davemloft.net, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, linux@arm.linux.org.uk


The patch titled
     dma-mapping: pci: convert pci_set_dma_mask to call dma_set_mask
has been added to the -mm tree.  Its filename is
     dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch

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
Subject: dma-mapping: pci: convert pci_set_dma_mask to call dma_set_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This changes pci_set_dma_mask to call the generic DMA API, dma_set_mask.

pci_set_dma_mask (in drivers/pci/pci.c) does the same things that
dma_set_mask does on all the architectures that use pci_set_dma_mask;
calls dma_supprted and sets dev->dma_mask.  So we safely change
pci_set_dma_mask to simply call dma_set_mask.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/pci/pci.c~dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask drivers/pci/pci.c
--- a/drivers/pci/pci.c~dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask
+++ a/drivers/pci/pci.c
@@ -2261,15 +2261,13 @@ void pci_msi_off(struct pci_dev *dev)
 int
 pci_set_dma_mask(struct pci_dev *dev, u64 mask)
 {
-	if (!pci_dma_supported(dev, mask))
-		return -EIO;
-
-	dev->dma_mask = mask;
+	int ret = dma_set_mask(&dev->dev, mask);
+	if (ret)
+		return ret;
 	dev_dbg(&dev->dev, "using %dbit DMA mask\n", fls64(mask));
-
 	return 0;
 }
-    
+
 int
 pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 {
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch

