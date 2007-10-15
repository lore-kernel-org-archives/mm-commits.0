From: akpm@linux-foundation.org
Subject: + tokenring-3c359c-fixed-array-index-problem.patch added to -mm tree
Date: Mon, 15 Oct 2007 15:45:06 -0700
Message-ID: <200710152245.l9FMj6qe029165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbXJOWp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 18:45:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: meissner@suse.de, jeff@garzik.org, penberg@cs.helsinki.fi


The patch titled
     tokenring/3c359.c: fixed array index problem
has been added to the -mm tree.  Its filename is
     tokenring-3c359c-fixed-array-index-problem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tokenring/3c359.c: fixed array index problem
From: Marcus Meissner <meissner@suse.de>

The xl_laa array is just 6 bytes long, so we should substract 10 from the
index, like is also done some lines above already.

Signed-off-by: Marcus Meissner <meissner@suse.de>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/3c359.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/tokenring/3c359.c~tokenring-3c359c-fixed-array-index-problem drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~tokenring-3c359c-fixed-array-index-problem
+++ a/drivers/net/tokenring/3c359.c
@@ -760,7 +760,7 @@ static int xl_open_hw(struct net_device 
 	if (xl_priv->xl_laa[0]) {  /* If using a LAA address */
 		for (i=10;i<16;i++) { 
 			writel( (MEM_BYTE_WRITE | 0xD0000 | xl_priv->srb) + i, xl_mmio + MMIO_MAC_ACCESS_CMD) ; 
-			writeb(xl_priv->xl_laa[i],xl_mmio + MMIO_MACDATA) ; 
+			writeb(xl_priv->xl_laa[i-10],xl_mmio + MMIO_MACDATA) ;
 		}
 		memcpy(dev->dev_addr,xl_priv->xl_laa,dev->addr_len) ; 
 	} else { /* Regular hardware address */ 
_

Patches currently in -mm which might be from meissner@suse.de are

tokenring-3c359c-fixed-array-index-problem.patch
