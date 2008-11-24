From: akpm@linux-foundation.org
Subject: + tokenring-3c359c-fix-allocation-null-check.patch added to -mm tree
Date: Mon, 24 Nov 2008 15:45:19 -0800
Message-ID: <200811242345.mAONjJGo001721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYKXXpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 18:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirka@pirko.cz


The patch titled
     tokenring/3c359.c: fix allocation null check
has been added to the -mm tree.  Its filename is
     tokenring-3c359c-fix-allocation-null-check.patch

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

tokenring-3c359c-fix-allocation-null-check.patch
tokenring-3c359c-fix-error-message-when-allocating-tx_ring.patch
tokenring-3c359c-prevent-possible-mem-leak-when-open-failed.patch

