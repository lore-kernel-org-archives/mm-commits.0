From: akpm@linux-foundation.org
Subject: + via-velocity-lean-and-clean-velocity_init_rings.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:38:02 -0700
Message-ID: <200807111843.m6BIhhua030810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585AbYGKSnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com


The patch titled
     via-velocity: lean and clean velocity_init_rings
has been added to the -mm tree.  Its filename is
     via-velocity-lean-and-clean-velocity_init_rings.patch

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
Subject: via-velocity: lean and clean velocity_init_rings
From: Francois Romieu <romieu@fr.zoreil.com>

- PCI consistent areas need no memset
- use dev_err instead of plain printk
- avoid a few casts

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/via-velocity.c |   48 +++++++++++++++--------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff -puN drivers/net/via-velocity.c~via-velocity-lean-and-clean-velocity_init_rings drivers/net/via-velocity.c
--- a/drivers/net/via-velocity.c~via-velocity-lean-and-clean-velocity_init_rings
+++ a/drivers/net/via-velocity.c
@@ -1102,47 +1102,41 @@ static int __devinit velocity_get_pci_in
 
 static int velocity_init_rings(struct velocity_info *vptr)
 {
-	int i;
-	unsigned int psize;
+	struct velocity_opt *opt = &vptr->options;
+	const unsigned int rx_ring_size = opt->numrx * sizeof(struct rx_desc);
+	const unsigned int tx_ring_size = opt->numtx * sizeof(struct tx_desc);
+	struct pci_dev *pdev = vptr->pdev;
 	dma_addr_t pool_dma;
-	u8 *pool;
-
-	/*
-	 *	Allocate all RD/TD rings a single pool
-	 */
-
-	psize = vptr->options.numrx * sizeof(struct rx_desc) +
-		vptr->options.numtx * sizeof(struct tx_desc) * vptr->num_txq;
+	void *pool;
+	unsigned int i;
 
 	/*
+	 * Allocate all RD/TD rings a single pool.
+	 *
 	 * pci_alloc_consistent() fulfills the requirement for 64 bytes
 	 * alignment
 	 */
-	pool = pci_alloc_consistent(vptr->pdev, psize, &pool_dma);
-
-	if (pool == NULL) {
-		printk(KERN_ERR "%s : DMA memory allocation failed.\n",
-					vptr->dev->name);
+	pool = pci_alloc_consistent(pdev, tx_ring_size * vptr->num_txq +
+				    rx_ring_size, &pool_dma);
+	if (!pool) {
+		dev_err(&pdev->dev, "%s : DMA memory allocation failed.\n",
+			vptr->dev->name);
 		return -ENOMEM;
 	}
 
-	memset(pool, 0, psize);
-
-	vptr->rd_ring = (struct rx_desc *) pool;
-
+	vptr->rd_ring = pool;
 	vptr->rd_pool_dma = pool_dma;
 
-	i = vptr->options.numrx * sizeof(struct rx_desc);
-	pool += i;
-	pool_dma += i;
-	for (i = 0; i < vptr->num_txq; i++) {
-		int offset = vptr->options.numtx * sizeof(struct tx_desc);
+	pool += rx_ring_size;
+	pool_dma += rx_ring_size;
 
+	for (i = 0; i < vptr->num_txq; i++) {
+		vptr->td_rings[i] = pool;
 		vptr->td_pool_dma[i] = pool_dma;
-		vptr->td_rings[i] = (struct tx_desc *) pool;
-		pool += offset;
-		pool_dma += offset;
+		pool += tx_ring_size;
+		pool_dma += tx_ring_size;
 	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

via-velocity-remove-the-bounce-buffers.patch
via-velocity-lean-and-clean-velocity_init_rings.patch
via-velocity-move-residual-free-rx-descriptors-count-register-update.patch
via-velocity-add-velocity_set_rxbufsize-helper.patch
via-velocity-give-a-structure-to-the-rx-tx-fields.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch

