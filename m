From: akpm@linux-foundation.org
Subject: - ath5k-fix-dma-operation.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:47 -0700
Message-ID: <200807301917.m6UJHlog011244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209AbYG3T0L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:26:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ath5k: fix dma operation
has been removed from the -mm tree.  Its filename was
     ath5k-fix-dma-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ath5k: fix dma operation
From: Jiri Slaby <jirislaby@gmail.com>

Don't sync
- coherent mapping (descriptors)
- before unmap, it's useless
- (wrongly anyway -- for_cpu) beacon skb, it's just mapped,
  so by the device yet

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-fix-dma-operation drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-fix-dma-operation
+++ a/drivers/net/wireless/ath5k/base.c
@@ -1704,10 +1704,6 @@ ath5k_tasklet_rx(unsigned long data)
 		skb = bf->skb;
 		ds = bf->desc;
 
-		/* TODO only one segment */
-		pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
-				sc->desc_len, PCI_DMA_FROMDEVICE);
-
 		/*
 		 * last buffer must not be freed to ensure proper hardware
 		 * function. When the hardware finishes also a packet next to
@@ -1771,8 +1767,6 @@ ath5k_tasklet_rx(unsigned long data)
 				goto next;
 		}
 accept:
-		pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr,
-				rs.rs_datalen, PCI_DMA_FROMDEVICE);
 		pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
 				PCI_DMA_FROMDEVICE);
 		bf->skb = NULL;
@@ -1860,9 +1854,6 @@ ath5k_tx_processq(struct ath5k_softc *sc
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
 		ds = bf->desc;
 
-		/* TODO only one segment */
-		pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
-				sc->desc_len, PCI_DMA_FROMDEVICE);
 		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
 		if (unlikely(ret == -EINPROGRESS))
 			break;
@@ -2035,8 +2026,6 @@ ath5k_beacon_send(struct ath5k_softc *sc
 		ATH5K_WARN(sc, "beacon queue %u didn't stop?\n", sc->bhalq);
 		/* NB: hw still stops DMA, so proceed */
 	}
-	pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
-			PCI_DMA_TODEVICE);
 
 	ath5k_hw_put_tx_buf(ah, sc->bhalq, bf->daddr);
 	ath5k_hw_tx_start(ah, sc->bhalq);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

