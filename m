From: akpm@linux-foundation.org
Subject: + replace-all-dma_24bit_mask-macro-with-dma_bit_mask24.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:14:44 -0800
Message-ID: <200902192314.n1JNEicm029819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165AbZBSXVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:21:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanghy@cn.fujitsu.com


The patch titled
     dma-mapping: replace all DMA_24BIT_MASK macro with DMA_BIT_MASK(24)
has been added to the -mm tree.  Its filename is
     replace-all-dma_24bit_mask-macro-with-dma_bit_mask24.patch

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
Subject: dma-mapping: replace all DMA_24BIT_MASK macro with DMA_BIT_MASK(24)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_24BIT_MASK macro with DMA_BIT_MASK(24)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/pci-dma.c         |    2 +-
 arch/x86/include/asm/dma-mapping.h |    4 ++--
 arch/x86/kernel/pci-dma.c          |    2 +-
 drivers/base/isa.c                 |    2 +-
 drivers/pnp/card.c                 |    2 +-
 drivers/pnp/core.c                 |    2 +-
 sound/pci/als4000.c                |    4 ++--
 sound/pci/azt3328.c                |    4 ++--
 sound/pci/es1938.c                 |    4 ++--
 sound/pci/sonicvibes.c             |    4 ++--
 10 files changed, 15 insertions(+), 15 deletions(-)

