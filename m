From: akpm@linux-foundation.org
Subject: - tokenring-3c359c-fix-error-message-when-allocating-tx_ring.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:46:15 -0800
Message-ID: <200811262046.mAQKkFCh010691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbYKZUq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:46:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirka@pirko.cz, jirka@jirka.pirko.cz, mm-commits@vger.kernel.org


The patch titled
     tokenring/3c359.c: Fix error message when allocating tx_ring
has been removed from the -mm tree.  Its filename was
     tokenring-3c359c-fix-error-message-when-allocating-tx_ring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tokenring/3c359.c: Fix error message when allocating tx_ring
From: Jirka Pirko <jirka@pirko.cz>

Pointed out by Joe Perches. Error message after tx_ring allocation check was
wrong.

Signed-off-by: Jirka Pirko <jirka@jirka.pirko.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/3c359.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/tokenring/3c359.c~tokenring-3c359c-fix-error-message-when-allocating-tx_ring drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~tokenring-3c359c-fix-error-message-when-allocating-tx_ring
+++ a/drivers/net/tokenring/3c359.c
@@ -638,7 +638,7 @@ static int xl_open(struct net_device *de
 	/* These MUST be on 8 byte boundaries */
 	xl_priv->xl_tx_ring = kzalloc((sizeof(struct xl_tx_desc) * XL_TX_RING_SIZE) + 7, GFP_DMA | GFP_KERNEL);
 	if (xl_priv->xl_tx_ring == NULL) {
-		printk(KERN_WARNING "%s: Not enough memory to allocate rx buffers.\n",
+		printk(KERN_WARNING "%s: Not enough memory to allocate tx buffers.\n",
 				     dev->name);
 		free_irq(dev->irq,dev);
 		return -ENOMEM;
_

Patches currently in -mm which might be from jirka@pirko.cz are

linux-next.patch

