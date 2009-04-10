From: akpm@linux-foundation.org
Subject: + replace-all-dma_nbit_mask-macro-with-dma_bit_maskn.patch added to -mm tree
Date: Fri, 10 Apr 2009 14:31:27 -0700
Message-ID: <200904102131.n3ALVRDd032123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbZDJVhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 17:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanghy@cn.fujitsu.com, James.Bottomley@HansenPartnership.com, davem@davemloft.net, greg@kroah.com, rmk@arm.linux.org.uk, tiwai@suse.de, tony@atomide.com


The patch titled
     Replace all DMA_nBIT_MASK macro with DMA_BIT_MASK(n)
has been added to the -mm tree.  Its filename is
     replace-all-dma_nbit_mask-macro-with-dma_bit_maskn.patch

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
Subject: Replace all DMA_nBIT_MASK macro with DMA_BIT_MASK(n)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

This is the second go through of the old DMA_nBIT_MASK macro,and there're not
so many of them left,so I put them into one patch.I hope this is the last round.
After this the definition of the old DMA_nBIT_MASK macro could be removed.

Signed-off-by: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/usb-musb.c      |    8 ++++----
 arch/ia64/kernel/pci-swiotlb.c      |    2 +-
 drivers/atm/solos-pci.c             |    2 +-
 drivers/block/cciss.c               |    2 +-
 drivers/net/atl1c/atl1c_main.c      |    4 ++--
 drivers/net/benet/be_main.c         |    4 ++--
 drivers/net/jme.c                   |    8 ++++----
 drivers/net/wireless/ath9k/pci.c    |    4 ++--
 drivers/net/wireless/p54/p54pci.c   |    4 ++--
 drivers/scsi/3w-9xxx.c              |    8 ++++----
 drivers/scsi/aacraid/aachba.c       |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c |   10 +++++-----
 drivers/staging/b3dfg/b3dfg.c       |    2 +-
 drivers/usb/otg/nop-usb-xceiv.c     |    4 ++--
 sound/pci/hda/hda_intel.c           |    8 ++++----
 15 files changed, 36 insertions(+), 36 deletions(-)

diff -puN arch/arm/mach-omap2/usb-musb.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn arch/arm/mach-omap2/usb-musb.c
--- a/arch/arm/mach-omap2/usb-musb.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/arch/arm/mach-omap2/usb-musb.c
@@ -131,14 +131,14 @@ static struct musb_hdrc_platform_data mu
 	.power		= 50,			/* up to 100 mA */
 };
 
-static u64 musb_dmamask = DMA_32BIT_MASK;
+static u64 musb_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device musb_device = {
 	.name		= "musb_hdrc",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &musb_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &musb_plat,
 	},
 	.num_resources	= ARRAY_SIZE(musb_resources),
@@ -146,14 +146,14 @@ static struct platform_device musb_devic
 };
 
 #ifdef CONFIG_NOP_USB_XCEIV
-static u64 nop_xceiv_dmamask = DMA_32BIT_MASK;
+static u64 nop_xceiv_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device nop_xceiv_device = {
 	.name		= "nop_usb_xceiv",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &nop_xceiv_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= NULL,
 	},
 };
diff -puN arch/ia64/kernel/pci-swiotlb.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn arch/ia64/kernel/pci-swiotlb.c
--- a/arch/ia64/kernel/pci-swiotlb.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/arch/ia64/kernel/pci-swiotlb.c
@@ -16,7 +16,7 @@ EXPORT_SYMBOL(swiotlb);
 static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t gfp)
 {
-	if (dev->coherent_dma_mask != DMA_64BIT_MASK)
+	if (dev->coherent_dma_mask != DMA_BIT_MASK(64))
 		gfp |= GFP_DMA;
 	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
 }
diff -puN drivers/atm/solos-pci.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/atm/solos-pci.c
--- a/drivers/atm/solos-pci.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/atm/solos-pci.c
@@ -1059,7 +1059,7 @@ static int fpga_probe(struct pci_dev *de
 		goto out;
 	}
 