diff -puN arch/ia64/kernel/pci-dma.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 arch/ia64/kernel/pci-dma.c
--- a/arch/ia64/kernel/pci-dma.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/arch/ia64/kernel/pci-dma.c
@@ -75,7 +75,7 @@ int iommu_dma_supported(struct device *d
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
 	   The caller just has to use GFP_DMA in this case. */
-	if (mask < DMA_24BIT_MASK)
+	if (mask < DMA_BIT_MASK(24))
 		return 0;
 
 	/* Tell the device to use SAC when IOMMU force is on.  This
diff -puN arch/x86/include/asm/dma-mapping.h~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -211,7 +211,7 @@ static inline unsigned long dma_alloc_co
 
 	dma_mask = dev->coherent_dma_mask;
 	if (!dma_mask)
-		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_BIT_MASK(32);
+		dma_mask = (gfp & GFP_DMA) ? DMA_BIT_MASK(24) : DMA_BIT_MASK(32);
 
 	return dma_mask;
 }
@@ -220,7 +220,7 @@ static inline gfp_t dma_alloc_coherent_g
 {
 	unsigned long dma_mask = dma_alloc_coherent_mask(dev, gfp);
 
-	if (dma_mask <= DMA_24BIT_MASK)
+	if (dma_mask <= DMA_BIT_MASK(24))
 		gfp |= GFP_DMA;
 #ifdef CONFIG_X86_64
 	if (dma_mask <= DMA_BIT_MASK(32) && !(gfp & GFP_DMA))
diff -puN arch/x86/kernel/pci-dma.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/arch/x86/kernel/pci-dma.c
@@ -239,7 +239,7 @@ int dma_supported(struct device *dev, u6
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
 	   The caller just has to use GFP_DMA in this case. */
-	if (mask < DMA_24BIT_MASK)
+	if (mask < DMA_BIT_MASK(24))
 		return 0;
 
 	/* Tell the device to use SAC when IOMMU force is on.  This
diff -puN drivers/base/isa.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 drivers/base/isa.c
--- a/drivers/base/isa.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/drivers/base/isa.c
@@ -141,7 +141,7 @@ int isa_register_driver(struct isa_drive
 		isa_dev->dev.release		= isa_dev_release;
 		isa_dev->id			= id;
 
-		isa_dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
+		isa_dev->dev.coherent_dma_mask = DMA_BIT_MASK(24);
 		isa_dev->dev.dma_mask = &isa_dev->dev.coherent_dma_mask;
 
 		error = device_register(&isa_dev->dev);
diff -puN drivers/pnp/card.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 drivers/pnp/card.c
--- a/drivers/pnp/card.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/drivers/pnp/card.c
@@ -167,7 +167,7 @@ struct pnp_card *pnp_alloc_card(struct p
 	card->dev.parent = &card->protocol->dev;
 	dev_set_name(&card->dev, "%02x:%02x", card->protocol->number, card->number);
 
-	card->dev.coherent_dma_mask = DMA_24BIT_MASK;
+	card->dev.coherent_dma_mask = DMA_BIT_MASK(24);
 	card->dev.dma_mask = &card->dev.coherent_dma_mask;
 
 	dev_id = pnp_add_card_id(card, pnpid);
diff -puN drivers/pnp/core.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 drivers/pnp/core.c
--- a/drivers/pnp/core.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/drivers/pnp/core.c
@@ -137,7 +137,7 @@ struct pnp_dev *pnp_alloc_dev(struct pnp
 	INIT_LIST_HEAD(&dev->options);
 	dev->protocol = protocol;
 	dev->number = id;
-	dev->dma_mask = DMA_24BIT_MASK;
+	dev->dma_mask = DMA_BIT_MASK(24);
 
 	dev->dev.parent = &dev->protocol->dev;
 	dev->dev.bus = &pnp_bus_type;
diff -puN sound/pci/als4000.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 sound/pci/als4000.c
--- a/sound/pci/als4000.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/sound/pci/als4000.c
@@ -872,8 +872,8 @@ static int __devinit snd_card_als4000_pr
 		return err;
 	}
 	/* check, if we can restrict PCI DMA transfers to 24 bits */
-	if (pci_set_dma_mask(pci, DMA_24BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_24BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(24)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(24)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support 24bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/azt3328.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 sound/pci/azt3328.c
--- a/sound/pci/azt3328.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/sound/pci/azt3328.c
@@ -2125,8 +2125,8 @@ snd_azf3328_create(struct snd_card *card
 	chip->irq = -1;
 
 	/* check if we can restrict PCI DMA transfers to 24 bits */
-	if (pci_set_dma_mask(pci, DMA_24BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_24BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(24)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(24)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support "
 					"24bit PCI busmaster DMA\n"
 		);
diff -puN sound/pci/es1938.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 sound/pci/es1938.c
--- a/sound/pci/es1938.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/sound/pci/es1938.c
@@ -1608,8 +1608,8 @@ static int __devinit snd_es1938_create(s
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
         /* check, if we can restrict PCI DMA transfers to 24 bits */
-	if (pci_set_dma_mask(pci, DMA_24BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_24BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(24)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(24)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support 24bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
                 return -ENXIO;
diff -puN sound/pci/sonicvibes.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24 sound/pci/sonicvibes.c
--- a/sound/pci/sonicvibes.c~replace-all-dma_24bit_mask-macro-with-dma_bit_mask24
+++ a/sound/pci/sonicvibes.c
@@ -1264,8 +1264,8 @@ static int __devinit snd_sonicvibes_crea
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
 	/* check, if we can restrict PCI DMA transfers to 24 bits */
-        if (pci_set_dma_mask(pci, DMA_24BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_24BIT_MASK) < 0) {
+        if (pci_set_dma_mask(pci, DMA_BIT_MASK(24)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(24)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support 24bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
                 return -ENXIO;
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

replace-all-dma_64bit_mask-macro-with-dma_bit_mask64.patch
replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch
replace-all-dma_40bit_mask-macro-with-dma_bit_mask40.patch
replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch
replace-all-dma_35bit_mask-macro-with-dma_bit_mask35.patch
replace-all-dma_32bit_mask-macro-with-dma_bit_mask32.patch
replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch
replace-all-dma_30bit_mask-macro-with-dma_bit_mask30.patch
replace-all-dma_28bit_mask-macro-with-dma_bit_mask28.patch
replace-all-dma_24bit_mask-macro-with-dma_bit_mask24.patch
update-the-old-macro-dma_nbit_mask-related-documentations.patch
update-related-documentations.patch

