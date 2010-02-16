From: akpm@linux-foundation.org
Subject: + ssb-add-dma_dev-to-ssb_device-structure.patch added to -mm tree
Date: Tue, 16 Feb 2010 13:40:31 -0800
Message-ID: <201002162140.o1GLeW7M006604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933316Ab0BPVlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 16:41:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Larry.Finger@lwfinger.net, davem@davemloft.net, linville@tuxdriver.com, mb@bu3sch.de, stefano.brivio@polimi.it, zambrano@broadcom.com


The patch titled
     ssb: add dma_dev to ssb_device structure
has been added to the -mm tree.  Its filename is
     ssb-add-dma_dev-to-ssb_device-structure.patch

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
Subject: ssb: add dma_dev to ssb_device structure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Add dma_dev, a pointer to struct device, to struct ssb_device.  We pass it
to the generic DMA API with SSB_BUSTYPE_PCI and SSB_BUSTYPE_SSB. 
ssb_devices_register() sets up it properly.

This is preparation for replacing the ssb bus specific DMA API (ssb_dma_*)
with the generic DMA API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Gary Zambrano <zambrano@broadcom.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/main.c      |    2 ++
 include/linux/ssb/ssb.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/ssb/main.c~ssb-add-dma_dev-to-ssb_device-structure drivers/ssb/main.c
--- a/drivers/ssb/main.c~ssb-add-dma_dev-to-ssb_device-structure
+++ a/drivers/ssb/main.c
@@ -485,6 +485,7 @@ static int ssb_devices_register(struct s
 #ifdef CONFIG_SSB_PCIHOST
 			sdev->irq = bus->host_pci->irq;
 			dev->parent = &bus->host_pci->dev;
+			sdev->dma_dev = dev->parent;
 #endif
 			break;
 		case SSB_BUSTYPE_PCMCIA:
@@ -500,6 +501,7 @@ static int ssb_devices_register(struct s
 			break;
 		case SSB_BUSTYPE_SSB:
 			dev->dma_mask = &dev->coherent_dma_mask;
+			sdev->dma_dev = dev;
 			break;
 		}
 
diff -puN include/linux/ssb/ssb.h~ssb-add-dma_dev-to-ssb_device-structure include/linux/ssb/ssb.h
--- a/include/linux/ssb/ssb.h~ssb-add-dma_dev-to-ssb_device-structure
+++ a/include/linux/ssb/ssb.h
@@ -167,7 +167,7 @@ struct ssb_device {
 	 * is an optimization. */
 	const struct ssb_bus_ops *ops;
 
-	struct device *dev;
+	struct device *dev, *dma_dev;
 
 	struct ssb_bus *bus;
 	struct ssb_device_id id;
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

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
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