-	err = pci_set_dma_mask(dev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(dev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_warn(&dev->dev, "Failed to set 32-bit DMA mask\n");
 		goto out;
diff -puN drivers/block/cciss.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/block/cciss.c
--- a/drivers/block/cciss.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/block/cciss.c
@@ -3505,7 +3505,7 @@ static __devinit int cciss_message(struc
 	/* The Inbound Post Queue only accepts 32-bit physical addresses for the
 	   CCISS commands, so they must be allocated from the lower 4GiB of
 	   memory. */
-	err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
 		iounmap(vaddr);
 		return -ENOMEM;
diff -puN drivers/net/atl1c/atl1c_main.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/net/atl1c/atl1c_main.c
--- a/drivers/net/atl1c/atl1c_main.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/net/atl1c/atl1c_main.c
@@ -2532,8 +2532,8 @@ static int __devinit atl1c_probe(struct 
 	 * various kernel subsystems to support the mechanics required by a
 	 * fixed-high-32-bit system.
 	 */
-	if ((pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0) ||
-	    (pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK) != 0)) {
+	if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) ||
+	    (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)) {
 		dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
 		goto err_dma;
 	}
diff -puN drivers/net/benet/be_main.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/net/benet/be_main.c
--- a/drivers/net/benet/be_main.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/net/benet/be_main.c
@@ -1821,11 +1821,11 @@ static int __devinit be_probe(struct pci
 
 	be_msix_enable(adapter);
 
-	status = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	status = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (!status) {
 		netdev->features |= NETIF_F_HIGHDMA;
 	} else {
-		status = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		status = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (status) {
 			dev_err(&pdev->dev, "Could not set PCI DMA Mask\n");
 			goto free_netdev;
diff -puN drivers/net/jme.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/net/jme.c
--- a/drivers/net/jme.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/net/jme.c
@@ -2591,13 +2591,13 @@ static int
 jme_pci_dma64(struct pci_dev *pdev)
 {
 	if (pdev->device == PCI_DEVICE_ID_JMICRON_JMC250 &&
-	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK))
-		if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
+		if (!pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
 			return 1;
 
 	if (pdev->device == PCI_DEVICE_ID_JMICRON_JMC250 &&
-	    !pci_set_dma_mask(pdev, DMA_40BIT_MASK))
-		if (!pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK))
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(40)))
+		if (!pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(40)))
 			return 1;
 
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
diff -puN drivers/net/wireless/ath9k/pci.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/net/wireless/ath9k/pci.c
--- a/drivers/net/wireless/ath9k/pci.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/net/wireless/ath9k/pci.c
@@ -93,14 +93,14 @@ static int ath_pci_probe(struct pci_dev 
 	if (pci_enable_device(pdev))
 		return -EIO;
 
-	ret =  pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	ret =  pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 
 	if (ret) {
 		printk(KERN_ERR "ath9k: 32-bit DMA not available\n");
 		goto bad;
 	}
 
-	ret = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 
 	if (ret) {
 		printk(KERN_ERR "ath9k: 32-bit DMA consistent "
diff -puN drivers/net/wireless/p54/p54pci.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/net/wireless/p54/p54pci.c
@@ -492,8 +492,8 @@ static int __devinit p54p_probe(struct p
 		goto err_disable_dev;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
-	    pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
+	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		dev_err(&pdev->dev, "No suitable DMA available\n");
 		goto err_free_reg;
 	}
diff -puN drivers/scsi/3w-9xxx.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/scsi/3w-9xxx.c
@@ -2234,10 +2234,10 @@ static int twa_resume(struct pci_dev *pd
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
-	    || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)
-		    || pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 			TW_PRINTK(host, TW_DRIVER, 0x40, "Failed to set dma mask during resume");
 			retval = -ENODEV;
 			goto out_disable_device;
diff -puN drivers/scsi/aacraid/aachba.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/scsi/aacraid/aachba.c
@@ -1378,7 +1378,7 @@ int aac_get_adapter_info(struct aac_dev*
 	if (dev->nondasd_support && !dev->in_reset)
 		printk(KERN_INFO "%s%d: Non-DASD support enabled.\n",dev->name, dev->id);
 
-	if (dma_get_required_mask(&dev->pdev->dev) > DMA_32BIT_MASK)
+	if (dma_get_required_mask(&dev->pdev->dev) > DMA_BIT_MASK(32))
 		dev->needs_dac = 1;
 	dev->dac_support = 0;
 	if ((sizeof(dma_addr_t) > 4) && dev->needs_dac &&
diff -puN drivers/scsi/mpt2sas/mpt2sas_base.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/scsi/mpt2sas/mpt2sas_base.c
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -855,9 +855,9 @@ _base_config_dma_addressing(struct MPT2S
 	if (sizeof(dma_addr_t) > 4) {
 		const uint64_t required_mask =
 		    dma_get_required_mask(&pdev->dev);
-		if ((required_mask > DMA_32BIT_MASK) && !pci_set_dma_mask(pdev,
-		    DMA_64BIT_MASK) && !pci_set_consistent_dma_mask(pdev,
-		    DMA_64BIT_MASK)) {
+		if ((required_mask > DMA_BIT_MASK(32)) && !pci_set_dma_mask(pdev,
+		    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(pdev,
+		    DMA_BIT_MASK(64))) {
 			ioc->base_add_sg_single = &_base_add_sg_single_64;
 			ioc->sge_size = sizeof(Mpi2SGESimple64_t);
 			desc = "64";
@@ -865,8 +865,8 @@ _base_config_dma_addressing(struct MPT2S
 		}
 	}
 
-	if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
-	    && !pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+	    && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		ioc->base_add_sg_single = &_base_add_sg_single_32;
 		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
 		desc = "32";
diff -puN drivers/staging/b3dfg/b3dfg.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/staging/b3dfg/b3dfg.c
--- a/drivers/staging/b3dfg/b3dfg.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/staging/b3dfg/b3dfg.c
@@ -1000,7 +1000,7 @@ static int __devinit b3dfg_probe(struct 
 
 	pci_set_master(pdev);
 
-	r = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	r = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (r) {
 		dev_err(&pdev->dev, "no usable DMA configuration\n");
 		goto err_free_res;
diff -puN drivers/usb/otg/nop-usb-xceiv.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn drivers/usb/otg/nop-usb-xceiv.c
--- a/drivers/usb/otg/nop-usb-xceiv.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/drivers/usb/otg/nop-usb-xceiv.c
@@ -36,14 +36,14 @@ struct nop_usb_xceiv {
 	struct device		*dev;
 };
 
-static u64 nop_xceiv_dmamask = DMA_32BIT_MASK;
+static u64 nop_xceiv_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device nop_xceiv_device = {
 	.name           = "nop_usb_xceiv",
 	.id             = -1,
 	.dev = {
 		.dma_mask               = &nop_xceiv_dmamask,
-		.coherent_dma_mask      = DMA_32BIT_MASK,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
 		.platform_data          = NULL,
 	},
 };
diff -puN sound/pci/hda/hda_intel.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~replace-all-dma_nbit_mask-macro-with-dma_bit_maskn
+++ a/sound/pci/hda/hda_intel.c
@@ -2260,11 +2260,11 @@ static int __devinit azx_create(struct s
 		gcap &= ~0x01;
 
 	/* allow 64bit DMA address if supported by H/W */
-	if ((gcap & 0x01) && !pci_set_dma_mask(pci, DMA_64BIT_MASK))
-		pci_set_consistent_dma_mask(pci, DMA_64BIT_MASK);
+	if ((gcap & 0x01) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));
 	else {
-		pci_set_dma_mask(pci, DMA_32BIT_MASK);
-		pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK);
+		pci_set_dma_mask(pci, DMA_BIT_MASK(32));
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32));
 	}
 
 	/* read number of streams from GCAP register instead of using
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch
replace-all-dma_nbit_mask-macro-with-dma_bit_maskn.patch

