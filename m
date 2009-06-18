From: akpm@linux-foundation.org
Subject: + convert-some-dma_nnbit_mask-callers.patch added to -mm tree
Date: Thu, 18 Jun 2009 16:21:50 -0700
Message-ID: <200906182341.n5INfxjW024983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbZFRXmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 19:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Eric.Moore@lsil.com, James.Bottomley@HansenPartnership.com, alexander.h.duyck@intel.com, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, tiwai@suse.de, yi.zou@intel.com


The patch titled
     convert some DMA_nnBIT_MASK() callers
has been added to the -mm tree.  Its filename is
     convert-some-dma_nnbit_mask-callers.patch

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
Subject: convert some DMA_nnBIT_MASK() callers
From: Andrew Morton <akpm@linux-foundation.org>

We're about to make DMA_nnBIT_MASK() emit `deprecated' warnings.  Convert the
remaining stragglers which are visible to the x86_64 build.

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric Moore <Eric.Moore@lsil.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Yi Zou <yi.zou@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    8 ++++----
 drivers/net/igbvf/netdev.c       |   13 +++++++------
 drivers/net/ixgbe/ixgbe_fcoe.c   |    2 +-
 sound/pci/lx6464es/lx6464es.c    |    2 +-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~convert-some-dma_nnbit_mask-callers drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~convert-some-dma_nnbit_mask-callers
+++ a/drivers/message/fusion/mptbase.c
@@ -4414,11 +4414,11 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		 * 1078 errata workaround for the 36GB limitation
 		 */
 		if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078 &&
-		    ioc->dma_mask > DMA_35BIT_MASK) {
+		    ioc->dma_mask > DMA_BIT_MASK(35)) {
 			if (!pci_set_dma_mask(ioc->pcidev, DMA_BIT_MASK(32))
 			    && !pci_set_consistent_dma_mask(ioc->pcidev,
 			    DMA_BIT_MASK(32))) {
-				dma_mask = DMA_35BIT_MASK;
+				dma_mask = DMA_BIT_MASK(35);
 				d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "setting 35 bit addressing for "
 				    "Request/Reply/Chain and Sense Buffers\n",
@@ -4575,7 +4575,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		alloc_dma += ioc->reply_sz;
 	}
 
-	if (dma_mask == DMA_35BIT_MASK && !pci_set_dma_mask(ioc->pcidev,
+	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
 	    ioc->dma_mask) && !pci_set_consistent_dma_mask(ioc->pcidev,
 	    ioc->dma_mask))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
@@ -4602,7 +4602,7 @@ out_fail:
 		ioc->sense_buf_pool = NULL;
 	}
 
-	if (dma_mask == DMA_35BIT_MASK && !pci_set_dma_mask(ioc->pcidev,
+	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
 	    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(ioc->pcidev,
 	    DMA_BIT_MASK(64)))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
diff -puN sound/pci/lx6464es/lx6464es.c~convert-some-dma_nnbit_mask-callers sound/pci/lx6464es/lx6464es.c
--- a/sound/pci/lx6464es/lx6464es.c~convert-some-dma_nnbit_mask-callers
+++ a/sound/pci/lx6464es/lx6464es.c
@@ -988,7 +988,7 @@ static int __devinit snd_lx6464es_create
 	pci_set_master(pci);
 
 	/* check if we can restrict PCI DMA transfers to 32 bits */
-	err = pci_set_dma_mask(pci, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pci, DMA_BIT_MASK(32));
 	if (err < 0) {
 		snd_printk(KERN_ERR "architecture does not support "
 			   "32bit PCI busmaster DMA\n");
diff -puN drivers/net/igbvf/netdev.c~convert-some-dma_nnbit_mask-callers drivers/net/igbvf/netdev.c
--- a/drivers/net/igbvf/netdev.c~convert-some-dma_nnbit_mask-callers
+++ a/drivers/net/igbvf/netdev.c
@@ -1281,7 +1281,7 @@ static void igbvf_configure_tx(struct ig
 	/* Setup the HW Tx Head and Tail descriptor pointers */
 	ew32(TDLEN(0), tx_ring->count * sizeof(union e1000_adv_tx_desc));
 	tdba = tx_ring->dma;
-	ew32(TDBAL(0), (tdba & DMA_32BIT_MASK));
+	ew32(TDBAL(0), (tdba & DMA_BIT_MASK(32)));
 	ew32(TDBAH(0), (tdba >> 32));
 	ew32(TDH(0), 0);
 	ew32(TDT(0), 0);
@@ -1367,7 +1367,7 @@ static void igbvf_configure_rx(struct ig
 	 * the Base and Length of the Rx Descriptor Ring
 	 */
 	rdba = rx_ring->dma;
-	ew32(RDBAL(0), (rdba & DMA_32BIT_MASK));
+	ew32(RDBAL(0), (rdba & DMA_BIT_MASK(32)));
 	ew32(RDBAH(0), (rdba >> 32));
 	ew32(RDLEN(0), rx_ring->count * sizeof(union e1000_adv_rx_desc));
 	rx_ring->head = E1000_RDH(0);
@@ -2628,15 +2628,16 @@ static int __devinit igbvf_probe(struct 
 		return err;
 
 	pci_using_dac = 0;
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (!err) {
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (!err)
 			pci_using_dac = 1;
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
-			err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			err = pci_set_consistent_dma_mask(pdev,
+							  DMA_BIT_MASK(32));
 			if (err) {
 				dev_err(&pdev->dev, "No usable DMA "
 				        "configuration, aborting\n");
diff -puN drivers/net/ixgbe/ixgbe_fcoe.c~convert-some-dma_nnbit_mask-callers drivers/net/ixgbe/ixgbe_fcoe.c
--- a/drivers/net/ixgbe/ixgbe_fcoe.c~convert-some-dma_nnbit_mask-callers
+++ a/drivers/net/ixgbe/ixgbe_fcoe.c
@@ -251,7 +251,7 @@ int ixgbe_fcoe_ddp_get(struct net_device
 	/* program DMA context */
 	hw = &adapter->hw;
 	spin_lock_bh(&fcoe->lock);
-	IXGBE_WRITE_REG(hw, IXGBE_FCPTRL, ddp->udp & DMA_32BIT_MASK);
+	IXGBE_WRITE_REG(hw, IXGBE_FCPTRL, ddp->udp & DMA_BIT_MASK(32));
 	IXGBE_WRITE_REG(hw, IXGBE_FCPTRH, (u64)ddp->udp >> 32);
 	IXGBE_WRITE_REG(hw, IXGBE_FCBUFF, fcbuff);
 	IXGBE_WRITE_REG(hw, IXGBE_FCDMARW, fcdmarw);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bootmemc-avoid-c90-declaration-warning-cleanup.patch
char-moxa-prevent-opening-unavailable-ports.patch
convert-some-dma_nnbit_mask-callers.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

