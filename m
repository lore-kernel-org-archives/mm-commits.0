From: akpm@linux-foundation.org
Subject: + ath5k-fix-dma-operation.patch added to -mm tree
Date: Wed, 16 Jul 2008 17:11:52 -0700
Message-ID: <200807170011.m6H0Bqed020943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbYGQAL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 20:11:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com


The patch titled
     ath5k: fix dma operation
has been added to the -mm tree.  Its filename is
     ath5k-fix-dma-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
char-isicom-enable-disable-pci-device.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

