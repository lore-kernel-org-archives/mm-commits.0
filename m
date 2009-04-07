From: akpm@linux-foundation.org
Subject: [merged] replace-all-dma_28bit_mask-macro-with-dma_bit_mask28.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:04 -0700
Message-ID: <200904071908.n37J84Rr011610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755385AbZDGTJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: replace all DMA_28BIT_MASK macro with DMA_BIT_MASK(28)
has been removed from the -mm tree.  Its filename was
     replace-all-dma_28bit_mask-macro-with-dma_bit_mask28.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_28BIT_MASK macro with DMA_BIT_MASK(28)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_28BIT_MASK macro with DMA_BIT_MASK(28)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/wanxl.c      |    4 ++--
 sound/pci/als300.c           |    4 ++--
 sound/pci/emu10k1/emu10k1x.c |    4 ++--
 sound/pci/es1968.c           |    4 ++--
 sound/pci/ice1712/ice1712.c  |    4 ++--
 sound/pci/maestro3.c         |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/net/wan/wanxl.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28 drivers/net/wan/wanxl.c
--- a/drivers/net/wan/wanxl.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28
+++ a/drivers/net/wan/wanxl.c
@@ -586,8 +586,8 @@ static int __devinit wanxl_pci_init_one(
 	   We set both dma_mask and consistent_dma_mask to 28 bits
 	   and pray pci_alloc_consistent() will use this info. It should
 	   work on most platforms */
-	if (pci_set_consistent_dma_mask(pdev, DMA_28BIT_MASK) ||
-	    pci_set_dma_mask(pdev, DMA_28BIT_MASK)) {
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(28)) ||
+	    pci_set_dma_mask(pdev, DMA_BIT_MASK(28))) {
 		printk(KERN_ERR "wanXL: No usable DMA configuration\n");
 		return -EIO;
 	}
diff -puN sound/pci/als300.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28 sound/pci/als300.c
--- a/sound/pci/als300.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28
+++ a/sound/pci/als300.c
@@ -689,8 +689,8 @@ static int __devinit snd_als300_create(s
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
 
-	if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-		pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
 		printk(KERN_ERR "error setting 28bit DMA mask\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/emu10k1/emu10k1x.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28 sound/pci/emu10k1/emu10k1x.c
--- a/sound/pci/emu10k1/emu10k1x.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28
+++ a/sound/pci/emu10k1/emu10k1x.c
@@ -897,8 +897,8 @@ static int __devinit snd_emu10k1x_create
 
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
-	if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
 		snd_printk(KERN_ERR "error to set 28bit mask DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/es1968.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28 sound/pci/es1968.c
--- a/sound/pci/es1968.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28
+++ a/sound/pci/es1968.c
@@ -2539,8 +2539,8 @@ static int __devinit snd_es1968_create(s
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
 	/* check, if we can restrict PCI DMA transfers to 28 bits */
-	if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support 28bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/ice1712/ice1712.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28 sound/pci/ice1712/ice1712.c
--- a/sound/pci/ice1712/ice1712.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28
+++ a/sound/pci/ice1712/ice1712.c
@@ -2533,8 +2533,8 @@ static int __devinit snd_ice1712_create(
 	if (err < 0)
 		return err;
 	/* check, if we can restrict PCI DMA transfers to 28 bits */
-	if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support 28bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
diff -puN sound/pci/maestro3.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28 sound/pci/maestro3.c
--- a/sound/pci/maestro3.c~replace-all-dma_28bit_mask-macro-with-dma_bit_mask28
+++ a/sound/pci/maestro3.c
@@ -2530,8 +2530,8 @@ snd_m3_create(struct snd_card *card, str
 		return -EIO;
 
 	/* check, if we can restrict PCI DMA transfers to 28 bits */
-	if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support 28bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
 		return -ENXIO;
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

