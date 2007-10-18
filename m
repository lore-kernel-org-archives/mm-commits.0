From: akpm@linux-foundation.org
Subject: - tokenring-3c359c-fixed-array-index-problem.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:32 -0700
Message-ID: <200710180705.l9I75WIv031655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760067AbXJRHP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: meissner@suse.de, jeff@garzik.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     tokenring/3c359.c: fixed array index problem
has been removed from the -mm tree.  Its filename was
     tokenring-3c359c-fixed-array-index-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+			writeb(xl_priv->xl_laa[i-10], xl_mmio + MMIO_MACDATA);
 		}
 		memcpy(dev->dev_addr,xl_priv->xl_laa,dev->addr_len) ; 
 	} else { /* Regular hardware address */ 
_

Patches currently in -mm which might be from meissner@suse.de are

origin.patch
