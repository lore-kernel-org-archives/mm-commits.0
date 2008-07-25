From: akpm@linux-foundation.org
Subject: - dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:39:36 -0700
Message-ID: <200807252339.m6PNda0P005464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754126AbYGYXjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Sivakumar.Subramani@neterion.com, Sreenivasa.Honnur@neterion.com, fujita.tomonori@lab.ntt.co.jp, jgarzik@pobox.com, ravinandan.arakali@neterion.com, sivakum


The patch titled
     dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io
has been removed from the -mm tree.  Its filename was
     dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch

This patch was dropped because it was folded into dma-mapping-add-the-device-argument-to-dma_mapping_error.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io
From: Andrew Morton <akpm@linux-foundation.org>

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Sivakumar Subramani <sivakumar.subramani@neterion.com>
Cc: Sreenivasa Honnur <Sreenivasa.Honnur@neterion.com>
Cc: Sreenivasa Honnur <sreenivasa.honnur@neterion.com>
Cc: Ravinandan Arakali <ravinandan.arakali@neterion.com>
Cc: Surjit Reang <surjit.reang@neterion.com>
Cc: Sivakumar Subramani <Sivakumar.Subramani@neterion.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/s2io.c |   48 ++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff -puN drivers/net/s2io.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io drivers/net/s2io.c
--- a/drivers/net/s2io.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io
+++ a/drivers/net/s2io.c
@@ -2512,8 +2512,8 @@ static void stop_nic(struct s2io_nic *ni
  *   Return Value:
  *  SUCCESS on success or an appropriate -ve value on failure.
  */
-
-static int fill_rx_buffers(struct ring_info *ring, int from_card_up)
+static int fill_rx_buffers(struct s2io_nic *nic, struct ring_info *ring,
+				int from_card_up)
 {
 	struct sk_buff *skb;
 	struct RxD_t *rxdp;
@@ -2602,7 +2602,8 @@ static int fill_rx_buffers(struct ring_i
 			rxdp1->Buffer0_ptr = pci_map_single
 			    (ring->pdev, skb->data, size - NET_IP_ALIGN,
 				PCI_DMA_FROMDEVICE);
-			if(pci_dma_mapping_error(rxdp1->Buffer0_ptr))
+			if (pci_dma_mapping_error(nic->pdev,
+						rxdp1->Buffer0_ptr))
 				goto pci_map_failed;
 
 			rxdp->Control_2 =
@@ -2636,7 +2637,8 @@ static int fill_rx_buffers(struct ring_i
 				rxdp3->Buffer0_ptr =
 				   pci_map_single(ring->pdev, ba->ba_0,
 					BUF0_LEN, PCI_DMA_FROMDEVICE);
-				if (pci_dma_mapping_error(rxdp3->Buffer0_ptr))
+			if (pci_dma_mapping_error(nic->pdev,
+						rxdp3->Buffer0_ptr))
 					goto pci_map_failed;
 			} else
 				pci_dma_sync_single_for_device(ring->pdev,
@@ -2655,7 +2657,8 @@ static int fill_rx_buffers(struct ring_i
 				(ring->pdev, skb->data, ring->mtu + 4,
 						PCI_DMA_FROMDEVICE);
 
-				if (pci_dma_mapping_error(rxdp3->Buffer2_ptr))
+				if (pci_dma_mapping_error(nic->pdev,
+							rxdp3->Buffer2_ptr))
 					goto pci_map_failed;
 
 				if (from_card_up) {
@@ -2664,8 +2667,8 @@ static int fill_rx_buffers(struct ring_i
 						ba->ba_1, BUF1_LEN,
 						PCI_DMA_FROMDEVICE);
 
-					if (pci_dma_mapping_error
-						(rxdp3->Buffer1_ptr)) {
+					if (pci_dma_mapping_error(nic->pdev,
+						rxdp3->Buffer1_ptr)) {
 						pci_unmap_single
 							(ring->pdev,
 						    (dma_addr_t)(unsigned long)
@@ -2806,9 +2809,9 @@ static void free_rx_buffers(struct s2io_
 	}
 }
 
-static int s2io_chk_rx_buffers(struct ring_info *ring)
+static int s2io_chk_rx_buffers(struct s2io_nic *nic, struct ring_info *ring)
 {
-	if (fill_rx_buffers(ring, 0) == -ENOMEM) {
+	if (fill_rx_buffers(nic, ring, 0) == -ENOMEM) {
 		DBG_PRINT(INFO_DBG, "%s:Out of memory", ring->dev->name);
 		DBG_PRINT(INFO_DBG, " in Rx Intr!!\n");
 	}
@@ -2848,7 +2851,7 @@ static int s2io_poll_msix(struct napi_st
 		return 0;
 
 	pkts_processed = rx_intr_handler(ring, budget);
-	s2io_chk_rx_buffers(ring);
+	s2io_chk_rx_buffers(nic, ring);
 
 	if (pkts_processed < budget_org) {
 		netif_rx_complete(dev, napi);
@@ -2882,7 +2885,7 @@ static int s2io_poll_inta(struct napi_st
 	for (i = 0; i < config->rx_ring_num; i++) {
 		ring = &mac_control->rings[i];
 		ring_pkts_processed = rx_intr_handler(ring, budget);
-		s2io_chk_rx_buffers(ring);
+		s2io_chk_rx_buffers(nic, ring);
 		pkts_processed += ring_pkts_processed;
 		budget -= ring_pkts_processed;
 		if (budget <= 0)
@@ -2939,7 +2942,8 @@ static void s2io_netpoll(struct net_devi
 		rx_intr_handler(&mac_control->rings[i], 0);
 
 	for (i = 0; i < config->rx_ring_num; i++) {
-		if (fill_rx_buffers(&mac_control->rings[i], 0) == -ENOMEM) {
+		if (fill_rx_buffers(nic, &mac_control->rings[i], 0) ==
+				-ENOMEM) {
 			DBG_PRINT(INFO_DBG, "%s:Out of memory", dev->name);
 			DBG_PRINT(INFO_DBG, " in Rx Netpoll!!\n");
 			break;
@@ -4235,14 +4239,14 @@ static int s2io_xmit(struct sk_buff *skb
 		txdp->Buffer_Pointer = pci_map_single(sp->pdev,
 					fifo->ufo_in_band_v,
 					sizeof(u64), PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(txdp->Buffer_Pointer))
+		if (pci_dma_mapping_error(sp->pdev, txdp->Buffer_Pointer))
 			goto pci_map_failed;
 		txdp++;
 	}
 
 	txdp->Buffer_Pointer = pci_map_single
 	    (sp->pdev, skb->data, frg_len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(txdp->Buffer_Pointer))
+	if (pci_dma_mapping_error(sp->pdev, txdp->Buffer_Pointer))
 		goto pci_map_failed;
 
 	txdp->Host_Control = (unsigned long) skb;
@@ -4345,7 +4349,7 @@ static irqreturn_t s2io_msix_ring_handle
 		netif_rx_schedule(dev, &ring->napi);
 	} else {
 		rx_intr_handler(ring, 0);
-		s2io_chk_rx_buffers(ring);
+		s2io_chk_rx_buffers(sp, ring);
 	}
 
 	return IRQ_HANDLED;
@@ -4826,7 +4830,7 @@ static irqreturn_t s2io_isr(int irq, voi
 		 */
 		if (!config->napi) {
 			for (i = 0; i < config->rx_ring_num; i++)
-				s2io_chk_rx_buffers(&mac_control->rings[i]);
+				s2io_chk_rx_buffers(sp, &mac_control->rings[i]);
 		}
 		writeq(sp->general_int_mask, &bar0->general_int_mask);
 		readl(&bar0->general_int_status);
@@ -6859,7 +6863,7 @@ static int set_rxd_buffer_pointer(struct
 				pci_map_single( sp->pdev, (*skb)->data,
 					size - NET_IP_ALIGN,
 					PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp1->Buffer0_ptr))
+			if (pci_dma_mapping_error(sp->pdev, rxdp1->Buffer0_ptr))
 				goto memalloc_failed;
 			rxdp->Host_Control = (unsigned long) (*skb);
 		}
@@ -6886,12 +6890,13 @@ static int set_rxd_buffer_pointer(struct
 				pci_map_single(sp->pdev, (*skb)->data,
 					       dev->mtu + 4,
 					       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer2_ptr))
+			if (pci_dma_mapping_error(sp->pdev, rxdp3->Buffer2_ptr))
 				goto memalloc_failed;
 			rxdp3->Buffer0_ptr = *temp0 =
 				pci_map_single( sp->pdev, ba->ba_0, BUF0_LEN,
 						PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer0_ptr)) {
+			if (pci_dma_mapping_error(sp->pdev,
+						rxdp3->Buffer0_ptr)) {
 				pci_unmap_single (sp->pdev,
 					(dma_addr_t)rxdp3->Buffer2_ptr,
 					dev->mtu + 4, PCI_DMA_FROMDEVICE);
@@ -6903,7 +6908,8 @@ static int set_rxd_buffer_pointer(struct
 			rxdp3->Buffer1_ptr = *temp1 =
 				pci_map_single(sp->pdev, ba->ba_1, BUF1_LEN,
 						PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer1_ptr)) {
+			if (pci_dma_mapping_error(sp->pdev,
+						rxdp3->Buffer1_ptr)) {
 				pci_unmap_single (sp->pdev,
 					(dma_addr_t)rxdp3->Buffer0_ptr,
 					BUF0_LEN, PCI_DMA_FROMDEVICE);
@@ -7187,7 +7193,7 @@ static int s2io_card_up(struct s2io_nic 
 
 	for (i = 0; i < config->rx_ring_num; i++) {
 		mac_control->rings[i].mtu = dev->mtu;
-		ret = fill_rx_buffers(&mac_control->rings[i], 1);
+		ret = fill_rx_buffers(sp, &mac_control->rings[i], 1);
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
 				  dev->name);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sdhci-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

