From: akpm@linux-foundation.org
Subject: + via-velocity-move-residual-free-rx-descriptors-count-register-update.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:38:04 -0700
Message-ID: <200807111843.m6BIhj1v030813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721AbYGKSnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com


The patch titled
     via-velocity: move residual free rx descriptors count register update
has been added to the -mm tree.  Its filename is
     via-velocity-move-residual-free-rx-descriptors-count-register-update.patch

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
Subject: via-velocity: move residual free rx descriptors count register update
From: Francois Romieu <romieu@fr.zoreil.com>

Updates of the RBRDU have two different meanings depending on their
context:
1. the receiving process has not started - the value which is written
   into the RBRDU register is supposed to be the free rx descriptors
   count (rounded to a multiple of 4)
2. the receiving process is running - the value increments the count
   above (sic)

The update is currently issued deep inside the rx replenish chain (see
velocity_give_many_rx_descs).

Let's propagate enough information to the caller so that the rx
replenish functions do not depend on hardware any more.

It is needed to perform the Rx/Tx buffers housekeeping when MTU changes.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/via-velocity.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/net/via-velocity.c~via-velocity-move-residual-free-rx-descriptors-count-register-update drivers/net/via-velocity.c
--- a/drivers/net/via-velocity.c~via-velocity-move-residual-free-rx-descriptors-count-register-update
+++ a/drivers/net/via-velocity.c
@@ -1155,7 +1155,7 @@ static void velocity_free_rings(struct v
 	pci_free_consistent(vptr->pdev, size, vptr->rd_ring, vptr->rd_pool_dma);
 }
 
-static inline void velocity_give_many_rx_descs(struct velocity_info *vptr)
+static void velocity_give_many_rx_descs(struct velocity_info *vptr)
 {
 	struct mac_regs __iomem *regs = vptr->mac_regs;
 	int avail, dirty, unusable;
@@ -1182,7 +1182,7 @@ static inline void velocity_give_many_rx
 
 static int velocity_rx_refill(struct velocity_info *vptr)
 {
-	int dirty = vptr->rd_dirty, done = 0, ret = 0;
+	int dirty = vptr->rd_dirty, done = 0;
 
 	do {
 		struct rx_desc *rd = vptr->rd_ring + dirty;
@@ -1192,8 +1192,7 @@ static int velocity_rx_refill(struct vel
 			break;
 
 		if (!vptr->rd_info[dirty].skb) {
-			ret = velocity_alloc_rx_buf(vptr, dirty);
-			if (ret < 0)
+			if (velocity_alloc_rx_buf(vptr, dirty) < 0)
 				break;
 		}
 		done++;
@@ -1203,10 +1202,9 @@ static int velocity_rx_refill(struct vel
 	if (done) {
 		vptr->rd_dirty = dirty;
 		vptr->rd_filled += done;
-		velocity_give_many_rx_descs(vptr);
 	}
 
-	return ret;
+	return done;
 }
 
 /**
@@ -1219,25 +1217,27 @@ static int velocity_rx_refill(struct vel
 
 static int velocity_init_rd_ring(struct velocity_info *vptr)
 {
-	int ret;
 	int mtu = vptr->dev->mtu;
+	int ret = -ENOMEM;
 
 	vptr->rx_buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;
 
 	vptr->rd_info = kcalloc(vptr->options.numrx,
 				sizeof(struct velocity_rd_info), GFP_KERNEL);
 	if (!vptr->rd_info)
-		return -ENOMEM;
+		goto out;
 
 	vptr->rd_filled = vptr->rd_dirty = vptr->rd_curr = 0;
 
-	ret = velocity_rx_refill(vptr);
-	if (ret < 0) {
+	if (velocity_rx_refill(vptr) != vptr->options.numrx) {
 		VELOCITY_PRT(MSG_LEVEL_ERR, KERN_ERR
 			"%s: failed to allocate RX buffer.\n", vptr->dev->name);
 		velocity_free_rd_ring(vptr);
+		goto out;
 	}
 
+	ret = 0;
+out:
 	return ret;
 }
 
@@ -1412,10 +1412,8 @@ static int velocity_rx_srv(struct veloci
 
 	vptr->rd_curr = rd_curr;
 
-	if (works > 0 && velocity_rx_refill(vptr) < 0) {
-		VELOCITY_PRT(MSG_LEVEL_ERR, KERN_ERR
-			"%s: rx buf allocation failure\n", vptr->dev->name);
-	}
+	if ((works > 0) && (velocity_rx_refill(vptr) > 0))
+		velocity_give_many_rx_descs(vptr);
 
 	VAR_USED(stats);
 	return works;
@@ -1877,6 +1875,8 @@ static int velocity_open(struct net_devi
 	/* Ensure chip is running */
 	pci_set_power_state(vptr->pdev, PCI_D0);
 
+	velocity_give_many_rx_descs(vptr);
+
 	velocity_init_registers(vptr, VELOCITY_INIT_COLD);
 
 	ret = request_irq(vptr->pdev->irq, &velocity_intr, IRQF_SHARED,
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

via-velocity-remove-the-bounce-buffers.patch
via-velocity-lean-and-clean-velocity_init_rings.patch
via-velocity-move-residual-free-rx-descriptors-count-register-update.patch
via-velocity-add-velocity_set_rxbufsize-helper.patch
via-velocity-give-a-structure-to-the-rx-tx-fields.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch

