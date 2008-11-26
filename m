From: akpm@linux-foundation.org
Subject: - tokenring-3c359c-fix-allocation-null-check.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:46:12 -0800
Message-ID: <200811262046.mAQKkCje010687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbYKZU4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:56:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirka@pirko.cz, mm-commits@vger.kernel.org


The patch titled
     tokenring/3c359.c: fix allocation null check
has been removed from the -mm tree.  Its filename was
     tokenring-3c359c-fix-allocation-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tokenring/3c359.c: fix allocation null check
From: Jirka Pirko <jirka@pirko.cz>

Fixed type when allocating rx_ring, tx_ring was checked for null instead.

Signed-off-by: Jirka Pirko <jirka@pirko.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/3c359.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/tokenring/3c359.c~tokenring-3c359c-fix-allocation-null-check drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~tokenring-3c359c-fix-allocation-null-check
+++ a/drivers/net/tokenring/3c359.c
@@ -644,7 +644,7 @@ static int xl_open(struct net_device *de
 		return -ENOMEM;
 	}
 	xl_priv->xl_rx_ring = kzalloc((sizeof(struct xl_rx_desc) * XL_RX_RING_SIZE) +7, GFP_DMA | GFP_KERNEL);
-	if (xl_priv->xl_tx_ring == NULL) {
+	if (xl_priv->xl_rx_ring == NULL) {
 		printk(KERN_WARNING "%s: Not enough memory to allocate rx buffers.\n",
 				     dev->name);
 		free_irq(dev->irq,dev);
_

Patches currently in -mm which might be from jirka@pirko.cz are

linux-next.patch

