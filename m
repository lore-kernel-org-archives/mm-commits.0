From: akpm@linux-foundation.org
Subject: + staging-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:25 -0700
Message-ID: <53ab2351.Xn4iXRWWeKFPCkvu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaFYTa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, charrer@alacritech.com, forest@alittletooquiet.net, gregkh@linuxfoundation.org, liodot@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     staging-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/staging-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/staging-use-pci_zalloc_consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: staging: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lior Dotan <liodot@gmail.com>
Cc: Christopher Harrer <charrer@alacritech.com>
Cc: Forest Bond <forest@alittletooquiet.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |   15 ++----
 drivers/staging/rtl8192ee/pci.c              |   37 +++++----------
 drivers/staging/rtl8821ae/pci.c              |   36 +++++----------
 drivers/staging/slicoss/slicoss.c            |    9 +--
 drivers/staging/vt6655/device_main.c         |   40 +++++------------
 5 files changed, 44 insertions(+), 93 deletions(-)

diff -puN drivers/staging/rtl8192e/rtl8192e/rtl_core.c~staging-use-pci_zalloc_consistent drivers/staging/rtl8192e/rtl8192e/rtl_core.c
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c~staging-use-pci_zalloc_consistent
+++ a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2065,20 +2065,16 @@ static short rtl8192_alloc_rx_desc_ring(
 	int i, rx_queue_idx;
 
 	for (rx_queue_idx = 0; rx_queue_idx < MAX_RX_QUEUE; rx_queue_idx++) {
-		priv->rx_ring[rx_queue_idx] = pci_alloc_consistent(priv->pdev,
-					sizeof(*priv->rx_ring[rx_queue_idx]) *
-					priv->rxringcount,
-					&priv->rx_ring_dma[rx_queue_idx]);
-
+		priv->rx_ring[rx_queue_idx] =
+			pci_zalloc_consistent(priv->pdev,
+					      sizeof(*priv->rx_ring[rx_queue_idx]) * priv->rxringcount,
+					      &priv->rx_ring_dma[rx_queue_idx]);
 		if (!priv->rx_ring[rx_queue_idx] ||
 		    (unsigned long)priv->rx_ring[rx_queue_idx] & 0xFF) {
 			RT_TRACE(COMP_ERR, "Cannot allocate RX ring\n");
 			return -ENOMEM;
 		}
 
-		memset(priv->rx_ring[rx_queue_idx], 0,
-		       sizeof(*priv->rx_ring[rx_queue_idx]) *
-		       priv->rxringcount);
 		priv->rx_idx[rx_queue_idx] = 0;
 
 		for (i = 0; i < priv->rxringcount; i++) {
@@ -2118,14 +2114,13 @@ static int rtl8192_alloc_tx_desc_ring(st
 	dma_addr_t dma;
 	int i;
 
-	ring = pci_alloc_consistent(priv->pdev, sizeof(*ring) * entries, &dma);
+	ring = pci_zalloc_consistent(priv->pdev, sizeof(*ring) * entries, &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		RT_TRACE(COMP_ERR, "Cannot allocate TX ring (prio = %d)\n",
 			 prio);
 		return -ENOMEM;
 	}
 
-	memset(ring, 0, sizeof(*ring)*entries);
 	priv->tx_ring[prio].desc = ring;
 	priv->tx_ring[prio].dma = dma;
 	priv->tx_ring[prio].idx = 0;
diff -puN drivers/staging/rtl8192ee/pci.c~staging-use-pci_zalloc_consistent drivers/staging/rtl8192ee/pci.c
--- a/drivers/staging/rtl8192ee/pci.c~staging-use-pci_zalloc_consistent
+++ a/drivers/staging/rtl8192ee/pci.c
@@ -1224,10 +1224,10 @@ static int _rtl_pci_init_tx_ring(struct
 
 	/* alloc tx buffer desc for new trx flow*/
 	if (rtlpriv->use_new_trx_flow) {
-		buffer_desc = pci_alloc_consistent(rtlpci->pdev,
-					sizeof(*buffer_desc) * entries,
-					&buffer_desc_dma);
-
+		buffer_desc =
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*buffer_desc) * entries,
+					      &buffer_desc_dma);
 		if (!buffer_desc || (unsigned long)buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
 				 ("Cannot allocate TX ring (prio = %d)\n",
@@ -1235,7 +1235,6 @@ static int _rtl_pci_init_tx_ring(struct
 			return -ENOMEM;
 		}
 
-		memset(buffer_desc, 0, sizeof(*buffer_desc) * entries);
 		rtlpci->tx_ring[prio].buffer_desc = buffer_desc;
 		rtlpci->tx_ring[prio].buffer_desc_dma = buffer_desc_dma;
 
@@ -1245,16 +1244,14 @@ static int _rtl_pci_init_tx_ring(struct
 	}
 
 	/* alloc dma for this ring */
-	desc = pci_alloc_consistent(rtlpci->pdev,
-				    sizeof(*desc) * entries, &desc_dma);
-
+	desc = pci_zalloc_consistent(rtlpci->pdev, sizeof(*desc) * entries,
+				     &desc_dma);
 	if (!desc || (unsigned long)desc & 0xFF) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
 			 ("Cannot allocate TX ring (prio = %d)\n", prio));
 		return -ENOMEM;
 	}
 
-	memset(desc, 0, sizeof(*desc) * entries);
 	rtlpci->tx_ring[prio].desc = desc;
 	rtlpci->tx_ring[prio].dma = desc_dma;
 
@@ -1290,11 +1287,9 @@ static int _rtl_pci_init_rx_ring(struct
 		struct rtl_rx_buffer_desc *entry = NULL;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].buffer_desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rxring_idx].
-						buffer_desc) *
-						rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rxring_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].buffer_desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
@@ -1302,10 +1297,6 @@ static int _rtl_pci_init_rx_ring(struct
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rxring_idx].buffer_desc, 0,
-		       sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) *
-		       rtlpci->rxringcount);
-
 		/* init every desc in this ring */
 		rtlpci->rx_ring[rxring_idx].idx = 0;
 
