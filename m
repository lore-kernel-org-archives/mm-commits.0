From: akpm@linux-foundation.org
Subject: + sgiseeq-replace-use-of-dma_cache_wback_inv.patch added to -mm tree
Date: Thu, 13 Sep 2007 15:03:16 -0700
Message-ID: <200709132203.l8DM3GDu008144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038AbXIMWDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 18:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, jeff@garzik.org


The patch titled
     sgiseeq: replace use of dma_cache_wback_inv
has been added to the -mm tree.  Its filename is
     sgiseeq-replace-use-of-dma_cache_wback_inv.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sgiseeq: replace use of dma_cache_wback_inv
From: Ralf Baechle <ralf@linux-mips.org>

The sgiseeq driver is one of the few remaining users of the ancient cache
banging DMA API.  Replaced with the modern days DMA API.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sgiseeq.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff -puN drivers/net/sgiseeq.c~sgiseeq-replace-use-of-dma_cache_wback_inv drivers/net/sgiseeq.c
--- a/drivers/net/sgiseeq.c~sgiseeq-replace-use-of-dma_cache_wback_inv
+++ a/drivers/net/sgiseeq.c
@@ -75,6 +75,7 @@ struct sgiseeq_init_block { /* Note the 
 
 struct sgiseeq_private {
 	struct sgiseeq_init_block *srings;
+	dma_addr_t srings_dma;
 
 	/* Ptrs to the descriptors in uncached space. */
 	struct sgiseeq_rx_desc *rx_desc;
@@ -634,13 +635,20 @@ static int __init sgiseeq_probe(struct p
 	sp = netdev_priv(dev);
 
 	/* Make private data page aligned */
-	sr = (struct sgiseeq_init_block *) get_zeroed_page(GFP_KERNEL);
+	sr = dma_alloc_coherent(&pdev->dev, sizeof(*sp->srings),
+				&sp->srings_dma, GFP_KERNEL);
 	if (!sr) {
 		printk(KERN_ERR "Sgiseeq: Page alloc failed, aborting.\n");
 		err = -ENOMEM;
 		goto err_out_free_dev;
 	}
 	sp->srings = sr;
+	sp->rx_desc = sp->srings->rxvector;
+	sp->tx_desc = sp->srings->txvector;
+
+	/* A couple calculations now, saves many cycles later. */
+	setup_rx_ring(sp->rx_desc, SEEQ_RX_BUFFERS);
+	setup_tx_ring(sp->tx_desc, SEEQ_TX_BUFFERS);
 
 	memcpy(dev->dev_addr, pd->mac, ETH_ALEN);
 
@@ -653,19 +661,6 @@ static int __init sgiseeq_probe(struct p
 	sp->name = sgiseeqstr;
 	sp->mode = SEEQ_RCMD_RBCAST;
 
-	sp->rx_desc = (struct sgiseeq_rx_desc *)
-	              CKSEG1ADDR(ALIGNED(&sp->srings->rxvector[0]));
-	dma_cache_wback_inv((unsigned long)&sp->srings->rxvector,
-	                    sizeof(sp->srings->rxvector));
-	sp->tx_desc = (struct sgiseeq_tx_desc *)
-	              CKSEG1ADDR(ALIGNED(&sp->srings->txvector[0]));
-	dma_cache_wback_inv((unsigned long)&sp->srings->txvector,
-	                    sizeof(sp->srings->txvector));
-
-	/* A couple calculations now, saves many cycles later. */
-	setup_rx_ring(sp->rx_desc, SEEQ_RX_BUFFERS);
-	setup_tx_ring(sp->tx_desc, SEEQ_TX_BUFFERS);
-
 	/* Setup PIO and DMA transfer timing */
 	sp->hregs->pconfig = 0x161;
 	sp->hregs->dconfig = HPC3_EDCFG_FIRQ | HPC3_EDCFG_FEOP |
@@ -722,7 +717,8 @@ static int __exit sgiseeq_remove(struct 
 	struct sgiseeq_private *sp = netdev_priv(dev);
 
 	unregister_netdev(dev);
-	free_page((unsigned long) sp->srings);
+	dma_free_coherent(&pdev->dev, sizeof(*sp->srings), sp->srings,
+	                  sp->srings_dma);
 	free_netdev(dev);
 	platform_set_drvdata(pdev, NULL);
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

bcm1480-serial-build-fix.patch
git-input.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-netdev-all.patch
remove-setup-of-platform-device-from-jazzsonicc.patch
sgiseeq-replace-use-of-dma_cache_wback_inv.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
