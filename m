From: akpm@osdl.org
Subject: + ucc-ether-driver-kmalloc-casting-cleanups.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:29:22 -0800
Message-ID: <200701082229.l08MTMYl020836@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964956AbXAHW33 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, jeff@garzik.org


The patch titled
     UCC Ether driver: kmalloc casting cleanups
has been added to the -mm tree.  Its filename is
     ucc-ether-driver-kmalloc-casting-cleanups.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UCC Ether driver: kmalloc casting cleanups
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A kmalloc casting cleanup patch.

Signed-off-by: Ahmed Darwish <darwish.07@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/ucc_geth.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff -puN drivers/net/ucc_geth.c~ucc-ether-driver-kmalloc-casting-cleanups drivers/net/ucc_geth.c
--- a/drivers/net/ucc_geth.c~ucc-ether-driver-kmalloc-casting-cleanups
+++ a/drivers/net/ucc_geth.c
@@ -2864,8 +2864,8 @@ static int ucc_geth_startup(struct ucc_g
 			if (UCC_GETH_TX_BD_RING_ALIGNMENT > 4)
 				align = UCC_GETH_TX_BD_RING_ALIGNMENT;
 			ugeth->tx_bd_ring_offset[j] =
-				(u32) (kmalloc((u32) (length + align),
-				GFP_KERNEL));
+				kmalloc((u32) (length + align), GFP_KERNEL);
+
 			if (ugeth->tx_bd_ring_offset[j] != 0)
 				ugeth->p_tx_bd_ring[j] =
 					(void*)((ugeth->tx_bd_ring_offset[j] +
@@ -2900,7 +2900,7 @@ static int ucc_geth_startup(struct ucc_g
 			if (UCC_GETH_RX_BD_RING_ALIGNMENT > 4)
 				align = UCC_GETH_RX_BD_RING_ALIGNMENT;
 			ugeth->rx_bd_ring_offset[j] =
-			    (u32) (kmalloc((u32) (length + align), GFP_KERNEL));
+				kmalloc((u32) (length + align), GFP_KERNEL);
 			if (ugeth->rx_bd_ring_offset[j] != 0)
 				ugeth->p_rx_bd_ring[j] =
 					(void*)((ugeth->rx_bd_ring_offset[j] +
@@ -2926,10 +2926,9 @@ static int ucc_geth_startup(struct ucc_g
 	/* Init Tx bds */
 	for (j = 0; j < ug_info->numQueuesTx; j++) {
 		/* Setup the skbuff rings */
-		ugeth->tx_skbuff[j] =
-		    (struct sk_buff **)kmalloc(sizeof(struct sk_buff *) *
-					       ugeth->ug_info->bdRingLenTx[j],
-					       GFP_KERNEL);
+		ugeth->tx_skbuff[j] = kmalloc(sizeof(struct sk_buff *) *
+					      ugeth->ug_info->bdRingLenTx[j],
+					      GFP_KERNEL);
 
 		if (ugeth->tx_skbuff[j] == NULL) {
 			ugeth_err("%s: Could not allocate tx_skbuff",
@@ -2958,10 +2957,9 @@ static int ucc_geth_startup(struct ucc_g
 	/* Init Rx bds */
 	for (j = 0; j < ug_info->numQueuesRx; j++) {
 		/* Setup the skbuff rings */
-		ugeth->rx_skbuff[j] =
-		    (struct sk_buff **)kmalloc(sizeof(struct sk_buff *) *
-					       ugeth->ug_info->bdRingLenRx[j],
-					       GFP_KERNEL);
+		ugeth->rx_skbuff[j] = kmalloc(sizeof(struct sk_buff *) *
+					      ugeth->ug_info->bdRingLenRx[j],
+					      GFP_KERNEL);
 
 		if (ugeth->rx_skbuff[j] == NULL) {
 			ugeth_err("%s: Could not allocate rx_skbuff",
@@ -3452,8 +3450,7 @@ static int ucc_geth_startup(struct ucc_g
 	 * allocated resources can be released when the channel is freed.
 	 */
 	if (!(ugeth->p_init_enet_param_shadow =
-	     (struct ucc_geth_init_pram *) kmalloc(sizeof(struct ucc_geth_init_pram),
-					      GFP_KERNEL))) {
+	      kmalloc(sizeof(struct ucc_geth_init_pram), GFP_KERNEL))) {
 		ugeth_err
 		    ("%s: Can not allocate memory for"
 			" p_UccInitEnetParamShadows.", __FUNCTION__);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-cpufreq.patch
jsm_tty-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
cifs-remove-2-unneeded-kzalloc-casts.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
ucc-ether-driver-kmalloc-casting-cleanups.patch