@@ -1320,19 +1311,15 @@ static int _rtl_pci_init_rx_ring(struct
 		u8 tmp_one = 1;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rxring_idx].
-					desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rxring_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rxring_idx].desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
 				 ("Cannot allocate RX ring\n"));
 			return -ENOMEM;
 		}
-		memset(rtlpci->rx_ring[rxring_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
-		       rtlpci->rxringcount);
 
 		/* init every desc in this ring */
 		rtlpci->rx_ring[rxring_idx].idx = 0;
diff -puN drivers/staging/rtl8821ae/pci.c~staging-use-pci_zalloc_consistent drivers/staging/rtl8821ae/pci.c
--- a/drivers/staging/rtl8821ae/pci.c~staging-use-pci_zalloc_consistent
+++ a/drivers/staging/rtl8821ae/pci.c
@@ -1248,9 +1248,10 @@ static int _rtl_pci_init_tx_ring(struct
 
 	/* alloc tx buffer desc for new trx flow*/
 	if (rtlpriv->use_new_trx_flow) {
-		buffer_desc = pci_alloc_consistent(rtlpci->pdev,
-					    sizeof(*buffer_desc) * entries,
-					    &buffer_desc_dma);
+		buffer_desc =
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*buffer_desc) * entries,
+					      &buffer_desc_dma);
 
 		if (!buffer_desc || (unsigned long)buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
@@ -1259,7 +1260,6 @@ static int _rtl_pci_init_tx_ring(struct
 			return -ENOMEM;
 		}
 
-		memset(buffer_desc, 0, sizeof(*buffer_desc) * entries);
 		rtlpci->tx_ring[prio].buffer_desc = buffer_desc;
 		rtlpci->tx_ring[prio].buffer_desc_dma = buffer_desc_dma;
 
@@ -1270,8 +1270,8 @@ static int _rtl_pci_init_tx_ring(struct
 	}
 
 	/* alloc dma for this ring */
-	desc = pci_alloc_consistent(rtlpci->pdev,
-				    sizeof(*desc) * entries, &desc_dma);
+	desc = pci_zalloc_consistent(rtlpci->pdev, sizeof(*desc) * entries,
+				     &desc_dma);
 
 	if (!desc || (unsigned long)desc & 0xFF) {
 		RT_TRACE(COMP_ERR, DBG_EMERG,
@@ -1279,7 +1279,6 @@ static int _rtl_pci_init_tx_ring(struct
 		return -ENOMEM;
 	}
 
-	memset(desc, 0, sizeof(*desc) * entries);
 	rtlpci->tx_ring[prio].desc = desc;
 	rtlpci->tx_ring[prio].dma = desc_dma;
 
@@ -1316,21 +1315,15 @@ static int _rtl_pci_init_rx_ring(struct
 		struct rtl_rx_buffer_desc *entry = NULL;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].buffer_desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rxring_idx].
-					        buffer_desc) *
-					        rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rxring_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].buffer_desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].buffer_desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG, ("Cannot allocate RX ring\n"));
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rxring_idx].buffer_desc, 0,
-		       sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) *
-		       rtlpci->rxringcount);
-
 		/* init every desc in this ring */
 		rtlpci->rx_ring[rxring_idx].idx = 0;
 		for (i = 0; i < rtlpci->rxringcount; i++) {
@@ -1344,10 +1337,9 @@ static int _rtl_pci_init_rx_ring(struct
 		u8 tmp_one = 1;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rxring_idx].
-					        desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rxring_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rxring_idx].desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rxring_idx].dma);
 		if (!rtlpci->rx_ring[rxring_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].desc & 0xFF) {
 			RT_TRACE(COMP_ERR, DBG_EMERG,
@@ -1355,10 +1347,6 @@ static int _rtl_pci_init_rx_ring(struct
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rxring_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
-		       rtlpci->rxringcount);
-
 		/* init every desc in this ring */
 		rtlpci->rx_ring[rxring_idx].idx = 0;
 		for (i = 0; i < rtlpci->rxringcount; i++) {
diff -puN drivers/staging/slicoss/slicoss.c~staging-use-pci_zalloc_consistent drivers/staging/slicoss/slicoss.c
--- a/drivers/staging/slicoss/slicoss.c~staging-use-pci_zalloc_consistent
+++ a/drivers/staging/slicoss/slicoss.c
@@ -1190,18 +1190,15 @@ static int slic_rspqueue_init(struct ada
 	rspq->num_pages = SLIC_RSPQ_PAGES_GB;
 
 	for (i = 0; i < rspq->num_pages; i++) {
-		rspq->vaddr[i] = pci_alloc_consistent(adapter->pcidev,
-						      PAGE_SIZE,
-						      &rspq->paddr[i]);
+		rspq->vaddr[i] = pci_zalloc_consistent(adapter->pcidev,
+						       PAGE_SIZE,
+						       &rspq->paddr[i]);
 		if (!rspq->vaddr[i]) {
 			dev_err(&adapter->pcidev->dev,
 				"pci_alloc_consistent failed\n");
 			slic_rspqueue_free(adapter);
 			return -ENOMEM;
 		}
-		/* FIXME:
-		 * do we really need this assertions (4K PAGE_SIZE aligned addr)? */
-		memset(rspq->vaddr[i], 0, PAGE_SIZE);
 
 		if (paddrh == 0) {
 			slic_reg32_write(&slic_regs->slic_rbar,
diff -puN drivers/staging/vt6655/device_main.c~staging-use-pci_zalloc_consistent drivers/staging/vt6655/device_main.c
--- a/drivers/staging/vt6655/device_main.c~staging-use-pci_zalloc_consistent
+++ a/drivers/staging/vt6655/device_main.c
@@ -1091,25 +1091,17 @@ static bool device_init_rings(PSDevice p
 	void *vir_pool;
 
 	/*allocate all RD/TD rings a single pool*/
-	vir_pool = pci_alloc_consistent(pDevice->pcid,
-					pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
-					pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
-					pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
-					pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc),
-					&pDevice->pool_dma);
-
+	vir_pool = pci_zalloc_consistent(pDevice->pcid,
+					 pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
+					 pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
+					 pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
+					 pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc),
+					 &pDevice->pool_dma);
 	if (vir_pool == NULL) {
 		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s : allocate desc dma memory failed\n", pDevice->dev->name);
 		return false;
 	}
 
-	memset(vir_pool, 0,
-	       pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
-	       pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
-	       pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
-	       pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc)
-		);
-
 	pDevice->aRD0Ring = vir_pool;
 	pDevice->aRD1Ring = vir_pool +
 		pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc);
@@ -1118,13 +1110,12 @@ static bool device_init_rings(PSDevice p
 	pDevice->rd1_pool_dma = pDevice->rd0_pool_dma +
 		pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc);
 
-	pDevice->tx0_bufs = pci_alloc_consistent(pDevice->pcid,
-						 pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
-						 pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ +
-						 CB_BEACON_BUF_SIZE +
-						 CB_MAX_BUF_SIZE,
-						 &pDevice->tx_bufs_dma0);
-
+	pDevice->tx0_bufs = pci_zalloc_consistent(pDevice->pcid,
+						  pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
+						  pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ +
+						  CB_BEACON_BUF_SIZE +
+						  CB_MAX_BUF_SIZE,
+						  &pDevice->tx_bufs_dma0);
 	if (pDevice->tx0_bufs == NULL) {
 		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR "%s: allocate buf dma memory failed\n", pDevice->dev->name);
 		pci_free_consistent(pDevice->pcid,
@@ -1137,13 +1128,6 @@ static bool device_init_rings(PSDevice p
 		return false;
 	}
 
-	memset(pDevice->tx0_bufs, 0,
-	       pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
-	       pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ +
-	       CB_BEACON_BUF_SIZE +
-	       CB_MAX_BUF_SIZE
-		);
-
 	pDevice->td0_pool_dma = pDevice->rd1_pool_dma +
 		pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc);
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

